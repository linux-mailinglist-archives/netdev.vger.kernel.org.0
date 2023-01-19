Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78826742BE
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjASTZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjASTZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:25:26 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9565C95177
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:25:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYVpFsqvb8QPdTaI4uWzlQw8VacX3ljrgmaEm4YSoT/v5VCqMdzcICeVxUO/XsoJWd3Qw+Ar5Ujf9OghnSRckW3Qyibr8GlQsnzV8ajtXVXlmy8iDC0h2p8W/r9evf7pTt3bPpQHUzIFRPiFOmqJOl0HAi5iQrfF1xR95zs+qeNCWdGpaf5GhcEIBn1wq1gHIrcaG2Zw5E3hJNWiDnmicwgW3UaPKU+Q+fpGbb5MaC3Qi/I/HurMQF+RB8ov93M3TwRgL70sS3ecq1sZ4Jwtz9k1Rrd2zZeE7hQa+rPkPhnlhp6C++mqOR2hy2JRiotoVf0dLB4413LlfSVuc1Yi8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcQ7jPWGH2XvzeR29p3Y0nJ8uvv3gxE4aBRu8R82oQg=;
 b=jyW+nH6aHi3n4wfLd58CXlihNruum+DGl+TNUcVX0g1bmBe1NRhf1iFH/Pw56bo3LTcl/sXIilxhsnmaoO00MIxPs1SdzPVjJxExgH2qcjpaaAKpaQeuiDTdM8km37h1ucV0+FyF43DoIz0a47UhdswnMMoak/5DDCRcFS/CVO1Uu+vPud32qxx+jEijcuRp8UtdxwzUBXfBNZyMSUH6atnugXbCDfA0S+O0wdcO1OyPN/FkFVAq8X/9mrF+o9uLzawYyl4zNssVxf2jfWy5n83Z1BEqZjmRL1FCpVIBrc2y3YEhYhDaaF/n6O2RACftKGvPNDJANwdsjlWnM8hMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcQ7jPWGH2XvzeR29p3Y0nJ8uvv3gxE4aBRu8R82oQg=;
 b=QN28O1Oi5KV89zMV3D9Mz50t+bKUnxB8v8ckjYItZdtj3tWC/1VoZX2FhiwbRQnbo+FuiGdXwRkw+9UISm+xT9g+rO0l3VyUI1ZNz8uYftJNBAVUSjZQH3mgIOYlwsCD4ItoCyGcaoE7hOUnd+QleSPg3viGtfajiPsU2qZqjTxcc5ohQg9pIGn48RFsxecYbyllSKCprAZ1TOLf4vsDDEjCcTCUpt3KyI/059WPbvZH/403lzrXxwkxp8mkxwQ0H7HVKajZh1RBGFyC4E9mCI09IGBIGVZweOegBJn5TBCjR6nqm+0lQa7ASO/y1eM6HhSwoJ9EvfS3XRRcocXmwg==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by CH0PR12MB5122.namprd12.prod.outlook.com (2603:10b6:610:bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 19:25:23 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::5a75:6949:e897:bf85]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::5a75:6949:e897:bf85%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 19:25:23 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Aurelien Aptel <aaptel@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>
Subject: RE: [PATCH v9 01/25] net: Introduce direct data placement tcp offload
Thread-Topic: [PATCH v9 01/25] net: Introduce direct data placement tcp
 offload
Thread-Index: AQHZKolphh+eXtwjPESkoIPQ0zMX2q6llI2AgACIJfA=
Date:   Thu, 19 Jan 2023 19:25:22 +0000
Message-ID: <DM6PR12MB35649D22C1B41F895344E239BCC49@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
         <20230117153535.1945554-2-aaptel@nvidia.com>
 <65d3fab9c64423fbf9841b21448fe48cd825070c.camel@redhat.com>
