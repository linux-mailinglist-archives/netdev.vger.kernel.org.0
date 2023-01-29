Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A61680116
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 20:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbjA2TFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 14:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjA2TFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 14:05:30 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020018.outbound.protection.outlook.com [52.101.56.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFF9FF32;
        Sun, 29 Jan 2023 11:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieCCY17zE1shyHBlzF9z5SAwIFQof5HMuyoohtfuE8cPMjFXq7xE3DyjlhUAJw64FGdJdas0ebT/+au2YKBcOg2VtnvsfMmimAOxgME4i9rAd7gAWcICfa3wQZq0CWtEFOlmAWKedA0gvo9K1tpvkaSs1hD4rZxQZhoHhMq0ZKB1no358SttJ+8juZ5KLiyvOT6vwSk5hrG7law/H5NwMtzQ8TUXWGXa0+QG93gKiiNIgl0Sjr/1G7gWH/dRINo6/kDFqEs6YMIL7IvqIQ44rxamgeOQU4ld2+VsHzoYwsAKY0ctPoKDd6VifpmWjdyhsce/JLV8uJD3v23u0h+9SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWhF0Xcj3jJkOHy0hZbgN7nzGvkYOVYHd+qp+x4Sx2w=;
 b=meADNbcNRDIyiH1gsRCo25ZUsgPISy8fXBAYDWPGUOYePudXC/gxrAq189U9w1uAW9r3g03mUMKTWPIdB/sYZoxfXWAdVyEIetWtde6slu69nR2NExb65GzBJdUv+LKC6v4hVxXEk3Q43pJ2Z/oCG7oqyMOyzoifSVwtpLkqR2Zaoazkj0c5zMgBoXIylXrPCRUyyNgAsZFq+f+Cp1K/jztLphGK4+whFMyTfzwm74vunO/1U7+nS6iE7rpWCTvy78PzibrIweRZnMaodXEbaWdmiVjud/IRf1UFIG/qk9iSOtfBodmAgSdy1D8r/Bir63MOuAGtzQ1jo1hMFGkFgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWhF0Xcj3jJkOHy0hZbgN7nzGvkYOVYHd+qp+x4Sx2w=;
 b=cnnZDcp1KVdvn9Mqvbe8J2qMMVO2Cig5k2YdrXysgqSbnsLN8b0hXlQ6ojp1qZ7zM0AMZOhJIKvAM3Tfw4rT1uA6tsyhkhh+RY9K7dM6oC5ozRKt2K+rKycfg/c9hyQtCTKQN5YNiK2qyGTWmItkypeGS1TvF0+DQgNb0doE3fM=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH7PR21MB3143.namprd21.prod.outlook.com (2603:10b6:510:1d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Sun, 29 Jan
 2023 19:05:25 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%8]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 19:05:25 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Subject: RE: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity_hint
Thread-Topic: [PATCH net, 2/2] net: mana: Fix accessing freed irq
 affinity_hint
Thread-Index: AQHZMcn4aI2nsbHR902MpaNNd4HTWq61d9eAgABJsACAAAL1cA==
Date:   Sun, 29 Jan 2023 19:05:24 +0000
Message-ID: <PH7PR21MB31165BC34B4014EE55F17689CAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
 <BYAPR21MB1688D54F89D19932B3654E0ED7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
 <PH7PR21MB311613A4A8C7436BA78506F0CAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB311613A4A8C7436BA78506F0CAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ed50092a-4a52-4891-b37c-98888b68e03a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T14:04:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH7PR21MB3143:EE_
x-ms-office365-filtering-correlation-id: 508ee2d9-f0c7-439d-fd3a-08db022bc704
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hPJsSI2CLhLONm1NFkL14THnwKekvGzuzuGBsU4gFVZ4T7yOKO3W09J9JtCHoIrDZ0vaJ4v7/y0f8ujq6cZB5m/b+mvcm57YnzkkfqONRmHKKtpI+aTl4VzHzpqXjdIZSco3SHZNzZczsn9tSL/oveRil0HZU2mubNq4UzLl5iXdJnfVD+zkb6L4b96nj0GXnNL3jXfsxa56FeVS6EyjXWVZPyQ7ckD/SeaVpYdPTI3Y0ICeYGh/3fipEES/DKfV+7ZQ1v1sjSADUpCTejKu1C2wgqkL/JZOeR2rtokmcIoWjlov8DFBfE4f8M/u4YD/9txd1oaiH9CO64JZpLVu710vISt5bwP8096X4Xw1x8jAtbWnhaEsybAEXWvoD6kUoMi+AAiXfo55TN8N2vPojToWW4rHj19pDrp5BJuuiV264Lov7IwY4kgaE+XJ0sIfg7KAAgdG2ZsBygqddd5JSGrN9qePfENpFvyxHH2ZXqNXVI14nfuizoj8N3c+Bll8yNeAkBVguzuYtEU44nTb70nGOUePS5J8HsLIGs1P32QAeu51hwBFBoNX6oSLysjh1hOa70oPmbbu6d7rV89Vv4n797GGm6Ji6mhn1PI7bzENOMaTawd17HqlhmwBtU0HhkymNvYCGpiOhQUvAya6BIpTPiau7dlAagLmynik3Zeojyyz9XQttlY/R7GQLN1keMKrFRq9zAfR8NOCB77ytP8zRC5yyeW8NO9bRsj3mOFDAeWDhjhNYdDNJYnzUccm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199018)(66556008)(10290500003)(83380400001)(86362001)(6506007)(38100700002)(82960400001)(8936002)(52536014)(8990500004)(53546011)(41300700001)(82950400001)(2940100002)(186003)(54906003)(38070700005)(122000001)(76116006)(110136005)(55016003)(4326008)(478600001)(71200400001)(66476007)(26005)(2906002)(33656002)(316002)(9686003)(7696005)(66946007)(64756008)(8676002)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zabordD6hkHMQjBezgDqAcWLYoARlZ1fmvHYd3FeF6b1ITbnXza56uZyhihD?=
 =?us-ascii?Q?tlXRSEk9wJ4cujANuADkUhS8yJ7iPId0dV/qlkztGEmookY7ElPmvtYmRS8g?=
 =?us-ascii?Q?s5UxHEEwUPpJJ5Ja4yEF4WiMqhpKTmapttuUTg1v7FBZrntWhONQgoImKRN3?=
 =?us-ascii?Q?A79gpLuDYUODqftKQ9TVyShY38sVwwpPEOHnKvUutUmLKMrj7kjzo4WqebbO?=
 =?us-ascii?Q?85UvchA0PApt/wXbI1Ke+bNB9XNNihui4XZxkqhI3McQkAHwtpzq/t9y71KA?=
 =?us-ascii?Q?plS5lFWdRaKiO4MzolhPVYJUGphg/AcZAdfKPirEg5dn/rLtmISvyyqiogY1?=
 =?us-ascii?Q?POsNERAmZAGMH1KQP78wDt/ySBydhK3IhLnX52lrrlPWnEP9ozQm56UZl6m1?=
 =?us-ascii?Q?lPvWz+2//HUkJSWPxug22A8s6Nmt2eI1AejR7tC+/SHqp2fBi0MXqpiFLV0Z?=
 =?us-ascii?Q?LOnXTRVNsc3MGMeAVigTj8RFh4lyijTtdfjlMJCt1l8YII9cTjstTPntZDd8?=
 =?us-ascii?Q?EUsrvsyEvSaSw51FiMh/PV8LJTSbc2oa0DszAww6JM+OglWtI5veQtEM4+pL?=
 =?us-ascii?Q?aqk2u7ot83mPDrZ4hjNfKQhAq2NFN5U0wzmL/XlKTjOb0iEUH0TpRS+Q5S5D?=
 =?us-ascii?Q?Nuv46aHRAy3ar0ObYxo+QhMi6rrGiN423J/8lXKdu2dqb0ag59X5foxexFTQ?=
 =?us-ascii?Q?lUVUIntuen0E5KGjGaK0J83NCUribpYx0rkHKSytjsL7ndPX3/EDNddiPInD?=
 =?us-ascii?Q?E/ILC5FmX8eBkjEj8lcK3XBLvYfN34b8dgn5cNlz43Tco31EOhwVx+Vn8/Vu?=
 =?us-ascii?Q?0Ss+RrjF6GqzAqWxgjczFme2AEovsZomjZ6cCPUFmkJ7Sb3J/D9aqsWEgNLS?=
 =?us-ascii?Q?6mGlmcyz61gZ1FE391QiAcWFgitYZxxp79WlL/bBg2csZEtPzkOqwxJk8MkN?=
 =?us-ascii?Q?h5Rf26xQA/T3n34wvfjTHYHpUi/mULGKr8LE04ELzAj4lH3F1BmvtRixLC6O?=
 =?us-ascii?Q?jPmYpeda2Sohls6Rn/wnpWjY66Y6DPb+K62ru2twd4MJDTb3feRfFlXR54zQ?=
 =?us-ascii?Q?aN+lrRGha5Qv7rymahTdpJfWJWWjQpMpsdHXqRK+w6Xx2iVOJlCP5Va/W5cH?=
 =?us-ascii?Q?imSdCTwkglYZUxYthy+VdS/JvMlb3wanoM1CC9/YGY7sOH1yx+/as854ypwd?=
 =?us-ascii?Q?0Epkwfv0NkFLreGG1cxBRj5krMUbPAbaxD/I7cRBqvJeHLdGhh1M/wvE9666?=
 =?us-ascii?Q?+05nDlujjqFR8n4DoCU4sgpuXW1wWf4rj7/F58OcNaj7t0YKNP7pDQ/iyStT?=
 =?us-ascii?Q?WtEfMmjZXTy38ZRkxaas6N89iMz4n0+FKS1+ticsGOYzR0MjBWqsNHmIKnGN?=
 =?us-ascii?Q?jE+63syy//e596ff6HHS2PGgez5mX7kxrFBumqz00clyCjwGpYSjWNx9jx9O?=
 =?us-ascii?Q?mk6YvehHGvcavM0ud+7Ce8jwu1EdwzExLUfJuPgQr71/BqF47tck6Y+/UUdS?=
 =?us-ascii?Q?Q1v9YgBZpIMA4mbZnJD4hKIU/r5Ka+q8noPHPjrLAgbmco3T5CvQEE+ZfQ3p?=
 =?us-ascii?Q?sxE7ymZg07P6Cf5fFhDC0oJxBO/RPZDDmIW0+VxH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508ee2d9-f0c7-439d-fd3a-08db022bc704
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 19:05:24.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a+s4TWnxRDzDLW5VmZJiRQXTKM/RT1e9hRSiDpOc1ewQCu1KLoeHeadE8mLDYdiUFnau75jec7xLWc+jOIsybQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3143
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
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Sunday, January 29, 2023 1:51 PM
> To: Michael Kelley (LINUX) <mikelley@microsoft.com>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org
> Cc: Dexuan Cui <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>;
> Paul Rosswurm <paulros@microsoft.com>; olaf@aepfle.de;
> vkuznets@redhat.com; davem@davemloft.net; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Subject: RE: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity=
_hint
>=20
>=20
>=20
> > -----Original Message-----
> > From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > Sent: Sunday, January 29, 2023 9:27 AM
> > To: Haiyang Zhang <haiyangz@microsoft.com>; linux-
> hyperv@vger.kernel.org;
> > netdev@vger.kernel.org
> > Cc: Haiyang Zhang <haiyangz@microsoft.com>; Dexuan Cui
> > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul
> Rosswurm
> > <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> > davem@davemloft.net; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> > Subject: RE: [PATCH net, 2/2] net: mana: Fix accessing freed irq affini=
ty_hint
> >
> > From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang
> Zhang
> > Sent: Thursday, January 26, 2023 1:05 PM
> > >
> > > After calling irq_set_affinity_and_hint(), the cpumask pointer is
> > > saved in desc->affinity_hint, and will be used later when reading
> > > /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> > > allocated per irq, and available until freeing the irq. Otherwise,
> > > we are accessing freed memory when reading the affinity_hint file.
> > >
> > > To fix the bug, allocate the cpumask per irq, and free it just
> > > before freeing the irq.
> >
> > Since the cpumask being passed to irq_set_affinity_and_hint()
> > always contains exactly one CPU, the code can be considerably
> > simplified by using the pre-calculated and persistent masks
> > available as cpumask_of(cpu).  All allocation of cpumasks in this
> > code goes away, and you can set the affinity_hint to NULL in the
> > cleanup and remove paths without having to free any masks.
> >
> Great idea!
> Will update the patch accordingly.

Also, I saw this alloc isn't necessary either:
	cpus =3D kcalloc(nvec, sizeof(*cpus), GFP_KERNEL);

We can simply use the return from cpumask_local_spread()
without saving all cpu numbers in a tmp array.

I will clean this up too :)

Thanks,
- Haiyang

