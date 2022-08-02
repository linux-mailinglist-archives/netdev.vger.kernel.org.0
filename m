Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD95876C1
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 07:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiHBFf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 01:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiHBFf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 01:35:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E69B26553;
        Mon,  1 Aug 2022 22:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGaaI2akrwQWK53uFa13aUaoiupK+usn325TMfaGory0zzTmW5iPhlpwtWAbgqTcbNwmQj24JuB7pxn55higlYjMDokRT89bk4RdOQhVyvQpq17R3wtyup7/CBEnkkx9hNlI6OJhqZ6L901agLVigvW8SoTjyFOMVu5XcZWMcuNMFadlz+eAf3A4Jzvlt5k3jxVKwuqVT95gwVQQRpIYRsRGZXOw2UvZzDVCBdhIz5cag197ip7hwNzp/Qm1x1JTn1HCUq7E5L5bUFVUzQWArbRqv03wdtk5O7g/XgPhSILaJC53/6WbdgYQiFuusyVrvtNJ9dd7Ci7MEcIX8RogLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qr/t5Nh4CSbxlIj4GTABGYi01Q4E4KGUJUXqE9AkrI=;
 b=FdW10OLkWPDaix3E5sKaXk0aoqQoyywm0WmDsKziPeYVpjo6O8GakUI8eJl/dNGlhr4LgYfq4kD3UatvGuhf07DUX8cHd5IzHJsoyJQ31aWCjgz6u1EOxzXtdPHOAV4jyDFalmAaZxBrYZSMOh4NX4uCEl6rGGslnd0oHP1bC6XVkg/59ULIdz88GZK1mxORCI00ZFDiiOnLr169AmCKmbzJEJVzYo7lzxwlckmEC5cwZxDZzcgBM3BcbLviLis9iTtvHQXP5tAFGyObF9IoRu/OxKr1QBPPZve1uj8LODbyKRu66F8I0zDIOYFoBacrkhinmuNWzREFi4W86swmGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qr/t5Nh4CSbxlIj4GTABGYi01Q4E4KGUJUXqE9AkrI=;
 b=yHB91SN7fgz6FBV0VC0AjzwstoOEpkMAeisKNwwyqTSDBf1miPO86Pk5+tSUSgvw/vnnqvCP9jTZ+zyzMx6n/IZ6yJIN+FFXLZ+ROZ6BAIfzmZLcuF23k8/2b2d8tVS1GgXN6HLY+kAQyoRmpLR+jDnu3W2n+B4FDbAcJ+KEYtw=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by SN6PR05MB4751.namprd05.prod.outlook.com (2603:10b6:805:93::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.10; Tue, 2 Aug
 2022 05:35:22 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::959e:de9c:2ea:213a]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::959e:de9c:2ea:213a%5]) with mapi id 15.20.5438.010; Tue, 2 Aug 2022
 05:35:22 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYobWftGqT6D2PPUyTyofbXSwoca2bH+UA
