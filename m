Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D09A12E334
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 08:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgABG7u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 01:59:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33503 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgABG7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 01:59:49 -0500
Received: from mail-pg1-f200.google.com ([209.85.215.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1imuSR-0000rD-99
        for netdev@vger.kernel.org; Thu, 02 Jan 2020 06:59:47 +0000
Received: by mail-pg1-f200.google.com with SMTP id t189so27229555pgd.1
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 22:59:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=+4ASNLI8hemylDXAQ26bv8KzwuXrMFomc4dsXqfBlnQ=;
        b=n1Nv/q2++76ypLWWVdJnDUqWjt6/0GBN36LL/OBShLfsuzRiVubdMC3vRTKC14zdYH
         fxBQmNmlSg957PknqLP7y+hvoof358/R0nncCwKltovreFX6R/BxzF7aCQj8E2qmpgOk
         3sjc3U5Rh1UkNxHk9f7JMRqJbWHJI8hScIrvpCrfDXaYte5FUW033BEVg32DpjEPoCxh
         J7fDCxVwZ/TP/fzCnjuGkVzvnniTbjE8RcgU6DlRQTYJ+5NTXbrNSTnIPRvzQMKwZh8x
         WXJs6LN+Uc/YoyJW0VtITBM8Cj/bxX0QC9Ao0U6mfshuXV/cz8LtTaZX9Gasx4s/R4uw
         RaHw==
X-Gm-Message-State: APjAAAXDhlR7Sl7STkLUvXNiyv8d0CxMexzVpDRdS32unELSP4jLgEWc
        905+GV0CmnNfYtS5peOOTzxWIHdrSprVTHiV1XDdJrGzi1vr+fRcih0qvsI5PE7INLY/zJy5QKA
        cGZAGlLw4tM5k3THB3WSSGTAHmQ7wUGTrzg==
X-Received: by 2002:a63:4b24:: with SMTP id y36mr87026093pga.176.1577948385894;
        Wed, 01 Jan 2020 22:59:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4u7csTaenM6SHfp5W1eAmF77TctrCSAsskp7RkLMW0KhIV5dmXnThBwvIiiJsX1YvyWbuUA==
X-Received: by 2002:a63:4b24:: with SMTP id y36mr87026049pga.176.1577948385382;
        Wed, 01 Jan 2020 22:59:45 -0800 (PST)
Received: from [10.101.46.91] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id o7sm64953508pfg.138.2020.01.01.22.59.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jan 2020 22:59:44 -0800 (PST)
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: SFP+ support for 8168fp/8117
Message-Id: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
Date:   Thu, 2 Jan 2020 14:59:42 +0800
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

There's an 8168fp/8117 chip has SFP+ port instead of RJ45, the phy device ID matches "Generic FE-GE Realtek PHY" nevertheless.
The problems is that, since it uses SFP+, both BMCR and BMSR read are always zero, so Realtek phylib never knows if the link is up.

However, the old method to read through MMIO correctly shows the link is up:
static unsigned int rtl8169_xmii_link_ok(struct rtl8169_private *tp)
{
       return RTL_R8(tp, PHYstatus) & LinkStatus;
}

Few ideas here:
- Add a link state callback for phylib like phylink's phylink_fixed_state_cb(). However there's no guarantee that other parts of this chip works.
- Add SFP+ support for this chip. However the phy device matches to "Generic FE-GE Realtek PHY" which may complicate things.

Any advice will be welcome.

Kai-Heng
