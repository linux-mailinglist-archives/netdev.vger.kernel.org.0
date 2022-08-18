Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964C0598F75
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbiHRVZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346801AbiHRVYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:24:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8963BE9AAA
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660857423; x=1692393423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v9KL76vJPE5L+EybWD1EWrvjlpYdkeZCIs1Vk07STzw=;
  b=k72xrcE20O73Z/FVW9t0vB+5aKKzYlXk+ZCnBNpqVUFEK19CiBh9O/+x
   9/BtnzmoWWL6P656Q9RZW1gyldn2MtxqVVgpZOzRAZBWKw/0OtpOgqLkd
   AFe23k+J3oDYGoGAI6eificaK5hy54UzTXjwkK6zXkvxQD/UdTRiNNb7x
   RBfs4gzCiMCwveFCkMZxqWvXHO/QoapcLdbqpe0BsbsrxQDtI8BLmvGIS
   /ElJoPxdkezdNq9jbHnrfJsACz3UxLe2XT6AcQY0L9N9+IsaWcgmPkMGv
   HqeJcgkIfbEd/EBwMjjFFwRBCQAqIiqFxXkCR7Ve2mFmRd/+NXZP29s7E
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="291628751"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="291628751"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:16:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="611141436"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 18 Aug 2022 14:16:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:16:43 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:16:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 14:16:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 14:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bADriz+JizejNcggBeTuk5DPip1L5Cr8kBueRYzic9D92VTHMRKSZfyf4MMnKFz/VJQlh3sbckztMSmNsbKo8ikIeHwNbZwzVe+oL1ZdQLgoAyTndX9zDGIWNrhuAp3x+X4Yoaq6o7KC3X4dr19q+3HDfMU8MBmpH6T5N0zSHdhBKJDB5tFPa7t+cTSj8tD5Id+vfhu7YGsSgrZhiz8Oz2ErAggC5lOp4kCBNFdYzF/JG8AfVtCIt6cPmie8s/menkpNGXpoXeuBE3z9F/R27FWlaL1WCirG7ljojjGvWFMTcgYEkzmJVGBzuzegIifea41zU7DsVQKQl9FbTpSzCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJggE9mwreVVwUejuzs10YlkNI25esaQ+p+kFh8d3BM=;
 b=cmNsOoRZAPOM67ilHNsM/NooxhE0vgX8MOoElLvhPOX+VaAxlY71BdZud3QolQTdTMUSA4StAxdEcPgC/wYdPgRMy58acPZIRZnp4AzuMpXKg5CRarpTHjUZpnK8t4a8oswBL5kIGcT6YoyB98OM4bva6/HSzXsFAgFKfeGc4Akt4+MXStmVue2+ScnmLjvcVhrt3dHEfUaEsiybhrOC2Lp2LoRUW5f3VYv2g5/mhkmZAV12sd7Oz2d338LrCtq3MPo1OtuyqEwwawm4nFevZpg/fvw5FQEw7aFvoPk0oIwPYTwJli+0sN1kRcCO+VjhTSKgOjL+pSw5/5UQuteeng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL3PR11MB6507.namprd11.prod.outlook.com (2603:10b6:208:38e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 21:16:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 21:16:41 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next 0/4] net: devlink: sync flash and dev info
 commands
Thread-Topic: [patch net-next 0/4] net: devlink: sync flash and dev info
 commands
