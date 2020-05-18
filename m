Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E7E1D8991
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgERUr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERUr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:47:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCC6C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:47:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i15so13365206wrx.10
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=beeXCGptPmKn2Nygr+LiJ1uYVWzBmB3Qex3xH0IUBaM=;
        b=lIzNscjASFFD0oobpLCJPO8Xit3z83vTDTv+kmblLqgdnpS0GU6KOSTZ4cKjcgt8RJ
         qja6ISf5NM+ZlI5sI7qbGCKRzjiPXSyaHfhIzDwsss5E/oy74MOLtZnljjoybaPWjEmN
         M1zy2hxAPWWCjs3FqDVSS+txNaCv2CiCMctfbkRr+wRQCU/XKsbpFR/gZA8TIDRmnxYv
         LmiI1l7skU24Qs88beCDpKLsJEizeE/VRfucjNWgQEPxsCHa49UBaautXL33/QJUiU5d
         4eHZktRp1i0635Ss+ZT4sHOuCLKANEtitMXUU9BqS8Wvw1zmFKIPRqzaNsMdz1jmrjK2
         im9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=beeXCGptPmKn2Nygr+LiJ1uYVWzBmB3Qex3xH0IUBaM=;
        b=o4JmidCdtqEAUqlE+H3jOu0kriE1UKdQeoAr1yKEVpNYq1eT5k0tjUVIR+WY1PY6cN
         UxOIaUiQwX97TupAwKpy5beG08lKiDT++z6LZYG2Wy+CuFyLbCo9Li+jNsSkZsCXUrq0
         lABJ8bCdeyYfJ3Xdv06VFaHa27IUbr/UbwDlb4rUWMnGClaHmNYmjBiBmChrfitEckiO
         234maBnlVEkCxDA1n861oGuL/RLklB7HWRx0E9GLHk+f6J6mkf+Lp7iXZnH+Wnj4kM1e
         owrYfxRGguJUlnUixLHQfYJbaFWP1wzE3WGyfefnfN+mpsPLoUTdXxL6HlIYCVT4fnJH
         tbsg==
X-Gm-Message-State: AOAM531wqddUdKDnF5FvFdFMpxYax0GoFmMlfaKJjQd/APjtoQLYwxxc
        9cZC/IkFAiVzjf//7DjZIwDdXavE
X-Google-Smtp-Source: ABdhPJyqtHQG1bx4W0VtA0kkty5fvpu5tijirWwHDlKQRhwVwZoJL60DjRcKB6HTtbH4CTVU2TGQPA==
X-Received: by 2002:adf:ce05:: with SMTP id p5mr17388322wrn.423.1589834845824;
        Mon, 18 May 2020 13:47:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:9de0:f30c:fd06:315c? (p200300ea8f2852009de0f30cfd06315c.dip0.t-ipconnect.de. [2003:ea:8f28:5200:9de0:f30c:fd06:315c])
        by smtp.googlemail.com with ESMTPSA id q144sm1017804wme.0.2020.05.18.13.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 13:47:25 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] r8169: work around an irq coalescing related tx
 timeout
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <a979ac70-de91-aa66-f401-e61d31d04183@gmail.com>
Date:   Mon, 18 May 2020 22:47:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [0] a user reported reproducible tx timeouts on RTL8168f except
PktCntrDisable is set and irq coalescing is enabled.
Realtek told me that they are not aware of any related hw issue on
this chip version, therefore root cause is still unknown. It's not
clear whether the issue affects one or more chip versions in general,
or whether issue is specific to reporter's system.
Due to this level of uncertainty, and due to the fact that I'm aware
of this one report only, let's apply the workaround on net-next only.
After this change setting irq coalescing via ethtool can reliably
avoid the issue on the affected system.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=207205

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
- remove orphaned Reported-by from commit message
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 23f150092..79817d4ff 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1871,6 +1871,15 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 
 	RTL_W16(tp, IntrMitigate, w);
 
+	/* Meaning of PktCntrDisable bit changed from RTL8168e-vl */
+	if (rtl_is_8168evl_up(tp)) {
+		if (!rx_fr && !tx_fr)
+			/* disable packet counter */
+			tp->cp_cmd |= PktCntrDisable;
+		else
+			tp->cp_cmd &= ~PktCntrDisable;
+	}
+
 	tp->cp_cmd = (tp->cp_cmd & ~INTT_MASK) | cp01;
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 	rtl_pci_commit(tp);
-- 
2.26.2

