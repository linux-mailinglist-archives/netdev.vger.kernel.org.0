Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF4202663
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgFTUes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:34:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34356 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgFTUer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:34:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id v3so5453523wrc.1
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JoX96TjMxFtePdOvoscS5oX/j557ydr0WMD6M2n8EyI=;
        b=aOqf7F7T1r4iXLGyBD0ALh/CQoTmYNWnW7XrjWg88Cb0hbs7fU/jFIOsoJ5ejAX9fe
         CZcETuVEIcvy5HG88Cyjw62xztp4COXXmrrfkDN9lopInkmglI2Nj3eRDioGr5T05yCZ
         PkAqMkqQ4ZH7KlXubKLVodepr1VEu+peMlN6Z3iLv4TvAA5z1PcmguvHQnbx3BA9ZW8P
         p+Um4CAvy0Pb0GfHNqoNmBEu0St2xMHPmAy2IURzFwyobEKRDUB/FdUIJElP4gBK35Ki
         efbSK+E62k/4PZRw+JXp99gd/dqtagpyNvJRcfZ2rQvBkUHiPO54tD2CVi6bLi5qOXXt
         tYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JoX96TjMxFtePdOvoscS5oX/j557ydr0WMD6M2n8EyI=;
        b=gjKrjXnz+7vqFd0ryXJg9BjAxmULbKRvuvBQyPdB/x2tSK1YueiZTRxzziEjR4SYT+
         U3saJ5BuqY2Pm/aZ//ET41NUA1+7MgtyUbz+bIwdPZo4Ag3EywmBdm0Hj7KVAF4gvu72
         c5MfY5MlxSAeGtDhOXYx/yaBGMU/R1AgDzfPffAWry1qUuQ8IcqUcVhbwEXTL8o0C++g
         0Hl28wQPOTi4Q3viCGJO/wU2Z0gknGKyf6yDeeHq66m/KeSoFimzK0HgJIxuiaio5yZr
         ZxWxMKK8gLUiMRiMBc41W9DlVo9ZH05tqtIxqaNl5Ag2Xy7R+pIh+CpPHi0JgKAtrngH
         QNUQ==
X-Gm-Message-State: AOAM533jQY/u8HAMr2FfsTgNSiWd29XktfWCVeKOOIJA4ou2VRkwxryu
        /PkI++v5G8RG6Z/Tbut4Ohy8HGl9
X-Google-Smtp-Source: ABdhPJxjd6UCbn+VEE7TUjYMZlJY4i81r/oi3pNRPoRH869QpbIZePdmxO32tniIhGRfsVVRxKKTSg==
X-Received: by 2002:adf:c404:: with SMTP id v4mr10113986wrf.85.1592685225123;
        Sat, 20 Jun 2020 13:33:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id z12sm12746675wrg.9.2020.06.20.13.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:33:44 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/7] r8169: mark device as detached in PCI D3 and
 improve locking
Message-ID: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Date:   Sat, 20 Jun 2020 22:33:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark the netdevice as detached whenever parent is in PCI D3hot and not
accessible. This mainly applies to runtime-suspend state.
In addition take RTNL lock in suspend calls, this allows to remove
the driver-specific mutex and improve PM callbacks in general.

Heiner Kallweit (7):
  net: core: try to runtime-resume detached device in __dev_open
  r8169: mark device as not present when in PCI D3
  r8169: remove no longer needed checks for device being runtime-active
  r8169: add rtl8169_up
  r8169: use RTNL to protect critical sections
  r8169: remove driver-specific mutex
  r8169: improve rtl8169_runtime_resume

 drivers/net/ethernet/realtek/r8169_main.c | 181 +++++-----------------
 net/core/dev.c                            |  10 +-
 2 files changed, 49 insertions(+), 142 deletions(-)

-- 
2.27.0

