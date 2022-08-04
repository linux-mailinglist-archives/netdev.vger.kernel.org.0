Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CF7589B95
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiHDMVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 08:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239701AbiHDMU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 08:20:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3236E564F1;
        Thu,  4 Aug 2022 05:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPVtUdCpSEJdPocAlfaPLgAL2R2Iq9XWfbVclGvUq2K7vE3U5JGWE2lr/zbGoomKSOXpYRCXVSwhbdMiCWaBuRQxcWCa5zYHcj/70dkmGKMgWguSxVC9H9AC4PizUKk0Jsyqe9SHPc8BVjmc1ZssXIzwcI09VMZjT4lv6MVrEA4mYW/Wn9HMGr41EvJ6RprdzOANqlCD+c0rFkDY+KOPXqDsnMr8t3KY6fznMtliVSr3IsGMoKmE3Zdzz5YVmqAdsAKgXl/Pzm6ShyGMKM7PIWmrQujmZXbjaJXRerERFuv9SnpL3L0i9rbpqvw2jW4CJtDxq7YWWS7RQwf/RBLBsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVLQr2O25VNPa7j+zcQpmDh3UqT3sTW9RHHMRwGGZQY=;
 b=PGmAWJGcq6j/QCnUlrsz0NkwYfhpWL3Ib/egU63n+0rjgdgeeNYt88FEY8I4OshboCsAxHDAraC5MKMGQNwBH/5rLDLjjEZOuxuNcoL3RzQH2ENY8YdukaPVe0dbBClex9xgYmOd6i8F5VrlopCoHT5pnE7aga7Iw0TRSLHmwx6k5MtkAYCdSD3VdtYbqjQTKqXU2HiAvEdIwfujk7WTRM3LGHtyG5j4iVxaU+2sYiQTmSsy98TrFpEW8chhwcw2qhMWc5TN6IrO3plCoIHWr7e+389L4DcwEmbbcGIVQp81ReBqHTG4fJiZrhhodB76jW1ETGAIMJ206nzWq9dIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVLQr2O25VNPa7j+zcQpmDh3UqT3sTW9RHHMRwGGZQY=;
 b=acZfxXo5QuiznuuLV/xAN57Mx2GSyr3BlJ0qT6V+AhY9WC8ifUv1cG36k/XA5p+5hoYD6jxk0PWelqFDIOxD8NQOzdHpsWe6LRznXAN4gX8eDnHZD6AtdhkKmbvve1co63xJThEfFs1s9cT+urlWQNr5RQ7hWEzghwupnRGTXIp1v5TIAUOZG4KAyblKpdO4X/ZpLqGUpnCaZUgfuAiykVO7Osmxt0OmizO3ua6p95KWLZNW9wEPBA8CGBTL5TK1MhsmtsnqCQV5If9pi4vpCbMS/xvKZubmbltW0Vt820g2olQ+K79kT3S/7VxKg6HCT65NsIhXIBkdQ3YszTsr1w==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by BN6PR12MB1539.namprd12.prod.outlook.com (2603:10b6:405:6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 12:20:55 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::bc33:c992:d654:2670]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::bc33:c992:d654:2670%5]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 12:20:54 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Thread-Topic: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Thread-Index: AQHYpYz823UbypK34UGkFNMWE0pI2K2erAPw
