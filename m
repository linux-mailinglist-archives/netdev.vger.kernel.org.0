Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272ED6C605C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 08:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCWHDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 03:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjCWHCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 03:02:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6CE23123;
        Thu, 23 Mar 2023 00:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXKvn20pVmTDaINAholNRjgGy3k2PdE88xASCTGdLS4o+kdcTDuab0EluhEbOdamRfLbcEQZnbsxS1TW/4Naj+1hH2RNzUBtrwqW0mMy3FJa0MYh4p7IRNfEZHfRoUQjrliq6NnXLY1DEiio9ywzKlqAb+2RdSyX10UPVdmIUcAEIb1IFvj8BMEpnQS4SmXahHmFiFISK64UBJ8Q4WK8RsWxDuC4lMlGCgIYa/KEwcF2N66Ct6MBx7havG8IdviiCW81c5si8URMPYvNCUcRpSWueVEtsKdugV1oJNIZiMm+Cd+as2I8mHZCwi4q5ODbl/GWFHUYuXA4yO7qCvQyKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9XTPVPNEcYcyJlZJIr3Awz8wbJLM4iEX3F5YEbzST4=;
 b=BTmh4n3uH2A/eCCMoy6P9dp0s+/2z+BBgFgRyakj/HDh9/i9S5ixg4srJ/FCLw3podClDtezEidkeepFoPzB5ccSs+3Nw0leCZDMULVhojS85tOi0ELoo7dmS4uoiz1CNt3rsVfG+r4xt0QVQMtWqJq+BOeg75WC1j7OkVpZfSyF//lE5ErOBcRhNo049JUavTmSDkZyZSpxmx1MYPRIOpJf6cmoMFk+nlyouhDy/oeKZWtrecexCUeOz9ZWkGLBk63qQBLAOvOQHm5s/9OcR3x2/q26tizgBa7A6yXAdQWmNjntsi765EbmZmhocJuvLhjARV8jNE5nz+rAg2R2eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9XTPVPNEcYcyJlZJIr3Awz8wbJLM4iEX3F5YEbzST4=;
 b=WAPyaTO2EjI+0eptmDxZTh5Ou2naDCQEdAz6YXN9k7VsjsC7LQYlasw3dwROHTbAnasxW1gqwn5+AUiYqA2cniyc9US5iOzIfA24dK9fRvmPZmrusM3zOwH7pCV3eA/nWRyyyTq5Bw3ukxdP3kSxOBbi8iQ1s+zKMFy4iWF40t8=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by SA1PR12MB6970.namprd12.prod.outlook.com (2603:10b6:806:24d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 07:01:37 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::8709:da90:3d87:cdb2]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::8709:da90:3d87:cdb2%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 07:01:37 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "andrei.pistirica@microchip.com" <andrei.pistirica@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Simek, Michal" <michal.simek@amd.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>
Subject: RE: [PATCH net-next v2 1/2] net: macb: Enable PTP unicast
Thread-Topic: [PATCH net-next v2 1/2] net: macb: Enable PTP unicast
Thread-Index: AQHZW/JLtp5le6APU0K50iEquT1KP68H13eAgAAWqtA=
Date:   Thu, 23 Mar 2023 07:01:37 +0000
Message-ID: <BYAPR12MB4773239308DD06E4B80E14BC9E879@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230321124005.7014-1-harini.katakam@amd.com>
        <20230321124005.7014-2-harini.katakam@amd.com>
 <20230322222403.39191060@kernel.org>
