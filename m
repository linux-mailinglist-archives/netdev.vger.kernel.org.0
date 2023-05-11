Return-Path: <netdev+bounces-1954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5B66FFB7A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDDBF28194E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E2DAD5E;
	Thu, 11 May 2023 20:51:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22052918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:51:50 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FAD1FEE;
	Thu, 11 May 2023 13:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683838308; x=1715374308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DBgGw7OwVwc9lelTCFyGdW+fyULsTIQz0RIotj5/dTw=;
  b=Y4yMOKEGdBVNSLdvVq7NmJhq2aB1C8U7SpsxxXgg6WTlDLzuBq0tGEj/
   y3fxoz+xaR7Kup47x1nGGKo8vo15Gg3sfeOXt12rE5AN+31MJLJZwPWeS
   LArWQdKJ2fT8W8mOfJus8I1ZB4J7ulYO1jYzbKC4Jjpf2gm1LMWxPDP1Z
   UXtK6Itr/O96KrN7YbEzOA3xYGKroJr2yayvCnvAtSyF2fxy/9mMayk+c
   iKX55d/mFktN9/XA1ArLhFU72VBi3s5ReIpY/lmXy4Rk+VZxwhsVSsUsk
   Xngr4jfCv72q7sCJ1WfgjCaMyIEIdYCrMIRiRJnGSHNBZfAFSAA12WH10
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="330248801"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="330248801"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="650374196"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="650374196"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2023 13:51:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:51:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:51:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:51:46 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:51:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9qmlnTj00Hc5DzYSQya5VKOn2S5o+XhiEjQu7tP7epEghgp5nQZR//BMVfUEDhpCT6vZK2Me29jmKpNrHxJK37ZUsksBEqtK5KMcoojzhxGkUzSJSRyp+dyXKfov89F94anebcl73I2knCQyTfbghXus08qoeujjHoEz0wsDTf/mu4tsJEFsK1hw1vB/980KSrX632tgOgWOgu1Gv5iy2KoW0pgV6HoRd86DaUPyC1vZ/VNKnUz/LRHTZrVYpicl6qeY3/aRVWcvonsEYNPuf9i/IcbGpPFWEJRlt7fpeevivLGAPyREWBa6YFw0fduHowapEwyHlIxv2PSR0fgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjsA8RXEYCLSxfdoDDL3iomDLcg9bJ/Iboi2brvaLto=;
 b=BtakPzAgYD2wAWJnUAOMAmb44T845UDBYZJJfPJ5UHpMho0mxPvtDnO4uquFhOz4yyagpaQGQxjRN6QCETxSvgrSFmiKvYvENpQ9xPoN/GyFjFBr1+txekKEqW0nTfRqvsc0t3og36anN72MNAPf/oolj9Rie3uIJag/EXffZo/4BJQUqtmwiW5xAkQzOSlygmYIPjFn+P6/PGcL21jgpGT3aAQ7tLzxm8mQgCkoBZoMVnxbFrLscByda0LWjFzRR15DN3fQAveQnwfYSdrTlE8vs0fR4/dDUOEvBoQevttX+F9gUE6bPqypyhlEVrTV099sucl4jO02Rjha9dlfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CH0PR11MB5457.namprd11.prod.outlook.com (2603:10b6:610:d0::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20; Thu, 11 May 2023 20:51:43 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.022; Thu, 11 May 2023
 20:51:43 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAChnlwIAABXaAgACPXPA=
Date: Thu, 11 May 2023 20:51:43 +0000
Message-ID: <DM6PR11MB4657924148B84F502A44903D9B749@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com> <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
 <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <ZFygbd1H+VdvCTyH@nanopsycho>
In-Reply-To: <ZFygbd1H+VdvCTyH@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CH0PR11MB5457:EE_
x-ms-office365-filtering-correlation-id: 78db035f-8afc-4895-6eec-08db526186ec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JlIP9XOi3gLaG4WVXOYn6sMU6hL1PN9L6pGOJ/Wpf5cCsiI90DF6j0+dOrCYbH3olSd7CARJJ7w13qiIc94lMQ5rHCZsGrgQlD7z6Y+hh9ovLNMnxoigYh9PFxOpVLARxlGPDhzXrUguJRz/cPh6f6Yx/AmZw7Vox/vH1TaB7Dsw745lw1g0UHT0FbLsi5/yuDcX6ceKtwjarupDichzSZuSGZq7yxDDWOPLyn1j45nAMA93vShZxtt/BPDlAma888BGZNiKNwFrcEBVihrRLm5QW5wwqBrx04OAupdgWNOxkksrSg9PMUqplMVmR6KaGYhaL+gdOHadx0yRvkHzF+RzVaNFbq1gge1h+HttQZAyd7gA4lzBLXEnbOmzTTVZpRJicmm8qVNO86CTlqXHai8ncDty7cm3BXlvCLTnFxrJdEDGc64ABrUUW9F6ZlHsleISk0aZJOpNl0qpQzR3+mT0bqqehDOdYpWRWGPMPnAdN8/h6gASVwXKg3e8U8sIB0K2IdHoCPr0BPCoRLBAJ3gMWkzmOcwYP6b3TnR9rxHZNRt9AX28Cp2E6TOW2F0XHBDxkrWQD1AWJBgbDmhQu90I69msRJQtpy6fWjeZZMjb03VJHei0QKgM91jP87+X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199021)(52536014)(7416002)(5660300002)(54906003)(478600001)(7696005)(71200400001)(41300700001)(8936002)(8676002)(316002)(9686003)(6506007)(66946007)(66476007)(4326008)(66556008)(66446008)(6916009)(76116006)(64756008)(82960400001)(2906002)(83380400001)(186003)(122000001)(55016003)(33656002)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eIp6J+BMZvDmfXB5W0VnrmSLhk5+xvOuaAI9etBkrPFwxQctffgSVFXU0e/m?=
 =?us-ascii?Q?KjeB2UXvzylQR/m+u7KXhf+0mgsee3PC4oae72+t03gE5AuUpPL/L1kI0le1?=
 =?us-ascii?Q?YfJDhf9uyp3Jt8Q0Hdey50WUc5DgyI6gqUW+UvHYDw3+1yMhCARg3BJqokdq?=
 =?us-ascii?Q?gmg0IXY9BvjTY+wQaV1qqQhKsHxFRAhPyRmBgZguVYYCEqYzc//VOF8TV0cE?=
 =?us-ascii?Q?zwJDriugCBa4ExS///x9z7/tRaBvoqqLKkAiiQ32afmeH0YhZ1OoIZUy+kpx?=
 =?us-ascii?Q?daZGy0otWagK7iHdLKwcTWt1+VcLoCfQ/VWkF3YtFvs6D4OOZnuzVyivAI50?=
 =?us-ascii?Q?VTHxOkfAzU6ETRdV71mc4Ddrw1grH8nnsy3UZLLLACv/vfSMbG8DZU1yycY1?=
 =?us-ascii?Q?MOwpPcMbAgMv/Y6dfzyKQTNpcpki0BhgdfiA3soi03xUpb1Urt6mZEj92D93?=
 =?us-ascii?Q?QEJQq/Ci1Rv9IxhwBZucJjhMgv3HM0c+hNRn5mTdW041b9Ef6ZxwxJa9NlhY?=
 =?us-ascii?Q?b1ytbwPL/Nez//mSLWwjPmUz+qz5Xo1rns32/4hY0tZ9Gkss2DflMZYcsOx6?=
 =?us-ascii?Q?CvZBJ2qEp3pLHcM9AzryskXNCc7d6aISLvt3pcZkcRpySWQmGm2DB2KMcjq1?=
 =?us-ascii?Q?VdyQMPk1pOm/5jKoPCL6VxSNZiJ+CQMMMvVD1JTleewQ3f9Nb2H/FqX8qKDt?=
 =?us-ascii?Q?iKFfHH97ZY1g12i9iD2bhpxe2dRICXQXiSpCYoJMKxo19m3TSPq0ML+L4dfm?=
 =?us-ascii?Q?JNraoiQK52FaIIRzZWzrDD+86RBUQypmsA/yUfv9zBMc8sAyG1pib0akzjGJ?=
 =?us-ascii?Q?Sc5kg6yum0cZWX/w1W+9IKx2gX4TElbZEJQR68+iG1lzh2md09qniZ5RWCnE?=
 =?us-ascii?Q?h25VF1MiWrw9z5g21/H6+xWhUSOwuWZ5Liop3sg6bi3F9V6/cgzNrtsRGcKn?=
 =?us-ascii?Q?0SBD5pOxYLNwsiZy8wcdYfxrlD59LHJVyOIHmfnaxAFg8QBjYTfq4enu1U+F?=
 =?us-ascii?Q?L7zTbmLPxD7tcbeyEfmgln1WsTVliKp51nWS/HQ5qpjLKYJ6DY9kwZq2dLbE?=
 =?us-ascii?Q?SE0gIRDCC9WacsCG2iqjBTJpULZE1WTtlHfbK+YYXY4qvW27f7RyWNT4MjFX?=
 =?us-ascii?Q?GsUaV0hvuH7TdVtZNxbealSwU12IDZ1S+YXl4XkYdig00xszlINGLmI1RVJs?=
 =?us-ascii?Q?sBGgh5WKMvxAzD4nt5QkbLvz0a4mBjFvQoB84EC+x+tdCEoEHEjxhS24xgcd?=
 =?us-ascii?Q?sbU56yCWVfHtJpQF3JqvRKW6qDOHzubRVY4aokIzlJjPD5eeIwjtnhfHcgwu?=
 =?us-ascii?Q?HNHo0v3aoTSJI3IrgvcFC7fceTE/TV4e0QjZBeFPNexh54fDI1hmgZucfLW2?=
 =?us-ascii?Q?4WruhQ0hYI8UXORU3bMvOtvYhtTSIkkrbcdd9IENDH6yP1se0d2xBw7udwNE?=
 =?us-ascii?Q?rGzsL9DFDKPbQpNB6FW4I0vcW3a/F1adSVcjDmm4IyWHOXv7QpPMkojojp//?=
 =?us-ascii?Q?o7dmd4Exxc2JtwQTiGbChS7eGDT0MaJfZqZ5aHLoDdmilxRybZGN6JRnHhdI?=
 =?us-ascii?Q?OFlb3PxUcM5xk52tN/liPP03erUSkMIYK3QdBj6D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 78db035f-8afc-4895-6eec-08db526186ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 20:51:43.1471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g65LE13fBKu1d9V0XOaau/hB0F6psKMDL9a9ZrT2cRNLh17DT8d1idtXboNE1zY46NieXidd7/KWFXRn0lQYESq5k9lxXBA0bx7MzUcFA+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5457
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, May 11, 2023 10:00 AM
>
>Thu, May 11, 2023 at 09:40:26AM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jakub Kicinski <kuba@kernel.org>
>>>Sent: Thursday, May 4, 2023 11:25 PM
>>>
>>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>>>> >+definitions:
>>>> >+  -
>>>> >+    type: enum
>>>> >+    name: mode
>>>> >+    doc: |
>>>> >+      working-modes a dpll can support, differentiate if and how dpl=
l
>>>>selects
>>>> >+      one of its sources to syntonize with it, valid values for
>>>>DPLL_A_MODE
>>>> >+      attribute
>>>> >+    entries:
>>>> >+      -
>>>> >+        name: unspec
>>>>
>>>> In general, why exactly do we need unspec values in enums and CMDs?
>>>> What is the usecase. If there isn't please remove.
>>>
>>>+1
>>>
>>
>>Sure, fixed.
>>
>>>> >+        doc: unspecified value
>>>> >+      -
>>>> >+        name: manual
>>>
>>>I think the documentation calls this "forced", still.
>>>
>>
>>Yes, good catch, fixed docs.
>>
>>>> >+        doc: source can be only selected by sending a request to dpl=
l
>>>> >+      -
>>>> >+        name: automatic
>>>> >+        doc: highest prio, valid source, auto selected by dpll
>>>> >+      -
>>>> >+        name: holdover
>>>> >+        doc: dpll forced into holdover mode
>>>> >+      -
>>>> >+        name: freerun
>>>> >+        doc: dpll driven on system clk, no holdover available
>>>>
>>>> Remove "no holdover available". This is not a state, this is a mode
>>>> configuration. If holdover is or isn't available, is a runtime info.
>>>
>>>Agreed, seems a little confusing now. Should we expose the system clk
>>>as a pin to be able to force lock to it? Or there's some extra magic
>>>at play here?
>>
>>In freerun you cannot lock to anything it, it just uses system clock from
>>one of designated chip wires (which is not a part of source pins pool) to
>>feed the dpll. Dpll would only stabilize that signal and pass it further.
>>Locking itself is some kind of magic, as it usually takes at least ~15
>>seconds before it locks to a signal once it is selected.
>>
>>>
>>>> >+      -
>>>> >+        name: nco
>>>> >+        doc: dpll driven by Numerically Controlled Oscillator
>>>
>>>Noob question, what is NCO in terms of implementation?
>>>We source the signal from an arbitrary pin and FW / driver does
>>>the control? Or we always use system refclk and then tune?
>>>
>>
>>Documentation of chip we are using, stated NCO as similar to FREERUN, and
>it
>
>So how exactly this is different to freerun? Does user care or he would
>be fine with "freerun" in this case? My point is, isn't "NCO" some
>device specific thing that should be abstracted out here?
>

