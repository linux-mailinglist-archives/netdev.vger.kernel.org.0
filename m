Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD0923195F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgG2GQm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 02:16:42 -0400
Received: from tmail.tesat.de ([62.156.180.249]:16569 "EHLO tmail.tesat.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgG2GQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:16:41 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2020 02:16:40 EDT
Received: from bk99pgp.bk.local (unknown [10.62.64.217]) by tmail.tesat.de with smtp
        (TLS: TLSv1/SSLv3,256bits,ECDHE-RSA-AES256-GCM-SHA384)
         id 753b_0233_6a9c6afe_eddf_4338_b3f3_2f08d3cfedc8;
        Wed, 29 Jul 2020 08:05:09 +0200
Received: from bk99pgp.bk.local (localhost [127.0.0.1])
        by bk99pgp.bk.local (Postfix) with ESMTP id 59F7618E082;
        Wed, 29 Jul 2020 08:05:10 +0200 (CEST)
Received: from BK99MAIL01.bk.local (mail.bk.local [10.62.64.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by bk99pgp.bk.local (Postfix) with ESMTPS id 47BDF18E059;
        Wed, 29 Jul 2020 08:05:10 +0200 (CEST)
Received: from BK99MAIL02.bk.local (10.62.64.169) by BK99MAIL01.bk.local
 (10.62.64.168) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 08:05:10 +0200
Received: from BK99MAIL02.bk.local ([fe80::8824:afc:c78e:5807]) by
 BK99MAIL02.bk.local ([fe80::8824:afc:c78e:5807%13]) with mapi id
 15.00.1497.006; Wed, 29 Jul 2020 08:05:10 +0200
From:   "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        ", Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA ingress
 without bridge
Thread-Topic: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Thread-Index: AdZlacdvzNLFV3z/TlWeuthNKZ0yRA==
Date:   Wed, 29 Jul 2020 06:05:10 +0000
Message-ID: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.62.151.200]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TBoneOriginalFrom: "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
X-TBoneOriginalTo: Woojung Huh <woojung.huh@microchip.com>, ", Microchip Linux Driver
 Support" <UNGLinuxDriver@microchip.com>
X-TBoneOriginalCC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-TBoneDomainSigned: false
X-TBoneMailStatus: PLAIN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Summary: 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
Keywords: networking, dsa, microchip, 802.1q, vlan
Full description:

Hello,
we're trying to get 802.1Q-Tagged Ethernet Frames through an KSZ9477 DSA-enabled switch without creating a bridge on the kernel side.
Following setup:
Switchport 1 <-- KSZ9477 --> eth1 (CPU-Port) <---> lan1

No bridge is configured, only the interface directly. Untagged packets are working without problems. The Switch uses the ksz9477-DSA-Driver with Tail-Tagging ("DSA_TAG_PROTO_KSZ9477").
When sending packets with 802.1Q-Header (tagged VLAN) into the Switchport, I see them including the 802.1Q-Header on eth1.
They also appear on lan1, but with the 802.1Q-Header missing.
When I create an VLAN-Interface over lan1 (e.g. lan1.21), nothing arrives there.
The other way around, everything works fine: Packets transmitted into lan1.21 are appearing in 802.1Q-VLAN 21 on the Switchport 1.

I assume that is not the intended behavior.
I haven't found an obvious reason for this behavior yet, but I suspect the VLAN-Header gets stripped of anywhere around "dsa_switch_rcv" in net/dsa/dsa.c or "ksz9477_rcv" in net/dsa/tag_ksz.c.
Hints where the problem could be in detail are welcomed, I will try patches and looking into details.

Kernel Version: v5.4.51
Device Tree from example (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/dsa/ksz.txt?h=v5.4 )

Thanks
Marvin Gaube

________________________________

Tesat-Spacecom GmbH & Co. KG
Sitz: Backnang; Registergericht: Amtsgericht Stuttgart HRA 270977
Persoenlich haftender Gesellschafter: Tesat-Spacecom Geschaeftsfuehrungs GmbH;
Sitz: Backnang; Registergericht: Amtsgericht Stuttgart HRB 271658;
Geschaeftsfuehrung: Dr. Marc Steckling, Kerstin Basche, Ralf Zimmermann

[banner]
