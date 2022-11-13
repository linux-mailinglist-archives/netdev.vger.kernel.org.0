Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6DA62723E
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 20:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiKMT3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 14:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiKMT3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 14:29:19 -0500
Received: from DM6PR05CU003-vft-obe.outbound.protection.outlook.com (mail-centralusazon11023021.outbound.protection.outlook.com [52.101.64.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FFFDF4C;
        Sun, 13 Nov 2022 11:29:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEK6lRIePtsGQCuwpUSbRIRJNDSbHcq9Kk01U1PjUMxBWaiEehSuJQ5ZqbrwfbKDHt/gJmhqOQfmL7XOUSrcPKrzULhFcmjnREKdTtOEkijG/VxCvJkpaYrAFj5brecuAT2r8S9cKlNBKgGCwu7OYUaPN+RrcFlZq5j7qG6dgL3fQtkAa7qwYRa76lsbuHcFA5EgDJBlmwlGRtBGQa9RRSplCmQYK7CUgjjjbRiSpbDdWBNRsgA9ykxu0jAXAMNtluhhLqzGI7lqaLSYvU8roW9EM0Zt1rYiXOgbTNXAyOflv01T6a8FmcuDdEpEvumpBmxNm4XhQA5pWMxEgfiBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usIKV9bJ0jirS7oh90MFF27Vq1Tnyffvy87bzOmdhxg=;
 b=Gvu8/9YgqemGMfXW1sKX7jFXbDmblW+YRbKx68tgSeH++yeKrYthg5RjiZrSJeQCqqDKl1XSeTerBP73JqzZ3CbdXLXT0ckPI7e/OhPJBUDMcW7wNVVQdg0WJuwIMa0DeZMIkqeYmG6gzzBldVlHIdlLs0KHozB3jfyuVFf7XZz/o6kNK9z0tDBpR7gDcJbfQwVQw/nPCsmCFOvWgLH9ajM024gnFSkGUoqTXqBVhvCWw66+ckRvcl+qNJ/L8VKgcPxrevxfZpyNTbke6xMkf+KF+/z9Vt7pMuVSA4pGGGq0A3uab0R2WIQ9Ap0vLSg1JVacQM2Zu1dfz1UH4mMZqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usIKV9bJ0jirS7oh90MFF27Vq1Tnyffvy87bzOmdhxg=;
 b=B7SiB6fRUaFBuUlxu7yMFMVe0u7BNQMw15tnoGiuKAIOylsX0UpAlVVeIZd2I8lzwwBBtucreLIA/4gKz2A5xICL0s8ZHHnJNQwsYmyR3jWF/18BlT/CkN2RsCGKoHU61mePDi86Ew1HVHWHnS23jzsZ9o4NX2LSVvpoMbwHw+o=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DS7PR21MB3406.namprd21.prod.outlook.com (2603:10b6:8:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Sun, 13 Nov
 2022 19:29:05 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::34f6:64de:960b:ff72]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::34f6:64de:960b:ff72%5]) with mapi id 15.20.5834.006; Sun, 13 Nov 2022
 19:29:05 +0000
From:   Long Li <longli@microsoft.com>
To:     Ajay Sharma <sharmaajay@microsoft.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Eric Dumazet <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: RE: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition of
 basic u64 type
Thread-Topic: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition of
 basic u64 type
Thread-Index: AQHY9bPDq1tJwCLmNE2e9uTNRcjXPK46so0AgAKOOgA=
Date:   Sun, 13 Nov 2022 19:29:05 +0000
Message-ID: <PH7PR21MB326378C556522D9F02E51B55CE029@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <3c1e821279e6a165d058655d2343722d6650e776.1668160486.git.leonro@nvidia.com>
 <BY5PR21MB139450F4AADA9953317E08FED6039@BY5PR21MB1394.namprd21.prod.outlook.com>
