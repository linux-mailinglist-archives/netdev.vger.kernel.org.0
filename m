Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CE16E31B9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDOOLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOOLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:11:32 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9874544AD;
        Sat, 15 Apr 2023 07:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7wRor1RuACXZF5jsTaHFPsRWdP5aWAoqASKMyHrUa3u85GBz6NdyJxcturt6eSy0iqhC2kmmj1ocNYjZiBZbaXkcCKgNGndK31DiGPV0bRg1FGtATJgAyfnKtcE4iJGUCrFa9sK+om8T1G3tlMyBAkgZ2krCZi1p08cxMY3npxQ4hO5mn8f5VBYZaW2CVevsNvKjMNUK2FakOIP0VsITbrcLsT/Qe1VK36E9Nzhf7xjTdvEVrXBuldHq/Ijj/YphOJZRRPK2DmlvVYTOiTWGLfX18ReGap6hME8cgQN7ckPGdv3g3gFR417uWWOem+8WJm6NNn6rUvGzWpoFeE82Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycozS6glKdi2Qy/kZ7ulDcqABQpiG4QBiG2sUEvB6rQ=;
 b=TByz60iNoJI6BJLO87cyaftXJ3zLzKhh9vFCbYsECf1aGY1XirL8swMdq767B7AL/+Sj2axGIfj7N76Rl/zKXoKpBWbDkyhGoNzLJyygSocIJXc8eQ1VwBk5m5wTEPPPPYq5Yh8+0J20rE1B/apFWgPCvAV9izihnuu8QOx40siHbL24yok1v7oaOs/iQyYl6GQIU238vR7S7hxG/lGlNIW5+2qyVOXnSxNWOIp7kU7Za9U9dxmt4bL3VaI6aqW5hphNsg98FTw35kPchkufAJZfdUHJdARWKAOk2UQl4xVZWpPzIVALWssfoJt9wITfaVew9AnkGMWVdpVomMQpGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycozS6glKdi2Qy/kZ7ulDcqABQpiG4QBiG2sUEvB6rQ=;
 b=bgDWR9unExOELWnbw5LBk21JzW70kNz+bQyPJzDZZddothjheiFWzN7BdMKI3hdVNuuVpkeScSuGaF0+1ZNRxGxjOo1DrECAHQnBd2KIVrff6t6FKdH/UwrGgwaGd8d99XjpocGMAbhlv6HwiOQZhEMctOSfaEFixrygkq1hz9g=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by CH2PR21MB1448.namprd21.prod.outlook.com (2603:10b6:610:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.10; Sat, 15 Apr
 2023 14:11:16 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65%6]) with mapi id 15.20.6340.001; Sat, 15 Apr 2023
 14:11:16 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 0/4] net: mana: Add support for jumbo frame
Thread-Topic: [PATCH V3,net-next, 0/4] net: mana: Add support for jumbo frame
Thread-Index: AQHZbYQYinBBXAxm/EusbeEL165lgq8ro0qAgADJ0aA=
Date:   Sat, 15 Apr 2023 14:11:16 +0000
Message-ID: <PH7PR21MB311620D2F01B2153C258F1DCCA9E9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
 <20230414190825.6ce2d980@kernel.org>
