Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC05BEFAE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiITWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiITWGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:06:16 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8841E7823B;
        Tue, 20 Sep 2022 15:06:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xm7lng7zvgC/0Ux3Lg6LY11kD2XL4R9KjorsXKwEH/lR5fUgKogejRAfB3LxwLU02nQgjY8CIECelHQ/VdapB060386NA2+xILgrmmsDrVURiH+ibPq8cb8WQIw527VVDis6uuqVQks8Y5RwNGUwEzJvcMheARt1uf8DPfHqNykpvNqZkEn4B06hG1eSiJ34J0LtnwHQGVDlV2LKatlNuU2Aw7oUN7RSkPV/GzCIG+GMx5jUh2+17pzQxcMkPRPYA9JvZ3uhu7zhmiLqSrDLlwG13i5M3PckDSnYn02lzFGSGPeVQznxAkv9oZNT7PuPpkvoopLPLlWT6xVkaXR68g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbPTUgt86cN2N73IjnEv5VviFCxpEsaCVLlqjJxHwIM=;
 b=LU45RP+3VxLA/3TgCSJhCyvmLotmiPkpB5kj8PwDv0bpgrbzmE+ITUYNE0IJZopDnHDzw6g9VC49HQslrbFwXLpM6HXZpBro8Mwpt0vLmRlPfP38F6ksDpO58SytZiGicCajiibRbD+ZP/2XXE53OuL3/kSv2mjj/IBNP4rzWgGd0LYAZIUPuJ1ao981aqVePbrY9FmqqoVbn/eDr8CqZHYyIqwUOYijNwFcNRB5IbOeQwu3VyIcDKesSJXl+uT78hvg/I9uW9wqpiKfIIaczshiwXncCOwKab6YmCfgR5TDC+/V/jEAFeB3iQlFk5MKUME9piHkR1KL3YphS+7Ilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbPTUgt86cN2N73IjnEv5VviFCxpEsaCVLlqjJxHwIM=;
 b=CMZhH1KeZLsV7RjILW4ztmnMf94HNf7rlSirpwnw1KHGYwU8oKF8vbW3i99j4kJRrTN6b9q4BerVC4N9cyn6MCTPOHOsa2v1ekrtU27WJFFsA7V49JQElxsfYv3lxK7KN7OHhW9hPwlFIss1Rh8XfJKcNERkzbwppYmo46WrceU=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3043.namprd21.prod.outlook.com (2603:10b6:208:387::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.5; Tue, 20 Sep
 2022 22:06:04 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:06:03 +0000
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
Subject: RE: [Patch v5 05/12] net: mana: Set the DMA device max segment size
Thread-Topic: [Patch v5 05/12] net: mana: Set the DMA device max segment size
Thread-Index: AQHYvNF7XTQaeWVUp0yt3zdjORxkNK3pAKEw
Date:   Tue, 20 Sep 2022 22:06:03 +0000
Message-ID: <PH7PR21MB3116A9498798C73367BC11DACA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-6-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-6-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=24fd17e1-c30f-494e-b5f9-048c1dec8f5a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:05:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3043:EE_
x-ms-office365-filtering-correlation-id: 0db2f89d-f9a2-43c4-f32a-08da9b544f64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X6XwbPTytMHc+yZYXwGZDesc+K7NK3u+3sg3VWUqxdmYxP58Gwg2VIbfTDOb1OJqY1NSWKZSR+jz8WbymNwysJ9ZuQEbym/CZKfOMmRtCLKlDjqVKnBvfbFYLZ5eITBwJUQCM9fAf0FLvHdD2lbGxHxQCLtEdoFve6evC7Yew/X0q6XYhfeQQoIo5llp+8JqXyYOerWHHC7/BFNc1S481QD4bIwgaCs9Gu0SshbmW2kDDn27GNWLs81SKThFeToTzDLahwJoB7LRf5n9cLvkBZVh11+Y4PIFYdM5ORCQbMjwnDlHFwNzWJ3A5E4xwPWW+rl8PRBjTdvPjwauEaiBg9fnZ+Il2t3bripmEsfx+PEZIBx9RgwZLUm6Fo4fwztd8B8MW6QOaE+mFZMFnZVAtxeTRCocLKI4k3wmCstRFUBKlj/azecJVVtUlPAGLZLKNYsZ37PCinhp/KAZ3Aocl0MP4Pqa+2AeBR9ljq/HHXwHL391oKtTjfi+meaaRf+GrU77k6e9wPfaNb7F3RY99MIw/6RrvUK8rXC4YAW39l2EC8T+0WhGvwsEbVIzqQZEilVevF02Aam16OiywqJAh21/ubSKZdulauWbSmyzXIFZmk0MEQ954A9s8J7WLMkmstwKyF3no11KO/INKtCxWWM4jydClTJEJmil9bcKNk3fIVwl6XHa4kaMunc4jbRmSsQ1IPxoT5j9WXsY09Djt3BuzrtAAQQEKt9AaopWkk4O4c0F3ND4m93MVYZlvVedMFu9LV30MyuhcWZidItYfZGVdaRlEZiKPhyenhYoG3pNsEWexEETmfCh2AymXKkz5YrUWp/xvcHQfYyxEjwWBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(26005)(9686003)(55016003)(71200400001)(41300700001)(6506007)(10290500003)(7696005)(110136005)(5660300002)(8936002)(186003)(54906003)(6636002)(8676002)(4326008)(7416002)(76116006)(33656002)(86362001)(66946007)(2906002)(38070700005)(66556008)(66476007)(66446008)(64756008)(52536014)(316002)(8990500004)(83380400001)(4744005)(478600001)(122000001)(38100700002)(82950400001)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RtYFiem+JOV7UkrUDfJlT/hdGv8h6lpISjnmfQ7c8RxbaG/VJvccwhO0g1Mi?=
 =?us-ascii?Q?VIBXgAKU3UGC3S0NlL9hvHFsq5uy8TNXknfPvst2xp0sVmUM1WM1HOEvY7j3?=
 =?us-ascii?Q?ZNJWrUx8QsM2hZT+FcthsRJYCuyHHvN/T1OlVUGH9tMQOziWkPdYiyspWLUy?=
 =?us-ascii?Q?1uwRIa+rUc+OcW7E8xtzb0BuD3CzI1DMKLPAx2Ftri4u4UGqUpr/MOxnsQhM?=
 =?us-ascii?Q?7jcagvHF0JunJYWlHf7nZoP1sHh5v4lFyN06pxZ301AakYRt7CQ958h5yshl?=
 =?us-ascii?Q?bK7AbcaEvtO+rdewSm6Ps9zoeymKnvWsZadpRqApdLMcmHROtfYotQzUklHN?=
 =?us-ascii?Q?3J165UshtOcxiLimDVcQ4I9S60Pn99CWzplmWx/9CJWgNjQ8QGWaYgTb3a1r?=
 =?us-ascii?Q?vlcl2UdqKJx/YMOh/oLUc80OTEAm6M5tARSaGJWoQz3FmSpcnn1pgp+Mo1S8?=
 =?us-ascii?Q?gWrxhfO5/JhuFM4OOM0gdi1mun7POmiDYWMIjxfqYDcENFVvefe7RMSYBiMn?=
 =?us-ascii?Q?+xdukbT0uJ0i0i2n74ixOQq50Tue5JpZ7oNP2kkiNPeS8ijxhg9vFG/h8DuN?=
 =?us-ascii?Q?6fO/dcmGx9pmXd/nPu0STlByDdYujMC6Ym51r3qZjFWdM0jWSk+vHJDb4CsV?=
 =?us-ascii?Q?Q+evWGlYcDuJ6Z1sQQ7z9JVqQ+vPwBBFJbxH5eEvNB+3p5smiW7rZZCEzUnD?=
 =?us-ascii?Q?58DT9UaiRULLRQK+rxPtbmCGGUKD9j+Sxiov3DuLZcq6nqfrHA1FnI99EBXV?=
 =?us-ascii?Q?NVwg5oJPRsbW/bmbNo3s3L9cCUo7rxG5gpfkel6whg+CB01KHsGTCPq/189G?=
 =?us-ascii?Q?FRr/kRaFNWRKYnEhuTTV+EDTIEC0+kuIucfqI6ZML2V0PC7t7E2VRb7JS8Mq?=
 =?us-ascii?Q?KDmKV13qOnYYWsSmmIAkxpnIWBuIcAbaL6bYoxByCRufdRkcHNhr2Co5ivmp?=
 =?us-ascii?Q?/9YfQXWCeAhxhp3CbpgonVMNtr1bqoOij+fK4TAAS4GMBYk6LqBoJepXr3nK?=
 =?us-ascii?Q?NtP/vcLw2L65s0RipoafDImrKpSjEyQJUClKOLjs7ZXlFUM4GrEFjctqtbF9?=
 =?us-ascii?Q?goh3iAKWDTXBQjmT6RDR4K5raR5ayjilGBtTs6ZoFCwPReovmJH3NrjP7Fk8?=
 =?us-ascii?Q?+mQT9nmFmX+Ro1ompm/rIWMo1JWTO/QG6fzBNPqJocOjfqZ0heJT/DFSWkDv?=
 =?us-ascii?Q?TPu4OC8tjwIjuq0FxpPuk3OwnW4CtQ+u2QaILxmd8JREG45rJM2Ern3hx+h+?=
 =?us-ascii?Q?JWxjhML43+HgdhLu3pXAFiv3D52KhJ4XaWkIytnWvpRigtdlEMfKFmx460h9?=
 =?us-ascii?Q?y6bashov8vdgH93BETADP7baGlozjNh+pZPZd3tvkgyA63caMdUCIqsqGEud?=
 =?us-ascii?Q?Hl7sAQh887cIHN+2y2T0d5AtN7J0ndwGY0m89sfyBAH/XysfXAW2Oqw58QEN?=
 =?us-ascii?Q?wZCE3DYnaXOYe06wNHrAx2nSb3e3lP3KZK4kv/tsWsT5Tz8mmyjuMA9eH9Tl?=
 =?us-ascii?Q?lOpm/vk4lVrzsvUcdcQoLlWfQMmXcnL1Qattw/MYKpCCyyZiHn2pphdNHd64?=
 =?us-ascii?Q?rd9sMHNW0L5yce8Znk/WixdA+q1NnqdZ4P7KWE2Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db2f89d-f9a2-43c4-f32a-08da9b544f64
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:06:03.7764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ce+BS3jzhlB4jeyAZXX4ORWyF4QvHqEwiXWi+QQTu7BYUbtoI+Pt+KQp3p6tHcDklCkVY2ewm8fo/7frlb4VqQ==
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
> Subject: [Patch v5 05/12] net: mana: Set the DMA device max segment size
>=20
> From: Ajay Sharma <sharmaajay@microsoft.com>
>=20
> MANA hardware doesn't have any restrictions on the DMA segment size, set =
it
> to the max allowed value.
>=20
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>

