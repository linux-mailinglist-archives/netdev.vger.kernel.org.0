Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC924BCD30
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 09:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241029AbiBTHxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:53:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiBTHxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:53:42 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2106.outbound.protection.outlook.com [40.107.114.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3BE4617A;
        Sat, 19 Feb 2022 23:53:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBzw+zunkWq0FqCQk9dNOH31ZFXa3FTux5kykPYrdzp9MYFOQJkH4yHdR2i5raFjOy1+JRW7TMI3zyXsWZTdDUpohane+pyfm1Sbhv/09gGLA58pPBXlsCuSLIgPxnLYDUzIwBVk1pMWN6qV8787+wdxpKQkSu1YWIob+hpHWaOVTLGZrWfD3xrsAOTahciXwe/NJ/c6RKRLBQYkLBePP4MZoaaZTCOxpvjAoq5T9WTZQNHHF3JZB0HsnGcx25bJcHX5awMRGdvGEY1Vx8mhjJUvQgsiDrS3Xpcc3iG3XUTnZSptux01ly168kB5rZrj7bh94SSfKVsb7QM3mX5+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLZMDtLZIz4nAy9pXAsrrFuhvVaMMwmUZVI3ZMaq9u8=;
 b=P3YfEb7EM8HjJUwFZY7jV6OwScAaaOcpr2Mmd3foBSrg5A+Vu/Yz7W9AviPqhxl8p1SeM75vQIWS9Ug/IVNmzFbQ6HXDefBEaVwuiulgakKZ5I0s6CKVUEFqHnD4959Be1/v5Rr2KAYcbsJ9gQRh0oKRVtBgNwrgtGUMfYldzWoujf45MeHtzyGe6VmVBQVTCl+vH0AhOzj7wpJj+JAQfqELP6cMyqK31ZNaZM0xpS/xcOiXSppEVQMPzgGsfd3q/bUmanrVL6KpPllQi0ydbrZTua9eHf/6G51C8RiiOHivwCP1YlO4xk1Dlmz2Egj7rFkCglT6JYakuJJgUIBjog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLZMDtLZIz4nAy9pXAsrrFuhvVaMMwmUZVI3ZMaq9u8=;
 b=UWIUnXe/JrlDDAEwOcXhNLKI3mfWUPGnCvTAvMAuzLZkS+LrNN7Kh90vkWJJVRQp7ecxb4isNyZu8KJMXgSmsUn5N5pgYP5eRWK5ooQaI5yl09lR0Qw00Xn6qt2MGdfGHLNvwG1kywlgFO1J3wIvsyV7aM3Rp41QvwHoKsJ+4aw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB5418.jpnprd01.prod.outlook.com (2603:1096:404:803a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 07:53:17 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::58d9:6a15:cebd:5500]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::58d9:6a15:cebd:5500%5]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 07:53:16 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Thread-Topic: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Thread-Index: AQHYJitP/nu5LcwZQ0S52dNHzV9R7aycC/4Q