In-Reply-To: <BY5PR21MB139450F4AADA9953317E08FED6039@BY5PR21MB1394.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8d857c23-e1e7-4492-a346-670d2023c5ae;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-12T04:26:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DS7PR21MB3406:EE_
x-ms-office365-filtering-correlation-id: 18ebc6e2-564c-4124-c9c8-08dac5ad5405
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r0080qlatElRA7DzD8xbQxPdWYndeC415Av3eoJCJ8RbODuN6HeCyCLP6Evp28ieGkRYhknJbvW5scs3MJNaEEhnRS7Yset+wCmInIMwhNzpXk7yzBsNSVWS+J5cmaCgFwkT73zRVyspOPDNqIZhualAeOlmB8dig5s+W1f5+qx2SpCvh5Td9xv/AFqsAQvWIl/r5M/FOQu3Hyne5HDB1fiMYDa7JRf1GVha673DbX6djOpbCVCbtTGafpDfIFfdNj0OyvOH7na0YFtRwdSrJHuc8OA0Re7ul36pESeKU0i0ljQ+2fhv4NafQXY37t/lUc3xm+Cdw+Cm36kX/KfJrVlgQ8jv5lxGhbeYtugWYefSS9Zgz8G5mjNGYYs4rJlgfxGEEgI5YKAdIOiR3EmrPTe/69XjSy0rULRK+x0NaLvjp/JL4rO0bAdof5MCyNZTTUuQrW+VRTmj4fd+wAhJI2YVJ9fAbZvDPONDzBIWq3vGZkkVnbOMMjGrfp4HT7jvqJYZA+FExdsyMQSvWX1iPWZqb++i+jh7eukne2whcTbAa4vqa5alWRRq36tBD6YFon5iRKlnsFtNSjOn+PMxtR3OJQqI4bvqyMh93hclqifD4iC9sMiqpJiLlPZ2mtVsL2g+IYP7z9aPg2F6Sipq7YR3fjpRNJ+oU5Of5UpY5FqFedTY0qBZv7viS9/Af3iOBWykDYl7SHeaQ7kiNak1aGhtECwBQy0nS9al8SFo9NB5wKXd9lXJ0Oy/oRM1H0zfCW6/VNseY2ODDTUm8fuyxxwxFxy/EixiTTuF/z7fRFvD2P3WenKvfRPk4szWX1Iv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199015)(186003)(7416002)(55016003)(110136005)(86362001)(71200400001)(82950400001)(10290500003)(54906003)(8990500004)(82960400001)(38070700005)(38100700002)(316002)(122000001)(52536014)(478600001)(9686003)(6506007)(83380400001)(26005)(66946007)(33656002)(53546011)(66476007)(7696005)(4326008)(2906002)(5660300002)(41300700001)(8936002)(66446008)(76116006)(64756008)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KWUcyeT474ovdtVS/DfAcjzs4hgGuP4dQlI9dW96MPihVRZctTa3BXhYDlr6?=
 =?us-ascii?Q?2hiWgZBf69TcfLaBx2LDtIDtESmqF1Y7UF1hCwooo5PWydrTypx1cHJAuyUB?=
 =?us-ascii?Q?DIOE4UF0edhFXu2A5imu83+ejrbOEnY3ESK4/wTSzqja3wwql44W1ietiuME?=
 =?us-ascii?Q?sI1o0ZZdq1e3QPbaScRU3zoao1BUKxOT50bzcqwqAbgGj3iQNqBwrPyEI1Ak?=
 =?us-ascii?Q?Ux3fT10d0eNB2/7WoorQ0o3nrGXD7otQXLkZJfYGSDHbjKZulccEXVvYmJCm?=
 =?us-ascii?Q?UztkeKfJ4Go3hQx+gn9sWTIqwkagf1JCHBo+c93ykEn/wojAL3lPd3/ZMT39?=
 =?us-ascii?Q?jlK4MO41oC+QTPZfzkvs/d9U5UdMpc0hecF9mGfZjH0dr8qMgT5TMw5CNRzB?=
 =?us-ascii?Q?9/Kt+4xX0ErZ99PMFklKZP7zJ5bZG5o8wyJAA8QZLA9Sav134irIdsKnLYte?=
 =?us-ascii?Q?G+15x2z4r+bm3KYZB5Kd5BMCPIKET/aug9wbt7j1U07DssrLLGlWtGADZRql?=
 =?us-ascii?Q?0Gm+xOn4eO2TwqY5rbrvECXayIbxxkZv09YS4B2rXUl8olvtHkS/IpfuWQBK?=
 =?us-ascii?Q?/c+zAbiTEkiCr6WbCdId+v0kkEJKCya2hXhNGGzt0rA9aD5vp7O+FeY0j1/m?=
 =?us-ascii?Q?zJaN+yh9FBrBJl0EptBz6XT1ivZF4yragz/j0+uF9YFJfyZeXhQfv7nX9RuR?=
 =?us-ascii?Q?RmEmce1YEjfwqieK/mKu6nhnJwk7sOUfx6qtqlTLH39IRQVr+YRHi9gnsDnc?=
 =?us-ascii?Q?99oekrPYXu+i46tTO3m2nk+l/2ARo/aZOnn5NIPtUfm6Racp/CJa7jRwUyf3?=
 =?us-ascii?Q?KV6vk6M9MAdhXAtxqfL0bwZm5hYvXrEanGP+c2bdX+0Xe2iR8do8W23ZSwl8?=
 =?us-ascii?Q?2vkQaFRb2Yq7APFieGb643RggxvjUsrortn2YZVLmRvHW0EmtzuRzGj/pDPI?=
 =?us-ascii?Q?SlJgcgACklK+tTdDdaT9GlB9hyonONaRI9KnHtpn9TaVd/8tgQugZuOL6kcx?=
 =?us-ascii?Q?f7DvhVIp4trZIHc/8XJo5TvSjYDxbduJkT2GD5XKhZjgmM1vfH55TaaIx5l+?=
 =?us-ascii?Q?bcppJuKnZ0a69bW4YhpsZovFfTn5u3goxziEVzZI7YXlGf754bk5/fIP43pd?=
 =?us-ascii?Q?DS+RtXO2TJuYXugCJMuLR9n5cRrg4tF6Vs+l1hbUhoz4BzAV+05hPaGXgGOA?=
 =?us-ascii?Q?UqYZvn0g5XlGDfjuv72jOrgddROUfGJ54WMA8Z6xCUbcpqtHopDg3Rh5gDzH?=
 =?us-ascii?Q?Z2eK525VEu9OYLC8T9YInTnloJZimbzEQB9mZeVRIzL68GU/fDvvOTaO40uc?=
 =?us-ascii?Q?P+eoPEHS0bDnGiwst3u13VKXuIie2KRjNzcp3M0tWoLutDoLuKq9IRb05GH9?=
 =?us-ascii?Q?y9vNZgod0fxYySwyRcybgsvzaviwppWUJx/QYRzVHU2vEBlCWPy1R3uBXpAB?=
 =?us-ascii?Q?WXjSyor9Quu13uOzF4mqaFm1SnFeKS88WGUjmzKTLANk9CfMc22gW6nTEfLP?=
 =?us-ascii?Q?40QCnL0XqLEwl+TyaMRg6tsvglNxVMJ1ywEn4mj7YNmxv3ZHie6UjQvWZI9R?=
 =?us-ascii?Q?L3I6xsnqALh+Wu1uFsgWVOTFgOlkvmPBqzvtP2ae?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ebc6e2-564c-4124-c9c8-08dac5ad5405
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2022 19:29:05.5713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b0K5zin6z7TMcZVI/tC7NujIYvVwCL6W5WjPJAv3HdEnfB/RZLKKwXEzArlIboYs1qRevar1yTmBPwA9YiXl1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3406
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Ajay Sharma <sharmaajay@microsoft.com>
> Sent: Friday, November 11, 2022 8:27 PM
> To: Leon Romanovsky <leon@kernel.org>; Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>; David S. Miller
> <davem@davemloft.net>; Dexuan Cui <decui@microsoft.com>; Eric Dumazet
> <edumazet@google.com>; Haiyang Zhang <haiyangz@microsoft.com>; Jakub
> Kicinski <kuba@kernel.org>; KY Srinivasan <kys@microsoft.com>; linux-
> hyperv@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>; netdev@vger.kernel.org; Paolo Abeni
> <pabeni@redhat.com>; Stephen Hemminger <sthemmin@microsoft.com>; Wei
> Liu <wei.liu@kernel.org>; Ajay Sharma <sharmaajay@microsoft.com>
> Subject: RE: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition
> of basic u64 type
>=20
> Agreed. This was just to keep in sync with the naming conventions on the
> firmware side.
>=20
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Friday, November 11, 2022 3:55 AM
> > To: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Leon Romanovsky <leonro@nvidia.com>; Ajay Sharma
> > <sharmaajay@microsoft.com>; David S. Miller <davem@davemloft.net>;
> > Dexuan Cui <decui@microsoft.com>; Eric Dumazet <edumazet@google.com>;
> > Haiyang Zhang <haiyangz@microsoft.com>; Jakub Kicinski
> > <kuba@kernel.org>; KY Srinivasan <kys@microsoft.com>;
> > linux-hyperv@vger.kernel.org; linux- rdma@vger.kernel.org; Long Li
> > <longli@microsoft.com>; netdev@vger.kernel.org; Paolo Abeni
> > <pabeni@redhat.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei
> > Liu <wei.liu@kernel.org>
> > Subject: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition
> > of basic u64 type
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > gdma_obj_handle_t is no more than redefinition of basic
> > u64 type. Remove such obfuscation.
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Thank you.

