Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621E43251F2
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhBYPGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhBYPGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:06:12 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B00DC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:05:32 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d11so5559871wrj.7
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=G29xOixDCUbi2W1IyGiKYb3XGebYuSvfTx0J5uoOkcc=;
        b=h2zwcEn6n+rHsuJ5IussDcnPT/L0NLqhOozK46hYbHxvzDvyNWxMfYIDGtnalGQlq0
         TLYlstCxcc/rb3xcr41JEWk1C0gUf53si1fGOM3w7H301n0TxuhxDFIcgiRj3XJuZxKb
         qqpQHOOKYekHZe90GjrDhEvx27pOGF7l6UQESqh3krvwh86k9f5BYBctgb1W94eZRxPX
         nux5VToYPwTVKty2Jy3g8xRmEVxHkYPxuqwzy41DCwDZOqZFj7msPZn7bNF8Iu1Pbljf
         qDojAowSovu1/om3OxgKbarz/OPLXrIQYMCj1M1hV+4FFM7LdHOZV9EIkfY0kcq/lh14
         Iw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=G29xOixDCUbi2W1IyGiKYb3XGebYuSvfTx0J5uoOkcc=;
        b=TMyepOysO2/XXtJ5JFmL35mVHZeiAJ8PmQ1KdjYJwXdfbjms8qr2Z1UZGDvBK/R2NT
         TRxuDlYChbgparQwkdp0Kj8jbcpDkomf6sV+VvuWDKMN2g9PNA553BjpMfco3AZLrDt3
         LfsLEsKfL9uDVpvtgWIRgCtMEaBHNb/TBZn75npS7HYX8mO3UNL9c3d4fy15VoR+teQb
         fES/nzEUVxvx7ZNrQX90G3gm8UbYr/SQXEWkGlv5O2gAUz37AQ4uORH/Ia5MyEJHYlsd
         cPNT3oklx8dma3uOrGfGi+WQqqbtmDloWVt4jpq3nLpJcjR3Cbg8oPes5nk6KE5JdbyR
         Tnlw==
X-Gm-Message-State: AOAM533FMVo/JpHBBGIJGzJJ3tAE6upCAWOMLNExnc9yq1EGw9uZX264
        P1LtABJqMTUHS11pW3/g7/U=
X-Google-Smtp-Source: ABdhPJxBKb3LqSoIbZ1BymkWxLjvBxJIH4y14Xd2uOM/CNa6sA8wwmi3rv3sVMtxgwxi/X5P+tqOCQ==
X-Received: by 2002:adf:b652:: with SMTP id i18mr3905545wre.297.1614265531005;
        Thu, 25 Feb 2021 07:05:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:886:d78e:2ad2:a5bf? (p200300ea8f395b000886d78e2ad2a5bf.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:886:d78e:2ad2:a5bf])
        by smtp.googlemail.com with ESMTPSA id p9sm7975490wmg.10.2021.02.25.07.05.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 07:05:29 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        joskera@redhat.com
Subject: [PATCH net] r8169: fix jumbo packet handling on RTL8168e
Message-ID: <b15ddef7-0d50-4320-18f4-6a3f86fbfd3e@gmail.com>
Date:   Thu, 25 Feb 2021 16:05:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Josef reported [0] that using jumbo packets fails on RTL8168e.
Aligning the values for register MaxTxPacketSize with the
vendor driver fixes the problem.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=211827

Fixes: d58d46b5d851 ("r8169: jumbo fixes.")
Reported-by: Josef Oškera <joskera@redhat.com>
Tested-by: Josef Oškera <joskera@redhat.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e7a59dc5f..35b015c9a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2317,14 +2317,14 @@ static void r8168dp_hw_jumbo_disable(struct rtl8169_private *tp)
 
 static void r8168e_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	RTL_W8(tp, MaxTxPacketSize, 0x3f);
+	RTL_W8(tp, MaxTxPacketSize, 0x24);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | 0x01);
 }
 
 static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
 {
-	RTL_W8(tp, MaxTxPacketSize, 0x0c);
+	RTL_W8(tp, MaxTxPacketSize, 0x3f);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~0x01);
 }
-- 
2.30.1

