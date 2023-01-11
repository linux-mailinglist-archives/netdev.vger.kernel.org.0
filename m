Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70810665F33
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbjAKPcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbjAKPce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:32:34 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE12BC06;
        Wed, 11 Jan 2023 07:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673451153; x=1704987153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xt/UVTQJhMyfG9fR6A825ePK2U2c+3VlJMCht6SLvnI=;
  b=MTg8zALMP72D6QCiKTRMhN/Q712jni6AcSz3cM4PPA1TIYIeJqFilPh1
   l7N90NhuFnd6hO5JSb9q7uX4YkmJqo3aiBw/mVbZf8XLnOP4BX+3QKtXq
   FGmefqESGXht2RsnFNRYzYLwXoKR92B/WFylYWIhtro68jEsyvjwh4DhS
   HY4lpJweDE8XSJT2rXOuZ//jrJMrdWgy4fyZlWQGafzjYCXz/OQgiN8f+
   UvE2VkFebHxyi1TVMNMDEdYRPBxYleRKWCPZcJnvsWqSLIgQ9uk43B095
   6Uokfy8dLrmrqHYjo2VWFYxcaON+gB0vQIqumpIVugQURfnet78vxUxJS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="306958914"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="306958914"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 07:30:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="902808452"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="902808452"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jan 2023 07:30:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 07:30:47 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 07:30:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 07:30:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 07:30:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOmvQuM2sjVDVYZg+Q0w+fLFoEl5/0HHhjtLFLeKU39YUtHba935Q63aV882ILQftlt5NqDT8PC6f9ObRp54R5r3SGsK6wL7hFSc0yvyDVHN3eE9lMu54yxWQCYkbWSBim4RfNs3/ginafWM1mYJoybS2dUqr01CALRbEEYNGnhJnpLIJFrM04LQ58+7Tof05jN5cU1XwsQPQy5Lha3OVNOQ68B3rw3k7WMe0I4XZU9y63W+LS5G8fDXRNBQDBAcF76nKurKmC0ISWqSmk1tQPATIujaoutPN67Bu+IJVcYtzlFt6pEK2GobvAKYsV4yZO41ivGffcx7cf8jzgET8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifPuWWQiAgoOcWOYc554RJ8FA1ytJPDyG+VVrA1hREM=;
 b=V36GBnBD7VF6yk/vzjl0gm1T0I8YC1X8XqUSFl4aCc4nNNJmyDHLRQLmkljopMEu0BTKM2eyF7dcAOjXNA31m3L0Senm2f+lby9P/XO9F812Hs0nV1wJQ7BGP9smFunCwLQKD1qFcahBNcBAlJWpNsLs0MPxRhBDpgK34U7ho5eTw3jHmByfGOd9X8gUdQteA1rpTpH5eL23tHOJcKtUgqhjYr3nnJkJCLOxwBoBTkJ+jG6KAd3yF9uTvqpkiwoqXyuy3iIMv9qGn7h1Jed01C0gszD4wNtCUxs0i41zzBozJ1AvJ0WNqHx6FjVNpl1dfm40EjTH1jwY9pcGkzlNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 15:30:44 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 15:30:44 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        "'Jonathan Lemon'" <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAG+ucAgAC+YICAAJp7gIABOqIAgAEc44CAADKwAIAAJ6gAgASMcoCALA0RgIAB7ReAgADNAgCAAF4QcIAAEyqAgAAChKA=
Date:   Wed, 11 Jan 2023 15:30:44 +0000
Message-ID: <DM6PR11MB4657DC9A41A69B71A42DD22F9BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org> <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230110120549.4d764609@kernel.org> <Y75xFlEDCThGtMDq@nanopsycho>
 <DM6PR11MB4657AC41BBF714A280B578D49BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y77QEajGlJewGKy1@nanopsycho>
