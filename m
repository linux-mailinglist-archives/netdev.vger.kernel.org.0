Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65F8589B98
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 14:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbiHDMVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 08:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239723AbiHDMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 08:21:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92C2606BF;
        Thu,  4 Aug 2022 05:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ldhbgg+h8rzyDJztW8L5dk6ViLv6BRW/dXYp/PmA39spEonAHMaqD6cijzBu2RNfkDf77U/Zv4agGt5hfRBkkBzNo/Kbls6N7EsuMSqAlp0eTbVovB2zG3xlPllsOGyvQ9jBN5ydR4erLje1UM8uW8TFIdLtI5iYTTqTkDKzdqngdUt+OqVyUw5pBdzMw0hPb+UPZB38WwGVAcpvCvNM/J5F6xwBgFHjJrOJQT99IHYwKzDDbnYx7lFjrshvmmduPq85r8WKp/ne4oGPNiaieag3ySl6wv/+dEXU1zHoqmZO+0ucnRnOlR3Uoy70j0imWkXtczbTB/W24d/0g81zEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KR5keyrlUHc8Z5uu28MxaKj1dui893CqydbTH40F7is=;
 b=GXQAUrIOG67aBtt1z02CF42+sSyjbhI96GUROjK8cetao3vEN4hnMQrJd+A4hJxMUbFnuNcaUIFm2is6Y4VQ757uWKwQjcl4DzngSLfxFSVyPcpxK+iaJIi9OKJFfGB0dcmXwLb4ZksCHMbH8525FyXWmogdwd3ACsUbTKMtfDrHSsC0OnsCONygDB/YBXxf2F3+skf5FbynPG11nvHobwyYxEYbPcURfiNF8yKgqb2VALZ+e9YG0d6dFbHL9XdOoE4v+0vuMHGiDUNDIRU7U8Op9N6yHkiVw5JqtH4UsVq7SjX1+Pf4+GV4H3jXDxoy/uh3r49SwQazXlPDi/9khQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR5keyrlUHc8Z5uu28MxaKj1dui893CqydbTH40F7is=;
 b=NFCTTaQgibL4m1vnuxykTrBqRHEEquEYwWikvj5O9Sw0TXahsnIxsW9V207lqJTkErcqV1hYXHuc+JnRPbeMKN4v/aB7/2OOkSAkqwQeYXsD2qMgrIDZinjlG6YDicn16Tp+1xrFcWYJx4SA28wXLt1SiVZ3o0+auYtO9235YtTDr7dBCPl/yzDNMFn7lpdluPopVTA+W8A2+LMIMfHZ6pmENXQDAXH2dtqbMwSXK6JPFh8I8ubt/7k7gKmXKs4nuH30/yC8zM6WEy1Cj7cqJq1wcjhR8ejjbcfbEI52Mf77S440c4XX8YfMwRNiU58SKxF2UAybttZa1L1j4HXzug==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by BN6PR12MB1539.namprd12.prod.outlook.com (2603:10b6:405:6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 12:21:04 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::bc33:c992:d654:2670]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::bc33:c992:d654:2670%5]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 12:21:04 +0000
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
Subject: RE: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Thread-Topic: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Thread-Index: AQHYpYz96Gih+04o9kejOPb3QatIDq2erIYg
Date:   Thu, 4 Aug 2022 12:21:04 +0000
Message-ID: <BN9PR12MB538167CB6E0EE463ED25898CAF9F9@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
 <20220801095622.949079-2-daniel.lezcano@linaro.org>
