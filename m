Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F138A687761
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBBIaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBIaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:30:23 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3D42118
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:30:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOTFlLF/m9J3jOG3ogMU0fTwRmAhuWArNU8PiH4I83aUophfg9uLeJOeN5Wfu5E8lEzrVUzZjd84Ugf/iZ5jAumRA9a1S+NQOGL7dsCQrUAcgHt5UWAQ5P0i0RCCpXImgg58GVW5mwKaXHrYBg0lG9CAT3K2v2+F/+D1Hw4rEUhl1szyyKqGa1pgP9slPwYNglgI38ysi1gAafI0PRd7l6QSFR/3yxiAb+TDvXuUtKeIAK37SHfaRXlGRNLtb5EEsOfG2vifTfqSei3HV7cKNDbtKCXwZvYZAuI9FwpL+WNiFzS3ZhBBUzUmGsvqAmYjoqXv3bJHlr/pcENo67HwYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6gPAOVSrcdyJnSHU/7qvFR2L4QbJp/x8yXTDmGgumY=;
 b=h1PbWov9VnSc1YTDec+/D1WyJOHVWzKqSwAT6Q1yrZge2b0S329RWQyu/3QlQ8e0ZdG8bH6PYCKBuE3YsnpRyyrHE2vNIoGd1a7RqWfOS2aDjhK5d+Beh0ZSF+lMcpTUopH1S42fNrRpAi7vv//liPE9PiK8uL92mWFh0VjOB+eZTFnEquTlsjG48Vs677XSF7SUVAFG4R0RN6VunyqojgVPmJKJ2IRUhB/QdE3hvvYdC4f2q0OhnTLuWDrTN+lddzIKIswl3Mm8qvNhAFHlIhuZojg1Jcn9n26Sh25pFVOqPcYe1pFMLbHBAwHdcHTWsCWiFMgSJ3ijwuRXSLlXYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6gPAOVSrcdyJnSHU/7qvFR2L4QbJp/x8yXTDmGgumY=;
 b=1mk0ZCPM8gUuABmUFjWb+HTpQRKU/sbu0l5XVNZc0PZ+e2X6MJlRhVei0Hth0KDN7vv2YZRytUNFcyljPZP0ZfReVTEUUDhp/pnb8t8LgCoW/KvRL1drwrfye4SVsdkIOfLSli5bq8NusAIlOArjbIg4yUoT9oSl5on4Hvxsx+Q=
