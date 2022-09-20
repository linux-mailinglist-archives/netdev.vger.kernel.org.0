Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844EF5BEFA9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiITWFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiITWFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:05:44 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021015.outbound.protection.outlook.com [52.101.57.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679B178215;
        Tue, 20 Sep 2022 15:05:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jx7i/a8eat7PQxnRqe/3w447iI5DvCnhDiZafc3ywbtQn3oycDAW9nzJ7zvOJv88aad++y6+wOq0r+fQzhb8UCxr6a0vXqMebK0WOrMa2twjHBmymxMVEnRGyAskxQQc2nUq5Kl78KAwl01XECaeE51s2+L+CyKiQUG6AACyPSnSs1yIFvfq38n3LnRMIInMh/iysYOlLBbuMBvYUbxd72ee1saPk55ckFO1gAyc8ehN+emz5aU2UlVyOKrJNGYvuTqpNM0xJEjf1aGyPg8qls/EPBFIFfxejhR6RW9r5zsLUAiwJiS/hVYXE/h59D9UGwMgKWQL3JaQXY+R2lVzAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FGywfN+LhuoGED4ZvBKwNb1Rt6DNiMyBgWo9oTuV0A=;
 b=dQPo7RyzCCHZU10Bn3drDoWOvmdMSdVeHvZ3CmKNUoJ3XJPh/8UN6PT067XXgyx41oW025qI4xDo11tzZYE0vK40Dv++QIdjXl2sYg2OmUXBDGIwA3T3FrO6NXDO7GIQ+Ef5/TZWhxbNsJ8P9nkV1XSuD5lLQeId5nXq+5KzP7vxIuui8sTyYj8a8A4r10DqDpg6Dp+pL4DNjBFAUFHAeL+OxvetywHNpp3IovrAP1zZfDUDAPnN9jBF2Pia4aKC0hpw6wGWWMfiErGxj/y47uhv2yf9C/0IUVhSalU8UvEafkKF0UECMv2SYc/U8RV/ukO7bNKwS3sjsC1SOQ7qow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FGywfN+LhuoGED4ZvBKwNb1Rt6DNiMyBgWo9oTuV0A=;
 b=HGa6qOJJUDWfzt25zfI0qCskWUk7pU9XFdjIbfmrzZ33+PLtr3WvJjJ9Cr7D6jjNRtoxS850QH/YHL0judOnJccrDPcjQNHkIQWztpyP3VReKcv12h65jk+2ERNPhT8OX8WOz4ujFTnYMrlqRUrUwTvWNhLeWcKlxNmdZeNRWBI=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3043.namprd21.prod.outlook.com (2603:10b6:208:387::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.5; Tue, 20 Sep
 2022 22:05:31 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:05:31 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
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
Subject: RE: [Patch v5 04/12] net: mana: Add functions for allocating doorbell
 page from GDMA
Thread-Topic: [Patch v5 04/12] net: mana: Add functions for allocating
 doorbell page from GDMA
Thread-Index: AQHYvNF4/nLs1f/GOUmCofvt2lui1q3pAHxw
Date:   Tue, 20 Sep 2022 22:05:30 +0000
Message-ID: <PH7PR21MB31161D9D7A824D9E6B4F2E92CA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-5-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-5-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=53f1ddcf-861f-4d65-bc2c-4de38454ca86;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:05:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3043:EE_
x-ms-office365-filtering-correlation-id: 12052a03-36f8-43d8-0369-08da9b543bce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YsoUCrgn0S2qDXJyYnkkgeEmm5BrztL+CTki84e7vWMZH3A+L08jY/XdICEAwPnk+aO4EvoJnRqt/GTdj3w3ge8z8GYVGDl9ZgYDscm3wkViV+U5odSq3FqcROKUwc75XFefEcfiJYl17NROyclay9vfaMuKsWtUnPIofzfHhyP5ne3xWRSQ5BMaWmp8yPwjE7ACcvZvD+CyOfTlpNIVSpdO+5VahY/82ppAI9bxTu/JZX2inGG5UOYT4wtZzREA5Uiu48CuLlNDjzGltNKAD1UMnnU87owGZH0Q8Kdt2Qe6QsMM14hu+Hx9QulcHTJ1Yh9tqsKIDq/07PfzkibwDvnb1nPuZeKOwbs1iiMvpUwa0Bi4XmIKDYJA0w54W4/hfT26d3DJjyXlO4i7GBS3FCURgUyCMAnEna26z3MzALVbqjIFWlI1ur+WFV+34rypxI+RV1lfDOu2HxKsFoAX+RHL7hybZl5G4PONH4Kb1zY2NqJOKxrzUwoMOkUUWiV7gVtJuT1ycc3bHsjxcP3ZKUvyvdQ3ebBdNaZrhnxBzv1geOoKByhaNuqHBHNwTd/xdvFcvUrs2a7lmZD3NejafmgJgrD6CiPihqqyE71tvBv1MNNsAiI6GG2/CfYyO81MQalgMUoBUTtlguz1f1m1OAY4rLOOwEURHb60e2l+nWIpztO+phfGly7u+jJJDJngVMw+OZbSQKZWaX6kBcHp/WqKtV3mxsaxGsJxpfM/sNjLPrVnbXowNphM6LWODpaRzwMp2ezu+qd2yKljiuu4/KccMQuWxG0Q3vVFei4AZoPBGVF8cnbH2ibxy1cFtvavxvTo1S/9uqZqrSQj0Axn8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(26005)(9686003)(55016003)(71200400001)(41300700001)(6506007)(10290500003)(7696005)(110136005)(5660300002)(8936002)(186003)(54906003)(6636002)(8676002)(4326008)(7416002)(76116006)(33656002)(86362001)(66946007)(2906002)(38070700005)(66556008)(66476007)(66446008)(64756008)(52536014)(316002)(8990500004)(83380400001)(4744005)(478600001)(122000001)(38100700002)(82950400001)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cq4xhiW3rYcGY9tsNjcToRZJYlXgZJbLoEUT3coLZ9B/BVLxzOwe5BHZ+M1w?=
 =?us-ascii?Q?702cKAzMvbI6fTU3FD5rirtp6tKMHiB6AhZ2SG9frtiHg1hxlD5zkdrVfp6B?=
 =?us-ascii?Q?yTpe4VLn8HRnJRKY0HLDf+I+4EFJVkWx5mTMDcJ7qeF67+AX40zMdAFW0E2G?=
 =?us-ascii?Q?Pmrhb4dZJWiVyiDKTnr06ZLcpBGbJE0y3gUGSzBBUR5yJ/rDNkE2yhc693eI?=
 =?us-ascii?Q?87AAo4/6j/n3wmatsCBRzxFxg571vPHNaiTU5YRsdxIQsUCWAcHhDd8yxNxp?=
 =?us-ascii?Q?A1/kdCG30/tWMrj2xXlZJHtA67wnpQaRvSB74NxUVdtrimg3KYZzFfOhUC9l?=
 =?us-ascii?Q?qlNIBkMre8s/QgXQVq1n74T8R+1GPkeo4rBSKUk+/Ol75qmSRX4WYwawZLJT?=
 =?us-ascii?Q?ubwZEoe0pFHpuEEXxp36siAZIIxF5tXfR/iCA9IkF1pdTOJS1VHj9w+oqheo?=
 =?us-ascii?Q?Hx1P2TfdFPcYXlkgxlueVOUlTgCKpU1gZ4jvkU+05L2WQppRpIChHJJofBuB?=
 =?us-ascii?Q?npulNLB7H7/ZAPOpzJE6wsArkUcZ9JpaZHyz8IsdJynwJzQeSrW63P1xxnOj?=
 =?us-ascii?Q?YmH42BFe1XGTQNQ0nu5URoKlMzQl8WhzXalopb3IQxCCR7LTR3dR7Uf2hsvb?=
 =?us-ascii?Q?q14dCGa5HcdoIU+P/HorEoV+h+ELboyPYtvgdg/o1tJoFsFLRSGm44xbJ/lw?=
 =?us-ascii?Q?Iw2Jt1n5M4p19kvCOl9LbZxqR61RcGPT6NSSGRSfmHPZJf5/jNe7OgLh/DPy?=
 =?us-ascii?Q?N3ly0EJYwb80zQEuXxs4VZGr3jl0EBK9/9sXQIdNi1s1nm21dSzt1njJLbwO?=
 =?us-ascii?Q?Eo9uaNLMwKd64mKKBRSIvP80s/9/ZYDVosItyRN9m7WOI8kyYL4kUmk0VXBx?=
 =?us-ascii?Q?+O68+35xAcd7uwSojhJah5F2sq7hVqUaWt002OVHKLVqii/8ySQLBJaSBnSd?=
 =?us-ascii?Q?n7aI4ofx15P7zvL7wBaz/6wIkH9ndFEoYEj+Yv7DJ2LWmztopfiOIFSlDaxX?=
 =?us-ascii?Q?FXxL7JAi3o5MbvTNSDOfFllfi+JBqyvcukU0+KXSDsmcTtwtQweZR6qY+t3L?=
 =?us-ascii?Q?dwNXu/TKuHCc6EM3i6F4Q097HGTfmz8CWwFcMnCLgXUUQjw0dEr+uFBXcOBP?=
 =?us-ascii?Q?xTcq8Wspiv+D9LgWS8qrBaGftBif535t+awXfJH+eDPPTMjfFE++PLH/bInG?=
 =?us-ascii?Q?tQPyddesO+3snQtLEnYl5UQ9ogZUoIRGD5FT/cd5Ak9V6ajK/688t85tQusr?=
 =?us-ascii?Q?X8DtjVZ+V+TlEc9YxsbOsTejplNK96rrgGsExx5do5FYEGQoSPWhkFku0AIW?=
 =?us-ascii?Q?rmPOoVEjRXwDr3tZ/pymHCAjvSfRJSp7nPiRiF17RGzUnP0hnCzwZ0sa0w0M?=
 =?us-ascii?Q?aqYKuIywWitJEZ3kilSQxQoxrMmdFaFYhHfqaGxR7VcMx1BRqZXHz0TrPGfH?=
 =?us-ascii?Q?Yj9om9FKV4UU6H6a9/RLJxcSdy+1Bb7oSk1GD4z35FGYQvKHIQruHRrY5ICq?=
 =?us-ascii?Q?LqVPfir292mkOauHyjF1TrJuteL+7O2bMpAk8DCYFYpw2E4a44hGS+VVX/lG?=
 =?us-ascii?Q?7XjJcka4taZkpPlJ5SAFNJhZabtjY0yb0T4mnEVz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12052a03-36f8-43d8-0369-08da9b543bce
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:05:30.8636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xWNgEXvkkOtT/npVYhLswVtiRChi4jbiLryHhletVmdGpGsRTmO7+Kmb5ndfs/F2b3K0Dy1uh2GH+WhI4ZsRnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 04/12] net: mana: Add functions for allocating doorbel=
l
> page from GDMA
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The RDMA device needs to allocate doorbell pages for each user context.
> Implement those functions and expose them for use by the RDMA driver.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
