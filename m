Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374796E581C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 06:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjDREfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 00:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjDREfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 00:35:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EDE49EA
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 21:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681792503; x=1713328503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Je7GPL+LJP7PLAVe3irma4Ogw9IqYi2eit4aXQafUFY=;
  b=FNmUIdewUeSi9xcapLr8mTl8jELQK7gk7C+nDYp3nyxTn7sbmrpPm7Bi
   JyBNeuhatCeO+DQZl6f27dNG2cSjRWGExKz2knJQVd9eBTXv0rdsS6czZ
   TEAw1pdgkBN86doWawS7svPhhNR9U1UF0NWO4PjpK71zyF2/UDIJ9uQFB
   kJjTaRHfpmaT84bzYx5uTJInPJo5aZBBHMz0t++Ydjy5SEPUu10hUwe40
   t9bklT9fsEY/yG70iW7xKWEiMBLxGTp8afDnTbh77oVIYLfkuqNZ7u6OD
   1WE++CjNJsGr+L+TrE1fBw2/SGz/o0sPCvSq89mqkPlBRRHmyugsfdFfH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="372951570"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="372951570"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 21:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="1020667334"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="1020667334"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 17 Apr 2023 21:35:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 21:35:01 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 21:35:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 21:35:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 21:35:01 -0700
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by DM4PR11MB7183.namprd11.prod.outlook.com (2603:10b6:8:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 04:34:52 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 04:34:52 +0000
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
Subject: RE: [PATCH bpf-next V1 2/5] igc: add igc_xdp_buff wrapper for
 xdp_buff in driver
Thread-Topic: [PATCH bpf-next V1 2/5] igc: add igc_xdp_buff wrapper for
 xdp_buff in driver
Thread-Index: AQHZcTzsnAe6U9nIUE+jaLPBuHApcK8weMVQ
Date:   Tue, 18 Apr 2023 04:34:52 +0000
Message-ID: <PH0PR11MB5830DD3BA9F6CBDA648F5AF8D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174343294.593471.10523474360770220196.stgit@firesoul>
In-Reply-To: <168174343294.593471.10523474360770220196.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|DM4PR11MB7183:EE_
x-ms-office365-filtering-correlation-id: 71c554fa-c605-4a40-1dc4-08db3fc640be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nj1+6KTnJKkWkq35emk2V/lwNhkaWFQmkVMILsE0m53+l7Xf8yJeTO3JnfX2OYEookufTzf/YjGhqLspRsJlAIHNxwb1zha8dv6eu524Xh95YNvmZGdDhnYu4HPFyauTp5sFKw3cLj07tcGo1ZOZSe4HLvJsTbC7pTiayMlcBZG30Smw6K3foAhynLKXVmO52YEo2FCrBm2DsJFlqHtR186BQEnldaIPMOa+xgV0XAeGwfxkXye2mQoi1F9Ah8UQGlu2uCMhjyrIIDAwvQn0OrMTRqojaZoN5+b1UYPJc1eow7Uk1MJBUBalgVAXaY+cQ+CNtgpwpR0eB7LXQM7KW7Yt8n94ARyxrA+UNFyBQxr/u+DPM8k5A8Ca/qc+LcGRU+ry/qXVcXzQDbPb3m376fKcMIQNs+ZTa8Sqn/awJXxtZqBEZOS2RnW0r4zMM5VeELuitONycVFAWaP3qJ58fb6TAfYOAGLt6Qg9c3e/rDaLVEzj5LUw34Z78NCflfeyn6PRr/zgoYY+e/mop6Cog9uNoE9g3TGI9UKqXRmOaL/7y3ggU1D17sBH4wcLlA+7HtHLVLxSzPQk1SK4yUKUeM2akmPyzQxcMdxq837tgBJ79TtGRgeBj+HodGWEXSFw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199021)(53546011)(26005)(9686003)(55236004)(6506007)(122000001)(316002)(41300700001)(186003)(82960400001)(110136005)(7696005)(33656002)(478600001)(71200400001)(54906003)(66946007)(66446008)(86362001)(64756008)(66476007)(76116006)(66556008)(55016003)(4326008)(7416002)(5660300002)(52536014)(38100700002)(8936002)(8676002)(38070700005)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTVTdk9GOU5vWkE0R0dNNTZQWUVsb3RXS1lNb3ljR21tZElpN3NuWXl5bXlr?=
 =?utf-8?B?WFArcEdXSFFpbWhKMktqdURHaGRYc215bEN0ZEgwSlRKQXRYTHlCZGlyT3pn?=
 =?utf-8?B?dzJNNlY3YmF1Q3c3QlZ0K1NGOVFWUnB5S3BRVnF1bVkvSHRQSGkzN2krSlNk?=
 =?utf-8?B?S0JvYkg2RUNWWHpncVhQaW1KUTBjTGZETkhsRk9VeVE3U2FQWUQxRW5rK0Ey?=
 =?utf-8?B?ZG1RWjFHbVJNMHNrVWkraXczcCsxSGlDRVRPdXFjSjExT3hWTFBqQmEzVHRs?=
 =?utf-8?B?a0Q1TWVDSjhZRFg1eTNJcENnMitJSmtoUUtJSncyWmxIN0hOU1VmTmNiRjdD?=
 =?utf-8?B?Z2pwamxwQm5ibjNLeHJGMmhxWUZnbHZPSzdYS25pTDRKaWIyM2V5SFArRzhw?=
 =?utf-8?B?azFUWG52OXVDa2w1c2NFa2ZseWtROXlYejlxTHZ3aHFqazhLQnlQUjR3a3lQ?=
 =?utf-8?B?U2dmR2cxQ09kNEZRazB2cS8ydDVnOVYrL3V4QmxITEp1RWdmR0hjc2ptU0pN?=
 =?utf-8?B?UHMwOGhwdG1EKzJMdVh4ZDJqT3RNSDB0NnI1SHA1Y0pyRXVnMmhTTGhLWE1P?=
 =?utf-8?B?RUQwWkNva2drOUNXUW9VUWVTSUJLeXN4dTVLbVV4ZzZFQXNtYWk0OVdlT2d6?=
 =?utf-8?B?dTJzMUVkdU13SmF4VHVYRU1meGV5QnpibDljSUJnUjJBTlhzeWNxc3RUTnNY?=
 =?utf-8?B?V3F3UGRtSGYrUWNGM0piWUtZMklhbHQrbjZ1K1Bqeksrb1JrRFBvdWVkeEhW?=
 =?utf-8?B?WHVkMVI0c1BpdFFzdG9ERVUxUDN0dDZIRWEwWWs1aCtHWStra2RTWXBKdzBk?=
 =?utf-8?B?aVY2MFNaaitqYU9hS0ZCVDdqWXQ5cDZ4K0RTT1lmek1GZGEvYkIzVDZoVnNk?=
 =?utf-8?B?ZGJDUVM4SFEzZUw5a1A4c2UvZUhpUmU3V0ppODc3akZiRXRTazhtaGVvQ3Jk?=
 =?utf-8?B?cmJ2c05RVUNCZmZGR1o2N2IxY0NXSmNvcnpVTno1c296NldpMmQ0NUZjOEdh?=
 =?utf-8?B?dU9rR1dXRWk0QmpkRjd2Q2h0VmdaeklwNGlBcjVyZFlySEZhZUxrTDFpSk5l?=
 =?utf-8?B?aGZ3aXBlL1lHZ3cxbmt0UkQ1RmpXemZZTit6dzdlcnNoVG5jL0tDcXpValN5?=
 =?utf-8?B?QU44RFNYbko3MUEzdjhxeGc3bmNJMWdsMWVCMW9PaEIyS0FlVG81RS9pb1BP?=
 =?utf-8?B?aFY2SEkyc2pxZnFSY2pkOGNkeW9yUEM2dVFnbjQySVVldmtuajZXVWM0TEJo?=
 =?utf-8?B?bGFzTnpJakRoZDAwU3c2S2d5clRwSkszSUNFdHVWVktySnZxcDM4Uk83MUtw?=
 =?utf-8?B?YUFHTkJtYUhaNzZUZ1dBYWdBOCsvVm9HRlVqK21xYmdSSm1STXh4dll1ZFRi?=
 =?utf-8?B?VW1IRjkxWkxMM25vUGlNMm1kV003Sk5LMGVWak9ySnUrcjNTZHY0V08xeGhz?=
 =?utf-8?B?QVdVU3hkdGFScXcrNSsyUDF0VDNxNVMyUmpGTDNWRm9XWWRsMXJMWldFWU9K?=
 =?utf-8?B?eitYN1hvS3NQa0NlUE9iRFh3V0NVdmRyVllmdXJTNVhpamY4Wm9jTmdnNkpG?=
 =?utf-8?B?ZEt6QU4vYWYxNDI0MnZEd1hDOUxVNmdYOGxaZDg1L0U1Z2lYdzdIb0FlaFlK?=
 =?utf-8?B?V21NNEl2Ym1NY1dYNzVsUmQ0K09BOC9neDJZaG56NVVVU3RBL01ISVZYZkpT?=
 =?utf-8?B?TytIeThENWIzaEV3YXJJMzdXdkhiNzQza0NXOXJvdE1PbmRGc08vdDY5QUdM?=
 =?utf-8?B?OHJqdHlXSTkvbm11WGIzOUFOWEwrb0YyV1RBUGRqWk53cmhqSnJnNGQ2ZW1s?=
 =?utf-8?B?SHhIOXcrVkM1dzFXNkVMMjFRakRRdzZKR0hBbmRsajJ2SzBVY3F0b1kya3lq?=
 =?utf-8?B?WlV3eUwrY015bjlpcCtRVHU2aEVHdHhPSzROWmp6NVIzRm1sRTBaZmlwMG1P?=
 =?utf-8?B?NW1jckFzWjhWTldmYllrc3NoZWtXS3RlQ3hRenJmMkExY2NnT24vLytwYmg0?=
 =?utf-8?B?NXUya2ZZTmcyYWpudFFqK3VwT2Q4R3I2RzhDSXhyOTRvTFYwbFlQS2Y5ckVU?=
 =?utf-8?B?NzZZY0ZNM1VvZzJ3OWozMlRBckNZOHhtaXY3cjdPSDRsZ3VuUDNmNXVEZEpX?=
 =?utf-8?B?RU5LVEphWWZCTU5peElaSHMzbmNURmk4RklSQVl1TUlGU2FUWkpQVEx6MDU5?=
 =?utf-8?B?RGc9PQ==?=
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biDJkpk0QKu1loWiu/NwsgwOJ1rdNnOwkav7tZl4lkd6xfOcNH5J4c9R5t0P6kCjuv66JNhvEdc77YFd+VLmy0q/hOX+/sRbZTjOiFM/W0Qf3sU/hwUg+SFdu+K43OF3SuBAkwYFtkpcb4LEWCJFaNcyzJkjmflzcJfoPqXa6DOi0FMDga8j9tQ2c09QzGKi2hLRoQVnYfflAJIMdch42wIhAOgJSxXZ2Wo1rjp7qwqhk7c0oxIcPq18sT8p6kSsVbA2nx7yv2GIT9PxUlw0cV5j5R66nGRWJIhlWdnmsQZ2oW7aHL3zgDkmLM1cYPXteySWUAWyp9JuGlyQoD1JPA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rof/lRN1J79ZluySs7u0p2TklK45ngigczsHy2owLgU=;
 b=LXVU+lTfdERVLkpgWnkHv2xLGioX8P3lkkfSvwXcTU/e/q/GVg3Xa+f2+DMqlwhG0p15O4MdHDUSFKxSU+LFPYKYEuOGE9bzC10xetqTF/lWW0FJ0Va2GUlBWikjJT6NcA9iPfnBGbwr+TgxebEsaYFM70V5WnTcBtfPoOhVKR4s2TcgVJe/xGC9Um7rpojaFpggXyPawWJ804/JyyuBpZCRWdO4USRXO+WZ8dex7slDagePKR52eEIcbQ1+1U/fASr2DDQ53COQxpZOh6jkymssCOmg5fdbXBAIuOW5aSwZZrT/Zopc0BKtvu+QIgEQMv/HZRC7QPGEp6+HKh810A==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: PH0PR11MB5830.namprd11.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 71c554fa-c605-4a40-1dc4-08db3fc640be