In-Reply-To: <20230414190825.6ce2d980@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82daf76e-356a-400f-84f3-1f60f8691f02;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-15T14:10:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|CH2PR21MB1448:EE_
x-ms-office365-filtering-correlation-id: 6e0dd931-689a-4ef7-05c9-08db3dbb46fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YD6h8DfV4PCSUjTVJEoZ9jO18fPYchIQ5rsTSVar9umS6KkusRquHU/QDi/hNeG6rHn4PRI0DEIqT7ueS+lxc6w4hYO1+Jl0jWl823fsu3OrG6tmYQ1ZBXSAUu/4PpjxHjkWISx45uHhMIGGqygWM0mbUmOacEL4nIyjYrlJokXYsigbyL8rayWvBqIbHknkM02vmXkvSgZHFaE2njPj2bbNS2RQpEa008GpP29TyBbWDxCMnwaQ2qaH/RNjTf4EnIcjv4J4s2LYdQSArlH97yBM1UA5TfN4vwed/1wXMPrOBvLbSXAIgq7mmkED20M9Q2oBohLP+TEAUD4Lm83x7EeVlEc7ZP20RWBPOpxnIahejgSNm4EMzoLRDnc8QVPzsxKAuRyGJhWeHzEJ6QU5gKxhuY9gSqyClirVEYPKxFoWQOEjHQ4WjJ9gx52PiGLeb+GV/bD5AdL/ZmTkLORmgkXBG2KhTvfk7LLr0WUfKqaRrUdRcnMl5oigepvpGuSBnUaTMSnsMQA8H7wWkSK3CjyEhXhQNtFahAVsHb3TZODPYs0lcMrCkfJwYtqx8GaUycR8SBILQtwFyCPuZ+McvEeWH2U/gdUdYlzOYfwxkoOpp4bFDM3KfHHD9CyR5xfOVUecx2DiyLcdlQLjFP06pOXitx/cmgqRnZaikukMxhg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(33656002)(66476007)(478600001)(6916009)(10290500003)(4326008)(82960400001)(82950400001)(66446008)(66556008)(52536014)(64756008)(41300700001)(8936002)(66946007)(86362001)(38070700005)(122000001)(5660300002)(76116006)(83380400001)(54906003)(7416002)(55016003)(7696005)(71200400001)(186003)(8990500004)(38100700002)(786003)(316002)(4744005)(2906002)(26005)(9686003)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g95XVQ+wI3tQX5u2ndFB5AQh0JvVQahX7O04l7iTqcIaqyXIhPuYD5wtF2T4?=
 =?us-ascii?Q?C+r7L4nprzRWoD+hnv+pBbHunSBK7U1jPexir1mOzSu+Jspj0nw1KONUhdqp?=
 =?us-ascii?Q?nao9fccrHOOvswhPTd3Y56aKXxffnJyaVrozD/J2cPbSMzkjLFt1qB0G8K23?=
 =?us-ascii?Q?qH69UoR4S+f9/bS1upUzerrQIAetS33YMSTwznnqZrEhgwy3LmG2sP3kectF?=
 =?us-ascii?Q?0tL2qzcCtB4euL9isE8oUJ3YQ7hjhU/8dYNiWp5wh9XHo9vSWwIM4N2yJuOV?=
 =?us-ascii?Q?smwriPk/OaTx6tdq8tn3JvG0Oa5EZldj0EaIJsV7yRPlc4x06BHnImqYll3m?=
 =?us-ascii?Q?NOdemlZ7lccrRVU0BRdYb19EOkc4dYI7nizABxzgJQ0TaAVl/L3WoY6dmvWx?=
 =?us-ascii?Q?Ge9f6u+pCKYRt/jjsnPP1prGgx1U0+mMNEaC10hKDR9hBLqf1Z4/HDwJIMHE?=
 =?us-ascii?Q?aVDSgjRjJ2i4JfnhVSj8s4iX/f2ZgoawvU7IoblxDysng0egG1VIt0sSoboX?=
 =?us-ascii?Q?JyvFp3KFnFMWb2OXRVqxwjkOKywnG1Cf/v1+Qz72ZdfzfNsziq9COYoxhlVB?=
 =?us-ascii?Q?2F8SUYcdf4KyZAPWcR4FE3sJPsR6d2bHFh6CePsAw5fcznCU/O/QpmOfQ5dG?=
 =?us-ascii?Q?3Klb2RBHBuKmn0dzacuce/kV6pYYB0D9mKGnMAfi6SeN7gcz4K559Nm8p+PS?=
 =?us-ascii?Q?sJIEl+yLfGf3or7vFDNC8iGZtqXZZqQuntls7ZjB86x8S/sxgFTQymF6eJTc?=
 =?us-ascii?Q?HUD/LablbezXTUzX70esuuEyZwvffpQMw3YVCjGm8DqYBpAbTLGtRTKqi542?=
 =?us-ascii?Q?kek0AadKrn6iDTC+yLe1KTDyvyQxUl+elChfEy0LYwg2PGKQT8m1vUjPcJ7j?=
 =?us-ascii?Q?hhKYuI8Vj/njE6vSxkLLnYvC+4wE8VlwCg+7sQzz3H9z/UIIdXLnxG6agGfV?=
 =?us-ascii?Q?c6qCDPBIVkPnT4N8OY9qHeyvvvf99+VpghciTjVDkK0m6JJVQJ55I2FrvBdF?=
 =?us-ascii?Q?cEcPSjps35Dyi7nJ5BHJ2a43O7FMIf4W6FcnsgkpU2uPiqVvdN7a3YFSfcJD?=
 =?us-ascii?Q?a+bmzH/tvfPcfWc9m2XMQa6NLkBMSk2EpuI+Pxe6okdqnjISbA/udR125bWg?=
 =?us-ascii?Q?/7o4jKwgwR3YIG4jimF8W+6UEPt07uKWFSSSo9zIFz0WoxcDsbD/JDuZky+k?=
 =?us-ascii?Q?Q6mYB5pCFhDyepI5d7t8GM4dbx5cg2xyUFSxtDdqUcaq/uXozron7zSiYfGD?=
 =?us-ascii?Q?t25LUGv5cqUssIEZtOUC6UwAFfp7WZT0evA3oJkNFVKaGYgvfFb7NhkBMs+Q?=
 =?us-ascii?Q?1cd8Hlqcp+fE7v1xhsMcXPw23Xpk57Tt0O3CqZWzHLGcOqP66G4iEvSrxDgd?=
 =?us-ascii?Q?DPDWXOCWjGquCaMnt5qSlNyWdF6yl8OYG6s/evpvUGngpcbSIJFNq3GP7Zhg?=
 =?us-ascii?Q?eDtoTqxQc9LOOJ/L1rCeVDmghU2DISD6QVU7lXpZN75uJHFf2WbVNZXWv51F?=
 =?us-ascii?Q?tpwlWa3xll0ADlZzqcwXWMQ79iLLQWR0jl4hR3Ifp5Xb/k/p0VJOrPW0hjPv?=
 =?us-ascii?Q?L3Q67ktU0nab6apBJbtUr78WQTT78Os2Qhczq8fx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e0dd931-689a-4ef7-05c9-08db3dbb46fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2023 14:11:16.1856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4o6jRq6Bknzg+UnHLLYfdq1yw5dak+h3LUhV0O2MJTDW9DFYpdKqH46biESmmlL8wS789QO7arZOy6Df/dk47w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1448
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, April 14, 2023 10:08 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> pabeni@redhat.com; leon@kernel.org; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> hawk@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 0/4] net: mana: Add support for jumbo
> frame
>=20
> On Wed, 12 Apr 2023 14:15:59 -0700 Haiyang Zhang wrote:
> > The set adds support for jumbo frame,
> > with some optimization for the RX path.
>=20
> Looks like this patch set got silently applied and is already
> in net-next :( Please address my feedback with follow up patches.

Will do. Thanks.
