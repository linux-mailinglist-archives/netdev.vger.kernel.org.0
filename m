Return-Path: <netdev+bounces-11130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD94731A4D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9428F1C20EA9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEC015AFA;
	Thu, 15 Jun 2023 13:42:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561F415AE9
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:42:15 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B4330D6;
	Thu, 15 Jun 2023 06:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686836532; x=1718372532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wCsXpDLnrIIjeXVTbgwmAPZVxPjNB9j2ZOUcOVxLBpg=;
  b=UtCfnHSJVGLCVG470cCnyygg4Zm5q6fHA8TQlWtq0/+G//elugr8QzK+
   fNqF6sQRUagug1x42485Kt6McQGyHka9TxckgXpaUkr0R5OcudoytbnKI
   c7Hn+tZrBR+j+5Nn3NEZtKrgoyrvFE37VWJev5REzMpmkKxQUGU0kCBYt
   w7UYDa1Uh+hSHg5/Ni1jBfwhBlctrqlkrsWv6GHFd1AIJHhbSOAduEPjB
   Zfl9aE+vB0jt2NjfuLiNiv723XAJJRybi9xPKHzquQt2eytyT3BzDhEfy
   NoLgJRDgl9IoZyKF7faP+QMyxAnXNwUj0/Z2A/jE6U3pSfxLljFQaODMs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="356408540"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="356408540"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 06:42:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782522481"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="782522481"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2023 06:42:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:42:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:42:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 06:42:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 06:42:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vj4s7hijdnQNoqq+FWReqxIWv4a7G0OgeHfSjs1wUnibfoAaG3GABxXcgNm0L9bD4pdTGDg44BT6AYYXnyYI7+fMhuthec3PRwPlKBG/HfryjX1vIpm9lUkM23NnUzN8IDUIaxZql2iim32FzNV/t+mkZ6xZ5yrsqUI6JSV1zd2qMTL70wPyId/PO/5IRxkofJtIattuY09Z9vbSRfXSDMzGNRkb5CAfQiNURDdn+kZLeAMbY//pXARfLotSovZwzQ0IoV+CxRhNaYAtnmsSVqtQ7xHirGvnYeXaKQWjb0lvYnToySEGcmvBG2PcuwXiU2rQgMI4yofDUvmhhX7AoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeRrVA8z8DHzZsUPOCRSijPr54Z4whodI8kdH8N6y+4=;
 b=DqZfWaOaAUY7uSx3Cr4ODrA7Nsh+2Oix306yFY0mXQR8JZxD+LR6ZaS3uoC/hv/7nvbXZY7o7Mo3lWFGQbfXtmoD+0Wmf10BhRnCLv4tnJaIgxltv49eX5aHBz9MfIqG4o9kETOJWR6d+c0CUZKYmm4qj7NBka9PM/BoY49UfDE3TUUW3aW8GL/usnV6YXkoX4sdlkF0vG74HqN1HV63NrfPMGtbd4qyALC5uB6KVfPbj0Clki11mxuOEX48wzPGYjnqYIWQwmJlckKgDPo13Ck3t7RdB0uVdde/DKf0uUM4x/q5cJM7/MGoBBmbBdLidn3eZO01LezcDtOKycsiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Thu, 15 Jun 2023 13:42:03 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 13:42:03 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: "kuba@kernel.org" <kuba@kernel.org>, "vadfed@meta.com" <vadfed@meta.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "M, Saeed" <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "richardcochran@gmail.com"
	<richardcochran@gmail.com>, "sj@kernel.org" <sj@kernel.org>,
	"javierm@redhat.com" <javierm@redhat.com>, "ricardo.canuelo@collabora.com"
	<ricardo.canuelo@collabora.com>, "mst@redhat.com" <mst@redhat.com>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>, "Michalik, Michal"
	<michal.michalik@intel.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "jacek.lawrynowicz@linux.intel.com"
	<jacek.lawrynowicz@linux.intel.com>, "airlied@redhat.com"
	<airlied@redhat.com>, "ogabbay@kernel.org" <ogabbay@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>, "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "linux@zary.sk" <linux@zary.sk>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
	"geert+renesas@glider.be" <geert+renesas@glider.be>, "Olech, Milena"
	<milena.olech@intel.com>, "kuniyu@amazon.com" <kuniyu@amazon.com>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "andy.ren@getcruise.com" <andy.ren@getcruise.com>,
	"razor@blackwall.org" <razor@blackwall.org>, "idosch@nvidia.com"
	<idosch@nvidia.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "phil@nwl.cc"
	<phil@nwl.cc>, "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v8 02/10] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v8 02/10] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZmszr2BJDDEOJ60yRPuK1IWG2S6+EOc6AgAeqEYA=
