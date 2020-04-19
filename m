Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71F1AFD26
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgDSSQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDSSQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:16:39 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0603C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:16:38 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h2so8402084wmb.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=agQxSnV3uf+VTUq+2pXVGSO4KIcp8OMEWHxBYus81bM=;
        b=T9ratNl3NT9r1L7rmv/O6+CkO6BucVRv+uRQ3qs+JVVKeycy+nRum4x56L+bTA5Z9J
         O9jta65NlxakxOKi7RdKI0a2KSRx9i88vPL0tkIFTrY1AR+ep1ySA1UYeSARw+Dw5QuU
         Rb9IbC817UD2vggVdvNtB4062dwWaWhZwwDs8jXvgvPICR2dHEgzjYCJCm64a3/QJ5xV
         YslnL+eDvSX3Hn8NXcoLNinLWgJranmZeasKrSI8HSgKAgWh4sVQX9lxMAbeFix8xzci
         pb7BdMSvCeuzhteTu7RswuiBKoFCu7UVIZIyb6iZaI/tbGMaAR3S+8Uq92seU0J+pr12
         hLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=agQxSnV3uf+VTUq+2pXVGSO4KIcp8OMEWHxBYus81bM=;
        b=K2cZaJ/BHdnVQnhbYVtzolUnIrqAmnRmHqp8g6m4n2FvTUc4LTtwaPYZ++90gt21vR
         F8jt4o7ClHge8GKDZdn67W5+Me1cE0nkcWUl/B2fPhZS15N1v/Fs4/wmBFy/593Nw3OD
         wZDgIXgmjVu83WCDxKIp12IV/h59nXP2nY7fyefVY0Nk+j9MxdOSAfLKktkW/jxeswFa
         zu8ZdLNQiKFRn170yxjzIjnQR66FVnPTp+aNBpcMXTfDDAvrMjhGaK4Y3EpEWYkwB/Yj
         P5vnQM0hqbW04EmuUQYmwWlDH73NBzussd9k2VgjU40UeGK43cDLBSYunKcZHMaAYMmb
         gKqQ==
X-Gm-Message-State: AGi0PuZf5Q9dlbj1uraSKVPTUJAP8Y1d2gKqEwlQD4GcMDQdVHjH80eJ
        cwf5wzgG4U4EpT08hhTMqfUQBZzS
X-Google-Smtp-Source: APiQypLc9cevN8MgpO3YHzOln3jVyVBmjzXJHq/s/Hq8NWEZeKUQbi1K/+v7+dYM6zExklWD0fLCVw==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr14362674wma.78.1587320197060;
        Sun, 19 Apr 2020 11:16:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id w11sm16204004wmi.32.2020.04.19.11.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 11:16:36 -0700 (PDT)
Subject: [PATCH net-next v2 2/3] r8169: replace dma_rmb with READ_ONCE in
 rtl_rx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Message-ID: <70576d8a-1bb3-c692-6dbd-2304c233e592@gmail.com>
Date:   Sun, 19 Apr 2020 20:15:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to ensure that desc->opts1 is read before desc->opts2.
This doesn't require a full compiler barrier. READ_ONCE provides
the ordering guarantee we need.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dd6113fd7..2fc65aca3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1548,7 +1548,7 @@ static inline u32 rtl8169_tx_vlan_tag(struct sk_buff *skb)
 
 static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 {
-	u32 opts2 = le32_to_cpu(desc->opts2);
+	u32 opts2 = le32_to_cpu(READ_ONCE(desc->opts2));
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), swab16(opts2 & 0xffff));
@@ -4490,16 +4490,11 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 		struct RxDesc *desc = tp->RxDescArray + entry;
 		u32 status;
 
-		status = le32_to_cpu(desc->opts1);
+		/* Use READ_ONCE to order descriptor field reads */
+		status = le32_to_cpu(READ_ONCE(desc->opts1));
 		if (status & DescOwn)
 			break;
 
-		/* This barrier is needed to keep us from reading
-		 * any other fields out of the Rx descriptor until
-		 * we know the status of DescOwn
-		 */
-		dma_rmb();
-
 		if (unlikely(status & RxRES)) {
 			netif_info(tp, rx_err, dev, "Rx ERROR. status = %08x\n",
 				   status);
-- 
2.26.1


