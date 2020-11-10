Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558E22AE00B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731711AbgKJTqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJTqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:46:40 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141B3C0613D1;
        Tue, 10 Nov 2020 11:46:40 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id za3so19345930ejb.5;
        Tue, 10 Nov 2020 11:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=94xWn4igC2rRAAMu2z0THiSQOP5rKPvk0MjxLB0+gEY=;
        b=iVYffJCCKWKLf191Owwu9ps45oJ7w9Nsd3V1GMUP0v9PMSJuKYCZC08k1fdQhTpfBx
         ecNx1Vb53dVKtcylVvR26kuqYWfkLW244MXcqcKV6+yOHOBZKL3zJoBUyLShZqfrigN4
         cV/3xMGsh2Wwno0jGtRaEIQolja5WheurLRzzTn856lrrBkuiYnVQCbeLrMQobxfzaHd
         LrRvN/KJJsjW1D8ruoxpYri6L3wb4YFqT0ohJnvjXhlaRTv45TujBISx3sb6VI+tEFK/
         cOEsfBW4bxqsFs6qMuHult0tFx8EAu6JUuroRdZB+gUzYTEBNKKqRXhTecSJmMcy3INT
         WUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=94xWn4igC2rRAAMu2z0THiSQOP5rKPvk0MjxLB0+gEY=;
        b=G1nTqed18XMGU/eKDlJ5M13INbTFXZB7nMtEtdNpM+6v6BoJEBaBKvbxt26W1LDIFQ
         ToXrbv4fXTM8fudV3yhhkiaPQksSo4sb37QMQBeniwKwaqhsMJ7Yh1ySVY2RGYFbCMBD
         bLRa5+NmfUMCzNQ6eoHZMiyrfUZ/maMTadAj90TtllvJA2NfuEgm8T22X6jizcEUu9d0
         3+ZcNi+O4QDGaOMv0StQY82GgJQI8AYtnr6aqi9eHr/09M/VYDm4XZIe/w7LMfp7JxWn
         8wcWnmgNuIUj8gp3FOKhIJN5r54UinIt2fYBKgb48idcxlcYK7O/ZBw+2zCJ/32ieqJz
         YscQ==
X-Gm-Message-State: AOAM532vHLq2I9eUEUOJ4I8eBZOnYNIihUO4QCPu8Bpgs6pvRPpeJrhp
        O7ELBotVZxRNdBcHE0mH6eFq06fR5nZyXg==
X-Google-Smtp-Source: ABdhPJyyiDTRA9Xdiopj0gYPnrIo3pXG4hJzhgyBoCLnKnknMPKS8uj57zFbZ3FbPjWaHnal/xUDFQ==
X-Received: by 2002:a17:906:268c:: with SMTP id t12mr20832985ejc.377.1605037598523;
        Tue, 10 Nov 2020 11:46:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:895e:e59d:3602:de4b? (p200300ea8f232800895ee59d3602de4b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:895e:e59d:3602:de4b])
        by smtp.googlemail.com with ESMTPSA id n22sm11419876edr.11.2020.11.10.11.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 11:46:38 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/5] net: switch further drivers to core
 functionality for handling per-cpu byte/packet counters
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Date:   Tue, 10 Nov 2020 20:46:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch further drivers to core functionality for handling per-cpu
byte/packet counters.
All changes are compile-tested only.

Heiner Kallweit (5):
  IB/hfi1: switch to core handling of rx/tx byte/packet counters
  qmi_wwan: switch to core handling of rx/tx byte/packet counters
  qtnfmac: switch to core handling of rx/tx byte/packet counters
  usbnet: switch to core handling of rx/tx byte/packet counters
  net: usb: switch to dev_get_tstats64 and remove usbnet_get_stats64
    alias

 drivers/infiniband/hw/hfi1/driver.c           |  4 +-
 drivers/infiniband/hw/hfi1/ipoib.h            | 27 -------
 drivers/infiniband/hw/hfi1/ipoib_main.c       | 15 +---
 drivers/infiniband/hw/hfi1/ipoib_tx.c         |  2 +-
 drivers/net/usb/aqc111.c                      |  2 +-
 drivers/net/usb/asix_devices.c                |  6 +-
 drivers/net/usb/ax88172a.c                    |  2 +-
 drivers/net/usb/ax88179_178a.c                |  2 +-
 drivers/net/usb/cdc_mbim.c                    |  2 +-
 drivers/net/usb/cdc_ncm.c                     |  2 +-
 drivers/net/usb/dm9601.c                      |  2 +-
 drivers/net/usb/int51x1.c                     |  2 +-
 drivers/net/usb/mcs7830.c                     |  2 +-
 drivers/net/usb/qmi_wwan.c                    | 41 +++-------
 drivers/net/usb/rndis_host.c                  |  2 +-
 drivers/net/usb/sierra_net.c                  |  2 +-
 drivers/net/usb/smsc75xx.c                    |  2 +-
 drivers/net/usb/smsc95xx.c                    |  2 +-
 drivers/net/usb/sr9700.c                      |  2 +-
 drivers/net/usb/sr9800.c                      |  2 +-
 drivers/net/usb/usbnet.c                      | 23 ++----
 drivers/net/wireless/quantenna/qtnfmac/core.c | 78 ++++---------------
 drivers/net/wireless/quantenna/qtnfmac/core.h |  4 -
 .../quantenna/qtnfmac/pcie/pearl_pcie.c       |  4 +-
 .../quantenna/qtnfmac/pcie/topaz_pcie.c       |  4 +-
 drivers/net/wireless/rndis_wlan.c             |  2 +-
 include/linux/usb/usbnet.h                    |  4 -
 27 files changed, 59 insertions(+), 183 deletions(-)

-- 
2.29.2

