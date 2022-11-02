Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F68616425
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiKBNz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiKBNzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:55:53 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021022.outbound.protection.outlook.com [52.101.52.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D214629CB2;
        Wed,  2 Nov 2022 06:55:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4/RVqoukgjJ6SZ8AQbZC2QT20Tya0cQpXPVjVsEL8+rolErrQuJVkQJ2HG+7yEDwx3ERVtAD3nGIOIGE1OWFLBFkCHJsKvi1KLLpMaAzq+wfgqmxQPyObEu4rUuwusGOsH7CY2boK0vqm1G9f6JJ/S+uwzs0zhYMFE0yh/OrGYRasUk0XkRp5p97jbRoOh2ekJwSERA7SvoJTiVtYGMhgurh1PnPIBbfnfww8lEB0G7h9PPWAHeGhe7vTTZ4tX5O6Dk0qOzxA938lXTsPFVmFDRFWv0cHiw5Lk181EioSQ0nrvQhTqj2j0nlVUhllzoNHGLFBcB3JoRA1NU1idfkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GwMY7fctFknB4GITi199+ETVJCIK+fY56ehYgytQEU=;
 b=Mw/D8UDLZ03dXwMO744IbOI1z7AZtlkw9HXu6McQ6DQAvoHY0vtCm9FLFy7U0rNrCz24vt3DAv7tUgNr5FSgqfKahSfNBwxRBvdSwFiQZFE5ApkcFy+8FhSvGyEGaSOlbtW1JFzIxiWYV2ACl0FQK5ufGN0giCjkBmE94rROYq4N5mPjIHYyKDmpH2liAaHaHEzSOKdRM6ATQP3KrPYDkyXbFtjxTwzwxVNQBom9UrI/aOsQwXc+rODBTb7eSl4/5m9en/SnsIRPFOHW5PBZKnwazeoWi2Z4j/NX52z4gG8eDofZ732T33g9Y15yaNn/ZX7zPiNbEIOUHiJ6qZO7Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GwMY7fctFknB4GITi199+ETVJCIK+fY56ehYgytQEU=;
 b=V0fkG30i3qK4XtyVWI+ui/D3OLayWclYoRQdfpO5ASpfLC/6SdvqcAx2PcDoxpmMdIg9Zir0Qq0oNzVWHKsdSVBaJbECrrkXoOODxXFH/XdpJLvsXmiD8hSnWfiKdlcvugffL60m+Ca0qBAXDdnCntDsjFCfQEa9zR7e4VEINrw=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM6PR21MB1417.namprd21.prod.outlook.com (2603:10b6:5:254::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.4; Wed, 2 Nov
 2022 13:55:47 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::4cf9:b21c:c2bf:e5f3]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::4cf9:b21c:c2bf:e5f3%9]) with mapi id 15.20.5813.005; Wed, 2 Nov 2022
 13:55:47 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Saurabh Sengar <ssengar@linux.microsoft.com>,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "colin.i.king@googlemail.com" <colin.i.king@googlemail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Subject: RE: [PATCH] net: mana: Assign interrupts to CPUs based on NUMA nodes