In-Reply-To: <65d3fab9c64423fbf9841b21448fe48cd825070c.camel@redhat.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|CH0PR12MB5122:EE_
x-ms-office365-filtering-correlation-id: 4f213fe0-2ade-4237-8d9a-08dafa52e90a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymePHRgzWd3h1PUgeeKaTRAxAiELneQE09q3oPeucBRSJtH1VZZvXTw3Uj6QlKulIBcarmsTNoC2rZCNMc24qXLoHKjeN6LayXKmi6HMe0R+sWLNlhbP3Y0Yx8Xhmg+jx2apolz4+cz7ZhXMHObLL7UVy6GBExsyxU4irUeyr8Nj4SV8f8+OpHwXfLvpXNbERJYyqZ24UjJZy002DSVt10+tEhtiaCaVx54w3M+ZSp76j8qiZF8JmQwU+SXcktEIF5oOl9CmQrUaIcNchY8sUN/S/Ws62DHQ6fbHNts1uShA+k0PG/Vyal6UvSB8YZPMVrPlvQlTOVNMb/MlCQeAXu2CPiYzL89IViJ+RynEJ4S39tVY5tw2/OvwxVb29YAHIj4UHoK1xszd/rVkbe9vR9BJVbxFludRV2V6vt1+ab3iDcoBJ8pFjrVPPwFc3gq00J81ipPtVo6nSjdBK1Jp+xuGLjdUnpvtQoiVZ5bcH3I9wyOeUtYejD8n9p1+EvdIu3MYIcDdJ7yi1vLQFOX1cztvYgAwSEqVPobPVdAJ+MERetkWo0Zn819VQ2SA5728rt44hWbD/5OYq+VC3Rrsz5jKaFeOTZWl0lursAgAil7sFPdfbRcB5ERPhoeJLD6K2/xYgRkExMLjZNS1hBcfs3k+FYp3lUd/bBS2/K4Z1O6H9OobV8fwDlFSLchSSjbsqzRi+Xle58POAZJeTB5FhQveIlEnQ8wLy3KzjqXJvIs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(921005)(55016003)(38070700005)(107886003)(6506007)(71200400001)(478600001)(7696005)(86362001)(2906002)(54906003)(4326008)(7416002)(5660300002)(122000001)(316002)(66556008)(66446008)(8676002)(64756008)(66946007)(76116006)(110136005)(33656002)(52536014)(41300700001)(8936002)(38100700002)(66476007)(186003)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHN4UWZqUEw3SEtJQmdXRXVTd2R1UkNHVEpPVUc1a2l3MktwcWExQkJDa3Ry?=
 =?utf-8?B?ZDA1ZmlsdHA5dTA2T1l1UXFSMTZDTlJkeDdxQW1WV3RmdVJhNjFnR1l1WUFR?=
 =?utf-8?B?bVBrZC9TVnRxbDkxcFhyN2orTlBBYitEdTZqRTZSNnh5MktlV0FpWnZPRTlD?=
 =?utf-8?B?bEwva2ViQ0lRaVIzYXVFdHBvcUNxU0xuV3dLUE4zWGFlVDI0TkxCN1lrb0Nv?=
 =?utf-8?B?M1gvMnJscVVHdmxiQXBLYkV1UU41ak1kZ281K1pYTmNUYzdBSWQ3eGZnL3Bw?=
 =?utf-8?B?Q2pHZjFKb3c0eTJlRHg4UHBwcHkzWERoQ0hWbFF1ZytFT0xEUC9rZDhCSjBS?=
 =?utf-8?B?S2Nyb2d6aDZlNVBNUUxzdmdocENxVDJoWEwzU1QwdmFaL2xXdEozekhYd1Vq?=
 =?utf-8?B?anlKQ2lxQlRxZENIbEtwTlVMeWpTcWh3dGkzYmQxUzdLL3ZUMCtnVlNwQU5s?=
 =?utf-8?B?NDhtdjZrRis5RGJ4TDFUQVBxYTJMV01pSXBSWG9mU0RjYWtQZ05lWVQzazFn?=
 =?utf-8?B?cFlCT05lNmUwUUdsQ0NrM0VGUERiOFN4R1owYU54bC9rZ3N6SEQzYTRWVzNL?=
 =?utf-8?B?YS9aZTdJNTJVcS9JU0pmcTlaTU9jMmtVejVSV0VoMlNCYldNVGZ4eUVkcEd1?=
 =?utf-8?B?dGhXalFBSTBJSktBUC8zdk1yUUJjVmxvUFZlVENRUEdBQ0JvOFA3WFRTTERK?=
 =?utf-8?B?L05lcU95SzIxUWRQd25uYmRxd1NHRTFiMFp5THdHSmFjM1A4Tk1Rc1lNRzZW?=
 =?utf-8?B?RnBzZzBBSXhHZHJhMENqdndFWEp2WmlabkdoSUtHL3I0bDYyRElwUlNCN2ph?=
 =?utf-8?B?MUtNZ1YwQjV5Ty9NWXBnQnNGTGxqVExJU3k0SmhmZlNNTmM1Nlg1QyswRVVt?=
 =?utf-8?B?aE5VMGxBNHp2dFhvMlNEcnRKRW9WK2NPU3h5ajg2RnRRWUNZVWN5R01zSU94?=
 =?utf-8?B?ejVVbVMyNFk1UWRHVjJYRTExcnhESGRqOTZYSGxiOFRyc3pHeXlyMDFtOUhO?=
 =?utf-8?B?NUdNTDNLWS80d1FMR2srd01QOVBSTTJQbU5PRCs0ejU3WS96ODRtVWZZWmhG?=
 =?utf-8?B?MWdXQjg4TkRyYmc5bTdsVlhwd290Q3RTRm9tRDFwNFllQVNzSGlCbXFVNFE0?=
 =?utf-8?B?OTJ2VGxUTnppd1pDRDR1c0pQM3VqMHY3VjZIcFp3bldqdHVqZ0xPYzJhdWNN?=
 =?utf-8?B?c1BYVnpSakxUTld4RlRFckJ5bGdkUHF5NzQ3YnkzSStETzIxejBEdkxTempR?=
 =?utf-8?B?aTBPR0pJNUpnbjlWVElNQzJ4M2JLdldhVThWYU0wSk02TWp5bG1JNTF2K0VP?=
 =?utf-8?B?QkVVNnVNUTlkcEhJdThOUzhSMVROY3Zzd0I0TGxOMWVyQU5uZGg1ckZDUmw2?=
 =?utf-8?B?VTNIaEc2aHpFMFdCRmlpUk1FNmtSR2tzc3pOcW5hRTZYSWZFc1Uza2Zvd0FW?=
 =?utf-8?B?UUp0bzJxajRrbDFCN25WcnJ1Y1haSHMvWFg1blloL0lRL3dKRDFMNTVjZlJQ?=
 =?utf-8?B?Y0Q2WVBjMmxwRW50dVZDNHh0aERTaTYrYmI4ZmpnUU9kaUdzWW5UaVdPVjRt?=
 =?utf-8?B?Q2lWaHFFZkhOajJLdmpqS2FkQXM3RmRzZm1uNjNDVGJoNnU5V0FmcDFSRUZ0?=
 =?utf-8?B?b2RJSU1uWGhtOVRuak8wV3hmTTc3VjhwcXRWMDhBSVdHSDVBY2V0b214ck8w?=
 =?utf-8?B?TmgrWkJYN0JPOFU4VmJmcWQwdzFCb3hkREdPV2NnaUo1bnBsTm5XUWVmS1RX?=
 =?utf-8?B?RDNtQ1BPbktpbTJoMFo4YjlQbXFONDl5NTg1K3RUTGpDTVV4THdjYmYrQmlN?=
 =?utf-8?B?TFBJdVFjZWhDSWljcVVsQ3cyRHdvaHJ5N2g5UEIyYlVmcUxNNGc1RjBPSVpM?=
 =?utf-8?B?cHh2K2hHWTZPUk4xdnhGYTNPZHlyYzJmTlNqc2didzlWRitneHpieVhuVVFE?=
 =?utf-8?B?Qi9FWlAvQjAyVU5ndXhpbU1ZNFZYVWxCK2JxZmFuRjBrQ0dwOE1lZUZRV1l0?=
 =?utf-8?B?NEJqTGlGTDhRYVFNc2ZCK2JzS0h4RVByZnU4am05OTBkajdoSjVtTnhDbUIv?=
 =?utf-8?B?T0p3WEgwZEdzcUgzSEVvQzJ6aERYYTRBaHdSc1huODlReGNnWDg0UCtsNFZW?=
 =?utf-8?Q?PWmY9+MhlzKQeDquPXzn2Lj52?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f213fe0-2ade-4237-8d9a-08dafa52e90a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 19:25:23.0235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzoHO/ZLWCPsMOAOrMv6HCRSrBGxXvy3a26W3Lq2j2vhA2j24xi7slsLuuHnJL1Mj2b5HXTtb3BT8KIdWLvGcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5122
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAxOSBKYW4gMjAyMyBhdCAxMjo1NywgUGFvbG8gQWJlbmkgd3JvdGU6DQo+IA0KPiBI
aSwNCj4gDQo+IEknbSBzb3JyeSBmb3IgdGhlIHZlcnkgbGF0ZSBmZWVkYmFjay4NCj4gDQo+IE9u
IFR1ZSwgMjAyMy0wMS0xNyBhdCAxNzozNSArMDIwMCwgQXVyZWxpZW4gQXB0ZWwgd3JvdGU6DQo+
ID4gZGlmZiAtLWdpdCBhL25ldC9pcHY0L3RjcF9pbnB1dC5jIGIvbmV0L2lwdjQvdGNwX2lucHV0
LmMNCj4gPiBpbmRleCBjYzA3MmQyY2ZjZDguLmM3MTE2MTQ2MDRhNiAxMDA2NDQNCj4gPiAtLS0g
YS9uZXQvaXB2NC90Y3BfaW5wdXQuYw0KPiA+ICsrKyBiL25ldC9pcHY0L3RjcF9pbnB1dC5jDQo+
ID4gQEAgLTUyMzQsNiArNTIzNCwxMCBAQCB0Y3BfY29sbGFwc2Uoc3RydWN0IHNvY2sgKnNrLCBz
dHJ1Y3QNCj4gc2tfYnVmZl9oZWFkICpsaXN0LCBzdHJ1Y3QgcmJfcm9vdCAqcm9vdCwNCj4gPiAg
ICAgICAgICAgICAgIG1lbWNweShuc2tiLT5jYiwgc2tiLT5jYiwgc2l6ZW9mKHNrYi0+Y2IpKTsN
Cj4gPiAgI2lmZGVmIENPTkZJR19UTFNfREVWSUNFDQo+ID4gICAgICAgICAgICAgICBuc2tiLT5k
ZWNyeXB0ZWQgPSBza2ItPmRlY3J5cHRlZDsNCj4gPiArI2VuZGlmDQo+ID4gKyNpZmRlZiBDT05G
SUdfVUxQX0REUA0KPiA+ICsgICAgICAgICAgICAgbnNrYi0+dWxwX2RkcCA9IHNrYi0+dWxwX2Rk
cDsNCj4gPiArICAgICAgICAgICAgIG5za2ItPnVscF9jcmMgPSBza2ItPnVscF9jcmM7DQo+ID4g
ICNlbmRpZg0KPiA+ICAgICAgICAgICAgICAgVENQX1NLQl9DQihuc2tiKS0+c2VxID0gVENQX1NL
Ql9DQihuc2tiKS0+ZW5kX3NlcSA9IHN0YXJ0Ow0KPiA+ICAgICAgICAgICAgICAgaWYgKGxpc3Qp
DQo+ID4gQEAgLTUyNjcsNiArNTI3MSwxMCBAQCB0Y3BfY29sbGFwc2Uoc3RydWN0IHNvY2sgKnNr
LCBzdHJ1Y3QNCj4gc2tfYnVmZl9oZWFkICpsaXN0LCBzdHJ1Y3QgcmJfcm9vdCAqcm9vdCwNCj4g
PiAgI2lmZGVmIENPTkZJR19UTFNfREVWSUNFDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgaWYgKHNrYi0+ZGVjcnlwdGVkICE9IG5za2ItPmRlY3J5cHRlZCkNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZW5kOw0KPiA+ICsjZW5kaWYNCj4g
PiArI2lmZGVmIENPTkZJR19VTFBfRERQDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaWYgKHNrYl9pc191bHBfY3JjKHNrYikgIT0gc2tiX2lzX3VscF9jcmMobnNrYikpDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVuZDsNCj4gPiAgI2Vu
ZGlmDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiAgICAgICAgICAgICAgIH0NCj4g
DQo+IEkgKnRoaW5rKiBhIHNpbWlsYXIgY2hlY2sgaXMgYWRkaXRpb25hbGx5IG5lZWRlZCBpbiB0
Y3BfdHJ5X2NvYWxlc2NlKCkuDQoNClRoYW5rcyENCkl0IGlzIG5lZWRlZCBpbiB0Y3BfdHJ5X2Nv
YWxlc2NlKCkgd2hlbiBTS0JzIGFyZSBtZXJnZWQuIA0KV2Ugd2lsbCBmaXggaXQgaW4gdGhlIG5l
eHQgaXRlcmF0aW9uLg0KDQo+IFBvc3NpYmx5IGV2ZW4gaW4gdGNwX3NoaWZ0X3NrYl9kYXRhKCku
DQoNCkluIHRjcF9zaGlmdF9za2JfZGF0YSgpIGl0J3Mgbm90IG5lZWRlZC4NCg0KPiANCj4gQ2hl
ZXJzLA0KPiANCj4gUGFvbG8NCg0K
