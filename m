Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDFD325290
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhBYPkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:40:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:38182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhBYPjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 10:39:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614267541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NFd034RDEJYXcq9r3tELC5CypWrYDcd0d0knOZGlyxM=;
        b=XgbQ5MYSf2y5OQAreaPj8wbV/1arB81ci6OiZNQSw0iecmcn9PeJAz3pxsL+lARSo7YFil
        FFLJYih+iUjnSrwCloncsniCXHAee0dIo8SgjzscYwdffwufiCiPBmbI5y8vuQWuYLhWUl
        +WdMBDaNIfKT8sciziRQSdpj+YQekDk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 20A1BB10B;
        Thu, 25 Feb 2021 15:39:01 +0000 (UTC)
From:   Jan Beulich <jbeulich@suse.com>
Subject: [PATCH] xen-netback: use local var in xenvif_tx_check_gop() instead
 of re-calculating
To:     Wei Liu <wl@xen.org>, Paul Durrant <paul@xen.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <6604dec2-4460-3339-f797-e5f8a7df848f@suse.com>
Date:   Thu, 25 Feb 2021 16:39:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

shinfo already holds the result of skb_shinfo(skb) at this point - no
need to re-invoke the construct even twice.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -557,8 +557,8 @@ check_frags:
 	}
 
 	if (skb_has_frag_list(skb) && !first_shinfo) {
-		first_shinfo = skb_shinfo(skb);
-		shinfo = skb_shinfo(skb_shinfo(skb)->frag_list);
+		first_shinfo = shinfo;
+		shinfo = skb_shinfo(shinfo->frag_list);
 		nr_frags = shinfo->nr_frags;
 
 		goto check_frags;