Date: Thu, 15 Jun 2023 13:42:02 +0000
Message-ID: <DM6PR11MB4657F2003E744E0462FD5E7D9B5BA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-3-arkadiusz.kubalewski@intel.com>
 <ZISjMUcpmUTBXIOA@nanopsycho>
In-Reply-To: <ZISjMUcpmUTBXIOA@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7097:EE_
x-ms-office365-filtering-correlation-id: 7ab41417-6874-43e1-9bc7-08db6da64d1d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tQw4xzIaDIZk9PJabZjLyjhQtB+ib9NwFGrnQhkE7S0hJ2a6EzLOGVLk22HkN6U//lDLeMTXeqv4oS+sQZLXyW23eajawYiPBvQT0Qwpm2y+eL9qJ5sM7yainIisjmG1ROTjHVU9L+hYN9UQeV6UmDCtQ/agtRYboLkZ+oq+MEPleyvdP13PP/CdhNwXSMZWKfPIC5IoIWdwkopCh3uUyJOYBYm074ZxAgXp8fkm7irhf1QB3V7Tb4jjDNVUpeLjZO9kJffyKIN85+bYI7r8XrmY+gJNQ9pdz8x1kR62VUJkRcIg9vCFgsWP3q7SzrlqGh9WP1ZBziS7XjsFarM+fq1zV9+QVwLBbIQD5x0OX8PAyI/zL8FFzrl6ZiHe6FVC/AKNW+bHjZ4rYzg0t5sou9ikqhfpMNnd/JB3x1opaDhO2uE0IvR51chE68IDFbPszrKmQB33AuykPVpP1tktXLjUESq7WA+W858v1Xi886GFWZ66XXzAvUZOvne6FwMXfbVs5RFV79wSXGlsegCzCzgvIsExv9dgx0nqJPCCui1fsYraui3qoN0mmtrSqpyoO6wYnZMMB6CpdD5FgX640S6QU7+FLj2+NUvsegLXtVuVwpVOSui6WJYbyP4AjCjT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(38070700005)(52536014)(33656002)(86362001)(7416002)(2906002)(7406005)(71200400001)(55016003)(5660300002)(7696005)(186003)(83380400001)(9686003)(6506007)(26005)(82960400001)(122000001)(54906003)(66476007)(66446008)(4326008)(76116006)(66946007)(66556008)(64756008)(478600001)(316002)(38100700002)(8676002)(8936002)(6916009)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0OwbbEj4vV9cvcAocJw2RMKX+RPVyG9oAJ71OUjfOkey2zUPHbkPLf7jnPzi?=
 =?us-ascii?Q?ZRpNS7cL5PEZ8DMGhiNJTSnTRqNQBIAS8yRGg0JPSyHudxqGcfNx2iMHk4oB?=
 =?us-ascii?Q?pcZGLSNAJOBkE0wv1sU+56RlUfOeph8AGMX0TvspFxLqBxtbEEzcRQXYn2EC?=
 =?us-ascii?Q?mT+REKReO2jLD6YWBxgtJ5XbZBnaGfL7qyWv3lBTQrR7Iq2B90GKYXvJr8nH?=
 =?us-ascii?Q?i8SSbMGbk1fGv7mWr6CaMSIh4nlJ0+VHc9Vdw/gI3qE0fbSCYjvh2zbmM4D7?=
 =?us-ascii?Q?/GDRH3S1Rw/WFAb5rJ+fndY2afAKN8tApfOxeXbpXAsbDM7Abe/vz1eBAxBS?=
 =?us-ascii?Q?w1ACLRihjWgE1uOOyLb83KwP5+UZ3CP14bjGgpF1rf1sn/kQW0fqAFWXVhPe?=
 =?us-ascii?Q?jpv2iMMjh1dS4x4DvgEHoxhKL04NO+3L1bbjLv0nHnIJrdEazfap4qO/fNav?=
 =?us-ascii?Q?4OuVe//YqQQSxPLCeOB9gKocbLZmRR+xuXQwY0aEj+DhGLz9mAM+iU+H9OTl?=
 =?us-ascii?Q?Yj9X+zYY4p+VBmeXetn6S9J9vVG8yDTcszHh2qxwzc0qiBK4teFqhuuNzE3J?=
 =?us-ascii?Q?unWWWpnacOR7WuuqDwN1/bb57iUDo6dG8Je0jmGVcWkM0ugSdkrx6VYQvR2g?=
 =?us-ascii?Q?gWlYivtfkGd7x4RQg5fpprYKbqt1YlgoqNmYc/GA2eJaqptFjfx+T/o1Ux5d?=
 =?us-ascii?Q?7qzcHbQvawYawKj7prflhYEK8+kIWzHtI1AArzGZw+9IbFJsZhu5W3ZvByFO?=
 =?us-ascii?Q?QctFwp2UuAqjXNQ+l0ljMSloU/x/EBNV00BdhT//u9FGZjTZeHijtSpP79Yv?=
 =?us-ascii?Q?JLODWdz00j3DKASPs09paNh+qKhk56LZdh9nkcQczxws2842KGnmq64LQGF+?=
 =?us-ascii?Q?mJa+ZLg6xjKTOSZedYJHbSKRghe6u7DY3A5VVOKVRt0pMbwITOdaYf6+1I8c?=
 =?us-ascii?Q?N6BqOcbsmZEpnLiSCM7t/iW/X9WelJ7nzEfHjV7cssX+YMb4xMr50K0qjqCO?=
 =?us-ascii?Q?aKCGkWUq2mAtN+qOdcdmF9GKtfkExTARnu4D2cDVHLNqt3BT4Vc3yiDO4Me+?=
 =?us-ascii?Q?8jNZNPxIILfsQ8VpGVHIpgx+mPiPPACRQFCEkLYGH4huRaEpRUonKEITDbSx?=
 =?us-ascii?Q?pBGOH6YRsWEPtYSKKteMMXqvIIMqhdYWc98VFxinQl7aI/vrhUYPM5vYMOWz?=
 =?us-ascii?Q?Rl3ZpdhSQIJKJIwWcebLN/8xyjctwybxzIy2O1+DfPyYaeHC5ESHzRtDndIv?=
 =?us-ascii?Q?1XzBDK/igKoHoM0+xEvlU6oFgWeBZsTx6rdZB9E+nfTJDDkNA9Tt6gZ6QM1w?=
 =?us-ascii?Q?ILD2xVdQFyiFPRyTwLzmV5YrduGlmJn/X3M8+RdAOserhbdNJBIOo1oyRGey?=
 =?us-ascii?Q?Lkgo0sT9XSw5DjEEFOBrEy1AgFfMLEXhDlJYntcxPDqblp3Xh+mHQRYGKwSv?=
 =?us-ascii?Q?OvRTEDLoaJO2zDizyDFGJX1HAeMGj/TpFraH+u8DRIOkBvoVDkxYVusp1x4m?=
 =?us-ascii?Q?cXLFUC65qbMxFsVR2aXdMEZqFkL9m2QDADspDYbejSjYobfs/TGtYNFs/c4I?=
 =?us-ascii?Q?fbYqWRppByQ/yC/jIb9SZH0cW76kwufc03ZPq4m+fQK4S0BD8IyJjE2btSqN?=
 =?us-ascii?Q?Yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab41417-6874-43e1-9bc7-08db6da64d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 13:42:02.8498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTUmTs0G4LKmLr/YoMKT1PKYRt8T9iKNKRni/Jjboc8rPPfxohmTj7AaJ1Kxbt94aTewX/4yZoFf6R5Esd8kb0p+P6HUhE9OqjZ9cEeWUNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Saturday, June 10, 2023 6:22 PM
