Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B96266DE
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiKLE0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiKLE0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:26:52 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9925BD4E;
        Fri, 11 Nov 2022 20:26:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehQWvPUvdpj1bycVNeo6RagwpULfaL+XbVCt5zqB60Mlh71x8JZLcX3BVEGerM3Ow96JkQZNKfiIUKssADHJzEEAxtpw97lUVTccNjUf0MFyH7g2/iTguaAJAYeZ1+IhL9CDa1laSC6NgjxhEvGbqpjpjHFsDPfvCj03X13QCzmJ63Zi5rW0jQEfR45PjevyQogWvUlesQTfjp7ZMa65SSRj7uKhrng961VHK8ZUiPNP41DgiefuZVXiP7OHji4gzaB6KwJ62i+zpGUess8C8FdVDqRhiLEyGeKRniVSRhJ+G23l49qQ9MjiZhuqmiIBcLZYqS/HTGTGlUMKmXuW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwRpBseLXAHLDiB+JLZM7XlLZaTjB50yPGJmifgaBng=;
 b=CV1S8BXe7env0unV/ejpKIgnVPkupPbgkERzWTctwU6TCOGFHRc0OrGD+gtBDh8z+k0ZMLCXffA6p7CSFRJOMq7Uxd+Ya3JAZOXwYXi6wQ6UrbvX0xtWbZIPVh0PzLy7iznWbAQsGTGoN15t56+Sa5uSzTiK+a7nxt26QG14pOHLZpXkH9cqq5rJqZPREGlgQc5/25L57WcCDrYXZDehpd3rlC+URN6ntZdgl/ePdR5eqdWJNhx4j/UguB6+CF6GqjuGZVRA9YSLiOu1YcCA11w5Y5xl3lgUu1gG0i7zdsPljiRbJ5zIc/bOxN29fodYcmvN1JPYNS26B8YRg2k06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwRpBseLXAHLDiB+JLZM7XlLZaTjB50yPGJmifgaBng=;
 b=M6tpn6E95xj3sVGChka88aWpqbcfpevxBBvO9buo74c//qYVIiwx1nwMw8mZwY/61jxjRr/2iR3dHZdYYWuX6nIOFuSstWKHxxHyWnD6xGy8EzmMLXbzRThy05KIsX/XvOZc73wu+x0EUMoxOnAF6bbtMBQaCd406eYG8Sc97PM=