Received: from BYAPR12MB2853.namprd12.prod.outlook.com (2603:10b6:a03:13a::18)
 by SJ0PR12MB5501.namprd12.prod.outlook.com (2603:10b6:a03:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 08:30:17 +0000
Received: from BYAPR12MB2853.namprd12.prod.outlook.com
 ([fe80::8600:7da:3327:6976]) by BYAPR12MB2853.namprd12.prod.outlook.com
 ([fe80::8600:7da:3327:6976%6]) with mapi id 15.20.6043.021; Thu, 2 Feb 2023
 08:30:17 +0000
From:   "Somisetty, Pranavi" <pranavi.somisetty@amd.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: RE: [PATCH v2 ethtool 0/5] MAC Merge layer support
Thread-Topic: [PATCH v2 ethtool 0/5] MAC Merge layer support
Thread-Index: AQHZL/8rqZSrjcj6cU2y6kuHNByLOq67YRQw
Date:   Thu, 2 Feb 2023 08:30:17 +0000
Message-ID: <BYAPR12MB2853BE208DFD5D174E36529EF7D69@BYAPR12MB2853.namprd12.prod.outlook.com>
References: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB2853:EE_|SJ0PR12MB5501:EE_
x-ms-office365-filtering-correlation-id: ecf57f22-b361-436f-786f-08db04f7b706
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNtSm6lgHA+cYW+irIDsaNfTn0u1GAPxIvNSv6UUTSaNOiZzIqL/ZLl7WTNUSnzuiqBcN0lzWPbvlVtyKKXgiaBotDvV8/COLYj29NI2b8p6QfgwFy+mUhtc9m0JvNz+zDG1KX+yEqtQCb3cVI9AY2Gv4GaPyPSGMRyHTswa7GMo3eThjlF2yL7rVdEQCgWWGLNm9I3brafxXSedPUCJf/ChI57SVdhI1slqtOedcjCYjFJpzW8LR0hHT+0Nghx0q79wNOIVmaWWS4SYfJzys/aOSiXsolrpdu+v1xyqTEUmIGy7SD1+BRg9uNQMt2koFdzBGbPrZfuB5GGhXrDTb755BKxNjGlEf3wgnW5JZAYUyVVz9o6+fPsclkNhlESKERUfakqizULF8r5cLO0K+sM3cznXHC1Bq5kc/w6PC/0nCuYuBnmR4hO8QefTu0Tcppe5fHj3XsIMPx5kBOeAMoDYLInWdFQ6wpC0dgAxq/H9zGMakgXZx/pQkxHcKtYT0+sptlpEF4rgwxSim2Y6Ir+jVtkwN7fhBLD4+JdBEj5JpVkX8tIeMPmVqMLn4OZdoKt0XBorSujRqg3sUlitKnSC/Bv8StOdJ5SGBQ9FvBqkDMtD5nQF2O2xdQPn3UAbDzLSV8d+aHmW7YwqxLHSU/Pwm9CJyqt5vwt909N6OyztHt0B0QCVIJSzoXVBqN4+0Mw+aB00ggLCMQrnHG2VKO5Ir3ovcnjLpQJykdaS8AY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2853.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199018)(33656002)(38100700002)(122000001)(38070700005)(86362001)(8676002)(4326008)(76116006)(66946007)(66476007)(64756008)(66446008)(7696005)(66556008)(71200400001)(110136005)(54906003)(41300700001)(5660300002)(8936002)(52536014)(2906002)(478600001)(55016003)(316002)(53546011)(186003)(6506007)(9686003)(26005)(83380400001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uoFhoNRcOSD+oGApsZR0W1RmWG5Kdoe3P/LdumqmBA7d+CasxIEVcfy//lcJ?=
 =?us-ascii?Q?u9xJGZksgdVLXrTohZ/8fVluPL7z2yX/jvEczR6wo1TrRSk59BhzcEBB749o?=
 =?us-ascii?Q?qRhkKyZJvG2GChh69nV+4lVLGxx8TKGJfObZ4umKCc7rRfw/TkOV3jY+crxF?=
 =?us-ascii?Q?SzMgng5xo+e9xBliGTI3vjVv05C39JDCFansSgVdlDFTTAKlV3+IvgTOgTRO?=
 =?us-ascii?Q?bySzmrSyC+UyzswWSXEI5lPqcMvAmctx2pqGtKTKeCZl+og0Yni2pQ6Yspx9?=
 =?us-ascii?Q?7R3hBTnsqmcikGIy0ThgLL7RjeUDOsY4KleLiDsNKGCKOiIkskEkFls54FPR?=
 =?us-ascii?Q?7C1Mr6oTs7YZTONriJSe2YK4khgIzHNUhRSXXW5N104vfSyF9bC0gzaV+r1r?=
 =?us-ascii?Q?1orCc6M/qcN0xVnpWWJ+9i7uGB+emRz1C6x+Uh6VLsUWR+zX+5FV1MuE+o9t?=
 =?us-ascii?Q?fh7I3C+QJEvzoSshpsMi0yER3y01/9XPc8uJoNqjQDRAHOXS+VN4N+QzK1qC?=
 =?us-ascii?Q?o4KFe7KYCgg/gvgcw/h1AoKqd9C1mNPbAQ0eEKgn5tjC/u8QruYBuyTlupYl?=
 =?us-ascii?Q?YDvz1a5UJS+QaOy8q5BWQFQ2rw2ipWA6PRyoZIbhA9yDv1XmGrNiFLwoh84P?=
 =?us-ascii?Q?mMd3WG4Q81V+5f91Cf7xiqpr+4HMx2oVcZ7C6cT6xoRfhuodIYVzy7hZA/Xq?=
 =?us-ascii?Q?yF8xNr3izVyIf2/97k2gAjlazPT1+FcOivuiNKzqYMxcQSq34LGki6f8xzLi?=
 =?us-ascii?Q?iqBHeEgAhpF7eviNUhT+++Nwi5+qpESvSApOi7W8MRkTvTNXjAf0Es0t+P6l?=
 =?us-ascii?Q?qSevCOXeYL3JifaRly122BDvsYzBZB8tyTZcS5mdDxohb0ZGW1Lq2l22QO35?=
 =?us-ascii?Q?eXc2eu/xpmjisI1ZGbt1xaUr1s1YzPfF7Bpgs8Xy6dNv1ua98z4pb9Z1IW/n?=
 =?us-ascii?Q?1HHzaNOJVd4HGQ7k9K9xAsS/wo1659ExEXjeLhHel8I8dxq8V4enFE/0CF0U?=
 =?us-ascii?Q?K1hRyr7SAAfOAEQMp0/U2KoCocvum6NEPCPXrZc5pUrFw9LvYEOzH0XL4DFd?=
 =?us-ascii?Q?yNDx0Uzpo7Y+Bs991sReRDCcFohYSKZpI1A4jkhPto8A011VdSFJITT0LD2V?=
 =?us-ascii?Q?U5Kug4tRRSlKI/ZHNHGc3P9SYkVl/swHrdvFEmOb037tuWRmzh6b+9wgdxwa?=
 =?us-ascii?Q?j7uP2VihjZHQeO/M09XceaD9iNpDrLddg5llbUT/xx+IjxfYJ+THtthBL3RA?=
 =?us-ascii?Q?Dqu4vGKi9D3jYi3GfaRnkSdbdboQmNnALqVwvclCwnO3okbHpWaW6lcv38xZ?=
 =?us-ascii?Q?F2YXm+TqSukNsCP7fvu4NnBYk2XhLzMJtD0yq513EbsaFXSoJjHfS+aFk+83?=
 =?us-ascii?Q?5bdjrrHHamiBFTpBiX6spTdXUFOg6wucRyMzH/D1NsYRJxCs7w/7qEL5Xwef?=
 =?us-ascii?Q?pqtpkRGZ8+oCyAEYuhMvZzK8XpbCvlfh2O1c8NXWFwB0rV+tsreJ7KzinnC+?=
 =?us-ascii?Q?pz9qapp4lqmnehJOG/sRV+i6qudOYhbJn96Z7KQNsjesaJyHBSOOtnbm3DHT?=
 =?us-ascii?Q?OGz5J7oGKKd+rP8pNWc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2853.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf57f22-b361-436f-786f-08db04f7b706
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 08:30:17.6676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0tJx1ywE3yliH1fT7teaqCM03KoGI4FCa7u32ppiRglmBtcoK0Xi4Ufk4O6z9A5aQ8kF/snzW9gUNonhP3/LLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5501
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Tuesday, January 24, 2023 7:51 PM
> To: netdev@vger.kernel.org
> Cc: Michal Kubecek <mkubecek@suse.cz>; Jakub Kicinski <kuba@kernel.org>;
> Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Subject: [PATCH v2 ethtool 0/5] MAC Merge layer support
>=20
> Add support for the following 2 new commands:
>=20
> $ ethtool [ --include-statistics ] --show-mm <eth> $ ethtool --set-mm <et=
h> [
> ... ]
>=20
> as well as for:
>=20
> $ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggrega=
te
> $ ethtool --include-statistics --show-pause <eth> --src pmac|emac|aggrega=
te
> $ ethtool -S <eth> --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac
>=20
> and some modest amount of documentation (the bulk of it is already
> distributed with the kernel's ethtool netlink rst).
>=20
> This patch set applies on top of the PLCA UAPI update:
> https://patchwork.kernel.org/project/netdevbpf/cover/cover.1673458497.git=
.
> piergiorgio.beruto@gmail.com/
>=20
> Vladimir Oltean (5):
>   uapi: add kernel headers for MAC merge layer
>   netlink: add support for MAC Merge layer
>   netlink: pass the source of statistics for pause stats
>   netlink: pass the source of statistics for port stats
>   ethtool.8: update documentation with MAC Merge related bits
>=20
>  Makefile.am                  |   2 +-
>  ethtool.8.in                 |  99 +++++++++++++
>  ethtool.c                    |  16 +++
>  netlink/desc-ethtool.c       |  29 ++++
>  netlink/extapi.h             |   4 +
>  netlink/mm.c                 | 270 +++++++++++++++++++++++++++++++++++
>  netlink/parser.c             |   6 +-
>  netlink/parser.h             |   4 +
>  netlink/pause.c              |  33 ++++-
>  netlink/stats.c              |  14 ++
>  uapi/linux/ethtool.h         |  43 ++++++
>  uapi/linux/ethtool_netlink.h |  50 +++++++
>  12 files changed, 561 insertions(+), 9 deletions(-)  create mode 100644
> netlink/mm.c
>=20
> --
> 2.34.1

Reviewed-for-series: Pranavi Somisetty <pranavi.somisetty@amd.com>

Regards
Pranavi
