Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D2C618C66
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 00:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiKCXDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 19:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKCXDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 19:03:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2071.outbound.protection.outlook.com [40.107.20.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2481F2D5
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 16:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkxEc4EpUBn2XqDYFuIMNeH3EDDrKpvJRTv1c/zEwK7lqr7Pe+BtVUwtzyNRnSNJs3vssJZOMPSVbkItdQGwzIjtB8q/Bb2S0APnLFxk268CDEI4a6yioT5t+D/O62IEzs/D8OA/IVqxj7ilnPf4DDW/mRuz7g96QiyfMfvKo101V61ki0/7yHMdgWCfE8YM20ttVyao905mQ1W6DFy+BsXNRn/34Sv18rbPmL8iEoX1/APfKBzt/5/JRdBoGSEB8u1J65cygWtUcgBQU8oYkkXR0NKO/i0pRTK4EGOQ6+NT7uKNERlkiyjviY8w27gBtt01H5rYxufIznJXQTGWjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FiFlm4/ax/AjGG41OkLLpQOSP9+c75dloMOVtHN7xw=;
 b=aZhhT9oihyUT4TOvmmcGqdoGQDa+sjAY/PXy2vFjt/bGMoYf89yxhhnvt+EDbZaWRgVtnogtPiPjqsQcfGWBGNVRqOXM+A371+wwVoiFXdFFiQDfKP5ypDDgwG5TI9dYcnFSfzrvH+/olecWyQYMg1afHqlafRMjW+loethstozyqhyjDNRVKZB0yQin5WxBBoILNx1tLcfX09gYqCWzuTkfdoBq6685zQxZ+tOVrh98ji6cLQ122t+aUGv96M8r0UsQW23Ag2GNKl6K7SppjQDNkEvpl06TN4YaediT95vJtOHsVeA3nlpF59wWOUl4q28Pcd6rnA3Wi8c+FNSTIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FiFlm4/ax/AjGG41OkLLpQOSP9+c75dloMOVtHN7xw=;
 b=Fx1H7PV+Mn/Ga47KMTTsfD4c7qo26nSyUVZ7gfA47lwGsj4rcnytfPVA/50x/EJzVu4YMs3jzC9dI1oEAXPF3i5CZpo6sz5UdjEjYg2MXpL0sR6/HOHRw1S4Smc1MrFMc+JsYo6t9URStNEhHDYRDc0DIq9ocOxutQL7lECDOos=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8755.eurprd04.prod.outlook.com (2603:10a6:20b:42e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Thu, 3 Nov
 2022 23:03:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Thu, 3 Nov 2022
 23:03:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add support
 for locked FDB notifications
Thread-Topic: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add
 support for locked FDB notifications
Thread-Index: AQHY6FjUVuDB5/kMGkqgz4g+zKbN+K4moPuAgAGU3ACABaGZgIAABl+AgAACaQA=
Date:   Thu, 3 Nov 2022 23:03:17 +0000
Message-ID: <20221103230316.k5gocnfkdslkdimq@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221027233939.x5jtqwiic2kmwonk@skbuf> <Y140a2DqcCaT/5uL@shredder>
 <20221031083210.fxitourrquc4bo6p@skbuf>
 <20221103223151.cnmlvgnz3maj75iv@skbuf> <Y2RGr9ssyMXbNsC+@shredder>
In-Reply-To: <Y2RGr9ssyMXbNsC+@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8755:EE_
x-ms-office365-filtering-correlation-id: ce4e20c0-8b4e-46c6-d3da-08dabdef9811
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fDuo40sfZVMg+Uopbowv4AO5oOk71JiKgQu7LBUC2q4T0iZcIyDTWHB79Nv47yZITWboX26Z28rPfkS3hRC0Ly/auu7Wcf1fVe2rCgJN+/KTc7DQycrOq5m13tQp4yF2y9h3wZgmkmQJQ5Wrp0xfDzbtchxVDuq18URvt30q/oUZH/r1T+gALRNKMmPTg7eIq2mJhzDRtQVu4Ng+wqfes364Tfy3klx3dvRnQklT9Bdzd/vKwaw1+vmxrrbRlfy2wF28V2amoaVQNENPpKOc19LQtQW1OBdXwXE6bdEdK0qQEv/cj2fW0q1AJCYFI75P5oU1r2Ia/qwkVMInCd1IKTYwy+6DghzCBIe44mJCvAg2gOiknX3iQJf6yMJZ8bKc14GBahm6c8WIch67Ii+ljxcWVQmFXVob04zGjOiHonK08q3spOIWnWCyKgYfUPwXUxX7SASDO8k5pKjeQ4TW+0WJ6j/+wgDzaA+F2/QVnd+VKtlUnjyVCcHDffaD+Eo7VgQBUjCVebYFWo6zru2brhsMVgFTBYTZbv2cAs53jTsHqzGtCC+ixYp2f+ZiPgTlxHqLiqHIpoRv3K6LKxYAOcQbUuKVIpGix+ZNVgb4cPNQDUTiZrhfcFd55xOEMq/1bLE7gMzXuKf8fnDXbn/Yg0VXIkmI//GQA6mrkdcALYPXHB1nRfeSGtOCZG/dM3GuhzF92bPuOaUEHCbQ4RrQev6VUo5uw0U2DXo9cQknVBtSggdRV2xEz+YbLKRz7uO1b1r+8FLgu+WUZ4dtOts/aQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(71200400001)(6486002)(478600001)(8676002)(6506007)(316002)(66556008)(54906003)(91956017)(4326008)(76116006)(66946007)(66476007)(66446008)(6916009)(6512007)(2906002)(7416002)(5660300002)(38070700005)(38100700002)(186003)(41300700001)(26005)(8936002)(9686003)(83380400001)(44832011)(122000001)(33716001)(1076003)(64756008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zHlC6axX4OfU+vyr22yLWyKh95X6p1YyT9nk7LM85yP2ibtzjgZPFV5lIzDj?=
 =?us-ascii?Q?xsTKPYhsA3T1aPA+Uk00+wkFP0M6qoz1cz8RBqy2cQtgh6wHyhs6mUjjonnV?=
 =?us-ascii?Q?6aote972Ahz8Sbl37dzuWiB4JEeWwU16KaBZcGTKecMVZXH3Gf7akP2DFIou?=
 =?us-ascii?Q?lpxs6PW/F5N4RZlcyMHL3qK8zRZTR1GU1xiGuMD1OYzutet4YfYMPXSJ5PFd?=
 =?us-ascii?Q?6oJfU3SERtdQfinUhOXGEFfVtB69o78OPaExL+rrS3sOS4acOqGSyundPT0h?=
 =?us-ascii?Q?IrZQJajCnsq4CnI+2Xj8GVVVCKelCP9FejC1fL8nJEwTC2hAS5XPIts/I3J3?=
 =?us-ascii?Q?kd6mmTAjhVqVvLWygwA+qbV/D3LiQPtzG4lmfmaAFGVdUSjypOKwCoCbrH8P?=
 =?us-ascii?Q?Vja/Bzm/oER1Lt/5BhUZNUGeJffO5QNFwsB83ZUJpru78g3NE6MeDitKnAHp?=
 =?us-ascii?Q?OHYRT7t/JvRcnxrmfT0VCZtnyHofL9xHHozMQTgvgfI+OXXXTQIon8A0iJpr?=
 =?us-ascii?Q?3n9dhclnkoIphJseEi001FOVs+9CTqUX4LaBhh7zd7AX1h5Pq3AT0n0tqJnP?=
 =?us-ascii?Q?g+fc2ysUqtpJZtrx+n3y+Rfq1mZbhLrG8TF79A58NiycMUrNzpW8wrhzqlLW?=
 =?us-ascii?Q?Qaet8GkZo/8zVOCOXuu9oFuZvyRXuRPH1DTHOGf5Um2oa4IzTIvOvUbHTvv3?=
 =?us-ascii?Q?+eOL1/OirMnGn+hS5mSKoPWslde7Ayt1YSUPuFy+7Hge4qy0QYy8FIP93rpS?=
 =?us-ascii?Q?BzTAJqgI3dClywNhazdE4sdf6f2gw1PYph8b/E/MH0kjpvup6NZ01NQh0K4b?=
 =?us-ascii?Q?8J00lbFfMxgsQxHvVLrp1QbV0m9OFsmqYu9byxAL/FR2lHyQXRxQi6zu98iP?=
 =?us-ascii?Q?kU4myPLs8+S097A7lfMrRIZbxNa+PMNc2XxButO94KUSOandCv50YMl8noVD?=
 =?us-ascii?Q?+IQDyUjSagHtPbgOjWZTyUgp4EjyvSyN79JMY7ENWmR8aXr+hgOvbzcpDlry?=
 =?us-ascii?Q?GOzCp2Nz5YHLr4k8uRau18dLX6QFLmGW79ArmJCtSi6sVgbqQlnbnFKF3Lph?=
 =?us-ascii?Q?r9hwsl8QhWkF16u6+4zxAD4sut/rpYiuS2WBY3heR8EtJwCClgmVut0jy5vY?=
 =?us-ascii?Q?Lcs0sYvA3GCkPt5aqJCC381+b8ygWhImWMUcCHCuiYb8BbXIdiRGGM8OBWge?=
 =?us-ascii?Q?aky5GK6SF44Kj9Mt4a/ekzbsKgMQ0sWnO/Q/ak9tqPQLgjFvtstmZn6QNzez?=
 =?us-ascii?Q?0C0UrV04KKqZOY6UQO1OXNILZFltubxEzWRXEQ280sRYiep5cmXTpGpSDcs9?=
 =?us-ascii?Q?JI7dNAYziL37arkauhG0yLiL+n6gdwR0vHCHNEfNv8JPLbvLRMgc146YAYvR?=
 =?us-ascii?Q?TkSnQiG1I1GrJ5MzGiYTOs39JwdMeWbnp2LnUbxPiLb6dn+J7vk1JsK5p2km?=
 =?us-ascii?Q?K5gFL+zfTlC58uKtgkyHZkTIEojz1nSuKTZ7f+r1RNP7/8nRlZvKTNennMXp?=
 =?us-ascii?Q?jRs5B/dX9phKpCQuGnO/2WCFqsQGyLquf7FcLRxzW27Cjqnjap4kpFLY6s7f?=
 =?us-ascii?Q?L+RK6kolqAG4HPHxbDSd/4eNCnfnuw6BQ1TL1a2wV+UDq6Hv6Lq+nRA7a+c7?=
 =?us-ascii?Q?qg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9BD4B9FFE76B464FA4ED73933BF374E0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4e20c0-8b4e-46c6-d3da-08dabdef9811
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 23:03:17.1860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QB6be0xPh0i31xjz7owv3arDF8oS92gHIgOemwWbuFkkX7/C0rJUP1AylUmWl5q8RTNsRYLAGyMugJQGqPY0AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8755
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 12:54:39AM +0200, Ido Schimmel wrote:
> Sorry, forgot to reply... I added a patch (see below) to the offload
> set. If the bridge patches are accepted and we have disagreements on the
> offload part I can always split out this patch and send it separately so
> that mv88e6xxx rejects MAB in 6.2.
>
> commit ebdd7363f8c1802af63c35f74d6922b727617a7d
> Author: Ido Schimmel <idosch@nvidia.com>
> Date:   Mon Oct 31 19:36:36 2022 +0200
>
>     bridge: switchdev: Reflect MAB bridge port flag to device drivers
>
>     Reflect the 'BR_PORT_MAB' flag to device drivers so that:
>
>     * Drivers that support MAB could act upon the flag being toggled.
>     * Drivers that do not support MAB will prevent MAB from being enabled=
.
>
>     Signed-off-by: Ido Schimmel <idosch@nvidia.com>
>
> Notes:
>     v1:
>     * New patch.
>
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 8a0abe35137d..7eb6fd5bb917 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -71,7 +71,7 @@ bool nbp_switchdev_allowed_egress(const struct net_brid=
ge_port *p,
>  }
>
>  /* Flags that can be offloaded to hardware */
> -#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> +#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_PORT_MAB |=
 \
>                                   BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PO=
RT_LOCKED | \
>                                   BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULT=
ICAST_TO_UNICAST)

Yeah, ok, normally the feature would be gated until it really works on
existing offloading drivers, but I suppose a compromise from 100%
correctness could be made if you say you're going to send the offload
bits right away.=
