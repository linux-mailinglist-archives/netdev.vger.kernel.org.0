Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED76D10F6
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjC3VlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 17:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjC3VlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 17:41:02 -0400
Received: from MW2PR02CU001-vft-obe.outbound.protection.outlook.com (mail-westus2azon11012013.outbound.protection.outlook.com [52.101.48.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E384D336;
        Thu, 30 Mar 2023 14:41:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlBWeesxxEon9XPEC9ozVvjON72ERgpua/+Z4RfoFeFQFTsK2pj6dWtwtla7tqPdt+t1bcPEV2dL+lW9TSlkgQcNctobGX3Bg3PXqexXlPOesU0cNJ0dy3ZF8PMj7vxxbbKN/Yl63fIcfuUg0HElLh3pm6PVeumavr56i7oYqf2KjLhZ+YNKApgVO85dQG5QAhMFLiE0vfazXflbf0gBd+vvxKAxa3zxEH+FHTSEOec0CvycwGld3CtnOxFPKrSqS4YEdCGPcRvs56Yqmd4T9YSip2g8Hkz14KqwsVg0D0HramevhMwviQ1utinmmySPRFzXrPUKyEWfr6ehdnr1wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s8pSdprqMAia2K5up+hrU7fzanQumzprwBfixDqBHI=;
 b=EdkmOBlKIxiO272+Q3F6MYCqb5fGMrSGVlHJSJHrQwaip+D6SM1FcjCD+VlHd037EZ3819N1PhYgZVE5g44Xeiios7rMDtjmHSd3GXP//A1VnxNyYlRYUzmz/6mCu/UFbWdN2EmGalCk4sTO7Z8bWC84nHnXzl/VFJh5YKpVLui2nSm+oi+WvWEu6lKVG/awML79CZUUVwMEShdAfp6GbGsd4/1fEFeeXAwTahyTz74p8Ge1DeafBlVdxNuYJTbKeNsGlxECIpUKBpzSRoZLi/F+72mLAY5dus0Zw6odcpc0fO8MGG1GtnjkkNAe24UOPZYOpAnPiyZo1WgxHSlfBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s8pSdprqMAia2K5up+hrU7fzanQumzprwBfixDqBHI=;
 b=EP8K5H64IjY+Di5farf8aTSg9X2RAHMGexailOMGLe8bHSnOyUTaNbkUuuMP6bRQ1Q8oY765o9UxRndIMuUF4/w7SE8HcJ8JbaPD9jdQjsMNCzcm3MH1E+jlA9yA+xtZlIAHXyvNlV2FBQqWzz9FseNkrUqu/fTKK2NbITF+raM=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by BY3PR05MB8481.namprd05.prod.outlook.com (2603:10b6:a03:3c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 21:40:56 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::8cb8:9578:d0c0:83d3]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::8cb8:9578:d0c0:83d3%7]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 21:40:56 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@sberdevices.ru" <kernel@sberdevices.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>,
        Pv-drivers <Pv-drivers@vmware.com>
Subject: Re: [RFC PATCH v3 1/4] vsock/vmci: convert VMCI error code to -ENOMEM
 on send
Thread-Topic: [RFC PATCH v3 1/4] vsock/vmci: convert VMCI error code to
 -ENOMEM on send
Thread-Index: AQHZY0R9k4VKb4Rnn0Sv+wxENPcUEK8T2giA
Date:   Thu, 30 Mar 2023 21:40:55 +0000
Message-ID: <728EC7B8-4187-48AC-9FA5-EC757B72FAAF@vmware.com>
References: <a0915a9d-ba41-5a90-0e16-40c2315f0445@sberdevices.ru>
In-Reply-To: <a0915a9d-ba41-5a90-0e16-40c2315f0445@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB3960:EE_|BY3PR05MB8481:EE_
x-ms-office365-filtering-correlation-id: 2a70be3d-3ed6-417c-e09c-08db3167718c
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vL9J/32jto/d06b7qvlfKbadnW75dVMjPSX4jUxq5dOk9IN9XcpSJFB7Z1iuRoNOV8KzkXucruaRFVCuT7jzxYvYKyfHbDh1J2cEFAcYcCR5lpbjwtFpy7F7fi9xwXGRQxi/EfAgPfoPKMCB9xFTkbFYdv/ds/pibl0U1HR7t2q+2HkJqTLDeJ69f7EXezzVjvMj1TutJlm3lzVMw1DZvaa15NZ3fDfbj197VAPmnqFU2YGTFgUdu3KdZrAoyp9Pi+2KiN93Nsc1PNPcSh4Bt8dVpqOHShgHnVx1eDyaWuSsRPNXCktCiEwTvz1dKAYbvbo8ixoB72/AM6yWZfmPBEvcqBhKTgbbn4QXPr3yFrJBaRt74ykV1K74IMm4brzALqPXV65ZVsiCTHc8UUTaklDSKIXy/dnRTnp0x4udFR7O9FmuVMhn+O/jr+TTCVpi13WZJ8E3MH8Qyn/i01ky3VBQ41EYi0pMUUsA2zdTf6U+/hPO43I8NpgCaWBxdXJxlQ2Y1qqtzMkGKVbXGppPFakN6jPYmT+9c7fzuJsfySXYFqC1IpSj54kYPwBlnlJ+yrLgAjDo0BJabaLn5gUNvS7cxnQ1oj4GU2z1Zw8GpiL5gS1s5kEmjSNe5w3iRAfrQaOSPu6ESH0wExBN1aOtxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199021)(83380400001)(91956017)(2616005)(6486002)(54906003)(53546011)(6512007)(71200400001)(478600001)(107886003)(316002)(186003)(2906002)(6506007)(5660300002)(8936002)(76116006)(7416002)(38070700005)(38100700002)(33656002)(36756003)(122000001)(6916009)(66556008)(66476007)(8676002)(66446008)(64756008)(41300700001)(4326008)(66946007)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mfqRiTpQo2X7gugAaG8fdKqMQnaxXN77V6XDWCBmpfnlODMP/PGXwAcXZLbP?=
 =?us-ascii?Q?hcpGx/i9jlJDYGkdOSc4b2/p0i+LfGV/5pAbhjr7PQpmYIpIY2E2EuS695mZ?=
 =?us-ascii?Q?vJmcymKWo50YJDJbQ9zHaLacwbjUb1RzoujdLZUs+c32GkhFzBjLvc2NSAa+?=
 =?us-ascii?Q?aJ0m6KHtTusDPmJumhl+TY3My/yCplLpmGRotpeWY84U4QLs+SYWlPd7yYH3?=
 =?us-ascii?Q?wzWaZwFnieluZkQYwAX25T43tDFsfAUp2aJ2AKbrKdDnNcmAqXGaFhvw9oqS?=
 =?us-ascii?Q?93UPk+kiocbK4QH9lD2Jkh+eKsdYxTaMT95LYI8QIaRYPruNDhhOX8gjttIL?=
 =?us-ascii?Q?CMPckCMbUtq4CF9c8d2OVB0OIw3kH0LBpjzUKHdZ3Z/yXTHM9cXVCHKvz9ft?=
 =?us-ascii?Q?Ix0oDva3l9p8BTsRhGDdNUd2JI9r9O5ur+6tpAMJLl0rOGFioWGkTWVQKzID?=
 =?us-ascii?Q?Vd5TiAl7FMjQ9C0gXU6dquhRN/Z2SAWOMDcSYp25osqCUoJ1yjxjRaM4t4Tm?=
 =?us-ascii?Q?hnt1beCF0Gr3F8SQMgR+hgLAqeCjp/xYgOxsU7C0mR96SeTiChGQH9M+YeW0?=
 =?us-ascii?Q?xFE9QLxsyWfrE7OEqtAYMKzMOQ4JolNBNrNZKOOKOCKOse4gvWXbfkmKgPCp?=
 =?us-ascii?Q?6HdGstWhiKde7e/5lyuHuOa3n8F0BEuLPtNa9+JJWJjh+uqhVfWUL7q1tkwe?=
 =?us-ascii?Q?JOhPXFx45RcJ+ya2m9RtGB35cJu1TBUlYBs31ff4OkyDbheBA8lPEP5ugK/N?=
 =?us-ascii?Q?drSO/w/ZodfCs6THJfSSljfjnuYsuZguTRAfEPNKxAjKiUnDktxLPjMwXlXy?=
 =?us-ascii?Q?2LdgRJ3IBCr+G3pEnbajT/JJw8j6B3sV8cyg4qKwfj9tKJzDvHkIdPu+pc2z?=
 =?us-ascii?Q?clbd/rk2+ghUJ6Qq4yo2dkjS2S7mym4AGDGS73K1G3ooPi1CWUQ3wbTzuF8t?=
 =?us-ascii?Q?QXKqL416MZaBRK8SS6afsT5JhmwqP42N7qnPORwK3o7jZNXi5ugnSEkAnX9F?=
 =?us-ascii?Q?yxFa7G/vWusCZuRH/e4vdAWgbpW2rZBKHmAvr+k6WKrUuuTKHAugOyvYpxl0?=
 =?us-ascii?Q?tpGtEcrELy35l+dOY3MbnPcRagRY0iP7si85ON7V+9GAXXDIxRQrGc21M7eh?=
 =?us-ascii?Q?n6FvAPAzeS5Vf1pnZC7oqcseatHCD50c5e5Ww5fLM8H89v6EWXGzPJQWMLT3?=
 =?us-ascii?Q?Um+PKltrYNtto7oKHzs/iHCGpyU7W5I98FV+ujVMi28fymJt2UkqVGLh1DkW?=
 =?us-ascii?Q?oMjoRyCKNMssypjWvrNLpBi0MLUEPHf/YtULesRlzcYssjnWaUhBIP/Eyh08?=
 =?us-ascii?Q?6cQX4TlhBSFT1L4oteNu4XDe1noTk7+Rm80Dc+Gg/HELU+WL7QSySCxLPqRx?=
 =?us-ascii?Q?JCl8T0Sr8VUiYEzJeeywRO7o/XZEuNOjqcMDsYAGwwHAvPzhM4HP34J7LACb?=
 =?us-ascii?Q?/uQv4EsyqwJmG6Bz02XdIsLdj/AkNkRgiwo74cJB21VzpWyO6qpnLHs5n6x4?=
 =?us-ascii?Q?Sl4wVfIYpP1sBgwrnGdByQ467ZHQn+sKumHA0OEbak1wTi5e8iaNvLPKpLxz?=
 =?us-ascii?Q?JJDf2Rqedo2Fwv9yTS5V4UKkl+Vith4QAUkq0fFj1MxDX8l2BZJLbERoPPFw?=
 =?us-ascii?Q?HEYh9WI9F2cTplUELp78ZPiH5RjNrS/zD/q+gaHvEx9L?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <07F523487DDF6F41AF6F43243A6AD33B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a70be3d-3ed6-417c-e09c-08db3167718c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 21:40:55.9514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2WxMxGCcQWHyGf6ldEowWyEvjKS0wZdRvNmVoDO6+wPI8QTgNJt5IyAt6msZGPUUtxoW4I4KZQzxMV9XnlknSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR05MB8481
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2023, at 1:12 PM, Arseniy Krasnov <AVKrasnov@sberdevices.ru> w=
rote:
>=20
> !! External Email
>=20
> This adds conversion of VMCI specific error code to general -ENOMEM. It
> is needed, because af_vsock.c passes error value returned from transport
> to the user, which does not expect to get VMCI_ERROR_* values.
>=20
> Fixes: c43170b7e157 ("vsock: return errors other than -ENOMEM to socket")
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

Thanks, looks good to me.

Reviewed-by: Vishnu Dasa <vdasa@vmware.com>

> ---
> net/vmw_vsock/vmci_transport.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transpor=
t.c
> index 36eb16a40745..95cc4d79ba29 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -1842,7 +1842,13 @@ static ssize_t vmci_transport_stream_enqueue(
>        struct msghdr *msg,
>        size_t len)
> {
> -       return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
> +       ssize_t err;
> +
> +       err =3D vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
> +       if (err < 0)
> +               err =3D -ENOMEM;
> +
> +       return err;
> }
>=20
> static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
> --
> 2.25.1
>=20
> !! External Email: This email originated from outside of the organization=
. Do not click links or open attachments unless you recognize the sender.