x-ms-exchange-crosstenant-originalarrivaltime: 18 Apr 2023 04:34:52.4989 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: AfU1xHFRhwVgKKs4daZpN6pVP7Yo1wG7WzUbpQm3AEFcm/Jqt4eDxqLIB2cX6xBGuT54KznaMzs7dFpZ1spIS4DOPWNu5Z81U+jB8RiVObQ=
x-ms-exchange-transport-crosstenantheadersstamped: DM4PR11MB7183
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uZGF5LCBBcHJpbCAxNywgMjAyMyAxMDo1NyBQTSwgSmVzcGVyIERhbmdhYXJkIEJyb3Vl
ciA8YnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPkRyaXZlciBzcGVjaWZpYyBtZXRhZGF0YSBk
YXRhIGZvciBYRFAtaGludHMga2Z1bmNzIGFyZSBwcm9wYWdhdGVkIHZpYSB0YWlsDQo+ZXh0ZW5k
aW5nIHRoZSBzdHJ1Y3QgeGRwX2J1ZmYgd2l0aCBhIGxvY2FsbHkgc2NvcGVkIGRyaXZlciBzdHJ1
Y3QuDQo+DQo+WmVyby1Db3B5IEFGX1hEUC9YU0sgZG9lcyBzaW1pbGFyIHRyaWNrcyB2aWEgc3Ry
dWN0IHhkcF9idWZmX3hzay4gVGhpcw0KPnhkcF9idWZmX3hzayBzdHJ1Y3QgY29udGFpbnMgYSBD
QiBhcmVhICgyNCBieXRlcykgdGhhdCBjYW4gYmUgdXNlZCBmb3IgZXh0ZW5kaW5nDQo+dGhlIGxv
Y2FsbHkgc2NvcGVkIGRyaXZlciBpbnRvLiBUaGUgWFNLX0NIRUNLX1BSSVZfVFlQRSBkZWZpbmUg
Y2F0Y2ggc2l6ZQ0KPnZpb2xhdGlvbnMgYnVpbGQgdGltZS4NCj4NCg0KU2luY2UgdGhlIG1haW4g
cHVycG9zZSBvZiB0aGlzIHBhdGNoIGlzIHRvIGludHJvZHVjZSBpZ2NfeGRwX2J1ZmYsIGFuZA0K
eW91IGhhdmUgYW5vdGhlciB0d28gcGF0Y2hlcyBmb3IgdGltZXN0YW1wIGFuZCBoYXNoLA0KdGh1
cywgc3VnZ2VzdCB0byBtb3ZlIHRpbWVzdGFtcCBhbmQgaGFzaCByZWxhdGVkIGNvZGUgaW50byBy
ZXNwZWN0aXZlIHBhdGNoZXMuDQoNCj5TaWduZWQtb2ZmLWJ5OiBKZXNwZXIgRGFuZ2FhcmQgQnJv
dWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4tLS0NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWdjL2lnYy5oICAgICAgfCAgICA2ICsrKysrKw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pZ2MvaWdjX21haW4uYyB8ICAgMzAgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0N
Cj4gMiBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPg0K
PmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjLmgNCj5iL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2MuaA0KPmluZGV4IGY3ZjllMjE3ZTdiNC4u
YzYwOWEyZTY0OGY4IDEwMDY0NA0KPi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ln
Yy9pZ2MuaA0KPisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2MuaA0KPkBA
IC00OTksNiArNDk5LDEyIEBAIHN0cnVjdCBpZ2NfcnhfYnVmZmVyIHsNCj4gICAgICAgfTsNCj4g
fTsNCj4NCj4rLyogY29udGV4dCB3cmFwcGVyIGFyb3VuZCB4ZHBfYnVmZiB0byBwcm92aWRlIGFj
Y2VzcyB0byBkZXNjcmlwdG9yDQo+K21ldGFkYXRhICovIHN0cnVjdCBpZ2NfeGRwX2J1ZmYgew0K
PisgICAgICBzdHJ1Y3QgeGRwX2J1ZmYgeGRwOw0KPisgICAgICB1bmlvbiBpZ2NfYWR2X3J4X2Rl
c2MgKnJ4X2Rlc2M7DQoNCk1vdmUgcnhfZGVzYyB0byA0dGggcGF0Y2ggKFJ4IGhhc2ggcGF0Y2gp
DQoNCj4rfTsNCj4rDQo+IHN0cnVjdCBpZ2NfcV92ZWN0b3Igew0KPiAgICAgICBzdHJ1Y3QgaWdj
X2FkYXB0ZXIgKmFkYXB0ZXI7ICAgIC8qIGJhY2tsaW5rICovDQo+ICAgICAgIHZvaWQgX19pb21l
bSAqaXRyX3JlZ2lzdGVyOw0KPmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pZ2MvaWdjX21haW4uYw0KPmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19t
YWluLmMNCj5pbmRleCBiZmE5NzY4ZDQ0N2YuLjNhODQ0Y2Y1YmUzZiAxMDA2NDQNCj4tLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYw0KPisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+QEAgLTIyMzYsNiArMjIzNiw4IEBA
IHN0YXRpYyBib29sIGlnY19hbGxvY19yeF9idWZmZXJzX3pjKHN0cnVjdCBpZ2NfcmluZw0KPipy
aW5nLCB1MTYgY291bnQpDQo+ICAgICAgIGlmICghY291bnQpDQo+ICAgICAgICAgICAgICAgcmV0
dXJuIG9rOw0KPg0KPisgICAgICBYU0tfQ0hFQ0tfUFJJVl9UWVBFKHN0cnVjdCBpZ2NfeGRwX2J1
ZmYpOw0KPisNCj4gICAgICAgZGVzYyA9IElHQ19SWF9ERVNDKHJpbmcsIGkpOw0KPiAgICAgICBi
aSA9ICZyaW5nLT5yeF9idWZmZXJfaW5mb1tpXTsNCj4gICAgICAgaSAtPSByaW5nLT5jb3VudDsN
Cj5AQCAtMjUyMCw4ICsyNTIyLDggQEAgc3RhdGljIGludCBpZ2NfY2xlYW5fcnhfaXJxKHN0cnVj
dCBpZ2NfcV92ZWN0b3INCj4qcV92ZWN0b3IsIGNvbnN0IGludCBidWRnZXQpDQo+ICAgICAgICAg
ICAgICAgdW5pb24gaWdjX2Fkdl9yeF9kZXNjICpyeF9kZXNjOw0KPiAgICAgICAgICAgICAgIHN0
cnVjdCBpZ2NfcnhfYnVmZmVyICpyeF9idWZmZXI7DQo+ICAgICAgICAgICAgICAgdW5zaWduZWQg
aW50IHNpemUsIHRydWVzaXplOw0KPisgICAgICAgICAgICAgIHN0cnVjdCBpZ2NfeGRwX2J1ZmYg
Y3R4Ow0KPiAgICAgICAgICAgICAgIGt0aW1lX3QgdGltZXN0YW1wID0gMDsNCj4tICAgICAgICAg
ICAgICBzdHJ1Y3QgeGRwX2J1ZmYgeGRwOw0KPiAgICAgICAgICAgICAgIGludCBwa3Rfb2Zmc2V0
ID0gMDsNCj4gICAgICAgICAgICAgICB2b2lkICpwa3RidWY7DQo+DQo+QEAgLTI1NTUsMTMgKzI1
NTcsMTQgQEAgc3RhdGljIGludCBpZ2NfY2xlYW5fcnhfaXJxKHN0cnVjdCBpZ2NfcV92ZWN0b3IN
Cj4qcV92ZWN0b3IsIGNvbnN0IGludCBidWRnZXQpDQo+ICAgICAgICAgICAgICAgfQ0KPg0KPiAg
ICAgICAgICAgICAgIGlmICghc2tiKSB7DQo+LSAgICAgICAgICAgICAgICAgICAgICB4ZHBfaW5p
dF9idWZmKCZ4ZHAsIHRydWVzaXplLCAmcnhfcmluZy0+eGRwX3J4cSk7DQo+LSAgICAgICAgICAg
ICAgICAgICAgICB4ZHBfcHJlcGFyZV9idWZmKCZ4ZHAsIHBrdGJ1ZiAtIGlnY19yeF9vZmZzZXQo
cnhfcmluZyksDQo+KyAgICAgICAgICAgICAgICAgICAgICB4ZHBfaW5pdF9idWZmKCZjdHgueGRw
LCB0cnVlc2l6ZSwgJnJ4X3JpbmctPnhkcF9yeHEpOw0KPisgICAgICAgICAgICAgICAgICAgICAg
eGRwX3ByZXBhcmVfYnVmZigmY3R4LnhkcCwgcGt0YnVmIC0gaWdjX3J4X29mZnNldChyeF9yaW5n
KSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWdjX3J4X29mZnNl
dChyeF9yaW5nKSArIHBrdF9vZmZzZXQsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHNpemUsIHRydWUpOw0KPi0gICAgICAgICAgICAgICAgICAgICAgeGRwX2J1ZmZf
Y2xlYXJfZnJhZ3NfZmxhZygmeGRwKTsNCj4rICAgICAgICAgICAgICAgICAgICAgIHhkcF9idWZm
X2NsZWFyX2ZyYWdzX2ZsYWcoJmN0eC54ZHApOw0KPisgICAgICAgICAgICAgICAgICAgICAgY3R4
LnJ4X2Rlc2MgPSByeF9kZXNjOw0KDQpNb3ZlIHJ4X2Rlc2MgdG8gNHRoIHBhdGNoIChSeCBoYXNo
IHBhdGNoKQ0KDQo+DQo+LSAgICAgICAgICAgICAgICAgICAgICBza2IgPSBpZ2NfeGRwX3J1bl9w
cm9nKGFkYXB0ZXIsICZ4ZHApOw0KPisgICAgICAgICAgICAgICAgICAgICAgc2tiID0gaWdjX3hk
cF9ydW5fcHJvZyhhZGFwdGVyLCAmY3R4LnhkcCk7DQo+ICAgICAgICAgICAgICAgfQ0KPg0KPiAg
ICAgICAgICAgICAgIGlmIChJU19FUlIoc2tiKSkgew0KPkBAIC0yNTgzLDkgKzI1ODYsOSBAQCBz
dGF0aWMgaW50IGlnY19jbGVhbl9yeF9pcnEoc3RydWN0IGlnY19xX3ZlY3Rvcg0KPipxX3ZlY3Rv
ciwgY29uc3QgaW50IGJ1ZGdldCkNCj4gICAgICAgICAgICAgICB9IGVsc2UgaWYgKHNrYikNCj4g
ICAgICAgICAgICAgICAgICAgICAgIGlnY19hZGRfcnhfZnJhZyhyeF9yaW5nLCByeF9idWZmZXIs
IHNrYiwgc2l6ZSk7DQo+ICAgICAgICAgICAgICAgZWxzZSBpZiAocmluZ191c2VzX2J1aWxkX3Nr
YihyeF9yaW5nKSkNCj4tICAgICAgICAgICAgICAgICAgICAgIHNrYiA9IGlnY19idWlsZF9za2Io
cnhfcmluZywgcnhfYnVmZmVyLCAmeGRwKTsNCj4rICAgICAgICAgICAgICAgICAgICAgIHNrYiA9
IGlnY19idWlsZF9za2IocnhfcmluZywgcnhfYnVmZmVyLCAmY3R4LnhkcCk7DQo+ICAgICAgICAg
ICAgICAgZWxzZQ0KPi0gICAgICAgICAgICAgICAgICAgICAgc2tiID0gaWdjX2NvbnN0cnVjdF9z
a2IocnhfcmluZywgcnhfYnVmZmVyLCAmeGRwLA0KPisgICAgICAgICAgICAgICAgICAgICAgc2ti
ID0gaWdjX2NvbnN0cnVjdF9za2IocnhfcmluZywgcnhfYnVmZmVyLCAmY3R4LnhkcCwNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRpbWVzdGFtcCk7DQo+
DQo+ICAgICAgICAgICAgICAgLyogZXhpdCBpZiB3ZSBmYWlsZWQgdG8gcmV0cmlldmUgYSBidWZm
ZXIgKi8gQEAgLTI2ODYsNiArMjY4OSwxNQ0KPkBAIHN0YXRpYyB2b2lkIGlnY19kaXNwYXRjaF9z
a2JfemMoc3RydWN0IGlnY19xX3ZlY3RvciAqcV92ZWN0b3IsDQo+ICAgICAgIG5hcGlfZ3JvX3Jl
Y2VpdmUoJnFfdmVjdG9yLT5uYXBpLCBza2IpOyAgfQ0KPg0KPitzdGF0aWMgc3RydWN0IGlnY194
ZHBfYnVmZiAqeHNrX2J1ZmZfdG9faWdjX2N0eChzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCkgew0KPisg
ICAgICAvKiB4ZHBfYnVmZiBwb2ludGVyIHVzZWQgYnkgWkMgY29kZSBwYXRoIGlzIGFsbG9jIGFz
IHhkcF9idWZmX3hzay4gVGhlDQo+KyAgICAgICAqIGlnY194ZHBfYnVmZiBzaGFyZXMgaXRzIGxh
eW91dCB3aXRoIHhkcF9idWZmX3hzayBhbmQgcHJpdmF0ZQ0KPisgICAgICAgKiBpZ2NfeGRwX2J1
ZmYgZmllbGRzIGZhbGwgaW50byB4ZHBfYnVmZl94c2stPmNiDQo+KyAgICAgICAqLw0KPisgICAg
ICAgcmV0dXJuIChzdHJ1Y3QgaWdjX3hkcF9idWZmICopeGRwOyB9DQo+Kw0KDQpNb3ZlIHhza19i
dWZmX3RvX2lnY19jdHggdG8gM3RoIHBhdGNoICh0aW1lc3RhbXAgcGF0Y2gpLCB3aGljaCBpcyBm
aXJzdCBwYXRjaA0KYWRkaW5nIHhkcF9tZXRhZGF0YV9vcHMgc3VwcG9ydCB0byBpZ2MuDQoNCj4g
c3RhdGljIGludCBpZ2NfY2xlYW5fcnhfaXJxX3pjKHN0cnVjdCBpZ2NfcV92ZWN0b3IgKnFfdmVj
dG9yLCBjb25zdCBpbnQgYnVkZ2V0KSAgew0KPiAgICAgICBzdHJ1Y3QgaWdjX2FkYXB0ZXIgKmFk
YXB0ZXIgPSBxX3ZlY3Rvci0+YWRhcHRlcjsgQEAgLTI3MDQsNiArMjcxNiw3DQo+QEAgc3RhdGlj
IGludCBpZ2NfY2xlYW5fcnhfaXJxX3pjKHN0cnVjdCBpZ2NfcV92ZWN0b3IgKnFfdmVjdG9yLCBj
b25zdCBpbnQNCj5idWRnZXQpDQo+ICAgICAgIHdoaWxlIChsaWtlbHkodG90YWxfcGFja2V0cyA8
IGJ1ZGdldCkpIHsNCj4gICAgICAgICAgICAgICB1bmlvbiBpZ2NfYWR2X3J4X2Rlc2MgKmRlc2M7
DQo+ICAgICAgICAgICAgICAgc3RydWN0IGlnY19yeF9idWZmZXIgKmJpOw0KPisgICAgICAgICAg
ICAgIHN0cnVjdCBpZ2NfeGRwX2J1ZmYgKmN0eDsNCj4gICAgICAgICAgICAgICBrdGltZV90IHRp
bWVzdGFtcCA9IDA7DQo+ICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IHNpemU7DQo+ICAgICAg
ICAgICAgICAgaW50IHJlczsNCj5AQCAtMjcyMSw2ICsyNzM0LDkgQEAgc3RhdGljIGludCBpZ2Nf
Y2xlYW5fcnhfaXJxX3pjKHN0cnVjdCBpZ2NfcV92ZWN0b3INCj4qcV92ZWN0b3IsIGNvbnN0IGlu
dCBidWRnZXQpDQo+DQo+ICAgICAgICAgICAgICAgYmkgPSAmcmluZy0+cnhfYnVmZmVyX2luZm9b
bnRjXTsNCj4NCj4rICAgICAgICAgICAgICBjdHggPSB4c2tfYnVmZl90b19pZ2NfY3R4KGJpLT54
ZHApOw0KDQpNb3ZlIHhza19idWZmX3RvX2lnY19jdHggdG8gM3RoIHBhdGNoICh0aW1lc3RhbXAg
cGF0Y2gpLCB3aGljaCBpcyBmaXJzdCBwYXRjaA0KYWRkaW5nIHhkcF9tZXRhZGF0YV9vcHMgc3Vw
cG9ydCB0byBpZ2MuDQoNCj4rICAgICAgICAgICAgICBjdHgtPnJ4X2Rlc2MgPSBkZXNjOw0KDQpN
b3ZlIHJ4X2Rlc2MgdG8gNHRoIHBhdGNoIChSeCBoYXNoIHBhdGNoKQ0KDQpUaGFua3MgJiBSZWdh
cmRzDQpTaWFuZw0KDQo+Kw0KPiAgICAgICAgICAgICAgIGlmIChpZ2NfdGVzdF9zdGF0ZXJyKGRl
c2MsIElHQ19SWERBRFZfU1RBVF9UU0lQKSkgew0KPiAgICAgICAgICAgICAgICAgICAgICAgdGlt
ZXN0YW1wID0gaWdjX3B0cF9yeF9wa3RzdGFtcChxX3ZlY3Rvci0+YWRhcHRlciwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYmktPnhkcC0+
ZGF0YSk7DQo+DQoNCg==