In-Reply-To: <20230322222403.39191060@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|SA1PR12MB6970:EE_
x-ms-office365-filtering-correlation-id: 89a27b34-5ad5-4693-0487-08db2b6c7213
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NfPXjJmLGTRbAMw0AwkbpKwYtATNkQpdTYFYgljWAueEy79SBsPw4InH0UCkNRJKjoeAGZ9bwuq6be0dfIGQeJqhI3QmaoFmqGOn4KrMOU2wj2OuYzPBrZyYsL4X2LZYWfjnSKvd41+cRSh3qim3HN0L5gaSyGM8WQCkrH59hYw1xFAJ/ov47GLB+0+7Wfo0Y4rVDn9MYraEoBup/c9PE5PgaMMi5FhB9/D+tNN/8FPGvKMQy83dPGiuqueHi4hhZDmJzfu21GjJ8gHfUyhukAO/UNuVINZ8leMAqV7lsBLmoG/a4/iGkXe+396sZr/PlfYOoadWpCf0imu4Jo88hgcmLtDaqPAia02FWGhKr7cSlPN6DnV7irrn05Qnfzsm32y/F/a8RiyWOcYb8S0jKGVsP6qFLRTQhBc6TnaHDHHKlLHVDNFh0h5s/BrsRLOBgKLHVIEvfv08xfXCBVn7kEqTWI1kyAhAr70QVEnG+egFpAI4BeuvdVESc8d1bo75IsREDrD2VSHWFbgmzBWTw3lnF+/GRPdPTJc3ZN8fEwip1DNEMTcKp+35aSoMt2riupE2sqKKmkiF1k3hMOVoWbfdbAffeKfDqRToOg5poLkKpa/LpDNIurJz9tPCu/uD8DW3XMUi59GrLjvKePoTgZozmKb40b8shNH26+utZaz42P6rzxhx3FY8SoLJ720xZi9sYK1PWoGNz7dBlABSsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199018)(316002)(66946007)(6916009)(7696005)(76116006)(478600001)(66446008)(122000001)(64756008)(2906002)(4326008)(52536014)(8676002)(86362001)(83380400001)(66476007)(66556008)(33656002)(7416002)(186003)(71200400001)(38100700002)(41300700001)(54906003)(38070700005)(5660300002)(6506007)(26005)(8936002)(53546011)(9686003)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bqqBN4lXhhhrk6jQDt/7GLMCbAG77CozjwrU5Mwv2CYk25kBBvgkefrsW329?=
 =?us-ascii?Q?7RlVTItVWHacQ4fo8FsuuwRFyUPLAUY7fBynJsRcwTw5nYLOUlCNJcxqEpRd?=
 =?us-ascii?Q?bOY13YQ2yjxYClWTIrp87jnGhO96DWAyq4kdZsHK4m2+xR1xztUO9uif5wID?=
 =?us-ascii?Q?o9/KaoMv+ZvLQKVkvZsEIyh4QaZ1TdV25uwAXzrm5ViFRnwPTuAhPXlVzA8u?=
 =?us-ascii?Q?F0hmgDu3sr6nggWyTcbh/yjpydic3J8M6+Pr9rSQV1hkOqaZltxyiMks98pj?=
 =?us-ascii?Q?7+j/z0+d3VTjr2txf2djLOmrfsHStEr050an8zz0rDNEoNqpnrBAJZu8+9zC?=
 =?us-ascii?Q?JdyuwdpYceFJIUFu2ZexTz3zrB+sYOfHQTVBF3EmTpe0fLBnZs/1R6CtcL6c?=
 =?us-ascii?Q?vHqO2hocFQpMSH9IWHU0vD5Gdo7FTttaVAGFtrmQird5x4KMloox9Lm4370v?=
 =?us-ascii?Q?XucF8KSm7ozzmy4C3pCvF9vXkoGG+qIBsw7daQ/O+g7s3Alf+8SUV6v5C/qY?=
 =?us-ascii?Q?+hluaoRRAiP86ydcvaiphZWzbucmmTPNVIlRyDqEXed20FQ7ojcJ1SPrjR8H?=
 =?us-ascii?Q?gx5rpnFolk96qbsqVwoCrXvJsux6SWiDjwDjSRrtsnpZ/0O6dfwFeoBzN6vs?=
 =?us-ascii?Q?uvjT7GfgH3BzXq0NUbmYQuii334DavDuVfUxT96W31zUOJ1QHeOF9V4vIdd+?=
 =?us-ascii?Q?aWxH2xnpHuVdXIB+yVL7+gEH1Q7F+wKr5IMWLlDWNUAUzmqBjz4vGS/AjHMO?=
 =?us-ascii?Q?hkgsS0jYa2ecUYIBD3vK1QDDFMDSdXqh0qkOKqxNV5E1RdPDl4POVrsPI2lG?=
 =?us-ascii?Q?1cl9oqQVXGCq/L4BYmGgXDXvDRUUyu22RtBdj/NZCs1Mg2IBRL+ajPG2gNbu?=
 =?us-ascii?Q?RnE5MokrD4bh0wrot/bkt0VViof3SR5vrPu+uNixmLlLI/B7UTj+4X8bcZNY?=
 =?us-ascii?Q?qDbhd88e2Aum9CaopG6PFFppUTwXVwnkyPupHMc5mb0rBcvQgtmKlSNsWQv5?=
 =?us-ascii?Q?FXyR2qMvlx0mHVJPSTAUBV7FArRJ39TYVNRZj+9AljoYNWFahRfkVdQmp4H/?=
 =?us-ascii?Q?ed2kzmyL3G1i1g0lhV8rQQyJDke8/ImuaOdUm5rp4evBsJ9zb4g+vRbBFZ0G?=
 =?us-ascii?Q?9dR4KE84uRtRtrMo8b8zILLOrccqiTHGiMVd001GcafhjsyWCxED3rtH5z31?=
 =?us-ascii?Q?9ko87UMfZOHsfYlsrF8DOy3l3uEyVJ1rf0z2gkXpCaafWSwCyy3UukboZhEU?=
 =?us-ascii?Q?MIUggyrwQjxYDjb15RetsalAROfXv4nmBO2255mKwt/udO0GovwjbDsLhhXe?=
 =?us-ascii?Q?lIo7S1epuwCiiPQRx9uTDvKJtrEEnaKUqxdTDM5kVPC22T23Cwfq/+qtnRl0?=
 =?us-ascii?Q?Gye9nt+QWqGCmJ54oAabirWOmcIrHsO/IgotUfvaybPYLvreIQAp4oL2snLc?=
 =?us-ascii?Q?hJ00rGCZ7CwBP9xEhUc5ZJmmsUIElNoAuZaY8lPVekmR3vzcXcQGmcQcgorf?=
 =?us-ascii?Q?NHuRv/2gfEXi1SEdEnyfMNrCuD/a8Zeo+8MD4YmMcriYGK12Q1jLtYpOlK8J?=
 =?us-ascii?Q?rHB6R+E8T74Hg04hkhQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a27b34-5ad5-4693-0487-08db2b6c7213
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 07:01:37.3212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yxAD6+LUlL2zRO+zuDkaRy7tMJZBWr8B/WQ6kbXktwteJbSlo28agx1dQI46/b5u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6970
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, March 23, 2023 10:54 AM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: nicolas.ferre@microchip.com; davem@davemloft.net;
> richardcochran@gmail.com; claudiu.beznea@microchip.com;
> andrei.pistirica@microchip.com; edumazet@google.com;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Simek, Michal <michal.simek@amd.com>; harinikatakamlinux@gmail.com
> Subject: Re: [PATCH net-next v2 1/2] net: macb: Enable PTP unicast
>=20
> On Tue, 21 Mar 2023 18:10:04 +0530 Harini Katakam wrote:
> > +#ifdef CONFIG_MACB_USE_HWSTAMP
> > +	if (gem_has_ptp(bp)) {
> > +		gem_writel(bp, RXPTPUNI, bottom);
> > +		gem_writel(bp, TXPTPUNI, bottom);
> > +	}
> > +#endif
>=20
> You can use the same IS_ENABLED() trick here as you used in the if ()
> below, to avoid the direct preprocessor use. In fact why not just
> add the IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) to the condition inside
> gem_has_ptp() ? It looks like all callers want that extra check.

Thanks for the suggestion.
I believe gem_has_ptp was originally defined for checking device
capability (Atmel/SiFive/AMD) and CONFIG_MACB_USE_HWSTAMP for the
kernel selection but I agree that there is currently no usecase for a=20
scenario where gem_has_ptp is TRUE and MACB_USE_HWSTAMP is false. If
hear are no objections, I'll include this check inside gem_has_ptp and send=
 v3.

Regards,
Harini

