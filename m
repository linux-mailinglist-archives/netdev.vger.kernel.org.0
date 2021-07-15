Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C8B3CAFD0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhGPACF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhGPACD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 20:02:03 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5472C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 16:59:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id u14so8196858pga.11
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 16:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L6GVt5cETggeBfBi99l90X+lzuNAEVO+JAb0wuByBJo=;
        b=q96z51cezNhSeq2/zCYLOYKiY8uAgW6jdhOv+WnuRE/2L31unPh1N7ojc4OJQBVGvH
         eBrKqg8cuzS9HtIxUpTesUoUZDmuVxuDXLLD+2bvrjRsHjfTcVN1GfiBNFqWV2MVafaT
         405VFRQckzhxi/pitecigtVmND4pBlBHC/PHxpGU5u7kk09n435Po96mu576yoks+tYo
         6i8trGanGfi2b7+AUgZL7MScz676a9Ji28BF8ggk1HR76xmtOGYglwken7+VSaFiwnlQ
         OtNGBw/M7uI548fNM+llT2P2ImiTKth0NWbi6jiQ/wBRzSGml4btKS35v5QdJgom8uTr
         Qd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L6GVt5cETggeBfBi99l90X+lzuNAEVO+JAb0wuByBJo=;
        b=YjEigTfZaiowA8Ug2AkB60+nSFD7URhghqdCI29ha0DSkRM3+QtVc6gGNvlL8hJYlV
         5CxvpeeK/1EwGtOnK1D/P5Zqp24sJBQnDO6g+gJ8dv+6aBqvk1v+49eGFTQwjE5ldFA+
         WVer2uohDtvJaRjUagMaw7Jpm4JdeCJ96e19rcVavg9CLLkhZPF8dSHVMyOxTFaxg1XK
         dM1aUgbTVyltHAlfiNcz1KAgSriR32amNlEdMe8+EpyrgTn2c9qJmssNHlvmpVuiZWJE
         2o7PTAniLSENC6jibU5A9MkaBWf2kjN2BhIsjCDH220CX5KINpcnHDsC1rZvwUvjQ9PF
         lS7w==
X-Gm-Message-State: AOAM532oivIVXVcNzlRo8JOva2hPC1l81huuvlWHaBUuy9ipILz4XDfE
        QjuFZiqxNEjWkfKHu3xzF7oKK2fEX5YNUU1N
X-Google-Smtp-Source: ABdhPJzl6p5DXQKSSojEG4JQbzw+R12bDJAyznKIOmsG8z1P+4ffFx7ggC0XhwKUeuIBO/L4omVFpQ==
X-Received: by 2002:a63:5442:: with SMTP id e2mr7046284pgm.365.1626393548154;
        Thu, 15 Jul 2021 16:59:08 -0700 (PDT)
Received: from localhost.localdomain (c-73-92-226-101.hsd1.ca.comcast.net. [73.92.226.101])
        by smtp.gmail.com with ESMTPSA id g123sm7493774pfb.187.2021.07.15.16.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 16:59:07 -0700 (PDT)
From:   Pravin B Shelar <pravin.ovn@gmail.com>
To:     netdev@vger.kernel.org
Cc:     pbshelar@fb.com, Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH] net: Fix zero-copy head len calculation.
Date:   Thu, 15 Jul 2021 16:59:00 -0700
Message-Id: <20210715235900.1715962-1-pravin.ovn@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pravin B Shelar <pshelar@ovn.org>

In some cases skb head could be locked and entire header
data is pulled from skb. When skb_zerocopy() called in such cases,
following BUG is triggered. This patch fixes it by copying entire
skb in such cases.
This could be optimized incase this is performance bottleneck.

---8<---
kernel BUG at net/core/skbuff.c:2961!
invalid opcode: 0000 [#1] SMP PTI
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G           OE     5.4.0-77-generic #86-Ubuntu
Hardware name: OpenStack Foundation OpenStack Nova, BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:skb_zerocopy+0x37a/0x3a0
RSP: 0018:ffffbcc70013ca38 EFLAGS: 00010246
Call Trace:
 <IRQ>
 queue_userspace_packet+0x2af/0x5e0 [openvswitch]
 ovs_dp_upcall+0x3d/0x60 [openvswitch]
 ovs_dp_process_packet+0x125/0x150 [openvswitch]
 ovs_vport_receive+0x77/0xd0 [openvswitch]
 netdev_port_receive+0x87/0x130 [openvswitch]
 netdev_frame_hook+0x4b/0x60 [openvswitch]
 __netif_receive_skb_core+0x2b4/0xc90
 __netif_receive_skb_one_core+0x3f/0xa0
 __netif_receive_skb+0x18/0x60
 process_backlog+0xa9/0x160
 net_rx_action+0x142/0x390
 __do_softirq+0xe1/0x2d6
 irq_exit+0xae/0xb0
 do_IRQ+0x5a/0xf0
 common_interrupt+0xf/0xf

Code that triggered BUG:
int
skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
{
        int i, j = 0;
        int plen = 0; /* length of skb->head fragment */
        int ret;
        struct page *page;
        unsigned int offset;

        BUG_ON(!from->head_frag && !hlen);

Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
---
 net/core/skbuff.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f63de967ac25..eaa264984535 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3011,8 +3011,11 @@ skb_zerocopy_headlen(const struct sk_buff *from)
 
 	if (!from->head_frag ||
 	    skb_headlen(from) < L1_CACHE_BYTES ||
-	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS)
+	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS) {
 		hlen = skb_headlen(from);
+		if (!hlen)
+			hlen = from->len;
+	}
 
 	if (skb_has_frag_list(from))
 		hlen = from->len;
-- 
2.25.1

