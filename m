Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B898E388AA7
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbhESJcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:32:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26576 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229668AbhESJcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:32:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J9PiZf032264;
        Wed, 19 May 2021 02:30:51 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-0016f401.pphosted.com with ESMTP id 38mqc1hp5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 02:30:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCKdWuaEfFrqHLNAf5EYA21DB0jYlp0WFZnYQkFuDCgadipL7W5OIpyaHJ0uvU8Ca9s2Q2THTNhivWaBrm/B0grjPCizDytFYrR8ARonoJfHJ0iS/idQ4HoASA4AtHSV5zDxXCge7gQ7ibj37VkqTVDNtTZYkQEayW8qtaW//ljO5yROJtFVL93SJqrrLz0e8w4KgPd1Hk5U8WpDfy/8Un2OofvcWOx9AAYyAZPokuBrqdlCxy2HVLjDXoJZMoA9cMULDYLUwgLq9dwSI0yAo0HcixVtofck/SgxBH9UJsDXf6aTai+OThMtifMFZlGavi06P8ZHb68vMvMam59FBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v4cLvCqx03mmA3ch7SWljviVaHIsQoIe8md9tcriyw=;
 b=dHOzvKzQQPXVNqMen3SvZsjH/ysJFFyJZ0nsbToUFVdqW2klTz6LNUN1H2v2Io0zPCpUuBAGGewsTWOno3dvueIARGMd8RSToszo38tX8tc0pGkoGvCbHpDjj4KX+DP4HaXmi3ch9d8t4FtGE+vbmW4ZcOoKuL9i+t04EAMPE/eXPbqtVtsz5K/2zloI5bnkSk1otW1zyH2VNvRiaO7tkRdond+9e4qmdgv6TQ4ov+2psieodp90FlABv0Q3U+J5vY5kVT0l5wgdrexPcY3jZ5e8+GbHHvbwwdojGMQJUso5cwCguGXbOZBcaAXvK1TXTXkVALCuq/I6ckq9wU8awA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v4cLvCqx03mmA3ch7SWljviVaHIsQoIe8md9tcriyw=;
 b=dL9OBe4KNtGdGOGVIAG++vw9qTcdDS6F215iQCNSK74BPHi3fYBEoDxL+ZOlCet23z1uRo9QQmZziYF5Z8f21SyBmmmpwj3QvqZl7T3Ha0n58kFwUQMsOVq78q0zS427/JXD2jo42g9x9RUv9q6R/bnjnsQWUBvUIdeEOu4WYnM=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:2d::6)
 by PH0PR18MB3896.namprd18.prod.outlook.com (2603:10b6:510:27::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 09:30:49 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::10ad:7f4c:f888:b700]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::10ad:7f4c:f888:b700%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 09:30:49 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Yang Shen <shenyang39@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: RE: [EXT] [PATCH v2 05/24] net: broadcom: bnx2x: Fix wrong function
 name in comments
Thread-Topic: [EXT] [PATCH v2 05/24] net: broadcom: bnx2x: Fix wrong function
 name in comments
Thread-Index: AQHXSvJ+eAx++mbHVkmqNK2UfEEjF6rqjNsw
Date:   Wed, 19 May 2021 09:30:48 +0000
Message-ID: <PH0PR18MB403932EAA58A847383EA6E54D32B9@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
 <20210517044535.21473-6-shenyang39@huawei.com>
