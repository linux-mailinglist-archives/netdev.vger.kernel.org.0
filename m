Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75F961EF90
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiKGJuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKGJun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:50:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2113.outbound.protection.outlook.com [40.107.94.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC06389
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 01:50:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwJg+1Yudf8JuCbK2Og0TXocXpX7z+axVcQXiZP9kfMXpnXSIdtWv/d/PnIOS9noiI63NwFg/7yrH73IVpBRLqvZ/yJh1nxsAULQd0mtSysmYop5Gf0XKAV+n8JuGiCLz3SmK6GF0JS9HP6dh4qVoYhiyhhzLGoLmJ+lv/ISEyyZwP03kh4GzNPqg7afAFKEyPbylgnINv3ZeE+aiPVKXtk5Vk7W0CNZONJhTi5DvuswkGDS6c0ggIGzywQE9N5dHR1F3CzMQCI06T1qSSDCobFPwBPJlGkegSgjDmn3hbeWuXn/jeDnrV0loQToEOF6tazT8z/aXoTGWg1ekxH0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFKtiCOSJQ5ZSABmi58KG3Zq/pZ2osVGyHJaNdkh3qA=;
 b=hlMVO/3+4tS+5F0YFTjCIdnXjMG6o/m0jJzzqw91cVPx9LL0IeLkbzIVKYrw+n9ZXh4/YTylW34X4gsjF2IGxb5SL8JrCIdF2BztuJCghyJenpW3pNKCXifpDvOqc/JI+dQlOj85jTvp2/C1YhnCE9sEA3woA1zqGB6v7fqdfCXysb97s1MThOj1dFEjTuGba8IRaJCU3QLVKJl91aMsqDtKKVtWQllfHMsZCt3FTDvXDbH5fXP+YTR/NrvQUyV4k7xM+S9ZpBp/R76cQAJaEUTZrq1vhsxhc6tPdjJvy1GCdvVl1ndvLA0QHqYJIpdT0QdN6QM+s+aA8G19rxqmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFKtiCOSJQ5ZSABmi58KG3Zq/pZ2osVGyHJaNdkh3qA=;
 b=hVamZus90VU3RnF5gocgWMIxQeNCFqWNPtcxlAArNhLvHsMrw4vKmFmj/ywaMYhqC1SfTfStvB1UupaSWq8An7gmXB6FhS+YF2RNeRQYvH24iHDL77tKyqV2XqyQYMgzz2BUEBnnCvuiOWvU5VHtXOT4YPorWUIgjctVso111Gw=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SA1PR13MB5419.namprd13.prod.outlook.com (2603:10b6:806:232::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:50:41 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 09:50:41 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chengtian Liu <chengtian.liu@corigine.com>,
        HuanHuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Topic: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Index: AQHY7eGMPasXy6hiXkqW0Y9zNHZbuK4yVaIAgADqb+A=
Date:   Mon, 7 Nov 2022 09:50:41 +0000
Message-ID: <DM6PR13MB3705F0963A853D5C794FC639FC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com> <Y2gPelnt3xfgDGYd@unreal>
In-Reply-To: <Y2gPelnt3xfgDGYd@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|SA1PR13MB5419:EE_
x-ms-office365-filtering-correlation-id: cf566674-e8a3-4e48-f36e-08dac0a58835
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HoSbBbgKBj2HHtRZIkxSns0uFXRJlUzfP8qoDeXQZAeZpIG9k87X3AkA26d2fA1aPkBxaefLidVuZaNMpF4mq5eP6j+vUlV4ka+GiuJm4CPvWkb3QsjJvvhxjQMKAEnHD3RKyy8QXa/QbcI7MkjAyHJ5ghtYX+ifBisSolqBm9Qe1l4m4rgDbR3gnQP0cE2CYEtMr3tq/IrFJuwW79waHw+lK3Bc98i1r0h2fY8Z1tsdjBfCgv31JiYmMbc893JK5mOswIv0tX0C3v/l3+GnyIXwkMdR6UAKcSFb8KD5tDza5tr7+3bxiD/S+CN2/4REaf8bVYNCOUsRPBNprgo4zNKE53m2b0lwkiJJyXOicFGGTnMuQpvDWXintBk5TkMq4shbuN1Tw7mHqkuAzDl0gA/X5GcKtWYHRMdylh9lENhfMA11DDOeAz37EDrSqmX91nsCe6hCCnhYFuxIwRdQqZbE5f97pAuNMK8UPQdqABgsP0cLabBIysjEGpxZtIy4xlzSR5daxEu6fT33wxC6z1CYrPWAKO1oNkmL3QzrVRBLWW5dDX1FUFEfzmt1VP4PGKCzrA2Tgc6yEMWHzcxTOg8OLeEbRh3ZtrzDXOylsnp5VshICjlbQLMLlJHUG23ItVotfdn8ioLFqpZIQVG054pncim4s5EdzrX/3BROQAvGC/ywSdNgOGZU9mnkxo7yCDcsabUUtyEzfDPLAx7zpQR8BxexHiN94fLKaaOFLUxN7XZBezhwanDCrH9o3S+NCcN1rY7z3wHC8SdmCMWNjj56avbT1s7vk7nEMslC3rli1Hc7rBd4EAyPLzV7ba6v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(346002)(39830400003)(451199015)(33656002)(186003)(38100700002)(122000001)(38070700005)(44832011)(4744005)(2906002)(41300700001)(86362001)(8936002)(52536014)(5660300002)(55016003)(107886003)(7696005)(478600001)(26005)(6506007)(9686003)(66476007)(8676002)(64756008)(66446008)(66556008)(66946007)(76116006)(4326008)(71200400001)(316002)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w1DMPp113ZIA5dpJaLqYffaylIagS2i34TY6Sj0WnVH4kOm0SQqu4EfMSSsi?=
 =?us-ascii?Q?SXxoqov8forr7woxleT9XEb23esWG4NiCl2affquQymUOAmRz0noHwgn52kI?=
 =?us-ascii?Q?JbA+toyVABrc8+0QCcAdUDATKBuWbq/bVHfkN0wL5fonwBL3cAEIoFpw0ZoK?=
 =?us-ascii?Q?R45fIADrjYigxNCkHYVaQ22qCL7FHA+i1oCkyqHcarIoCZGUrDoId82hkL25?=
 =?us-ascii?Q?k7de4yo5WSEyRR4Nj1mWAjkzH3AxsrJXiauqBK0Mv7ge8KJceqU8oVwhqSQH?=
 =?us-ascii?Q?8AnCjRIKkL3R00znRJ7DLZh//2ONKQAzkslKHxy8PpAjeecoJxfBgZVIwNmX?=
 =?us-ascii?Q?V7w2jwpbDMDCEMANpYb7OAeqGlPVoHkyDSekhhdHC3FTbib8LraCdaqyUGxZ?=
 =?us-ascii?Q?48LSYDpkklFYsEERwoNhMZP1Kjv4XyN5GhTBnsJN5EAucmscnbwMYxYwNz6p?=
 =?us-ascii?Q?4alsHLHlxCWh6mE0FRm0csenixwf0LYdx9NWbnJstADiMyp9/Zy037Sx6zsr?=
 =?us-ascii?Q?+voDMXZYvXEHBMm/xD/UUySSmvOnOH/gCj6AUP3OWC77C/XxLI6zRjjh3OM1?=
 =?us-ascii?Q?H6wXuJvea1VFNHwRafXz3T2495uJaFMvH20CKrLDlZDNTleC/D0joEvzzpyF?=
 =?us-ascii?Q?J/oDBvp5vB4Mj+1t9Nz3LTAw6GRkySp9bYE0HCTGTxSRQPNrHRPV1nELa7Ee?=
 =?us-ascii?Q?3ms/2BmsmVW2t29isLmxQ55BZqnV6nP8RcwGT57ZRWQKmaudrpbLLJcf0wEK?=
 =?us-ascii?Q?0nt1seeddfbZFepKHK9xSCI4ifJDJUoQtW/YGlv8zxORWLk4TiqvopM9D1C8?=
 =?us-ascii?Q?rpbehpB5v2cI1zuDejISyhtEtEtUDZJfpW3cDUZ7K4IZy/WAhfw3/a2+wSUA?=
 =?us-ascii?Q?/fpppX/5kwyxLfVFKamM3PDlJXv+sdwbRUAlCHeCfDU76kbgoiqNzIc42SAM?=
 =?us-ascii?Q?hYGoGZGLyFKo72LPqkStcPfbweH8x86EG4mbC5pfj7CD+QFhKw7dFomdOJxj?=
 =?us-ascii?Q?KQE/ycNUvEBEW9i2cDN/dMNjADwFmYQtjM+7boOW7cCn8ywX8APZz1jvFAsL?=
 =?us-ascii?Q?LxT2VJ1U2BoBn5yRyK2po9mvvlKDrcW4A/6RmasFR+1YL8xnnZOu4zc1srWY?=
 =?us-ascii?Q?wgedg2g9VD9J9W49tk6XH7LCcKfyRh6PbFgc4QiUuOZibiMgaFQJlkII7V5I?=
 =?us-ascii?Q?9sAD4BFquGah6XCKYjCEkmy6Ud4vncXhdb7kcqUQAKeTlmOE3MiM1pwSOhdV?=
 =?us-ascii?Q?p3KMKB8ZEi/1mrv3zDLDg+xFqpCePJyiUdLxaPcIvLOlqJVBdJcOauPkYPWv?=
 =?us-ascii?Q?+TOwg0AxJJ1/l11A58pE2f44XzLyHTXGrtibrW/ZTk6E8K5ajAQoGl1vysdH?=
 =?us-ascii?Q?YGf/E8dxC/4Edo6t7Jf8p6zYcXsTVIdKNwsDaT36CRpMpsiOX95xan0VEAZn?=
 =?us-ascii?Q?lW4nZlUDWrR1QotI1ZR9Q6X0rCrMhj9bGbY0IPRV3YWMzz6uFORMuRrw/NIC?=
 =?us-ascii?Q?LnQuTiJnkDrLLm0ocTq9rqOSbuDf+s6djJg2FnXT9+/bO6qJnu9K4T42jQMR?=
 =?us-ascii?Q?7MZggXmKvIBtgV912g8k427Jj8B+NMndsjZzPRit?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf566674-e8a3-4e48-f36e-08dac0a58835
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 09:50:41.3252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dUXAU2ipJEsXt3v5rypAxSwCfawdqPheBHWW5esqmkk7yijBvmXNLU5l6MJ0DUHijfCkiV4eFWrS4bldqRZ02yTJA1QbovuR308UL4uL7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Nov 2022 21:48:10 +0200, Leon Romanovsky wrote:
<...>
> > +	if (x->aalg) {
> > +		p =3D (__be32 *)x->aalg->alg_key;
> > +		key_len =3D DIV_ROUND_UP(x->aalg->alg_key_len,
> BITS_PER_BYTE);
> > +		if (key_len > sizeof(cfg->auth_key)) {
> > +			nn_err(nn, "Insufficient space for offloaded auth
> key\n");
> > +			return -EINVAL;
> > +		}
> > +		for (i =3D 0; i < key_len / sizeof(cfg->auth_key[0]) ; i++)
> > +			cfg->auth_key[i] =3D ntohl(*p++);
>=20
> I wonder if you can't declare p as u32 and use memcpy here instead of
> u32->__be32->u32 conversions.

The BE/LE process is necessary as HW requires it, we'll use get_ unaligned_=
be32
instead to make it simpler.

>=20
> Thanks