Sure, it is device specific, some synchronizing circuits would have this
capability, while others would not.
Should be abstracted out? It is a good question.. shall user know that he i=
s in
freerun with possibility to control the frequency or not?
Let's say we remove NCO, and have dpll with enabled FREERUN mode and pins
supporting multiple output frequencies.
How the one would know if those frequencies are supported only in
MANUAL/AUTOMATIC modes or also in the FREERUN mode?
In other words: As the user can I change a frequency of a dpll if active
mode is FREERUN?

I would say it is better to have such mode, we could argue on naming though=
.

>
>>runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
>>dividers before it reaches the output).
>>It doesn't count as an source pin, it uses signal form dedicated wire for
>>SYSTEM CLOCK.
>>In this case control over output frequency is done by synchronizer chip
>>firmware, but still it will not lock to any source pin signal.
>>
>>>> >+    render-max: true
>>>> >+  -
>>>> >+    type: enum
>>>> >+    name: lock-status
>>>> >+    doc: |
>>>> >+      provides information of dpll device lock status, valid values =
for
>>>> >+      DPLL_A_LOCK_STATUS attribute
>>>> >+    entries:
>>>> >+      -
>>>> >+        name: unspec
>>>> >+        doc: unspecified value
>>>> >+      -
>>>> >+        name: unlocked
>>>> >+        doc: |
>>>> >+          dpll was not yet locked to any valid source (or is in one =
of
>>>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>>> >+      -
>>>> >+        name: calibrating
>>>> >+        doc: dpll is trying to lock to a valid signal
>>>> >+      -
>>>> >+        name: locked
>>>> >+        doc: dpll is locked
>>>> >+      -
>>>> >+        name: holdover
>>>> >+        doc: |
>>>> >+          dpll is in holdover state - lost a valid lock or was force=
d by
>>>> >+          selecting DPLL_MODE_HOLDOVER mode
>>>>
>>>> Is it needed to mention the holdover mode. It's slightly confusing,
>>>> because user might understand that the lock-status is always "holdover=
"
>>>> in case of "holdover" mode. But it could be "unlocked", can't it?
>>>> Perhaps I don't understand the flows there correctly :/
>>>
>>>Hm, if we want to make sure that holdover mode must result in holdover
>>>state then we need some extra atomicity requirements on the SET
>>>operation. To me it seems logical enough that after setting holdover
>>>mode we'll end up either in holdover or unlocked status, depending on
>>>lock status when request reached the HW.
>>>
>>
>>Improved the docs:
>>        name: holdover
>>        doc: |
>>          dpll is in holdover state - lost a valid lock or was forced
>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>	  if it was not, the dpll's lock-status will remain
>
>"if it was not" does not really cope with the sentence above that. Could
>you iron-out the phrasing a bit please?


Hmmm,
        name: holdover
        doc: |
          dpll is in holdover state - lost a valid lock or was forced
          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
          if dpll lock-state was not DPLL_LOCK_STATUS_LOCKED, the
          dpll's lock-state shall remain DPLL_LOCK_STATUS_UNLOCKED
          even if DPLL_MODE_HOLDOVER was requested)

Hope this is better?


Thank you!
Arkadiusz

[...]

