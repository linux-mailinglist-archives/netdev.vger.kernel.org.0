Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D331A2B347A
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgKOKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:53:06 -0500
Received: from yes.iam.tj ([109.74.197.121]:58588 "EHLO iam.tj"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726634AbgKOKxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 05:53:05 -0500
Received: from [10.0.40.123] (unknown [51.155.44.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id 7055D340AD;
        Sun, 15 Nov 2020 10:53:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1605437583; bh=EGsM0fLMXwCGwT31lO5V/ZpZc2vKWVZKVrwOrZJVn0k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=t+NaZLxCNFc3XVuspQsN3U4LEW8aOQGwf5m3kcgbmBiezG7dlRqGfMWS1uz4p+pGV
         Kecp2H7IP1a0BNMloIs/+H0l1JvQBO4SqoPhSiH118pz8rJkfG2TKbiPRj1WgngRKv
         pWPIKDCeG7IDuTAa3IzCLd5Ds2VLojA+cc0yn8kbz/qA3uc3pkSggMnalMsH3SMUgA
         BSCHfdZ6ByL8nb5Iua+Ua1kAkrn56rY8v+XLdGIIOHeUQx3g7x1+4fS+QtCV89RVXE
         qO9LYh3H8KwS249mQKSTTQcKEXEvWwWI5EwqylESdJQlgKK7GDSBhUk/QmA7X/mnIo
         eFYu7vckisdlg==
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        andrew@lunn.ch, f.fainelli@gmail.com, marek.behun@nic.cz,
        vivien.didelot@gmail.com, info <info@turris.cz>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
 <20201114184915.fv5hfoobdgqc7uxq@skbuf>
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Organization: Elloe CIC
Message-ID: <c0bb216e-0717-a131-f96d-c5194b281746@elloe.vision>
Date:   Sun, 15 Nov 2020 10:53:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114184915.fv5hfoobdgqc7uxq@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/11/2020 18:49, Vladimir Oltean wrote:
> On Sat, Nov 14, 2020 at 03:39:28PM +0000, Tj (Elloe Linux) wrote:
>> MV88E6085 switch not passing IPv6 multicast packets to CPU.

> Is there a simple step-by-step reproducer for the issue, that doesn't
> require a lot of configuration? I've got a Mox with the 6190 switch
> running net-next and Buildroot that I could try on.

Our set-up is Mox A (CPU) + G (mini-PCIe) + F (4x USB 3.0) + 3 x E (8
port Marvell switch) + D (SFP cage)

Whilst working on this we've moved one of the E modules to another A CPU
in our lab so as not to mess with the gateway.

Running Debian 10, using systemd-networkd, which configures:

eth0 (WAN) static IPv4 and IPv6 - DHCP=no
eth1 (uplink to the switch ports) DHCP=no
lan1 (connected to external managed switch) Bridge=br-lan
br-lan static IPv4 and IPv6, Kind=bridge, IPForward=true

Whilst we're working on this issue only lan1 is connected to anything
external; a 48-port managed switch. No connection to SPF either.

We assign an IPv6 from our delegated /48 prefix to br-lan and have
isc-dhcp-server configured on a very short lease (180 seconds) to issue
leases.

On a LAN client we request a lease using:

dhclient -d -6 wlp4s0

Usually, if this is started just after the Mox systemd-networkd was
restarted, it'll manage to obtain and then renew a lease about 3 or 4 times.

These will show up in the Mox logs too.

At some point, with absolutely nothing showing in any Mox log in the
meantime, additional renewals will fail.

We later noticed that after this happens sometime later clients on the
network lose IPv6 connectivity to the Mox because neighbour discovery is
also failing - took us a while to spot this because the Mox occasionally
sends RAs at which point the clients can talk to the Mox again. The
symptom here was unexplained random-length 'hangs' of SSH sessions to
the Mox that would affect LAN clients only when the neighbour table
entry had expired.

I'm trying to create a very small reproducer root file-system on the lab
Mox.

Right now I've not been able to reproduce it on the lab unit even with a
clone of the gateway Mox's micro SD-card, but that seems due to it
failing to complete a regular boot - hence creating a fresh root
file-system.