Date:   Sun, 20 Feb 2022 07:53:16 +0000
Message-ID: <OS0PR01MB5922D806D40856485CDD612086399@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85738381-bc24-450b-568d-08d9f4460dba
x-ms-traffictypediagnostic: TYAPR01MB5418:EE_
x-microsoft-antispam-prvs: <TYAPR01MB541858A7D82A1EE7842E675486399@TYAPR01MB5418.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LjarVtr0Ufu/pHCRYqZdReVkOw9Ym0pCInHz3KT/xLM7KX0m0rBCddTUXvIeFoZxKt5NvnITAAbijFfp+3GXnERi1v0S5jrPdjsyr1O+7pvz0kkUQ8NMPJifGne3f2d0aiGwQfJ5HNuSkFwdT5JUbqjjg4OxQbH8rFjNPPGh1rF2ibyOLAsiu11w2ZjCo/hKk8mvAUlVZGkmmC87/8IGzdwmwBHDln8aHMcBgABTd6rLnJSj9LqISoP1cujCGhw70ERzt3OhrggGt11VeyVW2l4yhB9McdyVj4+NGbvszIRXz/9GoNPuwBoHglaoGZTKefCsX3bovXASD+n0Xanmp6W2uwMVedovy7+oka6HbegwPcqLUH9NGIc3j8bAenSO1SE8Yw34aMvPPeJajULIXg2BNDvNcfF/G1+YnrqUiwX8gHPRIzKKSQNymZgMRNQ9qsyGAMVb9f+t6heicogtvzMo5llJei6QvItPPYwBuBnU+FjG4xRpiXW/+GePnlSL4S+jFLf0cd+MiZaDGGxYopPeBQ+VELo04WQ5kW6LtHrwOIUTUWre7hnRLhkKGWXBx7MBu1UUcrQ/SJRY6/aBZhS9q5DFehiB6JsYYx17hX3C4nNlBb5R7QG6Iam7owVoSpMBMgQx/W2YraNSgV+CYTOmR8pIB0ZDbbNb3symoAK4so55wyE6XVPuuVLgZnETROMcsJwQ2ynDervu28Q8qYRJvxL0Drwv2NUM925s7JILNTHbDK0c+Zsv05wfuMdFamk1mVJ3m1TcNdPpxNBL9GDy3unvd0lleS+P/dupTC4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(4326008)(38070700005)(8676002)(66556008)(66476007)(64756008)(76116006)(66446008)(86362001)(38100700002)(5660300002)(66946007)(52536014)(122000001)(2906002)(8936002)(26005)(186003)(71200400001)(966005)(33656002)(9686003)(7696005)(6506007)(54906003)(316002)(508600001)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rrg1Fh0WlJ9LXFatbMZ6fRPi6uLTan4q0HD0x1pE5njci3fY01qkZ6vpsj9W?=
 =?us-ascii?Q?+m3IOwqxpytXUk01V7rDpS8BpSGHrQdKJyPFTrgCCZnnGVdyYI0AihTfloKz?=
 =?us-ascii?Q?XmGiVSyNMc0v2hkvTJU3fdMSLNmUyq54oEM9F/G3UCDCOlzKHVkHnWzY9NRW?=
 =?us-ascii?Q?LUc6+9kT/iSGA5wBSsKJwK2caNEetMEVRfL+o03CX3cJ1I7HG8/Y1UPQ8mRz?=
 =?us-ascii?Q?fctY5rSKMgpNeSM+cwfFcV+cwlECVwGsexA2Z3n7EDAvHCy0NwywmpT9Jdnc?=
 =?us-ascii?Q?TEa04Z+De1V8SWel4zsbzYlVJA+ZiXv0ZJnJMox5OEYubSLY4xkhgYpw0iLY?=
 =?us-ascii?Q?V6I6uNj/graXDVav8GVMYWT5uul1Kn7rGQWHsZpffy3pFQQoxSbH9kJKvzNo?=
 =?us-ascii?Q?44WVBnX3k1eEWKff9uS43Y2ZhoK12jfGE7LZlpRXNnLQkz9nRCgzYOyO9jan?=
 =?us-ascii?Q?b3Pse4qnDK8m3UTC55x5FKJ1AuXmeXSIhleK+87CYaZUTj61UBwuq8m1jOUs?=
 =?us-ascii?Q?CD8xKDUNWCmDwkZ6rSdojufFxkQpaTPQDUe0QZYF6yYohHCfzDZJrzf36Dy7?=
 =?us-ascii?Q?HmUp/gXTILQ+CI8czkFrtj8EJuPovOYI/ymXClzrZamXG6xj7syRJbUn0m2p?=
 =?us-ascii?Q?HFOr6UjOqe83K1W++RgiaFcl+m2J1DwSD2gHlnkVQjfqhKr0mQjDhzW3qe8V?=
 =?us-ascii?Q?otDR1xpOhVBm43HA1WlM0Wckx/ItN91g6gP4hlkHCjKxcILRPFMBz09REfwz?=
 =?us-ascii?Q?ePiiq4N+5lYdpi35/iiroVqi+byc4MUaly3pIEXKa08o2QpaQj6sz7R4gzzY?=
 =?us-ascii?Q?7h1aIvswfvBCucU2NmUgW+bCv3bhZJgEjpjnpxtbx/Q84mzfHVnbeE4Vq/q8?=
 =?us-ascii?Q?WHrmXse52WzG9sH8DVwk/6MVKep81KTQC7+WIfHREqE7ejvsB83Af7URdtPp?=
 =?us-ascii?Q?spa46e84jxy07Thm5j98sIWSbSQJkSVlX0M9IOEcNIeenaeBwTHHKnFRAp97?=
 =?us-ascii?Q?opj56w/FdrKAhqqy7k1qSXNuFJyC5kCk+ERv6jqy8+sy9zBEHJndCyHBY6Kg?=
 =?us-ascii?Q?+PMThRKPPpdzX53TNtyZB3JPdG6H037yGBrKyimyCE93q+Vb0g/QKEIV5Ebv?=
 =?us-ascii?Q?/5HgDTMEv1k+Jm/aQ4ztdVXUcDNDZJeu5NWe2QUMVQ9i+mbxnpQTf0wivwsv?=
 =?us-ascii?Q?0jnOfh/UJoftzizduoD/3bapwLgILEpC3cOiHwQzF99Vd9gBCxjEz5O2BgnQ?=
 =?us-ascii?Q?xODv8UOZzBYjduXRe8jZK8uDbyGwkekKg0dpNP3fPoSuYB7HjAI9XPT4QGh6?=
 =?us-ascii?Q?PTleIr2/hHclldknZRChwLQ5ts27dbyH4aKgvC0aL7V2TN80W3S7iVePbm0v?=
 =?us-ascii?Q?6BxWmVfF7VU+c+tzNd/zbpvUQddGoGXkknREXwU4NacEItuCfbN5MFXXgUEf?=
 =?us-ascii?Q?OH/twlOFuRQDAw6i6HCGM191rQ7IgyyRdt28YFJSLW9ovk48JJSgaDMLFC7w?=
 =?us-ascii?Q?80OOcb4EIeqpvicgQJhmbEbo/gqzP9Ys0I7UFx5lWQSxVfoYi9HHqagrDZDp?=
 =?us-ascii?Q?5PLuyDymJbSVpVC4hQNmzV59LdmmWT+o66LMGrblnRMeMn0Hhys0jG2GH+ri?=
 =?us-ascii?Q?37dHBQBMUO45jUeob9cQOP6Sh/568Q6X9tjq5XHL9T0vuBfvGhBIW0W9LrNq?=
 =?us-ascii?Q?tLP6aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85738381-bc24-450b-568d-08d9f4460dba
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2022 07:53:16.4200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OQPn3v/8nDLRU/F2jNlwJjOtVs67AXUooQqH1yX840HEUtgVsrmx2QSekllL65i033XGorrQfSQJC27Y3DVwTevfFI0XX2L9xQk0v1gXJTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5418
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

