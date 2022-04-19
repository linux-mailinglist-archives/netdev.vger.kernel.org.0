Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57739507961
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353655AbiDSSu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiDSSu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:50:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2092.outbound.protection.outlook.com [40.107.244.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8363286FB;
        Tue, 19 Apr 2022 11:48:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoliwKEaFs9o6RbUQUXB2a3vSPKNdCBhWL3UUyk2zaddK7Y/afgJWfNdPigD8yghamBodVrSf3C1/cX0ihFgkfNiTYP3gSMt75XbMlEE7Xv20Ztk5yi+HmM2rxQZ9KfHnAnHk+xYTqLDR1HA524saUbPx7FhB0ZxEKO5Bnwsq29CxaGX88oJXRCNzj93XdLz1P3fXh1w5/9Fl5oBvqy7y5p0Y9AkX2+A0ohnxXNzpSVKagWSM6hV9xwQwb7PFUcH5iDvyfN/ChjHX/REKRJgAZjB2XxEcjdT74V/vM3ojN2Cgsb22MhhT/qfMFZfDZlhXPsH6NHxPJ2ZxDqnH3+urg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs3gqnyxysGIXAXGdWFti7SNS8iVf61Cr7bukFNLv6M=;
 b=RkPDVvbnl2z3T+XZIzLLgkQyjfl6XRosaeUZs0XOGUM/uOJhhWZhXttcVvo9vI+x5MuJ2rEdiiheMHA3wbMNRRMdCzPM+53wrqr1zml5Vnnj89FHV22VpibKi1DbKGsrl7rwylyQ8cNqhntrHt9kWJH5R1QBwHn21Zk4P093v/H+K78mC98QVkXpO72qI80KKAsurf87+X+w6qB+bySJgtCpeFJ4gQBfJcVSk9AByWTJkPM2Y0w/8D4uo49HTlR5EwocdyqJDhv05ByjAaS5UheSzx8+bhigJQdzIXmGC60+G8QKy5m1SFcJQcHN97bMmSp2t2iPwmuTD3slAryDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rs3gqnyxysGIXAXGdWFti7SNS8iVf61Cr7bukFNLv6M=;
 b=ddxgKKsWi4knCQQWHPCiFXkV5ouePzzYo/28woc6Rmz9iDc/o0/6Pp3o7O6mokwyGmsK4ZFVaC0ohE3xF5c5oxkz0YmbkNyypA2SfYC4lH4tJkE4FxobZ1bXjcgmkI1gR9uJpPF/aGQSrN7sKHSVF/THQWFoZegVP5zn4D825XQ=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BYAPR13MB2439.namprd13.prod.outlook.com (2603:10b6:a02:bf::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Tue, 19 Apr
 2022 18:48:07 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006%7]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 18:48:07 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>
Subject: Re: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Topic: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Index: AQHYU0ShVuMmk9QygkCkWs0LWSNy16z2lWmAgADRSQCAAC6+AA==
Date:   Tue, 19 Apr 2022 18:48:07 +0000
Message-ID: <8597368113bcc38e605e9bbd11916a0ac8b7852d.camel@hammerspace.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
         <962bbdf09f6f446f26ea9b418ddfec60a23aed8d.camel@hammerspace.com>
         <06AB6768-AA74-43AF-9B9A-D6580EA0AE86@oracle.com>
In-Reply-To: <06AB6768-AA74-43AF-9B9A-D6580EA0AE86@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 457308fe-d3ad-49ee-8efe-08da22352521
x-ms-traffictypediagnostic: BYAPR13MB2439:EE_
x-microsoft-antispam-prvs: <BYAPR13MB2439B2A3A1379B157744B383B8F29@BYAPR13MB2439.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MUFaLD6Rb4tkSIv3elHQt6HdEllPEydmI1DUyZqJJ/nNUafuI3IiZ01Cv1bOAkbFSoWlAh3B66o7G/RJOY5xilcy6AkP1a8S68dAqwZ8ihQQV2SB0tG2Ja+WYfdaOlZh4gF1ZevLUx/eyIRMh6GyeLZDRGkXWqbuWHF4EUgwtM+N0PGagwIS7Mv5Dvfw6lCoH/hF3ExKy9LD/DXxLYrQ52SV4SPV2DGhgIqPemRxLbc1oDtSjJGQFYy0KTvHNJs2X7cCN/Zszubr2gRYzL4oZLLovqZ3QPZcDV+KXDmuuzCRXS47DJBBNZax8SIp9EgAmTGAqLTy8yQ66c61+Xj70EV1nhy04v9qOcndybM7mbGCVzAh/CUGOvDJWUwEQkfDZtPig6s+wlyVb4kGrJJEE97obJaAoz3uS8vxgFyAf1mM5NfFTeUqB0xMtQBvRanJeRRV6MH2WDEwEYLjYdDP1HG4RO3H184MEigXtRE6dLTURuEPp/5twlEeOTTog0nNXNtnRuV44No9Ve8km/iIoccbdVdJu87o6lNJit9JlPz9Q/pcmLtgVge/ot2fhA1Owrdu7eM21SsaIq0qsoT35PR8LSFNTL4dO16xa+iDxUQZpGOB6u7zjwP6x2iA4YPHBIhnBDk2kL8Dz8kpYdu2Itkb4znbfoVa5i491EE+AhT72On/ZUba1oZsbLYKOCKTBsRHlxqcIcVabbtd6enqBa9+CO89gpTAuf0h8RsKSUp4IDLASemsFT8eNB6npp6lDyL99fylq64LFM/WhtlGiFVL0D+47waRD9ZJDGWLas=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(64756008)(66946007)(8676002)(4326008)(66556008)(26005)(6916009)(2616005)(54906003)(83380400001)(66476007)(86362001)(122000001)(6486002)(966005)(38070700005)(38100700002)(316002)(6512007)(71200400001)(2906002)(186003)(508600001)(6506007)(76116006)(36756003)(53546011)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVB1Mi9pYTZCR3BtVHR3ankwcEVjYXY1UmY4cWZQUWdENW5qNjJhTzBEUHha?=
 =?utf-8?B?UlVDM2lPbndvUjYxcFYvSm5BbTREK1MwYUxZb0Z2RTI5Tm9BdkR1TzREYWZ3?=
 =?utf-8?B?UHpHNmFNOS9BZDlxdksya21tRzNHNkhzbkRaZ0VoZ1dnL2U0NzB2S0R0dDlj?=
 =?utf-8?B?SWxGM0lNZGpMRkVjVlpFb2dhdU9MMkpKWlZ6NGxVNTlYWDkvYXFYUmZBNVJN?=
 =?utf-8?B?S2s2YnZ6UU5sd0luZ1FodnE3Z0hwckZCWm85WFFKNkhPU0JmOFhhSjZ5dTFr?=
 =?utf-8?B?SHdlUzZuK28wakgxbDdoajNMbEF0aDhqenFXTlhBT2UwVHQ0Q0lyUjRoN3F5?=
 =?utf-8?B?cHlqdEJUbC9KVVFhS3hNWFhsV3ZMWmo3UlJ2Q1FrYklOSHhoOHFSVDQyNGdj?=
 =?utf-8?B?MFlncUZkaHNaQ1JXKzA0TUNNNjVQNytNNnp1ZGsxbGVPOE1lR3dacTd0M01M?=
 =?utf-8?B?THkvUWVyN2wwbjk2WGRraWhTRUpmSTV1SGZHM1Z4OFVuRmhtc1RKR09nZXlJ?=
 =?utf-8?B?QURhWjNaa0tKN081M1k4NmZSTkp2dWMwZnRrcjRQTGs3N2J1ejYxQWRFcE5N?=
 =?utf-8?B?Vi9hSXpZRVBoQnhUT3BlbUR5bC8yWnk5T0FqL2hpeGxEaDkxNWtOcEdmTytR?=
 =?utf-8?B?Z0V2akNSMEEzOGlla1NIYlFGa0Yxdm5tT0tPYjhZbFdXaHRrNTlpQ3VVWWU4?=
 =?utf-8?B?dzVlT0twOVA5aVVQdjVUQ0F6VmtlQ3Y3alo4bWtPazRBSHhGbW1tSHdDZHpq?=
 =?utf-8?B?Uy9iZUNzTmloTHp3bXJqZnIwdWlRQWxoMjdUSTNoc21qcXZ2ZTRMUUdSOHpP?=
 =?utf-8?B?Z2dBVGN1NTAxUmZWK1MzYTJLa1lSbVpUUEZvbzhLaTA2bTFUY3pPakcrc0h3?=
 =?utf-8?B?eHZLUXpHY1MvbHVaVFJPekdQTTRkV3FQcHVWMFRPRzR4TUNYdi9KUVlLZ05C?=
 =?utf-8?B?enRML0lvSSs0UWpwY00vVGdtQXhkak9TTFFtbllDMDV3UVJhZUFjWVNFR0lW?=
 =?utf-8?B?bytid09LUnJhUzlLNWZjelFjeHY5S1AvbVlKdHZ3WWplMnRwYzdJQnpmVHFk?=
 =?utf-8?B?a3h6VnE0TlBVY0t5YTRDcmZKNDN4NkJNWDRHRlVmSDBZUlR1THFuVGs5Wnow?=
 =?utf-8?B?N1J6U2JFbmMwR1FVRGt2RHoxUDllUnpqR0IyNHdXM2tNTWtWRmlYNXlBNTV2?=
 =?utf-8?B?WVIwcXRDZW93dXJlU29vaHc2RDlaeUlKM2p6WWtnVERsSjM4ZnZKQWhrdnRL?=
 =?utf-8?B?QUhtem95TzJvcVhqcXpKWXhjS3pRakttdVVYWWUxNE1mclpmaWcrUjNMMFVu?=
 =?utf-8?B?R3E0R09iYnpEbnE0UVJaVEp5TDBEYjEyK1Yra0xYcU9ra2ZDUStuZVU4cG16?=
 =?utf-8?B?OWUyZFZPR0M1OCtqZldyRzZvMmJxVXhTdm1QYlNYd1lKRzBweWUrL09ZYjZH?=
 =?utf-8?B?YUJrVGhhelFsNmNZcW9zbk5KM1J0MENObFpKQ3UxdHZNWUJDdkRSOEczNm01?=
 =?utf-8?B?NEFsd1ArbThKTzNTSEtJRk92VDl5U1JEbkVETHJSZ2hvc1orek5jcW1GZXFQ?=
 =?utf-8?B?WVNHVVdrbDlSc1k4THErWjhKZHhlam1ROHFhRkVnd001Nkt5K3RhVGtzVjNH?=
 =?utf-8?B?S1ZHNVF1bi9ZVWcwNzdnT25Vd0VmaERXUjhudS9LSG1pS1l1M05TaE9xRm01?=
 =?utf-8?B?cVN5d1RCNy80cFJUL0tNbmdPZ3pOdHh2TlhGQVpIZEl1NmltTEU4T2J0ZFBC?=
 =?utf-8?B?UXN4d3VZVngvOHFNSjB0c0UyTHZKa1RNZFh4N2t3Nm9ablVsRlorN05ETit5?=
 =?utf-8?B?czBIalhIa0tWUCtlVUVRVjFuQ2hOSUJOUFc4S2ZhQUZVQy9JNEpvUWVhOEMz?=
 =?utf-8?B?SjZPYlJZc0RVVHdzakNqcDhRb0c2cHlkS3pjbk9OM3lBVVk0NzQzWlpENlgy?=
 =?utf-8?B?dGdYSE1hSEtRT2pUb0tKTzFsODhWNGdaZTJjQTR6TlBNdGp6VjNsWjVwamxY?=
 =?utf-8?B?eFZ0Q0REL2dpRnFKbzdtSUpqMHJTK2lHVjVCVVg1Z1JVa0dyMTRyc0JLTHNr?=
 =?utf-8?B?YStOTExVTmdKS0YwYmFudXJudDNJYi9XTXlMUWJUY2lka3BscUtwYTJ1MHl3?=
 =?utf-8?B?QlVKME45enBpc0lGUGtoK3g3SWxPUENCb3hDdGlqdThDcFc5RncvK3Z3TS8y?=
 =?utf-8?B?T1FRb0FJUVRuNFVnWklNL0ptUGxoTFgrOGV1Wi9ocEpqR0ZZVmRjT2JoYXdB?=
 =?utf-8?B?ZXh0RVZBcVhqdjh4cWN4TlpOUmVxZlgyRGJ6QlpTNkt0a2FKK1F0eTNqOUtN?=
 =?utf-8?B?SkN3aXNjSkMyVFZIakRCRnF0OFc2azk1ZXZwcFZ4SFRnakNQK08xTVI4SlBP?=
 =?utf-8?Q?fySqqYiKEqlzzMEo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3020D75696A7F428D820AE4C0FF1FDB@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457308fe-d3ad-49ee-8efe-08da22352521
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 18:48:07.7445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRysUtWH5+MYd8xNioOntkJgUxKF11XddjLta/lveME4+dtDZJx25owR41hhwOICj05PGTST1IgJEFr5cO3hZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA0LTE5IGF0IDE2OjAwICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6
DQo+IEhpIFRyb25kLQ0KPiANCj4gVGhhbmtzIGZvciB0aGUgZWFybHkgcmV2aWV3IQ0KPiANCj4g
DQo+ID4gT24gQXByIDE4LCAyMDIyLCBhdCAxMTozMSBQTSwgVHJvbmQgTXlrbGVidXN0DQo+ID4g
PHRyb25kbXlAaGFtbWVyc3BhY2UuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIDIwMjIt
MDQtMTggYXQgMTI6NTEgLTA0MDAsIENodWNrIExldmVyIHdyb3RlOg0KPiA+ID4gVGhpcyBzZXJp
ZXMgaW1wbGVtZW50cyBSUEMtd2l0aC1UTFMgaW4gdGhlIExpbnV4IGtlcm5lbDoNCj4gPiA+IA0K
PiA+ID4gaHR0cHM6Ly9kYXRhdHJhY2tlci5pZXRmLm9yZy9kb2MvZHJhZnQtaWV0Zi1uZnN2NC1y
cGMtdGxzLw0KPiA+ID4gDQo+ID4gPiBUaGlzIHByb3RvdHlwZSBpcyBiYXNlZCBvbiB0aGUgcHJl
dmlvdXNseSBwb3N0ZWQgbWVjaGFuaXNtIGZvcg0KPiA+ID4gcHJvdmlkaW5nIGEgVExTIGhhbmRz
aGFrZSBmYWNpbGl0eSB0byBpbi1rZXJuZWwgVExTIGNvbnN1bWVycy4NCj4gPiA+IA0KPiA+ID4g
Rm9yIHRoZSBwdXJwb3NlIG9mIGRlbW9uc3RyYXRpb24sIHRoZSBMaW51eCBORlMgY2xpZW50IGlz
DQo+ID4gPiBtb2RpZmllZA0KPiA+ID4gdG8gYWRkIGEgbmV3IG1vdW50IG9wdGlvbjogeHBydHNl
YyA9IFsgbm9uZXxhdXRvfHRscyBdIC4gVXBkYXRlcw0KPiA+ID4gdG8gdGhlIG5mcyg1KSBtYW4g
cGFnZSBhcmUgYmVpbmcgZGV2ZWxvcGVkIHNlcGFyYXRlbHkuDQo+ID4gPiANCj4gPiANCj4gPiBJ
J20gZmluZSB3aXRoIGhhdmluZyBhIHVzZXJzcGFjZSBsZXZlbCAnYXV0bycgb3B0aW9uIGlmIHRo
YXQncyBhDQo+ID4gcmVxdWlyZW1lbnQgZm9yIHNvbWVvbmUsIGhvd2V2ZXIgSSBzZWUgbm8gcmVh
c29uIHdoeSB3ZSB3b3VsZCBuZWVkDQo+ID4gdG8NCj4gPiBpbXBsZW1lbnQgdGhhdCBpbiB0aGUg
a2VybmVsLg0KPiA+IA0KPiA+IExldCdzIGp1c3QgaGF2ZSBhIHJvYnVzdCBtZWNoYW5pc20gZm9y
IGltbWVkaWF0ZWx5IHJldHVybmluZyBhbg0KPiA+IGVycm9yDQo+ID4gaWYgdGhlIHVzZXIgc3Vw
cGxpZXMgYSAndGxzJyBvcHRpb24gb24gdGhlIGNsaWVudCB0aGF0IHRoZSBzZXJ2ZXINCj4gPiBk
b2Vzbid0IHN1cHBvcnQsIGFuZCBsZXQgdGhlIG5lZ290aWF0aW9uIHBvbGljeSBiZSB3b3JrZWQg
b3V0IGluDQo+ID4gdXNlcnNwYWNlIGJ5IHRoZSAnbW91bnQubmZzJyB1dGlsaXR5LiBPdGhlcndp
c2Ugd2UnbGwgcmF0aG9sZSBpbnRvDQo+ID4gYW5vdGhlciB0d2lzdHkgbWF6ZSBvZiBwb2xpY3kg
ZGVjaXNpb25zIHRoYXQgZ2VuZXJhdGUga2VybmVsIGxldmVsDQo+ID4gQ1ZFcw0KPiA+IGluc3Rl
YWQgb2YgYSBzZXQgb2YgbW9yZSBnZW50bGUgZml4ZXMuDQo+IA0KPiBOb3RlZC4NCj4gDQo+IEhv
d2V2ZXIsIG9uZSBvZiBSaWNrJ3MgcHJlZmVyZW5jZXMgaXMgdGhhdCAiYXV0byIgbm90IHVzZQ0K
PiB0cmFuc3BvcnQtbGF5ZXIgc2VjdXJpdHkgdW5sZXNzIHRoZSBzZXJ2ZXIgcmVxdWlyZXMgaXQg
dmlhDQo+IGEgU0VDSU5GTy9NTlQgcHNldWRvZmxhdm9yLCB3aGljaCBvbmx5IHRoZSBrZXJuZWwg
d291bGQgYmUNCj4gcHJpdnkgdG8uIEknbGwgaGF2ZSB0byB0aGluayBhYm91dCB3aGV0aGVyIHdl
IHdhbnQgdG8gbWFrZQ0KPiB0aGF0IGhhcHBlbi4NCg0KVGhhdCBzb3VuZHMgbGlrZSBhIHRlcnJp
YmxlIHByb3RvY29sIGhhY2suIFRMUyBpcyBub3QgYW4gYXV0aGVudGljYXRpb24NCmZsYXZvdXIg
YnV0IGEgdHJhbnNwb3J0IGxldmVsIHByb3RlY3Rpb24uDQoNClRoYXQgc2FpZCwgSSBkb24ndCBz
ZWUgaG93IHRoaXMgaW52YWxpZGF0ZXMgbXkgYXJndW1lbnQuIFdoZW4gdG9sZCB0bw0KdXNlIFRM
UywgdGhlIGtlcm5lbCBjbGllbnQgY2FuIHN0aWxsIHJldHVybiBhIG1vdW50IHRpbWUgZXJyb3Ig
aWYgdGhlDQpzZXJ2ZXIgZmFpbHMgdG8gYWR2ZXJ0aXNlIHN1cHBvcnQgdGhyb3VnaCB0aGlzIHBz
ZXVkb2ZsYXZvdXIgYW5kIGxlYXZlDQppdCB1cCB0byB1c2Vyc3BhY2UgdG8gZGVjaWRlIGhvdyB0
byBkZWFsIHdpdGggdGhhdC4NCg0KPiA+IA0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5G
UyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJz
cGFjZS5jb20NCg0KDQo=
