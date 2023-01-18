Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158B4672653
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjARSIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjARSIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:08:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD510A99;
        Wed, 18 Jan 2023 10:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674065285; x=1705601285;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+2e0MyGhAyHtTLaqDb68zKg8COv5OPUj8KkHK1bIMyc=;
  b=L2KCWYVLt6hRHK2MYW8d9lX+R85uwKaKFgIoGAh8wdOl8+lLiW/7y5U9
   8bnXSojCQXqiOJOldVdgE+nE3M25v2A0jYh1izmZT0hPFaRNbNnpRVzCp
   eqvMJ9PZiM+c6a2FNVg8SEGpmlJa4gutpkTSAwlmoWmU4Au2tAKWvxQTW
   AZu+P2prUf+i5MXpU0vIybw/drYaw2bYKPcFLn8olfSQOPrR+KR3DgMw1
   hrzDQaUMfZg+GT904tV9A097rIuEnOKTrhZQ057IePBLoOG65r0cnNniw
   xAC8sRqNl5fCjl00JHxZwO1elaXYyYE43d8QU6A87A493zgP47jkCSmPO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="312933198"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="312933198"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 10:07:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="723194267"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="723194267"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 10:07:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 10:07:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 10:07:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 10:07:56 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 10:07:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nbgv8nkce53UEg+fsmS6Bk/0WzEcYKSIxZk7sdN+romt/ZUBfDyo8UuTwa/8Ofl1AGL8pucf4OuECvD1Sxh68uZurVq7It2AlLhyYkXKUT8f6mZGyJ/jP0hi89Omkj9e+lWE5GbE1liyt0c78rEEY5sHEiumZ5KnGoPvZsNA5CyMnBoMmFGxUmt5Wd4hivW5YWSpDYGfDhLwB1efvL5roEn3se5Jhx3zBF6k3zObOlUiawaK/dG2UChu6DJ6Mtk17KAPoRLYN9n4pPmcCkvABEtourkKdac/XJA9biwohsMwBVy+XnVp5xooQMMFm3btEn8REqsdksmxH93hKinNGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcqhfKncMZ8u+OWYkDHKRmVXK/QTca5yZDmWqoFF8xE=;
 b=GCmyHBDfvNF4CZ14UgLVONFztzTLGmUGuU3BMz4vAprzeaDfw4gWaPT06VF62lpTewzb+fYisU+TiPrGKACL/LBKF7zP36cwrfV9vKHufGZxcxkYH95GDdrz3zdd80U85jN+QEZTIh59esW4NDj3b4bKhzgZ9PCTL+P10CbGV6fB2YcDrsVx9wC22FgR9qABGeFJzwdEf3PZtWOBgREbIT6B4w8COo8ZX37Nkmi/SrVjRdHzeXhyRi1oM/DDdnAkkorc110p2BmU8JA95N3Ba+RtVHw1EhzHyDIENrXQFDKO5VxQjt6HX/cIO5PCdc6SndTgWqS8l0glhkmJvmz1iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 IA1PR11MB7774.namprd11.prod.outlook.com (2603:10b6:208:3f2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 18:07:54 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 18:07:54 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@resnulli.us>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZKp4G2r/C0xvjvEaU4m2OVmfgX66kdoDg
Date:   Wed, 18 Jan 2023 18:07:53 +0000
Message-ID: <DM6PR11MB4657644893C565877A71E1F19BC79@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
In-Reply-To: <20230117180051.2983639-1-vadfed@meta.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|IA1PR11MB7774:EE_
x-ms-office365-filtering-correlation-id: 2719d96b-584b-49ea-4052-08daf97eeb86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BNhoA4VM+l7UIM3qbSFkC/mU0MRKketInNLRXA9hMMCCn9iMZTvGslKKm74SO/aUmlkgj3ijlL7p5vPFrJAJQDg6agZ2oP9n+5Nhbe9gy+0l7Tf7JvqOK4PgdwwQfb1e1TKVBFylE/zTiewE/tjZ7DSF14QHb3ketvLGBhoTHSNSyHrxCpbw5FRr8Mzwv/mLDCrEV7fZc0UDVgqusWsCPOLF9ybduDUHqrfz+03kpd8tiPnDdAGJOAYQMGc4Cz8R2D+Oa8RirwRg5wC4QYeX2rojCoV4WQ9uLlYNcnhBPTpf4v3T0jSJ5I3tgkrGywTZqP1+vxTZ11voxhP1sbICg/w7fYc5FGrGv84tcpskcoDyXD9ynLM0PfudJk6R4zVFpPRrR/HN+hZZFHcTVxsansnp/BMvFsDTbsG5IUGAJsmHZvaYcuDQv0MDoxJYs9IP0t2GrWEuo+FZB7SnWgaquviauqQbE1FCFz/B9aRRhO3BxBL4AwqxtfY28EHryQwwsh8EgWB5mkUwezUSTCZJ5CcpYiVIKhmyZeGu5HgrlalYg6fHvTbICqstIqLIsx0ZocoqYmcWNoWSE6rWwBOU2EQGGKNuZicyQUeNS3N+sdpPf37OJrI5XeBmE0pPfAJxxINeAb9zPhG6mH6tUWkWODRR7L+/5o4A+HufztKWv93s2zK76/pwSgASJWXHVJ65Z7Cc/ZX38ZIvZDMyX5A5kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(4326008)(66446008)(76116006)(55016003)(64756008)(186003)(8676002)(9686003)(86362001)(66556008)(26005)(41300700001)(66476007)(66946007)(33656002)(316002)(71200400001)(54906003)(7696005)(110136005)(6506007)(122000001)(38100700002)(2906002)(38070700005)(82960400001)(83380400001)(5660300002)(52536014)(478600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z2B3eD9H86fgeaaOYM0oEW4x3be6haPgFQmXZkjzZnLx9cFM0Zs9o8aZor3A?=
 =?us-ascii?Q?w9d2QuVOoD+J7Z0hewrB3Dzi8gylsFGH5GNxfN4yHD7oi2dcn2EmAnUInc5o?=
 =?us-ascii?Q?wPkMI9YRzaB+3LRiHmH+HbT+ajXs67C++CJyKG4ERPTYD/5A9mJ7W6BxEnU0?=
 =?us-ascii?Q?tJ/APOzjQIzrAD0MV0OFO6avEJVdOJPWfVNxMud0+Pk4UbHomTsmAS4Wv+gj?=
 =?us-ascii?Q?a9pTtZmfAjHnudZd7+Is9OOq67CDDrHiRBCdRpt/L9J2trJUIFv+WWUsQKsB?=
 =?us-ascii?Q?NDVfutTF6rEYTlSlrgkMGStIjWufniD9W2KjKFtAItlmZ6iKZGbx03NcLxn1?=
 =?us-ascii?Q?7PJFWPKa2JnT6qFUxcxrblSPmCUuwRv6XG4pxB1aex6yBvAhkExQeWSgfR0G?=
 =?us-ascii?Q?L5q8ojwPYHEnTucZzIi1VrarngGZyBDyfgp02Ud9LABo8UsxId8pGX0V+lQ1?=
 =?us-ascii?Q?C+yxYL19Qso3/DvTAWXUpniLoXo7OVzlztzZq2VgfTyYX1HzRPOXWvd73dzN?=
 =?us-ascii?Q?JvHfaBluzE+exqLGSCNAO1kFPFN3kjz1evPhil+tloU76lsLWILrKVTHiZj/?=
 =?us-ascii?Q?v3a+hAnwI1EkRHfgJYE8SHarowQxYwRg1blBERi6XKRdY5Vh0X0KIN2yeAA6?=
 =?us-ascii?Q?0DJZG/tqns1cuusQC/wGVduyiCvjI5j/t38JFI2ktmph9LEKQRM3MMruFjF4?=
 =?us-ascii?Q?T/OnjjQ3Q5SdcM9w3gtWuNDUGIFKfX6ve9JaEI2ZCZ1KpBmIsFYy894sRt1l?=
 =?us-ascii?Q?K6I3Z4w1AHysA1bMOxpQvTQ8yEM5//YoqToV5bKgnkRrA9mvvZVs1SLLca4s?=
 =?us-ascii?Q?eepnPkAEBpSj0TSOjZUh+ElYpAuNE45O1UUcQMb2JNULNDGofebYoKywTrnK?=
 =?us-ascii?Q?CRPTIpMJVAwOJ9+Dbz0EbfIuGTvk852ZOxZz0DRVBTAX2Zn+dBMGHob3UH0J?=
 =?us-ascii?Q?sdTKfh5i4HBhje9gjFk9ktwUW7T7ao6tNhLbr+Tx/KfX22WJgqHb0Am+kjct?=
 =?us-ascii?Q?+n7saO7ygg/xVQQWAgdac7Zc5We8EuA4vMXbNdv5GYL7VV7X2fCq2UEUqci4?=
 =?us-ascii?Q?U0TCAwzm323e/c1qfyG/snlWW+JYZi88Q5Xv+LBRSE1WDHkT8cfPGvts6sM2?=
 =?us-ascii?Q?E0k6l7kJuL7JtRurbHM1jCUMqgUzCouEA0yLv9O5/gtgWZzFZYC9tUP99rEO?=
 =?us-ascii?Q?ERWrE5rOYRbsj54eJM+FAbE5ApLsgukJh7x32q/kWUEeLNZ3DndyUO/+X/8H?=
 =?us-ascii?Q?4M7/8FYUd9MhifwYdYKdRUVafK9MM+AG+Z/uElA9fAS7Pd5XyyA0nhh9HkmG?=
 =?us-ascii?Q?qVUvoMikTi1FB6na5/cCG8z0C5ggOFZ/2Lk1kiedGDio5EORCes8u3TL5tgU?=
 =?us-ascii?Q?B7zeh8U3ogCjeMzlIgpU0I9LBtmzQrFwAo3+W8YoeZjDPlgFXET1jJDwVy7j?=
 =?us-ascii?Q?0/ULdL8ENzNfFLWIhFyM5rsaHs2lnXl1QR6c6ukkeyHJ2jGArgDavQFrRLNE?=
 =?us-ascii?Q?P+j5NfAXEkeOkxel6+tqPoZ6MFBvcVuG+TXIOh+8PKx/IosSUlvX+aqVdtV+?=
 =?us-ascii?Q?SOUOExUsySrf9KNck6pVYEhTAyGXHZLpyE455b00pOaxIb7sJEINOUamxBWm?=
 =?us-ascii?Q?AQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2719d96b-584b-49ea-4052-08daf97eeb86
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 18:07:53.8673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GV6Yo2MzCbfrHAASMaRp+emP9ryS5rOizwBLRX028810zzUWFQPSGfEPoc9xQT5skaKAzrd3qbl8Lu3pWxJaqA+TkgH8MkdF2Q+dth/6rIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vadim Fedorenko <vadfed@meta.com>
>Sent: Tuesday, January 17, 2023 7:01 PM
>
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and make i=
t
>flexible and easy to cover special configurations.
>
>v4 -> v5:
> * fix code issues found during last reviews:
>   - replace cookie with clock id
>	 - follow one naming schema in dpll subsys
>	 - move function comments to dpll_core.c, fix exports
>	 - remove single-use helper functions
>	 - merge device register with alloc
>   - lock and unlock mutex on dpll device release
>   - move dpll_type to uapi header
>   - rename DPLLA_DUMP_FILTER to DPLLA_FILTER
>   - rename dpll_pin_state to dpll_pin_mode
>   - rename DPLL_MODE_FORCED to DPLL_MODE_MANUAL
>   - remove DPLL_CHANGE_PIN_TYPE enum value
> * rewrite framework once again (Arkadiusz)
>   - add clock class:
>     Provide userspace with clock class value of DPLL with dpll device dum=
p
>     netlink request. Clock class is assigned by driver allocating a dpll
>     device. Clock class values are defined as specified in:
>     ITU-T G.8273.2/Y.1368.2 recommendation.
>   - dpll device naming schema use new pattern:
>	   "dpll_%s_%d_%d", where:
>       - %s - dev_name(parent) of parent device,
>       - %d (1) - enum value of dpll type,
>       - %d (2) - device index provided by parent device.
>   - new muxed/shared pin registration:
>	   Let the kernel module to register a shared or muxed pin without
>finding
>     it or its parent. Instead use a parent/shared pin description to find
>     correct pin internally in dpll_core, simplifing a dpll API
> * Implement complex DPLL design in ice driver (Arkadiusz)
> * Remove ptp_ocp driver from the series for now
>v3 -> v4:
> * redesign framework to make pins dynamically allocated (Arkadiusz)
> * implement shared pins (Arkadiusz)
>v2 -> v3:
> * implement source select mode (Arkadiusz)
> * add documentation
> * implementation improvements (Jakub)
>v1 -> v2:
> * implement returning supported input/output types
> * ptp_ocp: follow suggestions from Jonathan
> * add linux-clk mailing list
>v0 -> v1:
> * fix code style and errors
> * add linux-arm mailing list
>
>Arkadiusz Kubalewski (2):
>  ice: add admin commands to access cgu configuration
>  ice: implement dpll interface to control cgu
>
>Vadim Fedorenko (2):
>  dpll: documentation on DPLL subsystem interface
>  dpll: Add DPLL framework base functions
>
> Documentation/networking/dpll.rst             |  280 +++
> Documentation/networking/index.rst            |    1 +
> MAINTAINERS                                   |    8 +
> drivers/Kconfig                               |    2 +
> drivers/Makefile                              |    1 +
> drivers/dpll/Kconfig                          |    7 +
> drivers/dpll/Makefile                         |    9 +
> drivers/dpll/dpll_core.c                      | 1010 ++++++++
> drivers/dpll/dpll_core.h                      |  105 +
> drivers/dpll/dpll_netlink.c                   |  883 +++++++
> drivers/dpll/dpll_netlink.h                   |   24 +
> drivers/net/ethernet/intel/Kconfig            |    1 +
> drivers/net/ethernet/intel/ice/Makefile       |    3 +-
> drivers/net/ethernet/intel/ice/ice.h          |    5 +
> .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 +-
> drivers/net/ethernet/intel/ice/ice_common.c   |  467 ++++
> drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
> drivers/net/ethernet/intel/ice/ice_dpll.c     | 2115 +++++++++++++++++
> drivers/net/ethernet/intel/ice/ice_dpll.h     |   99 +
> drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
> drivers/net/ethernet/intel/ice/ice_main.c     |   10 +
> drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  408 ++++
> drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  240 ++
> drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
> include/linux/dpll.h                          |  282 +++
> include/uapi/linux/dpll.h                     |  294 +++
> 26 files changed, 6549 insertions(+), 6 deletions(-)  create mode 100644
>Documentation/networking/dpll.rst  create mode 100644 drivers/dpll/Kconfig
>create mode 100644 drivers/dpll/Makefile  create mode 100644
>drivers/dpll/dpll_core.c  create mode 100644 drivers/dpll/dpll_core.h
>create mode 100644 drivers/dpll/dpll_netlink.c  create mode 100644
>drivers/dpll/dpll_netlink.h  create mode 100644
>drivers/net/ethernet/intel/ice/ice_dpll.c
> create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
> create mode 100644 include/linux/dpll.h  create mode 100644
>include/uapi/linux/dpll.h
>
>--
>2.30.2


Based on today's sync meeting, changes we are going to introduce in next
version:
- reduce the muxed-pin number (artificial multiplication) on list of dpll's
pins, have a single pin which can be connected with multiple parents,
- introduce separated get command for the pin attributes,
- allow infinite name length of dpll device,
- remove a type embedded in dpll's name and introduce new attribute instead=
,
- remove clock class attribute as it is not known by the driver without
compliance testing on given SW/HW configuration,
- add dpll device "default" quality level attribute, as shall be known
by driver for a given hardware.


BR, Arkadiusz
