Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E676E5804
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 06:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDRES5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 00:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDRESz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 00:18:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E5B30EB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 21:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681791534; x=1713327534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FizGskOtq0fr4lbXFqKPjilgAlIUwN7Skk76VBxqS4E=;
  b=nA5F6GTYIF3rnibg1xi2cjToiq6LfMs3k1j+tvSnHi+MjJA/uultEIQM
   DoAXBlkoTLlfCmu0Ha175Lk/3iz12R2kyX6oJh/SH32JQzUWvd+4i0WCq
   0HeZXrvD76sgwyX58viJb8CF9vIYcHu6S97x19ejbJGhwKuU92plH8Btv
   04awM2EuxVeDaJWCPn6M798FzLWSpc5zn7ixR5QLz2mnVGIovI8ZYb5mi
   Q4eguYouUt+dldsVSLbnCxF5XpIhs/CB1nx/PHiV2oVzh8TbSk/x2WxBo
   vyOX0ZE3N2pPyllCLVsXqPfTgIz541b9q4C+OYmjJqdd4zmqEwqiCc1Ob
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="325409911"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="325409911"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 21:18:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="780363718"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="780363718"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Apr 2023 21:18:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 21:18:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 21:18:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 21:18:52 -0700
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by SJ2PR11MB7502.namprd11.prod.outlook.com (2603:10b6:a03:4d3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 04:18:50 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 04:18:50 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Brouer, Jesper" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH bpf-next V1 4/5] igc: add XDP hints kfuncs for RX hash
Thread-Topic: [PATCH bpf-next V1 4/5] igc: add XDP hints kfuncs for RX hash
Thread-Index: AQHZcTzyLxexDRn6WUOEsDW09NDjv68wdoRQ
Date:   Tue, 18 Apr 2023 04:18:50 +0000
Message-ID: <PH0PR11MB5830550374DCF59BAEFC5D09D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174344307.593471.11961012266841546530.stgit@firesoul>
In-Reply-To: <168174344307.593471.11961012266841546530.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|SJ2PR11MB7502:EE_
x-ms-office365-filtering-correlation-id: 9911b0d9-befa-4ec0-e104-08db3fc4033c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UBZ2fVbLV6PFS/35UhtcKU7KV7HeEmPLtGS/QF0CxJrdH2ZBTK1CJy5UpxZH6jSQNPoDMUiJH1RJh9COK4P4oMHfryM394bySsdnEyB2dnePGle3uTMORBjIdiwOe9f0VsZE1nMNPyy/9PE1qhAnF27qY8ZUPuJBHWFIRFgZbKpZjLsD4E4AqFY+hQY6h2m1sB3gQmUbxzyRsa+9dVk/p6oO5YrS179THU6xVHzYFrtYyvG81oyy8BrE+wLxF89xHJvpm9CXKCEU8wcARnv4SRV5HILsMVlnzeVXrElJ73OcUdXIQ53YoGsPVRKfeJDTtMuzAkOlGFvw6jhECAdgY/cHHHghBXoiigsByR1ZCVd77ITsgjqDfEtzQwbzIOBZm5196O7LI+8K9g4uxALxQmNntDxLIlc6vWOx4aNp6eFlJ8pIpep+2DHguRdWFMWKdS8JXId6PdDt4FuUM2qJ13LVQs1ZU2WxLAthfwaM3NqrRpt2DprvCoauXvR5OfmbQUgYkPdSikbth+HUzaySU7JH6d3alTkeCEu3fuJyBo9ZozVqZ6VxvVIsSHYMsJca989rrE3mCsiwORr7YGJFyst9nIwQ2jVxRyOdUjJf1n8tKwh1LL7OFVdohGPGY87q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(2906002)(38070700005)(8936002)(8676002)(41300700001)(82960400001)(122000001)(52536014)(7416002)(38100700002)(5660300002)(33656002)(86362001)(55016003)(478600001)(54906003)(110136005)(55236004)(9686003)(6506007)(26005)(71200400001)(186003)(7696005)(53546011)(76116006)(4326008)(316002)(66946007)(66556008)(66476007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L085M1pjbjJ1bk5QdWhjb0NCdjZSbkh3QjB1WEFubWFQYTE2dE92c3BhSkNS?=
 =?utf-8?B?alljKzR5UFB4L0xERlNqZVdNdHFuMEpicHkrL2h4WGNzbitwSjJvKzlXRkdC?=
 =?utf-8?B?Ty9kNDk3ZW9MNzV5eWFVdDRJOGZ0TDVKd0J5VjBYM2VLMnlLdDVna1ZwV0hZ?=
 =?utf-8?B?UEQvZk9XMC90L0ZoaXA0L3NjZ3dZaTVGd0dOV29zcEdTZGhnSEVzd3M4RmUx?=
 =?utf-8?B?ektJUzZaVE9YVzhVdlh0R0FxejdCMjEwckJVVTVFWFVnZXVLM1FRbEVuWE5U?=
 =?utf-8?B?RUZPTTF6RXd2LzdrWk9XRFZCcGt3YWRZeDEvUzA0NTliajVjZzlaTUhKMnF3?=
 =?utf-8?B?S3dDbDdkTHI3Nm83ajhDeXBBdVdjZ2hFQ2UyeFVObVl2QXYxMFNHSFFQSmJT?=
 =?utf-8?B?dTJXUUI1NjA2VDBoc2RycVVDdlpNMWNuQUo2SFgya3M3QmF0MktzZmFad1F1?=
 =?utf-8?B?Tk8wUGVCeG15Sk9rOUtIN3lQVmxpQjZ6YXFkZjdzcmJZSG0wMVlESGdFNk1T?=
 =?utf-8?B?MXN6VmVMaVVGd3dzK2RJcEYyWlVvd3hoU01JT1N4cWVkYWJDMncrTkhpS0po?=
 =?utf-8?B?WFJOT2d4M2xPMHhyU0lpSFpTMDNxbGc3eFd3TVp1MDlBRExKbTJTbGlkaWpG?=
 =?utf-8?B?Sm95Mzd6V0lsWVRqUUNRM0lWUGdyQzhhbE1ibWZPTUxJTmp5WkQ0di9DYzh1?=
 =?utf-8?B?VGxxWExKZG5CRllkOHBkaDd3WEQzUnNCdFozcXZBT3hCUlNONHljNFNkdFo1?=
 =?utf-8?B?SWRLWkEwOUlqdWMwWXdDRUZOM1BvQ293azlxVDB1YTRlZmZtTldoTGV6OWpR?=
 =?utf-8?B?ZGVrUFZYQ2dXZlZwaDFNdnprbXJFcHpab2UrMEFKcXBwM25qSFlkR2kxcmtp?=
 =?utf-8?B?dFFjK0xqOVJhU3haV2ZNMHFNMzZTTG4vOGR3TGFWbVZHcG9pd3VISHJFckYw?=
 =?utf-8?B?dWlNa2R6MXZ6OTNKOGpxeDlnalhvTXZDUXJmVGJOOWJMdWxpa2h2U0dPN2h6?=
 =?utf-8?B?ckZMSzh1WTNkQStiVUVkakt4ZUVoUjlZaGtmWUFlVHgyNElZWm96RW5QcTJn?=
 =?utf-8?B?ZkN2aHRKLy9yc2FrSEJRTGVMcmpSN0tIYUVBVTZsc0R1c1JOanVwK2JrSFZ2?=
 =?utf-8?B?dVdyRmlFcjlNMjFNRmszd1dZYk1LT09IcnhMbE5RSk5KWFhaeUNGeUtyYWl6?=
 =?utf-8?B?TUtDZCtKdzA3VEMxMFNzbWhVVG11UXEvYkJoaU45dXVWbFJwS3phSEcwTDlK?=
 =?utf-8?B?aEphRnpaaERYMmpBWVRKako0ZEtJS3VNbVB1ODJ3cnZCMExZeU1hbEdITzRV?=
 =?utf-8?B?TDQ3SmI4L25sb0dRcjJGU0JiVXRBSzNCWEFaTjV3SDFzWWtURktOTVM5TFhE?=
 =?utf-8?B?K3hMNlVCYm4wWnR0YXNETEE3UC9DbDhUZ0RrTFJJaUN4b3RuY2lxOUVINmhW?=
 =?utf-8?B?R042dlF6U29ZZUl0S3F5MXBlMTBhTFREd01qNkZnMkV3c3J5VFErVis0aTZ0?=
 =?utf-8?B?Z0ZlaG5MSnJGNDFueEJKNkQvTURMWjdLbjg4THhJMWN5NURKeWk5cHZqR1k4?=
 =?utf-8?B?TGVWcEVMOWFZMFBxNU02c0IvdXBIOFhicFdKZWFKL3djVGFUVWIwOEtxR3RL?=
 =?utf-8?B?U0ZRMU5YZXo2YjEyaEw4M05sbGdPMU9pQlRhR2wyOXg1em5PTXk1eWh0OHdF?=
 =?utf-8?B?N0xGUDVCNnBsempyQklKZHB0K1o1MU9IdDlKMlVWR1ozV3p0enkwNllnSHFq?=
 =?utf-8?B?ZHlEVjhmYjZkRlRUdTd0elp5MFhCYkZqemJYbk84b2t6UTJONmYrNjV2dldQ?=
 =?utf-8?B?a0hFSUZ3U090WTM1NjZXYlRabmFGeGlKbDhSMUlVYUJCbERZUVhDYzZZQnNI?=
 =?utf-8?B?QU5tL0JzeEtudUtQK240TndYSnErM1BPOEZ0Nkh6N2lMSkl5RVdtOHo3TE04?=
 =?utf-8?B?VEQ4Rk1LYnRHSkRQa0JyOEhuTjVtN00xenFkdlBCM1AybCtSVktHekptbUxV?=
 =?utf-8?B?TysxVW84ZUQzWGYyZ29qZm1jWVFyWkUzQlA1QWY0RUZzeUJ4SUUrZllVdjFG?=
 =?utf-8?B?U0NlKy9ZMHJESkl0ZC9zQm15T0JLSXVVd0MzdW1OUk9SOE9lcUd6RVJSeERh?=
 =?utf-8?B?ZDA5VURWQ0VBYVJvNXYra3RDbGJCNm5zODRtSGZ0WExWdHAxckRrbHV4cnNv?=
 =?utf-8?B?T1E9PQ==?=
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvXrCHhHfAJf+JbiayZ8Vtxn1RMgrUnGKqPenOxG9sgE7m1hQNuTSRSMwp3hta9iV4TwdSMBRW5ZuEtjVXcqAg9bAWymc53ZnYzrWhPTOQaIfAo0V2xeCkd1LaKX+Ooe4cZLSdVE4ud7ajjRBCUnEyu6AyYbcZcF6P3DLdXDTXwwA4d/bPRCnsBv3bEvx7PWKGC5AylUnXGcjcF9O/RWJ1ewmasPDpu+m6PB497OzyAd1W/v1sv+e0mKEkYDUZPDWQBZKpwLwIeIJ0ENiDu9PyIYQ/TJ86KOqIZKCGOjJE6dVdBa2L6wFK1LZ/EuOadDcuSQsjdZiIvVLnqysBWQ/A==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EScBFjOqNh/xTtCyNJQQRZyCR/R6eL/JC1sIRVCOoE=;
 b=R8ItexZ0B5EbF6IqlcAL/onX1URyCZ1z0EaPmLZgq9qaIYuI8OOKBTD68uDFHffo8kd2lzes+6yzT3dHVlT0gjzABsbfz/2XyvTQyaohF7dOgZWT4QJccpAu7FNuKfHLFXEZB1ZaUEHUBAtyI5gZPcV9+RXscYWPcrkkQupoYcGotvzDiQSEN26JPmLUd0dou8dt3fWW9j+bgLXv+cuF3NxTiZXF8rseEZDTXuwcMX0RwMO5b1+bqhWYUZbVxN+axg0JmsF0GkCCBlICRsjpKDKHSVMBvU2cKt7z/pvL7HC98602OLQtpIRuWiyx/Jl7sHzIlqTUCCFpGWxzYHNdxA==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: PH0PR11MB5830.namprd11.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 9911b0d9-befa-4ec0-e104-08db3fc4033c
x-ms-exchange-crosstenant-originalarrivaltime: 18 Apr 2023 04:18:50.3437 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: Z/6ftgdQaChFKowZJLalUIizSeMqBWWaapwBPWU2KR70iwY/IRAzIqYOrsnDJgs2/JhfeujC5CRx0f9GYaIhoRSPEONMmdDGlAQFkeOjsro=
x-ms-exchange-transport-crosstenantheadersstamped: SJ2PR11MB7502
x-originatororg: intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uZGF5LCBBcHJpbCAxNywgMjAyMyAxMDo1NyBQTSwgSmVzcGVyIERhbmdhYXJkIEJyb3Vl
ciA8YnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPlRoaXMgaW1wbGVtZW50cyBYRFAgaGludHMg
a2Z1bmMgZm9yIFJYLWhhc2ggKHhtb19yeF9oYXNoKS4NCj5UaGUgSFcgcnNzIGhhc2ggdHlwZSBp
cyBoYW5kbGVkIHZpYSBtYXBwaW5nIHRhYmxlLg0KPg0KPlRoaXMgaWdjIGRyaXZlciBkcml2ZXIg
KGRlZmF1bHQgY29uZmlnKSBkb2VzIEwzIGhhc2hpbmcgZm9yIFVEUCBwYWNrZXRzIChleGNsdWRl
cw0KDQpSZXBlYXRlZCB3b3JkOiBkcml2ZXINCg0KPlVEUCBzcmMvZGVzdCBwb3J0cyBpbiBoYXNo
IGNhbGMpLiAgTWVhbmluZyBSU1MgaGFzaCB0eXBlIGlzDQo+TDMgYmFzZWQuICBUZXN0ZWQgdGhh
dCB0aGUgaWdjX3Jzc190eXBlX251bSBmb3IgVURQIGlzIGVpdGhlcg0KPklHQ19SU1NfVFlQRV9I
QVNIX0lQVjQgb3IgSUdDX1JTU19UWVBFX0hBU0hfSVBWNi4NCj4NCj5TaWduZWQtb2ZmLWJ5OiBK
ZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4tLS0NCj4gZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWluLmMgfCAgIDM1DQo+KysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKykNCj4N
Cj5kaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWluLmMN
Cj5iL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+aW5kZXggODYy
NzY4ZDVkMTM0Li4yN2Y0NDhkMGFlOTQgMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWdjL2lnY19tYWluLmMNCj4rKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pZ2MvaWdjX21haW4uYw0KPkBAIC02NTA3LDggKzY1MDcsNDMgQEAgc3RhdGljIGludCBpZ2Nf
eGRwX3J4X3RpbWVzdGFtcChjb25zdCBzdHJ1Y3QgeGRwX21kDQo+Kl9jdHgsIHU2NCAqdGltZXN0
YW1wKQ0KPiAgICAgICByZXR1cm4gLUVOT0RBVEE7DQo+IH0NCj4NCj4rLyogTWFwcGluZyBIVyBS
U1MgVHlwZSB0byBlbnVtIHhkcF9yc3NfaGFzaF90eXBlICovIGVudW0NCj4reGRwX3Jzc19oYXNo
X3R5cGUgaWdjX3hkcF9yc3NfdHlwZVtJR0NfUlNTX1RZUEVfTUFYX1RBQkxFXSA9IHsNCg0KU2lu
Y2UgaWdjX3hkcF9yc3NfdHlwZSBpcyB1c2VkIGluIGlnY19tYWluLmMgb25seSwgc3VnZ2VzdCB0
byBtYWtlIGl0IHN0YXRpYy4NCg0KVGhhbmtzICYgUmVnYXJkcw0KU2lhbmcNCg0KPisgICAgICBb
SUdDX1JTU19UWVBFX05PX0hBU0hdICAgICAgICAgID0gWERQX1JTU19UWVBFX0wyLA0KPisgICAg
ICBbSUdDX1JTU19UWVBFX0hBU0hfVENQX0lQVjRdICAgID0gWERQX1JTU19UWVBFX0w0X0lQVjRf
VENQLA0KPisgICAgICBbSUdDX1JTU19UWVBFX0hBU0hfSVBWNF0gICAgICAgID0gWERQX1JTU19U
WVBFX0wzX0lQVjQsDQo+KyAgICAgIFtJR0NfUlNTX1RZUEVfSEFTSF9UQ1BfSVBWNl0gICAgPSBY
RFBfUlNTX1RZUEVfTDRfSVBWNl9UQ1AsDQo+KyAgICAgIFtJR0NfUlNTX1RZUEVfSEFTSF9JUFY2
X0VYXSAgICAgPSBYRFBfUlNTX1RZUEVfTDNfSVBWNl9FWCwNCj4rICAgICAgW0lHQ19SU1NfVFlQ
RV9IQVNIX0lQVjZdICAgICAgICA9IFhEUF9SU1NfVFlQRV9MM19JUFY2LA0KPisgICAgICBbSUdD
X1JTU19UWVBFX0hBU0hfVENQX0lQVjZfRVhdID0gWERQX1JTU19UWVBFX0w0X0lQVjZfVENQX0VY
LA0KPisgICAgICBbSUdDX1JTU19UWVBFX0hBU0hfVURQX0lQVjRdICAgID0gWERQX1JTU19UWVBF
X0w0X0lQVjRfVURQLA0KPisgICAgICBbSUdDX1JTU19UWVBFX0hBU0hfVURQX0lQVjZdICAgID0g
WERQX1JTU19UWVBFX0w0X0lQVjZfVURQLA0KPisgICAgICBbSUdDX1JTU19UWVBFX0hBU0hfVURQ
X0lQVjZfRVhdID0gWERQX1JTU19UWVBFX0w0X0lQVjZfVURQX0VYLA0KPisgICAgICBbMTBdID0g
WERQX1JTU19UWVBFX05PTkUsIC8qIFJTUyBUeXBlIGFib3ZlIDkgIlJlc2VydmVkIiBieSBIVyAg
Ki8NCj4rICAgICAgWzExXSA9IFhEUF9SU1NfVFlQRV9OT05FLCAvKiBrZWVwIGFycmF5IHNpemVk
IGZvciBTVyBiaXQtbWFzayAgICovDQo+KyAgICAgIFsxMl0gPSBYRFBfUlNTX1RZUEVfTk9ORSwg
LyogdG8gaGFuZGxlIGZ1dHVyZSBIVyByZXZpc29ucyAgICAgICAqLw0KPisgICAgICBbMTNdID0g
WERQX1JTU19UWVBFX05PTkUsDQo+KyAgICAgIFsxNF0gPSBYRFBfUlNTX1RZUEVfTk9ORSwNCj4r
ICAgICAgWzE1XSA9IFhEUF9SU1NfVFlQRV9OT05FLA0KPit9Ow0KPisNCj4rc3RhdGljIGludCBp
Z2NfeGRwX3J4X2hhc2goY29uc3Qgc3RydWN0IHhkcF9tZCAqX2N0eCwgdTMyICpoYXNoLA0KPisg
ICAgICAgICAgICAgICAgICAgICAgICAgZW51bSB4ZHBfcnNzX2hhc2hfdHlwZSAqcnNzX3R5cGUp
IHsNCj4rICAgICAgY29uc3Qgc3RydWN0IGlnY194ZHBfYnVmZiAqY3R4ID0gKHZvaWQgKilfY3R4
Ow0KPisNCj4rICAgICAgaWYgKCEoY3R4LT54ZHAucnhxLT5kZXYtPmZlYXR1cmVzICYgTkVUSUZf
Rl9SWEhBU0gpKQ0KPisgICAgICAgICAgICAgIHJldHVybiAtRU5PREFUQTsNCj4rDQo+KyAgICAg
ICpoYXNoID0gbGUzMl90b19jcHUoY3R4LT5yeF9kZXNjLT53Yi5sb3dlci5oaV9kd29yZC5yc3Mp
Ow0KPisgICAgICAqcnNzX3R5cGUgPSBpZ2NfeGRwX3Jzc190eXBlW2lnY19yc3NfdHlwZShjdHgt
PnJ4X2Rlc2MpXTsNCj4rDQo+KyAgICAgIHJldHVybiAwOw0KPit9DQo+Kw0KPiBjb25zdCBzdHJ1
Y3QgeGRwX21ldGFkYXRhX29wcyBpZ2NfeGRwX21ldGFkYXRhX29wcyA9IHsNCj4gICAgICAgLnht
b19yeF90aW1lc3RhbXAgICAgICAgICAgICAgICA9IGlnY194ZHBfcnhfdGltZXN0YW1wLA0KPisg
ICAgICAueG1vX3J4X2hhc2ggICAgICAgICAgICAgICAgICAgID0gaWdjX3hkcF9yeF9oYXNoLA0K
PiB9Ow0KPg0KPiAvKioNCj4NCg0K