In-Reply-To: <20210517044535.21473-6-shenyang39@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.37.151.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9590e9fb-8723-4f9e-8dae-08d91aa8c9b5
x-ms-traffictypediagnostic: PH0PR18MB3896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR18MB38965C22DB957470B4F36221D32B9@PH0PR18MB3896.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sF3aULvGFOQPHQKv69UcDNCNZAsyg85AHhBiauqgSzQzWyloi/mBw1lJbtq8n8C41nz8be+pUhnSa4N7fsW3IlYHHNkjYlQKzxOk3G/jL1qnE9scS6TVNCY4DSQyMZRYLiBVpgot4PnSSW98ztO0wUPWheRhWSDQzdZQglUMbSFSAXEaIpeYe9Kf+JgsL22ESn42MWH5exQu9C+lbCN/V5C2v4VL3n5u2E3SNBi0bSXTWzv45fHBJkXWc+/y6q1zv/RenSVYWWhEkFhKBEeso1c3/4cWx94tr3L5+Npg8JBjUYjBPKlvNAm0gJ5FRXfIuebQ3PFv0g835djqVyRg/e304jxY+K2ECoSCjzVJZlduiGx9+cdJY7QBhcRZPWZEBM7UiNC2M4yKsarBkS2aMjfWiQBHEgXYfbfXRkMF4lWlOjrZW7J/LWJ9CRwOpfZzZz+S8PdxRFMRzcLkUXSnOXjWlAAllfq0DCoiBYiGSYOvb0YYM1u/n8sMop9gjNB2dUNQp3FFyQdwEeROeLTEc4BmjhI+iYWejoJDdum0ykUj7VObac9n7XdgcvmGkyyusmoY39wsnBQYspoMLo4Ozk+XCDtzXBl18ti4H3mwhjY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(5660300002)(54906003)(478600001)(122000001)(110136005)(38100700002)(107886003)(26005)(66556008)(6506007)(7696005)(186003)(76116006)(316002)(66946007)(4326008)(66476007)(53546011)(86362001)(66446008)(71200400001)(83380400001)(64756008)(52536014)(8676002)(8936002)(33656002)(2906002)(55016002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZnqkHjNzhDTpk90tQsBmcfNEt5WDMfEvfQwnaFefNoZkOgjc/pPMF0sriwrF?=
 =?us-ascii?Q?3h+zEjUQD0m1r5586ynHzkLvsuM9D7uk4a5isLt1aONxqlzeBV3L3KrVN0x/?=
 =?us-ascii?Q?bN/uca0vU+2U0UB2Nj6VJ+4A0wTxFI88f1V0UlyC6qiU0uPFEkw8FUcgv0dp?=
 =?us-ascii?Q?ye7gsH6M3w5Lhlxo8aizWBB+yS8nyVQfFsa3E89DfykntcfvuE+15ASPr7Kh?=
 =?us-ascii?Q?ehIHCx2ttrnvUpLNIdp7vNSdDLpHazRVZqcZzgYIAN9pFum9GYowY2Lygs9P?=
 =?us-ascii?Q?C7qomXA80WFZ2DRuTdu50YhsF0+PcEl2tZ7O3ZLmcF8hKXfyGAlNDt0u7Rr+?=
 =?us-ascii?Q?J+7JW/fAm/mSWGBwtET213f9z/2EGtTveghnDmK2w+tOYPuWWvaugjSD2iAR?=
 =?us-ascii?Q?tOStd5ouhNYuHU03Ol8AZb15Wc37u4eEj2fWrwS0/X0vDWRkV3oyb0ZwLDHL?=
 =?us-ascii?Q?v/2khk5BrYLwevga+PCdKBpY9JcouZoJDTn00CScG9vdmhr3Rs4K8fe+XPXc?=
 =?us-ascii?Q?S73+tlavWO3kHOja4dpkkDnNPMXn0jckAzoBCIynap3T/z/RFO2PETIslfYS?=
 =?us-ascii?Q?mm2bstxBdO1TnuVmZsmvRTW0NoVwPwPnNW9k2MO6KHjiCQjiZPCwdzb25kO3?=
 =?us-ascii?Q?e6Vqb9nE+45zQu+/+LQwLDQ82/LK/35i414Nfq/hZwIXkczfu7JqoP4ddeHs?=
 =?us-ascii?Q?xt2Xy+4MJ3jdGAPQ1gTVZyfbYFmJR3J8gvRYgkfsAPQ/jShZx9nuofv9QZLB?=
 =?us-ascii?Q?4AQBVd2Uu788idXiZJYB2Is8cohbaUEf5IMR8R64rJ56JV61sPRobDp+ATe/?=
 =?us-ascii?Q?QN+1SYjEatW6QRP4xYKg0C8F7OTM+3EyYfvltMsNYNX8cIcpZu1q0ywvi2hs?=
 =?us-ascii?Q?+0fZe7WsdvgIv7QEOVqerA9kXgVtMZ4tiM6rqGmgI1ibMdJWXSQPE/FIO1N5?=
 =?us-ascii?Q?QgDvxg0wPY8TOa0bwtNLK2XFpCKT+RIzomsmGqD5uzTtUfiBYYFlDHcDRlbe?=
 =?us-ascii?Q?0ea/JX+e4MvwtVKmywXy/Bg41q42ZTbhuM2nt6yvIlfKfed8cHFLjm5oan0U?=
 =?us-ascii?Q?MAghnqg3p3qwbCP8CUWRjZDpQC/l7YQ7ktnhbD98ROiuMw+Y80GFsWXo7nZY?=
 =?us-ascii?Q?yWt8xwtDqrPUl0qBcULsJU4cO8RLFXnWDVWdtGDfgCCW4zxC//or5M/nnku8?=
 =?us-ascii?Q?WhmODaNwxCcnrWbZ2AYPKbMMsAt7+2FEv9odFGowzTDoyt/pef50k+cac9aC?=
 =?us-ascii?Q?yOYr3JwMrZUBi/SEruNGdYRbmwuHodA9xXidZ5xkU9IcGXpar10ftt+WjGAU?=
 =?us-ascii?Q?JT4GdlfKQMbmogqJDaTr1F+g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9590e9fb-8723-4f9e-8dae-08d91aa8c9b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 09:30:48.9308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c/gyJUhlF04utbcytI0EqIKoJX0Bdmu8uikQPI01cT1twLsP1B1dEqlzSbeLs3mMD3jCC/OCZZK4f0tk/w8BkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3896
X-Proofpoint-GUID: PQCclEQXzB7tWgHna_Zvygoissw6ByuJ
X-Proofpoint-ORIG-GUID: PQCclEQXzB7tWgHna_Zvygoissw6ByuJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-18,2021-05-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Yang Shen <shenyang39@huawei.com>
> Sent: Monday, May 17, 2021 10:15 AM
> To: davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yang Shen
> <shenyang39@huawei.com>; Ariel Elior <aelior@marvell.com>; Sudarsana
> Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2 <GR-everest-
> linux-l2@marvell.com>
> Subject: [EXT] [PATCH v2 05/24] net: broadcom: bnx2x: Fix wrong function
> name in comments
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fixes the following W=3D1 kernel build warning(s):
>=20
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13595: warning:
> expecting prototype for bnx2x_get_num_none_def_sbs(). Prototype was for
> bnx2x_get_num_non_def_sbs() instead
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:4165: warning:
> expecting prototype for atomic_add_ifless(). Prototype was for
> __atomic_add_ifless() instead
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:4193: warning:
> expecting prototype for atomic_dec_ifmoe(). Prototype was for
> __atomic_dec_ifmoe() instead
>=20
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c   | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 281b1c2e04a7..2acbc73dcd18 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -13586,7 +13586,7 @@ static int bnx2x_set_qm_cid_count(struct bnx2x
> *bp)  }
>=20
>  /**
> - * bnx2x_get_num_none_def_sbs - return the number of none default SBs
> + * bnx2x_get_num_non_def_sbs - return the number of none default SBs
>   * @pdev: pci device
>   * @cnic_cnt: count
>   *
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> index 6cd1523ad9e5..542c69822649 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> @@ -4152,7 +4152,7 @@ void bnx2x_init_mcast_obj(struct bnx2x *bp,
>  /*************************** Credit handling
> **********************************/
>=20
>  /**
> - * atomic_add_ifless - add if the result is less than a given value.
> + * __atomic_add_ifless - add if the result is less than a given value.
>   *
>   * @v:	pointer of type atomic_t
>   * @a:	the amount to add to v...
> @@ -4180,7 +4180,7 @@ static inline bool __atomic_add_ifless(atomic_t *v,
> int a, int u)  }
>=20
>  /**
> - * atomic_dec_ifmoe - dec if the result is more or equal than a given va=
lue.
> + * __atomic_dec_ifmoe - dec if the result is more or equal than a given
> value.
>   *
>   * @v:	pointer of type atomic_t
>   * @a:	the amount to dec from v...
> --
> 2.17.1

Thanks for the changes.

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
