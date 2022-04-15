Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A99A502BEA
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354583AbiDOOdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354624AbiDOOdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:33:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2129.outbound.protection.outlook.com [40.107.237.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D9BA76C7;
        Fri, 15 Apr 2022 07:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKjZt6nlkUf36cfxgg7S0wHLfycm4sbBzUhyz0yEQT+b6ysAr0BCoqswNddVFxZ5peBV6lS2Gj+UhptA/V+Uk3tuKZyW0EQjFJuvfOi3ggNgW2J+Tc5bukz6QzCLVF1qIQKgge1QUIvsmNQxe1T4Q3/VPFaLcesPnTzqV1lERDTz6+kYqzOvQOYuiGKGbZeO/ZaCcDQJgMDA74hLs9r1El+vMYqM5o2vkOIdPaOx3X/yY81QkQBA6Aw9sFm3aA0kDkC2wAk4utdteY/2/J+StJWQh8MTWOSD08tNpSkupKne6mM2zF0DntbLG4j/7lDesJs7camXDNTVXfvG7t5jtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiDbvgatAz2cfOoblgI2QtLx38L2MWj2IPTtANzelH0=;
 b=B9nK9y9vGQ0QuNd9UlLMKq+XHjnlx0x+Z63FxtXNuykFzpoyebNThxDO5LIUNFx0i8YBzKyMIswvipBFTr/YThpEBicLhISI51RsGEddI7ySdDmhAPlNL2G0d3/3XoliysfiX/BM7hWt726VntFdIhuDrMsH5W4eg9kK7NAk9vOGlOSSVOJnWBH0QZYeHINYoV5i5k/Z8lUKQ0u2WLyjwFrjEVR1L55M/0emxpf9fHaUu82LszsqrozXIvxxWs9c21ebUCTGFq9FGltqUxAm8M98/x0G7tVSH7YowzlVZwRcXyz4fyZx3meMHaLFE40XqdQ6mhNVEE7vDvWFCaGU9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiDbvgatAz2cfOoblgI2QtLx38L2MWj2IPTtANzelH0=;
 b=e1L0LYMd3kUE9kDrs3cHLQfmQS6eAzTKXbfQ5Zvqw+8CKuJ0iBcoxfeE/lozoy7sLgtIEhk4P9TJMmeycJZZncWz3x7jrKB1h3EyhEH0/NdGKGO/oIznOMEKboDtOl4Qnt/Nn5sOYhczJcpmtwMn21Ied7wKdWgDFlEArPZ0IVc=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by LV2PR21MB3350.namprd21.prod.outlook.com (2603:10b6:408:14e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 14:30:30 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.010; Fri, 15 Apr 2022
 14:30:30 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Andrea Parri <parri.andrea@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 4/6] hv_sock: Initialize send_buf in
 hvs_stream_enqueue()
Thread-Topic: [RFC PATCH 4/6] hv_sock: Initialize send_buf in
 hvs_stream_enqueue()
Thread-Index: AQHYT3fj0GpxS7gRakKuoVXd9R6gy6zvoDCwgADrHoCAAH/W8A==
Date:   Fri, 15 Apr 2022 14:30:29 +0000
Message-ID: <PH0PR21MB302526F1483A6FC932AC55CFD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-5-parri.andrea@gmail.com>
 <PH0PR21MB3025F58A2536209ED3785F24D7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415065041.GC2961@anparri>
In-Reply-To: <20220415065041.GC2961@anparri>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e784f1d2-f130-4552-8e55-cd1be966c940;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-15T14:28:13Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f43d2a40-2df9-42b3-b08a-08da1eec7de7
x-ms-traffictypediagnostic: LV2PR21MB3350:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <LV2PR21MB335025BB73F022C6FBFE2C97D7EE9@LV2PR21MB3350.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t9wcN4xIA8ubv2RSMHV2AXaMbv84CSIJkw7kftZ5RKwsR/RJ6g3+QumOeO1JPEP1paOPLfm4AkbPxUieXd2c6F/0DYae2W2zzGsh1CPA5rRePm6GrgVCPpHIGe4ShZFA9Z9xBZXMbwCcTH9mXA5HFiIODpxfbZY7lwdBjsvqijFo2CYQxUv23y2fZKKvsRildLubOFlFsDCtpfB02RTBNEbqKzsXV/fMaNRFHHuolxCwQWzAkeTdcPcEdqPvW2hpHddlKgEEnYxJC2uA8PMWV2+2xwNjoCl5w6VA2ISdiho1z6YFBM0zA3wS6hq2kHCVHVvbYn8frlmJT9JgXhL4rfLfK37/MRBmcoBbPcpUi4N/k7xGftsKKDW/ieAGroxfPi8oZWgsiHLREpBjRoFWUAJV0aUmX5fMbVu3pYb1bKVpfcGTSvwh5sjFCvFVsqb6tO+O0I9/1EtohUbhLqACOvjnapTus4TYvQih8wy6vIoPmWzKWg8ZENSiRExsb/sFFJk1EO6cKW4jfk3NM6qPtOzpQNmoV/PKE8BOl3MyoK2r58xNLkn4fLwVJT+6SAtlxFdndjje3B6xDjxfsVNQiKX+CR23X8cQHhp6HUOsmR6/DOlUnvbHTUtBuG4GT4CldPPFjzFZeGykRAt81I7EZYejuYegNnwMQjemGeUyHozCa1oS6uII+vm4qN5XkzBe+oM+7Uym8UdFbAlQFjHCKOVaLUDlCAA9oRAJc58YpceUozZ8m4rvte81VSUg+as7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(10290500003)(86362001)(122000001)(71200400001)(6916009)(54906003)(52536014)(508600001)(316002)(8676002)(66556008)(64756008)(5660300002)(76116006)(66476007)(66446008)(66946007)(55016003)(7416002)(82960400001)(82950400001)(8936002)(4326008)(33656002)(38100700002)(186003)(9686003)(8990500004)(26005)(7696005)(6506007)(38070700005)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aCJE1A80fiOYq0Z8a/SObAqA45TUrfg0z+wEWRBsl57S0s0eUOtV7+dwnILX?=
 =?us-ascii?Q?1nf/XyrbjGb+Nns0Cj64WM11BOquabI0VLCRgbSDnKog+VGr0fS7tRGUzbrf?=
 =?us-ascii?Q?naBy6mB66gi9WDIn2jnPVl8aSd/LnrMnf//Scz4WBkN1v+/o6X7NY90RtTgj?=
 =?us-ascii?Q?zakU9J8gJPq5BN8TZwJkN4VzQkcH8oWKNtc35/zHuWFDsdkPhgRB48fvc2Rc?=
 =?us-ascii?Q?G2NG6tL6W8TAbgtxWXpZvNtnv+IDl7nBvom8jyrDILPoUV7ONiMhP+jIPKDp?=
 =?us-ascii?Q?QdLDaSU8HTJEZOSyUK/WSFS1h2d5WE0RHDprVBTCyzzNa4UQCCAl51VAnpF5?=
 =?us-ascii?Q?sZCdBL7ewNF2OFomMGWNA2pBBkIJeN/cBG798oeZBBWKFXcjIfvacc+kzW9B?=
 =?us-ascii?Q?dfQAePpdFB1hp0t1AOiTord9Cv5cRrAnSI0IuxeXOJNZXu4GZ8SPXQzHkQEk?=
 =?us-ascii?Q?Awv9jFgnnSdpKoRTImNcAi3SnS4+8oWlwgZ8InMlAzxGCsoCXv9MsGNyDtlD?=
 =?us-ascii?Q?oMkx0f70uFDysl9nFdhThtH3+Dx6VBSNmud6/sEB6yIGx8YefA1yFZ5uof3C?=
 =?us-ascii?Q?7Innr9ZpraIaqMMgESnEIBc/IrSqwSEWPztE1I2Bj1kXo7/IVj9g2OPls69j?=
 =?us-ascii?Q?FsGRSVWjK3A/XYm+rhopZqjqAIaBEGhMhfLzkpUVHPZA4aTAaHlBhn6t1rqV?=
 =?us-ascii?Q?P2+g6sSXpwNb0zbyH6RebF/6pveWcWTAUGAO+RTqkOofZpUAGUfXNIaL+qbF?=
 =?us-ascii?Q?cNUNDyGFtTPnBLeUGsNaa1XfKf0RqU78Rn9qI1P4zmFDYrtlu0JFv2QfTDJk?=
 =?us-ascii?Q?j7104RRk4HQ1Btyb1HmCykBCn3SL8StLJneLG9i0gtjZjLrKnIL7R8NKbo/9?=
 =?us-ascii?Q?kTU6V7wlYnMUteCOF0smwaksvjbod82I58GcvjCaOM9j/YBgTgMde0KHHQb7?=
 =?us-ascii?Q?ZA5E43tLib++2+Lxnxt9+abeXC8f8fm495TxIBzy+P9uYS+TtCF5F5Kzdekq?=
 =?us-ascii?Q?W0DE9BdCiv6ERh5v0VDP1ZVemHJyGVrSMDMrDW1bl3o1LCjMuRAfrF5BYA/8?=
 =?us-ascii?Q?JziPDu4oQaT5NmNh71aVetxW6s9uRxDEzOvJJsZBuqhHkoEQ5uIq03G1zLxt?=
 =?us-ascii?Q?8GLQVo0P+L32dWLdPjMJbR48GY3ol5uSTE/bo6Phxa5UrtiaAAcxVzrIxUYR?=
 =?us-ascii?Q?tVyg9puV4ViW8ZSDWju77P6N3AkChTmByoPoMqSWQZBzFDkUIlFui0Jc7C6W?=
 =?us-ascii?Q?KUMaFwUwJoiqbZYx33AnhMudoadF6BXu5ZDpeMplVmgkLXRfUsaeU/fTvDwc?=
 =?us-ascii?Q?6+4tyoFPR4cTUdKTMXCTv2cv4sC0ugetsIZdxXDfY56YjGICZ2ViOtwmWpxc?=
 =?us-ascii?Q?+y+YUwxN4b/pGuEEljG/ZZOTnr2+ns57EyeGL7pOFqWwzOFJDO4PgTwSl2MM?=
 =?us-ascii?Q?BI+qefb77q7tpAUJoip97oyvb2IxRK4IDcnYAxMtG6rVw8TSha2qfKU5x/eZ?=
 =?us-ascii?Q?SL6q8wraUDrCQXpyeGXVcSN44ySfzGWcZN36JH3sWgbrMItNN9WODnHblaTv?=
 =?us-ascii?Q?ds1saHOKCSGNNGPyBk+dyq2wfBnD0AVwgVOoorTeQJbKayIuHDTKNq7Xgdsm?=
 =?us-ascii?Q?s1LUOPGek1sl/k8epojNGM/RQb+CBLNAkPmJvmpUOsjd0Mu1ANJEls4PqXj1?=
 =?us-ascii?Q?1OMFbkufZxMvMJ4bm9ID6gr7yehxkrb288/VbJ9iwbMZY4JDo8Mxf0AUMhfF?=
 =?us-ascii?Q?sjqFvzQ24+f/zVm5GPA5RlI+vfBZ2QA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43d2a40-2df9-42b3-b08a-08da1eec7de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 14:30:29.9586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jeVC42MOshZRUM0vrlN9lKyPpxHVMbdnL7rginbxfkFrUjfcmoQV2Hr/dZiTUbrtz61yMSV6+NDg/PlHDohJQvnMMGXk62z/rKHn2LJ42SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri <parri.andrea@gmail.com> Sent: Thursday, April 14, 2022 =
11:51 PM
>=20
> > > @@ -655,7 +655,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_so=
ck *vsk,
> > > struct msghdr *msg,
> > >
> > >  	BUILD_BUG_ON(sizeof(*send_buf) !=3D HV_HYP_PAGE_SIZE);
> > >
> > > -	send_buf =3D kmalloc(sizeof(*send_buf), GFP_KERNEL);
> > > +	send_buf =3D kzalloc(sizeof(*send_buf), GFP_KERNEL);
> >
> > Is this change really needed?
>=20
> The idea was...
>=20
>=20
> > All fields are explicitly initialized, and in the data
> > array, only the populated bytes are copied to the ring buffer.  There s=
hould not
> > be any uninitialized values sent to the host.   Zeroing the memory ahea=
d of
> > time certainly provides an extra protection (particularly against paddi=
ng bytes,
> > but there can't be any since the layout of the data is part of the prot=
ocol with
> > Hyper-V).
>=20
> Rather than keeping checking that...

The extra protection might be obtained by just zero'ing the header (i.e., t=
he
bytes up to the 16 Kbyte data array).   I don't have a strong preference ei=
ther
way, so up to you.

Michael

>=20
>=20
> > It is expensive protection to zero out 16K+ bytes every time we send
> > out a small message.
>=20
> Do this.  ;-)
>=20
> Will drop the patch.
>=20
> Thanks,
>   Andrea
