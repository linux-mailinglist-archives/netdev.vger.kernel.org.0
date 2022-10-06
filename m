Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A272E5F5E77
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 03:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJFBsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 21:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJFBsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 21:48:40 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020014.outbound.protection.outlook.com [40.93.198.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1609E870B1;
        Wed,  5 Oct 2022 18:48:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft4CRhq/6uiK+HzV4b/77Aicwi8fAiy7A+BETYQy7YzJwXiUDPcvuH3bmiBKJY7/QuSzGoceqVLwU2v/BZdlRfnIfeHZQ3T4qL35ZodP3gEJLHX1D/i+lWwPsUA8e19wCwX8B7iR5O6rsj4NuLFB3Hc1YYxO+lY7JhqlDhFnMXuF+Jz3Qe9Sd7tpUlCebVckW0SmvdzOGrHMftfcuJ6mioxOaor9vKbt+YnQQS9LQgPodIfBLUckA6QHDl5OTta/Y2gfnmNsuJBZWrIutGz2lNXpxazAN9guGpB4IQDX2AFYDYeshi3XYakjyZ8CeYFFzcn9ssOI/iahyIHapvDjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYa+4OrICwWGQYUSa8K4grWyNgDaRl/zYVC8s9b8/qc=;
 b=l20lVF/2VTQ0IxUzmF5KKwoGEjDcywssTgHspNaDqn5GkfJo8s6F9koSDV9t0vpP9c1aqiJcBbC+lIkqdO0DnYAx/y8ANAJ9G5XqT5Bb/8SB7UolnyJJueGGnVJ8c78jDyl2irHWW+cz0q8AbMG/8vXpX+9cPJpe8WMsdJVHS2z0gQmP8IPUE6c3MqkNHjC0I3xFCKPsOpLFxWERnlNPiDb+AB6aTlK6j2R89OGvlgupQsu+pZDfoK+FnoVuoDuIbjNedNY/svE2h50GLuwS1ibV6F4n8JX2Mvcu7kvFUkRYwpS+gShVGRj9u2E+2M7kJWpZrSqUf+4TULkxEgbkzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYa+4OrICwWGQYUSa8K4grWyNgDaRl/zYVC8s9b8/qc=;
 b=WoiVuh8Xz/CL9l7xMvZNFsRJYPrETQpeFl2ELZlHMuRHu7ua6S5X2/RhaYOLU6HqMLrnShNczq2ZFzDUeVt2+bzgHfPeEnzBs1CHJ5GLTP+2PJTRldwVRI3p4rW5W5HHGATByBE2J7lnHFlD8q8Obyyi6MLZic5QlSaCL36FmGY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BY3PR21MB3035.namprd21.prod.outlook.com (2603:10b6:a03:3b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.9; Thu, 6 Oct
 2022 01:48:36 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::e19e:c7cf:1bf0:1a75]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::e19e:c7cf:1bf0:1a75%7]) with mapi id 15.20.5723.009; Thu, 6 Oct 2022
 01:48:36 +0000
