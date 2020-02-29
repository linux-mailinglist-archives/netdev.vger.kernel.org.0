Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABEA174997
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgB2WTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:19:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37135 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgB2WTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:19:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id a141so7171295wme.2;
        Sat, 29 Feb 2020 14:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Rq6vkQgTaOQDotxYomeOOqqSCicKb0gWij/0lXcfMPs=;
        b=CgJE8xO/dLhkcoI8oDJycGzTipj/BjsRi8gPl7dxzATB+E11EFGNPqwjARxZDBWPAX
         16X1rDAZ9yb/Z6NFnor2DsJL00bxBBrGN7rkUeAIPCFRm+o1S+0vOVECfv8GW2VZUIZm
         sEyWeNrlkocUdU8TF9Wjvjg9sHHxgGGhhWxtH5eIbUeHN19k7BIrPIFhqPU9wvD986P3
         fk5MM0AwaTqi7PjI/JO8EW7cZ5B2CwZRiixWKWCB4TnXarse20/5Io2MWR8+zkrRMEBT
         HCav4h+AdvfB/UywRqHQiJHKyRzntakvLfAc22Sst+kYvS9tBRplDOFHsvRFEZF7ywoN
         uaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Rq6vkQgTaOQDotxYomeOOqqSCicKb0gWij/0lXcfMPs=;
        b=gGnHu4APny8GVRkCvhxh8TZwDdgfNc9BfycINpnTh18h6aSicmhU3MWNwdcwZkdcZx
         chGGD/2dbYaaFQa+nZjsHZ/4dGFHtXu0IJugEKkiG9C1DbfoKwFBEZJGgjRf8Pn1b+S2
         89kJGYk8KdhpRHeGxqD2AsV61LSG0yvN7pFplF/yinJ6Xygc8RYbLFY8jKr/3t8jWT/p
         q0xMMTmlsnOxYZOKkFBdw2mdJvoMCHFPQs/SDuW6cbTPi39W+b+rDNVAPMeuJ/xyG57m
         3SlF6H0lVVlLDBbACt2OJ/epQDVPSX/YBKzlX834b1Hwks0o9WiYodNEMAFfQcCvKB4t
         x0lw==
X-Gm-Message-State: APjAAAUzKLSwDU2B+svkPXD57Zw7/cOAyWH2+hI0GOUYdGitF0RMM2/+
        tC1Mz3OMwM6LJ5EIv0tPZ6o=
X-Google-Smtp-Source: APXvYqw67IGoTwJ8NzM3XM89iPMypR15cLOYPYs07JIUP1A0ezQRFsrvQbuM+HTJimit4msBKUXa4w==
X-Received: by 2002:a1c:9a88:: with SMTP id c130mr10592334wme.73.1583014759103;
        Sat, 29 Feb 2020 14:19:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id v2sm18217864wme.2.2020.02.29.14.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:19:18 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v4 00/10] PCI: Add and use constant PCI_STATUS_ERROR_BITS and
 helper pci_status_get_and_clear_errors
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Message-ID: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Date:   Sat, 29 Feb 2020 23:19:13 +0100
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

Several drivers have own definitions for this constant, so move it
to the PCI core. In addition in multiple places the following code
sequence is used:
1. Read PCI_STATUS
2. Mask out non-error bits
3. Action based on set error bits
4. Write back set error bits to clear them

As this is a repeated pattern, add a helper to the PCI core.

Most affected drivers are network drivers. But as it's about core
PCI functionality, I suppose the series should go through the PCI
tree.

v2:
- fix formal issue with cover letter
v3:
- fix dumb typo in patch 7
v4:
- add patches 1-3
- move new constant PCI_STATUS_ERROR_BITS to include/linux/pci.h
- small improvements in commit messages

Heiner Kallweit (10):
  net: marvell: add PCI_STATUS_SIG_TARGET_ABORT to PCI status error bits
  net: skfp: add PCI_STATUS_REC_TARGET_ABORT to PCI status error bits
  r8169: add PCI_STATUS_PARITY to PCI status error bits
  PCI: Add constant PCI_STATUS_ERROR_BITS
  PCI: Add pci_status_get_and_clear_errors
  r8169: use pci_status_get_and_clear_errors
  net: sun: use pci_status_get_and_clear_errors
  net: skfp: use new constant PCI_STATUS_ERROR_BITS
  PCI: pci-bridge-emul: Use new constant PCI_STATUS_ERROR_BITS
  sound: bt87x: use pci_status_get_and_clear_errors

 drivers/net/ethernet/marvell/skge.h       |  6 -----
 drivers/net/ethernet/marvell/sky2.h       |  6 -----
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++++-------
 drivers/net/ethernet/sun/cassini.c        | 28 ++++++++-------------
 drivers/net/ethernet/sun/sungem.c         | 30 +++++++----------------
 drivers/net/fddi/skfp/drvfbi.c            |  4 +--
 drivers/net/fddi/skfp/h/skfbi.h           |  5 ----
 drivers/pci/pci-bridge-emul.c             | 14 ++---------
 drivers/pci/pci.c                         | 23 +++++++++++++++++
 include/linux/pci.h                       |  8 ++++++
 sound/pci/bt87x.c                         |  7 +-----
 11 files changed, 61 insertions(+), 85 deletions(-)

-- 
2.25.1

