Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BDB608213
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 01:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJUXc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJUXc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 19:32:26 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020026.outbound.protection.outlook.com [40.93.198.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14112ADD3E;
        Fri, 21 Oct 2022 16:32:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVtXERw+EcciVVmrT11u7VuYezmDaEe/6bKWtScvKc55wamzQx6CwMiUKW+S/5fCHoFmZRYSblquFrDG92XCZA2dOyxd/1vmgRhQWneynkW5Tk1N7jE+KJuDL7LEtN04adOmlwznC900tlnirphdbP9GzYSWCNCLZb9JDA5aH5GWZGSGyDrRYxy34UZbwgJ6kzvGUa8HB+0PLFwG6kkfl+J9SsVr5AS+TmqsOmYDra0FyBY/OvMwZCihgypFyKLKB8r9DTrLFEVsrgskwGDDwGmZsx6tGgg6H3UaITxkIqxUK1Xq7OcHOAqPgvn3wr6dPHWppgsaKrk99mhQBuy6vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZHOtPLL3y5/VmSP+KvwQmcIa7fntXIB97ChZlLyG8c=;
 b=R5XtWTK7q7uD/T4HBvXfiPWwpVCoGhx/4S9PP85/qG6j6nnN6P5VZ1/JfufbQPKcIrPTbUmo+LVFc1a8gqS4iqMkRMuU8xPW0B/UYnB0kEI1OP4u39iXpUs47xlLjCXYrVCJY8EXOXCTq5Y8P2r1KyYKEpK0XgLx6z4ztGpNHrL+9ecLUWaaRbnUS7XJaClrq5kas1TX437K3vVf1zyOahgb5nuSB0rTV8cc6b+3GPMlskzHA5pJ4hkh+j6gNjgOGu6Csp2ft70OHjIOkDv0nFDKWr4+O/j+t32ym0zEGddz2OCGm5UHmDrsyniA5wlJ0XoIdM/XJjzcnpJDXDOPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZHOtPLL3y5/VmSP+KvwQmcIa7fntXIB97ChZlLyG8c=;
 b=frlrHWaYtmyGRgvAx7g+tpAcnF8gkSfwHExMib+m+cvU66rt23BICi+J1vnn+iPavCCKZQabWj2TE6Eg2mSfAxVPeKY/+YgojWNCuuP2fMDi0pLrWaSKeKS4FQOfmB3F3QG9VYb9CdCA1L94GuukB3MO7356H4p9xN57KaxZqlo=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DS7PR21MB3292.namprd21.prod.outlook.com (2603:10b6:8:7c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.9; Fri, 21 Oct
 2022 23:32:20 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8%7]) with mapi id 15.20.5769.006; Fri, 21 Oct 2022
 23:32:20 +0000
