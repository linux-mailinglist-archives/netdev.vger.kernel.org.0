Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B4B621E94
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 22:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiKHVd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 16:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiKHVdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 16:33:24 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020019.outbound.protection.outlook.com [40.93.198.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7307FC2D;
        Tue,  8 Nov 2022 13:33:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=my2BNiYSJ1wTGzoiN2GGwAh/Xv/8m5nj4i+HPSzqVTOus6ipKTB1qY2FGm51a+np/YL14tDI8UDfGIXMAQn1uVotDFTkrbrNnc68K6B/IJoPo1s8Wp53ABF+HWdj359x7M98XX/ymozOjkVooTmGHlyo07RQhyciETlvoDSXGaV9+dFWp2o4/UgCuNJPlcHlguHl29cUiiYuLbOi7DqsQpoCDKsjR4f9jWv82tvWQh+bGRwKTqXwc6no4WB+SVhCQzzGs80vJJyz3BjtMzvmNS9I4eMRLXjDOHnrqy+ooaeo3QQm23C5CRqh/rrGfn6ZfodJvom/mst7jcaBl1E2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U1IiE5DEiOmUDui/qdvSLR3wWwv8efR4X2GwMHIkS8=;
 b=bytkvdRfEh8PgYuJ3EhNefYzJEr7FJR2Vul/gxlWkvNG98Z0MUKwgytSEL/t2p0iU8gyCcYrgEkQUEqOorGTTW68apquM3rG00uCTo8m2igmr05xbVNiQ4JdPSXzY+E9ZrW1QuiqMFhU8IugJNpzxgCOJQiH5LxzOF6wWMvzi5QDJXTHJLMdN8s2mY8DtHEpDTx/d+QwdnX6bffj/Gx2o5lUMc5LlIwnZpJzfCsH6H9ZchPlnK7Zs8VLgANZFX+WuMw+/eRj8t6mYog/PRl/p0vOa2JOKD/DBAdAnxJD/W6B8fGMXaVZ6fF7ZJQlNF79h9o4jSVzLbIjJAos6mWlnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U1IiE5DEiOmUDui/qdvSLR3wWwv8efR4X2GwMHIkS8=;
 b=G5iJIPkKOdLsh5qamUX+WFuOlZvFC/lv4ms7qSEjVVCa1o0IJvZnkMnc2SoVStUBZEBWpvfbiaqpFonBzMHPUBJ/Vd6dfrBXBZ4IXOEMjFjcWq+bhVNsDzAXe2OEABdVtrap5q76k/khX+Lt5qhgkd+QHayM5/h4mSPGNh1HVnM=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH7PR21MB3332.namprd21.prod.outlook.com (2603:10b6:510:1d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Tue, 8 Nov
 2022 21:33:21 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::34f6:64de:960b:ff72]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::34f6:64de:960b:ff72%4]) with mapi id 15.20.5834.002; Tue, 8 Nov 2022
 21:33:21 +0000
From:   Long Li <longli@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v10 01/12] net: mana: Add support for auxiliary device
Thread-Topic: [Patch v10 01/12] net: mana: Add support for auxiliary device
Thread-Index: AQHY77jYyCZ4V2zftE2vySTJPn7Kra41bkGAgAAkh2A=
Date:   Tue, 8 Nov 2022 21:33:21 +0000
Message-ID: <PH7PR21MB3263700CCC9EC16FF7EA937BCE3F9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
 <1667502990-2559-2-git-send-email-longli@linuxonhyperv.com>
 <Y2qrd/BbrZUokitA@unreal>
