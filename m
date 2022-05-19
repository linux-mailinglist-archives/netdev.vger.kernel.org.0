Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9A752D57F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbiESODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiESOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:02:00 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eus2azlp170100002.outbound.protection.outlook.com [IPv6:2a01:111:f403:c110::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F9A5DBE7;
        Thu, 19 May 2022 07:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvHhDuMgJGqLm4PJvceO8UnCuDCP+dVR/giuo2Fo1WU5aKafGxgSAN/uLGIkIHdHSzOS36xPgasL//he3DeTguO/tdYd9kbqfjDGHSDPf16Elmg9JtILDxbQy995RQbk3zGTIjoZdyngxzVyhY9LBVS0KMyFw38eF/5X4zg91sXThyCM1gHyYtDkDezEfQ8OQ06XHp5+AaH8YI8Nbs6YKdroEkRTOzkcKRCPlpBGtyNVwL7Yo5IeNw6Ty7pL1KV5ovtkW21+tjY0iXtgglbRukOcpf7IUxglotbwFsme85xjEeZxgIwLtbYxo+rodNxX9K1Ny4I/x8E2bfG2gYXJWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynGEeBCN0XQvUESYmgGYylxrFJrX+EeuhjOvWG8gfaw=;
 b=FaieG8acGpmOiqj5Aw3BIxz5H95zicNEw3M0V707x7mHbLgkr9K7/Cv1UbqiDJ8Z1XE2yYs3BHJUqteqZ/O/Twg9pCEQ6C7bt7xvkj+rUZpn6FOxgp50mKpygKgTBXlAWGsBMQ/EFMwbdiGjeJaTKXn1gVMV/wqHBunTGkywLzs1gzIIWu/F1ddhEHKwly69stFdElh1D0YGLZbbkUjiQBhTFs9xgZdVRyF5my1mXb4Xh412mwnoRMwenE5ohWIDGsFgP7Q9Y/V0N5qQkB4naTa4qbtJ8pLnDT9HeS9hkpvkYoj5AA4jTbLLz89LsTTv9iUNs8oYMbC3dL0qtduDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynGEeBCN0XQvUESYmgGYylxrFJrX+EeuhjOvWG8gfaw=;
 b=C8/5kGh1/bQoCONoICzRZgFwdYXETPmg5Fv+EmVCkzAr7hYOvc0WxJhg80dX4Y58EWbWfToAbhshKqYCBN6JDBF/VGU0uvm2UtCMn7Nrohjk4W6j/wulg7Nd3a7beBn0RUQrdnS7hGd0qs/druVq+Mash1E/Jnr5OlQqS2yTJNg=
Received: from DM5PR21MB1749.namprd21.prod.outlook.com (2603:10b6:4:9f::21) by
 PH7PR21MB3119.namprd21.prod.outlook.com (2603:10b6:510:1d3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.5; Thu, 19 May 2022 13:45:25 +0000
Received: from DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4b9:a58c:5baf:bc29]) by DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4b9:a58c:5baf:bc29%3]) with mapi id 15.20.5293.005; Thu, 19 May 2022
 13:45:25 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Yongzhi Liu <lyz_cs@pku.edu.cn>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fuyq@stu.pku.edu.cn" <fuyq@stu.pku.edu.cn>