In-Reply-To: <Y77QEajGlJewGKy1@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DS0PR11MB7381:EE_
x-ms-office365-filtering-correlation-id: 36e11a99-1f88-4ce8-1160-08daf3e8ce6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vzc9PfC0N3lKBC9A3pL9QE2Kq8xRwDItESMT/Ux/OQO/q/1uXDcECZqVg5AZT1ZUn0sXxr5knLzZZtDixhsVPbWqCqyFmmERTEQv6rU7W8dHWrYzbCZ7E+FM6V4m0WfZgn0rFKCOIck/nftRSmM5JtzYX229iASQcb3Fd8VNOThiH7wWvptbmQgGoqiS2hI4ta8Xx9uLyzSizSsLuA4UulaMsIiKBrZpwhuiQ/e5nM8vlaf03szEUThQxO5Ze2WLGROABrqpc+1ookjax0g3yjYTwbhcuaO7WJFwtwn1qnO9/2JcB3Wk9YXwUPwc0F/sY5LEPJ4QhjdMfZDAFqARfyR+wcas5pNZfdBjpXeftxsHbcx3C+rkXv45TVrT5enCDeI8cqYcNt2QcZ1nsTvNReWh61/1PLnfHwCbs4KnnRowNpdCYIA3S77y5K7pNwe2R+uvepeU3Q4OzgIwAL+RlK/Myzc/hgu7A1UaLlLHrNJxWFSPJiZpqa8BFfCuk9p6a/zcP2AGOfT5sJnvUsXbk+6B9pg+3hjMydw485Uw4mZvPNsS6m8asc6zQdS/wptxANW4lNsnVZFhRcVGoFaOrKgprE8cZV6T3klhnJ8mNbQWgCfgy44YPI8EHevq4Dgdm99v3YaqrSajxYswSXYcf+dNI8M5Qwn54E9XCm54gwk/Km1VAAEA+EN3W3QKOUIHXiWTVJzZrJoB73KUo40nE/v1G1IeUaPX2fcKxGvewWE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199015)(2906002)(8936002)(5660300002)(64756008)(83380400001)(33656002)(4326008)(8676002)(76116006)(66476007)(66556008)(66946007)(38100700002)(66446008)(41300700001)(9686003)(82960400001)(52536014)(316002)(55016003)(86362001)(54906003)(26005)(186003)(6916009)(7696005)(38070700005)(478600001)(122000001)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fsAhplkWDaMN6OgFA9lMYaZNvyc+/zYxjVzy+mfI8kb5Aw7Uh6ZkrF3MyHNL?=
 =?us-ascii?Q?dL+B86y012aY95AJQ2oarogSZKxHUJYCcptJx6hE3HkqovwLAUXTi/p/ybKx?=
 =?us-ascii?Q?DwMhtmE6CwX6z6YFuKDtM+7Daq8pdFr4YE3WQxE2hC6cD3+/qdfgmguBWcNK?=
 =?us-ascii?Q?N5kmUaVlc8PnasS8UEZehHuDjyDWc5TBFAx58rg/zlCdv+YmqY7/jF/qwLKu?=
 =?us-ascii?Q?lTuHItQZCFTNselaAohgHyJavG48luivXHCxgeucQnJ+8eGlZDdPyTAVu32e?=
 =?us-ascii?Q?VwC5P6cPclWJeWYBbmGYTVAvNXPeMpS2dLhEHnDM1EY56fdXOz7D8V/ASxJn?=
 =?us-ascii?Q?Z2D462w7nW1lrbQY05b674nhUHoYl8xTOLEnS8K4wPrzepacIl54GDeiZLL8?=
 =?us-ascii?Q?ZwXADgKEOIOvkDseLzgZnf/WdzyWj5PrVZhXPAgqig300miAg6KhXL5vwijo?=
 =?us-ascii?Q?SRVs2RQ+q6a8DsXIPLYX9ExgIOGz8l51CKzud/79ETnl52U3lEe45NyVO8vP?=
 =?us-ascii?Q?dUyRolEkoZ1qsQAkn8HEEbqhEZoFAT/HWbnZg+TCZ8dhhnAK/Qpn5TKJBZ0o?=
 =?us-ascii?Q?o8j2zU6wKfS2ycfWlOSJf+WbQBf6j9vmba9xrmlrivZK5D851S5T98AkioXX?=
 =?us-ascii?Q?XNjRLnMFCDPhsnKmDsga/RFwDikNbYlVGWJmuLWGGNCXKXCxiD4GRDPyIats?=
 =?us-ascii?Q?6JewDPzeZSZiKvGpPs8/WKLkqUfoJ3zHvqZj+8JyleSF/j43cAzAu8Krzo4s?=
 =?us-ascii?Q?n/n4hbnLCtz2GAlfXMc3qur8+gVSj3S1dfHHWGTAvaPONgXnerrdqr/3FhdM?=
 =?us-ascii?Q?AQe/YWfFDRQdR2vMtZq4rfuwAiLM+M2GE/dHTw9D2Xvz4BV0lh0U0u88fumT?=
 =?us-ascii?Q?t0p437w/DO9lCHiGeEYHzIPdod1/hd8BCr5xPOErrM7H/sR0ASJ4O3QSZUWV?=
 =?us-ascii?Q?+LPNakeRZjGW52yXNG0mPYIRVt3HdgjHHCNd4MGywGsJ3JiQ3fm+7Zwsuvof?=
 =?us-ascii?Q?xQEzJMY1qTdXiPBOMq7MEQ53hHE9DkOVPr9dUZPQdVY2QJl5sHyFLYYlpFh9?=
 =?us-ascii?Q?yMZ6byBE0eKgEm4/UxLCdS2uAc+xbTCzeVMGR9pQcSoob2mZf52KerzAcher?=
 =?us-ascii?Q?S2kO+weXLWTTE1UTYDajzZ5Mhupa8cEOK+BJurpCYvmYGsHYml5EwZDQ0buk?=
 =?us-ascii?Q?iIQtoljagsTA/AsN0Mc4DzdSEOCCofJ9QhmFBIeXLHeXAYGJ9uOp1YIpQ3hp?=
 =?us-ascii?Q?fFZ32VDM9VyA+qykq88sCIm/Matd1luSC3oRKJiEer/eW6srpxpDqHz4S4Mm?=
 =?us-ascii?Q?xq7ovUSiDKw0OETZDDcY9bKvcN+DzVPbj4+FhsLdyQJgw5jx2K6TDt1BB+HZ?=
 =?us-ascii?Q?jZgkypq5YVrVFvgGrYdRkDA59kQU/OZExBQjnJuRTnTum6Zf6nfoSLsySkqd?=
 =?us-ascii?Q?G0PrUbtV803qOGGKfRfXF0rCZIR4CE67pIywM1ShDnKYc8d4/MUTeudb+TQj?=
 =?us-ascii?Q?bfuA5xe7XZP2p1J9Fci9nkq2+G+BAOqtovNxnkFqpvWwtgqqSSOowUwVQGk1?=
 =?us-ascii?Q?B3c6j6JMv7sDl/RX7sTEfM2W4ain20wgLIOm5Jdib91Ra8jZJoVSLvH4HqiK?=
 =?us-ascii?Q?sA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e11a99-1f88-4ce8-1160-08daf3e8ce6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 15:30:44.7160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IjHwu8/S7/hox0e8xrS7D5GfpbFgWtW6zCN3iWoP7ZhyWTTTejonWU2NXThISVdoM1ZusvGXBkLHTS6dqhX/252QSQdRotUm8ZVtYOBaH0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, January 11, 2023 4:05 PM
