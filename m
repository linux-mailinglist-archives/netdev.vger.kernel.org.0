Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300FD4B95AE
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiBQBwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:52:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiBQBwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:52:16 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2096.outbound.protection.outlook.com [40.107.101.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F07104A45
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:52:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfYOpa+L63DTfr1wSaWafpzct+bw4niwgZZMTipnZO1QBqbUFo3TXZZyB1k+Iznv7Lx3bPOU+NohSUsnpgInUQDLqVOtAXw6U/uGNWeljRslgbbCWmCvGrlNarnIiLcMo+hUP2HM01Vx//8rLIWJkqQ8aBpRmmhQncinAh++KOLeM0jUKQvacTgnN1rB7qaa0tHm4mSZbhqkgKe9u8gD3kL6a2XM6k0FaQ2j5j7GQVnmBi6C2E0hrdW5H8uInH/a12kP1eFWWYCOdBAZppTHq5KRbVSqK24VswXipu4LDyALJtDxiZ3kiq0oLhxPamU2zby+p/yA4cvgFI+BuKcmkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GG7QSDe+3QnaHDl8kPkFuefUCz1Wn44rqVpahHgeTy4=;
 b=OXtU5tkzKD4xRkUu49QZHKlfKDcDRCbhufxN6/GHoIgIdY1GJiF9rBUA7vV2y5Oa7q1Y9tfCJkOgxtkrd++O4haawn3nu+DJpgYkoa5Ar1tfJBenbXGeYjgxt/YcO9V3digeIrCfDuTt5Eu/XNEBzCz5wfTnbtXOObCOKdugB2Je7+ffl5rcxB3mTn9iOVF38nrFTjRz2ZAnAox+f6KQEdvkdNd8FReghbpTFQ3RbSlO56EXDpzyaYUnzN+d5SC3d+M49El3LpGTeWQBqGFCS+/RSmkANfIrhCRpFrKElKX00DB6umdvD288s6R22guR/MGFGmrYHCfpmJMc6V49+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GG7QSDe+3QnaHDl8kPkFuefUCz1Wn44rqVpahHgeTy4=;
 b=CUm0a3anczZssk/0VhXjD0MkjPhIXQGxb4rvskRg1Rfl0VpPIljV79itfKUYEVtuxTyuYDbleLdyGndjCh4WssBg9xLF9YvZPTKnlNmxno4AfTeVWUHGi6iT45yxq5mhGOC0Cwpjr6UYdew+09RGmghXfRhNzOctJANV6KUJp68=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1436.namprd13.prod.outlook.com (2603:10b6:3:120::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9; Thu, 17 Feb
 2022 01:51:59 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5017.007; Thu, 17 Feb 2022
 01:51:59 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Roi Dayan <roid@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Thread-Topic: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Thread-Index: AQHYEoG1Et1s4gxqYUSe1W65rALAhKx1T7gAgAhAIoCAAmveAIAAAheAgAAHpsCAACrBgIAOAWcAgAgRFgCAABhPAIAAwQEg
Date:   Thu, 17 Feb 2022 01:51:58 +0000
Message-ID: <DM5PR1301MB21729C98CF86FA399B1F8297E7369@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
 <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
 <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <8a777b6f-0084-5262-40f6-d9400f7e6b15@mojatatu.com>
 <DM5PR1301MB21722969131F70DD7FA350EFE7309@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <280e716c-a588-5c7b-d77e-d5d09bb0148b@mojatatu.com>
 <5c888335-9732-8cdc-eab2-081ddbb8f2df@nvidia.com>
In-Reply-To: <5c888335-9732-8cdc-eab2-081ddbb8f2df@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f3e872e-d8fc-4f3c-f882-08d9f1b815c4
x-ms-traffictypediagnostic: DM5PR13MB1436:EE_
x-microsoft-antispam-prvs: <DM5PR13MB14365955333496F0AAC579F6E7369@DM5PR13MB1436.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gPXYLbs4SVQ/sO2fnjMdWDDJ5IZOlsYvgPBmpc71XzxxoYmTlRmF9wLpEkszMm6KbhqYfWI6en7Dw9mKxT1ZG79c5eX/Y9vhoin/mmCpmqPoP+DS3uldIMfbYe+5+rMzJpRqyh54i8rWuqyN5QbYjIx3QJcA4Ky/61dnfWz8pC7o6cd/R9iFRDXiNwjiECo1YQUE15m+bBWefCd8xc/JSC0lGaEqW1W5taaUEXQLCXrT7yWmOKZ1AfInU3BtDG49O7p50QBhF0Ds6qLIA32n/Lmf4wz0hmcI/EQXYEZcUpF6KKeao1DJ4DYnlUU9NuhvWROjHmZmHA44uhmUYkW4jsr/LC9j2cWfr2wmAMFp2+6SMjY7jMD4wfxROojJ+ClZMs84t3tnNyeBxxqKZyz1sktTN/I4Augg6zS1cgS948A0DFt7CXbDRTsAw5eKZYj+8UGnNc3cjG/TvA207NktX6hLfAt2ZDR94ym07LFFgsDWc2nXgAtJn783qlnl9m+YDvwkkzpoKf+L8PDd+ruoy6eMei3tPZjSN2r0kqJjPpEM4GVXKqb0FrtgaXbX1HxVpZIyv0wAdqfNLTFN75743Dj8BD1Jgyr0YKDOfmjnlyf6L6tmaD86M6Uc952/KFgb1RVZjiMnAa+9A6krhXtvHvFqfzHlK74ZilY4mCKtPLzC/sEUy/HyU0SV8dwTqcx/WpTZ/7smhQNEkMx26jUJYrQzTb74TPt7g2KK+Hs3x8U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(376002)(39840400004)(396003)(346002)(316002)(110136005)(71200400001)(54906003)(122000001)(38070700005)(55016003)(38100700002)(508600001)(2906002)(4326008)(8676002)(64756008)(66446008)(66476007)(66946007)(66556008)(76116006)(9686003)(86362001)(107886003)(33656002)(5660300002)(8936002)(53546011)(52536014)(83380400001)(6506007)(7696005)(44832011)(186003)(26005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXJWbUM5Vyt6dExDajdGSmh4SDZaVlNHejJjQlZUa2QreDZuaWlzR3U4cTNo?=
 =?utf-8?B?bkYyMThoTVZUL0NXYjllbzVIRWtydENIcVo2L2xTaG9kSkZodHczNXhNKzlK?=
 =?utf-8?B?VGs2cDMzMTdaaklqaUVOMGVyTnRFZU5BNlBNb2czM3VjQ2RnQnZmV3ZtUlhW?=
 =?utf-8?B?NkVyRXNWUjNXc04rY1dmMy8xMCt1MlFNZXFpWUJhNmlNd2xDNFZpUXhwV0lZ?=
 =?utf-8?B?ejVmVzRkUXV3MndyUDRYaldjM0lvVXhseWtmQ3lWWmN5M3lvbDJLSXpDN3R0?=
 =?utf-8?B?dXhYVGlLbnVXVE85QkN0WFZLSVRmeUZjWm1RT0JaMjlsMVJPNzJVN3pKSmdV?=
 =?utf-8?B?Q1VxOGcxd0tySTlXUjlvbmhaSWhZdEZ2VGJBQWhXVFZhYndvNUN0azBQci9R?=
 =?utf-8?B?SUFLYW9UNlZ3KzV1bFZsZjJ0UXA3cE9GOHhZRTB2OEhpOTlOZG96TEMrbHVo?=
 =?utf-8?B?d2t3NHU2MXVTWXNmRUhlaXYvcmNVVUNyV2JSZ2JlL2ZpSVFMOVhySFVSaXRS?=
 =?utf-8?B?RUh3WEJvUXJqWWJnWWYyU1E4bVhrRkM4clhtSnJKUSs0a3NGZUlBTFJFZW9L?=
 =?utf-8?B?R3hXL0VWV0M0Z2F5NTVTeWRrY1JuUDg1dEwwOUVsOVR2dzNPU01INVhnSGpW?=
 =?utf-8?B?STUyMGxUOGgxdklWanR3Z1VvRG5DYzhIOEFEZEZoWkRKU1B6TW9ZYW5zL1lR?=
 =?utf-8?B?MTZpc2Jva21vcnJXbEE3TC9IbkFZakk5R0EwYzF4L0YrUjdaTy9rR0ZDVDFj?=
 =?utf-8?B?bEVmV21mejNCaXBuR0cyb29MalJkSGIrVlV3ZGs4VmhRVmowRmdGenpVYitY?=
 =?utf-8?B?Y2MrMTE3Z3E0ZDdYMGhVbGt4ZndaUzl3SmwveCtBNzUxc2RzL3JTRkdGMldB?=
 =?utf-8?B?V3JOQzhKN0pMSkxLZ2tuLy92ZVI2T0ZHYnVuWGhmY04xOEJ1ME1MTWVPL0M3?=
 =?utf-8?B?UVc0N3g4Sk9kTWIyNnJROTl1ZmpBSWprQmpnWHhwQWhvaFFONXBZV3cyWk1E?=
 =?utf-8?B?bi9lNFRiTHNHR290anNPL3lmNHYrWW4zeGFLcUFQWlZHLzh2Q2VTT01zTWFN?=
 =?utf-8?B?T2R5ak95RTkwU0trK3gxM2VzVVNHNHkvK0dicm5KRk90RktQNCs1cERvTmFk?=
 =?utf-8?B?M1J3Z0dLY0dja1FXZEtFeVBRUTlwRGNkRmNFeFo3Z29PR3l3c1lLeUpGeTgy?=
 =?utf-8?B?UjM2Z3pEVU4vWVhmQ1BzbTE1UWlaaU4xNEVhWHlJY3lJMDF2aEtNZ0NUNW14?=
 =?utf-8?B?MEJUR0lXTDM1SitUOVoxeHNhcWdPNUdJSGxOZlFwNTlWR2w2cGZxM0ZiNzBl?=
 =?utf-8?B?M3ZHS2ZXQWJYZ1ZRNzErU1hjdVVua1dEYnNBNzBLQk94aFB5Um5GYjNsLzAz?=
 =?utf-8?B?dHY5SVpDTlppNHBYbngxbWZKNEE0UUtFTnNrV1JiL2Nucndscm8vREU3cTlB?=
 =?utf-8?B?dlFNWmtpYU1kVEcwWmFzNnJjRys2UmxxNXdFRDUzUVFuWHVnaVZ2YW9WN25X?=
 =?utf-8?B?bUcrcFVmV0FJL0dITDUzbEN2UExQOWVNTTVPTWFLS0lQNFUzWTFXVGo0ZmZw?=
 =?utf-8?B?TzdwUzlObDZhV2o4Q0ZWTytqck51bGlSdk1wRWdndDRLMWczcWRQeGdRYmdV?=
 =?utf-8?B?YzEwaU5wVnhKNEFiekljdjNiS04wakJId2tTVk4xTWNWanNTU1IwSDNTZVp5?=
 =?utf-8?B?MjBROTZmNU1CS0UxYk9MMlNZVklNay9ITTRLdTBhN3BHRVhNb1dzUythejVz?=
 =?utf-8?B?MEtTTFRRS2MwWjZObSswNU5UaldmM1dXcEZVYjdvOW13cFlaRjUxSjAwa3V0?=
 =?utf-8?B?d1ZhMGhWY2w3MXg4aU5qUkJWMHpUek5rVUtjT3VidlM3YmJTa3BnV0Rqbkxq?=
 =?utf-8?B?VHJpa1dhSzNuc1IrRzl5MTZMVlprdHVUOFo0NFRtTXNQQnBtaEFETEY5WERX?=
 =?utf-8?B?QzRQNjgyYzBBZmxQU1FudzgvQzBXVmhQUEJTYkl3djdmeXRzWnZabTRYSWhU?=
 =?utf-8?B?ZEVmR2lML2xHei9QZzRoS3ltdEZwQ084OUg0UnJqc2VVZ0orTHhCMnczeEJ4?=
 =?utf-8?B?UXlCZXVmMXRJRmY1RUt6REg3WXpqZENBeDhiWVpYMklLYnBwR3hsa3BEcEkz?=
 =?utf-8?B?b2RRYTZrL01sOHpscG1zU29sOWFPTVdxejhPY2NSR29DcjIzeHJVNmZKQzdt?=
 =?utf-8?B?SzlMWjZmVHV5SDlxNHNZK2tseWtucHNsVXd3cUo3NEVVY01SeUxlZHNLa1di?=
 =?utf-8?B?VnFvVjR2a1FQNEVzNWMvekYwK3N3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3e872e-d8fc-4f3c-f882-08d9f1b815c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 01:51:58.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQaXVGUin0TGr7niI2+BaY6S0GiUYZjUIOhSek7++WpXB0Dic6tQ9XgW8pxqf1cdg9xFQTomXyJPI1W08A34QJQE5OUv1AvujE4aSt3E4O8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1436
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRmVicnVhcnkgMTYsIDIwMjIgMTA6MTggUE0sIFJvaSB3cm90ZToNCj5PbiAyMDIyLTAyLTE2
IDI6NTEgUE0sIEphbWFsIEhhZGkgU2FsaW0gd3JvdGU6DQo+PiBPbiAyMDIyLTAyLTExIDA1OjAx
LCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+Pj4gSGkgSmFtYWw6DQo+Pj4gU29ycnkgZm9yIHRoZSBk
ZWxheSBvZiB0aGUgcmVwbHkuDQo+Pj4NCj4+DQo+PiBJIGd1ZXNzIGl0IGlzIG15IHR1cm4gdG8g
c2F5IHNvcnJ5IGZvciB0aGUgbGF0ZW5jeSA7LT4NCj4+DQo+Pj4gT24gRmVicnVhcnkgMiwgMjAy
MiA3OjQ3IFBNLCBKYW1hbCB3cm90ZToNCj4+Pj4gT24gMjAyMi0wMi0wMiAwNDozNywgQmFvd2Vu
IFpoZW5nIHdyb3RlOg0KPj4+Pj4gSGkgUm9pOg0KPj4+Pj4gVGhhbmtzIGZvciBicmluZyB0aGlz
IHRvIHVzLCBwbGVhc2Ugc2VlIHRoZSBpbmxpbmUgY29tbWVudHMuDQo+Pj4+Pg0KPj4NCj4+IFsu
Ll0NCj4+Pj4NCj4+Pj4gUHJvYmFibHkgdGhlIGxhbmd1YWdlIHVzYWdlIGlzIGNhdXNpbmcgdGhl
IGNvbmZ1c2lvbiBhbmQgSSBtaXNzZWQNCj4+Pj4gdGhpcyBkZXRhaWwgaW4gdGhlIG91dHB1dCBh
cyB3ZWxsLiBMZXQgbWUgc2VlIGlmIGkgY2FuIGJyZWFrIHRoaXMNCj4+Pj4gZG93bi4NCj4+Pj4N
Cj4+Pj4gRWl0aGVyIGJvdGggYWN0aW9uIGFuZMKgIGZpbHRlciBhcmUgaW4gaC93IG9yIHRoZXkg
YXJlIG5vdC4gaS5lDQo+Pj4+DQo+Pj4+IGFjdGlvbiBpbiBoL3fCoCArIGZpbHRlciBpbiBoL3cg
PT0gR09PRCBhY3Rpb24gaW4gaC93wqAgKyBmaWx0ZXIgaW4NCj4+Pj4gcy93ID09IEJBRCBhY3Rp
b24gaW4gcy93wqAgKyBmaWx0ZXIgaW4gaC93ID09IEJBRCBhY3Rpb24gaW4gcy93wqAgKw0KPj4+
PiBmaWx0ZXIgaW4gcy93ID09IEdPT0QNCj4+Pj4NCj4+Pj4gVGhlIGtlcm5lbCBwYXRjaGVzIGRp
ZCBoYXZlIHRob3NlIHJ1bGVzIGluIHBsYWNlIC0gYW5kIEJhb3dlbiBhZGRlZA0KPj4+PiB0ZGMg
dGVzdHMgdG8gY2hlY2sgZm9yIHRoaXMuDQo+Pj4+DQo+Pj4+IE5vdyBvbiB0aGUgd29ya2Zsb3c6
DQo+Pj4+IDEpIElmIHlvdSBhZGQgYW4gYWN0aW9uIGluZGVwZW5kZW50bHkgdG8gb2ZmbG9hZCBi
ZWZvcmUgeW91IGFkZCBhDQo+Pj4+IGZpbHRlciB3aGVuIHlvdSBkdW1wIGFjdGlvbnMgaXQgc2hv
dWxkIHNheSAic2tpcF9zdywgcmVmIDEgYmluZCAwIg0KPj4+PiBpLmUgaW5mb3JtYXRpb24gaXMg
c3VmZmljaWVudCBoZXJlIHRvIGtub3cgdGhhdCB0aGUgYWN0aW9uIGlzDQo+Pj4+IG9mZmxvYWRl
ZCBidXQgdGhlcmUgaXMgbm8gZmlsdGVyIGF0dGFjaGVkLg0KPj4+Pg0KPj4+PiAyKSBJZiB5b3Ug
YmluZCB0aGlzIGFjdGlvbiBhZnRlciB0byBhIGZpbHRlciB3aGljaCBfaGFzIHRvIGJlDQo+Pj4+
IG9mZmxvYWRlZF8gKG90aGVyd2lzZSB0aGUgZmlsdGVyIHdpbGwgYmUgcmVqZWN0ZWQpIHRoZW4g
d2hlbiB5b3UNCj4+Pj4gZHVtcCB0aGUgYWN0aW9ucyB5b3Ugc2hvdWxkIHNlZSAic2tpcF9zdyBy
ZWYgMiBiaW5kIDEiOyB3aGVuIHlvdQ0KPj4+PiBkdW1wIHRoZSBmaWx0ZXIgeW91IHNob3VsZCBz
ZWUgdGhlIHNhbWUgb24gdGhlIGZpbHRlci4NCj4+Pj4NCj4+Pj4gMykgSWYgeW91IGNyZWF0ZSBh
IHNraXBfc3cgZmlsdGVyIHdpdGhvdXQgc3RlcCAjMSB0aGVuIHdoZW4geW91IGR1bXANCj4+Pj4g
eW91IHNob3VsZCBzZWUgInNraXBfc3cgcmVmIDEgYmluZCAxIiBib3RoIHdoZW4gZHVtcGluZyBp
biBJT1csIHRoZQ0KPj4+PiBub3RfaW5faHcgaXMgcmVhbGx5IHVubmVjZXNzYXJ5Lg0KPj4+Pg0K
Pj4+PiBTbyB3aHkgbm90IGp1c3Qgc3RpY2sgd2l0aCBza2lwX3N3IGFuZCBub3QgYWRkIHNvbWUg
bmV3IGxhbmd1YWdlPw0KPj4+Pg0KPj4+IElmIEkgZG8gbm90IG1pc3VuZGVyc3RhbmQsIHlvdSBt
ZWFuIHdlIGp1c3Qgc2hvdyB0aGUgc2tpcF9zdyBmbGFnIGFuZA0KPj4+IGRvIG5vdCBzaG93IG90
aGVyIGluZm9ybWF0aW9uKGluX2h3LCBub3RfaW5faHcgYW5kIGluX2h3X2NvdW50KSwgSQ0KPj4+
IHRoaW5rIGl0IGlzIHJlYXNvbmFibGUgdG8gc2hvdyB0aGUgYWN0aW9uIGluZm9ybWF0aW9uIGFz
IHlvdXINCj4+PiBzdWdnZXN0aW9uIGlmIHRoZSBhY3Rpb24gaXMgZHVtcGVkIGFsb25nIHdpdGgg
dGhlIGZpbHRlcnMuDQo+Pj4NCj4+DQo+PiBZZXMsIHRoYXRzIHdoYXQgaSBhbSBzYXlpbmcgLSBp
dCBtYWludGFpbnMgdGhlIGV4aXN0aW5nIHNlbWFudGljcw0KPj4gcGVvcGxlIGFyZSBhd2FyZSBv
ZiBmb3IgdXNhYmlsaXR5Lg0KPj4NCj4+PiBCdXQgYXMgd2UgZGlzY3Vzc2VkIHByZXZpb3VzbHks
IHdlIGFkZGVkIHRoZSBmbGFncyBvZiBza2lwX2h3LA0KPj4+IHNraXBfc3csIGluX2h3X2NvdW50
IG1haW5seSBmb3IgdGhlIGFjdGlvbiBkdW1wIGNvbW1hbmQodGMgLXMgLWQNCj4+PiBhY3Rpb25z
IGxpc3QgYWN0aW9uIHh4eCkuDQo+Pj4gV2Uga25vdyB0aGF0IHRoZSBhY3Rpb24gY2FuIGJlIGNy
ZWF0ZWQgd2l0aCB0aHJlZSBmbGFncyBjYXNlOg0KPj4+IHNraXBfc3csIHNraXBfaHcgYW5kIG5v
IGZsYWcuDQo+Pj4gVGhlbiB3aGVuIHRoZSBhY3Rpb25zIGFyZSBkdW1wZWQgaW5kZXBlbmRlbnRs
eSwgdGhlIGluZm9ybWF0aW9uIG9mDQo+Pj4gc2tpcF9odywgc2tpcF9zdywgaW5faHdfY291bnQg
d2lsbCBiZWNvbWUgaW1wb3J0YW50IGZvciB0aGUgdXNlciB0bw0KPj4+IGRpc3Rpbmd1aXNoIGlm
IHRoZSBhY3Rpb24gaXMgb2ZmbG9hZGVkIG9yIG5vdC4NCj4+Pg0KPj4+IFNvIGRvZXMgdGhhdCBt
ZWFuIHdlIG5lZWQgdG8gc2hvdyBkaWZmZXJlbnQgaXRlbSB3aGVuIHRoZSBhY3Rpb24gaXMNCj4+
PiBkdW1wZWQgaW5kZXBlbmRlbnQgb3IgYWxvbmcgd2l0aCB0aGUgZmlsdGVyPw0KPj4+DQo+Pg0K
Pj4gSSBzZWUgeW91ciBwb2ludC4gSSBhbSB0cnlpbmcgdG8gdmlzdWFsaXplIGhvdyB3ZSBkZWFs
IHdpdGggdGhlDQo+PiB0cmktc3RhdGXCoCBpbiBmaWx0ZXJzIGFuZCB3ZSBuZXZlciBjb25zaWRl
cmVkIHdoYXQgeW91IGFyZSBzdWdnZXN0aW5nLg0KPj4gTW9zdCBwZW9wbGUgZWl0aGVyIHNraXBf
c3cgb3Igc2tpcF9odyBpbiBwcmVzZW5jZSBvZiBvZmZsb2FkYWJsZSBody4NCj4+IEluIGFic2Vu
Y2Ugb2YgaGFyZHdhcmUgbm9ib2R5IHNwZWNpZmllcyBhIGZsYWcsIHNvIG5vdGhpbmcgaXMgZGlz
cGxheWVkLg0KPj4gTXkgZXllcyBhcmUgdXNlZCB0byBob3cgZmlsdGVycyBsb29rIGxpa2UuIE5v
dCBzdXJlIGFueW1vcmUgdGJoLiBSb2k/DQo+Pg0KPg0KPkhpLA0KPg0KPklzIHRoZSBxdWVzdGlv
biBoZXJlIGlmIHRvIHNob3cgZGlmZmVyZW50IGluZm9ybWF0aW9uIHdoZW4gYWN0aW9ucyBhcmUN
Cj5kdW1wZWQgaW5kZXBlbmRlbnRseSBvciB3aXRoIGEgZmlsdGVyPw0KPg0KPnRoZW4gSSB0aGlu
ayB5ZXMuIHdoZW4gYWN0aW9ucyBhcmUgZHVtcGVkIGFzIHBhcnQgb2YgdGhlIGZpbHRlciBza2lw
IHNob3dpbmcNCj5za2lwX3N3L3NraXBfaHcvaW5faHcvbm90X2luX2h3IGZsYWdzIGFzIGl0J3Mg
cmVkdW5kYW50IGFuZCBpdCdzIGFsd2F5cw0KPndoYXRldmVyIHRoZSBmaWx0ZXIgc3RhdGUgaXMu
DQo+DQo+SSBhbHNvIG5vdGljZWQgd2UgY2FuIGltcHJvdmUgZXh0YWNrIG1zZ3Mgd2hlbiBhIHVz
ZXIgd2lsbCB0cnkgdG8gbWl4IHRoZSBzdGF0ZQ0KPmxpa2UgYWRkaW5nIGEgZmlsdGVyIHdpdGhv
dXQgc2tpcF9odyBmbGFnIGJ1dCB1c2UgYWN0aW9uIGluZGV4IHRoYXQgaXMgY3JlYXRlZA0KPndp
dGggc2tpcF9ody4NCj5JIG5vdGljZWQgY3VycmVudGx5IHRoZXJlIGlzIG5vIGluZm9ybWF0aXZl
IGV4dGFjayBtc2cgYmFjayB0byB0aGUgdXNlci4NClRoYW5rcyBSb2kgYW5kIEphbWFsLCB3ZSB3
aWxsIHRoaW5rIGFib3V0IGhvdyB0byBkaXNwbGF5IGRpZmZlcmVudCBpbmZvcm1hdGlvbiBpbiBh
Y3Rpb24gZHVtcCBpbmRlcGVuZGVudGx5IG9yIGFsb25nIHdpdGggdGhlIGZpbHRlci4gDQpBbHNv
IGZvciB0aGUgZXh0YWNrIG1zZyBlbmhhbmNlbWVudCBmb3IgdGhlIHVzZXIuDQoNCj4NCj5UaGFu
a3MsDQo+Um9pDQo+DQo+DQo+PiBjaGVlcnMsDQo+PiBqYW1hbA0KPj4NCj4+DQo=