Thread-Topic: [PATCH] net: mana: Assign interrupts to CPUs based on NUMA nodes
Thread-Index: AQHY7bgKO9lsOHP8+kCmdcQzq8fpp64rqTJQ
Date:   Wed, 2 Nov 2022 13:55:47 +0000
Message-ID: <PH7PR21MB31161ED47D7742D5F499BB93CA399@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1667282761-11547-1-git-send-email-ssengar@linux.microsoft.com>
In-Reply-To: <1667282761-11547-1-git-send-email-ssengar@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9c00726a-d48f-4d95-bec0-f3295df11b37;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-02T13:52:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM6PR21MB1417:EE_
x-ms-office365-filtering-correlation-id: b6041cec-0a14-4613-70b2-08dabcd9f177
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tBHiKJc2RiuRw17r3B5yHBI47UHM2HW2tm0b69ZKtn99Sqg3z6NYWPLp2lo3kWwQA4MA/GG8jGQ3lsWEKHf53YdtXjxTZUXKpLlkFkgvoqxkjp47I1SblxBcrEddlLaPmNmgpsx7IvDQx1BlJmYhhmZBLAH9U1Fj9soqGr9owHBbkMgSOkL3m2dzMckGMjEbqmiH4aCQX1Kexk65n3axNDWmbowiZJ7GZyytakd6/HqayyY153plc9f256EY1u33qvlGn/SXuEjYF3LtamJkCdnqsiEdTDMcapCz5RYti10WmKk4yxFInhaAOkVbFZK8i0VZXcGO4Fa4MKy8QqCUVh9CNJU9n1DOdIcDtymDefn4NZ8Zv5QmrL+bUfmEx5hM0YQTEr6Fo77ZCMeHFTZbae7cxfDRjTY1R0xB/mkCHTEJpPiGAr6h1tTsqjiP1U3vzGxo2CcXiWtdqeiUB9SXBKU/8Oae7rL0hnlZjrIupQhfTJZay5YoI3HZUIcDg9fbLmUaewUWOwurg/KEI5C9idgHZ/pGJyuKhKoCU9Lx8hiS/N49uVDmyHzZpVMIYCfsKxQ2/FEEeIIprSONqE4JyEVW0yX+1297RGmzkjpZYGDp7HhEpFk5jYW6FrSdHGM0wk253VOYBfFbemfqwQg2a54HkZozbH3ihzy9IQG8KB8P4WEGyc0z9rjxJ4Z/2KP23TJUZ27UVK2EuLLXZkgduZf1HjWgYNTcQLE7NiMvV5cKr0zxcr1+H9XScv1D7jFK3CUbj936JRKkSoSahVwoOh0nej9WjtwfNs+uU+o1dPFiqEtuVAI0rQp1XNgHYAOc7yCsjUHPgANFqaIlOqAuCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(6636002)(8936002)(52536014)(110136005)(66446008)(41300700001)(66556008)(64756008)(316002)(66476007)(76116006)(5660300002)(66946007)(7416002)(10290500003)(4744005)(8676002)(8990500004)(2906002)(921005)(38070700005)(478600001)(71200400001)(122000001)(6506007)(26005)(9686003)(7696005)(53546011)(38100700002)(83380400001)(33656002)(82960400001)(82950400001)(186003)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PfbDs58KK/y6tXQ/DNWuzd8xFa3VKGAxcQyclAqnd7MDYRJTfB2lWF7U6BNE?=
 =?us-ascii?Q?rL10ZIWSECfImvkeAMwQ6xR3ylph67t4n61d86d3WO0GE6/nZoslqPyWAKyw?=
 =?us-ascii?Q?gxE7G3eI3rbqm67+Wmpj5gl3ZrL5atbwkQ2BrJMYpjvvDVGJI1yA3tpsKbKk?=
 =?us-ascii?Q?tj1Yfg54w52oZbCpWbqgifuq+jQOXvpAEtnOc57lX6DgB+721yZ3bfD6kzX4?=
 =?us-ascii?Q?ectnlcw0lH9Y2BflnJnkhDYUQ3mbDeRqjQS9dXSd87ZKKJkESr6qTxlgeyzG?=
 =?us-ascii?Q?grpLTnvFqt3NUOt9uXJLwpjmvbGt99D8YECLsWTkcJfAprCHSz1dbhJni12g?=
 =?us-ascii?Q?LNbt0BqFaHdVsHhFORCwwr4EbsuSKLf23RzywkJP/duCnEqcdnOCwIuQPzwg?=
 =?us-ascii?Q?V6CMBfXCwO1I7jO4zzCtM0S6niuGQI92BDAjGdimfKkBNkyJDpP+UBcyMQmt?=
 =?us-ascii?Q?XzZ5rSxENa8eafL5kE9Zzjurrjab3u+Ai+vWmXNg89U3tGfStcMT6FuHfqFk?=
 =?us-ascii?Q?AWKj+ttKDQIZ1av3Dp5sBvt9+1QNfcc2Z/1ysOiql0mM2RHNEeqXGwqChFGA?=
 =?us-ascii?Q?8TZNSQZiuDpvABYZs/n85cqM5kmGrBNUJwWLLarbiHS6GgohAgsyg5M+rMVG?=
 =?us-ascii?Q?23Jpr1QlTbs9wX/XW2Hkvda1lRNmZjTGOm0KL6tx4jRtqjH4m/hv5L9eNGnL?=
 =?us-ascii?Q?HxEoYDuDHfAYJ7btYW0kwS3krGdCAwV/K+p7yDoUvyVt2PO7lKYPT5iLqf3q?=
 =?us-ascii?Q?W1OIZBR4LurCCvJnRj68DUWGsDqVtfLDTg/PGGjAn1d7Cs840jUikOe9r5lP?=
 =?us-ascii?Q?Y+M6Zy9TQoLGPg5VKQdjizftd9c9kKbUnsJgqT1PyeulcGg1+m67XE4UFzSK?=
 =?us-ascii?Q?RsnGla2zOKL/+AHXDvdi/yOFtyWy08iS8Kh8GxgdHWFUzHmmeCxddvucxvyZ?=
 =?us-ascii?Q?7lDreoup/+zwC9YZnQ8VlU005nqbPKiIhyOH4hPOUBGSeDSmWuTxjMUWRioi?=
 =?us-ascii?Q?JTCJ6bDZLaGbp4e5wJ9k1mx+Xa+g/eeFHtiYlkHLPtWEMxWEPKhCq8NZ2kgL?=
 =?us-ascii?Q?A1a/dQBFtKA+CURrtibEAUZyTktLbcP7sVVBKj6LrvW66bV4l7ZJx85K3qRX?=
 =?us-ascii?Q?U8om87trIosA/K0oMbgGMUVUoJ9fns/PlpxUwEDbPkag7oPYfWH3SwqUDsCZ?=
 =?us-ascii?Q?dvCHSUsboVwAZ/1rhGhbSdDZuCU7P8NN2igN2DQ5nwv56zAJZRQxTvWR3yTF?=
 =?us-ascii?Q?kPeqVF/YAu+uRlXtbtzLtEkNqjAz7mn+ZaN0NlCHXTEHbUFCziDLOe1z0nMC?=
 =?us-ascii?Q?bsIIdxJsc4b0Dl7xyKSyM2wlJG1gOex/0fiIBkmawM+S7c+/0zuRJY/+EVwI?=
 =?us-ascii?Q?5dd1gLiDdTu+B/8K9lxJqZKnpEg4OZoIp5aljUY0GUbhz28BGp6REsLD8W/y?=
 =?us-ascii?Q?/DnxfLTrCinQEprReo9NMru672Wy4kL71ODL061vbok9X3Q7s7HRP1NOnI16?=
 =?us-ascii?Q?CHZ8kX9B1fi0SDhE4UsQaNXeqpgjj/Qh5K/KPZmqyoxa5zCylJ4o5CihCma1?=
 =?us-ascii?Q?NlP5nabnYKIVSX6TUBHVtr6cS6wh3ebrFZmgY3dO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6041cec-0a14-4613-70b2-08dabcd9f177
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 13:55:47.0783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1JiY3Xnu207+F55SDxHmPLSmSGXCl+Y4Q2nNAWyKJdHTywUYpEBkGGcyLzsl4RZ/7LcLO1e6pZE5qpHZXEIT6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1417
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Saurabh Sengar <ssengar@linux.microsoft.com>
> Sent: Tuesday, November 1, 2022 2:06 AM
> To: Saurabh Singh Sengar <ssengar@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; ssengar@linux.microsoft.com;
> colin.i.king@googlemail.com; vkuznets@redhat.com; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>
> Subject: [PATCH] net: mana: Assign interrupts to CPUs based on NUMA nodes
>=20
> In large VMs with multiple NUMA nodes, network performance is usually
> best if network interrupts are all assigned to the same virtual NUMA
> node. This patch assigns online CPU according to a numa aware policy,
> local cpus are returned first, followed by non-local ones, then it wraps
> around.
>=20
> Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Thank you.