>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>
>Wed, Jan 11, 2023 at 03:16:59PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, January 11, 2023 9:20 AM
>>>
>>>Tue, Jan 10, 2023 at 09:05:49PM CET, kuba@kernel.org wrote:
>>>>On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
>>>>> This is a simplified network switch board example.
>>>>> It has 2 synchronization channels, where each channel:
>>>>> - provides clk to 8 PHYs driven by separated MAC chips,
>>>>> - controls 2 DPLLs.
>>>>>
>>>>> Basically only given FW has control over its PHYs, so also a control
>>>over it's
>>>>> MUX inputs.
>>>>> All external sources are shared between the channels.
>>>>>
>>>>> This is why we believe it is not best idea to enclose multiple DPLLs
>>>with one
>>>>> object:
>>>>> - sources are shared even if DPLLs are not a single synchronizer chip=
,
>>>>> - control over specific MUX type input shall be controllable from
>>>different
>>>>> driver/firmware instances.
>>>>>
>>>>> As we know the proposal of having multiple DPLLs in one object was a
>try
>>>to
>>>>> simplify currently implemented shared pins. We fully support idea of
>>>having
>>>>> interfaces as simple as possible, but at the same time they shall be
>>>flexible
>>>>> enough to serve many use cases.
>>>>
>>>>I must be missing context from other discussions but what is this
>>>>proposal trying to solve? Well implemented shared pins is all we need.
>>>
>>>There is an entity containing the pins. The synchronizer chip. One
>>>synchronizer chip contains 1-n DPLLs. The source pins are connected
>>>to each DPLL (usually). What we missed in the original model was the
>>>synchronizer entity. If we have it, we don't need any notion of somehow
>>>floating pins as independent entities being attached to one or many
>>>DPLL refcounted, etc. The synchronizer device holds them in
>>>straightforward way.
>>>
>>>Example of a synchronizer chip:
>>>https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-
>>>frequency-translation/8a34044-multichannel-dpll-dco-four-eight-
>>>channels#overview
>>
>>Not really, as explained above, multiple separated synchronizer chips can
>be
>>connected to the same external sources.
>>This is why I wrote this email, to better explain need for references
>between
>>DPLLs and shared pins.
>>Synchronizer chip object with multiple DPLLs would have sense if the pins
>would
>>only belong to that single chip, but this is not true.
>
>I don't understand how it is physically possible that 2 pins belong to 2
>chips. Could you draw this to me?
>

