Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13557CA036
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfJCOUK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 10:20:10 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:38336 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730457AbfJCOUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 10:20:09 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 46kZsH6txjzMtyv;
        Thu,  3 Oct 2019 16:20:03 +0200 (CEST)
Received: from SRV-EX03.muc.traviantest.lan (unknown [10.64.2.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 46kZs31gTBz2TS86;
        Thu,  3 Oct 2019 16:19:51 +0200 (CEST)
Received: from SRV-EX03.muc.traviangames.lan (10.64.2.31) by
 SRV-EX03.muc.traviangames.lan (10.64.2.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 3 Oct 2019 16:19:50 +0200
Received: from SRV-EX03.muc.traviangames.lan ([fe80::24a4:13fd:f7e3:12a1]) by
 SRV-EX03.muc.traviangames.lan ([fe80::24a4:13fd:f7e3:12a1%3]) with mapi id
 15.01.1779.002; Thu, 3 Oct 2019 16:19:50 +0200
From:   Denis Odintsov <d.odintsov@traviangames.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "h.feurstein@gmail.com" <h.feurstein@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Marvell 88E6141 DSA degrades after
 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Thread-Topic: Marvell 88E6141 DSA degrades after
 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Thread-Index: AQHVeRiR5JyXjvwWeUCkhMRfeb02DqdHI38AgAFYlACAADgRAIAAI18A
Date:   Thu, 3 Oct 2019 14:19:50 +0000
Message-ID: <FD60F87A-E338-4CDB-875C-67DE7A3B451E@traviangames.com>
References: <DE1D3FAD-959D-4A56-8C68-F713D44A1FED@traviangames.com>
 <20191002121916.GB20028@lunn.ch>
 <73A3CAFD-56DB-4E09-8830-606B489C3754@traviangames.com>
 <20191003121314.GB15916@lunn.ch>
In-Reply-To: <20191003121314.GB15916@lunn.ch>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.168.62]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6CD780067DDA44DB8843E30BE09A593@muc.traviangames.lan>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RMX-ID: 20191003-161951-46kZs31gTBz2TS86-0@kdin02
X-RMX-SOURCE: 10.64.2.31
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 03.10.2019 um 14:13 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
> On Thu, Oct 03, 2019 at 08:52:34AM +0000, Denis Odintsov wrote:
>> Hello,
>> 
>> Thank you for your reply, now that you've said that I actually put WARN_ON(1) into mv88e6xxx_adjust_link and found out that it is not actually being called. Not even on 5.3. What I saw was a warning produced by block like "if (ds->ops->adjust_link)" in net/dsa/ code, but not the actual call. My bad. So it seems the content of the function is irrelevant, and as I can see there are many block like this, so most probably it is something one of these blocks were doing on 5.3 which changed to 5.4, which is way harder to debug I guess. Any other things I could check in that matter?
>> 
>> Denis. 
> 
> Hi Danis
> 
> Please don't top post. And wrap your emails to around 75 characters.
> 
> How did you decide on 7fb5a711545d7d25fe9726a9ad277474dd83bd06? Did
> you do a git bisect?
> 
>    Andrew

Hi,

My approach after I've found the DSA no longer work properly on 5.3.0-rc1 that time was to compare dmesg of 5.2 and 5.3, where I did found the difference to be this line coming after DSA init:
[    2.812111] mv88e6085 f412a200.mdio-mii:04: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
Present on 5.2 and info about phylink being there on 5.3. Looking into where it come from I've found it to be net/dsa/port.c in function dsa_port_link_register_of in case adjust_link defined. I've searched to what happened to adjust_link function in mv88e6xxx code between 5.2 and 5.3 and immediately hit 7fb5a711545d7d25fe9726a9ad277474dd83bd06. With that commit reverted everything worked fine again, so I assumed this is some part that is not yet fully done for mv88e6xxx or my 88E6141 specifically and is going to be done later, so I just used 5.3 with that patch reverted.

PS. Sorry if I write something wrong, this is first time I communicate with kernel development so close, thank you for your patience.

Denis
