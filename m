Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64A95876AC
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 07:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiHBFbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 01:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiHBFbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 01:31:33 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2071.outbound.protection.outlook.com [40.107.212.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA411E3C2;
        Mon,  1 Aug 2022 22:31:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQ9RB4KrulAhXpo+okZ6M6sPa0IwJJUoBe+xHPq5q9yRJK60u9V5SHchzo1jjjobE0xPiV9U4aqbCSN2nATgpdBYhXSWBWTty9nWtnav1Vytwj5aIREj8uffqEL9HWaXiT97qVdWHYgYr67blIi7tvrloBmd4AvW4rt/+uIfL5sNawRfRYoyePBXzjVk6LCciUL28NMwO8yaxl/OLj5HOsHyfY+mSyFai72SCkqxiQU6dwayfcsmyhbyE4c5WswT4cpEd1pzg2nZj+9UwoGmCEzeV7pTO+XM9DANRo0T4+W1nnrJVKWJ4JGnQzEYC9MlyEVwwVOXoF3HkSKGP6YHxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Bw9vNWnxDycufPy7lgFnIz3CCZZvq4e63znhIuyew4=;
 b=OCxQ2C2RUIul+ju1neQmuz6BdbhrfJEDaweTEUMxLCNfFpmsYAiQ2HNKnDNdKdSjnYFgWaleikcsX8CMRc9C8jxJ93htRFEul0ptcrkIx8eT83XcBKjFtNZkRGVBNGNMcX0xq5nogZZb2/v+Jd32ENSOp/x6CNixeCU5U2dsFv2jIp6ZWds1Sri8psyNt20xwi2G8Ewwid6ocClHC1MWpoRy+KLZOTZY0Cz9W4v0Ayzsvc9OzJYKULyi8e9j7HARjPFyEFjqL+t0bnu5RO74lvx67a3KXqEP9AfLsksxCVIyaaAo+gO1t63TxSuJwIsGslIqQ+b870/E8jDfeTsAmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Bw9vNWnxDycufPy7lgFnIz3CCZZvq4e63znhIuyew4=;
 b=v5JueGYYxp2Tx8bEDPRZ2injCb3bsiUKxXdvmXo08s0vAvS4GxD7eNOeaDdIuWmOBzB1LF/ioI4UNlc9g02LH3ltNniqWvLCi1LJenJUyvQQ71D+RLJmJtwHSwKUG9P5yBBnWgGVDZJEwP2VcRzg89iqdKuCJziDGLNF6T7uXCw=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by SN6PR05MB4751.namprd05.prod.outlook.com (2603:10b6:805:93::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.10; Tue, 2 Aug
 2022 05:31:27 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::959e:de9c:2ea:213a]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::959e:de9c:2ea:213a%5]) with mapi id 15.20.5438.010; Tue, 2 Aug 2022
 05:31:26 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
CC:     Stefano Garzarella <sgarzare@redhat.com>,
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
Thread-Index: AQHYobWftGqT6D2PPUyTyofbXSwoca2TTYkAgAfRQoA=
Date:   Tue, 2 Aug 2022 05:31:26 +0000
Message-ID: <B67A3903-3AF5-40D0-9887-F2253F55C7EB@vmware.com>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
 <d5166d4e-4892-4cdf-df01-4da43b8e269d@sberdevices.ru>
