Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0F71630B6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgBRTz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:55:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43191 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:55:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so25424056wrq.10;
        Tue, 18 Feb 2020 11:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2XbnpJ3DCsRKiHe1DaCKVtnJE9/aeVVRESQe3D8Emz0=;
        b=vUohnzwHM6ww95pQT57+3W9rF4ypv0oi9Sr2c9p3s83ysEDCy4B8i7wA2YEjpx4o7O
         NcjBuJOYJT3TkV38cAxuxjb+GQg+/EGWFW7GqjNTqfN9IXB1ujD8cfSNj805Eqi9UL3J
         sVm9BCtuHEfxKEPYZxsEhZJn7fhEIQrGxl+bbVqNYURgddAdzTdXM+0zuWbYJmPrQY59
         wKP2rd4F6kVeZdGKvosiHVzXPskpRcN+Ld9zlmdZfT1pXW9Pmgt5x9Wmmq76Ugw2uFx1
         kRSPDlv37YJUGIgNKnCM8XV/FSdiTFZJzGUDuK+ZYgrIDM8RGYpeMxkNLm4rW2QysL8S
         aFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2XbnpJ3DCsRKiHe1DaCKVtnJE9/aeVVRESQe3D8Emz0=;
        b=G99VNtUeZnAbiQpqH+h+WNaENDsKM/BH/9xIe9NHnD0vTTShat8nl5vgNFzFoIx435
         6AYY6Ty3gU+tagblMyluJCiS/tGnROjp0kY/xMsHxQ0/umTw2qAXySp4p9uKJJvQn/oM
         g/loia1ZNRfhlzuZPx3Rhr4IFpwjKc04Apnyptu4o8Xv0O0EpEMWWtf6JBPgCVXuzgsQ
         NiDK0GaXO83SQWzRZuTiEyxtIH2BNXBGax4ZZOxWv1lt7jIssMNWPXwqMHldTF3I2CEm
         a8gQp+6HtA8w/NE306hSIx4iSTKQ+k8S4qNt9CEQgINwjpMO0F21l9Wp5ndjQzBZAMG9
         4oQQ==
X-Gm-Message-State: APjAAAXEnkIb9Lj2ZrXMmEc6i//VLL+ii3YKufknS+CJByYbAehP7s+c
        J66mFT8Nk0AcURHiUEHV1nCThg+dCRo=
X-Google-Smtp-Source: APXvYqxgH2Zy4SF7Ru6OgX1SQtM0GsOax0n4VqsktL36jANdSqE9ij6StXtgtan9ISXSA9S4DFix+Q==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr30082796wrq.51.1582055724084;
        Tue, 18 Feb 2020 11:55:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id t187sm4914865wmt.25.2020.02.18.11.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 11:55:23 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/13] net: core: add helper tcp_v6_gso_csum_prep
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Message-ID: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Date:   Tue, 18 Feb 2020 20:55:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several network drivers for chips that support TSO6 share the same code
for preparing the TCP header, so let's factor it out to a helper.
A difference is that some drivers reset the payload_len whilst others
don't do this. This value is overwritten by TSO anyway, therefore
the new helper resets it in general.

Heiner Kallweit (13):
  net: core: add helper tcp_v6_gso_csum_prep
  r8169: use new helper tcp_v6_gso_csum_prep
  net: atheros: use new helper tcp_v6_gso_csum_prep
  bna: use new helper tcp_v6_gso_csum_prep
  enic: use new helper tcp_v6_gso_csum_prep
  e1000(e): use new helper tcp_v6_gso_csum_prep
  jme: use new helper tcp_v6_gso_csum_prep
  ionic: use new helper tcp_v6_gso_csum_prep
  net: qcom/emac: use new helper tcp_v6_gso_csum_prep
  net: socionext: use new helper tcp_v6_gso_csum_prep
  hv_netvsc: use new helper tcp_v6_gso_csum_prep
  r8152: use new helper tcp_v6_gso_csum_prep
  vmxnet3: use new helper tcp_v6_gso_csum_prep

 drivers/net/ethernet/atheros/alx/main.c       |  5 +---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 ++---
 drivers/net/ethernet/brocade/bna/bnad.c       |  7 +----
 drivers/net/ethernet/cisco/enic/enic_main.c   |  3 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  6 +----
 drivers/net/ethernet/intel/e1000e/netdev.c    |  5 +---
 drivers/net/ethernet/jme.c                    |  7 +----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  5 +---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  7 ++---
 drivers/net/ethernet/realtek/r8169_main.c     | 26 ++-----------------
 drivers/net/ethernet/socionext/netsec.c       |  6 +----
 drivers/net/hyperv/netvsc_drv.c               |  5 +---
 drivers/net/usb/r8152.c                       | 26 ++-----------------
 drivers/net/vmxnet3/vmxnet3_drv.c             |  5 +---
 include/net/ip6_checksum.h                    |  9 +++++++
 15 files changed, 27 insertions(+), 101 deletions(-)

-- 
2.25.1