In-Reply-To: <20220801095622.949079-2-daniel.lezcano@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bae5a1f6-f4d2-4191-fe71-08da7613ccee
x-ms-traffictypediagnostic: BN6PR12MB1539:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6p3ZNLdi5KnKlr8kXt7yIhu7fghubFgoY5CFF7U8QSn2Qs75wRO98u0NkbRTaPGID1YPUlI/Z6B7QDoDmCZ8LlSVdi/6L1a/X/2lrnhXfp4HX0zdLZQh7gU893CsF1GZ4k1cxe6BBmrzLjmIfvqImLxGi3WiAX75hlFsl7DOIWNrMubnH3SKqrrwcpxNYzYGsMpYBEk55JCdf1+ptekcpWqPAHzdWyAETjTQJLP4iH6agdVPLWFtryUgUjyPTZRVVzxh2xnfrBnz9HBryq5WP1DHZTH2QCW2BDmiYQrq7S5Mx45ESdD6GytGcOS59cCRcf3RiHEKfX03hWow6S6wdE9DpkD5GoRlDDifbNsuvAtBw5t7tF4+LKa5sOzkgW9iwjkZiTmN/gKwV77GqBRznnw4VFgpwp2mJCI+oXm2Ia87uEB+AWjFE4sR50jMHHgbQpomHCchp7EE/XvoEsyHG0fuUypGHSNraLkEZDolLPR5PmMRZ4hPjl0IXha9dciPRDg678QEUZhR6A1dMijtZ0/lZiVNfB/zHSImGLaSVrnqO8jwcB5SVkWFaCGG0cqmeURWyh7AtnzPPx9qzw5GtUgc/DMLTWsc6GS8QrMIJSGBRjXM7ij6Af3uq6/J4U+nytlHjgOQD0HGeS/S8a0RiF/r6IyAIO9/zZ/fHzcudX39OfKqImH5kL1C6hRcbsS/wSUKZq5LQsi4nCq+w+YgHbTFfiofz7XyxX5VUIKV0HzJrH/OGdOjfnzJQyr5ZHByIJfQznoedTSKl9olskIghRxt9iNtQr7jNP5k2T0JzRgGegPRFitfjTBsPIRSMOgjjbe3l/hvUqvQoYGSX3EzmRrswcuCEciGaOJ95t9wUKWJnvXY10o2Q5dUDuA1Itb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(55016003)(316002)(110136005)(66556008)(66446008)(66946007)(66476007)(52536014)(8676002)(76116006)(64756008)(4326008)(71200400001)(478600001)(966005)(8936002)(83380400001)(86362001)(54906003)(38100700002)(186003)(2906002)(5660300002)(41300700001)(33656002)(38070700005)(26005)(9686003)(53546011)(6506007)(122000001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qiNFfPPObAzTWbhuvv/1MEAj3p5Qv+VQLQG0wkfZMi8MN6iG/4xw8aLdjUuj?=
 =?us-ascii?Q?Q12ArXW2sKAkLRQPUshuxckX7wkapza7TQ5yCVe58ZMEOudOxBbYDgRgE/rR?=
 =?us-ascii?Q?O0DkXRBPtQ2lpVduvwuM8URviuFhLUbnT7K4B24qQw2FCQ66q11PvlR9LzRP?=
 =?us-ascii?Q?vr1hFHfMxPpi3sZVO3Hda12fQI7P3VcZ//BVMvkok7TAYBwe82yQOln3b+5p?=
 =?us-ascii?Q?JEHuPibOV5Z/tls9L74mryuX/8I1B8Afu5AukBx11vw6T/9Xl6E61SrWGbs/?=
 =?us-ascii?Q?GU1EG15pT0XO44Q3ZeZpJugSzI7XmEjeRnQ6jJsF4IrCi3vLEzBcF5Kb6Dkt?=
 =?us-ascii?Q?Mz+Q6uxGxtTevR53tn0a9VXnHYhY9eC4vdrRQYOLxnJWKktiM4+Gj9wqIdWw?=
 =?us-ascii?Q?vLCflb9pKGWb6/lZNGdz8vAsfPlJM89Uy01Y78XbqoIJ61u+Y95pg+qB0Qxh?=
 =?us-ascii?Q?RvjenXjgMhlIZtMO6SCAaxCojlfdxr+qP5V4IS0UeSSDStZ/2V6j9KW/GDuG?=
 =?us-ascii?Q?cxfVIbfCKVyW8dFs67BIhpmNkpjzCvsBFaMMDEgaYC0ICej+pIBMMW80vgPZ?=
 =?us-ascii?Q?MYCSTc33+CGvSVdfuIUJvR3uc3maVK+9JQ62bn48gMgA/XhxtiD7TGRsHkXk?=
 =?us-ascii?Q?Epf4rJHxeokkkJf1ac4ljXmaSFf1QWOxQfRwYRwJWlhvDo+xJ8V3qzukucb4?=
 =?us-ascii?Q?9PGJoWdmBFljlRH/h408BtLG/XrMFUifveZiKYA2q5pZO9TXk/s8nR2rQlU4?=
 =?us-ascii?Q?v51ZTQsOsoBspGwda1yeROGdQec/isabQC7ntMh+yOf+KHe/uTPEvVILJaPK?=
 =?us-ascii?Q?MbWtsG0Azccv5nahD9TyXaep4ulq3IGjkSFzondXCYl28ERD8vWe4FJi5jYD?=
 =?us-ascii?Q?jiLmnkJfa/y7U562Qw3GwYwTWdMfIaC8L52LQsLehk8LqJNx8yTMixbBfy38?=
 =?us-ascii?Q?pbx8/wKMAnOgMSys2BwzJ46N0S5p/Cw7HurXBCtlzZTk5sVjJER5JxQwVEL8?=
 =?us-ascii?Q?OWh6DQvS/WBWO4jzQ/H1YZL7wi4D2g9cqlNeASVwluIqjXk+Wwt63xMjzjz7?=
 =?us-ascii?Q?roeQkl3RlIkVmzyvSVcXdvi/W8nZKRgrVec/h4spcpMf5uMn4Oy/xrqLsagC?=
 =?us-ascii?Q?+f09B+wOBuhbUAzreBsvBKoPnFRgL8W2V+r7w+OJIVddZ2wOnc98LtUtVL6d?=
 =?us-ascii?Q?MMGBANP/l56G/MMGQ0wlxS+ySwEpUqDVTkUXNc1D+jglvi/NFjpeHIi4pNxq?=
 =?us-ascii?Q?mhHdTska6re3VCgsVtr2u38czEJ0HyJryN+2Vn1+Ei6hLs9VRTVgUIaxGrAI?=
 =?us-ascii?Q?33M45k1TuNEDGLubuoGVsf18JWi9aT0jg02OAOLIjMjhCfaIAVEGi7Y/O9aH?=
 =?us-ascii?Q?uucAqhFi8WTzCr/v0qgASUC4iqzaRWF3GlOOtfIQvTrJjFLeGV9mGZMnKU+l?=
 =?us-ascii?Q?epDVKldJveGsGlRta3TGDMuAxBF0KUwoNCqSdV6tfS/yqLIq8B0FkaS2VyrT?=
 =?us-ascii?Q?bwdB7skS9OxcNmga+qRwaMtpKbUxip3Pw+ieXr7JHtMbf4v3UDcICEF4xxRL?=
 =?us-ascii?Q?r6plp4S7NJGC7CCwX7vvSsAoxMX/OFS0nRMjPOwo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae5a1f6-f4d2-4191-fe71-08da7613ccee
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 12:21:04.0392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ojT1OgiR+FqdVpDJBwCQA0FGXn5IpStSePgHkDD1bMnunp0wmqdF2uJBkbDK5OJ3ydcNbrMZBY+bonZV8sPP2g==
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
> Subject: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
> detection"
>=20
> This reverts commit 6f73862fabd93213de157d9cc6ef76084311c628.
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
> The revert conflicts with the following changes:
>  - 7f4957be0d5b8: thermal: Use mode helpers in drivers
>  - 6a79507cfe94c: mlxsw: core: Extend thermal module with per QSFP module
> thermal zones
>=20
> These conflicts were fixed and the resulting changes are in this patch.
>=20
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>

Daniel,
Could you, please, re-base the patch on top of net-next as Jakub mentioned?
Or do you want me to do it?

There is also redundant blank line in this patch:
							&mlxsw_thermal_module_ops,
+
 							&mlxsw_thermal_params,

> ---
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 59 +------------------
>  1 file changed, 2 insertions(+), 57 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index f5751242653b..373a77c3da02 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -22,7 +22,6 @@
>  #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
>  #define MLXSW_THERMAL_MODULE_TEMP_SHIFT
> 	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
>  #define MLXSW_THERMAL_ZONE_MAX_NAME	16
> -#define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
>  #define MLXSW_THERMAL_MAX_STATE	10
>  #define MLXSW_THERMAL_MIN_STATE	2
>  #define MLXSW_THERMAL_MAX_DUTY	255
> @@ -96,8 +95,6 @@ struct mlxsw_thermal {
>  	u8 tz_module_num;
>  	struct mlxsw_thermal_module *tz_gearbox_arr;
>  	u8 tz_gearbox_num;
> -	unsigned int tz_highest_score;
> -	struct thermal_zone_device *tz_highest_dev;
>  };
>=20
>  static inline u8 mlxsw_state_to_duty(int state) @@ -186,34 +183,6 @@
> mlxsw_thermal_module_trips_update(struct device *dev, struct
> mlxsw_core *core,
>  	return 0;
>  }
>=20
> -static void mlxsw_thermal_tz_score_update(struct mlxsw_thermal
> *thermal,
> -					  struct thermal_zone_device *tzdev,
> -					  struct mlxsw_thermal_trip *trips,
> -					  int temp)
> -{
> -	struct mlxsw_thermal_trip *trip =3D trips;
> -	unsigned int score, delta, i, shift =3D 1;
> -
> -	/* Calculate thermal zone score, if temperature is above the hot
> -	 * threshold score is set to MLXSW_THERMAL_TEMP_SCORE_MAX.
> -	 */
> -	score =3D MLXSW_THERMAL_TEMP_SCORE_MAX;
> -	for (i =3D MLXSW_THERMAL_TEMP_TRIP_NORM; i <
> MLXSW_THERMAL_NUM_TRIPS;
> -	     i++, trip++) {
> -		if (temp < trip->temp) {
> -			delta =3D DIV_ROUND_CLOSEST(temp, trip->temp -
> temp);
> -			score =3D delta * shift;
> -			break;
> -		}
> -		shift *=3D 256;
> -	}
> -
> -	if (score > thermal->tz_highest_score) {
> -		thermal->tz_highest_score =3D score;
> -		thermal->tz_highest_dev =3D tzdev;
> -	}
> -}
> -
>  static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
>  			      struct thermal_cooling_device *cdev)  { @@ -
> 278,10 +247,8 @@ static int mlxsw_thermal_get_temp(struct
> thermal_zone_device *tzdev,
>  		dev_err(dev, "Failed to query temp sensor\n");
>  		return err;
>  	}
> +
>  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL,
> NULL);
> -	if (temp > 0)
> -		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal-
> >trips,
> -					      temp);
>=20
>  	*p_temp =3D temp;
>  	return 0;
> @@ -342,22 +309,6 @@ static int mlxsw_thermal_set_trip_hyst(struct
> thermal_zone_device *tzdev,
>  	return 0;
>  }
>=20
> -static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
> -				   int trip, enum thermal_trend *trend)
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
>  static struct thermal_zone_params mlxsw_thermal_params =3D {
>  	.no_hwmon =3D true,
>  };
> @@ -371,7 +322,6 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_set_trip_temp,
>  	.get_trip_hyst	=3D mlxsw_thermal_get_trip_hyst,
>  	.set_trip_hyst	=3D mlxsw_thermal_set_trip_hyst,
> -	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
> @@ -473,8 +423,6 @@ static int mlxsw_thermal_module_temp_get(struct
> thermal_zone_device *tzdev,
>  	/* Update trip points. */
>  	err =3D mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
>  						crit_temp, emerg_temp);
> -	if (!err && temp > 0)
> -		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips,
> temp);
>=20
>  	return 0;
>  }
> @@ -547,7 +495,6 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_module_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_module_trip_temp_set,
>  	.get_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_get,
>  	.set_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_set,
> -	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device
> *tzdev, @@ -568,8 +515,6 @@ static int
> mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  		return err;
>=20
>  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL,
> NULL);
> -	if (temp > 0)
> -		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips,
> temp);
>=20
>  	*p_temp =3D temp;
>  	return 0;
> @@ -584,7 +529,6 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_gearbox_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_module_trip_temp_set,
>  	.get_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_get,
>  	.set_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_set,
> -	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_get_max_state(struct thermal_cooling_device
> *cdev, @@ -667,6 +611,7 @@ mlxsw_thermal_module_tz_init(struct
> mlxsw_thermal_module *module_tz)
>=20
> 	MLXSW_THERMAL_TRIP_MASK,
>  							module_tz,
>=20
> 	&mlxsw_thermal_module_ops,
> +
>=20
> 	&mlxsw_thermal_params,
>  							0,
>  							module_tz->parent-
> >polling_delay);
> --
> 2.25.1

