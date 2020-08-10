Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADAC240F4C
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgHJTVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbgHJTNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:13:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 591C6207FF;
        Mon, 10 Aug 2020 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086810;
        bh=eKLmI6yIRznVo57G102CPPtPPxx8TC3m3pHQ/L+bVTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxiFglNUSFw9lENgauAN5u2osL/3U1dFnMjXmf5/SYwUXGfVcUQfCB0Jc0o9UTtYd
         adc2xgV4Oc8fKe9xALKMgr98C3MnelEUf+TE5aedpGAtOHh+aNtIDsmVJcVZiLGVyM
         MpQ2Y7gpO6WX820cXNCEMWpK1rd2laTqQywh0s/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/31] brcmfmac: set state of hanger slot to FREE when flushing PSQ
Date:   Mon, 10 Aug 2020 15:12:49 -0400
Message-Id: <20200810191259.3794858-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191259.3794858-1-sashal@kernel.org>
References: <20200810191259.3794858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit fcdd7a875def793c38d7369633af3eba6c7cf089 ]

When USB or SDIO device got abnormal bus disconnection, host driver
tried to clean up the skbs in PSQ and TXQ (The skb's pointer in hanger
slot linked to PSQ and TSQ), so we should set the state of skb hanger slot
to BRCMF_FWS_HANGER_ITEM_STATE_FREE before freeing skb.
In brcmf_fws_bus_txq_cleanup it already sets
BRCMF_FWS_HANGER_ITEM_STATE_FREE before freeing skb, therefore we add the
same thing in brcmf_fws_psq_flush to avoid following warning message.

   [ 1580.012880] ------------   [ cut here ]------------
   [ 1580.017550] WARNING: CPU: 3 PID: 3065 at
drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c:49
brcmu_pkt_buf_free_skb+0x21/0x30 [brcmutil]
   [ 1580.184017] Call Trace:
   [ 1580.186514]  brcmf_fws_cleanup+0x14e/0x190 [brcmfmac]
   [ 1580.191594]  brcmf_fws_del_interface+0x70/0x90 [brcmfmac]
   [ 1580.197029]  brcmf_proto_bcdc_del_if+0xe/0x10 [brcmfmac]
   [ 1580.202418]  brcmf_remove_interface+0x69/0x190 [brcmfmac]
   [ 1580.207888]  brcmf_detach+0x90/0xe0 [brcmfmac]
   [ 1580.212385]  brcmf_usb_disconnect+0x76/0xb0 [brcmfmac]
   [ 1580.217557]  usb_unbind_interface+0x72/0x260
   [ 1580.221857]  device_release_driver_internal+0x141/0x200
   [ 1580.227152]  device_release_driver+0x12/0x20
   [ 1580.231460]  bus_remove_device+0xfd/0x170
   [ 1580.235504]  device_del+0x1d9/0x300
   [ 1580.239041]  usb_disable_device+0x9e/0x270
   [ 1580.243160]  usb_disconnect+0x94/0x270
   [ 1580.246980]  hub_event+0x76d/0x13b0
   [ 1580.250499]  process_one_work+0x144/0x360
   [ 1580.254564]  worker_thread+0x4d/0x3c0
   [ 1580.258247]  kthread+0x109/0x140
   [ 1580.261515]  ? rescuer_thread+0x340/0x340
   [ 1580.265543]  ? kthread_park+0x60/0x60
   [ 1580.269237]  ? SyS_exit_group+0x14/0x20
   [ 1580.273118]  ret_from_fork+0x25/0x30
   [ 1580.300446] ------------   [ cut here ]------------

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200624091608.25154-2-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 1de8497d92b8a..dc7c970257d2f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -653,6 +653,7 @@ static inline int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 				int ifidx)
 {
+	struct brcmf_fws_hanger_item *hi;
 	bool (*matchfn)(struct sk_buff *, void *) = NULL;
 	struct sk_buff *skb;
 	int prec;
@@ -664,6 +665,9 @@ static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		while (skb) {
 			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
+			hi = &fws->hanger.items[hslot];
+			WARN_ON(skb != hi->pkt);
+			hi->state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
 			brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
 						true);
 			brcmu_pkt_buf_free_skb(skb);
-- 
2.25.1

