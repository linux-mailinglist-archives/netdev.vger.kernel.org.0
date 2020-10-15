Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0202628F632
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389893AbgJOPvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389693AbgJOPve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:51:34 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E545EC0613D2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:33 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id cq12so3609874edb.2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o1HGVmUT/OhvqKkWrLamJKiOCE0cdQtudBTyS1tZm8I=;
        b=eIVCa9svoHxUjRC70zo4OwYhp32AE6RKwMIOps7ykTJTC59EFjxgj7M/zYDwO1smDe
         hfaGGR0iMaTIA2UaCCGAdFYm8EOsETPB3x3vTIvwM8y3EnZu/uJuQ59NviKaCCm1xcZy
         LYin9MEe080ve5nmUZ3mR5MFVUCJ+s7XxGSMC7ZXvIr2n2GzshclyMxTtFCCnikpmqJh
         uTB6Zq/rx4PHm4Sz4qiih0+WzGyTlnc7mtuFDrukIA+atSHYOmt7aMKNxe7f8nIY/QGC
         wjX1ie8CkSzsTlvHJwOb9EezEAFQ/qPOk2uJsSecIB1kUNtuxQLWIbE1mjdKqfGSs3vX
         1h7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o1HGVmUT/OhvqKkWrLamJKiOCE0cdQtudBTyS1tZm8I=;
        b=ncwx4CahZk7nt1Tr6s4R7akTDcvrseuMn/HSE0T/+EYZZ7RN5/VpextlAyYJpgWhts
         TjZvVQ2iL/grASg+NUfedxHNH3EhQc85gJQ0811exhgJFqf+n8DX4QjuFFLP65eLrzBF
         0vijqBHaaWgFulSsMzIcF0Rp0jmmgzzLhX7eAZouwxpD6ml/8xKw2XD1ChZkLMvl+OuK
         uAdxMA6TmebnFLsQUIHspFCqMrdaK0JxjR+YzyOeYZ/sy7Zf9i9ukHA+11XNxiyZmDMb
         mj6hqh9OjDqfLmcD+FysHQrNw12xHwtUw41jal/hKB2H2hWfEFVGleF2aGraUgsJ0jGm
         7Phw==
X-Gm-Message-State: AOAM5331NZ+PeTS/JaXG7rmjRv1aKeR4ychiv4wXjJjqv9JBq7pBtrZn
        LhcIpB1i/vf+RjhItI7R4devwshEynA=
X-Google-Smtp-Source: ABdhPJx3b2+j3m1NdTUNo5JM1dS04Uly6y9CIIdasSgDFCh/FtAWiY2wQ5yfS09nCp/+6TEMB/2L7Q==
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr5038499edb.358.1602777092396;
        Thu, 15 Oct 2020 08:51:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c92:1571:ee2d:f2ef? (p200300ea8f2328000c921571ee2df2ef.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c92:1571:ee2d:f2ef])
        by smtp.googlemail.com with ESMTPSA id r4sm1827936edv.16.2020.10.15.08.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 08:51:32 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: use struct pcpu_sw_netstats for rx/tx
 packet/byte counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Message-ID: <8d0804a1-16e5-2f76-9e7e-213cd093b520@gmail.com>
Date:   Thu, 15 Oct 2020 17:50:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
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
index 7d366b036..840543bc8 100644
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
2.28.0


