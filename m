Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAE523848
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344431AbiEKQOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344426AbiEKQOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:14:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2097.outbound.protection.outlook.com [40.107.244.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC865159D;
        Wed, 11 May 2022 09:14:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLhnlFMG8ZqWg4Gphm957Ktycmt89ZquflJ4bCn/2z9Of/sjj6wlTnYx7P3CF9JqNJcsu2VTjp7bl7M0gbQwP63FZxP/S7v1+vulF8udX41SYICiXNHVC10T7THCkT/9fQ59NFBX1ucfCesSmF5yRt5wsR4Z7TfofpEv0PErwdCPk9h4X1z6ymWDH7OEKCIOQbCFepUe5JqMXGtSdH46AzBIzwS1SHYBl4aQeJe/rvMntpTWHUyJrDTRWXfqk7WZjSfOm3fN/oecMbT/yvNxUXvH3ws7yTBe3lE/Vd3D4qezPqfJac0NAhzy5YyJEkhdWcKDXSu3Jt/QIUG+N6Yang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IgiLpK1VD1qCWDlkfa1FkK2a03QBlQUi2vz+NsPde4=;
 b=RJq7UGQFWhV1kFhLqCIsP3NOdP5zW9lytT/5f+D6DmdIzcdBuMO/jTtybADV+4g7Lsz9M+vXXIFBIGJSvvtmeww2TlVoJhLLaVZ8BJwKsO43y/vZLey8N5fYumc6UhQGRADQ2/Cic4HBPmmQMA8W6UxfDHddj8SP3BQPaxziAgA/GS5IUGgEvd1lXrJ5nGoSntgK4XObCEoqdPnrNxbHnyC8OwS8DirMcF/ZDZ/9AEsmxatv/E1yP4VGZ8cPDgzrqU+vnXnVyRXWkmftM75cBfr/FWAr2KImScN/OzYF5dEdtK6sfXV/YQaTC/ayaRIoOU6wbB0OyU3fdMJl1CR4hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IgiLpK1VD1qCWDlkfa1FkK2a03QBlQUi2vz+NsPde4=;
 b=Uqqe9C7EibVV/UMuknAlN3lspu6BD6y9j+LdKHIB3U0Jm4luYi3WcANUq0q2J+dNPzWzGJwVa7g8rQo4u5aMPCvlg8CuLy4lY7qMJ+zNfsIx628gdJEmSk+6WNAHvzCdq5wnZXHto0/CEvgvtmSAGFxgkA7JNkNLc7XBnYuq2Ok=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by DM6PR13MB2380.namprd13.prod.outlook.com (2603:10b6:5:cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Wed, 11 May
 2022 16:14:18 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5%5]) with mapi id 15.20.5250.012; Wed, 11 May 2022
 16:14:18 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna@kernel.org" <anna@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Refix the socket leak in xs_setup_local()