In-Reply-To: <d5166d4e-4892-4cdf-df01-4da43b8e269d@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6179d3fa-b5ba-4bd1-3d6b-08da74483eaf
x-ms-traffictypediagnostic: SN6PR05MB4751:EE_
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?ge+ruSwnfWT8A8hFoJgnNDOvaQ4I2FtGEGcxpzMiV/OCka/Y3Qha2WhSOmLL?=
 =?us-ascii?Q?/+HHDFVds9Y5VgDVCTfxb9mqXwFHNwPRHutKGL2qrurb6mDuJ29f60u6GdQC?=
 =?us-ascii?Q?UWAMy+3WrULijVe7k7fLLaPiix3ilhAOPqKOZDDsooBauDkW+zXpeNEYWz4W?=
 =?us-ascii?Q?mkCZnBFdlHSmMaofBFZ0HTA13YgDrojnITaZeqlofLBSK9xhojEJZKva11Yd?=
 =?us-ascii?Q?d3Jm+BBYhHe/b791NcOmYkyIPYFiY43ZzCFpc5FpWXRO1EDohrWX4zmw2HhS?=
 =?us-ascii?Q?yaaAdo9qa53OO5Y5WHbMfDAetgOBLScnX5RzSd7nQDCQnjpLGoY3FNUUe3MD?=
 =?us-ascii?Q?e+zmkJ7Cs6BpM37otS5aWXWUZ0/+NWUR31PMkNL+lZ4tUHPlmJw+ji0qFvDq?=
 =?us-ascii?Q?XiIf3rLS5XywZgTZKagdOLTtddDB1dNf/a5uRWGXrPR4C3mFSbeUqQqV3kTa?=
 =?us-ascii?Q?qQWdZixV1hHCMGLtS01rXzk8EUrAT8m5Jix6xG0Sgnwqf72eXqfbcncr35au?=
 =?us-ascii?Q?/pZcA1XyUrrcHyiapLHiYwQ2NFLKQ2lGhQDpiiiRIlvBceGGRsBx6HNDgSa8?=
 =?us-ascii?Q?htXMEL/bkSLbi/j7s+Ox/ULQmScrU7SDB5ZtmpAsToRRznq9Eqrx0OQ2LVo9?=
 =?us-ascii?Q?JT6F8DlI/hER7orh51YcwCDZk4v74yeHtEKcg8TRQU4wY7Y1t/zkqkAX96PD?=
 =?us-ascii?Q?G+5bp7P99HXcqGo8YKtzsV7VaW5sO3HU8Kudy14bx3yIQWYUwwGMIKeTVG2T?=
 =?us-ascii?Q?8JuTe5aqI4RdvUZ28vW8gOD6/RJQonJazBDiiFkz1oVdKT8Fkf3sIx/JiiO7?=
 =?us-ascii?Q?dUVQbRtdk8Kq1+EqytIRoF+Jf07MwlSarw0dzVAwxvnSqHVA+LuiuvS3ND8r?=
 =?us-ascii?Q?fIDwri6z50dh0DS2D54NZGnhJ+vn9GLfsm3XDn9vjadjQ7oV69tfwDDQLf1L?=
 =?us-ascii?Q?/2g7/olwqhWuGkggtTN1Xw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(6512007)(53546011)(6506007)(86362001)(41300700001)(54906003)(6916009)(45080400002)(316002)(6486002)(966005)(71200400001)(478600001)(38070700005)(122000001)(38100700002)(2616005)(186003)(83380400001)(2906002)(66946007)(66556008)(8676002)(76116006)(4326008)(64756008)(66476007)(66446008)(8936002)(33656002)(5660300002)(7416002)(36756003)(15650500001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TBnWskDXNrROHryx/Ltu2oicStT26GSDF6mHhbENCppR+mDR81bIqoQqEhvn?=
 =?us-ascii?Q?KkPf+eVmRxA35szghV2kBRzjh5l7ITFBIh6BMjXXKsxeLskqjfbCT5enTP5K?=
 =?us-ascii?Q?s9rZ996hOM1DmZ3oxQxa9HEre9f3Z08lVYGlSpLcf0+2VMuQX9BMgR5sGQ+I?=
 =?us-ascii?Q?jmV11nyQwfm2ElKE/YlChqaFdaRw/89CDO8HrwTNqEwuX9VkxnXLk6FNgf6r?=
 =?us-ascii?Q?EUmLQHivQDyNfoEWOIu5IIcBHm4rm1DTkg/Z+JgE+LlO0uHP0S/IX+K5BeHk?=
 =?us-ascii?Q?ZxirQr0XJrsHWVT10uKTpxYkHvKdYaTTcl/yL+Lh/ocmrb6STy4j7Nnlox31?=
 =?us-ascii?Q?7Vukh/L+XyDVdEwBV2WG0qn3yzWVic73zM5nONkP3jb0a+Vb1Kyj75BLWbrI?=
 =?us-ascii?Q?3br+TA5e3Woa9CZUJxYEPGT14052jq6pKl1/dD7eMwKn70Cm0Fbn68eInA1D?=
 =?us-ascii?Q?N9davl5O3TZEKRbm7tPo+ttlXtvxSMPRlor4U8RW5bbqY5bAeRWWj0XsTWeU?=
 =?us-ascii?Q?UZqJLWCvLYmNHzyMOrI9kheOB1jDUSe5yj4uewuywyCYT47CWNUWW+xaJkst?=
 =?us-ascii?Q?KAmY9wh+wOzJTk038xc39QpgNnsbCEWqzOmuiTG/IP5PO6TE7gNkVE86lP+U?=
 =?us-ascii?Q?23tLFmh1NBLqx0u40E+S9eWCgx7VVdBhet7D1kOfBWsEdBN4wYG5b7RpiJFt?=
 =?us-ascii?Q?yXfIDMm2/RMT5izsLvnnZ+LP6JbOHGHEFVRWjcoz1ysuT9UixKCwqluFa8G7?=
 =?us-ascii?Q?2SsDJ3Azl6dV5BXmXdo4FBgOl+j0IhxoIOouaxk/CNN9vCVj6l9cdMYFziNs?=
 =?us-ascii?Q?SA1M6dorvPIyFKAky6EF1ADT3idKFP/fYaekLUTfLk/mhws7FXuMnCzoq/ow?=
 =?us-ascii?Q?IdNFb/o9sKuAskNzkF0UAnKK4vMa9LFao3kE6NiDTyiATPOWGqyREE8qUUTl?=
 =?us-ascii?Q?eR1PoyyqvabPWZPEHhpcVC5huVF/fy/JHbUlOonscmIWODEzwXSPJY2v6wAr?=
 =?us-ascii?Q?r68EYJttBaqIx1SvqQ6JbAig54fjsovD+IY5I5fRxTlnxH6AQCfa79Hn9WRN?=
 =?us-ascii?Q?Ntayj0JEPT0I49vGHL+JIHFvCq8ZTo6Q/JuClxvGQejZ1rPyEfjDk2ncHvkV?=
 =?us-ascii?Q?jmst4b2966AXhr5O74D/T5JST+mDmcttF0Dt6+8ZqUCjLbsZvVRIVEeOuLnt?=
 =?us-ascii?Q?FvLC+YPKpt2FAmGsR8SwqYk3zFQYd9VMQToWlKeGr1WeZZ2ex0InLkKEWhYf?=
 =?us-ascii?Q?CqnDhdEcD9aw8ZrTeo2pIv3hwJma7EF6nquGlMTFcobXrZcBJOrOkKPXtadx?=
 =?us-ascii?Q?I0CjNt2YWs0o1XAaqwV2JroNiInAgQDbyXzJzawdNuGoPzVi+oAU5Z/pPZ/3?=
 =?us-ascii?Q?AMdzoJuyrO5XUHU4sBaMI96yqAtBtD8PIZpNPH+vOeBR9TIKpxQVch496D6t?=
 =?us-ascii?Q?NJAHfW3PfOFEZ2mocOolKC2hhO+3XlA9zCmyuogNmwl1dGLTxkP/5ILlPon3?=
 =?us-ascii?Q?LA+86T36B0BQa8yycF91oA2ihTlf8GnrEr/xf73p6L4r51aXVZwTQTIY6Y+Y?=
 =?us-ascii?Q?P2soqYWefoZf7ay4CMmboi9n0XMLdIjcvn/Vg3j50ZS8jC/+WxABNLFA7Df9?=
 =?us-ascii?Q?nY1gVmRFnBt4OtT4CKAT0y8Lt97jRIkQo7hn59vncwip?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <217F182527510E499A11E1EC6457B6CB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6179d3fa-b5ba-4bd1-3d6b-08da74483eaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 05:31:26.4329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qk39j9Y6/UjbvS3vTsEBy30ZGPPs3M75nu0c1zOigJHxl458+XtdVf3zehPqOKtjUGNw/qtO1rP4oAa2q9pTAg==
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



> On Jul 27, 2022, at 11:08 PM, Arseniy Krasnov <AVKrasnov@sberdevices.ru> =
wrote:
>=20
> On 27.07.2022 15:37, Stefano Garzarella wrote:
>> Hi Arseniy,
>>=20
>> On Mon, Jul 25, 2022 at 07:54:05AM +0000, Arseniy Krasnov wrote:
>>> Hello,
>>>=20
>>> This patchset includes some updates for SO_RCVLOWAT:
>>>=20
>>> 1) af_vsock:
>>> During my experiments with zerocopy receive, i found, that in some
>>> cases, poll() implementation violates POSIX: when socket has non-
>>> default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>>> POLLRDNORM bits in 'revents' even number of bytes available to read
>>> on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>>> POLLIN flag and then tries to read data(for example using 'read()'
>>> call), but read call will be blocked, because SO_RCVLOWAT logic is
>>> supported in dequeue loop in af_vsock.c. But the same time, POSIX
>>> requires that:
>>>=20
>>> "POLLIN Data other than high-priority data may be read without
>>> blocking.
>>> POLLRDNORM Normal data may be read without blocking."
>>>=20
>>> See https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fwww.open-std.org%2Fjtc1%2Fsc22%2Fopen%2Fn4217.pdf&amp;data=3D05%7C01%7Cvda=
sa%40vmware.com%7Cae83621d8709421de14b08da705faa9c%7Cb39138ca3cee4b4aa4d6cd=
83d9dd62f0%7C0%7C1%7C637945853473740235%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4=
wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp=
;sdata=3DNrbycCcVXV9Tz8NRDYBpnDx7KpFF6BZpSRbuhz1IfJ4%3D&amp;reserved=3D0, p=
age 293.
>>>=20
>>> So, we have, that poll() syscall returns POLLIN, but read call will
>>> be blocked.
>>>=20
>>> Also in man page socket(7) i found that:
>>>=20
>>> "Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>>> socket as readable only if at least SO_RCVLOWAT bytes are available."
>>>=20
>>> I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>>> uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>>> this case for TCP socket, it works as POSIX required.
>>>=20
>>> I've added some fixes to af_vsock.c and virtio_transport_common.c,
>>> test is also implemented.
>>>=20
>>> 2) virtio/vsock:
>>> It adds some optimization to wake ups, when new data arrived. Now,
>>> SO_RCVLOWAT is considered before wake up sleepers who wait new data.
>>> There is no sense, to kick waiter, when number of available bytes
>>> in socket's queue < SO_RCVLOWAT, because if we wake up reader in
>>> this case, it will wait for SO_RCVLOWAT data anyway during dequeue,
>>> or in poll() case, POLLIN/POLLRDNORM bits won't be set, so such
>>> exit from poll() will be "spurious". This logic is also used in TCP
>>> sockets.
>>=20
>> Nice, it looks good!
> Thank You!
>>=20
>>>=20
>>> 3) vmci/vsock:
>>> Same as 2), but i'm not sure about this changes. Will be very good,
>>> to get comments from someone who knows this code.
>>=20
>> I CCed VMCI maintainers to the patch and also to this cover, maybe bette=
r to keep them in the loop for next versions.
>>=20
>> (Jorgen's and Rajesh's emails bounced back, so I'm CCing here only Bryan=
, Vishnu, and pv-drivers@vmware.com)
> Ok, i'll CC them in the next version
>>=20
>>>=20
>>> 4) Hyper-V:
>>> As Dexuan Cui mentioned, for Hyper-V transport it is difficult to
>>> support SO_RCVLOWAT, so he suggested to disable this feature for
>>> Hyper-V.
>>=20
>> I left a couple of comments in some patches, but it seems to me to be in=
 a good state :-)
>>=20
>> I would just suggest a bit of a re-organization of the series (the patch=
es are fine, just the order):
>> - introduce vsock_set_rcvlowat()
>> - disabling it for hv_sock
>> - use 'target' in virtio transports
>> - use 'target' in vmci transports
>> - use sock_rcvlowat in vsock_poll()
>> I think is better to pass sock_rcvlowat() as 'target' when the
>> transports are already able to use it
>> - add vsock_data_ready()
>> - use vsock_data_ready() in virtio transports
>> - use vsock_data_ready() in vmci transports
>> - tests
>>=20
>> What do you think?
> No problem! I think i can wait for reply from VMWare guys before preparin=
g v3

Looks fine to me, especially the VMCI parts.  Please send v3, and we can te=
st it
from VMCI point of view as well.

Thanks,
Vishnu=