>
>Fri, Jun 09, 2023 at 02:18:45PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>Add a protocol spec for DPLL.
>>Add code generated from the spec.
>>
>>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>---
>> Documentation/netlink/specs/dpll.yaml | 466 ++++++++++++++++++++++++++
>> drivers/dpll/dpll_nl.c                | 161 +++++++++
>> drivers/dpll/dpll_nl.h                |  50 +++
>> include/uapi/linux/dpll.h             | 184 ++++++++++
>> 4 files changed, 861 insertions(+)
>> create mode 100644 Documentation/netlink/specs/dpll.yaml
>> create mode 100644 drivers/dpll/dpll_nl.c
>> create mode 100644 drivers/dpll/dpll_nl.h
>> create mode 100644 include/uapi/linux/dpll.h
>>
>>diff --git a/Documentation/netlink/specs/dpll.yaml
>>b/Documentation/netlink/specs/dpll.yaml
>>new file mode 100644
>>index 000000000000..f7317003d312
>>--- /dev/null
>>+++ b/Documentation/netlink/specs/dpll.yaml
>>@@ -0,0 +1,466 @@
>>+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-
>>Clause)
>>+
>>+name: dpll
>>+
>>+doc: DPLL subsystem.
>>+
>>+definitions:
>>+  -
>>+    type: enum
>>+    name: mode
>>+    doc: |
>>+      working-modes a dpll can support, differentiate if and how dpll
>>selects
>
>s/working-modes/working modes/
>s/differentiate/differentiates/
>?

