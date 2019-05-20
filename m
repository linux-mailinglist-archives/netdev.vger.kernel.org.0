Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C9F230EF
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbfETKKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 06:10:07 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:44690 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730468AbfETKKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 06:10:07 -0400
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 06:10:06 EDT
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+netdev@zugschlus.de>)
        id 1hSevb-00020T-L5; Mon, 20 May 2019 11:49:55 +0200
Date:   Mon, 20 May 2019 11:49:55 +0200
From:   Marc Haber <mh+netdev@zugschlus.de>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Kernel 5.1 breaks UDP checksums for SIP packets
Message-ID: <20190520094955.GA6502@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

when I update my Firewall from Kernel 5.0 to Kernel 5.1, SIP clients
that connect from the internal network to an external, commercial SIP
service do not work any more. When I trace beyond the NAT, I see that
the outgoing SIP packets have incorrect UDP checksums:

Frame 6: 657 bytes on wire (5256 bits), 657 bytes captured (5256 bits) on interface 0
    Interface id: 0 (/tmp/wireshark_extcap_sshdump_20190520104331_NgLcXH)
        Interface name: /tmp/wireshark_extcap_sshdump_20190520104331_NgLcXH
    Encapsulation type: Ethernet (1)
    Arrival Time: May 20, 2019 10:43:35.907132000 CEST
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1558341815.907132000 seconds
    [Time delta from previous captured frame: 0.748426000 seconds]
    [Time delta from previous displayed frame: 0.748426000 seconds]
    [Time since reference or first frame: 1.088703000 seconds]
    Frame Number: 6
    Frame Length: 657 bytes (5256 bits)
    Capture Length: 657 bytes (5256 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:ip:udp:sip]
Ethernet II, Src: RealtekU_95:df:a6 (52:54:00:95:df:a6), Dst: AvmAudio_29:77:45 (cc:ce:1e:29:77:45)
    Destination: AvmAudio_29:77:45 (cc:ce:1e:29:77:45)
        Address: AvmAudio_29:77:45 (cc:ce:1e:29:77:45)
        .... ..0. .... .... .... .... = LG bit: Globally unique address (factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Source: RealtekU_95:df:a6 (52:54:00:95:df:a6)
        Address: RealtekU_95:df:a6 (52:54:00:95:df:a6)
        .... ..1. .... .... .... .... = LG bit: Locally administered address (this is NOT the factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Type: IPv4 (0x0800)
Internet Protocol Version 4, Src: 192.168.251.241, Dst: 195.185.37.60
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
        0000 00.. = Differentiated Services Codepoint: Default (0)
        .... ..00 = Explicit Congestion Notification: Not ECN-Capable Transport (0)
    Total Length: 643
    Identification: 0x3359 (13145)
    Flags: 0x4000, Don't fragment
        0... .... .... .... = Reserved bit: Not set
        .1.. .... .... .... = Don't fragment: Set
        ..0. .... .... .... = More fragments: Not set
        ...0 0000 0000 0000 = Fragment offset: 0
    Time to live: 63
    Protocol: UDP (17)
    Header checksum: 0x6081 [correct]
    [Header checksum status: Good]
    [Calculated Checksum: 0x6081]
    Source: 192.168.251.241
    Destination: 195.185.37.60
User Datagram Protocol, Src Port: 42867, Dst Port: 5060
    Source Port: 42867
    Destination Port: 5060
    Length: 623
    Checksum: 0xe8a6 incorrect, should be 0xe89b (maybe caused by "UDP checksum offload"?)
        [Expert Info (Error/Checksum): Bad checksum [should be 0xe89b]]
            [Bad checksum [should be 0xe89b]]
            [Severity level: Error]
            [Group: Checksum]
        [Calculated Checksum: 0xe89b]
    [Checksum Status: Bad]
    [Stream index: 1]
Session Initiation Protocol (REGISTER)
    Request-Line: REGISTER sip:sip.easybell.de;transport=UDP SIP/2.0
        Method: REGISTER
        Request-URI: sip:sip.easybell.de;transport=UDP
            Request-URI Host Part: sip.easybell.de
        [Resent Packet: False]

The SIP server doesn't appreciate that and refrains from answering.

As soon as my Firewall is back to a 5.0 kernel (here: 5.0.13), the UDP
checksums are fine, the SIP server answers. The contents of the actual
packet are identical modulo serial numbers, nonces etc.

The setup is "a bit complicated" as it's kind of a laboratory setup:

SIP client is on a Wireless LAN, WPA Enterprise

The Accesspoint (Unifi AP Pro) bridges the data stream to a VLAN

The Firewall, barrida, is running on a KVM virtualization host, prom.

prom has a 802.1q trunk to the network and hands the entire trunk on to
barrida on barrida's eth0.

barrida has the 802.1q interfaces, firewalls, NATs. It receives the
tagged packet on the VLAN interface int184 and routes the packets to a
different VLAN interface, unt381, on its eth2. Barrida has checksum
offloading turned OFF on both eth2 and unt381.

prom, again, has a different trunk to barrida's eth2 and forwards the
packets over another 802.1q trunk back to the physical network

The access router, an AVM Fritz!Box, is on an Access Port of the network
and performs NAT a second time. This is for historical reasons.

I can see the broken UDP checksums both on Barrida's unt381 and on the
outside-facing Interface of the Fritz!Box.

As soon as barrida runs a 5.0.13 kernel, the UDP checksums on both traces
(unt381 and the outside-facing Fritz!Box interface) are fine and the SIP
server answers.

I think that I have a case for barrida's Kernel being at fault, since
this is the only thing I need to change to make things work again.

The obvious candidates are nf_conntrack_sip and nf_nat_sip. nf_nat_sip
didn't change between 5.0.13 and 5.1.3, and transplanting 5.0's
nf_conntrack_sip onto a 5.1.3 kernel didn't change 5.1.3's faulty
behavior.

Does anybody have an idea that I could try before bisecting 7074
revisions in roughly 13 steps?

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
