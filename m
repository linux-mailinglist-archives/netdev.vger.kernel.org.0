Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC7112DFC0
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 18:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgAARaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 12:30:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40364 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgAARa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 12:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NwHMXFcgZR8XTTD5tv5KQQTcR8yXPs7MkV/oQb4zC5U=; b=YihfrbzE+7jbABXlf3vSlifCX
        gKZ9LeUrEl7mPyCm5Lw5oJjEPELJxSB0LRA0xPYDa4daXrc0K5kDYsy+v6LlM0aju7QL6jIsnGbSc
        DSeg5Mjsz1HJeQX6pawibKmIvhTU1FiV5Yux5xonwqlHER0PlYCZK6WYDYBM0oiN71ZMxq6P29vwH
        3UxWn90KuIR6FdkPwgsR8OnIm8LKvY9rhcvefGOsVQfx8f7gydXe/wpj2mfeQW4sXk5SdgOjILTNu
        nTV8yFZ4HwPi6xwwEX4eQnBYg9gl4ZCZk7zhbKRJEKM/O+O6Iupb0rU7j67PlXHOh8SiFvgDK+Pm4
        /NUQG62jA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60874)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1imhp5-0007mC-Bi; Wed, 01 Jan 2020 17:30:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1imhp0-0001JH-BI; Wed, 01 Jan 2020 17:30:14 +0000
Date:   Wed, 1 Jan 2020 17:30:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200101173014.GZ25745@shell.armlinux.org.uk>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
 <20191231180614.GA120120@splinter>
 <20200101011027.gpxnbq57wp6mwzjk@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200101011027.gpxnbq57wp6mwzjk@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

I've just tried this setup here:

# ip ad add 192.168.4.1/24 dev lan1
# ip li set dev lan1 up
# ip li add li lan1 name lan1.128 type vlan id 128
# ip ad add 192.168.5.1/24 dev lan1.128
# ip li set dev lan1.128 up

without lan1 being part of at Linux software bridge.  lan2..6 are
part of a software bridge that has vlan filtering disabled.

On the other end of lan1, I have another machine setup with addresses
192.168.4.2/24 on the raw network interface and 192.168.5.2/24 on vlan
128 - and it works perfectly, without issue.

This is my 5.4.0 kernel, which has a lot of patches on top of 5.4.0,
including the patch set that started this thread. The hardware is a
SolidRun Clearfog (MV88E6176 DSA switch with mvneta host ethernet).

I think the most important thing to do if you're suffering problems
like this is to monitor and analyse packets being received from the
DSA switch on the host interface:

# tcpdump -enXXi $host_dsa_interface

Here's an example ping packet received over the vlan with the above
configuration, captured from the host DSA interface (ether mac
addresses obfuscated):

        0x0000:  DDDD DDDD DDDD SSSS SSSS SSSS dada 0000  .PC.....[h:.....
                                               ^^^^^^^^^
        0x0010:  c020 0000 8100 0080 0800 4500 0054 ec40  ..........E..T.@
                 ^^^^^^^^^ ^^^^^^^^^ ^^^^
        0x0020:  4000 4001 c314 c0a8 0502 c0a8 0501 0800  @.@.............
        0x0030:  8784 0c85 0001 32c8 0c5e 0000 0000 59fc  ......2..^....Y.
        0x0040:  0c00 0000 0000 1011 1213 1415 1617 1819  ................
        0x0050:  1a1b 1c1d 1e1f 2021 2223 2425 2627 2829  .......!"#$%&'()
        0x0060:  2a2b 2c2d 2e2f 3031 3233 3435 3637       *+,-./01234567

dada 0000 c020 0000	- EDSA tag
8100 0080		- VLAN ethertype, vlan id
0800			- IPv4 ethertype, and what follows is the ipv4
			  packet.

That way it would be possible to know whether the DSA switch is
forwarding the packets, and in what manner it's forwarding them.

Another tool that I've found useful is Vivien's debugfs patch,
which seems to be way superior for understanding the Marvell DSA
switch state than any other tool out there. It's my understanding
that DaveM doesn't want that in the mainline kernel, but it's
really useful for understanding what's going on. It was key to me
discovering why vlan stuff wasn't working for me.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
