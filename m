Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C57680104
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbjA2Sye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjA2Syd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:54:33 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020026.outbound.protection.outlook.com [52.101.56.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DC81E5EA;
        Sun, 29 Jan 2023 10:54:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPJ0rsnXVaGI/E4N0MaihgfqNkLOl7bxrCU6p5UlnGe2FUKeFiueGq/kYZigUWV8Gx368qEHkpIzh3iJZK9z6oQnEsWkPZvzT9n4kKkOQEjOH7QsOFAsNmyxXX5T70lGWaev6cf30KpmHjMWrjJOu2OzUfqfGVqe0LoVHZcRcng8L9nEh3zCGV6jij7KwggW2J5vM+SuttQN7k1wm3yXP8d8P8gciJrdDCYJqBI2BwLnPs+lwKaYyyNQsOQWAKKG9ocF4N5r+Ya3UjFj3NBFjngVzwreM8bpD8pztE7tcAw+VPKAXABOf5KSB9q7bI4kt1gAIQ5qzWSFSL+YPy1nHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjuMxVxYnTX+rnbIq96hubDFfjJdElICH/GJciofWbY=;
 b=ZIhM/BMSTepea0X0qE2aaiPD75c69qGjTdjR8vie7Ik0zc6Trxq8BRPz0uPqO6zgaZYMtRYaX/FJpip0qjsC3PxUbOFPVlHyNw3iLp23ynLmgIO62YvM7Ja0pMxnWwDv+K1i2a1mgMD9oYcCuYsLblBzRd+Slim4jEMd5/Cmtg/zx+tDfIVlhFROWTNqTF1DHn4SlJqiWPPQ0kWgq1DhGCLKtzZdBgfzZ/++IPWqpEYb3to4dxSEIG7jMbPmA86aWzGkFYT2SZU3/xREUmhnEMHVIK1CYVulj4RCQgvzSkq6aWFwN3hIj6WiItXHl2FYS5Ll06tKqe7dPRKDC1uFJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjuMxVxYnTX+rnbIq96hubDFfjJdElICH/GJciofWbY=;
 b=XejcaGCCwaasYbigxxs5TEUJJp8GM77GSz7bEOajnTDm+NBJNVVEKiYAnUd4WwsPGahbKOazju4Zq9Ibi3w9t1tIdzsoduRzCmeu7UfyrSpGtr1/PwWGpvT+OWTzju+msh7mgM1pSrpw2n0Fczlix1Y97lmIK2GHWxszIpVz+Rs=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by SJ1PR21MB3745.namprd21.prod.outlook.com (2603:10b6:a03:453::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Sun, 29 Jan
 2023 18:54:30 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%8]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 18:54:30 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Thread-Topic: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Thread-Index: AQHZMcn23AFRD/VpY0ej7V9LSkZxq661d8AAgABKyrA=
Date:   Sun, 29 Jan 2023 18:54:29 +0000
Message-ID: <PH7PR21MB3116242A4D898271E933A23DCAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
 <BYAPR21MB1688E80FB5C75DEA549B3FD5D7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1688E80FB5C75DEA549B3FD5D7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=35eae1cf-5b2f-4563-9e40-48674e0c5c62;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T13:58:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|SJ1PR21MB3745:EE_
x-ms-office365-filtering-correlation-id: b799e599-d606-478d-d591-08db022a408e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oY4U+1shIyowrWi/BlsnlvInsUt1/iUfdavnhf5emVXnSsaDRIdT/jO1r1pMnhrA1+fwGpmS5bKVFZG4xWAcRq4EGdnotq5T0IKSL09Q/EmqY8+nj1ALD2pJjGjJhH12ZV9jCv9OxYmP69evJrHG9AhT7NYMmEUUZ/s+FV6iTMsR3E/AvW58pUtx8fwmJxG1dwVPXtlhegq010p1PTnJAFFwN2hdZemy6tRK5OLNAe4U2vue8v4BnXv2xQz7ARWvixyGGOU+8M0nldEO15ohXG5HZgIGQH5BXE6De7Qj7UplqaerBXMilQ054xL5NbwHdLRc6o3Qz3dfCAe9Z7roXRG6BiK2s9muNLymdwW4w+leW1SQNGTaLdnZZ8fDr0VVRBmWOmB5fVRnZ0ZiUXWU9CYO1FnqkNIlLNAmSrgxVABctjCAtxMeVxkG3nxaAq0UH9GW+wltzPifxMFE+c6GEjSLPPJ2N4GmrLmSRlVWLvszFvD9pVg0oAMiPI6RpkPbFh02uizqNsdeOfLbQYj5FeC5yHtIaNN7m2d7Hzchbmn25Xk1YYfmlUb1/IIs5hUNKuCAd0vJ8R3uhLvVn3Z9yyYgxwcwRlg2BjVCN30/ZzaduK3jSS1eSlwkMRmSBcjlTzTsq4vVpJ68CJqmIyOrNQCceoLWuX0C39ysl/H27X/yd+NHYmJIL1e2rLAB1ANMKd3ZpMFPA70kWsxp4Gk4o2JCqHBaIPNCczbjQKuTDjsVnTGJLzC/DcQPdpTCewGS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199018)(110136005)(55016003)(82960400001)(82950400001)(54906003)(33656002)(38100700002)(10290500003)(38070700005)(66446008)(186003)(7696005)(71200400001)(26005)(83380400001)(53546011)(5660300002)(52536014)(8990500004)(41300700001)(2906002)(316002)(4326008)(9686003)(64756008)(122000001)(8936002)(86362001)(76116006)(66476007)(66946007)(478600001)(6506007)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vQVvKm6xBZBkAsJaM8gRk9n4Ng8Y1oBNdXqyDa87KnsRy9xz9Hdr06mgwG5J?=
 =?us-ascii?Q?o7q787Q51d9Zg4WbDbuf/1mASTNkDcXzX6W4tpDJOQn4EulPCDc2WmloFTDD?=
 =?us-ascii?Q?+yRZeplEdSfo+MRlkALTJsuCJJJYEj9RX2ZU+GdByBTCxvLaC4mQpl9iqRu4?=
 =?us-ascii?Q?MxowxLfxQMYIf5atnP9NpEUY8QWigGM4hnjTdSiDnigddZUoN9bxJsxqbXvS?=
 =?us-ascii?Q?rINwAOE3d+O3cxEN6ASGVntp0TRREWS1HenDEDAmr7+u5DjocijWwcjiF8Om?=
 =?us-ascii?Q?dehmEC0AbzOEsel3Q36dR15FHm9amkrCch+9k4WWt4ms6HlwuktcXw5erMEg?=
 =?us-ascii?Q?XwQRqmOr3TiclY3lw20WGaRZdf0hoNI3/fYQ+7Q3O8hvWOZZrtHHVaTYWnaf?=
 =?us-ascii?Q?Nzm79MN5VDMeGlB9MAk8pTiVa54VI67M2V7/t75FDsbjeJwB0n63GhD9VAG1?=
 =?us-ascii?Q?TxCbflG56K5lqFSmTu8xbgi+vj5AnYalolIAlADpqShD79EJjzH94rtn8y3a?=
 =?us-ascii?Q?bAh1fs+GcIQEQmsvA+LKnmmKRrFWEQTg7dl+lcUZ5f//bg6ptvFhaxQL6M40?=
 =?us-ascii?Q?EIQiICuVZOMtgcTEyHOwivsb6A5FzhyO8wpkj00CtxLsv9/BK4Qhs4YacA3s?=
 =?us-ascii?Q?ERqdyMsgYQpbnI3sP6TlQsDiv3uo51TDNRhC57uNCaYKW+qqbgp5jFhcZBxk?=
 =?us-ascii?Q?w2t1QpgstYQn28dx+5x72/wO1slvfpaSW/NCCRg7R0UPkVX1KU4YzUChfp5v?=
 =?us-ascii?Q?5ckYZQ8m8Yxan2ME2HfB7BmHwf0de5Dn0USM6qrdIis1+crCVU2LkE6ovcFH?=
 =?us-ascii?Q?SXgyUIIvzwRbwZF2LeVWDogMI5YfXbiwAP2vBOCrZ0tgu7beA0Wc09MxF1jH?=
 =?us-ascii?Q?9Q10Z2sGza6wUfwo/nIYJGZKyNwp4LP+e//modobraKwBUOXqB5NiW5P8ibr?=
 =?us-ascii?Q?o7X8x6cuxI1ecjlMBT3b/QfPY7+UckoU+NQL9jAAgPf/L14pHMIuYGU8P29n?=
 =?us-ascii?Q?wIa5q8pCMl9P3vWipVi/VFgYMGOZ5UUCB6SPDzWnDoB2MAHerPBIbujav64y?=
 =?us-ascii?Q?qX5StzDbBOgWY9dbZVsvNjPN7klANU/8HVTTg6fvkxyUbcStJJVkn8R9Xvfw?=
 =?us-ascii?Q?3QcJf0VC02xzUgN3p/g33VDi2kSzRanNAD7NzSlELgWGBTWrwrl4tS6l75go?=
 =?us-ascii?Q?oqerNmYXH93HPuFzxWGCvSorT/hgZO5EZcMvYSkbjGXclP7cZdrOFW5ZB/kG?=
 =?us-ascii?Q?NGgmSGi3cKEk15ghos+EkUDiFA1Ksb8XG2Dp4mdZLbgp5pKpPRcvJYaVDxwM?=
 =?us-ascii?Q?BOJ4z63ji63aLCZg8HcbvfdufImL20QinC7UccV4XqVy7CATSQ3QKrh61ceY?=
 =?us-ascii?Q?w0V3JnJ+Z0wBOJ6W/I6kUtutYXZwfZZ2btCqYsXLfI9vnNLAUZwW4FRxS2Si?=
 =?us-ascii?Q?7eHpmDStp/ObqE4NWVqZsU1PXsfiRvECMPVuKrinMTV+FqzrYTDeRPveDUoW?=
 =?us-ascii?Q?+exeuR/lKuDbcOrRoLMV8JQiUOWYw+vz44+YrkAcVFDq+U8gC4rLszufWaCJ?=
 =?us-ascii?Q?BeSJxcCLfJl2tSm0jve2XjNff+G2KFAmyv5jqxEZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b799e599-d606-478d-d591-08db022a408e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 18:54:29.7885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQly7aPim6pYIzgPtW44nA1aPNuxG4NtDW01VbrDTlh8ZoL+aMLcNVGJ+VNLbQfK7ihX33wubFr6Mr9nYw5AFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3745
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Sunday, January 29, 2023 9:26 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: RE: [PATCH net, 1/2] net: mana: Fix hint value before free irq
>=20
> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Thursday, January 26, 2023 1:05 PM
> >
> > Need to clear affinity_hint before free_irq(), otherwise there is a
> > one-time warning and stack trace during module unloading.
> >
> > To fix this bug, set affinity_hint to NULL before free as required.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUM=
A
> nodes")
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > index b144f2237748..3bae9d4c1f08 100644
> > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > @@ -1297,6 +1297,8 @@ static int mana_gd_setup_irqs(struct pci_dev
> *pdev)
> >  	for (j =3D i - 1; j >=3D 0; j--) {
> >  		irq =3D pci_irq_vector(pdev, j);
> >  		gic =3D &gc->irq_contexts[j];
> > +
> > +		irq_update_affinity_hint(irq, NULL);
> >  		free_irq(irq, gic);
> >  	}
> >
> > @@ -1324,6 +1326,9 @@ static void mana_gd_remove_irqs(struct pci_dev
> *pdev)
> >  			continue;
> >
> >  		gic =3D &gc->irq_contexts[i];
> > +
> > +		/* Need to clear the hint before free_irq */
> > +		irq_update_affinity_hint(irq, NULL);
> >  		free_irq(irq, gic);
> >  	}
> >
> > --
> > 2.25.1
>=20
> I think this patch should be folded into the second patch of this series.=
  While
> this patch makes the warning go away, it doesn't really solve any problem=
s by
> itself.  It just papers over the warning.  My first reaction on seeing th=
is patch
> is that the warning exists because the memory for the mask likely had
> been incorrectly managed, which is exactly the case.  Since this patch do=
esn't
> really fix a problem on its own, I'd say merge it into the second patch.
>=20
> That's just my $.02.  If you really want to keep it separate, that's not =
a
> blocker for me.

Will do.

Thanks,
- Haiyang