Date:   Tue, 2 Aug 2022 05:35:22 +0000
Message-ID: <D7315A7C-D288-4BDC-A8BF-B8631D8664BA@vmware.com>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
In-Reply-To: <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 419a3d18-6a0c-4689-a555-08da7448cb7d
x-ms-traffictypediagnostic: SN6PR05MB4751:EE_
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?wAuhAEdDs/Ykx5NtbTYFk4AC5gO6FSzyyEm0Q9GeFx7+GNGNGm8Qv5FHm43X?=
 =?us-ascii?Q?Rh6/k1/cMKpybboOUyPrgAYdW2IxBXgMv7tfFtIiSj1rHr/nwEnSo8/HKOjx?=
 =?us-ascii?Q?DIls2qyQbbGOII9AeRuHjEKpwpBI5G+1R/EIPunu4K35Kb/rVu+F5JShBMwJ?=
 =?us-ascii?Q?ODT9fbfXu1ttSAoCpe6paZX1iAXueOM9U2+MNGHubc8vpVSzMwTkEi/cf5xE?=
 =?us-ascii?Q?ANbNHlOr6f2oTumngfoRhSvHhlzlPgAic2QViZO9t19fZZ/oeFiBsHG2Bdf7?=
 =?us-ascii?Q?xHsR04e9p1pZZflHU3ot+VXskK1Cpqo8x4EFmoNyqIc0YdXH8PMhozCMlJph?=
 =?us-ascii?Q?AC6kYCAlE3NNqCuTVRCxWgqBYxa2jbRpgEDlU4SHuwbBikKQW3H5hgB2cJcT?=
 =?us-ascii?Q?fb3/ogsb1bUeC95+he9k45m85Y0w4yNd9lxnnBt4G8R19NB80Qsrl5qY+ymV?=
 =?us-ascii?Q?PXzl2qLem5NZRGxhln0ZG4NAhNK4V1bEExforlxRh0AA9kWG3lcTT+Hh3r6b?=
 =?us-ascii?Q?EDwJCuSR/xq2lluOUiFeL1DewGauI5sRS2E1hV/rx0x0E2uTENN265Qsj7tt?=
 =?us-ascii?Q?aG3HYiOSTcaFH0VXFYd3JDpb9uchFYk2OPbQ1MRLMOSWR9r33K2OISIaiIER?=
 =?us-ascii?Q?9vQ7ThaergcG8i8X5YZ4C8pF4UzLaUD20pGCBu+Bf0Swuh6BNqJ+0MImwlL7?=
 =?us-ascii?Q?5Vrsp2RrFJgKUZiL42lvvxmCe5EXvknWeugPR7h3pKNmMZM9lJMIKtHxnWjH?=
 =?us-ascii?Q?wfsc4vs1I6uj0c/LW971fw5kSSqnSgu56D9Es4x1O5DJUG1ZtL9rrID02owN?=
 =?us-ascii?Q?PcJx2CpwRLvbxyLvfo/9CUy1S2oOCQNYO5vP5mU4+NgM6/DvAbO6H68kXb1h?=
 =?us-ascii?Q?tN3BujVsFaAWQ3uaS0EISGhmTMy3aXRhxMEE508AvwqWXU7Lnj5rTa/Ph/Vv?=
 =?us-ascii?Q?WIEw0FJQv8/gjc6gvk+KnA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(6512007)(53546011)(6506007)(86362001)(41300700001)(54906003)(6916009)(45080400002)(316002)(6486002)(966005)(71200400001)(478600001)(38070700005)(122000001)(38100700002)(2616005)(186003)(83380400001)(2906002)(66946007)(66556008)(8676002)(76116006)(4326008)(64756008)(66476007)(66446008)(8936002)(33656002)(5660300002)(7416002)(36756003)(15650500001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oltrh0RmrEP8x7yTWQi8/GJhlOSgiLAyyBSpQC5MncH66+GqJ3FPacbIHb4T?=
 =?us-ascii?Q?mb9YSWAnOQArLma7+whY6I3LwuEAR1F5i2cVqPMQQsCkqsXU1/XLYpgk7mhG?=
 =?us-ascii?Q?T6EobU9QroliX7kVFPX+61bawcsJfP9EvTCetNXEXvYj3TvBVU46sJAQLnFm?=
 =?us-ascii?Q?zmjNk8qHXlMbyGHQhDPCSPDKjUvk7IorcrffaS9I0PVtGD0wgZNFsteD8mHh?=
 =?us-ascii?Q?G5Qs7WjfXXttiDIzPQUhhHSeAkdvOepg8FQjAG8HZosy48jOUXoNPQGByEU6?=
 =?us-ascii?Q?GSk09PSS25p8/bSs44HIw73dBqxzY2eBJ/gnGJwOaz0u8VLZnOnn8xEiHk/K?=
 =?us-ascii?Q?HTzdUDcj9vlghrBNaorQMlJU3mDWY+EH9CzMs10vYLleoegCwf237/hQLzUl?=
 =?us-ascii?Q?gw/XCN44UhSTwEgqJQVuun9c4dfBqAzWpCFMFy1HLIrDX4dJ2dUZgHrMr+mt?=
 =?us-ascii?Q?bUfJ8ND6th8LP8L66sIV0ubz3kUS2nf1bivR8RTkP3UphLaOqBYHvP0Jyj//?=
 =?us-ascii?Q?QnXmAEa/6QFBPKgb8vQhlyCRHo7mxxBZnhfgyIEp0cGFZzcmP9ijJmiuecYC?=
 =?us-ascii?Q?dz9tOIB83m4K3ucIvaNVasdJHUZTggqlRcPDrr2nxqcEF7SxawbCPXLoGC2N?=
 =?us-ascii?Q?UOq816hwIrU8jAeU14kZkPaVfoDWUD2+lAa+Ar/2oENEX2BtlKXk1fQR8xcX?=
 =?us-ascii?Q?JHiHoVVvCTEiIW8rrbzQ9+tNyx0BxUjznEVErZvL6WV6CX+QdEeR2ZP3VgmA?=
 =?us-ascii?Q?Z2S5VfhZC1eC4KJfWcTJXO311bziaa/u4ScsUhwRRGLdmStQxcVwNp3tWhvi?=
 =?us-ascii?Q?BJ96NZO9iEDD3N1pNgRHUGEHcYaHzsDx9QTy7JF+XHpA2du0avklMwr8BRnh?=
 =?us-ascii?Q?Ld/K4hRTFkzyBF/0sQCzgoZLHCjQaDV9uQF5rVhHy7R7xpEHUdOATX7ngR4d?=
 =?us-ascii?Q?gemPSBAyBSuu02XSHvqfNjG6Lu5VZ90VlwFO23UbJhB+XzBT5fnRgfAZc+H5?=
 =?us-ascii?Q?/+JZD+BNx5EXeB0JlO+S29D3NeR/utAdRpzXcPZUUCXCoVTma1eY3Z2Jbljv?=
 =?us-ascii?Q?B4KvuvoAMW0nwj4EzA1zjudHx7PphmlYaq049ysxPCtN5oJ0aO6RCvSKTAlZ?=
 =?us-ascii?Q?68ebP0rToMfKhpi6X5kdb8GEB6s7YVly/iA0F7/OiFxFn4H9tKsD7GRvaVAP?=
 =?us-ascii?Q?drqfAG+E5oWHrYJpTX4ocka6zyEf/0rbsn/hACl7ccL41ABKxyTv1FHRg1Aj?=
 =?us-ascii?Q?YDVcX9NX1ydnoKFE+emXPEpv/EMWUi79E1qTi8DO6BSk235aQRwHZWQvdF/b?=
 =?us-ascii?Q?++iJYcEl6zOpackEqFa3C0xKhewhLV80CsTVwFAVLdI6a/HNqhIpB8Gm/mMi?=
 =?us-ascii?Q?XUzpotNbQtx/v5p8Rtp5noUwGeZuOZe14W8BkGCTD3EDjf4nrNZKAPwQ/5c0?=
 =?us-ascii?Q?k4rUd3FPCSu1kK4CBSub5VFTRbySfi0mRY9NZ9VGEAgDD/ARpqYw6W0Iunvk?=
 =?us-ascii?Q?+eapmIwKtlUEsTXrBZCzo18ldHz3ncMuJLqcJV6zpjqNPlUEh68LDMOxEDWD?=
 =?us-ascii?Q?ZgfxD7py3Wx3VNO9bU3dl2lMPSGVgjknZwlthedEbWtrxSm4Z+N077OHt+dz?=
 =?us-ascii?Q?G4XOxY0+cCpml936gJ9oHL9GBjYTD0jl7gWJeHFls4fd?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54ECB86CAAA4F941BE14BA597B924194@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419a3d18-6a0c-4689-a555-08da7448cb7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 05:35:22.6666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0QZAxhVZYd4Ao7IZr8HlRyS5EWqjaSq0dPsReIyDaGaGLJ/pAGUAAl+9kRyxTl/FkHo0SVLS7yJ5aRwKtk2gPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4751
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Jul 27, 2022, at 5:37 AM, Stefano Garzarella <sgarzare@redhat.com> wro=
te:
>=20
> Hi Arseniy,
>=20
> On Mon, Jul 25, 2022 at 07:54:05AM +0000, Arseniy Krasnov wrote:
>> Hello,
>>=20
>> This patchset includes some updates for SO_RCVLOWAT:
>>=20
>> 1) af_vsock:
>>  During my experiments with zerocopy receive, i found, that in some
>>  cases, poll() implementation violates POSIX: when socket has non-
>>  default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>>  POLLRDNORM bits in 'revents' even number of bytes available to read
>>  on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>>  POLLIN flag and then tries to read data(for example using  'read()'
>>  call), but read call will be blocked, because  SO_RCVLOWAT logic is
>>  supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>>  requires that:
>>=20
>>  "POLLIN     Data other than high-priority data may be read without
>>              blocking.
>>   POLLRDNORM Normal data may be read without blocking."
>>=20
>>  See https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fwww.open-std.org%2Fjtc1%2Fsc22%2Fopen%2Fn4217.pdf&amp;data=3D05%7C01%7Cvda=
sa%40vmware.com%7C5ad2c6759fd8439e938708da6fccbee4%7Cb39138ca3cee4b4aa4d6cd=
83d9dd62f0%7C0%7C1%7C637945222450930014%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4=
wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp=
;sdata=3D60hG3DiYufOCv1DuufSdujiLEKDNou1Ztyah3GPbOLI%3D&amp;reserved=3D0, p=
age 293.
>>=20
>>  So, we have, that poll() syscall returns POLLIN, but read call will
>>  be blocked.
>>=20
>>  Also in man page socket(7) i found that:
>>=20
>>  "Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>>  socket as readable only if at least SO_RCVLOWAT bytes are available."
>>=20
>>  I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>>  uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>>  this case for TCP socket, it works as POSIX required.
>>=20
>>  I've added some fixes to af_vsock.c and virtio_transport_common.c,
>>  test is also implemented.
>>=20
>> 2) virtio/vsock:
>>  It adds some optimization to wake ups, when new data arrived. Now,
>>  SO_RCVLOWAT is considered before wake up sleepers who wait new data.
>>  There is no sense, to kick waiter, when number of available bytes
>>  in socket's queue < SO_RCVLOWAT, because if we wake up reader in
>>  this case, it will wait for SO_RCVLOWAT data anyway during dequeue,
>>  or in poll() case, POLLIN/POLLRDNORM bits won't be set, so such
>>  exit from poll() will be "spurious". This logic is also used in TCP
>>  sockets.
>=20
> Nice, it looks good!
>=20
>>=20
>> 3) vmci/vsock:
>>  Same as 2), but i'm not sure about this changes. Will be very good,
>>  to get comments from someone who knows this code.
>=20
> I CCed VMCI maintainers to the patch and also to this cover, maybe
> better to keep them in the loop for next versions.
>=20
> (Jorgen's and Rajesh's emails bounced back, so I'm CCing here only
> Bryan, Vishnu, and pv-drivers@vmware.com)

Hi Stefano,
Jorgen and Rajesh are no longer with VMware.  There's a patch in
flight to remove Rajesh from the MAINTAINERS file (Jorgen is already
removed).

Thanks,
Vishnu=
