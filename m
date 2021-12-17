Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5BA47902F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhLQPpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbhLQPpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 10:45:12 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E1C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 07:45:12 -0800 (PST)
Received: from [IPv6:2a00:23c6:c31a:b300:2e4c:acb4:9992:9f44] (unknown [IPv6:2a00:23c6:c31a:b300:2e4c:acb4:9992:9f44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 9F7771F470D2;
        Fri, 17 Dec 2021 15:45:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1639755910; bh=pQP1dcRiTZ0I3bE2dhVUA0797jxh162gv67K0L3jMYY=;
        h=Subject:From:To:Cc:Date:From;
        b=j0apLfdFPfj8g6+k/iNYKwm0qnh8BvHkGqA0WdmDaj1Gv70mFIT6Up+iHoRv6vMhO
         ui+dJ5nWFxOr51dIeRETB2vOVz89IoIIau2Z0TW6IzsJedLroKpSDV3P8xHZjoO+qm
         kX5ozvwHfEPmxNvKlbiK6vb8SyKny9qKqa6bsMlJrc8VLFkUIIrQ2sCJVs8DeIrjfD
         oqCr4ucFmaRYyjI1vO7v4LSGPKkwa7yIJ0Ha5ZXSz8Byyr1KuPJaAbBklG5UETw7Ja
         QPGa3nNt32s9NhJ6Qv7oZozWI2aYXkraX6JBOGnfjLZF5CM6WKITUHnjUN1FfDzdhs
         lRLzuXnhGuECQ==
Message-ID: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
Subject: Issues with smsc95xx driver since a049a30fc27c
From:   Martyn Welch <martyn.welch@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
Date:   Fri, 17 Dec 2021 15:45:08 +0000
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've had some reports of the smsc95xx driver failing to work for the
ODROID-X2 and ODROID-U3 since a049a30fc27c was merged (also backported
to 5.15.y stable branch, which I believe is what those affected by this
are using).

Since then we have performed a number of tests, here's what we've found
so far:

ODROID-U3 (built-in LAN9730):

 - No errors reported from smsc95xx driver, however networking broken
   (can not perform DHCP via NetworkManager, Fedora user space).

 - Networking starts working if device forced into promiscuous mode
   (Gabriel noticed this whilst running tcpdump)


ODROID-X2 (built in LAN9514):

 - Networking not brought up (Using Debian Buster and Bullseye with
traditional `/etc/network/interfaces` approach).

 - As with Odroid-u3, works when running in promiscuous mode.


OrangePi Zero with LAN9500A EVK:

 - Network works fine. Interface can be taken up and down, cable
   unplugged and replugged, network continues to work (Debian based
   user space).


Raspberry Pi 1 rev 2 (built-in LAN9512):

 - Network works fine. (Raspberry OS user space)


Raspberry Pi 2 (built-in LAN9514):

 - Booting with DHCP performed by kernel, appears to be working:

    https://lava.collabora.co.uk/scheduler/job/5240174

 - Tested in LAVA (traditional `/etc/network/interfaces` approach),
   networking appears to be working:

    https://lava.collabora.co.uk/scheduler/job/5247952

 - It has been noted that U-Boot uses this device during boot, which
   may be having an impact, however the driver appears to be resetting
   the chip at device bind. Have not been able to replicate this on the
   ODROID-X2 (U-boot environment there doesn't have the network
   driver). This is interesting as the Raspberry Pi 2 and ODROID-X2
   appear to have the same device, yet ones working and the other
   isn't.

Not sure how to approach this now, I've yet to find a device I have
access to that is impacted by this issue.

Martyn
