Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC0322EBC
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhBWQaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:30:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:36540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhBWQaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:30:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614097765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1fcBBVi2VQJZ1nf/JdbxVgiBTyHyQF9V+0dM+Pib8sw=;
        b=AIsb4Pg1kS6LzyrZ1kIU6GCBQu5bS5bkoOedIG3Nw+T9eBFfq99Ao4VwWMueQmuco2vIjY
        Ic3soYYBWVMq3BTbOblmODIv+41R+gt4ZwjNpzlcBwXmp+D2rTGKlpOAF3SBvncPRo5TlM
        gdvQxneUDFJeKhdpBdnIo3AHxIoYMyc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6070ACBF;
        Tue, 23 Feb 2021 16:29:24 +0000 (UTC)
To:     Wei Liu <wl@xen.org>, Paul Durrant <paul@xen.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
Subject: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
Message-ID: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
Date:   Tue, 23 Feb 2021 17:29:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
special considerations for the head of the SKB no longer apply. Don't
mistakenly report ERROR to the frontend for the first entry in the list,
even if - from all I can tell - this shouldn't matter much as the overall
transmit will need to be considered failed anyway.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -499,7 +499,7 @@ check_frags:
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else
