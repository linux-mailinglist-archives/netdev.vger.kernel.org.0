Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51921C9A3C
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 10:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfJCIw7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 04:52:59 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:43811 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfJCIw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 04:52:59 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 46kRbn468Cz2ynT;
        Thu,  3 Oct 2019 10:52:53 +0200 (CEST)
Received: from SRV-EX03.muc.traviantest.lan (unknown [10.64.2.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 46kRbQ5qZ4z2ywf;
        Thu,  3 Oct 2019 10:52:34 +0200 (CEST)
Received: from SRV-EX03.muc.traviangames.lan (10.64.2.31) by
 SRV-EX03.muc.traviangames.lan (10.64.2.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 3 Oct 2019 10:52:34 +0200
Received: from SRV-EX03.muc.traviangames.lan ([fe80::24a4:13fd:f7e3:12a1]) by
 SRV-EX03.muc.traviangames.lan ([fe80::24a4:13fd:f7e3:12a1%3]) with mapi id
 15.01.1779.002; Thu, 3 Oct 2019 10:52:34 +0200
From:   Denis Odintsov <d.odintsov@traviangames.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "h.feurstein@gmail.com" <h.feurstein@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Marvell 88E6141 DSA degrades after
 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Thread-Topic: Marvell 88E6141 DSA degrades after
 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Thread-Index: AQHVeRiR5JyXjvwWeUCkhMRfeb02DqdHI38AgAFYlAA=
Date:   Thu, 3 Oct 2019 08:52:34 +0000
Message-ID: <73A3CAFD-56DB-4E09-8830-606B489C3754@traviangames.com>
References: <DE1D3FAD-959D-4A56-8C68-F713D44A1FED@traviangames.com>
 <20191002121916.GB20028@lunn.ch>
In-Reply-To: <20191002121916.GB20028@lunn.ch>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.168.61]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <46FDA190BD510944A9CC09AB58928EF8@muc.traviangames.lan>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RMX-ID: 20191003-105234-46kRbQ5qZ4z2ywf-0@kdin01
X-RMX-SOURCE: 10.64.2.31
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thank you for your reply, now that you've said that I actually put WARN_ON(1) into mv88e6xxx_adjust_link and found out that it is not actually being called. Not even on 5.3. What I saw was a warning produced by block like "if (ds->ops->adjust_link)" in net/dsa/ code, but not the actual call. My bad. So it seems the content of the function is irrelevant, and as I can see there are many block like this, so most probably it is something one of these blocks were doing on 5.3 which changed to 5.4, which is way harder to debug I guess. Any other things I could check in that matter?

Denis. 

> Am 02.10.2019 um 14:19 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
> On Wed, Oct 02, 2019 at 11:57:30AM +0000, Denis Odintsov wrote:
>> Hello,
>> 
>> Hope you are doing fine, I have a report regarding Marvell DSA after 7fb5a711545d7d25fe9726a9ad277474dd83bd06<https://github.com/torvalds/linux/commit/7fb5a711545d7d25fe9726a9ad277474dd83bd06> patch.
>> 
>> Thing is that after this commit:
>> https://github.com/torvalds/linux/commit/7fb5a711545d7d25fe9726a9ad277474dd83bd06
>> on linux 5.3 DSA stopped working properly for me.
>> I'm using Clearfog GT 8k board, with 88E6141 switch and bridge config where all lanN interfaces are bridged together and ip is assigned to the bridge.
>> 
>> It stopped working properly in the matter that everything fires up from the board point of view, interfaces are there, all is good, but there are never any packet registered as RX on lanN interfaces in counters. Packets are always TX'ed and 0 as RX. But! This is where weird starts, the actual link is negotiated fine (I have 100Mb clients, and interfaces have correct speed and duplex, meaning they actually handshake with the other end). Even more, if I would set ip lanN interface itself with ip address, the networks somehow work, meaning a client, if set ip manually, can kind of ping the router, but with huge volatile times, like >300ms round trip. And still not a single RX packet on the interface shown in the counter.
>> 
>> So this is really weird behaviour, and the most sad part in that is that while on 5.3 with this patch reverted everything start to work fine, the trick doesn't work for 5.4 anymore.
> 
> Hi Denis
> 
> Could you give us the call stack when mv88e6xxx_adjust_link() is used
> in 5.3. A WARN_ON(1) should do that.
> 
> We are probably missing a use case where it is used, but we did not
> expect it to be used. The call stack should help us find that use
> case.
> 
> Thanks
> 	Andrew

