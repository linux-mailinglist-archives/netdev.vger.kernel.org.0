Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71300788F6
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbfG2J5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 05:57:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35776 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfG2J5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 05:57:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id s1so21684113pgr.2;
        Mon, 29 Jul 2019 02:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Boz4CFC7012LYcZRn2NFsg+lEMbJ7x6Jzm6H/OkCj4M=;
        b=dzGYBm0i5+xbYycnw/1P98m/Td+tn/kioZg5kvlCjnyffm/s3cgtxd6l04UXIlHlIN
         9XpNVvasz+CC9R78FO7NTLk7WzOoasUv4MjyK30Tz9DKeNZbgaMhLdysWq3HtPWTT8Yf
         RdvUS5IWFAClnWpmgZ5a9WsJb1rsCOEljo49QU6ohcUybVAKkRFfwnYoMl2yWepxpb2d
         AmC2ZFLbCTZ3jV3hNMtnNNTEeC5e5ZUzNyA7l+/1Kx58bXz2b1udx/xYnf85KHAiKkD0
         Mcva4oP7F9qhKnqPKjYINYDY4Ydm2M+H8gxWJ9dok2A9VgWzP+MSzO3ROvatG8++HCKl
         CgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Boz4CFC7012LYcZRn2NFsg+lEMbJ7x6Jzm6H/OkCj4M=;
        b=Xw3BgAYOskQ/cPTQ3+LJs4gmF7oSJegUvJB0VOMnwR74DzdAj+BoK/dSbmp7KLJDpR
         wTVwV4oxlBwm21WYBbWrA2TmLZVfCp6rdBxAz7H12KdmdDYQ389XAmAOfkmCY1yHtcPf
         ZcHzuAY7/ZLbYYCv9em1WiSU5GsoNBQMSl6UJI6IWfH6OqhYm1rSD4/VQWyYvbnTqFI1
         F/pec5QGsCUk6xfHIjz8pyoiRVP5D3/052/bFkMD9e16LPLG2C0tno0loKdXKW2fW8hC
         abFlYtuFFr1B9nnjONcbz7C4jzTAZVgqqWW72g+zmQ8YILvopNVdFMmLNBdYxnjbFGZZ
         x0iA==
X-Gm-Message-State: APjAAAXLzerbd8WbztYouMgyEqGuHtL0cMMROnc2mltAtTQ6w35AiOVJ
        sKuxv+p6ytOgjPnCAgTW7TA=
X-Google-Smtp-Source: APXvYqwRNYtT5fZyrSqbg3o+wefLyl/tc7EQg1xRieNdSVRqsO0sKu97NGcWbbw/Fj3NWcBmqMOBQg==
X-Received: by 2002:aa7:8193:: with SMTP id g19mr34737721pfi.16.1564394220850;
        Mon, 29 Jul 2019 02:57:00 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id s7sm52910913pjn.28.2019.07.29.02.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 02:57:00 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        pieter-paul.giesberts@broadcom.com, plaes@plaes.org,
        rvarsha016@gmail.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] brcm80211: Avoid possible null-pointer dereferences in wlc_phy_radio_init_2056()
Date:   Mon, 29 Jul 2019 17:56:52 +0800
Message-Id: <20190729095652.1976-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In wlc_phy_radio_init_2056(), regs_SYN_2056_ptr, regs_TX_2056_ptr and
regs_RX_2056_ptr may be not assigned, and thus they are still NULL.
Then, they are used on lines 20042-20050:
    wlc_phy_init_radio_regs(pi, regs_SYN_2056_ptr, (u16) RADIO_2056_SYN);
	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX0);
	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX1);
	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX0);
	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX1);

Thus, possible null-pointer dereferences may occur.

To avoid these bugs, when these variables are not assigned,
wlc_phy_radio_init_2056() directly returns.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 07f61d6155ea..0c57d48f47b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -20035,7 +20035,7 @@ static void wlc_phy_radio_init_2056(struct brcms_phy *pi)
 			break;
 
 		default:
-			break;
+			return;
 		}
 	}
 
-- 
2.17.0

