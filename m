Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1382B2E35
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 16:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgKNPpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 10:45:18 -0500
Received: from yes.iam.tj ([109.74.197.121]:49752 "EHLO iam.tj"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726885AbgKNPpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 10:45:15 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Nov 2020 10:45:15 EST
Received: from [10.0.40.123] (unknown [51.155.44.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id 8F5F5340AD;
        Sat, 14 Nov 2020 15:39:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1605368368; bh=9H2sw/oxQlxxHUDyoSY/lnJazAvarw7rSLFVUzw0O68=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=bZL+N70WB06q6MzZlH+nB/F/UVmbqRVg2aTCHL2Cjq1pMpxQFzqH1CavpjOd4C5bX
         uDBPZ6dIFshhLUwf9071iTSIwIpaByrmkjnQlgvVuRf+yqfCo6UxD91LXcht6XJdtI
         CeOgN5ofjgGNosPSwhE+T7Met+OMNt553OKc/WoKG6PUGvL0C72GxidAzG/fsaozsX
         wLsUOBKFnORFACs5eTS4SV6xEqTlyGs7TiujASPpV9u2F23AorJMcXSZRMa95KB+n3
         clrSajPZw+Uqb54gHDAa7+Lz+g3HbxoaL2xcyjiqdH1+rqBZC/4OqVXpbfmsGH8XZp
         7v/rFCb4QruHA==
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
To:     netdev@vger.kernel.org
Cc:     chris.packham@alliedtelesis.co.nz, andrew@lunn.ch,
        f.fainelli@gmail.com, marek.behun@nic.cz, vivien.didelot@gmail.com,
        info <info@turris.cz>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
Organization: Elloe CIC
Message-ID: <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
Date:   Sat, 14 Nov 2020 15:39:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MV88E6085 switch not passing IPv6 multicast packets to CPU.

Seems to be related to interface not being in promiscuous mode.

This issue has been ongoing since at least July 2020. Latest v5.10-rc3
still suffers the issue on a Turris Mox with mv88e6085. We've not been
able to reproduce it on the Turris v4.14 stable kernel series so it
appears to be a regression.

Mox is using Debian 10 Buster.

First identified due to DHCPv6 leases not being renewed on clients being
served by isc-dhcp-server on the Mox.

Analysis showed the client IPv6 multicast solicit packets were being
received by the Mox hardware (proved via a mirror port on a managed LAN
switch) but the CPU was not receiving them (observed using tcpdump).

Further investigation has identified this also affects IPv6 neighbour
discovery for clients when not using frequent RAs from the Mox.

Currently we've found two reproducible scenarios:

1) with isc-dhcp-server configured with very short lease times (180
seconds). After mox reboot (or systemctl restart systemd-networkd)
clients successfully obtain a lease and a couple of RENEWs (requested
after 90 seconds) but then all goes silent, Mox OS no longer sees the
IPv6 multicast RENEW packets and client leases expire.

2) Immediately after reboot when DHCPv6 renewals are still possible if
on the Mox we do "tcdump -ni eth1 ip6" and immediately terminate,
tcpdump takes the interface out of promiscuous mode and IPv6 multicast
packets immediately cease to be received by the CPU. If we use 'tcpdump
--no-promiscuous-mode ..." so on termination it doesn't try to take the
interface out of promiscuous mode IPv6 multicast packets continue to be
seen by the CPU.

We've been pointed to the mv8e6xxx_dump tool and can capture data but
not sure what specifically to look for.

We've also added some pr_info() debugging into mvneta to analyse when
promiscuous mode is enabled or disabled since this seems to be strongly
related to the issue.

We believe there's a big clue in being able to reset the issue by
restarting systemd-networkd on the Mox. We've looked for but not found
any clues or indications of services on the Mox causing this but aren't
ruling this out.