Fixed.

>
>
>>+      one of its inputs to syntonize with it, valid values for DPLL_A_MO=
DE
>>+      attribute
>>+    entries:
>>+      -
>>+        name: manual
>>+        doc: input can be only selected by sending a request to dpll
>>+        value: 1
>>+      -
>>+        name: automatic
>>+        doc: highest prio, valid input, auto selected by dpll
>
>s/valid input, auto selected by dpll/input pin auto selected by dpll/
>?

Fixed.

>
>
>>+      -
>>+        name: holdover
>>+        doc: dpll forced into holdover mode
>>+      -
>>+        name: freerun
>>+        doc: dpll driven on system clk
>
>Thinking about modes "holdover" and "freerun".
>1) You don't use them anywhere in this patchset, please remove them
>   until they are needed. ptp_ocp and ice uses automatic, mlx5 uses
>   manual. Btw, are there any other unused parts of UAPI? If yes, could
>   you please remove them too?
>
>2) I don't think it is correct to have them.
>   a) to achieve holdover:
>      if state is LOCKED_HO_ACQ you just disconnect all input pins.
>   b) to achieve freerun:
>      if state LOCKED you just disconnect all input pins.
>   So don't mangle the mode with status.
>

Well this is not entierly true, the mode is not a state.
Technically in those modes the user would not be able to set any states
on the pins.
The modes are supported on the synchronizer chips we are using, altough
the ice driver does not have this support enabled yet.
So I am removing those for now, if they would be needed, we will submit the
patches for it.

>
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: lock-status
>>+    doc: |
>>+      provides information of dpll device lock status, valid values for
>>+      DPLL_A_LOCK_STATUS attribute
>>+    entries:
>>+      -
>>+        name: unlocked
>>+        doc: |
>>+          dpll was not yet locked to any valid input (or is in mode:
>>+            DPLL_MODE_FREERUN)
>
>Don't forget to remove the mention of mode freerun from here.
>

Fixed.

>
>>+        value: 1
>>+      -
>>+        name: locked
>>+        doc: |
>>+          dpll is locked to a valid signal, but no holdover available
>>+      -
>>+        name: locked-ho-acq
>>+        doc: |
>>+          dpll is locked and holdover acquired
>>+      -
>>+        name: holdover
>>+        doc: |
>>+          dpll is in holdover state - lost a valid lock or was forced
>>+          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>+          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>+          if dpll lock-state was not DPLL_LOCK_STATUS_LOCKED, the
>>+          dpll's lock-state shall remain DPLL_LOCK_STATUS_UNLOCKED
>>+          even if DPLL_MODE_HOLDOVER was requested)
>
>Don't forget to remove the mention of mode holdover from here.
>

Fixed.

>
>>+    render-max: true
>>+  -
>>+    type: const
>>+    name: temp-divider
>>+    value: 1000
>>+    doc: |
>>+      temperature divider allowing userspace to calculate the
>>+      temperature as float with three digit decimal precision.
>>+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
>>+      temperature value.
>>+      Value of (DPLL_A_TEMP % DPLL_TEMP_DIVIDER) is fractional part of
>>+      temperature value.
>>+  -
>>+    type: enum
>>+    name: type
>>+    doc: type of dpll, valid values for DPLL_A_TYPE attribute
>>+    entries:
>>+      -
>>+        name: pps
>>+        doc: dpll produces Pulse-Per-Second signal
>>+        value: 1
>>+      -
>>+        name: eec
>>+        doc: dpll drives the Ethernet Equipment Clock
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-type
>>+    doc: |
>>+      defines possible types of a pin, valid values for DPLL_A_PIN_TYPE
>>+      attribute
>>+    entries:
>>+      -
>>+        name: mux
>>+        doc: aggregates another layer of selectable pins
>>+        value: 1
>>+      -
>>+        name: ext
>>+        doc: external input
>>+      -
>>+        name: synce-eth-port
>>+        doc: ethernet port PHY's recovered clock
>>+      -
>>+        name: int-oscillator
>>+        doc: device internal oscillator
>>+      -
>>+        name: gnss
>>+        doc: GNSS recovered clock
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-direction
>>+    doc: |
>>+      defines possible direction of a pin, valid values for
>>+      DPLL_A_PIN_DIRECTION attribute
>>+    entries:
>>+      -
>>+        name: input
>>+        doc: pin used as a input of a signal
>
>I don't think I have any objections against "input", but out of
>curiosity, why you changed that from "source"?
>

