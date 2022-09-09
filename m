Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C75B3367
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiIIJSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiIIJSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:18:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2917EB481
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 02:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662715128; x=1694251128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tlNfQrVBaFnRfRbMJ89Q86IkvSlQmXBMV8O9ejlqyHs=;
  b=VwI23erUDHLc3o1LvVdRuWxYJCeAkkzcjR5iarqne6Rm+D2GvQxJwnW6
   r6CTvNnBaB3xEJePCXkSRVlemtvYb/dPQfbgTcubo79glfxhOoJ0aM9NJ
   uXFQPVG1cdi7X+6QRPLGNQkNurceqdnJw0xm3yTaLF5ZbQFxT2ZjsSeVw
   MHkgw25ep2hWkfrZenw6A6RcnfLKJ7ufWdMq8K7N/pYg4bobJgnOckW6+
   ck+19KbNcHqkFqB+fbisxsk+qhs9rDyUFhkOjai+fgSnMKMiTdVqtp4IZ
   5TpdR0zSftDAN0t0QLSWf9Eac8YrZXc3G2EF/eVgFzFf6I/5GDSwuIkvr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="383729635"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="383729635"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:18:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="757539339"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 09 Sep 2022 02:18:37 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 02:18:37 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 02:18:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 9 Sep 2022 02:18:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 9 Sep 2022 02:18:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzC8PpqeZczGrBhLtq56p4AXRtQH91hW4OfXnGgavouvitdCBIMqpgQoxgtBOBv3JUZEwhLeZ81rVNHj2ID0HxzhLCRyU/hPJ6sxtnt8cq++5o8PiYUUu47M1fMSdqlThgi7ft1l8NHHfPiRCVF9a7lQTtqnXWOkSxWpIF6IFp4XFpq40J5gnc+I3fFdT4h4l6HjPwW3iV4AkplDHzO6yh9oT9viubpgtFJIJOKlW+LYJ+RP+J8BwhZAwh1tFErAjwNSVOW0DLTqGKRRWXZBzQsYCA/6OWhOAi+ejkZI7vIPPuYkDNM1iIu9rxnc8uDtLKecAS10YbZcxQqh6HYXYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlNfQrVBaFnRfRbMJ89Q86IkvSlQmXBMV8O9ejlqyHs=;
 b=Z9lkCLU7ov+Cxa3SUFE3YDN1jDfaxK4ebTeiRqrPkCeWt1nZKNB55cWlypxRJgikgQdhtrMjAiFI68LA6vdnyO1rNHVoW/GU14cQCmPq3tVyud1myknHMqY0TNTkwRJq3FpFPSwRFXhVHBIU+Bmmf2fUSyg+fzDpZInGqKVb4PHXygEBv/N4H3CqhAZXj+WZHGASSgvtoEXsmaxYJVHBTc68MEGeRVY8doGA2oOdH7H1s06MYk3OSOF7/8km07MmpwGgZsOowzMrULphzfP22/eW3UD5mDdaUxrVZsewwa/2Z0gPkvgj1F1voM7iKnxwrL78LmvBdKWIZt46jkaJOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by DM4PR11MB5439.namprd11.prod.outlook.com (2603:10b6:5:39b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 09:18:29 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 09:18:29 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
Thread-Topic: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Thread-Index: AQHYwyBaPBOhs3BGO0uGs2JDALv3X63VqNIAgAEg6xA=
Date:   Fri, 9 Sep 2022 09:18:29 +0000
Message-ID: <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
In-Reply-To: <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1293:EE_|DM4PR11MB5439:EE_
x-ms-office365-filtering-correlation-id: 399a6a48-cb6c-43eb-3d3c-08da9244423b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iXQTiB+0poNGt4EkN0fLOvWG4G5TzYI5CQDxnHjzaNbxpMvUwTqlb40+kBf3+my6H3asUPE/4KCJ48UmwwaHtGlM8xAL/MjSLqEqVgU/F7FWcrYKRhInxzAIc/klm3e/6nAw0ttndn8rNGHpTgOT6/siVJO0fJDqi/+HlB6OQ5QNqsQ/gWfla+EwMnRlY02gM7e0p/frOUEapzCH8wP52uVNQQfCMC2YlPvdzlRHkUqTRKQEggvCMSHn0vwMEjflKLOOMPW6p+WIe129i1Hkd6aPaF8nR+0zP9gISMf9ZzJg7RIzmuWut+FkkqlEqS7B8UYajmOJim8Z3As6TFqC6qC9CPRnceJng4KhuXDDpcy1wfQZtwbbOh6pNYpUzERfMlRvPSiNFOtEzbuWWWgTYBm5nVVF31BA/3eAooqAjVaqQMlg/VSHlMnPGPHAbG6l+E/fAp6I/V1Gs+T70HZic9iYm8urPPFtKKi2x7CbroqI3cXzJuj3nGhI0BZbj0X9q42NmE/jPE7tC9Le6/y+ZhMtNW+17hqLG+F9Qgg2/7Su/zzhay2kVebXcknvB2AHtd9PVqVNZakDLD7nByp/JtbzxL4nHlNCFt8p01YunE/r4ENgh9NgxEqnit7yIIFUlZQNRi0aLM5ZNXERpTHWfsPHxCCzoUkvqmWQGyy2y9ZDj1Q5n9kfDCJSoPd4fLj/UHo83QSu+QAjc5Z5Xmng7FaB2TYwCt+tDG3/ObDMik4PaWXmUbBeJNRIJ/XrahgH0rVpNvusAz5iFBgHXGRlxEnPXddKxPFR10IaFRKE+atNmEK7PR6rGDFNFPIwVrYA62mvUWKIg/PfVp8W/dX+vQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(366004)(136003)(39860400002)(41300700001)(38070700005)(9686003)(966005)(26005)(86362001)(6916009)(54906003)(107886003)(53546011)(6506007)(7696005)(478600001)(71200400001)(122000001)(186003)(55016003)(82960400001)(38100700002)(33656002)(83380400001)(66446008)(64756008)(4326008)(8936002)(8676002)(5660300002)(2906002)(66476007)(76116006)(66946007)(316002)(66556008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmFDdU5kdWZFT2RzYkw1YmdqYkpSdW5NUjF6WFp1UnY1K1l1Wk5pclh5b1Rz?=
 =?utf-8?B?Y0w2UWZ4ckJvOEZWVUVKeUNFKzhPajZUNmd2VEc0NkRtT0FkWm5naloxWXJr?=
 =?utf-8?B?MW1Mbk5JVXBJL01PV2xlZWo4NXdoQlNPNnM3R0EvTm1oSzQxZ05XRTU0RmNo?=
 =?utf-8?B?aUhuY05FRE9vbkVQbEo5b3dUdUk2Z0RnODk4dnZXVGRUcExlN2k2bDRwNW9w?=
 =?utf-8?B?S1BzMXBkMWJma2NXby9nU1JWeXU4TURPcjdseXo2T1FjdDdYY3pyeXVjbW15?=
 =?utf-8?B?TVhCdm5QZ0l3TDFDeUtPSzRtYkVHUWZqOHRmcEFERHhadGxZclNMWWJoU0Jq?=
 =?utf-8?B?WnQyR0FFalBFaXEvc3Rjam9aMGxHeENOemNWN1Nncml5OFRySUkvajUyNmMr?=
 =?utf-8?B?WVQ1VDFIcDlhc1M0V0tyL2ZlZGRUSVhZaFFWdXlYT1JVYkxhYzA2RHdsWEV2?=
 =?utf-8?B?Y0lCWDlpN01JUUZDWkJkUTJUQjRqUmdWdVZIYi9zOERON2VZQmdYNlFHT3Fm?=
 =?utf-8?B?YVlDRE1naGZJTTZFZmZMc2ZtSVJWSWtjd2hjL0hncXpjWWhmU0FNRDZKb1U4?=
 =?utf-8?B?T3o3YjVWcFpJMmhJNE1IbzNHT3pxSDh5bmltemVyU1VvRVI3VVlZVk9mVHlk?=
 =?utf-8?B?S3o2UEoxeXhnamN4Z1FSVGRhK2JzaEFKOGJRVmFodUszQ1d1eGRZMURKc09w?=
 =?utf-8?B?R1VNWFJiKzVHR1dBZ1dmRGVQUEp4alRubTVSNjhMR3lyejkreTlhTjhodFRB?=
 =?utf-8?B?ckFkTitUdXdvYWwraDdjWmRvSDdtMTl3TUtheDZncHRUV0F2WUlGa3hCZW9v?=
 =?utf-8?B?ekVnSkp4YUk5d3NBc3lwTVhSeUxIUGs0Njl0dEVpVVM0RmZtTnlKZDF1OGJl?=
 =?utf-8?B?YkpNd0dRbW9RbjE4TytHSGtPaVFZQUJJeExOSUVZU2xscEErZmxpM2I3WHdp?=
 =?utf-8?B?Y3l2T3VwbSt4NFVVRGc2Z29tMEU3RGViMU1ZZ0d2NWorY09RY0ZFSUhMNGoz?=
 =?utf-8?B?ZXJ0c1J5cHpLcFFiekM3bjJrL2d5VE1nNCtpOHdleHRhMUgwSTAwYWlXcE5K?=
 =?utf-8?B?aEd4TXBxa1NDSjhScEhvRUdMVDFkUWIzTGliS0FINkx0a1ZUUWJIakdldjIz?=
 =?utf-8?B?ZzBrU3RCRXlEN3VkUk1RaHNkSHQ0L1k1WXBoNmJSRzVwMVZybFpVOHlQOEd6?=
 =?utf-8?B?b3QrdzdId1lMK1pDWEx6N2pZWS93eDIvMUpTVnVweEpMcFFWMWhBeHhlK3Ry?=
 =?utf-8?B?YlFNN1lrZ1krMFd2eGZCZzAwb2VYdUgxSlRDaDB2ZkNhaXRRRjhxMHNsOStt?=
 =?utf-8?B?NE9XT0N2NHpRVENnTStuanQ4S2FPRm1UMkYwVUcraDBKbEJSblZ5VzdOZUZE?=
 =?utf-8?B?ZVJwNVJ5eVRxVmVuQVRKUUNGb2NiNjJVczkvczViNWRhUElYT2ZqaFdWMVJP?=
 =?utf-8?B?L05uQ3FiU2g0YUZ5eHBNcGUwRGJpUExEbnJVQ250UzRuMm9MSm1mKy9Ec0ky?=
 =?utf-8?B?RjA3NmhLS2FQd0NaaEt1akdXM2xHMWNnVmJKaTk3ZEJVaU8vNVJEZmw3U3Bi?=
 =?utf-8?B?U1dBOEpsdlhqRDhtWEZGNnR3NG9WcHpaaThCcHpIN1l4R3VpaFprTHJCNlEz?=
 =?utf-8?B?dGJYcWkxTlBJZzlBWktzUjJXakt5M0RlUlRTNTl5TFNmZXNFNkI4WWxQZ3lS?=
 =?utf-8?B?aGVUVHh6UWxJUFRQY3N2T0N6UE5IbXRuWWVFNE9KU2xva2hsb2lEQWJVdmdU?=
 =?utf-8?B?azZDYk11Wm1mcG1lNTF3Myt6TEJMU0tYYVlrQ3FGL1FIalgwNVdZOEcrYmM5?=
 =?utf-8?B?UHVYRkphOGRZaExXUWlNcTBVYTF3MDlvTEw5RVVIZHliK25Ld1U0YlZibnli?=
 =?utf-8?B?eC9oK1lJeGRJVHFrcjJBYTNnN09sbENaNjlEVDFzSEhDR05LWGJDQlNLRk9o?=
 =?utf-8?B?SU1NOCsrK1J1ZDVmaFRDV1NSWUNzSmgwbUZ6Umhid2g5TnFZTHdxQlV6SUM5?=
 =?utf-8?B?QmdwdE9xTldGbitCcXI1Y2Flc1lVNDBNaml5T0FNTC9uWHYvQS8xWFp3NGFS?=
 =?utf-8?B?bURCdkZiQVd6UGl0TWc4dnR6SUM0eFNva04xRVcvenFKazExOVNYUzRxZDZR?=
 =?utf-8?B?WEJzd1N0T1p2eDh5ZXcwdDRIblR5YUY2Y0sxRGpzTW81bnlFRzZ0UG1KOWln?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399a6a48-cb6c-43eb-3d3c-08da9244423b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 09:18:29.2644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+xS/pWd5cOS+VDLvAzLPDMGfS89PnrULXSgeiPi1W4KIqwvdTmlLdmIVLnfx+U64Q6EyDNsY1wnXZUCJLBpTocS+M+Lnzso0vo1dWSE/2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgOCwg
MjAyMiA4OjI4IEFNDQo+IFRvOiBOYW1iaWFyLCBBbXJpdGhhIDxhbXJpdGhhLm5hbWJpYXJAaW50
ZWwuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsga3ViYUBrZXJuZWwub3JnOyBq
aHNAbW9qYXRhdHUuY29tOw0KPiBqaXJpQHJlc251bGxpLnVzOyB4aXlvdS53YW5nY29uZ0BnbWFp
bC5jb207IEdvbWVzLCBWaW5pY2l1cw0KPiA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgU2Ft
dWRyYWxhLCBTcmlkaGFyDQo+IDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbbmV0LW5leHQgUEFUQ0ggdjIgMC80XSBFeHRlbmQgYWN0aW9uIHNrYmVkaXQgdG8g
UlggcXVldWUNCj4gbWFwcGluZw0KPiANCj4gT24gV2VkLCBTZXAgNywgMjAyMiBhdCA2OjE0IFBN
IEFtcml0aGEgTmFtYmlhcg0KPiA8YW1yaXRoYS5uYW1iaWFyQGludGVsLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPiBCYXNlZCBvbiB0aGUgZGlzY3Vzc2lvbiBvbg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL25ldGRldi8yMDIyMDQyOTE3MTcxNy41YjBiMmE4MUBrZXJuZWwub3JnLywNCj4gPiB0
aGUgZm9sbG93aW5nIHNlcmllcyBleHRlbmRzIHNrYmVkaXQgdGMgYWN0aW9uIHRvIFJYIHF1ZXVl
IG1hcHBpbmcuDQo+ID4gQ3VycmVudGx5LCBza2JlZGl0IGFjdGlvbiBpbiB0YyBhbGxvd3Mgb3Zl
cnJpZGluZyBvZiB0cmFuc21pdCBxdWV1ZS4NCj4gPiBFeHRlbmRpbmcgdGhpcyBhYmlsaXR5IG9m
IHNrZWRpdCBhY3Rpb24gc3VwcG9ydHMgdGhlIHNlbGVjdGlvbiBvZiByZWNlaXZlDQo+ID4gcXVl
dWUgZm9yIGluY29taW5nIHBhY2tldHMuIE9mZmxvYWRpbmcgdGhpcyBhY3Rpb24gaXMgYWRkZWQg
Zm9yIHJlY2VpdmUNCj4gPiBzaWRlLiBFbmFibGVkIGljZSBkcml2ZXIgdG8gb2ZmbG9hZCB0aGlz
IHR5cGUgb2YgZmlsdGVyIGludG8gdGhlDQo+ID4gaGFyZHdhcmUgZm9yIGFjY2VwdGluZyBwYWNr
ZXRzIHRvIHRoZSBkZXZpY2UncyByZWNlaXZlIHF1ZXVlLg0KPiA+DQo+ID4gdjI6IEFkZGVkIGRv
Y3VtZW50YXRpb24gaW4gRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nDQo+ID4NCj4gPiAtLS0NCj4g
Pg0KPiA+IEFtcml0aGEgTmFtYmlhciAoNCk6DQo+ID4gICAgICAgYWN0X3NrYmVkaXQ6IEFkZCBz
dXBwb3J0IGZvciBhY3Rpb24gc2tiZWRpdCBSWCBxdWV1ZSBtYXBwaW5nDQo+ID4gICAgICAgYWN0
X3NrYmVkaXQ6IE9mZmxvYWQgc2tiZWRpdCBxdWV1ZSBtYXBwaW5nIGZvciByZWNlaXZlIHF1ZXVl
DQo+ID4gICAgICAgaWNlOiBFbmFibGUgUlggcXVldWUgc2VsZWN0aW9uIHVzaW5nIHNrYmVkaXQg
YWN0aW9uDQo+ID4gICAgICAgRG9jdW1lbnRhdGlvbjogbmV0d29ya2luZzogVEMgcXVldWUgYmFz
ZWQgZmlsdGVyaW5nDQo+IA0KPiBJIGRvbid0IHRoaW5rIHNrYmVkaXQgaXMgdGhlIHJpZ2h0IHRo
aW5nIHRvIGJlIHVwZGF0aW5nIGZvciB0aGlzLiBJbg0KPiB0aGUgY2FzZSBvZiBUeCB3ZSB3ZXJl
IHVzaW5nIGl0IGJlY2F1c2UgYXQgdGhlIHRpbWUgd2Ugc3RvcmVkIHRoZQ0KPiBzb2NrZXRzIFR4
IHF1ZXVlIGluIHRoZSBza2IsIHNvIGl0IG1hZGUgc2Vuc2UgdG8gZWRpdCBpdCB0aGVyZSBpZiB3
ZQ0KPiB3YW50ZWQgdG8gdHdlYWsgdGhpbmdzIGJlZm9yZSBpdCBnb3QgdG8gdGhlIHFkaXNjIGxh
eWVyLiBIb3dldmVyIGl0DQo+IGRpZG4ndCBoYXZlIGEgZGlyZWN0IGltcGFjdCBvbiB0aGUgaGFy
ZHdhcmUgYW5kIG9ubHkgcmVhbGx5IGFmZmVjdGVkDQo+IHRoZSBzb2Z0d2FyZSByb3V0aW5nIGlu
IHRoZSBkZXZpY2UsIHdoaWNoIGV2ZW50dWFsbHkgcmVzdWx0ZWQgaW4gd2hpY2gNCj4gaGFyZHdh
cmUgcXVldWUgYW5kIHFkaXNjIHdhcyBzZWxlY3RlZC4NCj4gDQo+IFRoZSBwcm9ibGVtIHdpdGgg
ZWRpdGluZyB0aGUgcmVjZWl2ZSBxdWV1ZSBpcyB0aGF0IHRoZSBoYXJkd2FyZQ0KPiBvZmZsb2Fk
ZWQgY2FzZSB2ZXJzdXMgdGhlIHNvZnR3YXJlIG9mZmxvYWRlZCBjYW4gaGF2ZSB2ZXJ5IGRpZmZl
cmVudA0KPiBiZWhhdmlvcnMuIEkgd29uZGVyIGlmIHRoaXMgd291bGRuJ3QgYmUgYmV0dGVyIHNl
cnZlZCBieSBiZWluZyBhbg0KDQpDb3VsZCB5b3UgcGxlYXNlIGV4cGxhaW4gaG93IHRoZSBoYXJk
d2FyZSBvZmZsb2FkIGFuZCBzb2Z0d2FyZSBjYXNlcw0KYmVoYXZlIGRpZmZlcmVudGx5IGluIHRo
ZSBza2JlZGl0IGNhc2UuIEZyb20gSmFrdWIncyBzdWdnZXN0aW9uIG9uDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9uZXRkZXYvMjAyMjA1MDMwODQ3MzIuMzYzYjg5Y2NAa2VybmVsLm9yZy8sDQpp
dCBsb29rZWQgbGlrZSB0aGUgc2tiZWRpdCBhY3Rpb24gZml0cyBiZXR0ZXIgdG8gYWxpZ24gdGhl
IGhhcmR3YXJlIGFuZA0Kc29mdHdhcmUgZGVzY3JpcHRpb24gb2YgUlggcXVldWUgb2ZmbG9hZCAo
Y29uc2lkZXJpbmcgdGhlIHNrYiBtZXRhZGF0YQ0KcmVtYWlucyBzYW1lIGluIG9mZmxvYWQgdnMg
bm8tb2ZmbG9hZCBjYXNlKS4NCg0KPiBleHRlbnNpb24gb2YgdGhlIG1pcnJlZCBpbmdyZXNzIHJl
ZGlyZWN0IGFjdGlvbiB3aGljaCBpcyBhbHJlYWR5IHVzZWQNCj4gZm9yIG11bHRpcGxlIGhhcmR3
YXJlIG9mZmxvYWRzIGFzIEkgcmVjYWxsLg0KPiANCj4gSW4gdGhpcyBjYXNlIHlvdSB3b3VsZCB3
YW50IHRvIGJlIHJlZGlyZWN0aW5nIHBhY2tldHMgcmVjZWl2ZWQgb24gYQ0KPiBwb3J0IHRvIGJl
aW5nIHJlY2VpdmVkIG9uIGEgc3BlY2lmaWMgcXVldWUgb24gdGhhdCBwb3J0LiBCeSB1c2luZyB0
aGUNCj4gcmVkaXJlY3QgYWN0aW9uIGl0IHdvdWxkIHRha2UgdGhlIHBhY2tldCBvdXQgb2YgdGhl
IHJlY2VpdmUgcGF0aCBhbmQNCj4gcmVpbnNlcnQgaXQsIGJlaW5nIGFibGUgdG8gYWNjb3VudCBm
b3IgYW55dGhpbmcgc3VjaCBhcyB0aGUgUlBTDQo+IGNvbmZpZ3VyYXRpb24gb24gdGhlIGRldmlj
ZSBzbyB0aGUgYmVoYXZpb3Igd291bGQgYmUgY2xvc2VyIHRvIHdoYXQNCj4gdGhlIGhhcmR3YXJl
IG9mZmxvYWRlZCBiZWhhdmlvciB3b3VsZCBiZS4NCg0KV291bGRuJ3QgdGhpcyBiZSBhbiBvdmVy
a2lsbCBhcyB3ZSBvbmx5IHdhbnQgdG8gYWNjZXB0IHBhY2tldHMgaW50byBhIA0KcHJlZGV0ZXJt
aW5lZCBxdWV1ZT8gSUlVQywgdGhlIG1pcnJlZCByZWRpcmVjdCBhY3Rpb24gdHlwaWNhbGx5IG1v
dmVzDQpwYWNrZXRzIGZyb20gb25lIGludGVyZmFjZSB0byBhbm90aGVyLCB0aGUgZmlsdGVyIGlz
IGFkZGVkIG9uIGludGVyZmFjZQ0KZGlmZmVyZW50IGZyb20gdGhlIGRlc3RpbmF0aW9uIGludGVy
ZmFjZS4gSW4gb3VyIGNhc2UsIHdpdGggdGhlDQpkZXN0aW5hdGlvbiBpbnRlcmZhY2UgYmVpbmcg
dGhlIHNhbWUsIEkgYW0gbm90IHVuZGVyc3RhbmRpbmcgdGhlIG5lZWQNCmZvciBhIGxvb3BiYWNr
LiBBbHNvLCBXUlQgdG8gUlBTLCBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgdGhlIGltcGFjdA0KaGVy
ZS4gSW4gaGFyZHdhcmUsIG9uY2UgdGhlIG9mZmxvYWRlZCBmaWx0ZXIgZXhlY3V0ZXMgdG8gc2Vs
ZWN0IHRoZSBxdWV1ZSwNClJTUyBkb2VzIG5vdCBydW4uIEluIHNvZnR3YXJlLCBpZiBSUFMgZXhl
Y3V0ZXMgYmVmb3JlDQpzY2hfaGFuZGxlX2luZ3Jlc3MoKSwgd291bGRuJ3QgYW55IHRjLWFjdGlv
bnMgKG1pcnJlZCByZWRpcmVjdCBvciBza2JlZGl0DQpvdmVycmlkaW5nIHRoZSBxdWV1ZSkgYmVo
YXZlIGluIHNpbWlsYXIgd2F5ID8gDQo=
