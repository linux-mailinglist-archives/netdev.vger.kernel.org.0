Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B005BEBD4
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiITRZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiITRZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:25:22 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020023.outbound.protection.outlook.com [52.101.61.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAAA52DD9;
        Tue, 20 Sep 2022 10:25:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9Nj2FAL9b9+QaY5rbOrVZQdKhgrdGMM9KpaLmj+L8eCbHZqxkLg6kHT+Q2afgl71TGvqlfg69e0xbkEpK0ZS5JQ+bimW8uu/yDuS9HQhv9Vdmv5BFXHLRsl6u2e1QkNZSdx2lZmcJW/7F8HxuaokA0VwolB06/GGiGcWXXrWHKP63jHx36N6BdgKjXMdS6T+u16NYz6avuF8kwJld9ETagWn62k3wKFfgZZ15gFgxovxCMMYi1GxKATiMpWqdxwlLt/YXkFN9DJta0qnqgOtV+bXTdb4kf/K6l3QGsACiQ1gLeiJpkl4mUhFXCWr1Z4wS+BEStUa5lQL9HO/pkzjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5z+VUimxgVd+ChpsH1NWhFFn0ZB7hE6xZ5jRVBNfxr4=;
 b=l12hVOC1X1/1slc7YxiF4uYo/50YO+KfesGO8dqQAXOZLZAfL2ct/70b9TMd3P3eEm28sLfZJAkDrJTw6wVNhRY3rTYcWoYSkZ2qZGBmwOQp9BpnvGh7Bflxno7VqMHf/+VMYwEDOqKpfsa//4tHCEOiT0gjqKOx2je+OzRDyfAmKg8HNgsTyiiCtBQEs5FUAF8SxbKSaJ5wx/9wgIop8ZNYH/XKrA+kfJUgL9AxO+dS1PJSbjXLz+PhKGc81M9kqQf7r6NLQXnL/io2CYU6092ntbAz10rn5dUzKjN7IomT7bcKMmUKMCT+ioD4FxD8kWSYN7/eyMeYtTGmsW2Xfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5z+VUimxgVd+ChpsH1NWhFFn0ZB7hE6xZ5jRVBNfxr4=;
 b=CUipd8A18e5p0Y1U5lMWP6myA3kkdGxiilzhe+5RvMMJ8k3cP3zX56feI+QsVqqyLQacwne3cRiIZY5Z2t+evHy03vJ7n0GUrZHPIc+Z0x3j+LdoWCHukasuEajkyJRcaDsInt/0St1uVLvpdAqPmvJlFti8dS4foeKI3NoD7vM=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DM4PR21MB3683.namprd21.prod.outlook.com (2603:10b6:8:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 17:10:39 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::b113:4857:420a:80e%4]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 17:10:39 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
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
Subject: RE: [Patch v5 11/12] net: mana: Define data structures for protection
 domain and memory registration
Thread-Topic: [Patch v5 11/12] net: mana: Define data structures for
 protection domain and memory registration
Thread-Index: AQHYvNF7bQEmUA10cEOXp/CDsZomn63orgsQ
Date:   Tue, 20 Sep 2022 17:10:39 +0000
Message-ID: <SA1PR21MB1335EF33DEE19DBDA5841B7ABF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-12-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-12-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4b31c1e2-5dd9-42e0-a6e7-350a72d7d578;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T17:10:10Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DM4PR21MB3683:EE_
x-ms-office365-filtering-correlation-id: 2882431b-f592-4626-26cf-08da9b2b0aa8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIi9DhcU4yaI5HNahum1/NoRhugubzSJyj6bBkAsGGHZSshanXt0W1TGixvP1z06YIM8SovVGwpZEA8sx0Molov3VUGeLFR4ajUWyUvAXTjbatpAsKcogui0pB2BBbjqEIn9uAIuZszjvBOZa3FS6tkEp/BDvfTc61GLYHixaIBIngdw5dbBNpSoC6kPE9pJn7cS2v/+aLHCHg1dme+U01XoSz7WVUFNfTMPNLjOt7PKRm9ZjK2LxWjBWbiUDKDelx3zJLSOQX+6jX5OfZk1/wBtc46jSX98BQ3JTSIgQIKNtiE+ues3Ahu3bw3CjyOtnpGoZxvtuMQ/TO1xLMAh92N3C/Kv6ozAaX0fNEC6PS+8dv2+L2LWz+n3iquLLsHHh0HeV1sqoaw5nY1DUvQsuXsxsiPoOOchc3GT5XA4GmHgASUcvHC/6UlSodzrJ4Ft3WnkgSYy9LhUYbS3IdEFw7+CdoTAB60ZcChLcn0F6yXQAzwPkexWr3qVbf2N/vO+yit6mtj8iVCk90Nuwzk5mvhG5rtEYuKxVnszVhIgy+z8cDCq37V3WFJaEDYHeXESZcrm+pGrDrAlvadobZKpOhzya7dkyM0Up7YiOPA34geok9J/uM51Y5GmsjY3JvnUSNZPfNyd6/pI0sJ2TU5rgFxhziu+4we+0KwCsy0EudMUL48NcU62PxjhiUfhgy0SMq7Vb3ZSMjByidzAcu+KcXnCfVOQ3An9mtk8yVcH5Hxx7miB1mLFtTJw9hcjz1E0j+cCXq++Z+U1h80+60CMC82ENQUjqdTranBmy4ZzZw3Ii91pf8WIraJyu1RD0evZTVyakLPdiAQ/AYIGu6jElw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(921005)(38070700005)(86362001)(122000001)(186003)(38100700002)(82950400001)(82960400001)(76116006)(8990500004)(6506007)(7696005)(2906002)(26005)(9686003)(71200400001)(478600001)(54906003)(10290500003)(66946007)(6636002)(316002)(110136005)(66556008)(41300700001)(4326008)(66476007)(66446008)(64756008)(8676002)(5660300002)(52536014)(8936002)(7416002)(4744005)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cAA/ZV89XDCHCLCXUI/4Y9kHkX2jOUrc7JiXH3jRWQPRSdWv0ZxxA0/ocnyo?=
 =?us-ascii?Q?0h/D40+CIwInznxvJs0Jmqjm+XB7vzbV5c0fAAspQq1hRuDWrT1cWJ++VRFa?=
 =?us-ascii?Q?SOliqK8DC7Q60EoGHAA9NXQXaIyrkeNtFcAUGn7yRH+7WYCQ37fFznxhdaJO?=
 =?us-ascii?Q?dGsEIrZy8BRE+mVn9Ih/rXURPvJrwfuyMF2DeFad4xboRCt2gEP0GNnbLUvI?=
 =?us-ascii?Q?ru0agE3k/gvFC7JxVwoVFxXsiMLK67TRgoGYz8wuskdchYXjAKjT5MtWtsUi?=
 =?us-ascii?Q?jcmaeLxcozR9erPGv1zT8YjRISPU+q3SkWrkt9ejDAirdKrHbyqSERwh+t/o?=
 =?us-ascii?Q?oh2CaZQ0D/U9toiO+NegIpzBfWQ+jl8Q6IYwZMU8iKGRGMtIEjI2TnirZkBS?=
 =?us-ascii?Q?50y4aS+DsiFeUjmPPuyv4yFbxje8VC3ib7ux6kSsh9T+phcQ9HSrughP++aA?=
 =?us-ascii?Q?It0PuVNXuh3hxJk5H5CgWPrpHcqoaBpid8ETRrfq2vkzjFin8Cs8CySWz80s?=
 =?us-ascii?Q?K5jPU+NSKI1VXcFy9ztyUaZ87VKbIz6jagr6XzwG3QE+ymCDXClYYxOQS3/M?=
 =?us-ascii?Q?6UQdWxyTMPbzbU55FPGOIoEzFIl2PeSEK9tS6UxMmhnWVX7cCMSx45QQmEjM?=
 =?us-ascii?Q?YNeYKOl6iy4S3rDIJ1sMs3J/D6fvF5GdeviIvBVqQKlNnMLx96jtSAaMdvy+?=
 =?us-ascii?Q?E6aoYuzPurP9MA9rW0MIq+KbV8orrw9R/+cVYcjWbOT4FBoozxhzxB65T8v0?=
 =?us-ascii?Q?3eNv9eNgkvdI+J0EE9PVuw29Q2WCnXEioKC0swYSBMrgzD/d2YOWdtkp8RJA?=
 =?us-ascii?Q?wAnROWfybqRR6Vlxq6dSy19nKsCKPI2EaPGEm0Az0GTf2Mc65oYcM83kcsmQ?=
 =?us-ascii?Q?P9U70G9m/e92qO4/QaRF2zaKKFOIZ0aHE15fQdijhpVFwojOCtTfSFBeRC/7?=
 =?us-ascii?Q?aMdPjmHtqSPVs5A+M8C0YR3izflXJPnmSUHg2Jzb4qbIDgCwvxgZfOhRaK1g?=
 =?us-ascii?Q?vE4cdX21rskkoUpTYtwYbH45guU28nUH2J7iaKHN4vEtN1NP/qlwjfCgJJEm?=
 =?us-ascii?Q?YU6JpFjpmgCmtL1njs9pknMEJPC+mkMsFLbxuNYPiXg6clTip6Q6Bjb1gY0g?=
 =?us-ascii?Q?W9iiBm32Itm6dbCFR82mzYvULjQ3gjPQ44GHY7PyGkBZNeP3DkrO61gO8kji?=
 =?us-ascii?Q?q4lFLDLYNg9/FKRlr9aIpmJyYw6v5vB/WYtUWUb6ovrMKdmUd0cZFXrbF52P?=
 =?us-ascii?Q?GySmX4fjk7Yt7DYcw21gztghkQSrLsU9ygyfJm+zMWl3Om8AczjuvjBV87LO?=
 =?us-ascii?Q?QySssIJurzrXnvd8Ou3LdLUmOd9A5Crskf2tlmtMsWSi8Uw/+KEVARHLZhcg?=
 =?us-ascii?Q?MD4SyWIVFAuw4twEzwkUap2rcPwPc7d47Eeh6l+ZAHT5kGrCVOcVc+QFZcUK?=
 =?us-ascii?Q?+Q8MjlF2g/MdhzHbW2oukkmFEnk7HSuCItpqajknzCte9+vL35RSbeDsJll8?=
 =?us-ascii?Q?CaUL0D7aXg5hn7uLjYn2ZH1BDoByAjF3LKJ3oltS+g+HmpU+qxblNub5CyIV?=
 =?us-ascii?Q?23AVLIZpm/nwnT3z2phhq5FYPHwDDy5OQ8UekGu4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2882431b-f592-4626-26cf-08da9b2b0aa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 17:10:39.0568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sNCQm3AIBLqGK3GEibE4+Eum3LSVn/v4kfAAoOgHvPp/n3oHe51VVjz0Lw38xUkOgbCazKIstnWXNpjcnEKgRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 5:35 PM
> ...
> From: Ajay Sharma <sharmaajay@microsoft.com>
>=20
> The MANA hardware support protection domain and memory registration for
> use
> in RDMA environment. Add those definitions and expose them for use by the
> RDMA driver.
>=20
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
