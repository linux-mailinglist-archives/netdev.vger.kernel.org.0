Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2426AA0B7E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfH1U3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41372 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfH1U33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so1090934wrr.8
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B9KRSV3Ie7zDC6ctyCzWFy91B1UvsfnDrO3NodMbSCw=;
        b=bAT8PR9ljIpd5hN6rrZWdSunAU1IoEJ27rZh5hvRMS23UWO1LBXRSRcibX2dyWoYh+
         6hOjksFjb1PfRX7UqpKYo1t04LWJkLjwuEIdPbbhAocAz5hqLGuJHr3OPO3jv0Itlp3a
         YW6b2mLdqLfijODnYmdqWSoNWyBfQrVvAy6aUWUpFzDwiZuX1AejiBWUQ7HnJ5D/XK6Z
         weUHK5fje4p0y5kMXXY2zSH8+R88gzp6kBfA6xNiKK1xFGausQuatIpre3FBvv+k2J2b
         2RdHfLb3XGTeZ2DkcMdXdLvvV2NyZdPqsnrZ2SBFVadMkafH607CTGn45K5N/D7RkCtv
         5B3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B9KRSV3Ie7zDC6ctyCzWFy91B1UvsfnDrO3NodMbSCw=;
        b=nATUHlEc4Vcnzpi7MNXr2EE5zLg2kguTLQumJBuSu5PgrMaE3g431TbI6Wo+0r/Q1U
         A73JVelpt5NDbbdD8jJbtnb+4oRb6nZRRbXo6uBkW1cyTxG0dXpvqXY1/C5tmJRSy1Yd
         lfmqQf40FGU9YM6Ue6C/jK0IHtGvgk189DUNOCspjkmzd0p51jF1hvT2TS9nBeRneqoc
         yi9Qbi6KDBn3JdJK4x2i80xdpug/oJfULS/OyRAlyzmN3zQPib1EuD0bHgnDbjehuJ2Y
         SDkT51HYRJ63bjalnfDrJ3blciuDSYS4WLKndIKJHnHy5RXqJIs2pULKqQKLfiYPINr8
         Ul+Q==
X-Gm-Message-State: APjAAAWo/iUxYG6uST0jNokl5k6uYNF6RBBZv28S7KmyjOVic9fP3fQA
        VH56HSaQCa4E5xYKESMP6pw=
X-Google-Smtp-Source: APXvYqyqlWt0g0muh8vHFGGSUDAub8LucVoCegKrqCm3s3o0cZELVy1k0ffE7OWeN9QE5yuYit5X/Q==
X-Received: by 2002:adf:c594:: with SMTP id m20mr7423574wrg.126.1567024168588;
        Wed, 28 Aug 2019 13:29:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id y3sm4052649wmg.2.2019.08.28.13.29.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:28 -0700 (PDT)
Subject: [PATCH net-next v2 5/9] r8169: read common register for PCI commit
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <c6a0948a-feca-ebb5-9119-7412da8c42a4@gmail.com>
Date:   Wed, 28 Aug 2019 22:26:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8125 uses a different register number for IntrMask.
To net have side effects by reading a random register let's
use a register that is the same on all supported chip families.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dc799528f..652bacf62 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5135,7 +5135,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_lock_config_regs(tp);
 
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
-	RTL_R8(tp, IntrMask);
+	RTL_R16(tp, CPlusCmd);
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_init_rxcfg(tp);
 	rtl_set_tx_config_registers(tp);
-- 
2.23.0


