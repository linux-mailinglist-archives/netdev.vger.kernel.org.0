Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6888D69E33D
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbjBUPUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjBUPUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:20:31 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEB92006B
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:20:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXAad1ms0XziBLlHy6gngawXlUX8ArvkPFs8ZTESTEUPnbAARrAuT/hHnDnt1Lyow3YsHe0ATplgdNkwVpjSMr4ZKXfEeWAyfZIkk83zMF3SUKkz8Y6PL5tFB0ntcajnsjRms4NzaydHDFll0K9r1UyeoWJr/Zj8PoxOg8SqcWSVQprZ9KbQNiOU7h4/iQzzEYRcKO8yVO+e0YvCVomvzkGx9EFGPPfHdnlHMz197vkROK9fcCqNtJkXvZX0HcK4yXa/X5S8b8ntTRS9aJFBP9dRnK02wM1opnZ8ITuLujdwXcI4fKjBQRQlZnZ0zEE5XFbLiFft5CwDkVnPNGZToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQevnE0zW1zw10H/HEwbx0OdKIDOUPeR6lG6ELhZQIs=;
 b=OziYiCDiXtZtXl/q9GyZSI4qEUsqqklN0UmvN+dSZCiPZuPgc7Wr+W6hDCrWuqMZyWb7WI/lPseng4kDpdDnufhjtfUb76bZjUx+eAFWgt3jB4poZgk3WGVg9tN5hyK3rjtFEoPD5O/1JWiMydCRUJq8H0FHLW9wjLj7tCyMgeEr4qgmhP8QN80wYTmkpqhNv3bsWsVsrAkUY93XltAeuLb5u5oh3vQQSxPByaSSvSbynZjfNY4fruCfwl7tjW3Ess8tZiCryOOVBRe08mhyweBpHGjzgrqiRN7YsmBSpcXdSBd2umNizkY2V+G1VWbtT5IO5mzrRAI6nBbUDOXLBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQevnE0zW1zw10H/HEwbx0OdKIDOUPeR6lG6ELhZQIs=;
 b=iZGWbq7rFwOJoZ+l271G2NE/ziImpVz3fzfp6zQRAyf7RVf8C3bnWegfL8U46RDka8cZgL8n+cO27N7UEYH3+vZ2luTqJLdIdn+l75Q+525i/fec3fKoROmNMN5F/nPEbciwnAnOP5RqAvEhsrVSJB6KAqR8ndx8b8XcAwT6ufzirWOG3QqG2Lm52dpdNJsjdjjzC6BZIPKxVnyPshG6T7F5uXyb3bg82kZgEkbfPKvqKFXfQ8uGDYfCUwP8LVJGznA4l2Ig/+IQRgteG+J96FUnswUIQiQ+ZX6HlVfqJd0Cy5n6mut0RAtlqd2fF+amNyAFo5PvahZW7kiD7O9pXA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY8PR12MB7489.namprd12.prod.outlook.com (2603:10b6:930:90::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 15:20:28 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::ee61:8dc4:14c8:7cbb]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::ee61:8dc4:14c8:7cbb%8]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 15:20:28 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "alvaro.karsz@solid-run.com" <alvaro.karsz@solid-run.com>,
        "vmireyno@marvell.com" <vmireyno@marvell.com>