Date:   Thu, 4 Aug 2022 12:20:54 +0000
Message-ID: <BN9PR12MB5381BAE6F85C68E1C9168A50AF9F9@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
In-Reply-To: <20220801095622.949079-1-daniel.lezcano@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f399a4af-5908-4d72-b9ba-08da7613c73d
x-ms-traffictypediagnostic: BN6PR12MB1539:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fd+fZpACJIjL1p7RtnkDJlPHafRaoPZhejqt4zoMZ0Pzf/iTjL2/Cq6HtMyXjNikuzp2FKbt4qY/faT5IWGus9QVAwF4DNyBsC6e65qIPD2tcPb5SujBoP4I4qav9TvBcHVjCTdpgiZu+oEEsxkzaCt8Sj4P6iM7hSI6Co7qccAVMTfZtjDxR4gMHF2rdW8FPnOwujm5fbtUovJf4P00xPnpNZFdklID10m7/VX/BBrizB/GhfZRmecWE2w1yjk1S/Ye+WwCI0FQ+e5VgmQSVcEbJeVRpn/FgPreK1Hx8n/n+knxfGwNjQ6gDYs9ciC2v9gMD8N0HIr58QqnUSsbQ6avyOPzVnmlZYMVjyVAjU/1/q+svZbbqqOcWYEchSc3fUT+xhhT6yZQNHMMJwFMdyHD6eWnfPTbpN9fz3XnfeYeCIgTCtg0EUHUr6upFeq1Prs9c2y/zaMM+EUSLC6T6PnmWaSKR433Ml6vOJ4UWjTdWuS/suKLi9GbKkvST9rQihz/V8B+mFW4OK9B2Cj2oIPB0S6SBXwGD9kSiRuYVkM0GTHMX6brmOKtI4x17JGvojqF0tiXkEGh/VpJhjmI57SDDCjvtHm7aZm3xukSItCfNmeJAdgJL5QtfmpbF3cctq6HZJwwtC3eLeOUil8l4DCqSOmP+/172mWN7MApdHDFHdILZFYJxvNkg+revh5ctQcrIKHt5cVYU2Wbl8DqaQ8TFIGgt1RFqJKFSOjI34UywQa4ah+AZKWdniQVZFgppJS1Bd7b9yUQzPHC7JYhRgSw7rioNc+VdCMMibElifpIgUw/H//Ow0hMw5urHJQndigPKtyufxXsk9hl7Leo/FdqthwUbnc6x4kwl0hwoCNhT7CaR97Hj4DzCiXjf+nZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(55016003)(316002)(110136005)(66556008)(66446008)(66946007)(66476007)(52536014)(8676002)(76116006)(64756008)(4326008)(71200400001)(478600001)(966005)(8936002)(83380400001)(86362001)(54906003)(38100700002)(186003)(2906002)(5660300002)(41300700001)(33656002)(38070700005)(26005)(9686003)(53546011)(6506007)(122000001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ken1GPGIIYKi78SAx+I4cJKL1cvSgeR63OFoPbx/0++t/0Ssy/cPD3b9OiHG?=
 =?us-ascii?Q?yK2QTF6NXIYDqtt3EKLz94IDjQq6YPceyRvfeJ2T/10Xn2VH6Viq6Yjl1Dt3?=
 =?us-ascii?Q?LnVvI4VJ1t9jnLeHJlvzcxCFYL+K1/aioDcrklWuMxZBib9t+sQfoEKM/Zw9?=
 =?us-ascii?Q?s1MOl+c9hIdC7D7RTz55vrSxbEWbDU8Pk3sox3Imw1RJopzNZEePOOJ8Lwrg?=
 =?us-ascii?Q?M00snR2FbogvJrk9LN5q9+VE6bMMw9QZM4eD1UycE1/xTHNTJQeweAt8oDAQ?=
 =?us-ascii?Q?IFalWGzaTcWntdHNphdzHjmTFrO/D1uACsQR2g8phNHt3es9EUT1xC7sYR4k?=
 =?us-ascii?Q?OF/gZMfMcJcWcS+OPXZq33HSoMjyEMFiadP7AdRxSCEC85S1p5C8XxbFaHKd?=
 =?us-ascii?Q?K3/EsE+Ic0wMHdZqQ0C0gFK1irWqcCobnM3shmoDvuGQLY+ywxjhS/lctqPe?=
 =?us-ascii?Q?LoyDnaa8ObV6IqlRoqRFpaBXqcRkDg2r8oYrzfjC2ei3lTIEhm3tlhRW2Gbs?=
 =?us-ascii?Q?JeQjxFYvan3x/K1MgIKDdlU7F3feU166vGhWallN/AnUMl7wm3JtpEvNcjet?=
 =?us-ascii?Q?5L9sg3BQT1O8JFl+XlIiWEM3Lemka7GmDqd1Fd6XKDNVs/X6v6vfsE1eaOwr?=
 =?us-ascii?Q?PsIgFt5xV9qHx+1WuvIDJCdINlQb8n5/KwU6wmkO0HlPTAtjItIagNOcxjhF?=
 =?us-ascii?Q?j7T0YoZnxNuIp6cYMHjp53R/g0s2aFpdIpR8ONhJNe6gxJdSXMIxygaeNz03?=
 =?us-ascii?Q?Of4wIt46dvF0JSn1dy4yQE5azo9it5n5xtk+22Vc7Ttn7yHpqUDBWJEVa6M0?=
 =?us-ascii?Q?V9B6rH95s89d8cFq5jiM6B5p/CXZA03ZUpgAyNDpxOHnlSXlutG61pUAlLPg?=
 =?us-ascii?Q?jETLv4419z94zoDNvYfD8wMvHQXBZjed86Q+tGfmrV8/BYuhOXenA5XNALK/?=
 =?us-ascii?Q?T+sjIH2Q7oKN2t1/pP9lVTP+jSny79EzcqAhNaY6mMi57X8eLYpQcmjP778D?=
 =?us-ascii?Q?IHLFTT97T4QgLeNO6kygnmQReRdlDWYFR5aUcFIh8iW4B4RKdmyuYkxyPHHg?=
 =?us-ascii?Q?JlwyEc3BWIQQkqaaleUOR4ac4bYn4p+xDyYsG5m2Ykc+MjMWx5QKUePJvqCK?=
 =?us-ascii?Q?TVXrYgdESzchBfPicQ12p4TkEw7DrmnocJBlgrjVkj+/QklkL8fm+KmyI+0F?=
 =?us-ascii?Q?YMsUA+KPIT/riITqmYvveNG+8q/Kx+8PWKDIKTkMr46+Q28vGE+vQZtAjtng?=
 =?us-ascii?Q?f7zr1izOzbYGw5afS1MESd9tVo+BQgIpVklxcATyvNxbV6TWSX1eeKFr5U4V?=
 =?us-ascii?Q?RlNTRUjwr5Gl5kVhXxByrHSAG0+6SKF1HA/XeWoK5H3yiPscgEwIK8NzGpvE?=
 =?us-ascii?Q?ZtWjweJZ1Wn920FCdrVy9WTseaNZTfOKM7yqnk/uY+CMvR1Kf9RicMQMEWYn?=
 =?us-ascii?Q?tI2YgVsz2sGdct3YtCubBC6/0auJMoRT17Z3YlSBej05IFmAb3qXUVfd7ICA?=
 =?us-ascii?Q?fOMQldBluj0cKOxhamtzBqudhzUI28qURLycFSU5YJeBIU3fr+Q+KCkbmyHq?=
 =?us-ascii?Q?BE1u5xuJxL9bZnzhpiucge7X8Pyfm8BGaFl3WUxq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f399a4af-5908-4d72-b9ba-08da7613c73d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 12:20:54.5357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkvEcXg94fu6WHCsf9q4WFpkmxzKz3a5+D2VZ/5Umib4nnntmggNXqXiBy50223O363BcO4+sbu2sCUmZ77cKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1539
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> Sent: Monday, August 1, 2022 12:56 PM
> To: daniel.lezcano@linaro.org; rafael@kernel.org
> Cc: Vadim Pasternak <vadimp@nvidia.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Ido Schimmel
> <idosch@nvidia.com>; Petr Machata <petrm@nvidia.com>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>
> Subject: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
> callbacks for different thermal zones"
>=20
> This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.
>=20
> As discussed in the thread:
>=20
> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-
> bff366c8aeba@linaro.org/
>=20
> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
> actually already handled by the thermal framework via the cooling device
> state aggregation, thus all this code is pointless.
>=20
> No conflict happened when reverting the patch.
>=20
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>