Thread-Index: AQHYswKh/b0QkIJ5yk61hjzRp2dkpa21KV+g
Date:   Thu, 18 Aug 2022 21:16:40 +0000
Message-ID: <CO1PR11MB50899BF793E9DFD7731E9D5FD66D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818130042.535762-1-jiri@resnulli.us>
In-Reply-To: <20220818130042.535762-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7744c46-5941-4986-0476-08da815ef1c6
x-ms-traffictypediagnostic: BL3PR11MB6507:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xajwOrcYrI28S9pGnr5XgkDtdPaoIsrp3MmkSc3XAme0jT1uiBABM212lrp0xhVflLMlEZJ3Sk86VGL8/I6Sq0GaCNIVfyFEmjmfqTCJYsV/8gW/j6vtYwxBY/xf9LyjSAx4y4PvWoTR91Kru+jWa6PNaq7thGu4Q47wBioCE5KJ7x3vyrinnvbDLzrJXwvJoWcv+isktoAHmb8sbYYxLeBtX1bZ16wHQrITTAINKhVT7RSI6sGvB417dbsymWmQH3q30sz3zrlU+IC8u9tOuxp/IYyNXcc4kttJNKlMMk7d7YzRde5uT3uCw8smQuj1iRGcKZadiZ7NEPoFYIfdr8EJAaOYkMjMPdTKff4p6PvXi17nj/CZdXNjid17oJEDMl4cRz6qOYv3lBa0JIeISYA4QgfrLgxrL6MpC53GFF2zYUEXAv5iY5SqOI2WU4U5Q8FsoE65MyccqqFJWcB0vhg6vnGFtTq5JWP9QgOqU09cloccUFL53gQwohcdA6XQ7IFW3AAwIOfGb3P6LhRE2JfPRv0/DkkuevERiDkLBLMrPFIZSVlaq1J/uvVM7u5vnVenIN4LjcEA6r/kbakK40UJynNgmFc5xMXyLwfSuc9PAYzvdjfw3ibbE2G27YIXJx1bJsDsb3qLcp+dnHSY9V0vff5Wr4gIapHo56IYQzqQL3yeHuDKUIbqckL6pQbj6nt/rdZeYR51hk7mPsiz2hIdZtOtnqwkvST10iasg5Gnyx7V4kcvl1nR/iv8XPe5gtLpp9y8W0K7T7V+CsDhHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(376002)(136003)(346002)(8936002)(82960400001)(38070700005)(83380400001)(316002)(5660300002)(33656002)(66446008)(122000001)(38100700002)(66476007)(76116006)(186003)(66946007)(8676002)(64756008)(66556008)(86362001)(52536014)(7696005)(26005)(4326008)(9686003)(2906002)(53546011)(110136005)(478600001)(55016003)(41300700001)(54906003)(71200400001)(6506007)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6QXqwP2U58NN8cCQESjvHyvD2wA4xClkgi8QfHtPmTcvVqqp23VLeVzBqG15?=
 =?us-ascii?Q?OSIbe0YYqKiYHhYundiMdhYcyyp+Tt7YQO92pyNfrl8lc3bJIUstYelY1e0h?=
 =?us-ascii?Q?KwE52IXaruuiFCSyU//p0HWUvVQ/qO7gaCsh7rPhxvUc1IXf/FANGEGXVvmw?=
 =?us-ascii?Q?ELAK0kv5FRo3O2oAUvoUj13N6nRa5Py+VAlgPzNWNFzVmYoq4865np4048xl?=
 =?us-ascii?Q?NlIhlr+2MrsXgyYpFsO5mahNqaZgc9FHJC4ZdcpP4Fw7rQ0E8z662b6Emiuo?=
 =?us-ascii?Q?svdUl3kh0cvuuiC7j6SqUy9WNxPP01p+4Dd5gKYp3CJNkU5kllWN/rLpBZRT?=
 =?us-ascii?Q?qIkH6XeSPRawKyRGAHOyeD+AzKOnN9yvTKZn2yoXOSBnIYkXZBG1VOyKu3bP?=
 =?us-ascii?Q?XknWr3CGkkAlLHWpwKo75MZNhYFueuUOSaKgC/pxNSyKhQzeIlVUwcsLvx/8?=
 =?us-ascii?Q?gSxku1EVXNB/nNYQ2b71NTdBfwCXgfkKU461bct+5ActvAwj6/R6A1RkZXWd?=
 =?us-ascii?Q?nZ3yyAOfDXAxAOoUNrlvoLyUcQGcrco7IR4BhZBuD3+Uc+0kv1jAy0OamU6j?=
 =?us-ascii?Q?vEtA9yJbjk8xl4hjAl482shrs4g+lxw4+uNtmk3T9hMkrh1664uOLKmN5NgU?=
 =?us-ascii?Q?tWIKqp6jBipNtZb41f458gwl5XIJQ271BzEOUas+MEpUKOc0a+tHhFVQFneP?=
 =?us-ascii?Q?Gra7sGoVjeZ2Z2CxRXoOS6ntiJj37/wTri12QXrNX0Xyfl5BlA9AuQocT32q?=
 =?us-ascii?Q?2tBLT2KSsZg2f4SyoqLtnZJgYv+Ajbk0Yva1wdnMW2yRqeYn/5nFs7bvAcLB?=
 =?us-ascii?Q?3fzflvhR/RxJZNAvdXWPXJ0etDnmPKhA4HJtlGzMQvnA+XU8/pU53QOwo196?=
 =?us-ascii?Q?PrXFv8cZkaR8jjU/sfIM3A4Imh5IxeW65CJsbTqPxiX+qG6l03euxy8klozL?=
 =?us-ascii?Q?mrPNWSfrjfcRhextd7L/5FyqliAtjeY4qCTGrJyoecAnyC4oWiFDlkSz3WQD?=
 =?us-ascii?Q?Y6HyfromQu+Gd8f2BtXtDMiab/N7GGAK0QkGZIO2vnPzV6XMZi/fy8Inf9Hj?=
 =?us-ascii?Q?/HpigH8mUSaRoNT5gz7QhqJb21ewnyDCv3AtYyb6wPjdcRqoFJ3e1yKGNwh1?=
 =?us-ascii?Q?W4PhBD66rMhymL2YchG6QfXbsFO8yfmE21wRlUJ9kckDWb6U4LfmnipNA5wv?=
 =?us-ascii?Q?14pUkJCxHYX36ojf8vNAz8TCrTNla76o/BR1B4ZYcSujIkwbCKqjU3pgNf8c?=
 =?us-ascii?Q?NxL3iRMvm+uN9qSvNVjbA9ej0lUTe9CZBGveoUHftxOmrbOKKZkDu4fqHs+m?=
 =?us-ascii?Q?bN1iE3lN8F/1IdJKCmbvYiyfYUrMb1eRfv8i28j3NXTfxIW2nU+LjyODQl1Y?=
 =?us-ascii?Q?jRi72eYLvaAiX5qfFsqEiT/GfedCK644b6KzmhEpVW5sKtcV9JRqla7pD0H2?=
 =?us-ascii?Q?A7ojehkLiV5PA7+6Q2uQFS1pHTLx3Fh4DvIMCKVclmEa53wqRckcmbOafS/T?=
 =?us-ascii?Q?efhbreqBjsARASpqIe2KhAqHvKXH+QMvjLTD/lI2t+X0qICeVJ8eHn/nxQjU?=
 =?us-ascii?Q?eETMURW4eK94n+OuIg88mHvFUl1JsJkK+usAb+Cz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7744c46-5941-4986-0476-08da815ef1c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 21:16:40.9229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npYA3mZ8h4V1l+epixqp59ERJDlcpFefGlJ8+9pUno8dlCg8gJetdmGJao8LuJjVY8MXr19TdWkhTS/qV1Q2ORZdgtG0We/oxBEWc2StVM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6507
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, August 18, 2022 6:01 AM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; idosch@nvidia.com;
> pabeni@redhat.com; edumazet@google.com; saeedm@nvidia.com; Keller, Jacob
> E <jacob.e.keller@intel.com>; vikas.gupta@broadcom.com;
> gospo@broadcom.com
> Subject: [patch net-next 0/4] net: devlink: sync flash and dev info comma=
nds
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Purpose of this patchset is to introduce consistency between two devlink
> commands:
>   devlink dev info
>     Shows versions of running default flash target and components.
>   devlink dev flash
>     Flashes default flash target or component name (if specified
>     on cmdline).
>=20
> Currently it is up to the driver what versions to expose and what flash
> update component names to accept. This is inconsistent. Thankfully, only
> netdevsim is currently using components, so it is a good time
> to sanitize this.
>=20
> This patchset makes sure, that devlink.c calls into driver for
> component flash update only in case the driver exposes the same version
> name.