Subject: RE: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Thread-Topic: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Thread-Index: AQHZRgN1fdzfpktrkUS2o3N/6zXmMa7Zf6Jw
Date:   Tue, 21 Feb 2023 15:20:28 +0000
Message-ID: <PH0PR12MB54812E132459F4661B07492EDCA59@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230221144741.316477-1-jiri@resnulli.us>
In-Reply-To: <20230221144741.316477-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CY8PR12MB7489:EE_
x-ms-office365-filtering-correlation-id: b3fb66e4-64aa-44c9-cd4f-08db141f29ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZiIH48bL8pXh/AqPmr+o7hyaCdsz+ud+iev1Qj4Ndykf5cw/RwMc2G3y+GK4AzElo0e/I5NKFSToypi7VFxBNAhy+cCXpI/kjJTKlarIZWAZK52OKiv8xiSIWH0pZYCzFULNpBCmzzBYXwgY4n9F+1J9PhlihmDafcP0sDIQnW7Xh/mPF0pCOPfewqJGGhINE1e4TTAv6u8x72l41U4F91YTbCwce0UYlDh9eYoB4GLMi0touCZO9yOjuPob0Z8XWRw9HRVADlzi0TC56Wk78YugBtvANyogkS5cm037zQjkfJtfNJB/ed0jWp7sFjhz6w3vVGc0ibifyu3DpponI+PEin+6q9Gk+sZNoeP7gpFOwDqKfq4I8o2SK2AjK+zPKEppxqq7uQdKgbkBjDWu1c0LmrMpMC6rL/pD/56bfB4xsbbMG2uRIuB9Ms6Dhymj9qLOc4+tAl9ZtSvRsqnc5uel8PijuUtgmPsar2ogrbXyDOMRA9ikckDLYBmYnUVzN8oFU5F5bYEgDPFcmGsS2OTP4fBDQ/8ejmUsKc2MlrI8rs3YyQO/WQ3A07oDxFjDP0RLZLg8O/oV53cc6e4WZCFiS0d9W0WqZQxVsHRCB8rNNeJWu+l1m+fdz4drvIdRUnDFtbH/LZIMvw65+07ZhcWQGHXu39tyAvEbYa/ZHF+w+0xqWczY3Fr/BUwQ4t5s5Ij2iCREWUR/1B8zK8CYPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199018)(52536014)(7416002)(8936002)(7696005)(66899018)(83380400001)(2906002)(5660300002)(110136005)(41300700001)(316002)(54906003)(122000001)(38100700002)(76116006)(86362001)(66946007)(8676002)(64756008)(66476007)(66556008)(66446008)(4326008)(71200400001)(33656002)(55016003)(26005)(9686003)(186003)(38070700005)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9hOdTIOGjkYGaNGsjsKCxTZRBYKP6unIKhEzADwQuotpW/bdvsICPdRtePxw?=
 =?us-ascii?Q?cdAJqI2N+Y3DQgQrjNlIc9CdzxwiBzmjPskHMzjkcgci1rxW4JXq02+NIF6e?=
 =?us-ascii?Q?0HnA06C4WwPsZiXgivJT9JBCJe7wAtmVfHr6asqzQpk1xN+4kOxQNNtL3+xn?=
 =?us-ascii?Q?OAT2LMZd4bUxE6/e3PCkT4ANpbohF55013arBbTcKV/Md69KQFWpU8IRoqFo?=
 =?us-ascii?Q?qmBoARvaYiF4m1bJfPgnWMPLJ7qWP8/8TVMdLkOt95IOkoLZ6jG7EXJV0fk7?=
 =?us-ascii?Q?pXJW3WDCFnuuCRA0i4G5lgUwCyV4/fz5amxi3meevyEItUeMUd/qfk1ghp56?=
 =?us-ascii?Q?8ngamDiaHd73xN9IIZGRkLrDCzzz9eE0x8EB573RKhL0ylu/isCnwApD7Q/E?=
 =?us-ascii?Q?RzhYu9Kqs5ifRDJZWIm3X3R0eGzwFc8esO4iV25B61qrGfCyc6aU0eOn9Ibq?=
 =?us-ascii?Q?TsQZa2gnIWy1t9eYiyISG0eOo8MLz2kVULBgBoloei+nloWLSfvXBcPluf7s?=
 =?us-ascii?Q?QH48+lf1M7r6L2+e93qRmiUfny6zB2G8uK5n8E8LYLOb3O/Z4Q1iNZKAuU+D?=
 =?us-ascii?Q?9Tg+d9zzRg2XdD/Eges8cA5EWYaR+VH/sXqJcBYemnkPapLRCkEURqprN/fE?=
 =?us-ascii?Q?LC+BjcknI5bFXJWa/WcRduWXbXI3GTQ+HeFT4DdfteIW2abkUZCI+b4jme2Y?=
 =?us-ascii?Q?GndrEK/LY59ETHvgFRG6irF3BLUWunoAxPfziu8tTZwzn3x6o+3DZ3zf30LA?=
 =?us-ascii?Q?zZwviilDwwOYa4Ia1qqwXGaTlJgPst3Fxt4tGe+6tlvAsoJm/J23wMz7b+66?=
 =?us-ascii?Q?yljtbAo5uht/WoTlkG+EmRULfCGLxD3vqgPrNdhtHOfKDU98G0LW/eqj2jGd?=
 =?us-ascii?Q?+8bbwmV2/W8d3SgwVXNoJ2+WV1zMUwQgCB+Rs12BHLPVYOnv4gJV20He3sgV?=
 =?us-ascii?Q?fLZX3gjFp116vDv4l2SCFVlPRotIonhbkm/lvierBOi928uUDrRB22MZKy5O?=
 =?us-ascii?Q?vIkmIJ05IM/rOCbO1RH+NQK8TzZ/zixx2NOoKUuQ4XXrJaWX7YDoA4iGTFg9?=
 =?us-ascii?Q?N3zy+UqZMpzBgX9hwUEb2xSDjZKoOVqslck/+qbqVCh++SL5JUoennTcxbQK?=
 =?us-ascii?Q?ribtAKScXNwaxagveunQNt6JNCSOVvkUCwTm1AE78XLgC87ReiqDESoIX3u3?=
 =?us-ascii?Q?7y2dpJNQFhTItwImdCx8Ek38pfnzigSWCdKVld0ePbeh9kXalK9QEYqlDMLL?=
 =?us-ascii?Q?c1K8fTQiHN0p2C8RcIq9jJNfoMu3q4Cu4mlPE96plwaFeHgp8LYZuVoPTMT1?=
 =?us-ascii?Q?UYSN1Fj9Jum63Bx4c44EOvtz08HrDZk3QJ2vo5GhsiVDr5OKkfLtLexiG5AI?=
 =?us-ascii?Q?SmBafQHWzYLPheLxYOnnj1IwGMcIqORLMYqEVYrihpVgIrytWEHJWp9PXX/E?=
 =?us-ascii?Q?eTmkN12bSM/8nT28rcTyWtLr+aPQvBAnCEHLIfCt2BpqYrqTWYKIbtrK88L6?=
 =?us-ascii?Q?RkFGNL59xC/QmL5lPcUy5UFoHzna9vKT37OaBg80JaEXAFHkUn1+OTlmFO1F?=
 =?us-ascii?Q?dtAlEaGiNp3b+mZWv3g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fb66e4-64aa-44c9-cd4f-08db141f29ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 15:20:28.2540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rUnBGKFQmt1mAgDP/YIuAxsmnbY0P9XriL84L7gjBcvJEfl+syo3hNQqp6Ilo3UkZLs6l8GJqXM6+dxRBDwhTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7489
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Tuesday, February 21, 2023 9:48 AM
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> set implicates that the driver provides the exact size of the header.
>=20
> Quoting the original virtio spec:
> "hdr_len is a hint to the device as to how much of the header needs to  b=
e kept
> to copy into each packet"
>=20
> "a hint" might not be clear for the reader what does it mean, if it is "m=
aybe like
> that" of "exactly like that". This feature just makes it crystal clear an=
d let the
> device count on the hdr_len being filled up by the exact length of header=
.
>=20
> Also note the spec already has following note about hdr_len:
> "Due to various bugs in implementations, this field is not useful  as a g=
uarantee
> of the transport header size."
>=20
> Without this feature the device needs to parse the header in core data pa=
th
> handling. Accurate information helps the device to eliminate such header
> parsing and directly use the hardware accelerators for GSO operation.
>=20
> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> The driver already complies to fill the correct value. Introduce the feat=
ure and
> advertise it.
>=20
> Note that virtio spec also includes following note for device
> implementation:
> "Caution should be taken by the implementation so as to prevent  a malici=
ous
> driver from attacking the device by setting  an incorrect hdr_len."
>=20
> There is a plan to support this feature in our emulated device.
> A device of SolidRun offers this feature bit. They claim this feature wil=
l save the
> device a few cycles for every GSO packet.
>=20
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

