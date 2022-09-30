Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FE95F0C28
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiI3NDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 09:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiI3NDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 09:03:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6112B176AF1;
        Fri, 30 Sep 2022 06:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEzJSxAdjb/GytS/OYgL81EEh4D71qOM7lOOdL6hNCZsnJRc2Ee+lTE3OMhMiAZkICd300acYmn0k1UOfLPgpBPQSCgXyXbCOBhVTl/ukyUMe/a3z5Aer1LDpNRx+uMPahBV2rYGgQjNpN99I/ja9tbB3ajMAL5/rF/cqazX/VrOudMlhKSiN94Tl2MnTgaHwaUPqR0OM2YSAO7q2XNaeIn0KoEQm24GzgMkWT2blMdFfZfHtbFHtB6v5ZSvmYHyfd9qjZ8Z5JlYRbo5+0TTPljRKmeYSt7OkqNnYLmdbKgNNwIzyZb0lslrsA8fX3jK99RMYYsrsa6ZzNcD+a7wTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5f4/Ey72EVCrnASdCO8hUIq2diL9ce8HC7Kxfi62G5o=;
 b=d65tHF3w6uo+Ed/MfKpLaYZKFpvWrbCglqiTdCtMb9Rz51z2xAB0GLNg2XnOvGoX1xv3wZEIQtGfXoBBO7IjftTrMmyVq0UFgPp4wSm0h93pldQ5QVapNhD1G/iWEsNfHafZVeYzZCa+kVh6bg8/zadgAgZjJWLAj66wN5OUAyQMGDPBICbybmMBxt7wkx4jq01GsExCk7su74wBZFH4dlyGkgAM1CLHBtqIkMImyZwsKXEV2JUofoXdFgZQQ4j2Wid8/PtOCqH0Xn/jmZCN9uXMaTg/FOr5EgZm+2s9lmOJFlg4Fr1cn13JFO0r0IaNa6RDI0ikXdP1xAN5dM8BeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f4/Ey72EVCrnASdCO8hUIq2diL9ce8HC7Kxfi62G5o=;
 b=ABrIyeDa0R84T3H1lEahZEtbn064K5GwDF5E4pZEHlVBquryYuuhw+two/DqHHEVH18ZDXKzF0dobo+aKFo63WqfIp61MgjtMTQzCsK/TNNELOIicMumb4z7e1Uhc05XppHtnRCjKFlIO7E9OyUSLWdGtSY9Ige1WfkmEWwT6Iw=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3513.namprd21.prod.outlook.com (2603:10b6:8:a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.3; Fri, 30 Sep
 2022 13:03:00 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%8]) with mapi id 15.20.5709.001; Fri, 30 Sep 2022
 13:03:00 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Gaurav Kohli <gauravkohli@linux.microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] hv_netvsc: Fix race between VF offering and VF
 association message from host
Thread-Topic: [PATCH net] hv_netvsc: Fix race between VF offering and VF
 association message from host
Thread-Index: AQHY00EEpavH7b+Xk0qDFQ72IrNakK33QYsAgACqw4A=
Date:   Fri, 30 Sep 2022 13:03:00 +0000
Message-ID: <PH7PR21MB31166EEAA957F467D953D1C1CA569@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1664372913-26140-1-git-send-email-gauravkohli@linux.microsoft.com>
 <20220929192620.2fa1542f@kernel.org>