> ---
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 23 ++++---------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 05f54bd982c0..f5751242653b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -345,7 +345,8 @@ static int mlxsw_thermal_set_trip_hyst(struct
> thermal_zone_device *tzdev,  static int mlxsw_thermal_trend_get(struct
> thermal_zone_device *tzdev,
>  				   int trip, enum thermal_trend *trend)  {
> -	struct mlxsw_thermal *thermal =3D tzdev->devdata;
> +	struct mlxsw_thermal_module *tz =3D tzdev->devdata;
> +	struct mlxsw_thermal *thermal =3D tz->parent;
>=20
>  	if (trip < 0 || trip >=3D MLXSW_THERMAL_NUM_TRIPS)
>  		return -EINVAL;
> @@ -537,22 +538,6 @@ mlxsw_thermal_module_trip_hyst_set(struct
> thermal_zone_device *tzdev, int trip,
>  	return 0;
>  }
>=20
> -static int mlxsw_thermal_module_trend_get(struct thermal_zone_device
> *tzdev,
> -					  int trip, enum thermal_trend
> *trend)
> -{
> -	struct mlxsw_thermal_module *tz =3D tzdev->devdata;
> -	struct mlxsw_thermal *thermal =3D tz->parent;
> -
> -	if (trip < 0 || trip >=3D MLXSW_THERMAL_NUM_TRIPS)
> -		return -EINVAL;
> -
> -	if (tzdev =3D=3D thermal->tz_highest_dev)
> -		return 1;
> -
> -	*trend =3D THERMAL_TREND_STABLE;
> -	return 0;
> -}
> -
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops =3D {
>  	.bind		=3D mlxsw_thermal_module_bind,
>  	.unbind		=3D mlxsw_thermal_module_unbind,
> @@ -562,7 +547,7 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_module_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_module_trip_temp_set,
>  	.get_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_get,
>  	.set_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_set,
> -	.get_trend	=3D mlxsw_thermal_module_trend_get,
> +	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device
> *tzdev, @@ -599,7 +584,7 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_gearbox_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_module_trip_temp_set,
>  	.get_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_get,
>  	.set_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_set,
> -	.get_trend	=3D mlxsw_thermal_module_trend_get,
> +	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_get_max_state(struct thermal_cooling_device
> *cdev,
> --
> 2.25.1