Received: from BY5PR21MB1394.namprd21.prod.outlook.com (2603:10b6:a03:21c::20)
 by DS7PR21MB3431.namprd21.prod.outlook.com (2603:10b6:8:90::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Sat, 12 Nov
 2022 04:26:48 +0000
Received: from BY5PR21MB1394.namprd21.prod.outlook.com
 ([fe80::908:1dc3:c68:7420]) by BY5PR21MB1394.namprd21.prod.outlook.com
 ([fe80::908:1dc3:c68:7420%8]) with mapi id 15.20.5834.005; Sat, 12 Nov 2022
 04:26:48 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Eric Dumazet <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition of
 basic u64 type
Thread-Topic: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition of
 basic u64 type
Thread-Index: AQHY9bPD+aHWKX6dGEui+44ZF4If3646sltg
Date:   Sat, 12 Nov 2022 04:26:48 +0000
Message-ID: <BY5PR21MB139450F4AADA9953317E08FED6039@BY5PR21MB1394.namprd21.prod.outlook.com>
References: <3c1e821279e6a165d058655d2343722d6650e776.1668160486.git.leonro@nvidia.com>
In-Reply-To: <3c1e821279e6a165d058655d2343722d6650e776.1668160486.git.leonro@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8d857c23-e1e7-4492-a346-670d2023c5ae;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-12T04:26:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR21MB1394:EE_|DS7PR21MB3431:EE_
x-ms-office365-filtering-correlation-id: f057980f-c109-4c40-4154-08dac4661d24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a3TxgvTO7ZYZiSb9RkpgqhbBwglTQBLAhNG6tAsXqRZe2BAlH2QeqRjyy3qb2CBoNmDWfwI8SpZNyUqG7ZcKnQAsH8mjLQsjdJDxuKeXqhOstgrYUZaR5M5BL2j1NnQ2xNQxcTmQaX8T6glJWHBrDGWmZJ8XgU3HZQjuVBXVxWy0wOHHBZ0FKfWi2ijl3vA24kbaBnZ5ccR+6i8s/suT5Ph3C24L1E5nM7955ylHVzs6LS8NYpEysqejUzb4xbhdZz2LR42C6sDSqSQ3dxQ3W0Z+MRokOTxEm+pW9KgeClhu0UVS81I8IoC7alXMaBajEF5Jv7rPaeEYRRH2cUC6Ix1ppkDyMKuZ2OjyZSc7EQ8Fef3lQSgmL0NvPvZCwYlJBOf1orDx7m64h2ZHxGreiftuaeBWpnBh0Vc7li6oyzUVGsCZWzVZtx4Q7Nu/FHDSk1o99EcsiqYSEy8l2K87n1PydEHpCJwAjoX4rohRLZDdVr872QjOra+cfcH/JM0eMfIOu3RyWPX0nb/s9cbwwh8EiEbrXGsZ6Rp1ea0SaHxvsmHjgrUJWIuhM2hNfMMBVo0oOe5SOe1vxRCoQc1xPpqIZVVbuLsb/X59QZW7WBcD6tMWFIb2FbIQGw+zZeMh5ALPyrsHn3J37znEIALcZmL/iH4At/Y/IN/uCCIziz250Y5MWWCOPq9U+mUaLVAS3UAKdIlbtTFmKBAIKxGZ5+53bgRvKhLyJKLG9XhoPAkc9L9vKydDKoNoQPHPxzHHKN59oZcY9ZMHrNp9LyXxVozaHj2rnwv1zzFT2e6je9P+rQZH9DXBl1xTOjaN2LGY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1394.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(66946007)(41300700001)(82960400001)(82950400001)(33656002)(83380400001)(478600001)(38070700005)(38100700002)(8936002)(66446008)(86362001)(8990500004)(122000001)(76116006)(66476007)(64756008)(55016003)(4326008)(7696005)(6506007)(110136005)(7416002)(71200400001)(107886003)(54906003)(5660300002)(52536014)(9686003)(186003)(2906002)(66556008)(8676002)(10290500003)(316002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nabDpiheffHbjc1Ek3JdTIW1/gWh5hEotkAA4H63ZNcqWQxk5cV6zWQqs+j8?=
 =?us-ascii?Q?A0vyDRoWg00Z5UkVA35yvnHhILlawp35Kzn7T3v4Rya7hRgb2kzjfW6o8Qn2?=
 =?us-ascii?Q?yCtKC1K2QbohGjsP3StN50eK+i8uMfFnsuNVwifQfZlTVzNzYRW6hfGtlkrK?=
 =?us-ascii?Q?AmMz6Eovb1QFLzOotlZw9CmzPmYeaWi1sTQYW3pYq9VkfMFGOiHQuK+hQK4i?=
 =?us-ascii?Q?GkmGVq0jkawch6FXYcmdxnm1i6cFXifADVPCpTyWcPiqLM0Hhv/Ki8AEVSQ5?=
 =?us-ascii?Q?d0c/0JkqI/Tk3WLbRWC68YCY2UChwl5ZRU620O/Z5sH/fi1tQj58rxjTKdcJ?=
 =?us-ascii?Q?aVoz5XbiSambll1sitMmapgjnwxXIjvob4VS4+547/FgiABpp/uHuTOEajkz?=
 =?us-ascii?Q?AKKusCjSUyO4msU0jorOw5LE5vtlkHAjjscj3eOzxLmYd/S/yIhHyvmIcLr5?=
 =?us-ascii?Q?boKhZJ+LuORgTyaQukYzW98ttxGB04parAaNGiq/umcWE6lS8Cp7zDrVDpE3?=
 =?us-ascii?Q?8NiZA3nHC+MmcPjsJezQUpHGPZmWFi5itWyD9h3xsyC93Q+M29tiuFDp1JCe?=
 =?us-ascii?Q?zRy4iWX+sxlB8uNRdZjTgkKwGNLO6GrQKZFuK1/tyoQoNWA01vCVBOSyT4zP?=
 =?us-ascii?Q?xNP5wR9bjZ/F1oxTEgZ4OSjViDX7OJjD+dxT2zMMOoy2u9kaRZAVBdR3MTCU?=
 =?us-ascii?Q?OzO8j+f83fvWex+lAxkjenrdMze+7YEJBKubyo90AguI8/6vOmxJnH6aYiXq?=
 =?us-ascii?Q?uflWgGxgvQ3F9TqzG29kN0NaVkmK1jcimPlVbd25wxLmjVC63N3NWE1yCUK1?=
 =?us-ascii?Q?mWJPe2B3erx3NQYC01Qf4m4CZ5HP5PnzuVSJjZAE28dkBLb+ia2S1cAeS9wQ?=
 =?us-ascii?Q?044ToNOtLagRNJB0KtYEBGc3VKA0+VMG6kCSpAGI0qLtR6nG63uqynyqFQwr?=
 =?us-ascii?Q?HF+IWwlcagKeRzM2uEf5OuS3/mSZ92RwlumQ7nL7nZkf1ojgMtvnJe9IdzS1?=
 =?us-ascii?Q?7Yc5UtVcOG5RH6cIaxqL20JovOQ6ms+3MQXhwBFwVALDzvd1QklUVxUBD3tB?=
 =?us-ascii?Q?dVNejKPoxBkFDq84gTkhwj/y/foR1IjQqEFRfQGgfPdJiSrUJtv6yhCfiFcQ?=
 =?us-ascii?Q?S6x+OmvOXe6st2FhnKykSTQF2JFcE/hs4gY4T73+kpRZSJfwov5d8mVCyaRa?=
 =?us-ascii?Q?+7esMP3nt6NBI9B1Twqa5wvIMrN+P5QHcTGvu2TXuj6iqobNs9Xs+9qV8QbN?=
 =?us-ascii?Q?ylyRYBs8keRKQwMdO20lHSuR2jrN7zcu8MPmm5Y4/OCiq61AaV1PnZX69gfc?=
 =?us-ascii?Q?pBjiVbg7IAbbiu3GYFFjjEKjRo2nFvGNu8oUc8uYPaL0XFRKtCNUtMCV4e8k?=
 =?us-ascii?Q?TGfEfMpOqeJlzYKp0dS0oFunRfh9WXynjxEQ7SaWTqipJ/LFTCqxrX4A/hOP?=
 =?us-ascii?Q?2tGN0Ygrul7EFY2VPknrSiWImsyPbNKZoCkAbHSGHedX64hwRz3c7m9yRbqP?=
 =?us-ascii?Q?y8CK1s73lCoNwcpfRjo+Wm3JVLy0EcP01yH1AlnTlfwMj2agYFq4tsSoNRg6?=
 =?us-ascii?Q?b9+c3SqmRwuqo5UB+5VFxgMDlY0yKRYXX8eYbmbk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1394.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f057980f-c109-4c40-4154-08dac4661d24
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2022 04:26:48.0814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fmxTAlP1YOeZwi8IZEIG66IKGR9THgkHp3CklPpEqv7jkofIkwcAHuK9D4+zM40YstgPYloAX44ozI6SI2of9zWmas7WiB4HK4BX1+13hkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Agreed. This was just to keep in sync with the naming conventions on the fi=
rmware side.=20

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Friday, November 11, 2022 3:55 AM
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>; Ajay Sharma
> <sharmaajay@microsoft.com>; David S. Miller <davem@davemloft.net>;
> Dexuan Cui <decui@microsoft.com>; Eric Dumazet <edumazet@google.com>;
> Haiyang Zhang <haiyangz@microsoft.com>; Jakub Kicinski <kuba@kernel.org>;
> KY Srinivasan <kys@microsoft.com>; linux-hyperv@vger.kernel.org; linux-
> rdma@vger.kernel.org; Long Li <longli@microsoft.com>;
> netdev@vger.kernel.org; Paolo Abeni <pabeni@redhat.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>
> Subject: [EXTERNAL] [PATCH rdma-next] RDMA/mana: Remove redefinition of
> basic u64 type
>=20
> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> gdma_obj_handle_t is no more than redefinition of basic
> u64 type. Remove such obfuscation.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mana/mr.c               |  5 ++-
>  .../net/ethernet/microsoft/mana/gdma_main.c   |  3 +-
>  include/net/mana/gdma.h                       | 31 +++++++++----------
>  3 files changed, 17 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/mr.c
> b/drivers/infiniband/hw/mana/mr.c index a56236cdd9ee..351207c60eb6
> 100644
> --- a/drivers/infiniband/hw/mana/mr.c
> +++ b/drivers/infiniband/hw/mana/mr.c
> @@ -73,8 +73,7 @@ static int mana_ib_gd_create_mr(struct mana_ib_dev
> *dev, struct mana_ib_mr *mr,
>  	return 0;
>  }
>=20
> -static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev,
> -				 gdma_obj_handle_t mr_handle)
> +static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, u64
> +mr_handle)
>  {
>  	struct gdma_destroy_mr_response resp =3D {};
>  	struct gdma_destroy_mr_request req =3D {}; @@ -108,9 +107,9 @@
> struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 leng=
th,
>  	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd, ibpd);
>  	struct gdma_create_mr_params mr_params =3D {};
>  	struct ib_device *ibdev =3D ibpd->device;
> -	gdma_obj_handle_t dma_region_handle;
>  	struct mana_ib_dev *dev;
>  	struct mana_ib_mr *mr;
> +	u64 dma_region_handle;
>  	int err;
>=20
>  	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev); diff --git
> a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 46a7d1e6ece9..69224ff8efb6 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -671,8 +671,7 @@ int mana_gd_create_hwc_queue(struct gdma_dev
> *gd,
>  	return err;
>  }
>=20
> -int mana_gd_destroy_dma_region(struct gdma_context *gc,
> -			       gdma_obj_handle_t dma_region_handle)
> +int mana_gd_destroy_dma_region(struct gdma_context *gc, u64
> +dma_region_handle)
>  {
>  	struct gdma_destroy_dma_region_req req =3D {};
>  	struct gdma_general_resp resp =3D {};
> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h index
> 221adc96340c..a9fdae14d24c 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -65,8 +65,6 @@ enum {
>  	GDMA_DEVICE_MANA	=3D 2,
>  };
>=20
> -typedef u64 gdma_obj_handle_t;
> -
>  struct gdma_resource {
>  	/* Protect the bitmap */
>  	spinlock_t lock;
> @@ -200,7 +198,7 @@ struct gdma_mem_info {
>  	u64 length;
>=20
>  	/* Allocated by the PF driver */
> -	gdma_obj_handle_t dma_region_handle;
> +	u64 dma_region_handle;
>  };
>=20
>  #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8 @@ -624,7 +622,7 @@
> struct gdma_create_queue_req {
>  	u32 reserved1;
>  	u32 pdid;
>  	u32 doolbell_id;
> -	gdma_obj_handle_t gdma_region;
> +	u64 gdma_region;
>  	u32 reserved2;
>  	u32 queue_size;
>  	u32 log2_throttle_limit;
> @@ -699,14 +697,14 @@ struct gdma_create_dma_region_req {
>=20
>  struct gdma_create_dma_region_resp {
>  	struct gdma_resp_hdr hdr;
> -	gdma_obj_handle_t dma_region_handle;
> +	u64 dma_region_handle;
>  }; /* HW DATA */
>=20
>  /* GDMA_DMA_REGION_ADD_PAGES */
>  struct gdma_dma_region_add_pages_req {
>  	struct gdma_req_hdr hdr;
>=20
> -	gdma_obj_handle_t dma_region_handle;
> +	u64 dma_region_handle;
>=20
>  	u32 page_addr_list_len;
>  	u32 reserved3;
> @@ -718,7 +716,7 @@ struct gdma_dma_region_add_pages_req {  struct
> gdma_destroy_dma_region_req {
>  	struct gdma_req_hdr hdr;
>=20
> -	gdma_obj_handle_t dma_region_handle;
> +	u64 dma_region_handle;
>  }; /* HW DATA */
>=20
>  enum gdma_pd_flags {
> @@ -733,14 +731,14 @@ struct gdma_create_pd_req {
>=20
>  struct gdma_create_pd_resp {
>  	struct gdma_resp_hdr hdr;
> -	gdma_obj_handle_t pd_handle;
> +	u64 pd_handle;
>  	u32 pd_id;
>  	u32 reserved;
>  };/* HW DATA */
>=20
>  struct gdma_destroy_pd_req {
>  	struct gdma_req_hdr hdr;
> -	gdma_obj_handle_t pd_handle;
> +	u64 pd_handle;
>  };/* HW DATA */
>=20
>  struct gdma_destory_pd_resp {
> @@ -756,11 +754,11 @@ enum gdma_mr_type {  };
>=20
>  struct gdma_create_mr_params {
> -	gdma_obj_handle_t pd_handle;
> +	u64 pd_handle;
>  	enum gdma_mr_type mr_type;
>  	union {
>  		struct {
> -			gdma_obj_handle_t dma_region_handle;
> +			u64 dma_region_handle;
>  			u64 virtual_address;
>  			enum gdma_mr_access_flags access_flags;
>  		} gva;
> @@ -769,13 +767,13 @@ struct gdma_create_mr_params {
>=20
>  struct gdma_create_mr_request {
>  	struct gdma_req_hdr hdr;
> -	gdma_obj_handle_t pd_handle;
> +	u64 pd_handle;
>  	enum gdma_mr_type mr_type;
>  	u32 reserved_1;
>=20
>  	union {
>  		struct {
> -			gdma_obj_handle_t dma_region_handle;
> +			u64 dma_region_handle;
>  			u64 virtual_address;
>  			enum gdma_mr_access_flags access_flags;
>  		} gva;
> @@ -786,14 +784,14 @@ struct gdma_create_mr_request {
>=20
>  struct gdma_create_mr_response {
>  	struct gdma_resp_hdr hdr;
> -	gdma_obj_handle_t mr_handle;
> +	u64 mr_handle;
>  	u32 lkey;
>  	u32 rkey;
>  };/* HW DATA */
>=20
>  struct gdma_destroy_mr_request {
>  	struct gdma_req_hdr hdr;
> -	gdma_obj_handle_t mr_handle;
> +	u64 mr_handle;
>  };/* HW DATA */
>=20
>  struct gdma_destroy_mr_response {
> @@ -827,7 +825,6 @@ void mana_gd_free_memory(struct gdma_mem_info
> *gmi);  int mana_gd_send_request(struct gdma_context *gc, u32 req_len,
> const void *req,
>  			 u32 resp_len, void *resp);
>=20
> -int mana_gd_destroy_dma_region(struct gdma_context *gc,
> -			       gdma_obj_handle_t dma_region_handle);
> +int mana_gd_destroy_dma_region(struct gdma_context *gc, u64
> +dma_region_handle);
>=20
>  #endif /* _GDMA_H */
> --
> 2.38.1