In-Reply-To: <20220929192620.2fa1542f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=91d4c71b-2e88-4f80-91d4-bcf90f7058b5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-30T12:37:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3513:EE_
x-ms-office365-filtering-correlation-id: 83dcea8f-ec80-4f6e-3f40-08daa2e41a21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ap3yFXQ4QGWrwifPy4exbg4yiKTZ7smZXSwVzubdAmhUtfCMUM74QEt9LSc+BS2uceiuZ6KWNxPQhGzj/exrTwgt+t7xEBk8wdoaSqKz1/HDhLsUOaBs4TjzqrdtbyMYHKXGBwaH//Bu378siMOkiH24zyQoYGTYBcxh+oW3zfRDvEDFjkhOA77W0YTeI5x98aKGTjWflvgu2RT2eMpjT6eEmLV5cpVl1b+TRaAsphngoN6bOWdkh3TqCDGZ1KG7vmK2Z2O+tXMxe4AKanq9ZGT04FQ74sYGFlnbCZ0b/Ajz/95Y+J7yckWaTOQmnvSflR1Ge36eWWQGOymIG4daxpf+U23KIRelqVTzYl0eAppwMmzWIYPk2ipXODP1YdtoIUEYtiqtF5viKIQSqMbgzFXZ/rwnlzgsnNfmrHAYPQZr/oKsDyT/wgAhUSJ4jV8hcrKoF1+neJbJ1LUDV5kE0c9wp5OZ8q6OkCvcrIqA+eEcnYLNCvICksNt7utP+xwHgJr7HgfY6hIA31HN8ItC1k7HOe0btdPEOy1MXcx2EuGVcyOt2aJ8dcyW0OvipG85gjiL053h583ZMGokdYS/YLRG3kKC8KM0CWoFneBVZMNOvgGIdfNyHD0pfk1kx7vDmja893aA2O5J76jvyStZZvisN5UadDk7PiLcBYUJGLSSfuK7wuFT1XYncZfNB9A5ifdJZwpT173UHZA3k0x4eQLkcZ/yVYurj+7WRUPDf/Q/ST6Zhq9mALiHZHtL4QwpAbGG68iPqx5BhkCvDTXPQHtIthy8a+46zfUVZtp00aFbiMd6ngofME2h7aghKVFE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199015)(478600001)(110136005)(86362001)(55016003)(54906003)(10290500003)(316002)(71200400001)(66899015)(52536014)(53546011)(26005)(8936002)(41300700001)(66556008)(66476007)(66946007)(76116006)(9686003)(4326008)(8676002)(64756008)(66446008)(186003)(5660300002)(2906002)(7696005)(6506007)(33656002)(15650500001)(83380400001)(8990500004)(38100700002)(122000001)(82950400001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ncOT0srprFeQKMBmHI9zSfh2iDzMtE3e+7SQeSWfXom3J6adOMQpNEp3vbvr?=
 =?us-ascii?Q?pB4BFWaIugHmFXg5ZIOGCCqRsG1CPLSlgw6KNI1sO9KlRTRMXaJSMF8PQinP?=
 =?us-ascii?Q?GuXKphve6AoqgvGWxlIWGWLtXkb8dNrEZXy8lAAhkMGe+gDROQEtVU8Ury02?=
 =?us-ascii?Q?Zw3TRRTw4xCo4kX5wUW8jaQ4bE3sDoLKLVg9lFOvjfK7CH9DSgPzkW/zo8ec?=
 =?us-ascii?Q?0aVH2S+70ZbCKISI096gvh1dC61XpgR4ZzGVUWs8LIW5pwv6r+5iZ4uSkVmt?=
 =?us-ascii?Q?nuYKtcT6+3wraV8zWprsT07IcXM9d6/6WnF07ISnXJjc0RB+cDDUPvKjwKTi?=
 =?us-ascii?Q?njPvOiXhgsBefZ387B0t4yDtYqf5GMqHS8t9cJL3GlmTawXOpKnrPM27nQGf?=
 =?us-ascii?Q?1zXQAmxuyCIgB8MWFmpWkqgUFhBPpMUZ00gYhm4xiWizfmmA8Si8T38EWiGl?=
 =?us-ascii?Q?NxvHk+ZZTPtfOwFk5bD6jPXJMItkcl0pbRUE9vIW93MJsZdQo2r8FnfreUqm?=
 =?us-ascii?Q?Kn4lzBIeGUiblpipqVDx0Hq4FBpBvyzpWizip/R5RSFV3PdEpqIxwNKwU5jF?=
 =?us-ascii?Q?6j1gZWZhfxl63ahjBcuVoKIunZXtiC+TMrff57wDJIdtHmJp911vmxatL4g5?=
 =?us-ascii?Q?J4s9WbJyQnQP5bJ/g3OyhBikDDe/fDDKO/Px1gVG/fEDmqJOSFUZ74stBWMH?=
 =?us-ascii?Q?NA17Ltd3tWC2zoTn3fcrTNwAbnspSum5ZOCrlAIKEclsG4jrzGeiY6NpJFJ2?=
 =?us-ascii?Q?Zs17xF4+yxG7+g6m3nBdLVvgCK9eHrXBAc8ab1uSkdDBNWRubAO+8SDS6p0l?=
 =?us-ascii?Q?2QBV3xOSGV0hqPtHODjYaY1iVV/hUmxI+nxTq4feRKberhziD7Xz6sEw0TFI?=
 =?us-ascii?Q?44W2XEaLv2p4majcazAgkvU5bC3WCKKMj4D37jjsqUTihsaMIqx1TLBMb+DN?=
 =?us-ascii?Q?AfJ3JUXcShSKAq7U0re+W2TkR8wbz98dIcF+80Huqm2uhIVryxTnevLXERDM?=
 =?us-ascii?Q?RnrgGBLac+UlDGY8EnV8Rkr6MiZLYM3t9AwKnLjZxX+AH2TZvpBXyxut6fvM?=
 =?us-ascii?Q?jhhXnXphlmE59+av9gagpwF2QXvqINLiXJBQpk4ppRCywky50mKQJz0Nxn4k?=
 =?us-ascii?Q?PE0xvBO7yTltDvrBu8xCifa9p3T2lGsIRcubghwgJ3dozs3XU30KCw6vo9Ik?=
 =?us-ascii?Q?aIgVd9H/vIIYhdGimM048g0Mfx+08ZCd5RiSuBMKgMtsQxe21+6WS5zEvvPL?=
 =?us-ascii?Q?qaZ5XoWKFUiTwOv+Mqq1z2128XpbhaxgGXW5ePqLkM5fTeUSqFiBS6qBBvVj?=
 =?us-ascii?Q?lzya5JsyoQ2jmgLL3QXmJWEo3RsbBiYaXKda5aycEG09vjuAQYoiCLqC208y?=
 =?us-ascii?Q?oTfWGczT7qPPWpRD+i9Lh+uCmiZNQBB0lnrjIQB9d/Iy99ocou+dNjtZi5oG?=
 =?us-ascii?Q?25QCK+kzPPv3pwHYGa8C1wePSlZFyiTU3dpPqsFxAqGhKfWIMLstooMFXW9/?=
 =?us-ascii?Q?/tuBPWIFfRbXAxntvQG8UcGE82yHo8MIeW90Kl3Vr/691ZA69JTZ2kYAp3ef?=
 =?us-ascii?Q?l06A+YSZtAc5+NINgiMJw8vKpRykx+aKm8TsGtib?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83dcea8f-ec80-4f6e-3f40-08daa2e41a21
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 13:03:00.0351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zP2ChmF4YIFsUchc7dR44lOrWgqY5i8NXTkTLMG0oKazj5vBdb2/E0OuDpLMn0U90/E90yrjsJcaq1lIca2WfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3513
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 29, 2022 10:26 PM
> To: Gaurav Kohli <gauravkohli@linux.microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net] hv_netvsc: Fix race between VF offering and VF
> association message from host
>=20
> On Wed, 28 Sep 2022 06:48:33 -0700 Gaurav Kohli wrote:
> > During vm boot, there might be possibility that vf registration
> > call comes before the vf association from host to vm.
> >
> > And this might break netvsc vf path, To prevent the same block
> > vf registration until vf bind message comes from host.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
> > Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
>=20
> Is it possible to add a timeout or such? Waiting for an external
> event while holding rtnl lock seems a little scary.

We used to have time-out in many places of this driver. But there is
no protocol guarantees of the host response time, so the time out value
cannot be set. These time-outs were removed several years ago.


> The other question is - what protects the completion and ->vf_alloc
> from races? Is there some locking? ->vf_alloc only goes from 0 to 1
> and never back?

When Vf is removed, the vf_assoc msg will set it to 0 here:
        net_device_ctx->vf_alloc =3D nvmsg->msg.v4_msg.vf_assoc.allocated;
        net_device_ctx->vf_serial =3D nvmsg->msg.v4_msg.vf_assoc.serial;

Also, I think this condition can be changed from:
+	if (vf_is_up && !net_device_ctx->vf_alloc) {
to:=20
+	if (vf_is_up) {
So when VF comes up, it always wait for the completion without depending
on the vf_alloc.

Thanks,
- Haiyang

