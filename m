Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05F2136105
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgAITYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:24:35 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41633 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgAITYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:24:35 -0500
Received: by mail-wr1-f44.google.com with SMTP id c9so8625872wrw.8
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xukODnIrqO7EDXlvBF0WBhT/8pRl7lRQhkCIHpVntl8=;
        b=ZN6R64a8bFiSQVRdEwCxTRRCnkePmKz3v1e3GoQuv8MFJnJHKf48flOXF3Ljwn1ugA
         mYVSpVVbNs8XJTIPvFVcw+8+L9qwH3K+xOySCeTQqKyZ1pYGPJJ8woCR6g+O4HTQ/DX9
         W+7k7A7ZLrcK/FDwyd1ICN9aCFAWGmR19rCK4LUMgKOqlVQcLl5jBpDgKK5i4wsJ5Ap0
         lAvHD+6JtsjtPupINGU8DMNK1IsrwmVPLGqDvIol4bU+kVyPFxbOebKIfnUk+l9TEW9s
         ORMHxw9T9LLpPF20hKsoCif//toNlaFaZraa8HLn9fR+aTr0KhXgAdhvg584wKkmER3M
         6O9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xukODnIrqO7EDXlvBF0WBhT/8pRl7lRQhkCIHpVntl8=;
        b=Bp4GOOPrsRUjvTO+9n2X2jT69EyoJTGBx62R/ZDenzTw6ryXs3V1TPtoEAUG8ybcre
         S06LNsqcCqF40CTW/HM+ERXr2Qpc9qaJy/zvtN6nHsnCMc4P20PnnECTexJ+kzUwbfop
         nLn6YjKSbVQM38+gzLE0qtT/2hKKg6D+bsbpeFx8UYMZOSWZWAa3PgDElauRChLOmmXb
         MoD92cwJZTnZjhjzuraVOOAz/EPecXepFLAAjOy1OoW7CbR3GZ3NOiBOBZmw1iUFAnVy
         TjQUgbP9j5uUvyYi5X+0gnlPpeH9Vy3q4VhwT1Mg5xA8u+0401lGRCwJqS0rnRQvoeiZ
         o/Lg==
X-Gm-Message-State: APjAAAVicTb5I8SnytRVg8WhSIVkVhgrRgAvpSq9+bGUa0sTeeQTUrNs
        eU4UbUG+2kLWphuZLDGvk3zi8jEs
X-Google-Smtp-Source: APXvYqzQ1jWuKL4GRbkPtg/hIBLaTI3J3lrAtMZ369pzP38ObgkB0h0lBb+rE6KkO3N8UNy6Q7bNWw==
X-Received: by 2002:a5d:458d:: with SMTP id p13mr13052752wrq.314.1578597873131;
        Thu, 09 Jan 2020 11:24:33 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id l7sm9235474wrq.61.2020.01.09.11.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:24:32 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 00/15] r8169: factor out chip-specific PHY
 configuration to a separate source file
Message-ID: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Date:   Thu, 9 Jan 2020 20:24:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically every chip version needs its own PHY configuration.
To improve maintainability of the driver move all these PHY
configurations to a separate source file. To allow this we first have
to change all PHY configurations to use phylib functions wherever
possible.

Heiner Kallweit (15):
  r8169: prepare for exporting rtl_hw_phy_config
  r8169: remove not needed debug print in rtl8169_init_phy
  r8169: move RTL8169scd Gigabyte PHY quirk
  r8169: change argument type of EEE PHY functions
  r8169: change argument type of RTL8168g-specific PHY config functions
  r8169: switch to phylib functions in rtl_writephy_batch
  r8169: move setting ERI register 0x1d0 for RTL8106
  r8169: move disabling MAC EEE for RTL8402/RTL8106e
  r8169: replace rtl_patchphy
  r8169: replace rtl_w0w1_phy
  r8169: use phy_read/write instead of rtl_readphy/writephy
  r8169: add phydev argument to rtl8168d_apply_firmware_cond
  r8169: rename rtl_apply_firmware
  r8169: add r8169.h
  r8169: factor out PHY configuration to r8169_phy_config.c

 drivers/net/ethernet/realtek/Makefile         |    2 +-
 drivers/net/ethernet/realtek/r8169.h          |   78 +
 drivers/net/ethernet/realtek/r8169_main.c     | 1410 +----------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 1307 +++++++++++++++
 4 files changed, 1410 insertions(+), 1387 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169.h
 create mode 100644 drivers/net/ethernet/realtek/r8169_phy_config.c

-- 
2.24.1