From:   Long Li <longli@microsoft.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "kernel@collabora.com" <kernel@collabora.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: mana: store return status in signed variable
Thread-Topic: [PATCH] net: mana: store return status in signed variable
Thread-Index: AQHY19nNO1eIrthHQ0q/Ak11lGPtPK4AmqXQ
Date:   Thu, 6 Oct 2022 01:48:36 +0000
Message-ID: <PH7PR21MB32635C66722888A108A51198CE5C9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <20221004101200.758009-1-usama.anjum@collabora.com>
In-Reply-To: <20221004101200.758009-1-usama.anjum@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=97456b55-9e93-477d-bb4e-73cc065c9f86;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-06T01:44:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|BY3PR21MB3035:EE_
x-ms-office365-filtering-correlation-id: d2ac5b33-4318-4744-079b-08daa73ce25f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BYbzxnrbKIsbB5qwsoyZM4dkVjYzC4QFoD5JF96qozz3cIVVuZx/42FsSp4tmC6HK/4bka7bACi+4SQ65CtxhxrVt6iHOkgH9y8j68Bbek/oAmKLmk8ggjPeZNxAh7NmDcNKesw/aPyHfLpGeQzslAk5EnnnUslwdyE4CddmEh9h/OmlphNjT9Si3pwKQGRzUqb2c/LwWokvicjENYCAq6LLT0imrZRZUAzsDqIhhfp6ILTqHLuZgR73Bv5+hyhK/J9ofZsWOwbqmyZJloLjeY9q8mU1uy4JxPkPld0mD2mTxpIqIciXNpY5cyGQI2YGH3T+YckgoS7XA1EUdx8SbfJmxbj+lrFSEXJC1s1XdsbJCOP50fCo4+PGkrQuBzuDBplZRFiN/E53RbmDd4NnDffXoCp4fXuAIXR4AASZ4rM+Ru/U3cd0PVawLxiFxsoiWyciDPb79A+ai3OuIbDUfvX8xcY6Aik+y/YUmg9GgC1aLDqowaRylX3hd08KfOl9VH4NuxxjCOAHdIlaQJ8WkRxotkikfwEN6dlueK1g83vhp3GrXKt1cG/orvLNnA9yytbAXLxWM7YTIvBJy57ZE0vlCZmiEgTb7yCVnu/NFwo169Uo8zbEXyZM1DiWun6ooBQecmFPrUMlf3YMTxXK0HBTPc18BBRypfEDMAJy1bW3KjJdn/6opGNoxLQzJ63SrzbpBfzkcyyemFGGSGjx3HPeKWcanq4g/qstUqpoj2Xe+y/BqPAkwow+10X+YnfW5Ydzdw1jPNE9jpNZXysLdLRhfJye27jfiYNfC0G1AChf2CrtCVm1yF960mgVIqKk+O04ZAg7Mv24/qJ+djbkIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(38100700002)(82950400001)(82960400001)(966005)(71200400001)(122000001)(10290500003)(41300700001)(54906003)(52536014)(316002)(110136005)(55016003)(33656002)(6636002)(478600001)(86362001)(2906002)(38070700005)(8990500004)(66446008)(66556008)(66476007)(9686003)(76116006)(66946007)(921005)(83380400001)(7416002)(26005)(64756008)(8676002)(8936002)(4326008)(6506007)(186003)(5660300002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pVXDZ1vU80Cf/tJTproSjFqa586/h1Ut7cS6CNbYI7MB2a3+XVbgWFVrKRsP?=
 =?us-ascii?Q?O5jXWupDAAPUe2BITy+dei7gLqqIFYlVFTfiF4lG8Gk+HkcKvObgyfI4o7jU?=
 =?us-ascii?Q?5tEz01iKK91Wtg1Mhrg7pu2ysTmFNnXC7fr2eRYEKPfMBWSJ6T7sUjKbajEC?=
 =?us-ascii?Q?7pKPZ6s8dS+BWWVv+62UeS2uPc651WSYj26op389dAYAhB/qGJNIafKcJ042?=
 =?us-ascii?Q?Xz46bhlSDpBvcgC6KAibdLQLmfA3K3awzUPd9MXNpEBCsI+2kIOaes7nsRno?=
 =?us-ascii?Q?ONJwjcTK7uM9aqW4SHbqvOHK3uY80uUnQ+65BWbqVSZZccbf2dG25wP5c3hU?=
 =?us-ascii?Q?xnY8mYWcpa5VxF2+VPQhYLyAEVSsnb2vLNT+Q1EMTB08WqiIQzq6lD+hkXHY?=
 =?us-ascii?Q?VV+A6wP0quJpQtW+HZmUtmtoSfWIsCYzPjaVzgK5Q0GIPCgtRsCN7fFtnhNF?=
 =?us-ascii?Q?cf5Ls6UtkA2JDnVDLlbt4uAXTvHs/TYm0X9RYL/DqhbhyzMsvFcjqjXI20Te?=
 =?us-ascii?Q?k9eZDWS/57sXvFHLGgvwfie1gAO0ss6+KGwvSqM0GAoT56xNIO3MUyoXQMSg?=
 =?us-ascii?Q?GVkz0pTNXsBRl9oRZ787K7UNDCGX7EUcjDqa4ZwBV5N0rEMX9OEXmezQq83D?=
 =?us-ascii?Q?qkt2M1ZZTm6O792kq4wxYfE91Er/LpzVpn9vheGraXsl/ecKjsbvKTxIhkhJ?=
 =?us-ascii?Q?wX3vrlKcBiL9JJD54sZmBgU/bQxY5TBStyDGK3nVESBItevKZMD8IeEhKT7h?=
 =?us-ascii?Q?c3CIltFkLMyyiJUL7ev4nN0SXXV99/g7cSR1hYh+FxMuGGXz/TZZs/RWsh24?=
 =?us-ascii?Q?9QS+R/b/KGA5WHX5dn4+TXGWSClJSEjHB8nY19uekR8qzTnG8A3UOP7lgQxh?=
 =?us-ascii?Q?GlLTV2+TpHzBQ5I3+Qf4zGTIpNe3RtWmfljB3/2rJlDDhHGPBH1+4SsBxbac?=
 =?us-ascii?Q?VLP0uWpXVEShqGpJtTHFlXz/+Y32yDtqYM/2L7BJgdefBNgr0OVD39jT4T5d?=
 =?us-ascii?Q?0NPgHLRJYSpuvJi2tV1EvFwcMz+ihEGEyoGyokbbSpvDsNtoKujYP0OXxeOU?=
 =?us-ascii?Q?IvngboEkLSw98CMpyMwDQMHq555gZWqnhjmOrd/BV16tzISmc8ib2maaDUTs?=
 =?us-ascii?Q?2QUkNLZ/Ab1Xl6WQj/R6OtE9fPqVhWjzHfvNUiz/tqXbMg49aG1lrEZQlye2?=
 =?us-ascii?Q?MVZ7u0Y8pDMzDFnmV/shlPdLSVsfynzrcq4nCrlo5zvaD8462NE4PagNZd7Q?=
 =?us-ascii?Q?lzA+d61ADKqYbe3fw3fhjYguUNl96bU/XXdSpQTs6GpRHKVVJFTckepjFPh/?=
 =?us-ascii?Q?ng948YgzwqI4QtBD2b6gxSL810ghfix3YZjD3rJaCHf83SoYl/kiNs8/+LNQ?=
 =?us-ascii?Q?OAVq0+mu34PClcHaqHWJ9dQcoHaAsVe8HVKzT/c4u0wufeMOy+0F5xpzKB3Y?=
 =?us-ascii?Q?nC7dHldoIaeWsaJcdGHMl6pQsPmmr5EqB2C0M1MahL6NFxecVmloatc2Ymwm?=
 =?us-ascii?Q?/zbZkTUjwrjJmzu/zavndSGBBKSv/8iLmX7+/2ufuAm35VmGnwo57hLIoYBN?=
 =?us-ascii?Q?n7yTwipJ+tIpYCmcP9gKMF2ECPTM0G69dyx3DFTF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ac5b33-4318-4744-079b-08daa73ce25f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 01:48:36.3632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TiiE4XuRzJf86GCUabHb2QJNEEA9JhnkSPTKTuLizv3Fm5OEIaxTnHVkdTFUlOTyqR6HKtJcXSd8VuS3bOU48g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR21MB3035
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] net: mana: store return status in signed variable
>=20
> [Some people who received this message don't often get email from
> usama.anjum@collabora.com. Learn why this is important at
> https://aka.ms/LearnAboutSenderIdentification ]
>=20
> The mana_adev_idx_alloc() can return negative value. Save its return valu=
e
> in ret which is signed variable and check if it is correct value.
>=20
> Fixes: ee928282bfa7 ("net: mana: Add support for auxiliary device")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7ca313c7b7b3..1c59502d34b5 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -2203,11 +2203,10 @@ static int add_adev(struct gdma_dev *gd)
>                 return -ENOMEM;
>=20
>         adev =3D &madev->adev;
> -       adev->id =3D mana_adev_idx_alloc();
> -       if (adev->id < 0) {
> -               ret =3D adev->id;
> +       ret =3D mana_adev_idx_alloc();
> +       if (ret < 0)
>                 goto idx_fail;
> -       }
> +       adev->id =3D ret;
>=20
>         adev->name =3D "rdma";
>         adev->dev.parent =3D gd->gdma_context->dev;
> --
> 2.30.2

Thank you, I'm folding this patch into the next v7 patch series.

Long
