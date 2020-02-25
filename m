Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6445616BA41
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgBYHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:07:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35201 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729131AbgBYHH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:07:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so13347971wrt.2;
        Mon, 24 Feb 2020 23:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SrZGU1G41mv2qo7iIZNTk8CjAnB4XhhlNzKIGNifM0Q=;
        b=jk50YlopcwFVRMPmcDUM4T5pppnv57UfoUrrPKa/JFtcjo0yOqHtm2QZrZGRPH5sp8
         MxL2mrGSG78JYZwEWVFPPvBTDRKnGlydyla7Gyi+Z4RIbTByvXOpkO2SLaxut4YAj8oq
         B6nh7qgqH+FLCINiDppYKzLugPogIu81SvQGqqCSNZ+Bo9ILa4Q9GhMTiEYv2XAQ53IT
         jRYulYvfmsLkFL1NZmsDXu5rW53n5f6Vmnjb8kgoF5QUiSuVp36Dxejpb1Bbp5RNLww5
         TEwo/v+SooIj5PNHEA6v3PLD6+AwujIF2UaO3405spRFSL4kOJD0N21LZ9pdCeo+zEHF
         HYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SrZGU1G41mv2qo7iIZNTk8CjAnB4XhhlNzKIGNifM0Q=;
        b=ZiixYLksIdfznPNS5eeEMgVBPvqE9DhMaeBUySc5XlcKYFnj8kGLLYrtmSo0675rxK
         9V/f1OZmdlLGzuQrTVJ+jeXro98jbxst/uYv8w58QO1DsnBS4rCHrrRz+JCfU8dInuEK
         W4XLRIB5Ef85cHMLfIg1u2tvU6D2EfBdU+R+ZsKrDJ5qnRnXd5TJjv6wu0hSUq0py/AO
         I9xE5wEhkaPkquGUbrpJzNIgTLY/XzQ8XFTD/GqScC9Mz5AjraJNE/dHkybzwiASfIOW
         a6tlL0fm4kICYEiW9nMknL6Efuyi7wvogAkpiss+u/gEo5bhkMj47KPn2bxQ+v6BrZt6
         rbsA==
X-Gm-Message-State: APjAAAXTqQKmWjkyYEGTeNkqvd3XpHRQ/KBukWiVZzFwkSxv/VDYYw1+
        Ho3Joy3NC2M2JLjpz1U6NDI=
X-Google-Smtp-Source: APXvYqysD1p70Ezv+KN17DCQ5At5jsTA6LK4mGbct2w3ALF7Jx1cPZVxtyDnNXicOuATMH89iy1bCA==
X-Received: by 2002:a5d:4b03:: with SMTP id v3mr74472281wrq.178.1582614447704;
        Mon, 24 Feb 2020 23:07:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id f11sm2878410wml.3.2020.02.24.23.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:07:27 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 0/8] PCI: add and use constant PCI_STATUS_ERROR_BITS and
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
Message-ID: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Date:   Tue, 25 Feb 2020 08:07:21 +0100
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

Few drivers have own definitions for this constant, so move it to the
PCI core. In addition there are several places where the following
code sequence is used:
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

Heiner Kallweit (8):
  PCI: add constant PCI_STATUS_ERROR_BITS
  PCI: add pci_status_get_and_clear_errors
  r8169: use pci_status_get_and_clear_errors
  net: cassini: use pci_status_get_and_clear_errors
  net: sungem: use pci_status_get_and_clear_errors
  net: skfp: use PCI_STATUS_ERROR_BITS
  PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
  sound: bt87x: use pci_status_get_and_clear_errors

 drivers/net/ethernet/marvell/skge.h       |  6 -----
 drivers/net/ethernet/marvell/sky2.h       |  6 -----
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++++-------
 drivers/net/ethernet/sun/cassini.c        | 28 ++++++++-------------
 drivers/net/ethernet/sun/sungem.c         | 30 +++++++----------------
 drivers/net/fddi/skfp/drvfbi.c            |  2 +-
 drivers/net/fddi/skfp/h/skfbi.h           |  5 ----
 drivers/pci/pci-bridge-emul.c             | 14 ++---------
 drivers/pci/pci.c                         | 23 +++++++++++++++++
 include/linux/pci.h                       |  1 +
 include/uapi/linux/pci_regs.h             |  7 ++++++
 sound/pci/bt87x.c                         |  7 +-----
 12 files changed, 60 insertions(+), 84 deletions(-)

-- 
2.25.1



