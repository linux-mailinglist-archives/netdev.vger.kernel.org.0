Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2155BEF9B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiITWEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiITWEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:04:22 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16D177EA9;
        Tue, 20 Sep 2022 15:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjfHeFx/Vl0OOPdXFAZYgXNqZRrAuTSypGMCJjEmgC1ZjR8oFTwL6GwaeSsBeqybm1+sarYSGcUTIweKbqnSbHIvf0cVGN7ZfxMAtx9PAYFbznao0900dnk0K43+pSbOan0JItut1jqVowpWHWNdwTlTQawciK07AsSodYW1zt7pRL/54Mbadrcj/+CoQvcGtWGHZr0zckdyHAsrjKqNRGHnDUUwlghGUEd1LfmsF8bmSJnuaB1yiMGhEDhs7tvYu8aZ5BQl0w1uNJhMNKjB6CpRhHcM2xaukE5r92XKzZdaX4CEBn6bpekG8m/AJMWPAL9gYIbBl2vqUGWY/c32Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7oEZJRWS8Jd00Fk/zpGS1S2I4R372+LBk/yT2QwvUk=;
 b=nggdlKEdJsWs+yXd0gvK4oB8N5KFWWjcTidIAW9LtJjCi6UzZntjFw8pgK2kelBEuENkLuCs0Iqfvgu8Tb21bvupZJU4XMUtOEjtws0BsB/Cr8J7mqpPlI9baJNuOAEd2dqEQmbAOEAiBp81D7zLfuqEzkj8lp1QIOvbhwFwYKZbRQAtQ2Pdr19MfVI9AU0s+Dk8+7Th3HPuQ/DBKo+Dn3n9UaSJ3anPYxCmrCUcHuSBFWxVyjmy6eJCDCYczVjbaMbUKhy+l5QfBEc2ABG9w3JEoh+4pt7iHLr80hdjuZVg0xXUpxgHD5Cnww9Z7hncX/rc6a8BtzEYhyea49sRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7oEZJRWS8Jd00Fk/zpGS1S2I4R372+LBk/yT2QwvUk=;
 b=VI/WKot+AZRs2r2wp2EssWhhak1jNCAvDRXcbuRD86nCIQAqciMqoEgF7263qDJGTrlrZeeBipALnlP/xf6U7JoDDgmspO5P7zqBjarP/jJf0aNi6P3U9srOcF+1fNP+O4uQEuE1srhS8KoXya58QXKpql58vnseoe4TVxmV+IY=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3043.namprd21.prod.outlook.com (2603:10b6:208:387::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.5; Tue, 20 Sep
 2022 22:04:19 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:04:19 +0000
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
Subject: RE: [Patch v5 01/12] net: mana: Add support for auxiliary device
Thread-Topic: [Patch v5 01/12] net: mana: Add support for auxiliary device
Thread-Index: AQHYvNF47vRBKj1J60ezs/OZ9IjqVa3o/7TQ
Date:   Tue, 20 Sep 2022 22:04:19 +0000
Message-ID: <PH7PR21MB3116B4A49822A15D4814A4FACA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-2-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=56f64a17-3faf-4e7d-9387-8c73d9054de5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:02:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3043:EE_
x-ms-office365-filtering-correlation-id: 37e17a76-8d4d-42b2-ab3a-08da9b541116
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +dVcPaeK5J86NQPRvYME9r6USvjHuNa+rR7vVjXdMScBIK57MogY4uM8mTyhZOMK/b9KooCgugSQEv0caBaBLVC0uF3EDXkie2UOwfAVshSWhb/mJuDRgCEXMb6Gp4i76Sp9yjfxcHWoWrx7j2J21c9JehAAl6fiMXGWm11vVnIkf3RBIt/pbicy0k9G2t96Lxiavr+dIsdKa5au/RUIRjPKj2YBEBDDKnwIedGhsiAcOujoOzJuHNEcCJT9109OOtQHTyCnYJkvkuDYs29o8iIPiikwTCqv7lYwObK0m8ksDSTV4tCe/5cU5gEHwtbydcAltBFRhG9TGJoOpi2fwIPwKh3GfYsCkWp2sDHfF1uVwerrv9fokLJUoyFjbGPI5zDNxXFY/ApWq99AIXpteEzU2y1uzbuwMGTeImyAHims0GFXYzYpO1FgdWzUv2SrSqgP+Q2z2GUAXXMZZJLm8c0sho+gkN6XgE0j2eLToFXFceUxvKNGEw5sX7NYZCDIzVChKAHextWiXkqMo4IhOk/8dLbh1j7eTR/iFu88AzMPQibCkqJlPfX3p3UNZh29l4c0s+CrO4UjY7aBkwLDrB3w7jDxzNuD9L5TEexJirRBflMXfKQ7QexI9C1M4QbqXiIMEGU+bOWESCxlGAWkGdv9JoY8y0oBP7fGWvG0fwhABjcm3Pu84qSa/PQzJQFxS1PIisLJ/9VWLnGCc5cUt8G8hdX6P+bVUo+7/y5XAst7N7Qe2Ahj4Ta3V8vSATIwTOx1L5Qd6LX9th498X1zPkMvh6fze4LMMa+GYrWg6GV63ws+qHdfnfLgFJBs7YMat0DMWnitOaF08QcZwIk2Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(26005)(9686003)(55016003)(71200400001)(41300700001)(6506007)(10290500003)(7696005)(110136005)(5660300002)(8936002)(186003)(54906003)(6636002)(8676002)(4326008)(7416002)(76116006)(33656002)(86362001)(66946007)(2906002)(38070700005)(66556008)(66476007)(66446008)(64756008)(52536014)(316002)(8990500004)(83380400001)(4744005)(478600001)(122000001)(38100700002)(82950400001)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4mqNgfqCUMNxXK98Hwen6vQ7VgQACFUkRJWinM0Dj5Nt9g9PyMBoNp29hg8v?=
 =?us-ascii?Q?QOrhZ+etG/KTC5exi8jIJTJcP27g9XRD7qSFCq1mPbVcyqFbn1l+D3OdYHP/?=
 =?us-ascii?Q?WgAwD3mHITH1yWLV76RCkzcVV2AnAGXRL9kj0GLmLN87gaHX05OqLoKmaOPd?=
 =?us-ascii?Q?KxivFWmNdSVcS0oaTMqaJReRff5l4X+sfA2rODAPU9PZOfYTEAj4rOFsHM53?=
 =?us-ascii?Q?gc6S/K8gDCmvTGlroKHwL0BAJZS7xZEayYQRMp4Jz3H/kk5d28n8GhkuuK54?=
 =?us-ascii?Q?LOOybyf4zh79Cs61vgAr4J23AIodT7Eea/p7jgZ60dHqprgCmV/4D3YP4qOQ?=
 =?us-ascii?Q?kJ5uCG7JShWe6m8RNALACFHTbnX1bTThUeWnb+T4HMDOZyNSSDCsOCu48JV1?=
 =?us-ascii?Q?S6QXh3HrkTH0T5vZTuSfWZadzTZu6IoiHxloVYKgO6vr6ehnY4CPQGmLaHuD?=
 =?us-ascii?Q?uAWpdM67NYuHd/I5VpDbLyHiu3QDmeW9q2zA9AYxeD5Q9Rj4tLRGwQ+0gG3q?=
 =?us-ascii?Q?JRq4lXSGL/IbcIhldRn8SiXvWOFqGeVTXWpMP1t9AofhlxjIb8K6QnompaBH?=
 =?us-ascii?Q?vmQu0fEDWjyVryLGYm+Ft44WaOdM1o5yl+dbOqdwe+br5bU7ZGNwPdkJ0lMJ?=
 =?us-ascii?Q?0ws8oRqkD9qkNepyWBU4be2MWD2KVS0AWPAsiCIEZB51HA5qzPHiOTCS99P+?=
 =?us-ascii?Q?oL8V4KNLFGQN1loObAWNlKkUfIqaLGHdHqRImaNTCAaPCGbhX05pIY9do8fQ?=
 =?us-ascii?Q?WjWHMIkPgPrNN4am5D5JXM0yJ8pi+3P7I3uAHr87ddDeWUfpSGcJAXoL1TAc?=
 =?us-ascii?Q?IY11ajM2Qc+3nmQ1WRLc8zdYxetFmgdpQQgFDX6UbfKfSP/APrOfFv2QfgD/?=
 =?us-ascii?Q?OlszqXeYXQdUzft4X8jBPeT9MnTVCldVUYyLf5NWG0iS0MAsnWk9ZfzhxILC?=
 =?us-ascii?Q?CPhCcDksl9K3tXG59dLRiOgV9UnTsIGoXngWvcKC8odUns6Mv19NP8s/r4KA?=
 =?us-ascii?Q?L2xGkfgh7HeMv7AUWl1C+26WXr0EqcC/R18q719Xr7o6FycAG3hLNIVz7sYE?=
 =?us-ascii?Q?dhEz9kBilU9jt6rnGriYLJQa/UusnI5zuOT0tbMOvhZ6xG9s66VQx9Uq/5hP?=
 =?us-ascii?Q?hswtu3bMOdWynI7fp0ybN6sJ5pd6nuJpLFcZJJWdyJMcSPhnxGT/hnlMEUKK?=
 =?us-ascii?Q?IU2Xr8yzKFgtxbcsuc+roF3789UHDhDy1833gl+CiuUbtj4Ku2eRctFqynjm?=
 =?us-ascii?Q?hDUY4yiOZSMICM9S1AFRZyrgu36LQJPB+0GT0kSzjagU+XRqsBPy4LOqwLRW?=
 =?us-ascii?Q?5vDDGKwUjaH4lTXwvLaA1S+f6/VjHzERMcsslb+bRlhWogRH7QiRgjU/bgNG?=
 =?us-ascii?Q?VOYhQthfPctRJQe6M5cVnegF3Ioe8wzuu05c/xau0mRiaPV2gcPHOvtvZCQG?=
 =?us-ascii?Q?BoApyPKXWl3PDfq+xsBNTlZk5ecCGnRIRbUHEffrr9fZ6gBdoTaNoHcTSGZ0?=
 =?us-ascii?Q?CUNmsGktuTkUHaeaf85/6GIyZ1Ku4QHTFnYMz5s0H6iFZhdNRLpTy6g1aUDR?=
 =?us-ascii?Q?9qJGCGCyW70WL8H2xLuMlrw5ldnrq7qJH83iQBdU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e17a76-8d4d-42b2-ab3a-08da9b541116
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:04:19.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjB8A8psLc6iMOSbC/STQK2Suq4oA5nu0GWeYZiPOFzbF/3agUO6w0wG89TzmiY4ZEHJDpYzIi0MKh5pvZW+UA==
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
> Subject: [Patch v5 01/12] net: mana: Add support for auxiliary device
>=20
> From: Long Li <longli@microsoft.com>
>=20
> In preparation for supporting MANA RDMA driver, add support for auxiliary
> device in the Ethernet driver. The RDMA device is modeled as an auxiliary
> device to the Ethernet device.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