Subject: RE: [PATCH] hv_netvsc: Fix potential dereference of NULL pointer
Thread-Topic: [PATCH] hv_netvsc: Fix potential dereference of NULL pointer
Thread-Index: AQHYa3mXg5VVcdJkQU2jMWLoTy5koa0mNkcg
Date:   Thu, 19 May 2022 13:45:25 +0000
Message-ID: <DM5PR21MB174975EE6EF554BB72C60C01CAD09@DM5PR21MB1749.namprd21.prod.outlook.com>
References: <1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn>
In-Reply-To: <1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f1e090e-fdaf-4b91-925e-814f34d702c5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-19T13:44:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3885186d-ae25-4fd4-3c9a-08da399dd3f3
x-ms-traffictypediagnostic: PH7PR21MB3119:EE_
x-microsoft-antispam-prvs: <PH7PR21MB31193436EEA667A4D50F4DA9CAD09@PH7PR21MB3119.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SPAhSBaovEPBtQh8DGgrVwb3h1JStmCYdczmmUAZUqjPsYsvUW/4I5AFxXr85S40pG5T9lzG2hOVHHvFJ81JLx8IQYkKWNB4bZySnTKU7LE7HTVf2xPu/kzJhb5EyI/BM4mq5tP+ihY1u3s0oezoOes1jOjkfic0TyKgsn2iZtzuF4zdpYrh4/UHKOEuzTJj+ZhBciDmCPY8284pKh9nb0+atvumaKEXIWWPNWprt1M521OuFdi/MxjAmHqN6+P+zPl7xGyItdharkZky4N8Vjd+eh902RdQ4NoStzguKcMQoqswbdBlcPrxkKJY6BaIxtmNZZUV6u0fM6N++0Hbymcc5lPeDZrXhJhRZ/mJmKxPAhZqEapMy2MteOfMXkhvHpdzfVuEmFRgCRjvPsg4vbO4EiaIQL8V4e3fTfSo9wUDHNMYPurwzKT92dU2bN/gRzO/a5e16o+0v7COzgIO73w+tgBa0dRJvjDNsngbFJPzUCt0v+QyPMOsUPIDPuXe5s86aYCGQ0ROC5uv6bI/9pOFkv93ys907auY5+SbkkFzVXPwZ08u4o+kps2e6iRhMwAxTS2llkNE65NcYjHleZTOjIryMHpl6Xq9YtUnip6+N9hc7KMsD+pO5BlXAfCVE4xOMa6aR24tze05AaBiM8qaAMPPbEDWT/ii4NQyHIDnx/xYbMj4Of0628Ydpq6c0L14xxDk7y9If7tKcnynz7LT8lUnJozZ8AQadOAryyA9iZIUZW08KG+TzLFYQuTI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR21MB1749.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(66556008)(38070700005)(38100700002)(122000001)(64756008)(82950400001)(66946007)(8936002)(316002)(52536014)(6506007)(508600001)(8676002)(7696005)(82960400001)(4326008)(10290500003)(54906003)(110136005)(9686003)(26005)(76116006)(53546011)(66476007)(66446008)(71200400001)(186003)(8990500004)(7416002)(33656002)(55016003)(83380400001)(2906002)(86362001)(5660300002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1LbXBzfxD8xEOYbHRzL1ZAzXzi0AYvkZ5qEa/cOAHoJe5OKgsJe5Cm5RD+rG?=
 =?us-ascii?Q?xFyfB33Fak35qTrYf7fFiBMb17JKTFwd/hqs1dwIT908xCb3JFOKDE/1WB8y?=
 =?us-ascii?Q?xJ1Fyh3nnRdgFUnnkbwUhjXSRcYSMBov57DFkQd9/FYwmvqKWL0sodnF41MP?=
 =?us-ascii?Q?vg4ODlZgGh7m93zrzckdVp2ja4Z7eS0hs3GeYYCF1eUPnFi5KUk65S5fPW7X?=
 =?us-ascii?Q?HUbcYN6di70aSjM40PabVzFosPVzQuMliV/wCnZdUABt5DlyFEwtnm6N+jeS?=
 =?us-ascii?Q?E9QDATNv7YdhhsicQYzZjxz+FvyTGQLGqgbeSl3ut9l5iglQwkQn0x0BLAIv?=
 =?us-ascii?Q?A6fxEVxxdZnAJNLOxZGoAv8nPQtpkfAfefQRqScCA64IiD4T24u529xJEWlY?=
 =?us-ascii?Q?boogWQ2qgFqhK201X82lQ3FStU9ueZb9wxriYs5VjQJPUh5l9w5pKL77+BtT?=
 =?us-ascii?Q?j8UTPSYrEHMXnet1YFIEozYFDiZBBUTwA0jvErP1S3G8wowR35qtTMJYGxZc?=
 =?us-ascii?Q?VsE8Kyuncd4YyL/8b3gm3P15oWZ0JkvibM+QZ/iidXOgIMBOREdr3nS5XIVa?=
 =?us-ascii?Q?iQ0W1nx3+sTQO53Th/y6t/VVbqvS6pwV2GTbhGCpJGiOsa28/eCiLqqBS82J?=
 =?us-ascii?Q?7fuxQlGR3CVmESMPGCS5hQe2PpTYKUmiJJV8YbZgxlobxa/BORB3H2L4JgOr?=
 =?us-ascii?Q?9tiacT7tv01jZeE+kSO+CJbRUutKkGvlhq76anEPAty6l0M5Z19naInAdivV?=
 =?us-ascii?Q?7yH8dS4ldmfD+cyiEQ6wBw5aaXF8g5Y2/0UL1cVTMsryVI9wgVnKJH8Nya4j?=
 =?us-ascii?Q?IAKX526TFUbwbE/P8Jt4Oeq8t3MpON/sVA1E2Rqy7R6Gk4xG7ULbsr9bWxf2?=
 =?us-ascii?Q?HMnPy6zhMvb2UMqVfqeE4pbegkSsCIgoe3XF3J9/HHd4lmyOIQjpsnQkO3Xd?=
 =?us-ascii?Q?RIFrc+deONnKKrgSwOUFfQLe85b8QHC9rlMV0TQYMCSJL/lAqzZ2xWnTG7vF?=
 =?us-ascii?Q?ApMWl1cppOt4XdvjizzDFXrugNSxnr8p50MonyLLIPT+OaNY1Q/RvxDWDplV?=
 =?us-ascii?Q?YEA2iWQvUP9HdLHMcUbfHc0lhk3MCQA1DfDE9QckhDysLMbqEpDecBdNhoBq?=
 =?us-ascii?Q?nyFsXwNxDmedxiAyTa2BrtvOXMnIo869T+hgxNhjte4xtTyVkPIZdZkwPlME?=
 =?us-ascii?Q?O4/C5kaGnDVuAsKhgvqd3l6lwof2426ID8tRaX1/IKlHZQg4i/D3SUYKADOn?=
 =?us-ascii?Q?iGzmwmU9r/gfZAUaT2esLI33d5ueh4BHCzMtRS+6UrrrBv24+HI3RcJyk8sv?=
 =?us-ascii?Q?NV7kUiOb6R62LhQGjld2ebDbdRDYQADLvyWwtfDXUP+G8doV2Xa4Wd64C6ZH?=
 =?us-ascii?Q?l1LMMuZmHMt1Nm5nkGC4MLucI/l7eEa0MTL+Yqxq4Qo6M8f8GNLHYVgoM8y9?=
 =?us-ascii?Q?gH7s7oG5ASgrvJ26tRO1Ls5+2sF/ewwKov3Uwp3wLK0qjzkdRZwwabJjkvG0?=
 =?us-ascii?Q?foDsVv38CumPGF7N6+t0mnbKgxqTIexsHQWtekXVkWpXhfNccAkxLoXc8s15?=
 =?us-ascii?Q?ybAQKHAq2iA+lBFAYwA0lZ7aidHfODzqi+YCCJr27XWlT0PaOKAKZ84bm+6y?=
 =?us-ascii?Q?dCKc6flRzQcgx9khDHuFkbvPKxzDRfJz/9C9F6ZmBO87DCI6w/xctByLMVP8?=
 =?us-ascii?Q?XVZVpfHU3CSS8d3/JVRJ0PqdPuc049gAdaoCFYIYgJ7WS6i2cjAnqPvZLLKB?=
 =?us-ascii?Q?EV9ntUyLMA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR21MB1749.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3885186d-ae25-4fd4-3c9a-08da399dd3f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 13:45:25.4459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9PPp1A3OI2whI1YK1fRyDWxHE45aD8kP/Uc8j9kDxDsE/ktUBavejyfD4dEt/XICw6VPwS9sYi2NlGTsycjt/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3119
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Yongzhi Liu <lyz_cs@pku.edu.cn>
> Sent: Thursday, May 19, 2022 8:10 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; kuba@kernel.org;
> pabeni@redhat.com; sashal@kernel.org
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; fuyq@stu.pku.edu.cn; Yongzhi Liu
> <lyz_cs@pku.edu.cn>
> Subject: [PATCH] hv_netvsc: Fix potential dereference of NULL pointer
>=20
> [Some people who received this message don't often get email from
> lyz_cs@pku.edu.cn. Learn why this is important at
> https://aka.ms/LearnAboutSenderIdentification.]
>=20
> The return value of netvsc_devinfo_get()
> needs to be checked to avoid use of NULL
> pointer in case of an allocation failure.
>=20
> Fixes: 0efeea5fb ("hv_netvsc: Add the support of hibernation")
>=20
> Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index fde1c49..b1dece6 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2671,7 +2671,10 @@ static int netvsc_suspend(struct hv_device *dev)
>=20
>         /* Save the current config info */
>         ndev_ctx->saved_netvsc_dev_info =3D netvsc_devinfo_get(nvdev);
> -
> +       if (!ndev_ctx->saved_netvsc_dev_info) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
>         ret =3D netvsc_detach(net, nvdev);
>  out:
>         rtnl_unlock();

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Thank you!