This also saves a few cycles of L2 to L4 header parsing on every GSO stream=
 for virtio PCI PF and VF devices that we have.

> ---
> v1->v2:
> - extended patch description
> ---
>  drivers/net/virtio_net.c        | 6 ++++--
>  include/uapi/linux/virtio_net.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c index
> fb5e68ed3ec2..e85b03988733 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] =3D {
>  	VIRTIO_NET_F_GUEST_UFO,
>  	VIRTIO_NET_F_GUEST_CSUM,
>  	VIRTIO_NET_F_GUEST_USO4,
> -	VIRTIO_NET_F_GUEST_USO6
> +	VIRTIO_NET_F_GUEST_USO6,
> +	VIRTIO_NET_F_GUEST_HDRLEN
>  };
>=20
>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL <<
> VIRTIO_NET_F_GUEST_TSO4) | \ @@ -4213,7 +4214,8 @@ static struct
> virtio_device_id id_table[] =3D {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT,
> VIRTIO_NET_F_NOTF_COAL
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT,
> VIRTIO_NET_F_NOTF_COAL, \
> +	VIRTIO_NET_F_GUEST_HDRLEN
>=20
>  static unsigned int features[] =3D {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_=
net.h
> index b4062bed186a..12c1c9699935 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -61,6 +61,7 @@
>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in.
> */
>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact
> hdr_len value. */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another
> device
> --
> 2.39.0

Reviewed-by: Parav Pandit <parav@nvidia.com>
