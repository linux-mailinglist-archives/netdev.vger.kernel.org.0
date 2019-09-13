Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC074B1A7B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbfIMJIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:08:20 -0400
Received: from cvk-fw1.cvk.de ([194.39.189.11]:16398 "EHLO cvk-fw1.cvk.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387613AbfIMJIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 05:08:20 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2019 05:08:19 EDT
Received: from localhost (cvk-fw1 [127.0.0.1])
        by cvk-fw1.cvk.de (Postfix) with ESMTP id 46V8h50VJbz4wr6
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:59:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cvk.de; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:message-id:date:date:subject
        :subject:from:from; s=mailcvk20190509; t=1568365140; x=
        1570179541; bh=c2sKHLWdgUNLcYiTpIxgDlpw1ntPeMEwYpWiKBvpsSk=; b=F
        kGWwrKVR3vb+vT9C+DMZT34o4dqtfOiIgdTUPEiV+8bn9DcL+bIIFDUyHTu+booA
        UWLhhWODxtax68WlyD1w6p8AgJw+/Rv5AB1DnEHIc/EWxOnF1I1Km3dVPz03/prZ
        M6aSSGHaP+ZMxFYrOJ/n4MVyNbQUqnfTs0jOm9q2R+8H5TeXE9oI2HKcJl7tKA52
        N48DsZ6kKKRQKEm+OKwhevBIe3YkgefoHaRPVs+VjEn+3zBlIVjeLzV42RPIE+Oi
        ZrUWrxxjzzWdFPV/MYw/CFUDFd0QzsTUFx6dgp7tl6VgXwsSElmy1MQzLHkMs7Js
        aoxJ+B58K23COMM4id4sw==
X-Virus-Scanned: by amavisd-new at cvk.de
Received: from cvk-fw1.cvk.de ([127.0.0.1])
        by localhost (cvk-fw1.cvk.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bX0RhSWI-hXy for <netdev@vger.kernel.org>;
        Fri, 13 Sep 2019 10:59:00 +0200 (CEST)
Received: from cvk027.cvk.de (cvk027.cvk.de [10.1.0.22])
        by cvk-fw1.cvk.de (Postfix) with ESMTP
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:59:00 +0200 (CEST)
Received: from cvk038.intra.cvk.de (cvk038.intra.cvk.de [10.1.0.38])
        by cvk027.cvk.de (Postfix) with ESMTP id 65CCC84ADE8
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:59:01 +0200 (CEST)
Received: from CVK038.intra.cvk.de ([::1]) by cvk038.intra.cvk.de ([::1]) with
 mapi id 14.03.0468.000; Fri, 13 Sep 2019 10:59:01 +0200
From:   "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Topic: big ICMP requests get disrupted on IPSec tunnel activation
Thread-Index: AdVqDuxpNdDfEB5ERA+Q1nyhyK5bhA==
Date:   Fri, 13 Sep 2019 08:59:00 +0000
Message-ID: <EB8510AA7A943D43916A72C9B8F4181F629D9741@cvk038.intra.cvk.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.10.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-GBS-PROC: 5zoD1qfZ1bhzGU/FjtQuf4EINqGxeuzvToiSDe3zBQ8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello together,

since kenel 4.20 we're observing a strange behaviour when sending big ICMP =
packets. An example is a packet size of 3000 bytes.
The packets should be forwarded by a linux gateway (firewall) having multip=
le interfaces also acting as a vpn gateway.

Test steps:
1. Disabled all iptables rules
2. Enabled the VPN IPSec Policies.
3. Start a ping with packet size (e.g. 3000 bytes) from a client in the DMZ=
 passing the machine targeting another LAN machine
4. Ping works
5. Enable a VPN policy by sending pings from the gateway to a tunnel target=
. System tries to create the tunnel
6. Ping from 3. immediately stalls. No error messages. Just stops.
7. Stop Ping from 3. Start another without packet size parameter. Stalls al=
so.

Result:
Connections from the client to other services on the LAN machine still work=
. Tracepath works. Only ICMP requests do not pass
the gateway anymore. tcpdump sees them on incoming interface, but not on th=
e outgoing LAN interface. IMCP requests to any
other target IP address in LAN still work. Until one uses a bigger packet s=
ize. Then these alternative connections stall also.

Flushing the policy table has no effect. Flushing the conntrack table has n=
o effect. Setting rp_filter to loose (2) has no effect.
Flush the route cache has no effect.

Only a reboot of the gateway restores normal behavior.

What can be the cause? Is this a networking bug?

Best regards,
--
i. A. Thomas Bartschies=20
IT Systeme

Cornelsen Verlagskontor GmbH
Kammerratsheide 66
33609 Bielefeld
Telefon: +49 (0)521 9719-310
Telefax: +49 (0)521 9719-93310
thomas.bartschies@cvk.de
http://www.cvk.de
AG Bielefeld HRB 39324
Gesch=E4ftsf=FChrer: Thomas Fuchs, Patrick Neiss



