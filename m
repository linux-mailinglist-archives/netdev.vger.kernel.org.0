Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B1D67FF80
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 15:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjA2O0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 09:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjA2O0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 09:26:33 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021027.outbound.protection.outlook.com [52.101.57.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0121E14494;
        Sun, 29 Jan 2023 06:26:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vhcytx1MqS7Sz2oSolxC7DjXBsMR+WoyNztaX3YusUZGrBkuVqM+Ug4sdIjSVbM4sQ7qs8kc8TI+ECyF+nJ6mZ0M3be6kV3bqsBQrv9OguykP6QQz+ylOr01dzInxiSxRkR+r6PMGnpbgiLL1GoGhoYDIMdu6C8TodJITgLUzDYB5TR1Kt7CXOBjLUr/R2Ch5Nue5cataGyYWdZbHJemsVWQVJ1kbKum2tdszffhOWg4m+90in8fYS11G5k/JUlzIFS6Mo65wrlmxdPoNnjpTmppsRm8gsA1Cni+PMDT3/3OlERNEIK/Ep3PG4opgZEUIW1MBSvvF3a3WwzC7Ujffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXG5Ao3GFdLc0qySMSeG9uvRlfBuh37c3TdSMa8tGTg=;
 b=Y/Dn249LvZMzEIKwsZo8ytoN5gR+2u5BeuUQU+b8MC0qj6zldqw+fay0luq6N37ckFtg983W6zsLrFBz75Xge+9SYBBM9tz1VoSeIJ66YDnqubH8vOVPILNQYgdXoq9yqy/FShf73Uz5TOy8H32XiC4AmALInM+cxEK5KlE4/wSFe20iipZakcVn81AwsGzpwvjWg9TMdmSXWuQeAWgPOyo8P2t42s2HZVBitBV87s0+agcW+POdRt8ikhkIWFnqjpY5mBFpWx1V+n7cajFabXt0gfSg9/oxCC5pqYYkLAHUnuFFndDgGjafK+BwJWfKXo2hOvRn9//vbrmfLjlF4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXG5Ao3GFdLc0qySMSeG9uvRlfBuh37c3TdSMa8tGTg=;
 b=fMnBBeCE2kI1SF3kkxbyNziKt5Z85+cIF7OcdKVRUlJTqRXltYeate31sSop8zC3bYA6D75bYacqkOY2Fb/LA54Z0emrepsW675lGQmt0gZAcD0xdgd7ZvLDTyR4fst02QtprftdfbufkuFZSNeHaHlZlrybIIU+aKEwOLTVjzk=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3169.namprd21.prod.outlook.com (2603:10b6:208:379::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7; Sun, 29 Jan
 2023 14:26:25 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%6]) with mapi id 15.20.6064.019; Sun, 29 Jan 2023
 14:26:24 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Thread-Topic: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Thread-Index: AQHZMcn8SgpNIL4AbEyNED+pbLbKKK61b9TQ
