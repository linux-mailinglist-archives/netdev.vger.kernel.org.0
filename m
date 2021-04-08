Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C181F358010
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhDHJ52 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Apr 2021 05:57:28 -0400
Received: from smtp.asem.it ([151.1.184.197]:58903 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhDHJ52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:57:28 -0400
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 8.0.0)
        with ESMTP id 387cdbc5c84c4bbc94fbe1691073a758.MSG
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 11:57:15 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 8 Apr
 2021 11:57:12 +0200
Received: from ASAS044.asem.intra ([::1]) by ASAS044.asem.intra ([::1]) with
 mapi id 15.01.2176.009; Thu, 8 Apr 2021 11:57:12 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Thread-Topic: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Thread-Index: AQHXIZ1I+hIGDbheQ0mjeo1QOr5hoqqa90yAgAE1elCACw/7AIADMTcA
Date:   Thu, 8 Apr 2021 09:57:12 +0000
Message-ID: <fe865a23dfd04b7daab5d8325f5eaba2@asem.it>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
 <YGHuhbe/+9cjPdFH@smile.fi.intel.com>
 <92353220370542c7acdabbd269269d80@asem.it>
 <YGw5xFdczcKGqW1v@smile.fi.intel.com>
In-Reply-To: <YGw5xFdczcKGqW1v@smile.fi.intel.com>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.17.208]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A782F27.606ED379.0033,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

> > > On Thu, Mar 25, 2021 at 07:34:07PM +0200, Andy Shevchenko wrote:
> > > > The series provides one fix (patch 1) for GPIO to be able to wait for
> > > > the GPIO driver to appear. This is separated from the conversion to
> > > > the GPIO descriptors (patch 2) in order to have a possibility for
> > > > backporting. Patches 3 and 4 fix a minor warnings from Sparse while
> > > > moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> > > >
> > > > Tested on Intel Minnowboard (v1).
> > >
> > > Anything should I do here?
> >
> > it's ok for me
> 
> Thanks!
> Who may apply them?

I used your patches on kernel net-next 5.12.0-rc2, on a board with an
Intel(R) Atom(TM) CPU E640   @ 1.00GHz and an EG20T PCH.
I used the built-in OKI gigabit ethernet controller:

02:00.1 Ethernet controller: Intel Corporation Platform Controller Hub EG20T Gigabit Ethernet Controller (rev 02)
	Kernel driver in use: pch_gbe

with a simple iperf test and all works fine:

ht-700 ~ # iperf -c 192.168.200.1
------------------------------------------------------------
Client connecting to 192.168.200.1, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.200.159 port 38638 connected with 192.168.200.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   178 MBytes   149 Mbits/sec
ht-700 ~ # iperf -c 192.168.200.1
------------------------------------------------------------
Client connecting to 192.168.200.1, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.200.159 port 38640 connected with 192.168.200.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   178 MBytes   149 Mbits/sec
ht-700 ~ # iperf -c 192.168.200.1 -u
------------------------------------------------------------
Client connecting to 192.168.200.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.200.159 port 58364 connected with 192.168.200.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.25 MBytes  1.05 Mbits/sec
[  3] Sent 893 datagrams
ht-700 ~ # iperf -c 192.168.200.1 -u
------------------------------------------------------------
Client connecting to 192.168.200.1, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.200.159 port 32778 connected with 192.168.200.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.25 MBytes  1.05 Mbits/sec
[  3] Sent 893 datagrams
ht-700 ~ # uname -a
Linux ht-700 5.12.0-rc2-watchdog+ #12 SMP Thu Apr 8 11:08:49 CEST 2021 x86_64 x86_64 x86_64 GNU/Linux
ht-700 ~ # 

I hope this can help you.

> 

Tested-by: Flavio Suligoi <f.suligoi@asem.it>

> --
> With Best Regards,
> Andy Shevchenko
> 
Best regards,
Flavio Suligoi

