Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B145760C162
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 03:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiJYBso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 21:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJYBsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 21:48:20 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11023021.outbound.protection.outlook.com [52.101.64.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED1314D30;
        Mon, 24 Oct 2022 18:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NB5+U2fRKpcX7Yy1dRyatfs1ssJIREYhFMPoSaX+VvSdfv6r3fhmdtaibMzYavbq31CzGypUhkPsyiL0ilhZOXJlmsNGnIGQfylPbaMTIq2F7bhA1ph9Sa0ii7v6OOFvGqIGSoSOTFvji+3iM3DBa4meXuoHIEMPaxzmuVFh+aNN4ZpRWcQIZRmNAg5ZHlZ8ehBW5XSAZW8J4oNPdUzFUDVO51rBiyu25RIUmgRdekhS2QhU4EcwX9YfHtCD1KnGEDCzQUoLEQoQUBCan7BF/R5IXxOk6M9tjePhMQzrUTcP2b6ZWkELUblNLwdiTBZ0Bpg/+84KU6I5NAG4zUkTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzlPcldib/s16pZYV6L91djinNDB//MbHrldHYEScjQ=;
 b=aVvG72veVR22PDf6ovO5FYSa4+DnHVDYlRPobtRWaoWXSvCSDA0CNcq3LbM/m6HsLpZZpWPKECxAn/G+v6YKGEOsm5YqO86kWYRLXMcHJTpTeaI+y0diCNJcVf4IEC51RN5uIvJZXdox6F/hanmzd/pWjRxfFBBC6tcuBU10bVYxPykFTv+yMDgMa6Li7MIICnKL8rjhogdBA9A73Cp/XfgDpd/+/w3EFkamtMpwzMMC8K2XL8rSVIFDMDhdiahHXxvPz/trdv8qH2O3ZG6i1qe56fRNiOXlb7Vg4zWOmxil0tE+JwuR0KqXl5EhviAvzEvy4IwW2FLaW3HJGNfGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzlPcldib/s16pZYV6L91djinNDB//MbHrldHYEScjQ=;
 b=Xf1L1XeT+uXofGuEFHJKI48b+T8ML5EfIS+xzakLwRekpEuqtrKtVlyhybf2K/yI7l7J9BjotJqgmi1sxsC5bXXAddlEcj7vIOeKNnxwOq85YL3IfhCt6RZk1y4V8ejGoUs0m8XETE5P4TrUfeb2Lje9+O4TlIpywNA5b5LsV2c=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BL1PR21MB3280.namprd21.prod.outlook.com (2603:10b6:208:398::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.8; Tue, 25 Oct
 2022 01:43:16 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8%7]) with mapi id 15.20.5769.006; Tue, 25 Oct 2022
 01:43:16 +0000
From:   Long Li <longli@microsoft.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v9 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v9 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHY5al25GPEQ8/Qv0mDFYQ5rRZUYq4cwkcAgAEhilCAAG13AIAAAGFQ
Date:   Tue, 25 Oct 2022 01:43:16 +0000
Message-ID: <PH7PR21MB3263EBADFD177761BB978D6ACE319@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-4-git-send-email-longli@linuxonhyperv.com>
 <05607c38-7c9f-49df-c6b2-17e35f2ecbbd@huawei.com>
 <PH7PR21MB32633AC8730AFB4E6C247BABCE2E9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <38cedbd0-b719-eab5-71bd-2677462096c5@huawei.com>
