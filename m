Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02122ADF3
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgGWLnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgGWLnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:08 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEBDA208E4;
        Thu, 23 Jul 2020 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504588;
        bh=bEqWNVHLaaPCKQTgLqQQH5kpGpp2VD7M69JOxRx3qmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNuypVMH9aB9N9DTka1kG2fiv/h/Wbahbfe2b3hTfaOJZBS+tU8GB85qwioKcAArZ
         rR/6UqzgsfC4/0S+OtJo5r613eYch48dvNBjy8hcOfGtS4M/uUpcX7QgaEJ45fkzhs
         sIHUKveQJKVQ5+Fy1jE0t9rI2wWFktfA+vZYDsqg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 02/22] xdp: initialize xdp_buff mb bit to 0 in netif_receive_generic_xdp
Date:   Thu, 23 Jul 2020 13:42:14 +0200
Message-Id: <0c3c29b8d87259cd54bb7b1ec5892f71d12d62bb.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in xdp_buff data structure.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 316349f6cea5..eb3e54df198c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4641,6 +4641,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
 	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp->mb = 0;
 
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
-- 
2.26.2

