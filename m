Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4E2066F4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388815AbgFWWLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387840AbgFWWLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:11:12 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51599C061573;
        Tue, 23 Jun 2020 15:11:12 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id d27so149875qtg.4;
        Tue, 23 Jun 2020 15:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yz11ciyHBUyfQdsgqu8iMb/6aua6PZ+Q9S5NKvvlTbE=;
        b=O87y6dWV1bPYh1LE87O3QzQm66UbzFCYARgqz4cN6sph6Vg91tcBeNs+4gYKKSSYYR
         H/NrDtgVRafpykjTWfnNK1y8ZaeqdAvXeHl2v3dUPUWHv6HX0JAOWKZHOk9xvYdeU7cb
         ieuOr7x/flNBFqW3hGpbDphUPM1RQMHQ67kYxUSNhghEVqGyR6WMphmfa3GclfRDBVFe
         fwIqnuzlK0XWoLBWHd9i4G1PP94+HljznwWJvdVyzZA25rrZjzZULUvQRbZFhR4U6pz8
         BCY9PhjP7eNzFSosL+Y0m03Qzq+Sy1+OGAfn4jneoU7HtkONsI0wJPw7lqC4mRrayrkY
         Vd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yz11ciyHBUyfQdsgqu8iMb/6aua6PZ+Q9S5NKvvlTbE=;
        b=cRIZ9HR33yxPGNziGhhaAynFX4/jdh7BvM+KpF1zqQFl46yGFtV2nLTT4apk5r/k1D
         AD8srfWcsDar46rfxpRB+nUQIbhCDG+gKy6r78jTsN9pXNnfNS2yqAZ6dsXDOuk2AfVZ
         gOCAmYnI0SbXD+Gjxx7y2L/8NXg3MpH/uLbhm4IL3Of+bCzCO/qa3WWRNM6aXXMQ8xFp
         XP7xkZwT891rAbkgUeBj/PRIcSXDVXnev2R7vUE3nYxRKlJAOk991+hLHjrqSqSQzVCk
         45VK7ORXF3Myl8xYyDdfC0fzZPTB467pw/aMRWrIsSG1NZ366nzo/HiPkvXe/AWaEJLb
         Igng==
X-Gm-Message-State: AOAM531GUwybVYWrQrx1NSbigULJTmlNN7yVRFF+FtUygmr+e3Sw7BUZ
        ikkiIvps9P3Iw402ia2Zbo8=
X-Google-Smtp-Source: ABdhPJzXR2d0Y1jwkxVKARZz1HePUifurRj2yiAIpH9ks1hX2QFgQTL8nJ3mmI6wKmlJ08KCbN6FUg==
X-Received: by 2002:aed:33c5:: with SMTP id v63mr23901443qtd.104.1592950271349;
        Tue, 23 Jun 2020 15:11:11 -0700 (PDT)
Received: from buszk-y710.fios-router.home (pool-108-54-206-188.nycmny.fios.verizon.net. [108.54.206.188])
        by smtp.googlemail.com with ESMTPSA id b53sm1866464qtc.65.2020.06.23.15.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 15:11:10 -0700 (PDT)
From:   Zekun Shen <bruceshenzk@gmail.com>
Cc:     security@kernel.org, Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ath10k: fix OOB: __ath10k_htt_rx_ring_fill_n
Date:   Tue, 23 Jun 2020 18:11:05 -0400
Message-Id: <20200623221105.3486-1-bruceshenzk@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idx in __ath10k_htt_rx_ring_fill_n function lives in
consistent dma region writable by the device. Malfunctional
or malicious device could manipulate such idx to have a OOB
write. Either by
    htt->rx_ring.netbufs_ring[idx] = skb;
or by
    ath10k_htt_set_paddrs_ring(htt, paddr, idx);

The idx can also be negative as it's signed, giving a large
memory space to write to.

It's possibly exploitable by corruptting a legit pointer with
a skb pointer. And then fill skb with payload as rougue object.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
Part of the log here. Sometimes it appears as UAF when writing 
to a freed memory by chance.

 [   15.594376] BUG: unable to handle page fault for address: ffff887f5c1804f0
 [   15.595483] #PF: supervisor write access in kernel mode
 [   15.596250] #PF: error_code(0x0002) - not-present page
 [   15.597013] PGD 0 P4D 0
 [   15.597395] Oops: 0002 [#1] SMP KASAN PTI
 [   15.597967] CPU: 0 PID: 82 Comm: kworker/u2:2 Not tainted 5.6.0 #69
 [   15.598843] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
 BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 [   15.600438] Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
 [   15.601389] RIP: 0010:__ath10k_htt_rx_ring_fill_n 
 (linux/drivers/net/wireless/ath/ath10k/htt_rx.c:173) ath10k_core

 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d787cbead..4e411b33a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -142,6 +142,14 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 	BUILD_BUG_ON(HTT_RX_RING_FILL_LEVEL >= HTT_RX_RING_SIZE / 2);
 
 	idx = __le32_to_cpu(*htt->rx_ring.alloc_idx.vaddr);
+
+	if (idx < 0 || idx >= htt->rx_ring.size) {
+		ath10k_err(htt->ar, "idx OOB, firmware malfunctioning?\n");
+		idx &= htt->rx_ring.size_mask;
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	while (num > 0) {
 		skb = dev_alloc_skb(HTT_RX_BUF_SIZE + HTT_RX_DESC_ALIGN);
 		if (!skb) {
-- 
2.17.1