From:   Long Li <longli@microsoft.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5AmQQ427gtVraEOIJ5+rCERFPa4XHQ2AgACeAYCAAUfPAIAAdaGggAAJCfA=
Date:   Fri, 21 Oct 2022 23:32:20 +0000
Message-ID: <PH7PR21MB3263C613FF4CC1CAD5F126EFCE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <SA0PR15MB39190FF40EE305671D1C061D992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263BFE218601536B937F59FCE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB3263BFE218601536B937F59FCE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a6ec0a47-7bbb-450e-ab60-f48358a86509;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-20T20:21:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DS7PR21MB3292:EE_
x-ms-office365-filtering-correlation-id: eac99261-2f77-4351-ad83-08dab3bc7fa6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yRlO2lFg0KB1HdPlnUDmNLbrKO9dDMh/s3pOQRascgM1KZtKT4gk4SepdRUmmBbUkd6w61aL2MFtljY+JYG3P7xJp3OC6iNu/L2oCsI1khnIUKA5ztkwsXI4vUKPT3zucFQDqyNM8is6/kGl8+8aOl0co/XUyDeN5atN7RS8065W8HYQ4NmlaTIs+0cpMH5DNzeaDrsBe7E6feauvP+KMwKJuXttGa4EGM5TikINlbyXreWvg7j8wD9Eeo43XTbOKziHI34qz+mscyUgS1TAPpfHqCfpvCCjV/RnEzRjShyxPADQazanBzm+UH2RAuM2HCch7bdI8nsSfCrB/bz/g7OdOweU2XKIgJhvqK+JogZmLbI2Wtz+99GbITSBVxY/k0hKRJDBkm62YCPPk4/s9CXKakgoKKlK1XIOkyl3jeiUAdx2eKdBQdn9eW/BibV8Am/OFvqFOADYT+05d0eaFG5eF+5S7FMG4qK0kZzL14IyoLeoJp4AeHbOr3xbLO95bu4L8Ve5GK2/FZthLx//idVcUyLgTzna+35a8cPxBuK0mrNgPMKQ8XvLhZxDYkxWRx+70jOOdzS6bWa5PhEoo4WbnNdylQtDL0DWa7BBLFC78BK0JOuTvAb6y4J1vy83L73csO8HQJLBDPqr/clarQTqYgFFVqBqqywu1v3F76xPydfz/4i/RMxLX8EVzSOcFtsxJLrbKUY4Sphkt1pRgd+nOg/8TFoLFG4cunAdbWfQImFRGYef0y6lEiZVR+7QadnAfVaW/knwgiu2Er9te2bL1diLrgF/JwiupAc8wURQA3Un5arnC2NydrRIoeghkRmOKyEDzsmRSNk/yyLoSSAcV1Hbc/CEUhGYLXI4w5U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(47530400004)(451199015)(66446008)(71200400001)(83380400001)(33656002)(82950400001)(10290500003)(82960400001)(54906003)(38070700005)(921005)(110136005)(6636002)(478600001)(52536014)(9686003)(38100700002)(2906002)(26005)(55016003)(8990500004)(6506007)(316002)(8936002)(2940100002)(8676002)(86362001)(4744005)(122000001)(4326008)(41300700001)(7416002)(186003)(64756008)(76116006)(5660300002)(66556008)(7696005)(66946007)(66476007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LbX21GT82FpRJ1d0bNNN4ahzsfO3T+sWvFOF6DBnq3fTwUQMZ/VJIuoMCkm1?=
 =?us-ascii?Q?cQkfLhmOAAYhWRFJ/5M2OYQwF3JOBcU3IAhsIEyUxSKM1ZcqRSVCeAwVB2aT?=
 =?us-ascii?Q?lG2tgMcJlCdJRX4ks2DlT0L6/gd9YE41lpanQzPylz8VOxAprVblXu+AqnEJ?=
 =?us-ascii?Q?ptkjX64bDqYGnr71UDjo+dbGUz1Fhu+994Zks+a8SpPUWSF6d191Nhb226G1?=
 =?us-ascii?Q?B3F1ZzmMjg7KDpiAZutvAGgZ9MS6pxnxC+CU6euOBT2XJPg+9EZ3PFKaTYbu?=
 =?us-ascii?Q?irOO+r2qn391DhYn7D7YIBrl/wOiRpDMPTmMa4x5GnzxOBdS1Pb5hhN500Ol?=
 =?us-ascii?Q?YvsiFbcGQ+zWYH3LZBur7WVWlzAllOaacgqNGLcKYCy1xkmSSUWfxVR8EYYc?=
 =?us-ascii?Q?HttYnbWK3bT75OcDCVBACmGV9/v0ienLBllk6hLii75EpQtBUEfQ6alz76vR?=
 =?us-ascii?Q?uAYHdUXZ2GCgOBy+j8Leu08Oa7FnLIfg/8h5vH/nbwLB0ObpwtFlYoCgCJRE?=
 =?us-ascii?Q?wpXtxAH8Sd+porLha7oNslHkqlfLh7shSKG1kBVewQZcuwO12eLda2PZMsce?=
 =?us-ascii?Q?Q4d9uvjRC+Pz3zSXyWZeWISg2zD1kqrQcJZI+yEdpNFCSQWSlnqv8uT3cLkA?=
 =?us-ascii?Q?tFljTItPu0FWdey0idlxZIwGpFKYpdbTLXLo70lfyZ8iTkUc6N2fkCMvrcHX?=
 =?us-ascii?Q?puy5nGlhof6kuCBNOpkSAfgScJO4Zdm0aI5N2SdVWszKFnnrVzoNr2QKyi3m?=
 =?us-ascii?Q?hPQhUulkGrBpOAuzJoOOPFVPNcjrUy2jxyS5HxXtr+kg97vzzvO6eh4/aDL6?=
 =?us-ascii?Q?vNqIV/6VxPQSLh9ghDDh+6uf109iuWtgx6oTlwXvQ87rEAUw5Z6Ko7vjUwJr?=
 =?us-ascii?Q?+Jhn/TnTSW6MRf1g6ejvccunkAZ2GzkxQuM01Nxoj8/1QobPnHZVIwGDF5s2?=
 =?us-ascii?Q?76r3R+ve+rb2VH8AoASOuFodztXFNtioaVRduMUpoCAQFrM4+QUjv+rrFrmg?=
 =?us-ascii?Q?yi0jxSpDbxpPlbv2k9Ur3eTOiV97kQ25SvvmuWgnS9RRl3OnMx1bn2Ic/c3h?=
 =?us-ascii?Q?00KzfNwHfGyGzbAdK2qFXc1apBWOZrLe9r3ulXhcEFD080Gyv87OqBObphVn?=
 =?us-ascii?Q?OPvakF02yqlOEQa34wKAyDzJzYRYsFf14ZLHqfrn+URc9EPzGegGy9+GOA0K?=
 =?us-ascii?Q?5rK77s47Sby4WGxKw9E2Ov23LIykM2Q5UYhuCqyf1c5HuU0hNgLdRW385AiA?=
 =?us-ascii?Q?JTlt5N/P5ay+7sAtV+7O2GhJoLTlwUF6QjVy1UmcXMaiLG8KZG2S+wFxWy/i?=
 =?us-ascii?Q?Y6I3zPkpisXNfvTUF3hqKdNWhe9BUUkoBOK54g9binuvlcSYKJgheLDbtmhb?=
 =?us-ascii?Q?sqRB8MokAToxJ+FlLkGma3knOnVkQ3iAO6IZIR46eWO/nm4e7DWAXlELd0aB?=
 =?us-ascii?Q?x4LCaKohky7t1AN/POb8+zt4Sayp6RNHsHFq1kVbU+no31ePIpwZf7SugD80?=
 =?us-ascii?Q?GbfmBDvRK/JOLrkNJotZd8aYdaF2k/d4GzfND3J0L4KOIJiyc40vKxqFKHZz?=
 =?us-ascii?Q?9vQ7DzW5bQda3qgZDAT/SKcLFFAquxvJGXmNR3+h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac99261-2f77-4351-ad83-08dab3bc7fa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 23:32:20.2574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AweJoJrIN2M25dCbbupnxv6rWcf/qYXXVawdg0XFekkNyE6O81TKPkN1dMF+6oEct/5R1L+tKo5Z1qIL6RLlaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3292
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > For good reasons there are no abstract interface specifications in Linu=
x
> kernel.
> > I was just wondering if it is good to leave concrete attributes which
> > are not
> > (yet?) reported at random. It is obviously working okay today for your
> > environment.
> > But memset zero everything you don't care about today might be just
> > safe to detect an unexpected interpretation of those fields in the futu=
re?
> >
> >
> > Thanks,
> > Bernard.
>=20
> Thank you for the pointer.
>=20
> I'm making the changes as you suggested.
>=20
> Long

Went through the code that IB upper layer calls query_xxx into lower driver=
.
It seems the upper layer always zero out the values (or set them) before ca=
lling.

I think we should be safe for the code as is.
