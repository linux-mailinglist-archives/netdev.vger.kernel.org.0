Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE721D898B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgERUp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:45:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE1CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:45:23 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l18so13413753wrn.6
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8tQVZuzXcUs+grpq2NyJCZI1fALCQNi3u0qDtm6nonE=;
        b=ESVwtY/uiLxOIZWlh8XYvGSx9ljatbVcWo4gaD1xO/HiQIgpGgeNOsH9trzJDpLkN4
         TGPNpVJGoAxaPS2xV/Ry8x+vJ3rqsxfl28r/xtITW2xD5cFxJ/sUjauCfD/xfi7gQH4E
         9n8Y0nG1L0o+1HHBW1bB2bYCCcCrjsSx0cEwW4jnx65/xevdVtNP18xgCD3gtjcelAsh
         UvBaN5v2pm2PkwXxedQFZY22jp5i8g64c22W8OgljDGnPyFeZrV0vzLidhbQ5n+dpWFy
         rach5usKE15wm9o31fwS+/s2WJGAgsjyp81EIHFKVHNgbMxORJxUoGm/6Ozdjp2YN5Si
         Mk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8tQVZuzXcUs+grpq2NyJCZI1fALCQNi3u0qDtm6nonE=;
        b=n0AgWUHdeSETjMHhtb7UE15YxVIV4LTA1+5RTwTVxfTuYVICnaTu1dHRV59hoT5bVJ
         FecSAg+k1ExB4ai7Zg3gE2SrnVSAgGiKxkiQi2gV8Q8KFUD2cia0oNxl8iyolM98gyAl
         9AfTJ1pU8NZePEd5hWSjljVBAUHBlrexNlSrYuch+G5f5i9Z1++6jC8+7Y7lTt4qzkrC
         fk1DxuDyEJE6VBg5kSQA2QPh0/1jjMeNIhWidjuK50XSa/P4LM4LznXJsYIcpwcdt3qJ
         3qLk/vxIL1P1YplkhK/wWoNRsX9pwwDluNRMC2EO++CqnRuuhhwonX4JkS1KDPUAOJKy
         bWmg==
X-Gm-Message-State: AOAM5302XnWWwUxlkwexFlwxxTj5gA59+uqpFtWZAGvd2EXq1wlxHY57
        MKnOhfk9Cm9tt6aSG03cSm2UhU9j
X-Google-Smtp-Source: ABdhPJygbV4dzJQrqJnRVnmdYLPUofAPoljFDORiPMBTuQOzcswsV9+8JiN43AocK5ZUM/6kwBgvwQ==
X-Received: by 2002:a5d:6584:: with SMTP id q4mr22784341wru.12.1589834721555;
        Mon, 18 May 2020 13:45:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:9de0:f30c:fd06:315c? (p200300ea8f2852009de0f30cfd06315c.dip0.t-ipconnect.de. [2003:ea:8f28:5200:9de0:f30c:fd06:315c])
        by smtp.googlemail.com with ESMTPSA id 61sm5434085wrp.92.2020.05.18.13.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 13:45:21 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: work around an irq coalescing related tx
 timeout
Message-ID: <14cfcad9-7298-f183-295e-63e13858b863@gmail.com>
Date:   Mon, 18 May 2020 22:45:10 +0200
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

Reported-by: 
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
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