Well, sure, I was hoping this is clear, without extra connections on the dr=
aw:
+----------+                =20
|i0 - GPS  |--------------\
+----------+              |
+----------+              |
|i1 - SMA1 |------------\ |
+----------+            | |
+----------+            | |
|i2 - SMA2 |----------\ | |
+----------+          | | |
                      | | |
+---------------------|-|-|-------------------------------------------+
| Channel A / FW0     | | |     +-------------+   +---+   +--------+  |
|                     | | |-i0--|Synchronizer0|---|   |---| PHY0.0 |--|
|         +---+       | | |     |             |   |   |   +--------+  |
| PHY0.0--|   |       | |---i1--|             |---| M |---| PHY0.1 |--|
|         |   |       | | |     | +-----+     |   | A |   +--------+  |
| PHY0.1--| M |       |-----i2--| |DPLL0|     |   | C |---| PHY0.2 |--|
|         | U |       | | |     | +-----+     |   | 0 |   +--------+  |
| PHY0.2--| X |--+----------i3--| +-----+     |---|   |---| ...    |--|
|         | 0 |  |    | | |     | |DPLL1|     |   |   |   +--------+  |
| ...   --|   |  | /--------i4--| +-----+     |---|   |---| PHY0.7 |--|
|         |   |  | |  | | |     +-------------+   +---+   +--------+  |
| PHY0.7--|   |  | |  | | |                                           |
|         +---+  | |  | | |                                           |
+----------------|-|--|-|-|-------------------------------------------+
| Channel B / FW1| |  | | |     +-------------+   +---+   +--------+  |
|                | |  | | \-i0--|Synchronizer1|---|   |---| PHY1.0 |--|
|         +---+  | |  | |       |             |   |   |   +--------+  |
| PHY1.0--|   |  | |  | \---i1--|             |---| M |---| PHY1.1 |--|
|         |   |  | |  |         | +-----+     |   | A |   +--------+  |
| PHY1.1--| M |  | |  \-----i2--| |DPLL0|     |   | C |---| PHY1.2 |--|
|         | U |  | |            | +-----+     |   | 1 |   +--------+  |
| PHY1.2--| X |  \-|--------i3--| +-----+     |---|   |---| ...    |--|
|         | 1 |    |            | |DPLL1|     |   |   |   +--------+  |
| ...   --|   |----+--------i4--| +-----+     |---|   |---| PHY1.7 |--|
|         |   |                 +-------------+   +---+   +--------+  |
| PHY1.7--|   |                                                       |
|         +---+                                                       |
+---------------------------------------------------------------------+

>
>>As the pins are shared between multiple DPLLs (both inside 1 integrated
>circuit
>>and between multiple integrated circuits), all of them shall have current
>state
>>of the source or output.
>>Pins still need to be shared same as they would be inside of one
>synchronizer
>>chip.
>
>Do I understand correctly that you connect one synchronizer output to
>the input of the second synchronizer chip?

No, I don't recall such use case. At least nothing that needs to exposed
in the DPLL subsystem itself.

BR,
Arkadiusz

>
>>
>>BR,
>>Arkadiusz