Date:   Sun, 29 Jan 2023 14:26:24 +0000
Message-ID: <BYAPR21MB1688E80FB5C75DEA549B3FD5D7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=35eae1cf-5b2f-4563-9e40-48674e0c5c62;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T13:58:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3169:EE_
x-ms-office365-filtering-correlation-id: eb92eb44-2b5e-4426-47b2-08db0204cce2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgH0CsHieMVrK3jBbYNGHLqJp0yVacLa8oEem++tZb/zwY8Lxs4EDHtdBwDQiOC20spb95Xc5KoEMm5VlcvIFgkhBoSsIFVCCFexvnTtCl4XfNJJ0dkMwmTYv2ejgk7AiToZNiBWdgabKwBsjZ7+mKrhfUaGfFjjgK0a75YJSsh7oq7HO2SuUuWEQAaec5Vb767O5hEmWL9lNVe/+P8+EaS8FbYsdr9o++9rbhxsnWhpRNpoh21J4ORrlfjxON7qymX1Hgz63K8bxbpqrX6pYg1F0GecygV+4MCt9zwbx8SidWpts5dGDq1iwV7YBseP7EmMNkgppM3x/Pj7SO7AzgCy11TdnfEgnYlv+62jE/+ChgCOaS2FPsLGtX2kqs4BoVZ1Qcb8r7lYCH+n0KfIMZpO55UtS56fccpoLd/8Px5pcZcv2s6V9HCLuH8fE1ppQlM2fSHUh9Kykz0a2YQdHURrdvBZAP9EzZmpt2d3Yg44/+to+lw4eWfBDPQHdsK12OYJvhEFS5M5eZumLLSV7Cvv38eE0tMaPyKns3PkbRjwl1KmYZU4FkHM1Qm5mWOxQD0eTKisFg/wdL73WI/j7mIUB8gvDCnupbVzBs/mkrptHEKK+SqznO03+U9bvSNWFNQFZN4wGJU9d41RXGpEB+KVcZAXVKs02jULHlXNq8C70orAjeB3jvgDIvwVfNA9A2lq88zBMBVa5mlYGN4yiMhOmIezmatbbrvqWYk0Jm10VWyxZSV8XNklPheZBfyh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199018)(7696005)(186003)(9686003)(26005)(478600001)(71200400001)(8990500004)(83380400001)(10290500003)(54906003)(41300700001)(8676002)(38100700002)(316002)(64756008)(122000001)(66446008)(6506007)(82960400001)(82950400001)(33656002)(110136005)(8936002)(66556008)(52536014)(38070700005)(86362001)(4326008)(5660300002)(66946007)(66476007)(76116006)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?js/cqQdyyhU3vlbpSwLv/3fgTh3+pv2rDwgFZVLEDzi2rM0I4nFhuEoH2ZW0?=
 =?us-ascii?Q?NAzSsCg2sp9S5Eo+nn3JGJVsd94jtg1qLGGb9bWUmat56qZnjkwzMGexREtP?=
 =?us-ascii?Q?JsYMRGTvm58xy0xaZySX/AMO6aSaQPg9CpH7zGruHnZGD4oekT6bhpEwK8+Q?=
 =?us-ascii?Q?0oF8hSJh00mhd0BG6WqESYRpo2wzCsMdaw6RFFM4ZoFfyxnGG9nSwHKPfn5f?=
 =?us-ascii?Q?RYlYZ7HaolEH+lo4Efla3RtxiNVQknXS6P1MafxcAd96yMoxfzP12N1d3zTO?=
 =?us-ascii?Q?oDoVupO7w5NfzzjPSp63HRKYup9Ffj4vsLDKeobPVM8DElC6WYkhDz+od66p?=
 =?us-ascii?Q?Jp1NIiMEZ/NLYQmy4mnlGfHxkyxIi+2ZQLZQC7jZadtx7F/dwWeNz0HJj/nf?=
 =?us-ascii?Q?wx3GO0m1pvt8I+HAKxigJnDfEN6sSQO+uzuD96e8CxzCEwdNICf6G+nBaHxn?=
 =?us-ascii?Q?EYCRSQnJnGtHdPtt8j/BEDESatRDO/gMRdC0/tM5e35pAzIyr2loSoqr9TlM?=
 =?us-ascii?Q?JptuUBA47tSrFTjfE9EenDgmb6FeareMMYv8mNAnrU4hA9+UopNRtUHKAsFK?=
 =?us-ascii?Q?bp2e7c/M6BS8JQXjPFg3FEske7HimJGW/13XvqVf8SgKzmyzY1pzcnSs/fx/?=
 =?us-ascii?Q?IC68ZOg1q0/utpbJg59CF0S8VmP4d+U8DRqotNMIucQ23h4eBYxDaaPFW1zK?=
 =?us-ascii?Q?Py5jbmo335CrJumjZGuE49PXD32W4DYHNwqcd1xgCT2Qh7I0gCL+hf6+4aBd?=
 =?us-ascii?Q?vlzkSLeUNGf6myAGDHl/vx9AbM4I7DqlY7YihRDY46cnNZjgans0KT/PczQl?=
 =?us-ascii?Q?/CNuArADziOL0hcjC+0DqsZEN3uFyx0sikJuP/Cj5HhiGltjhpC8/SmWYuKl?=
 =?us-ascii?Q?VZeFqJ7fjXPua0tGc9S+g4XLurjh9olFif6alzYgfsxKeTmeJ1e2Yt2c6Aaw?=
 =?us-ascii?Q?vKTRgrxdO98pVwvn3vbjb0o7N8Jp6Al+mkbYTrMyszwoSMmltwyacS0Ek5zF?=
 =?us-ascii?Q?MCbkPbd8v32FXE57Vq2UJN/C9UpkBpCdUIhYCHzuVMSKfR6NJRWVJTWXdent?=
 =?us-ascii?Q?JfhxpY4rdS/7Z7yltfrsapwZUZSKsmMXrRIhUSzHs9gVWiYcEx8Eg/TmHkRA?=
 =?us-ascii?Q?4NI1m/AxyRF1XR+T4j0P1Sr6waD2YQry9L9KeTT0nZJkmF3yyrkTTlkW1mNh?=
 =?us-ascii?Q?yhDsF4QGn++Zfo+s/pSrDn+61q7LhAup80KHzD4gUzK+gIoZrvhcH9X527QV?=
 =?us-ascii?Q?InJnpHb49wxye6czE5uKK0cfRWhUpjUvuFVECR+Ylk8AOvbcP0fwLH4Gu23K?=
 =?us-ascii?Q?2RTlyK5e2pAGInYV4JOHFcrGPXO78xp9obQzslopfzuWyroOQqKZQ10yf3I9?=
 =?us-ascii?Q?14LNx1QLDS5P23asjo4Yfq5TRqVJ97egMptOkfZn8ZrWOwKp/1mHIbtdJcgh?=
 =?us-ascii?Q?rTwAXZrTE/yRfxqqv5chJYLRaznV0isS6CrEWiVF3IDfjX2eaBtVvb81hUCq?=
 =?us-ascii?Q?Ij7JAQsIEQfr+EPjaEJguTRdFBdspmJoVBnImKjchOqfUHM4BOQvtdTLuQX2?=
 =?us-ascii?Q?Pz2BuhSQNd51/1xjcdbNkhMeRwCDhwV25Axzl9JlRElyexBcMLvhifDWxcrf?=
 =?us-ascii?Q?Lg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb92eb44-2b5e-4426-47b2-08db0204cce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 14:26:24.2938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwiTGnNEyqJjBHUnWzhZbARyOne2gw2H5sb4vHH9Snna/5xIOS0A0wq63v2+ZHfpg5dvE1xiVwOP0RvhB80MNgF0plKYkxQZ2J/RRajf+vE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3169
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang Sent=
: Thursday, January 26, 2023 1:05 PM
>=20
> Need to clear affinity_hint before free_irq(), otherwise there is a
> one-time warning and stack trace during module unloading.
>=20
> To fix this bug, set affinity_hint to NULL before free as required.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA =
nodes")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index b144f2237748..3bae9d4c1f08 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1297,6 +1297,8 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	for (j =3D i - 1; j >=3D 0; j--) {
>  		irq =3D pci_irq_vector(pdev, j);
>  		gic =3D &gc->irq_contexts[j];
> +
> +		irq_update_affinity_hint(irq, NULL);
>  		free_irq(irq, gic);
>  	}
>=20
> @@ -1324,6 +1326,9 @@ static void mana_gd_remove_irqs(struct pci_dev *pde=
v)
>  			continue;
>=20
>  		gic =3D &gc->irq_contexts[i];
> +
> +		/* Need to clear the hint before free_irq */
> +		irq_update_affinity_hint(irq, NULL);
>  		free_irq(irq, gic);
>  	}
>=20
> --
> 2.25.1

I think this patch should be folded into the second patch of this series.  =
While
this patch makes the warning go away, it doesn't really solve any problems =
by
itself.  It just papers over the warning.  My first reaction on seeing this=
 patch
is that the warning exists because the memory for the mask likely had
been incorrectly managed, which is exactly the case.  Since this patch does=
n't
really fix a problem on its own, I'd say merge it into the second patch.

That's just my $.02.  If you really want to keep it separate, that's not a
blocker for me.

Michael