Acked-by: Long Li <longli@microsoft.com>

> > ---
> >  drivers/infiniband/hw/mana/mr.c               |  5 ++-
> >  .../net/ethernet/microsoft/mana/gdma_main.c   |  3 +-
> >  include/net/mana/gdma.h                       | 31 +++++++++----------
> >  3 files changed, 17 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mana/mr.c
> > b/drivers/infiniband/hw/mana/mr.c index a56236cdd9ee..351207c60eb6
> > 100644
> > --- a/drivers/infiniband/hw/mana/mr.c
> > +++ b/drivers/infiniband/hw/mana/mr.c
> > @@ -73,8 +73,7 @@ static int mana_ib_gd_create_mr(struct mana_ib_dev
> > *dev, struct mana_ib_mr *mr,
> >  	return 0;
> >  }
> >
> > -static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev,
> > -				 gdma_obj_handle_t mr_handle)
> > +static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, u64
> > +mr_handle)
> >  {
> >  	struct gdma_destroy_mr_response resp =3D {};
> >  	struct gdma_destroy_mr_request req =3D {}; @@ -108,9 +107,9 @@
> struct
> > ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
> >  	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd)=
;
> >  	struct gdma_create_mr_params mr_params =3D {};
> >  	struct ib_device *ibdev =3D ibpd->device;
> > -	gdma_obj_handle_t dma_region_handle;
> >  	struct mana_ib_dev *dev;
> >  	struct mana_ib_mr *mr;
> > +	u64 dma_region_handle;
> >  	int err;
> >
> >  	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev); diff --git
> > a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > index 46a7d1e6ece9..69224ff8efb6 100644
> > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > @@ -671,8 +671,7 @@ int mana_gd_create_hwc_queue(struct gdma_dev *gd,
> >  	return err;
> >  }
> >
> > -int mana_gd_destroy_dma_region(struct gdma_context *gc,
> > -			       gdma_obj_handle_t dma_region_handle)
> > +int mana_gd_destroy_dma_region(struct gdma_context *gc, u64
> > +dma_region_handle)
> >  {
> >  	struct gdma_destroy_dma_region_req req =3D {};
> >  	struct gdma_general_resp resp =3D {};
> > diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h index
> > 221adc96340c..a9fdae14d24c 100644
> > --- a/include/net/mana/gdma.h
> > +++ b/include/net/mana/gdma.h
> > @@ -65,8 +65,6 @@ enum {
> >  	GDMA_DEVICE_MANA	=3D 2,
> >  };
> >
> > -typedef u64 gdma_obj_handle_t;
> > -
> >  struct gdma_resource {
> >  	/* Protect the bitmap */
> >  	spinlock_t lock;
> > @@ -200,7 +198,7 @@ struct gdma_mem_info {
> >  	u64 length;
> >
> >  	/* Allocated by the PF driver */
> > -	gdma_obj_handle_t dma_region_handle;
> > +	u64 dma_region_handle;
> >  };
> >
> >  #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8 @@ -624,7 +622,7 @@
> struct
> > gdma_create_queue_req {
> >  	u32 reserved1;
> >  	u32 pdid;
> >  	u32 doolbell_id;
> > -	gdma_obj_handle_t gdma_region;
> > +	u64 gdma_region;
> >  	u32 reserved2;
> >  	u32 queue_size;
> >  	u32 log2_throttle_limit;
> > @@ -699,14 +697,14 @@ struct gdma_create_dma_region_req {
> >
> >  struct gdma_create_dma_region_resp {
> >  	struct gdma_resp_hdr hdr;
> > -	gdma_obj_handle_t dma_region_handle;
> > +	u64 dma_region_handle;
> >  }; /* HW DATA */
> >
> >  /* GDMA_DMA_REGION_ADD_PAGES */
> >  struct gdma_dma_region_add_pages_req {
> >  	struct gdma_req_hdr hdr;
> >
> > -	gdma_obj_handle_t dma_region_handle;
> > +	u64 dma_region_handle;
> >
> >  	u32 page_addr_list_len;
> >  	u32 reserved3;
> > @@ -718,7 +716,7 @@ struct gdma_dma_region_add_pages_req {  struct
> > gdma_destroy_dma_region_req {
> >  	struct gdma_req_hdr hdr;
> >
> > -	gdma_obj_handle_t dma_region_handle;
> > +	u64 dma_region_handle;
> >  }; /* HW DATA */
> >
> >  enum gdma_pd_flags {
> > @@ -733,14 +731,14 @@ struct gdma_create_pd_req {
> >
> >  struct gdma_create_pd_resp {
> >  	struct gdma_resp_hdr hdr;
> > -	gdma_obj_handle_t pd_handle;
> > +	u64 pd_handle;
> >  	u32 pd_id;
> >  	u32 reserved;
> >  };/* HW DATA */
> >
> >  struct gdma_destroy_pd_req {
> >  	struct gdma_req_hdr hdr;
> > -	gdma_obj_handle_t pd_handle;
> > +	u64 pd_handle;
> >  };/* HW DATA */
> >
> >  struct gdma_destory_pd_resp {
> > @@ -756,11 +754,11 @@ enum gdma_mr_type {  };
> >
> >  struct gdma_create_mr_params {
> > -	gdma_obj_handle_t pd_handle;
> > +	u64 pd_handle;
> >  	enum gdma_mr_type mr_type;
> >  	union {
> >  		struct {
> > -			gdma_obj_handle_t dma_region_handle;
> > +			u64 dma_region_handle;
> >  			u64 virtual_address;
> >  			enum gdma_mr_access_flags access_flags;
> >  		} gva;
> > @@ -769,13 +767,13 @@ struct gdma_create_mr_params {
> >
> >  struct gdma_create_mr_request {
> >  	struct gdma_req_hdr hdr;
> > -	gdma_obj_handle_t pd_handle;
> > +	u64 pd_handle;
> >  	enum gdma_mr_type mr_type;
> >  	u32 reserved_1;
> >
> >  	union {
> >  		struct {
> > -			gdma_obj_handle_t dma_region_handle;
> > +			u64 dma_region_handle;
> >  			u64 virtual_address;
> >  			enum gdma_mr_access_flags access_flags;
> >  		} gva;
> > @@ -786,14 +784,14 @@ struct gdma_create_mr_request {
> >
> >  struct gdma_create_mr_response {
> >  	struct gdma_resp_hdr hdr;
> > -	gdma_obj_handle_t mr_handle;
> > +	u64 mr_handle;
> >  	u32 lkey;
> >  	u32 rkey;
> >  };/* HW DATA */
> >
> >  struct gdma_destroy_mr_request {
> >  	struct gdma_req_hdr hdr;
> > -	gdma_obj_handle_t mr_handle;
> > +	u64 mr_handle;
> >  };/* HW DATA */
> >
> >  struct gdma_destroy_mr_response {
> > @@ -827,7 +825,6 @@ void mana_gd_free_memory(struct gdma_mem_info
> > *gmi);  int mana_gd_send_request(struct gdma_context *gc, u32 req_len,
> > const void *req,
> >  			 u32 resp_len, void *resp);
> >
> > -int mana_gd_destroy_dma_region(struct gdma_context *gc,
> > -			       gdma_obj_handle_t dma_region_handle);
> > +int mana_gd_destroy_dma_region(struct gdma_context *gc, u64
> > +dma_region_handle);
> >
> >  #endif /* _GDMA_H */
> > --
> > 2.38.1

