Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A582F46C91
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 00:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfFNWym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 18:54:42 -0400
Received: from pb-smtp21.pobox.com ([173.228.157.53]:54612 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfFNWym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 18:54:42 -0400
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 327116AC9E;
        Fri, 14 Jun 2019 18:54:40 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=from:to
        :subject:message-id:date:mime-version:content-type
        :content-transfer-encoding; s=sasl; bh=iEgu6rTrAwd8u7gHNlrBkvryq
        eY=; b=YZ+lqTkeSkugtzSRvmxoInb2WwIBaNeAKis6wvs5sax3UuASMTARKrO78
        P5yvFT1KZ8XX4jXQq1s1woMt67LvL0slc9WsBFLaRV670DDsMELp58+RsnvYX5Az
        G4WHxzCRim3C4UNQGvfPTCMhIQoxecrxWlF1NSmbxtcATSdViQ=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
        :message-id:date:mime-version:content-type
        :content-transfer-encoding; q=dns; s=sasl; b=YAU6IfALxo5kQq1Q9H1
        przLHl5bCsei31zJG0kDUgeURf+MTW3PaS4nNuv7N538oYK/eDhH+9bXbOtdPaRw
        upVRP1EAx3fyODMDAk+lx3Un7tClzbCMSTo3GJ4MvSfQn4abuvA+fnZkKLHrK1y7
        f93XH/9MVxEcf5Eu6e+NSUDo=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 2A8176AC9D;
        Fri, 14 Jun 2019 18:54:40 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id 4812A6AC9C;
        Fri, 14 Jun 2019 18:54:37 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
From:   Daniel Santos <daniel.santos@pobox.com>
To:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        openwrt-devel <openwrt-devel@lists.openwrt.org>,
        John Crispin <blogic@openwrt.org>,
        Michael Lee <igvtee@gmail.com>, netdev@vger.kernel.org
Subject: Understanding Ethernet Architecture (I/O --> MDIO --> MII vs I/O -->
 MAC) for mt7620 (OpenWRT)
Message-ID: <2766c2b3-3262-78f5-d736-990aaa385eeb@pobox.com>
Date:   Fri, 14 Jun 2019 17:53:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 62C4A350-8EF7-11E9-AA41-8D86F504CC47-06139138!pb-smtp21.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm still fairly new to Ethernet drivers and there are a lot of
interesting pieces.=C2=A0 What I need help with is understanding MDIO -->
(R)MII vs direct I/O to the MAC (e.g., via ioread32, iowrite32).=C2=A0 Wh=
y is
there not always a struct mii_bus to talk to this hardware?=C2=A0 Is it
because the PHY and/or MAC hardware sometimes attached via an MDIO
device and sometimes directly to the I/O bus?=C2=A0 Or does some type of
"indirect access" need to be enabled for that to work?

I might be trying to do something that's unnecessary however, I'm not
sure yet.=C2=A0 I need to add functionality to change a port's
auto-negotiate, duplex, etc.=C2=A0 I'm adding it to the swconfig first an=
d
then will look at adding it for DSA afterwards.=C2=A0 When I run "swconfi=
g
dev switch0 port 0 show", the current mt7530 / mt7620 driver is querying
the MAC status register (at base + 0x3008 + 0x100 * port, described on
pages 323-324 of the MT7620 Programming Guide), so I implemented the
"set" functionality by modifying the MAC's control register (offset
0x3000 on page 321), but it doesn't seem to change anything.=C2=A0 So I
figured maybe I need to modify the MII interface's control register for
the port (page 350), but upon debugging I can see that the struct
mii_bus *bus member is NULL.

So should I be able to change it via the MAC's control register and
something else is wrong?=C2=A0 Why is there no struct mii_bus?=C2=A0 Can =
I talk to
the MII hardware in some other way?

Thanks,
Daniel

https://download.villagetelco.org/hardware/MT7620/MT7620_ProgrammingGuide=
.pdf