Thread-Topic: [PATCH 0/3] Refix the socket leak in xs_setup_local()
Thread-Index: AQHYZTees9lYRz9xIkq++aq4NXkIn60Z2eSA
Date:   Wed, 11 May 2022 16:14:18 +0000
Message-ID: <2125358c4fbdcf2e9f84017a2f6b27830ffcb8f2.camel@hammerspace.com>
References: <20220511132232.4030-1-wanghai38@huawei.com>
In-Reply-To: <20220511132232.4030-1-wanghai38@huawei.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2c7de74-c7d8-4512-201a-08da33694d33
x-ms-traffictypediagnostic: DM6PR13MB2380:EE_
x-microsoft-antispam-prvs: <DM6PR13MB23807ACA9F6E0D7277D7C70BB8C89@DM6PR13MB2380.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EpX2DOqtWUYfdzhqoSyGjNZyYgkis0PhGItc/xS4aXsAS03KQvs/ecgBlzc90VJufy527KF+pp4vQbnBkO5oAXTS9ufznf1418oeF+f5egfl4ECuLuCFof6ciQHx3JsmUjWBZSyg2WPC3oOfejD45AmpTrPVm1iXC+YDOiFaK03Jd7Im9XKc2rGo+dmySPw8CDLzvT9VidmeIVrhBHBLV8bMZ4UNh+6xApVy1E8D2PvKtHck2nIrLZd6pQalPA/4O7Y2E4tUJsugUfVAsxHvbGHrasRYid1L5yGxICxDxA0WKUAoG4ZLr1LATeGevx/nMUgOwO8+7QWfqBH1L3Sxox/zNuKZOQwQTVoUnfTuw8l9s3KryKrchgTGUX1MsOhe8xw6agXOWfziMy5sUoCoROL+duZFQbNR+JpkuqumnBjdFkprWX2nP+x1EcQZDjr3yMfwNpzLcU62nXA5vLvoKNTmTvl5FlTc4kFVl3u+NhRgHgNBCC8w8E0GsgXl/WIZWQPU1ei9l0NPbMENFNgZKwEkuYayFbwYaogg9E2rjVt8i9y+wZY+Fdm6IxYg7wPjNogDHioadti2LWD1+IIuE0rvhEE4n+GGLhWhl87F/dxrbM0oxGO+KGTAHgeUBPteZP/GSe2+zyTu50UCimEBMFwtr1fl1bv5SkCvABfNuG74hOrvB5wM8ZuHjdty9ZwCJP2ThN9Y8v+yICTBpNutYQnfONqShDlSXGT2P7f3SVK/cv0gyjdRTDw7NRsumYGL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(54906003)(76116006)(66556008)(2906002)(66446008)(66476007)(66946007)(64756008)(8676002)(316002)(6486002)(110136005)(508600001)(38100700002)(86362001)(38070700005)(122000001)(71200400001)(8936002)(83380400001)(5660300002)(6512007)(2616005)(36756003)(7416002)(4744005)(26005)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MldkaytSc0RHa3J2NEtUNUlaT0dwT1B5QWNJaEliUVNCZFdTV0JUd1Ntcm9s?=
 =?utf-8?B?VWxUQStuWkEyemR0U09iT0JoL0tzK2ZzcDExdGFRNmZLN2xIZDBRMEw5SnhX?=
 =?utf-8?B?dkppQzBVdXJKemJsQmdNc01XS3k1L3F4Ry8wTEltSU5UR0xQSm9uUUN6VVZU?=
 =?utf-8?B?c3F4VS8rb0VtbGtQdjFNbHAxWm1sVVAvZlFxMmwyZzlJdkZLNE8vaUNjN0Mz?=
 =?utf-8?B?T1ByQi93WERObjJjbThCZlYrelJlU2NUc3I5QkdkVDRFL05HUzFOQWxLcmtk?=
 =?utf-8?B?OVBjYVQxNHl3K2VnUlJDOU9LamlOelEzbmdaSDUvQUlqZXNNa3llOU5TZFBW?=
 =?utf-8?B?bHYwM2d1SzBZRXFDZFg2ZW9HQXBVNkVmam9PdXJsRnN3SmpnMitIK216Z2ww?=
 =?utf-8?B?Wkw1MS9Xb05XcjZMV1NpRjA1dWk5U21KWU8yZmY4MHdETU8yR09lZnNjOW9n?=
 =?utf-8?B?bEd4dG0rbk1HUzBnOTB6U3RTMXZKa1RVUWFYVXN6SlhBZGR1MDlMK2t5S3Nh?=
 =?utf-8?B?bmcvNEx1SUlnamQyeUMrcWYrMy9oSjcrVkxNWU5CUEk5ZUc5eitBb3Q1bzlZ?=
 =?utf-8?B?M050NVlOYzZBcVF0YURyZmJYSHRSV2FtRDBhd1ZrS3czTzJMTktydUlZOVhZ?=
 =?utf-8?B?L0RKOU9DT2M3b0k5TzhVemV2Nkg0K2dZWTlZSDJ0MFpoNUh0dXpZdDZsOWhr?=
 =?utf-8?B?cE05bjJYYS9LT1BIeVFXNW94bXoxYjd3bE9vTkQzTVVmM3h1M3R1MTAzVXJS?=
 =?utf-8?B?Wko4aEpjaTdxSHl0aXpVczJhR0xaVU9UTnppaVV6SnBsZDVmdW1SL2x6bUc2?=
 =?utf-8?B?bEdKM3ZTS0JOaWVZamJxUi9KalhjR3VyYnFwUXBvaFRJbnJIK0Y2RXl0R2pj?=
 =?utf-8?B?Ym9NZUwwWHNmOGRjYzl6bHl5aHowM01RUHlIT3RzcnMvY2U3dDJnQjF5K1c0?=
 =?utf-8?B?NVZLWU01U0ljWmVNZno0TmpVT1ViMTNFT011dm5jVmlNWEtLdURnTkk2MHha?=
 =?utf-8?B?SHFmMkNhMUJ1TGNSOUdVVnl4dlN0dzFWTHBHbVlxeDRBbVBia1F5Z3lGNjc1?=
 =?utf-8?B?M0dvQklYVHpnc01vYlNHTUtoZlVYQXpaTnVhS1FORnlnb2d6ZXM1TTU0ekpx?=
 =?utf-8?B?d1VmZjRPRkE0QzVFMnVGZTNOMzdRVnFmOWd1UW1QNFBOclhYOTgvcUN1UmdN?=
 =?utf-8?B?Y25UMHMzL09ZUFROMnNDVzRvaHpTdWNZR2dlWjVFTzhJVUVwYWFqTzdRajZF?=
 =?utf-8?B?VFFkNk9mWDRHa0h1V2pMbHFMaWVlRjFvejJpS3FOMitIUkFzUllsYnlmbnlw?=
 =?utf-8?B?V3dkdE54ZHN4bTVNVnJPOWFUekRhSnB4L1hNWVg5dHRjRFNHM0h3dVQyRHA5?=
 =?utf-8?B?VGdYNUUzZ1BOTHhTVUFJMTEyMjgwRExxYWg2T0ZmdGxjVWplaTNuQ3pZRjIr?=
 =?utf-8?B?UDRqRHpkbHkvZEx5VjNVT1BOVWJSWlpLcGtUUjBMSk9sUXpzVlJITjdTRWZP?=
 =?utf-8?B?ZUlvT3pMWjF0K01mMjdleXp6c0tNdDBKT0pqU1c0cVR3eWlXSDBVZzQ0STMv?=
 =?utf-8?B?ZzRrRFFsYkIvdWFWdlB0WVNGWHBTcFVUQTdZVEFpUk14aW1VWGsvRjBpRGdt?=
 =?utf-8?B?UWxlTHJjSFE1bzQwN0Vnam1jRWR0NnZlaW5SSmsvVnJUVjBrSzBnM2h2SUoz?=
 =?utf-8?B?WnZ1K0NyL0Y5SGFDTFdNQXpjcjduL1g4OE9DanVyRndWVFZRUGJsWE1nemdm?=
 =?utf-8?B?ZEZQZTdLMGllR1BNSFBSOEVHdTZ0TFdZS3NhbVNqQ3ZyeWxhWjhibkI5aC94?=
 =?utf-8?B?ak5RZTg5SmROczliVnpDb1Z4bmdEckJJYjAvOVRsK3VFU28zaVc2ZXJOZHlO?=
 =?utf-8?B?TUhBTjI0SkUyUVZFNCtPU3BVWnlLVUJOYktOK2RwMVJHcXFYL1NRcHZSaTV4?=
 =?utf-8?B?c05jMHFaY2REeEdTaHoxZ3RoMzRWTFUwZytaQWRCb04xdFRNVE5BTTJFZ2RD?=
 =?utf-8?B?UHd4Q2hRamowYldXeFBucXg0OUlDRkxqV1FnQmpOMjJtcnIrWlQ1WFZHVDBI?=
 =?utf-8?B?RjJ4RWlmV2FESk5KODNHM2taKzlIMHZzSzZKQVQvMmlLZHJQbWFEeEQ3eHhX?=
 =?utf-8?B?VzRPdTFGSUVzTmJnMnVWM0tjNWtkQ3k5MGZXbDY5OXVLR0pGRHdUL1Jtd1JE?=
 =?utf-8?B?RVhDRm5HUW5adjhZK2lySTRKdFpoaWVSTkxjdHdoVExMZnlsTmVNb0RabUVa?=
 =?utf-8?B?WTFhZVlFWm84ZmtNcnBrYlJDSVlSUkJDeTFBaTA0b1FTVFRBZGMwM25PTVZs?=
 =?utf-8?B?Y211Q2llZVI5SCs3Y1RFV3VXWjB3enlBZ1ZZMU55d1h4ZmFxMTU4WmtoUzFt?=
 =?utf-8?Q?gKukmgXunO+MxUvg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D87CE599C3008345BA9B5A3E5EE1486D@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c7de74-c7d8-4512-201a-08da33694d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 16:14:18.5656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3NHL2q63HH4p8XOx4mwA/wn/vM7aovPJYHQWtA55zdIx2LXZJj3OMHTX1751MBMzC53vSfOtUgPnWEpx2jowKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTExIGF0IDIxOjIyICswODAwLCBXYW5nIEhhaSB3cm90ZToNCj4gUGF0
