Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F328D447
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbgJMTO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgJMTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 15:14:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DEFC0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 12:14:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p16so1581713ilq.5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VJjtKmd2apILXmfF2EQPIO1XzJ0lEoY85P4KNi8M4Yo=;
        b=lP3Z2IVedcNLCzGuPNd6NJi5JbXGjAbUhN+kkeUinSOtv/DczOrRtnE5Nm7+PbKCRC
         x8jvcACGr2Ov9Cyh8+GBSd+UFWwEMrg63v/5QR4m9sMr3LOd0SZ/PuMdSHBCJz43osj6
         HCTR9mrXxvPHqgtxu8tRfW3HbfTLOlr0KpAK5wTbjT/WvZdJm7I50AHZiYzh6aRDjyNe
         7PuzdQRCPqSprJ3AO5J2EL2yPoP4WuHlTfO+mzE1hej2VOycNQkzTvug4ZOwa5J98FO5
         oIunPo3+S8pQ10unsxlhBcECm1ex1iuJJ4CXLzrldKfaNBjGdSe0Fi28Q8NLSU+Q6nyG
         CqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VJjtKmd2apILXmfF2EQPIO1XzJ0lEoY85P4KNi8M4Yo=;
        b=XVc7Vz+QfFUex+v5SAUpdl8lUzeIDRcI41rUhRDgDZBkan49+zinMlq/BQEKbTUswa
         vwMgF4GA+nub4nz0Bf7bXVXmbQZ0ERzUZFEvcpkdxVMk9G5Y2s1grIyW3dHXkfvY0O1n
         N/yH3jP8cx/nySelraWdibkR1dDhEzZ9t63bBLkSHUeo8MGKog4428JspdY1BVYv8A9e
         c5VGDpNrVpOBvrr/hTKzL719M0ksovNp3nOdsCd21N3IyaTLgRlEprDprYadh1xH2YGl
         sM1Fm1nw1lBU7T3R/zE1ckTE46KCNEhIvlz8ezny6m8VP+pKGRrrgWZaJIYlZmN86yXC
         1iBw==
X-Gm-Message-State: AOAM533y5srG0/2WNlc/KelHHOkgiNveKYklfgMIv8Kkn46raselo/GI
        b4QqrwcC3KNwrWzuxHgcGeIwx9qHr0JZRWfIVQs9NA==
X-Google-Smtp-Source: ABdhPJwvTALQicnbBOI5aDrUrzxONwJs4HzJNk1waENtSLsVKmq+AX0giwG/VJ2TPij8WjQys43xC/7TtjRAb4spNvo=
X-Received: by 2002:a92:cd11:: with SMTP id z17mr1186301iln.201.1602616496705;
 Tue, 13 Oct 2020 12:14:56 -0700 (PDT)
MIME-Version: 1.0
From:   Grant Grundler <grundler@google.com>
Date:   Tue, 13 Oct 2020 19:14:45 +0000
Message-ID: <CANEJEGuciX5he18HU5B+mAEcTom2MFtAKZfiVHCojvj24mzSAA@mail.gmail.com>
Subject: cdc-ncm spewing link state
To:     nic_swsd <nic_swsd@realtek.com>, Hayes Wang <hayeswang@realtek.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I connect a "newish" RTL8156 2.5Gbps USB ethernet dongle to any
chromebook running 4.4, 4.14 or local workstation running 5.7.17 I get
the link state spewed on the dmesg at ~30 times per second:
[67541.686970] usb 2-6: new SuperSpeed Gen 1 USB device number 3 using xhci_hcd
[67541.707673] usb 2-6: New USB device found, idVendor=0bda,
idProduct=8156, bcdDevice=30.00
[67541.707678] usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=6
[67541.707681] usb 2-6: Product: USB 10/100/1G/2.5G LAN
[67541.707684] usb 2-6: Manufacturer: Realtek
[67541.707687] usb 2-6: SerialNumber: 000A91758
[67541.751910] cdc_ncm 2-6:2.0: MAC-Address: 00:c0:ca:a9:17:58
[67541.751912] cdc_ncm 2-6:2.0: setting rx_max = 16384
[67541.751978] cdc_ncm 2-6:2.0: setting tx_max = 16384
[67541.752223] cdc_ncm 2-6:2.0 usb0: register 'cdc_ncm' at
usb-0000:00:14.0-6, CDC NCM, 00:c0:ca:a9:17:58
[67541.752507] usbcore: registered new interface driver cdc_ncm
[67541.753929] usbcore: registered new interface driver cdc_wdm
[67541.755147] usbcore: registered new interface driver cdc_mbim
[67541.760965] cdc_ncm 2-6:2.0 enx00c0caa91758: renamed from usb0
[67541.833636] cdc_ncm 2-6:2.0 enx00c0caa91758: network connection: disconnected
[67541.865610] cdc_ncm 2-6:2.0 enx00c0caa91758: network connection: disconnected
...

This works out to roughly 200MB per day or 1 GB per week. Not acceptable.


QUESTION: Is the following change the correct approach to resolve at
least 1/2 the issue?
    Or is this a bug in the Realtek CDC NCM support?

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 16546268d77d7..8258f7463fcf1 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1623,8 +1623,7 @@ static void cdc_ncm_status(struct usbnet *dev,
struct urb *urb)

 static const struct driver_info cdc_ncm_info = {
        .description = "CDC NCM",
-       .flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
-                       | FLAG_LINK_INTR,
+       .flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET,
        .bind = cdc_ncm_bind,
        .unbind = cdc_ncm_unbind,
        .manage_power = usbnet_manage_power,

Removing FLAG_LINK_INTR eliminated the "no link" spew but not the
"uplink" spew output from cdc_ncm_speed_change():
[   70.919608] usb 2-2: new SuperSpeed USB device number 3 using xhci_hcd
[   70.931102] usb 2-2: New USB device found, idVendor=0bda,
idProduct=8156, bcdDevice=30.00
[   70.931107] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=6
[   70.931108] usb 2-2: Product: USB 10/100/1G/2.5G LAN
[   70.931110] usb 2-2: Manufacturer: Realtek
[   70.931112] usb 2-2: SerialNumber: 000000001
[   71.013028] cdc_ncm 2-2:2.0: MAC-Address: a0:ce:c8:c8:13:60
[   71.013033] cdc_ncm 2-2:2.0: setting rx_max = 16384
[   71.013110] cdc_ncm 2-2:2.0: setting tx_max = 16384
[   71.013394] cdc_ncm 2-2:2.0 usb0: register 'cdc_ncm' at
usb-0000:00:14.0-2, CDC NCM, a0:ce:c8:c8:13:60
[   71.014265] usbcore: registered new interface driver cdc_ncm
[   71.018726] usbcore: registered new interface driver cdc_wdm
[   71.019875] usbcore: registered new interface driver cdc_mbim
... (connect ethernet from GigE switch to dongle)
[  133.820200] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
[  133.884202] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
[  133.948235] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
...
[  167.164652] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
[  167.228824] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
[  167.292679] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
[  167.356662] cdc_ncm 2-2:2.0 usb0: 1000 mbit/s downlink 1000 mbit/s uplink
[  173.473869] usb 2-2: USB disconnect, device number 3
[  173.474110] cdc_ncm 2-2:2.0 usb0: unregister 'cdc_ncm'
usb-0000:00:14.0-2, CDC NCM
[  181.171531] PDLOG 2020/10/13 01:55:23.1602554122 P0 SRC 3000mA

Thanks for any help with this.

cheers,
grant
