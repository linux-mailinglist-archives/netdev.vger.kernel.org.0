Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E705347C9B1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbhLUX2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:28:24 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.140.77]:29127 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237140AbhLUX2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 18:28:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1640129303; x=1640734103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=//L2YYsQ5KjcdQjmugrVxG9PQWT0deadqwZuLB1oGW8=;
  b=m30DFSOrT5W8qIz0TJvjjh7x4+il09dU0mEZsPT0a3ry/EfP68VKB85f
   mDgO11B4/w/yNHkr6zaba/Vv7oQlgnb/UQvZLf6BzIb6HYLVOuB0fUdwI
   trEm4ng02P+WxMjozS+qHb4XcIlSex/SSbFa0SO64rwJgnnOW0SkO93xU
   M=;
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 23:28:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+mPWT8cz/35EFPkQFgrg7RfD6vj84iIWfHbmjqXUDw33gRvocPT2ZfoPjLqnA5jyeDi7ChBI3tNfmLBJtTpsK6d8V+e86WmT7EOt9kax2B9VsJtYL//G+D3nARsKUVrM9w2ct5RKOW5V+/fDx2T6B3mVoZvet/PNLtKEnfReCizzlXkjMMEHOdpnhy/alD804O8VFH55xsAKZ2zhq4m/N8bjQc5gHdQ3x91z1L9C2h63ArUJp9YU3iOH2aO3rLPCAaIuV4IRyNr/gCC0KGy6eLUNrzZSdFDpNCzoGzgb2hMxwuXm4kRDHH3wfUhYllG5ZnTwroF5I50jWYJe04E9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//L2YYsQ5KjcdQjmugrVxG9PQWT0deadqwZuLB1oGW8=;
 b=BaW3GeRn6y6Bgzy/Vu4qpYVlQP+QnpEgsNA5sfevjiQwsc7PSueXZqvDgPkpdsYYvAtps7GmQrKM6pSxovER8jaPhjSVXhTUTFi30N2wp2l3loz1+2/RpegDO1cK/VphY3IMkUCTe2mLD2ldN1qZslJbvJ4wcjr2Xx6aHQf7uzkPrU6iG/gv5coTwvKnwGd9s44W6cOxIKXjPC4/W4m8OJaFjzimHgdfGX567YVuNN/fC5hw/fqC8mlDd65zETvXldFGnczfS6dNLGzt8CTvMmhmZAPOGU+jt13hFYhymSQKzbHMEg3xHZrCFcskYlLRuSC7PXD6Jl/QC9tAA5jPrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by SJ0PR02MB7248.namprd02.prod.outlook.com (2603:10b6:a03:293::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Tue, 21 Dec
 2021 23:28:21 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 23:28:21 +0000
From:   Tyler Wear <twear@quicinc.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        =?utf-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>
CC:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Thread-Topic: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Thread-Index: AQHX9eHoIVi91SZqTE+0za9xEhnh/6w8RyUAgAAxxwCAANfuIIAAClQAgAAjJICAAAXDAIAADy+AgAAEj1A=
Date:   Tue, 21 Dec 2021 23:28:20 +0000
Message-ID: <BYAPR02MB52382D9342669D4D578C85D8AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
 <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CANP3RGeNVSwSfb9T_6Xp8GyggbwnY7YQjv1Fw5L2wTtqiFJbpw@mail.gmail.com>
 <20211221215227.4kpw65oeusfskenx@kafai-mbp.dhcp.thefacebook.com>
 <CANP3RGdbYsue7xiYgVavnq2ysg6N6bWpFKnHxg4YkpQF9gv4oA@mail.gmail.com>
 <20211221230725.mm5ycvkof3sgihh6@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211221230725.mm5ycvkof3sgihh6@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 094c56c1-b578-4076-f7c3-08d9c4d9937e
x-ms-traffictypediagnostic: SJ0PR02MB7248:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR02MB724823717AA1821ECE7575C9AA7C9@SJ0PR02MB7248.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +N37LWASnZqShVGDvtdUCNoqnBsAqcQVx4b11+m4CaT7U1XYGtUEwi/h63ySN+20ZhpyBrwLV2WEjhIS5FA8mWuhVY17S//8CCQad/l2lh5ZiU2C9VpRpgOGIb2fJFpvJKZy58cQYmFXUeZhR3N0qNWBGFCxEagIzK6kfq2ThStuxhKP7Rfj3+YwNjXlS7NLmHUW4pkgmsruVd+MXjEJVhvVZmQn4vqPzj4KpR9HC5BHV3S0sw2NM0mSsmzMeb+IfCV9ZcFP0cZl9IMBA/w5vngW6aWtdGVsDL2WMeeDs2Q7fDKdwrZ5mqGjGk7jALyrSVMvBURerSz/WsgenehBTlGOxzii5iEzeEQdHJewJFLUsq80Dc88wnXfgq9tbbFrYL6TSc1cq4C2uhgqcuybAXDNJtrX+f+CKtFNXl4cnPoreBFlhnpOu9ay4ygdCII9EV/bLd5yz0F5UsYGmOHhMRi+zu3K2XT2VeKuPm7QAwMMI2GFF0rF6KtSyZC5Ul13Ge5xZS3Hc8E9ZjYhS4oFLf5VfWcHXQAAe64mid9nXlvoQW+4AKL3AQh5plhs6bhZY8cLnwUVQP0TAEERXgx4eTGVzj6MqXpr6wuP/2MW+mAwYpx0nnfLTXuhJbzuFbXoDSjGSTnPjVp72o/ZYoT+t1SbF2s7AwAIgv+5zsqjeYiBwPKa2wUK9oQqJUAm1MTOBMcUe9krUS3AwFNDaC9SeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(52536014)(38100700002)(7696005)(316002)(186003)(2906002)(4326008)(86362001)(122000001)(83380400001)(54906003)(55016003)(110136005)(66574015)(26005)(66446008)(66556008)(76116006)(8676002)(66476007)(64756008)(33656002)(8936002)(508600001)(71200400001)(4744005)(6506007)(5660300002)(66946007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFk4b0pwcHE0RGNlMG5aVlU1d1dRWm5xYmYyc1NRdW83eXpobVc3d0hFeEh6?=
 =?utf-8?B?RHpRYmFLWngwQnVoT3lLdnNVR1FRZ1JoOWIxS0l1M1hMSWhicVJJTml4M0du?=
 =?utf-8?B?S1dnSHdBWFZtVHVEVU1SY0xnei9tWml3eTJJU3ZUeEVHcFM1cUF2VXBzZW9X?=
 =?utf-8?B?R2ZycU1oUEQzb1QvQld5WEM5Nlphc1dVSGhpWUN2dGxlNWNEY0VzaUZLc1Zy?=
 =?utf-8?B?bGV3RDYxNzlnMnZPNXVuOVl4RVExdTZJUWN1QzNFcDE4K3ovRmhxdEtQQ2xh?=
 =?utf-8?B?cDVDam1hbVhnTUdhM2ZYY2FIRkFPQ2RaNFRObXdGaU02amt3MTJHKzYrUXZN?=
 =?utf-8?B?bUtibVVMTmcrcEhBVGlYVHRVQjhadmdMZ3lWeWdNRDAxRnYyYXZDMGxrM01R?=
 =?utf-8?B?QitjMWM1Nk5rUmNuV29FeHhadkowZGpRUFdhbG1BL0lUNytsSTVtZjVhNjcy?=
 =?utf-8?B?YncrRkUvWlRvTU5raGtEZmM1OUMramM0RmRvU2RNc1c3aFBrYW54aGhSa1Z3?=
 =?utf-8?B?T1ozc3dSa0ZIWWRFOS9IU3Zua1QwVndUMW4xZXdrL2pRbUlPb0lOOFVLbEVz?=
 =?utf-8?B?U29SdENhZlh0L3FiaWJjYk9udTAvNUtTaEZLSitQTzcyd25yRWNPUlVmektv?=
 =?utf-8?B?NXVrUGUwOWFSYmt2NVp6cGgvRGtSbnZvOHNrVDZVclpTbk5RS21PMWp1V3Iv?=
 =?utf-8?B?WDY3MkxTek90RmQxU2xkWVlTenRFczdVYVIxdmZyc2dFWGlnTS9uOWdhalJo?=
 =?utf-8?B?V3FaYUg4OVkwNjhiYlRjdVk5REE4Y2tJNE9rczVlM1E0UVRTZ2RTYWZLK0VU?=
 =?utf-8?B?SXpLL3JrR20wNXpML0lSN1M0ZXNhS2U1eDZpWTV2cEFKUTlaekgva0VWSndj?=
 =?utf-8?B?OGpJT1lvUUxmVUpUbldBZHZEOS8xSk8zc3NTN001ZWtUeHVvZUxhbHNjcytP?=
 =?utf-8?B?cVJzeG1NVDBjbDNiMGNVZGg5OVEwcU96UDRqQk1Xd2hBc1lmWVgzNzlhTzdD?=
 =?utf-8?B?MEpEbDh3Yzl0ZzcxeXliZ2E5MmlPYjVzL2tibXd3czN3WjhWbWlSRU5yc0lx?=
 =?utf-8?B?d210SXMvcU8rZGxHVXBhL1BmQ1JqSFJQT2IzU1ZoZ0VFZ0x1Q3Q4UEI2OCtI?=
 =?utf-8?B?cUhQalR6Qms4VUNBMjRNanFOeEUxSW1yZkZLMnBqSmVRVzd5SzN3UkFSVVBB?=
 =?utf-8?B?VDBjdTZVNDExcmtuRVZiMWlCdHpsaktPNG8zZHRkblRqckdFVzNIMjFndXA5?=
 =?utf-8?B?WVJ6Qm5ReFFFMTZUckhIaUM1L2RHc3QxR0lDTktWb1lyRjFRcmxRN0M5bG1U?=
 =?utf-8?B?OWZrQjJITUhzdTlKSGhhVDc3Z0cza2tISnhJTURqUnlFcjdDTDF2NFZ6M1NJ?=
 =?utf-8?B?REFHa1ltckpSV1RiT2xpY1Q1Q20wem15T0hZRzVjejVPYTRHSjhBMjRteTVm?=
 =?utf-8?B?TVJNWlIxN3czTi9DRVlIRnBLS3VpZ2xNRWFUcnZzNVhjNVRBeFVRdTQxcS9G?=
 =?utf-8?B?OWk0aHZZY28yQ2dkbmdXSnd0U2k4L0Z5Zm9kN0U0L0QrZFlHRjI3MlpTYzlC?=
 =?utf-8?B?MUJlcEgrL256UU9ZMTV3WVZSa3dQeURHK0lBZ2lFbGhtOUJmRm5ueDh2T3VY?=
 =?utf-8?B?Q3N5NHNqaE85eHNIVndRdG1kcjZuRGpSWnZCRCtBT3ZlM0ZOcUVrZzJldlFo?=
 =?utf-8?B?Ynl2ZkppWFZuUUNaTjJwMDMxTTVVNVBlZVJ4T3pjUEg5b3J5Sm1HVE9EMHVr?=
 =?utf-8?B?bm5zckxCZUgrUDVGN1pOTnNZNExPVzE4Mm5taVVzNEdwcFYyWnV1RUszb2Iz?=
 =?utf-8?B?dkRGeXVhcHk0VEdiN25MNlZDRkZDWWo5UjBTZzZIbkhGMVp1OFd3aVNyR25w?=
 =?utf-8?B?enkxQi8rcDVLQ3B3TnJCUUM0cVlrMVQ5S2Qwb0VjbXRxZUlCQ2k0bkI3SFMv?=
 =?utf-8?B?YU1NeVNMam1udStHb0RUYXk1UStXSEJSTmZDV25vNDBraC84NXJBUWhHOWpH?=
 =?utf-8?B?SzR1cVJGaWJBaXNYRjhpVG1UVFlmZE4zS2owYUN2K0NIVi91cVZYTVg1T3hD?=
 =?utf-8?B?Z3djdkphNmlqMEhOT2JUOG9yZkV4S2s5Z0d4cWM2anEvZVprV0FtZTZjYmFZ?=
 =?utf-8?B?ck9RZ1Q2dWRKNXl1MWpHekYxQVkrZHVwOWJZNVYraXg5MzJQaXI4MU9VV1Rq?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094c56c1-b578-4076-f7c3-08d9c4d9937e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 23:28:20.9748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BCanq6ILLZ37LF/28FfgdbUY2I/eitej6s7ErQCakJ/5cUQR/RvT5+abseqe1qTQakOv4N/eiyxCLe9T03Y8aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7248
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIFR1ZSwgRGVjIDIxLCAyMDIxIGF0IDAyOjEzOjA0UE0gLTA4MDAsIE1hY2llaiDFu2Vu
Y3p5a293c2tpIHdyb3RlOg0KPiA+ID4gPiBBcyBmb3Igd2hhdCBpcyBkcml2aW5nIHRoaXM/ICBV
cGNvbWluZyB3aWZpIHN0YW5kYXJkIHRvIGFsbG93DQo+ID4gPiA+IGFjY2VzcyBwb2ludHMgdG8g
aW5mb3JtIGNsaWVudCBkZXZpY2VzIGhvdyB0byBkc2NwIG1hcmsgaW5kaXZpZHVhbCBmbG93cy4N
Cj4gPiA+IEludGVyZXN0aW5nLg0KPiA+ID4NCj4gPiA+IEhvdyBkb2VzIHRoZSBzZW5kaW5nIGhv
c3QgZ2V0IHRoaXMgZHNjcCB2YWx1ZSBmcm9tIHdpZmkgYW5kIHRoZW4NCj4gPiA+IGFmZmVjdCB0
aGUgZHNjcCBvZiBhIHBhcnRpY3VsYXIgZmxvdz8gIElzIHRoZSBkc2NwIGdvaW5nIHRvIGJlDQo+
ID4gPiBzdG9yZWQgaW4gYSBicGYgbWFwIGZvciB0aGUgYnBmIHByb2cgdG8gdXNlPw0KPiA+DQo+
ID4gSXQgZ2V0cyBpdCBvdXQgb2YgYmFuZCB2aWEgc29tZSB3aWZpIHNpZ25hbGluZyBtZWNoYW5p
c20uDQo+ID4gVHlsZXIgcHJvYmFibHkga25vd3MgdGhlIGRldGFpbHMuDQo+ID4NCj4gPiBTdG9y
aW5nIGZsb3cgbWF0Y2ggaW5mb3JtYXRpb24gdG8gZHNjcCBtYXBwaW5nIGluIGEgYnBmIG1hcCBp
cyBpbmRlZWQgdGhlIHBsYW4uDQo+ID4NCg0KVGhpcyBpcyBmb3IgYW4gdXBjb21pbmcgUW9TIFdp
ZmkgQWxsaWFuY2Ugc3BlYy4gV2lmaSB3aWxsIGdldCB0aGUgZHNjcCBmb3IgYSBjb3JyZXNwb25k
aW5nDQpmbG93IGFuZCBhcyBNYXplIHNhaWQgdGhlIGN1cnJlbnQgcGxhbiBpcyB0byBzdG9yZSB0
aGlzIG1hcCBpbmZvIGluIGJwZiB0byBtb2RpZnkgcGFja2V0cy4NCg==