Y2gxIGFuZCBwYXRjaDIgcm9sbCBiYWNrIHRoZSB3cm9uZyBzb2x1dGlvbiB0byBmaXggc29ja2V0
IGxlYWtzLg0KPiANCj4gUGF0Y2gzIGFkZHMgc2FmZSB0ZWFyZG93biBtZWNoYW5pc20gdG8gcmUt
Zml4IHNvY2tldCBsZWFrcy4NCj4gDQo+IFdhbmcgSGFpICgzKToNCj4gwqAgUmV2ZXJ0ICJTVU5S
UEM6IEVuc3VyZSBnc3MtcHJveHkgY29ubmVjdHMgb24gc2V0dXAiDQo+IMKgIFJldmVydCAiUmV2
ZXJ0ICJTVU5SUEM6IGF0dGVtcHQgQUZfTE9DQUwgY29ubmVjdCBvbiBzZXR1cCIiDQo+IMKgIFNV
TlJQQzogRml4IGxvY2FsIHNvY2tldCBsZWFrIGluIHhzX3NldHVwX2xvY2FsKCkNCj4gDQo+IMKg
aW5jbHVkZS9saW51eC9zdW5ycGMvY2xudC5owqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxIC0NCj4g
wqBuZXQvc3VucnBjL2F1dGhfZ3NzL2dzc19ycGNfdXBjYWxsLmMgfMKgIDIgKy0NCj4gwqBuZXQv
c3VucnBjL2NsbnQuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAz
IC0tLQ0KPiDCoG5ldC9zdW5ycGMveHBydHNvY2suY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8IDE5ICsrKysrKysrKysrKysrKysrKy0NCj4gwqA0IGZpbGVzIGNoYW5nZWQsIDE5IGlu
c2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KDQpUaGFua3MsIGJ1dCB0aGVyZSBpcyBh
bHJlYWR5IGEgZml4IGZvciB0aGlzIHF1ZXVlZCB1cCBpbiB0aGUgbGludXgtbmV4dA0KYnJhbmNo
Lg0KDQotLSANClRyb25kIE15a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBI
YW1tZXJzcGFjZQ0KdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
