Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A583DCB34
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhHAKfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhHAKfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:35:45 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0851C0613CF
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 03:35:36 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so9217120wmd.3
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dHAd82eCxBAlZH/ALtBmD0F4kOPt+agVTIs7izZWjYA=;
        b=GzTid2KNWYrz4NDF7bs8gAHLd4YVP2tLjMWpcUIPf5wfXJhOpsqcioU7RMrVhARfrJ
         JFUxrBI5zXLfLwfkW6KpmVmt+tMNxP/5wizPdhajETuj6IkXHzwE1mrrADIUAolGPy5G
         KJZyov/sGrrCjmmut5naxnjoUTBgLPiaRHcJN4I0ouDZoROKoZNzUgfxXqdyp7BCc4Vs
         7WvUlp0g1zRuYMpVpLj1RgexkouTUaWNGaH3ygzJ409rlj3CgU1nCnyLyiws8hMBCHeC
         ovRQFiDci40UwjA8elsXVWKgWOxzBoiPEtxAzTbGCXvKoZ2ElLZG2pU4lypgPqEK+NNL
         9bDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dHAd82eCxBAlZH/ALtBmD0F4kOPt+agVTIs7izZWjYA=;
        b=F7YoBBhjsE6WUTuwdXP9jbXnUOisBEE0cHlCXWaqqQb0eYWo+9U1RrN6/VEbn2IxWz
         juEOf6SMLp7Ni8dyCPb1NpLOe8yL1+Ioa73/CuobVhCPdoJTT8fERjWDlIsjhSZgK0A8
         D99EiEkr29pEcxnC0X3o9IF6BnuiAaDOq1sIdu5eW5MMZkDptWbCDQPDcBpTFRMDpo/4
         VSD5JjpkKEGVM5PntaclZsQK9xzes2D/1+kyfIV9/honaU9M2FaANa2Mqpdt4J38PLnk
         dvtF19ATMOX9GzvjoQPUhBZ5bLHmYxauy2iIXmhY/Ft+Z8VfTfuUzvUWLLGeSgYDI6u1
         hHlg==
X-Gm-Message-State: AOAM531FbML63O7T4Vc3vGuCRwkNVy45dP+w7uS1qF2AkCaMdfK4k3Gp
        hcPAYnYhjsBMs+O0YR0klCaGIvQmQhLIEQ==
X-Google-Smtp-Source: ABdhPJwqsczf4/Rj0cxLpZoWkfvNSBAZYS9w+hUO38r+cwA7jUt8Ww2Vo/8K1nvvQlpLBx3QaUF8+w==
X-Received: by 2002:a05:600c:5117:: with SMTP id o23mr11942335wms.85.1627814135373;
        Sun, 01 Aug 2021 03:35:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id z17sm7791298wrt.47.2021.08.01.03.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 03:35:35 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent before
 ethtool ops
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Date:   Sun, 1 Aug 2021 12:35:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a network device is runtime-suspended then:
- network device may be flagged as detached and all ethtool ops (even if
  not accessing the device) will fail because netif_device_present()
  returns false
- ethtool ops may fail because device is not accessible (e.g. because being
  in D3 in case of a PCI device)

It may not be desirable that userspace can't use even simple ethtool ops
that not access the device if interface or link is down. To be more friendly
to userspace let's ensure that device is runtime-resumed when executing
ethtool ops in kernel.

This patch series covers the typical case that the netdev parent is power-
managed, e.g. a PCI device. Not sure whether cases exist where the netdev
itself is power-managed. If yes then we may need an extension for this.
But the series as-is at least shouldn't cause problems in that case.

Heiner Kallweit (4):
  ethtool: runtime-resume netdev parent before ethtool ioctl ops
  ethtool: move implementation of ethnl_ops_begin/complete to netlink.c
  ethtool: move netif_device_present check from
    ethnl_parse_header_dev_get to ethnl_ops_begin
  ethtool: runtime-resume netdev parent in ethnl_ops_begin

 net/ethtool/ioctl.c   | 18 ++++++++++++++---
 net/ethtool/netlink.c | 45 +++++++++++++++++++++++++++++++++++++------
 net/ethtool/netlink.h | 15 ++-------------
 3 files changed, 56 insertions(+), 22 deletions(-)

-- 
2.32.0

