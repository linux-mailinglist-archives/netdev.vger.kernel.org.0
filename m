Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A782729F358
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgJ2RfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJ2RfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:35:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8210C0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y12so3689696wrp.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QvmtyFxr6vKdR7cSSnv7I9JoLTrn08Vr5xGDcRwZ4b8=;
        b=g3K+Fy5IpGTTFu93hn7NkceYYsMQv6FoqrWj/eiLyW+kGu841TlZ3LyE8KsVepLKLX
         FlbRJFMbN6GAaTqYafrqVMYVF5XEFeTN1X/0ZkbvcT7HEdGjoMG8LXgFJIuWDj2cDa7M
         IrAgiLvx/no/HshJoARZ7pxzhkDLSrh4CerQeQKAtDZD7CNGj3HbqKzeKjtHkVv+DbYn
         o0lTVgbKvyV0rPN8J1wPvn6TNi8ehFTJc52eTxTr3ORMAPRuw9VkvxnKsZPNrDJ9t+TH
         /AWa0qm96Msy6bAEMHcsiQkHiWtGYRl63h88iOnF96XHjlx6BDzG9PFSg1DfMYKJ3Diu
         bX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QvmtyFxr6vKdR7cSSnv7I9JoLTrn08Vr5xGDcRwZ4b8=;
        b=q4aVhFZBkgu57fF1kJApkfi5XWOlLfwjJEzbp2Xuc48CmKQMjPPmPOcBxa9Z6WuKP3
         v//ulwhiNlNhxnvSy9ZAbbe0iWFHeFXJjSefr8Mtk5CBfdcekzes4EIO8akTgnT2w7Wl
         DZgP/TjlFgEBDCNHN7dN8Ub38JSIv4S+55XDJkvbFWzUkUDQEElnh3LZWGjjRMEI//br
         scTJq0oBMKBjsea3VY/rEZf9pVXJYCTWDUgdDa8zmMQLeJeJE7ynfLi0uMlcGDygdu6I
         xVPRLO2TCTDVcg14ZJf3cb0W7kEdaoSDAqbau0eFChxnSNs7oeL7MApxl7DTCp4KdcJd
         8jLg==
X-Gm-Message-State: AOAM532VPzxIDSovgvtDULPmM6lsBcM4r+sXXH1q/A1Lkxp8mV5Pwp/U
        R5JA+pOiS3Fl9v0Bt2AUIvjW4r6mS+c=
X-Google-Smtp-Source: ABdhPJwbIUbk2WKzLuP0poImKDJap6463N6LVIW2OXjFX5ptsLjHKl7zr5nnC2xX+5rxgb2CbOHdew==
X-Received: by 2002:adf:fe84:: with SMTP id l4mr6951022wrr.293.1603992908368;
        Thu, 29 Oct 2020 10:35:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id q12sm6394086wrx.13.2020.10.29.10.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:35:07 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: use struct pcpu_sw_netstats for rx/tx
 packet/byte counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Message-ID: <36e182ec-8fe2-2e39-9830-fe86096bc8ef@gmail.com>
Date:   Thu, 29 Oct 2020 18:33:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to the net core rx/tx byte/packet counter infrastructure.
This simplifies the code, only small drawback is some memory overhead
because we use just one queue, but allocate the counters per cpu.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 00f13805c..0ef30ad8a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4417,6 +4417,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 	if (tp->dirty_tx != dirty_tx) {
 		netdev_completed_queue(dev, pkts_compl, bytes_compl);
 
+		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
 		rtl_inc_priv_stats(&tp->tx_stats, pkts_compl, bytes_compl);
 
 		tp->dirty_tx = dirty_tx;
@@ -4539,6 +4540,7 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 
 		napi_gro_receive(&tp->napi, skb);
 
+		dev_sw_netstats_rx_add(dev, pkt_size);
 		rtl_inc_priv_stats(&tp->rx_stats, 1, pkt_size);
 release_descriptor:
 		rtl8169_mark_to_asic(desc);
@@ -4790,9 +4792,7 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	pm_runtime_get_noresume(&pdev->dev);
 
 	netdev_stats_to_stats64(stats, &dev->stats);
-
-	rtl_get_priv_stats(&tp->rx_stats, &stats->rx_packets, &stats->rx_bytes);
-	rtl_get_priv_stats(&tp->tx_stats, &stats->tx_packets, &stats->tx_bytes);
+	dev_fetch_sw_netstats(stats, dev->tstats);
 
 	/*
 	 * Fetch additional counter values missing in stats collected by driver
@@ -5263,6 +5263,11 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
+	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
+						   struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
+
 	/* Get the *optional* external "ether_clk" used on some boards */
 	rc = rtl_get_ether_clk(tp);
 	if (rc)
-- 
2.29.1