Agreed to previous version review comment from Jakub,
to use either: input/output or source/sink naming scheme.

>
>>+        value: 1
>>+      -
>>+        name: output
>>+        doc: pin used to output the signal
>>+    render-max: true
>>+  -
>>+    type: const
>>+    name: pin-frequency-1-hz
>>+    value: 1
>>+  -
>>+    type: const
>>+    name: pin-frequency-10-khz
>>+    value: 10000
>>+  -
>>+    type: const
>>+    name: pin-frequency-77_5-khz
>>+    value: 77500
>>+  -
>>+    type: const
>>+    name: pin-frequency-10-mhz
>>+    value: 10000000
>>+  -
>>+    type: enum
>>+    name: pin-state
>>+    doc: |
>>+      defines possible states of a pin, valid values for
>>+      DPLL_A_PIN_STATE attribute
>>+    entries:
>>+      -
>>+        name: connected
>>+        doc: pin connected, active input of phase locked loop
>>+        value: 1
>>+      -
>>+        name: disconnected
>>+        doc: pin disconnected, not considered as a valid input
>>+      -
>>+        name: selectable
>>+        doc: pin enabled for automatic input selection
>>+    render-max: true
>>+  -
>>+    type: flags
>>+    name: pin-caps
>>+    doc: |
>>+      defines possible capabilities of a pin, valid flags on
>>+      DPLL_A_PIN_CAPS attribute
>>+    entries:
>>+      -
>>+        name: direction-can-change
>>+      -
>>+        name: priority-can-change
>>+      -
>>+        name: state-can-change
>>+
>>+attribute-sets:
>>+  -
>>+    name: dpll
>>+    enum-name: dpll_a
>>+    attributes:
>>+      -
>>+        name: id
>>+        type: u32
>>+        value: 1
>>+      -
>>+        name: module-name
>>+        type: string
>>+      -
>>+        name: clock-id
>>+        type: u64
>>+      -
>>+        name: mode
>>+        type: u8
>>+        enum: mode
>>+      -
>>+        name: mode-supported
>>+        type: u8
>>+        enum: mode
>>+        multi-attr: true
>>+      -
>>+        name: lock-status
>>+        type: u8
>>+        enum: lock-status
>>+      -
>>+        name: temp
>>+        type: s32
>>+      -
>>+        name: type
>>+        type: u8
>>+        enum: type
>>+      -
>>+        name: pin-id
>>+        type: u32
>>+      -
>>+        name: pin-board-label
>>+        type: string
>>+      -
>>+        name: pin-panel-label
>>+        type: string
>>+      -
>>+        name: pin-package-label
>>+        type: string
>
>Wouldn't it make sense to add some small documentation blocks to the
>attrs? IDK.
>

Actually already tried that, but after all they did not generate any docs
for attr enums. So this need also fix in ynl-gen-c.py

I think this would be useful, but only if we could use them in the dpll.rst=
.
Right now it is not case, but we already try to incorporate other enums
description there, for now it is broken, but will try to fix this in the ne=
ar
future.

Thank you!
Arkadiusz

>
>>+      -
>>+        name: pin-type
>>+        type: u8
>>+        enum: pin-type
>>+      -
>>+        name: pin-direction
>>+        type: u8
>>+        enum: pin-direction
>>+      -
>>+        name: pin-frequency
>>+        type: u64
>>+      -
>>+        name: pin-frequency-supported
>>+        type: nest
>>+        multi-attr: true
>>+        nested-attributes: pin-frequency-range
>>+      -
>>+        name: pin-frequency-min
>>+        type: u64
>>+      -
>>+        name: pin-frequency-max
>>+        type: u64
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        enum: pin-state
>>+      -
>>+        name: pin-dpll-caps
>>+        type: u32
>>+      -
>>+        name: pin-parent
>>+        type: nest
>>+        multi-attr: true
>>+        nested-attributes: pin-parent
>>+  -
>>+    name: pin-parent
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: id
>>+        type: u32
>>+      -
>>+        name: pin-direction
>>+        type: u8
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+      -
>>+        name: pin-id
>>+        type: u32
>>+
>>+  -
>>+    name: pin-frequency-range
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: pin-frequency-min
>>+        type: u64
>>+      -
>>+        name: pin-frequency-max
>>+        type: u64
>
>[...]