In-Reply-To: <38cedbd0-b719-eab5-71bd-2677462096c5@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8e4107c6-a2ab-4fd9-ad19-12ee4b9ef5bf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-25T01:09:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|BL1PR21MB3280:EE_
x-ms-office365-filtering-correlation-id: 21bb2907-ca8d-43d0-10e0-08dab62a499b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zXuIOHF1FgGpABaTRAQeISJcDWBOLTYrqmHgRCIhyda+YpK0K5eSm93Azc1Qz5K0X2W9m3U1eOOqkyDrvL7u1o0qAGAiLyld6GJW6s3iWQ912EalwHJmC/REzzwrBE14LJrLlUMjCBzqfZLPQZF2kp+hWWv2f9ivBSnDTQkKxD/TWQlZO2W56qGxuUVntefTO7D60Y2J56r13UBinxOf+reYUA/mWCCN6g8gUTCr3+lpcPfL3gOl8swMOrHV5xh46IfFHYsryCddmHVWHCCust6SKlYm1yndwb4FP/KI/qNzrvYT+u5TCqlPwSYnoHvlx0IQi5nk29y5TZsc/CV/uZqyNyoKZw1iB7D1Xq5t+YMSeQqUtf4JTQtcAYY+sDbQy8A62adHpXSCYaQ66pFKW2mxLZbbDpSkvM/272X7JQx9+BlQpm5WiRRAcuoFStei3giSFBLYCaUVAFdcfMYuuCePX4FHQz2p+ATqGA429Sf/W6BCSxHCK0vfoKD1Hz0BTmg/FYT+THUB1/YxBC5UV+iCI6EagBBSEN3qJ/+uC38kfgNH3s9D7nHvcsxxR5uA8hjDrCcj8EOvGBBLYhqyozodz5K0L200ZLTOYc35fcxzsSqnn4iOB/yoKsUHC8yuC8jbPweHQ2UmJMYUk4RlSW7zzjsOpZBgQFCjS3UyMo6r7gmC3/s9+y1ifin5OWZigwCVbh9we09xHLBP0EFnjHYAAJud57Xt9DK0HzDbppbTR5jay/LHDPb8b4NgeRyRHysKgv1Bdv9C0HZs7YcphVpV7hznB/E/Bdlpi064pXpYQswiUXBQ5fZ9C64Rb9BBpFXssTf/JFg5Udx4wGI1fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199015)(66899015)(33656002)(86362001)(122000001)(2906002)(38100700002)(82950400001)(82960400001)(38070700005)(921005)(186003)(83380400001)(6506007)(71200400001)(4326008)(66946007)(76116006)(7696005)(9686003)(26005)(6636002)(10290500003)(316002)(110136005)(54906003)(64756008)(66556008)(66476007)(8676002)(66446008)(5660300002)(55016003)(8990500004)(41300700001)(7416002)(52536014)(8936002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QllPZmU1dTZNaGRQT200YnhsNkNWMGRkTFRzZzVKZGhOcGsxbVJ3alcvOXN6?=
 =?utf-8?B?ZFBodTlPYllTNmI0NFI0ZUx0dmFPWjl2VUVxcHBrSW1qSWJ5d0YyN1ZPc0cx?=
 =?utf-8?B?dTBFWndQVlRvY0w1bFVTcjYvTDVMN1ByNW9LdEFsU1k5YmpUaU91czhRaUNF?=
 =?utf-8?B?MWZ0dVdvQlRITXZET3dRaTYzbmpVajA3VHVIa2hpQmg5REdvQlhjV0FaREhv?=
 =?utf-8?B?d2VzaUhmbmFub3FRVUZBaENRR2ZlNTlnUmMwOUM0S1pmWWR5K25VWXJ4MWN3?=
 =?utf-8?B?VVVPNzF3UDBHWGJZRmMyQy9pVDg3aTdnbHB5T2ZwVEU5USs4V3BZUHZKTEpw?=
 =?utf-8?B?SU5XSzNwQjVvQU5yU2NORlhoMVRLLzFBZStBM3REL1dzRWtiY0xtME5xUjRF?=
 =?utf-8?B?aUpDT1ZrYThSNHRSM0NMcENYRDZjTUp1WWlmNVg1SHk4L01QeHpyYk5lTi9k?=
 =?utf-8?B?bExaT1J2emdkek52NGZTemNHS1l5QUFucCszYjlQb3FzU29obkNMblVLWUR3?=
 =?utf-8?B?WVB2aXBpTXgyc21Pci9yL2Z3eExKTUJLS3lZZW9DK243VjlaMFFrYnpEVjRm?=
 =?utf-8?B?OHYyay9pVTc2b3R2Z3lRVWx0dzY3TklsQjNmalkram5iOTZjZUswRnByVlB2?=
 =?utf-8?B?cUo3eUx0Y0dlbHVXTGMzbHlqNFh2cDlLMzNFTHF2R0djWTJGUlNyYmdWRWZB?=
 =?utf-8?B?UWFmcXdvQkZKR0lDNC9rWEFXbllWcnVOSUJ6eWNJQWQvekZhdEpwbzlLV0Ex?=
 =?utf-8?B?dlRNYUF2a0lnZThud0phNlNQaDdTeVRTbjlxbWtnRVNhcmUvUUx4QlN5aU5a?=
 =?utf-8?B?dnVrQnRyYkxGcjV4MEhvQVFqamRxWjQ3U01uUDJ1MExiN01xR1FSSWxOemVK?=
 =?utf-8?B?WlBvT1p6TEFCS1l1Z3pnOCttZm1CUURkT0UyU0lVNGdHa3NVUUZ6UG01UUhL?=
 =?utf-8?B?enBrbVg3NmJqWDZyVEZnc2V4Z2M5aXJPSUU4Skt5VVBUYTZBN2hoUmRzV3p4?=
 =?utf-8?B?WDh3NkFnL3ZMZVFHb3NOTlFLYWdUUEZlOVg3ZUpkWmtvM2s3L2gzeUt1cGx1?=
 =?utf-8?B?WUowa1UvN0lSdElmRU4yZStHcURtcnU1TjJBeHRyS3FrTnVPVXlVQlJvVitw?=
 =?utf-8?B?ZUtZQjVVeFQwZENFQjdPaHZaNjhTQUorWFpCSmJidHJtY0FaQUhyMlkxNnlM?=
 =?utf-8?B?OWZlL1pFNkZsVXUzSzJhTGtwUEVuazhFaXVTa3RVenltcU55R2dobzZHdVla?=
 =?utf-8?B?STFTazg2elRmMUd5d2ZGVm9mNlZHM256eGk5djI2dDJIZm1qWnQzeThYM1Qv?=
 =?utf-8?B?WTVJak5USVZENUlqLzJueGw4N1hjQjZKeEU1S3kySkQyd004bE9OeU5CTmtq?=
 =?utf-8?B?NzBmUHc0dUM0ZU9tVjRpYktwRk1pWW92TWh0a2YzdEpvUnN5SkdCN0hJdTZH?=
 =?utf-8?B?V2xtRWZnYmxqYmxaQ3p4REtvVStnMG55cFJUNkRoQUNHdy9yVFVGbFBkU0pR?=
 =?utf-8?B?dUdhbldEai9ML0RTYWltdkJDaVc2ZTN0ZGgzVUQ2OUV1VEU1dEQvYkFXTDJP?=
 =?utf-8?B?SXlVVHRQYnREeHdHNTVaWUVmTnIvQWZDUHViZ0dGVEhLUmF0RVNrWVoySjRw?=
 =?utf-8?B?RExtVDkyRVNMM1JidFB2SU1SZDRYN1hCNDR5V2xqQmtDb2FDQk45dlFxMmRW?=
 =?utf-8?B?ZFZyUUpZTDVyLzl4d0pDK2RtTFNXZ3VqVXJsREZKbVVSYnJxVmpxSXp2VVNt?=
 =?utf-8?B?QmdKYmV1ZnhtUG45UVJSS3I0eFova3FqcEJTTUlrYXVDOXpvUlRmRE9CblAz?=
 =?utf-8?B?VU8wdi9rZzFlQ0xkRmdFSktMc1gvUDl6dTlDQ2o2OWpIZVo1LzUvOTc0NGF6?=
 =?utf-8?B?OUJQR0VaOUU2MG5LVTlVUDROSGQ3RUpDOGZYZ0NWdEVTVS9OdWdmdXBYWXlC?=
 =?utf-8?B?MDVvR01mSlp2dGpETjA5NHZWcUh0VEJrdFFqZ0FndndVbmZrQmJzRTQ0dnhj?=
 =?utf-8?B?VVU0NEdrWW44bWM1MlJTbkJKdGFnSklEeWhrblR3WmMxeGgyR3NSWWw4Q3M2?=
 =?utf-8?B?SWF3cGVvV3RNeXhLWmdxS0o2TXRXd1RnVlBPNU13WDloSDlDNkJuZUwyTkdi?=
 =?utf-8?Q?GQquK7VXYZssJmOSq39yrbYpb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21bb2907-ca8d-43d0-10e0-08dab62a499b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 01:43:16.5503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SOEUS35P6hTm+yHAOtNWlKOBzMs6BuIhEju0ofSuBM3XDhVbCrX1sEjLy2z/SNqXoeSSQ4NnNCYV5AoV5ngfOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3280
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+Pj4gQEAgLTY3OSw5ICs3MTQsMTYgQEAgc3RhdGljIGludCBtYW5hX2NmZ192cG9ydChzdHJ1
Y3QNCj4gPj4+IG1hbmFfcG9ydF9jb250ZXh0ICphcGMsIHUzMiBwcm90ZWN0aW9uX2RvbV9pZCwN
Cj4gPj4+DQo+ID4+PiAgCWFwYy0+dHhfc2hvcnRmb3JtX2FsbG93ZWQgPSByZXNwLnNob3J0X2Zv
cm1fYWxsb3dlZDsNCj4gPj4+ICAJYXBjLT50eF92cF9vZmZzZXQgPSByZXNwLnR4X3Zwb3J0X29m
ZnNldDsNCj4gPj4+ICsNCj4gPj4+ICsJbmV0ZGV2X2luZm8oYXBjLT5uZGV2LCAiQ29uZmlndXJl
ZCB2UG9ydCAlbGx1IFBEICV1IERCICV1XG4iLA0KPiA+Pj4gKwkJICAgIGFwYy0+cG9ydF9oYW5k
bGUsIHByb3RlY3Rpb25fZG9tX2lkLCBkb29yYmVsbF9wZ19pZCk7DQo+ID4+PiAgb3V0Og0KPiA+
Pj4gKwlpZiAoZXJyKQ0KPiA+Pj4gKwkJbWFuYV91bmNmZ192cG9ydChhcGMpOw0KPiA+Pg0KPiA+
PiBUaGVyZSBzZWVtcyB0byBiZSBhIHNpbWlsYXIgcmFjZSBiZXR3ZWVuIGVycm9yIGhhbmRsaW5n
IGhlcmUgYW5kIHRoZQ0KPiA+PiAiYXBjLQ0KPiA+Pj4gdnBvcnRfdXNlX2NvdW50ID4gMCIgY2hl
Y2tpbmcgYWJvdmUgYXMgcG9pbnRlZCBvdXQgaW4gdjcuDQo+ID4NCj4gPiBUaGFua3MgZm9yIGxv
b2tpbmcgaW50byB0aGlzLg0KPiA+DQo+ID4gVGhpcyBpcyBkaWZmZXJlbnQgdG8gdGhlIGxvY2tp
bmcgYnVnIGluIG1hbmFfaWJfY2ZnX3Zwb3J0KCkuIFRoZSB2cG9ydA0KPiA+IHNoYXJpbmcgYmV0
d2VlbiBFdGhlcm5ldCBhbmQgUkRNQSBpcyBleGNsdXNpdmUsIG5vdCBzaGFyZWQuIElmIGFub3Ro
ZXINCj4gPiBkcml2ZXIgdHJpZXMgdG8gdGFrZSB0aGUgdnBvcnQgd2hpbGUgaXQgaXMgYmVpbmcg
Y29uZmlndXJlZCwgaXQgd2lsbA0KPiA+IGZhaWwgaW1tZWRpYXRlbHkuIEl0IGlzIGJ5DQo+IA0K
PiBTdXBwb3NlIHRoZSBmb2xsb3dpbmcgc3RlcHM6DQo+IDEuIEV0aGVybmV0IGRyaXZlciB0YWtl
IHRoZSBsb2NrIGZpcnN0IGFuZCBkbyBhICJhcGMtPnZwb3J0X3VzZV9jb3VudCsrIiwNCj4gYW5k
DQo+ICAgIHJlbGVhc2UgdGhlIGxvY2s7DQo+IDIuIFJETUEgZHJpdmVyIHRha2UgdGhlIGxvY2ss
IGRvICJhcGMtPnZwb3J0X3VzZV9jb3VudCA+IDAiIGNoZWNraW5nIGFuZA0KPiByZXR1cm4NCj4g
ICAgLUVCVVNZOw0KPiAzLiBtYW5hX3NlbmRfcmVxdWVzdCgpIG9yIG1hbmFfdmVyaWZ5X3Jlc3Bf
aGRyKCkgcmV0dXJuIGVycm9yIHRvDQo+IEV0aGVybmV0IGRyaXZlci4NCj4gDQo+IEl0IHNlZW1z
IHRoYXQgdnBvcnQgaXMgbGVmdCB1bnVzZWQgd2hlbiBhYm92ZSBoYXBwZW5zLCBpZiB0aGF0IGlz
IHdoYXQgeW91DQo+IHdhbnRlZD8NCg0KWWVzLCBpbiB0aGlzIGNhc2UgdGhlIHZwb3J0IGlzIGxl
ZnQgdW51c2VkLiBUaGVyZSBpcyBubyByZXNvdXJjZSBsZWFrLg0KVGhpcyBpcyBleHBlY3RlZC4N
Cg0KPiANCj4gDQo+ID4gZGVzaWduIHRvIHByZXZlbnQgcG9zc2libGUgZGVhZGxvY2suDQo+IA0K
PiBJIGFtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCB0aGUgZGVhZGxvY2sgaGVyZS4NCg0KQmVjYXVz
ZSB3ZSBhcmUgZGVhbGluZyB3aXRoIHR3byBkcml2ZXJzLiBJIGRvbid0IHdhbnQgdG8gYmxvY2sg
YXMNCm1hbmFfc2VuZF9yZXF1ZXN0KCkgaXMgYSBibG9ja2luZyBjYWxsLg0K