In-Reply-To: <Y2qrd/BbrZUokitA@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e68d55fe-9f7c-4b7b-8ebc-7e806bc250ba;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-08T21:28:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH7PR21MB3332:EE_
x-ms-office365-filtering-correlation-id: 0266c204-582c-4d8c-ecc6-08dac1d0dbdf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j96ox6SQOkRZsBU1zI1YbpF55+2xZ7VDHcWCvGLfN/JrHLeIlKumKivqUgDoRp1RVH7O5BaeC4yXboCFSMOWdii0Zjnd7QV2fubU/uT/rYyQuez8Hx5zeVnEh2MtxGgJa7YvAqliA2L5L/HI+JBsc6Ql8Et37ilj7J6vWr25OshiTOreSS2W4HIM0UTtSz0btALzl5TBMjVxlHbXv4df8ARZf1wr5PbocO2pj8inJR9fEPNrJT7PPWiS47iCdGAyzI92SXNVB1Y2C5vFwoYnTRACrgHUbYU7u9MPS8/Q32JaiSy75wsdHC1CIzKK7rS3O/uuKAVYQlcuQOIOqgA44r2EET5TkDru3AqufBnKXe3SHNW0zyyjtPHA8YwGIwLvJljB2RDb9h7kvFKs12/5PLa1EGz8e4zHLlhHx2WRnUz7fil0jkOqrOdcCYh85fNEq5YJ1IeyBydSJAtRnckA2NJQect3976RyQgKQDZ8ADbd0AqtkXwzjGkl2dYDjlUM4qJVYj0HUqaJt/BQ+bDxT2OQu048YjswrYF7Cx3MBguUlTgotuZJGVJKsaK8Vdr/5wUqIyFgv4JZxA5vAsbQqQfd4Lc62LXDU6MhJnnt5taJnDaGaUAbeXE7RHXRcputDjgEz6W1NQMGU9U4GeoZbfjNObbbJf5rOswf85H/UVv6yN21a3vOmvEYHJZyUWLTehZqBpsDWzxintYfkhHM5zo0KVZjfDsA3cm7XOaC1wB7PbKO02LZQerCn26+mXUn+M6VeRfzDgAU3K4aArBBMNv/nMqbg+rNKVg5CwM0Rolt+DNSeIiI6Esorc8Vho3/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199015)(2906002)(55016003)(64756008)(82960400001)(41300700001)(9686003)(26005)(38100700002)(8936002)(7416002)(4744005)(82950400001)(33656002)(186003)(7696005)(5660300002)(6506007)(6916009)(122000001)(54906003)(4326008)(8676002)(316002)(38070700005)(52536014)(66556008)(66476007)(76116006)(66946007)(478600001)(83380400001)(66446008)(10290500003)(71200400001)(86362001)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vb9yOJTzy5FUMqr5VZ+a+AYuKIcDYhvfVOD03YOyGZZFE//rk3+/bEr4PZkp?=
 =?us-ascii?Q?kZdmM1CGi/yxVNlwelW3/mzVLj/9cFfnKJel2VvV8A+rXclvBzxp5zr8huWO?=
 =?us-ascii?Q?tXq/Jm3j419+zkPxANX+r3a2+59l53Frtmegf4WPMFCbXvO7u/d9tKs7ZnTq?=
 =?us-ascii?Q?7Wnj+WqpHryqgs9TbMHtWYHhxYs03B62yfbsafD735AJ9Y+IWfl1UsrRDaHn?=
 =?us-ascii?Q?VRaZl5GVr0n6ihQKrtJZymkZA/BqD3ab1989N8zN9SKyfdIdDtXlgGi5EI3H?=
 =?us-ascii?Q?HdbGKcO/b3CQdGQHeK2dGZFpz0kdPme5sqLt0cpRguFspJKqECD+32IImlNW?=
 =?us-ascii?Q?ThR5XGDgr7UT6CL1WYEPLaixt7kjbzV8/YPuJVshcCwZtYfIi0sZ2+8wUnpH?=
 =?us-ascii?Q?UbW/J/u/XPVbV3sb8ge6VouGza0AN8YF1t8GY6CgrGw86ZqQQFrNcGXkvH+4?=
 =?us-ascii?Q?GH2M73JlDcUjDuCeWdM+0E2MMemY/NAhM5NtYCCZJS3iBHnHAHc7wwN5keTP?=
 =?us-ascii?Q?ygA0oIChxNSd0+AyYDMZw+eM8vC4NEWLz3eg2nLixQd6LloaRQxheYnCi507?=
 =?us-ascii?Q?BI4GSw+Ym4Xp49eXvwQR3qKLUWAxvO0fv39zBrOgkFiOFfux6hnLbAeXvqJe?=
 =?us-ascii?Q?MrE6gB5wI5q9pLSUFXlMnbtr3n7yXP2AZ9LL87VVQsrazPMCyDjZlt12Or7y?=
 =?us-ascii?Q?+2VeAUDdRzDBQgCvtmXJJvWiKVFXfwJSttM0h+3Y2+iUnWhMIocdLFwR1Kq0?=
 =?us-ascii?Q?lMJdrsKLm+AOzv06dl4Mg6jVzTe7VOLv3VViXJtLgG5i8JVwZX3hTWjHKiyO?=
 =?us-ascii?Q?Iss3H3GfjzNUFEa29MbqlDxPdKTynrBdZE1Tcb1Yau1QxG/DyUrpikUmiZ+f?=
 =?us-ascii?Q?3lrtYqUzYKVIFoaoaXL6e0htNALNZfDxIzyrTQnFt23S3uPmoUr64UoJgCDr?=
 =?us-ascii?Q?ckO7ufQHFo3pzoQil7rJRYbt4BmTGJLbpR6iRK7OT+3FR52CaT+9W9vIq754?=
 =?us-ascii?Q?El8aRR72HodGW1Se/fPBlR7Vnyo/X5GacRx8HMRtxtqSGNrzkl9auH7kWeaU?=
 =?us-ascii?Q?voFuIQaObDUSsUMMcCHVb9VvhgSimC4myobPcthLAll+DHOvCKpomy+oBIFQ?=
 =?us-ascii?Q?Xh8WOuiDx+sJfcVZpH7RQEch9ssnxTX5Cj4ySdGA2tMS8xHMCdfHl9A5RgOj?=
 =?us-ascii?Q?jMyu5TLZbx+hyjHRYh60p93DXqPdmzB1/vzojA/uemEyNcjbnD4s4Ak1izgZ?=
 =?us-ascii?Q?Pk5vfEDUp8VPZ0PHSxABrg3Vwq8SaeJUv93WLZ6QFYSL7iOYwuCHSRUEmIFW?=
 =?us-ascii?Q?cYvQ5JMLR1yelHfLmSZEifgob6qPoaPww/Dc9xeJ57oPc7iw/pVJGv1JStPh?=
 =?us-ascii?Q?6qz9sH1KOMAMwb0lOOso4rXwrg/0oToOPlBOmozgxUqgdKCqqc+qygzym+RU?=
 =?us-ascii?Q?zJ6lIFN3f2/Fur8QWbQMVeV2toE/BzASeHYVUw3H3erXsPR9o2SKNzDnRSkz?=
 =?us-ascii?Q?drtsyYTWQeCyBWd/0ssOh7UUlK5nmphXWZXzedjdcki1HellC6O4bphDnoK7?=
 =?us-ascii?Q?IaXolaJ2jppBXhNEkf9PlMtepObUuKuuupfnHP8M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0266c204-582c-4d8c-ecc6-08dac1d0dbdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 21:33:21.2277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNkq8tasqA7uv/gdmlbPPSSpYyh/mGS8rFD9L6ddKkaFukMpMtmK9lXTC4hIqPMmwQCsEo0DOZLPWnHpTZqIeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3332
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > int mana_probe(struct gdma_dev *gd, bool resuming)
> >  				break;
> >  		}
> >  	}
> > +
> > +	err =3D add_adev(gd);
> >  out:
> >  	if (err)
> >  		mana_remove(gd, false);
> > @@ -2189,6 +2267,10 @@ void mana_remove(struct gdma_dev *gd, bool
> suspending)
> >  	int err;
> >  	int i;
> >
> > +	/* adev currently doesn't support suspending, always remove it */
> > +	if (gd->adev)
>=20
> This condition is always true, isn't it?

I think the check is necessary. mana_probe() will call mana_remove() if it =
fails to
add this adev to gd. If this is the case, we can't call remove_adev().

Thanks,
Long