Thanks for the patch.

Just a  question, As per [1], former can be allocated from interrupt contex=
t.
But nothing mentioned for the allocation using the patch you mentioned[2]. =
I agree GFP_KERNEL
gives more opportunities of successful allocation.

Q1) Here it allocates 8K instead of 1K on each loop, Is there any limitatio=
n for netdev_alloc_skb for allocating 8K size?
Q2) In terms of allocation performance which is better netdev_alloc_skb or =
__netdev_alloc_skb?

[1] https://www.kernel.org/doc/htmldocs/networking/API-netdev-alloc-skb.htm=
l
[2] https://www.kernel.org/doc/htmldocs/networking/API---netdev-alloc-skb.h=
tml

Regards,
Biju

> Subject: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
>=20
> 'max_rx_len' can be up to GBETH_RX_BUFF_MAX (i.e. 8192) (see
> 'gbeth_hw_info').
> The default value of 'num_rx_ring' can be BE_RX_RING_SIZE (i.e. 1024).
>=20
> So this loop can allocate 8 Mo of memory.
>=20
> Previous memory allocations in this function already use GFP_KERNEL, so
> use __netdev_alloc_skb() and an explicit GFP_KERNEL instead of a implicit
> GFP_ATOMIC.
>=20
> This gives more opportunities of successful allocation.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> b/drivers/net/ethernet/renesas/ravb_main.c
> index 24e2635c4c80..525d66f71f02 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -475,7 +475,7 @@ static int ravb_ring_init(struct net_device *ndev, in=
t
> q)
>  		goto error;
>=20
>  	for (i =3D 0; i < priv->num_rx_ring[q]; i++) {
> -		skb =3D netdev_alloc_skb(ndev, info->max_rx_len);
> +		skb =3D __netdev_alloc_skb(ndev, info->max_rx_len, GFP_KERNEL);
>  		if (!skb)
>  			goto error;
>  		ravb_set_buffer_align(skb);
> --
> 2.32.0

