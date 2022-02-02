Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01DB4A6ED2
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343572AbiBBKfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:35:44 -0500
Received: from pop36.abv.bg ([194.153.145.227]:47376 "EHLO pop36.abv.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343559AbiBBKfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 05:35:43 -0500
Received: from smtp.abv.bg (localhost [127.0.0.1])
        by pop36.abv.bg (Postfix) with ESMTP id 7A4AB1805D2D;
        Wed,  2 Feb 2022 12:35:35 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=abv.bg; s=smtp-out;
        t=1643798135; bh=LJ2bSPclt4CDkpG3k+w2M34FMl19qOebAQleIeO3j9I=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=mX8csLmiBLqAAq7f88AoxyszlnFNhZIKKrGKCG04QORhP9NJMwsELUUyo0pIFkACm
         YtcTYzdqtwNyvBVqEpTOrA+xRt3qLNZbxllNGQUNgnaFBX561+RK1x3JFZxb4uWQkm
         LlvNEBg9ev7115kZbxC0C9aJCULDxDKHiWaCO/f4=
X-HELO: smtpclient.apple
Authentication-Results: smtp.abv.bg; auth=pass (plain) smtp.auth=gvalkov@abv.bg
Received: from 212-39-89-111.ip.btc-net.bg (HELO smtpclient.apple) (212.39.89.111)
 by smtp.abv.bg (qpsmtpd/0.96) with ESMTPSA (ECDHE-RSA-AES256-GCM-SHA384 encrypted); Wed, 02 Feb 2022 12:35:35 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v2 0/1] ipheth URB overflow fix
From:   Georgi Valkov <gvalkov@abv.bg>
In-Reply-To: <0414e435e29d4ddf53d189d86fae2c55ed0f81ac.camel@corsac.net>
Date:   Wed, 2 Feb 2022 12:35:31 +0200
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable @ vger . kernel . org" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CE7AE1A3-51E9-45CE-A4EE-DACB03B96D9C@abv.bg>
References: <cover.1643699778.git.jan.kiszka@siemens.com>
 <0414e435e29d4ddf53d189d86fae2c55ed0f81ac.camel@corsac.net>
To:     Yves-Alexis Perez <corsac@corsac.net>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 2022-02-02, at 10:09 AM, Yves-Alexis Perez <corsac@corsac.net> =
wrote:
>=20
> On Tue, 2022-02-01 at 08:16 +0100, Jan Kiszka wrote:
>> Georgi Valkov (1):
>>   ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
>>=20
>>  drivers/net/usb/ipheth.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> Hi,
>=20
> sorry for the extra-long delay. I finally tested the patch, and it =
seems to
> work fine. I've tried it on my laptop for few hours without issue, but =
to be
> fair it was working just fine before, I never experienced the =
EOVERFLOW
> myself.

Thank you for testing and committing the patch!

Hi Yves!
In order to experience the EOVERFLOW, the iPhone has to receive a large =
packet
of size 1514 bytes. Note that it is common for ISPs to limit the MTU, =
which results
in dropping large packets before they arrive at the iPhone. For example =
if I run

mtr 8.8.8.8 -n

 1. 172.20.10.1
 2. (waiting for reply)
 3. 10.98.8.1
 4. 10.98.8.253
 5. 46.10.207.99
 6. 212.39.69.106
 7. 212.39.66.222
 8. 216.239.59.239
 9. 74.125.251.185
10. 8.8.8.8

Host 5 drops large packets, while 3 and 4 replay. Now run
ping 10.98.8.1 -D -s 1472

Without the patch I get EOVERFLOW and there is no further communication.
It would be nice if a failsafe mechanism is implemented to recover from =
faults
like that or in the event that no communication is detected over a =
certain period.
With the patch applied, everything works fine:
1480 bytes from 10.98.8.1: icmp_seq=3D0 ttl=3D253 time=3D50.234 ms

There is another issue with my iPhone 7 Plus, which is unrelated to this =
patch:
If an iPhone is tethered to a MacBook, the next time it gets connected =
to an
OpenWRT router the USB Ethernet interface appears, but there is no
communication. Hence I would assume this issue has to be fixed in =
another
patch. I can confirm that in this state macOS and Windows are able to =
use
USB tethering, only OpenWRT is affected. So far I found the following
workarounds:
* reboot the phone or run:
* usbreset 002/002 && /etc/init.d/usbmuxd restart
* or in macOS disable the USB Ethernet interface, before the iPhone is
unplugged: e.g. Settings, Network, iPhone USB: check Disable unless =
needed,
then connect over wifi. The USB interface gets disabled.
* the same effect can also be achieved using QuickTime, File,
New Movie Recording. Selecting the iPhone, causes the USB Ethernet =
interface
to disappear. If we unplug and tether to OpenWRT now, it works fine. =
This looks
like an incomplete initialisation, likely in usbmuxd or ipheth, which =
needs to switch
the iPhone to the proper mode.

The same happens if the phone is powered off, and then restarted while =
tethered,
or if it reboots due to extreme cold temperatures or low battery. =
Finally there is
also a bug or possible hardware/baseband fault in my phone where every =
few
days the modem reboots: the LTE icon disappears for a few seconds, and
tethering is turned off. In the last case Personal Hotspot disappears in =
Settings,
but can still be accessed under Mobile Data. This is likely another iOS =
bug.

Either way, running the commands mentioned above re-enable tethering and
restore the communication instantly. There is no need to unlock the =
iPhone with
a passcode after it restarts. It would be nice if a watchdog is =
integrated
in ipheth to trigger recovery automatically.

Any ideas how to implement a watchdog to fix this separate issue?
--
Georgi Valkov