Makes sense.

>=20
> Also there are two flags exposed to the use over netlink for versions:
>=20
> 1) if driver considers the version represents flashable component,
>    DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT is set.
>    This provides a list of component names for the user.
>=20
> 2) if driver considers the version represents default flash target (w/o
>    component name specified)
>    DEVLINK_ATTR_INFO_VERSION_IS_FLASH_UPDATE_DEFAULT is set.
>    This tells the user which version is going to be affected by flash
>    command when no component name is passed.
>=20

This is great. I've been meaning to get around to adding single component u=
pdate to the ice driver, so this would be a good time to do so along with i=
mplementing support for this.

> Example:
> $ devlink dev info
> netdevsim/netdevsim10:
>   driver netdevsim
>   versions:
>       running:
>         fw.mgmt 10.20.30
>         fw 11.22.33
>       flash_components:
>         fw.mgmt
>     flash_update_default fw
> $ devlink dev flash netdevsim/netdevsim10 file somefile.bin
> [fw.mgmt] Preparing to flash
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flash select
> [fw.mgmt] Flashing done
> $ devlink dev flash netdevsim/netdevsim10 file somefile.bin component fw.=
mgmt
> [fw.mgmt] Preparing to flash
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flash select
> [fw.mgmt] Flashing done
> $ devlink dev flash netdevsim/netdevsim10 file somefile.bin component dum=
my
> Error: selected component is not supported by this device.
>=20
> Jiri Pirko (4):
>   net: devlink: extend info_get() version put to indicate a flash
>     component
>   net: devlink: expose the info about version representing a component
>   netdevsim: expose version of default flash target
>   net: devlink: expose default flash update target
>=20
>  drivers/net/netdevsim/dev.c  |  17 +++-
>  include/net/devlink.h        |  18 ++++-
>  include/uapi/linux/devlink.h |   3 +
>  net/core/devlink.c           | 145 ++++++++++++++++++++++++++++++-----
>  4 files changed, 157 insertions(+), 26 deletions(-)
>=20
> --
> 2.37.1

