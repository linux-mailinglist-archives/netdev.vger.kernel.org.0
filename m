Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7EB46025B
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 00:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356522AbhK0XXh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 27 Nov 2021 18:23:37 -0500
Received: from mgw-02.mpynet.fi ([82.197.21.91]:60846 "EHLO mgw-02.mpynet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhK0XVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Nov 2021 18:21:37 -0500
X-Greylist: delayed 1938 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Nov 2021 18:21:36 EST
Received: from pps.filterd (mgw-02.mpynet.fi [127.0.0.1])
        by mgw-02.mpynet.fi (8.16.0.43/8.16.0.43) with SMTP id 1ARMiqPM035292;
        Sun, 28 Nov 2021 00:44:52 +0200
Received: from ex13.tuxera.com (ex13.tuxera.com [178.16.184.72])
        by mgw-02.mpynet.fi with ESMTP id 3ck98j8gh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 28 Nov 2021 00:44:52 +0200
Received: from tuxera-exch.ad.tuxera.com (10.20.48.11) by
 tuxera-exch.ad.tuxera.com (10.20.48.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.26; Sun, 28 Nov 2021 00:44:52 +0200
Received: from tuxera-exch.ad.tuxera.com ([fe80::552a:f9f0:68c3:d789]) by
 tuxera-exch.ad.tuxera.com ([fe80::552a:f9f0:68c3:d789%12]) with mapi id
 15.00.1497.026; Sun, 28 Nov 2021 00:44:52 +0200
From:   Anton Altaparmakov <anton@tuxera.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Guenter Roeck <linux@roeck-us.net>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v3 0/3] Limit NTFS_RW to page sizes smaller than 64k
Thread-Topic: [PATCH v3 0/3] Limit NTFS_RW to page sizes smaller than 64k
Thread-Index: AQHX46W2dvlin3Ey2EOJlJkpsU4ChqwXhYiAgABNKgCAAAGjAIAAA5+A
Date:   Sat, 27 Nov 2021 22:44:51 +0000
Message-ID: <6175371C-AA85-470A-B7E6-5BE8F2D471E6@tuxera.com>
References: <20211127154442.3676290-1-linux@roeck-us.net>
 <CAHk-=wh9g5Mu9V=dsQLkfmCZ-O7zjvhE6F=-42BbQuis2qWEpg@mail.gmail.com>
 <228a72fd-82db-6bfe-0df6-37f57cecb31a@roeck-us.net>
 <CAHk-=wjaVwrf1OQbDSbk1FxqzbtAYQLx16D74TeagXQyb5oEEA@mail.gmail.com>
In-Reply-To: <CAHk-=wjaVwrf1OQbDSbk1FxqzbtAYQLx16D74TeagXQyb5oEEA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [81.154.174.177]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D2931A9066944C4BB32AAE9301A50167@ex13.tuxera.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-GUID: TFeZmLzu2G1b3r3x_II5jkZNKw0heigq
X-Proofpoint-ORIG-GUID: TFeZmLzu2G1b3r3x_II5jkZNKw0heigq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-11-27_06:2021-11-25,2021-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=mpy_notspam policy=mpy score=0 spamscore=0 malwarescore=0
 mlxlogscore=640 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111270133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus, Guenter,

> On 27 Nov 2021, at 22:31, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Nov 27, 2021 at 2:26 PM Guenter Roeck <linux@roeck-us.net> wrote:
>> 
>> Either way is fine with me. Either apply it now and have it fixed in -rc3,
>> or we can wait for a few days and I'll send you a pull request if there
>> are no objections by, say, Wednesday.
> 
> I'll just take the patches as-is and we can leave this issue behind us
> (knock wood).

That sounds good, thank you!

Best regards,

	Anton

> Thanks,
> 
>           Linus

-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Lead in File System Development, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer

