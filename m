Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC656875F9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 07:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjBBGlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 01:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBBGlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 01:41:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FCB8001D;
        Wed,  1 Feb 2023 22:41:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4iF3tOeu6CLjdVDBUwMlfKEVCJirNuLWKYGnOkPfVH+8xdo4E/M7wt3GKZ0ys42h8WAeeNbr+32SC03vyJDW710g9ulREbqoSio8AHX252ILeXJYxDUljKUBpPG8reEqaGSm2N1cvA81QH6LMuYcOaE4Qd81xP04YtZUruf8rtdb5lIdC/vqP+uMYCdBvHDCqZaD1rC8kqozDNvnCMhqBjS7GxkheY0daVVdVjtP0Czt3JexbZ4E2utSl3dZbFIjrJE5gp0pX0RmF6f2tNh27hagKvV/Q49JqreaIPHAWsMUvktgdRn5hx84h9E8UdU9SpfuXW4trAaF1i0RgrubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWO9jjQkp2qyLXFM7sD6Eqw2V+8JY0keeHAnzrY7I5g=;
 b=eYrPKNaAvhPDSkcdgEyEd4prXk1H6VfC21TfaFg7vidr8p3T9IPJtzl+uwuYLAxkF5IJq/9JwV1LFQGMUfHZsHSQ2XNS+yDzJbmK+LpRKxmXV22giBxy1su35xw4eCZZaF0N8K8SdDg6I+hgrSmK475VTBlyIaWQTPKAUE2Q0JrNQlvBIUMoObhiQxRYQi0iAKyVsXhIqn6byP3XbnPKWV9wSm1Ne4vx416LBkd91R/d1IG1ch4UrrGk5zDk5tZZgjz/fo2K1kmDWrn54OD+a3oz24hpgvnM6BwtTXmfTgqYENqZyAng6RNtFIf3vKxvbzWC3M53TBUnF0hvTUWhkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWO9jjQkp2qyLXFM7sD6Eqw2V+8JY0keeHAnzrY7I5g=;
 b=fUgPeaAqdEN9YcmFEwNFsCwnVxJXDaSLL967IO09XdqPyIhWoe4bH4ypHg/FA+FxfGgIBkn47K28bBt5VdKpctTi+IAS8VaS+pkIx7zOXu/717TJrZQg6aT2OTZzFZBaorSpdhMLLmEsmtA+t47r+nYpLUiNqDpYNgAGjaXbmng=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 06:41:46 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 06:41:45 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Thread-Topic: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Thread-Index: AQHZNYSBh/JsP0BdakCrDM8wasEKMK64rx4AgAEZgACAAAWVgIAApgkAgADDOIA=
Date:   Thu, 2 Feb 2023 06:41:45 +0000
Message-ID: <84ac0002-5686-8158-1c17-f2724afda725@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
 <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
 <Y9k7Ap4Irby7vnWg@nanopsycho> <44b02ac4-0f64-beb3-3af0-6b628e839620@amd.com>
 <Y9or1SWlasbNIJpp@nanopsycho> <20230201110148.0ddd3a0b@kernel.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.69.23011802
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|MW4PR12MB7262:EE_
x-ms-office365-filtering-correlation-id: 77e76b5c-d0ab-4a48-4545-08db04e88dae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fW8KxvOaD48B3FPBHkvGmBABiU+MWYdKIdY/fdgym1BYymnkGBSli/5BAHlxHRDxS63bbNQQZHiXDitguKNWjOQ5CL8/RJtjxaELsYrtIz6KRVHJcFfXOWJC0qnI9B6iWoYgIccysj4O77Sc8nJuWPamaDoFoRfi93KIHglQZqp04glq9k5eoKDXDKenOXg61LJ7fiDO0HI4PDYmoZJ5aU8zbe1+2T/vZT/3MMSafpJgomOw0YEb6wiyHHycUQQtwCI21eS8Ri0WavVoUVOVAYKO64Z/OWr3MtyzdlA0YmmDkzJtO0zZdIRgUMlsmlB38xueilS5iXsBifc5n0Lzwq5WP89mDghCYzrlr7rCHqYSNz0fWB9gSX3KIgWMAYL+dyXbJo+jY463hs1yhdT+8PhGhJBx/HdWVr097aWmFnVqGWdGp1Xfl5Ka8nSg0OUT32JAGMd8X+rswFMdU8HG/0CfcdGNtPjDj3BnauT9fT3crZUWTS8DyZ+40VtOQq/A+AvOjBPrBY72dvTUdfhAV0u5fjj+/FJMtNWyoeTwd4EHSDjpPZuES1pS3t1Jdvfa0y+/6xfQWm7Gu8KAvrFrhDEcLZK6kmcMtx1Fvc0K6SFxK60yjqQ4ZlblxDKz31JnHDtOsQCazHp2O4h8n4lzbtwGworlixx0meFqi8zfrOMI16JymRvwQJUcUDtPuMR360tUIFayHC/e9PRpg9KB4w6lXQKmIXTWigf07qPk8g8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199018)(2906002)(7416002)(36756003)(5660300002)(122000001)(38100700002)(31686004)(2616005)(38070700005)(6486002)(478600001)(186003)(6506007)(53546011)(71200400001)(6512007)(83380400001)(26005)(31696002)(86362001)(66556008)(54906003)(91956017)(64756008)(66946007)(316002)(4326008)(110136005)(8676002)(76116006)(66476007)(66446008)(8936002)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUZBWTZQMzZHMmN1ekh1aVprOHUrY1BBYmFNWTFSbTdSTVZ3SEt6QVMrRWdt?=
 =?utf-8?B?eFQwdDFXYnptZUNmQWgxamVTa2lLS2wrNkNTVjJRWUYxQnVhZVZWeldKc3JJ?=
 =?utf-8?B?NTNiTXF2YTljZHNiQ2VLOWJkbjl0SWFiMGdjOXUzL3NWZXluRTRuUHJFcSsz?=
 =?utf-8?B?TFZXenNyRWR6K3lLK3ZYSmFaWDNzYitYSVpXRlJyMXZKSnRGZFNua3Uzd3hj?=
 =?utf-8?B?RnFWRzY1QUpmNE5nNFRSaEpoemZyWlplUWYyd09hY2ppYXdBQ1k0UjVnNUtL?=
 =?utf-8?B?UHhtMG9Vek5GR3BFOTdRWERoN2NjRjVnZmFmWVJHUTdMZE9xSUZXRW5nVk51?=
 =?utf-8?B?a3lRM1JVTUY0RGlTZm0rY0NkNE8zMk82Q1dYcytlTXFxcGJJOFdad2FnTThy?=
 =?utf-8?B?L1pTMHJjQ0h4UC9uNStUSENuWU1wakJSS3dwc1FFajF5aUQ3MUNFRGxudFBk?=
 =?utf-8?B?UktSZzJSU0pDM0E2bkJvZlN6cVhOMHlIc25MeURjUzRtL3NDb1FVZTJPd0sy?=
 =?utf-8?B?RXB0R2VWQURKbXFBcFhvdkI3TTM3VmRHOCtLZnE3NHhQNkppamN4T2M2ZCsy?=
 =?utf-8?B?dFhNc1NxTk1lU1B6R2FQMVdqT0JGcytIREdBd3Z6UGN1UjhNTFJvOGwya0dh?=
 =?utf-8?B?Q3h2MS9TdFdtMWJYbGl1d2tXVDZHYmtuYVp2R3hDSGVEMHVLUUcxVHNxZjFZ?=
 =?utf-8?B?TktJQXg2K2RFNFlvc0NtYzFiY3h0ZFV5R1BwMVcrekxQbVZka0NJY0NHNEJ1?=
 =?utf-8?B?U2J3QWhnN0l6bWl0TmR0TGVKa09oUXlEOWV6NXQ3ZlNLYXRheFc5R2txWlJW?=
 =?utf-8?B?cGtZcDZHblVFMHY4dnRmQXBUTm9NQVA5OXgyL1dIWktRSmluOTFNa1J1Z1Av?=
 =?utf-8?B?enRzRDJZNHhoRVNLT2RTMUlNaDZPNXl4ZzBiaDFZcFp3M25jZGdQaHkrZ2lq?=
 =?utf-8?B?USswRG05OFZYK0ZUdXdraXBCNmU2QXFqSlpISFVDVC9UaG56UlpPbnk2VVdP?=
 =?utf-8?B?MFJQYy9xaWRHaVZzN2xoeHlGYk9XalA5SGNGSjVJU09BWHhDb1FIVldWS0dm?=
 =?utf-8?B?eGNDcG1jcDBtMEh5MmIxZUlKVFFZQ0JUM2oxaUt2eHFvb1ZtU1ZTenpwYXZT?=
 =?utf-8?B?VFJIWUQyK2l5UVNlMFExNWtZbFNJRm11VnoxbEUrak00MHpYbmN3MnVHalBs?=
 =?utf-8?B?YUYxejQ1cytuT2Yza1BGd2NXQStZMEtVcGNwbDJFZDRqVDRMUVRNN3Q4WUJt?=
 =?utf-8?B?R05NNy9weEZLdFhaU1BKY1RKVFk5QkpEaldkNURIcEVNZ0hiZFYwTFFlbE1G?=
 =?utf-8?B?Z2lWK1FXQkRmcFA3WVNBVmNrZWxSL21aaFBCdnRlTExER0lzTGxqUFJuZ1hD?=
 =?utf-8?B?R0phcmhnQi9vZmhnc2hZS0dCY3AvM3V0a3pyaHZuZXlhYk1IRHpka1JQUjFp?=
 =?utf-8?B?M0pIZlFSZkU5bFplRDFaV04vQnMxY2VscHJvQTRSL3plSjlIUElkazFBM2cr?=
 =?utf-8?B?b1JONC9DQlFBcmQwYjdLeVBTcDRwUHhSc01kZFQwMWE5ZkVSU3ZKWHRnVHdk?=
 =?utf-8?B?TmFpUHB0c1djVnBvaE9DTGlCdjFBekpTb1djVzhDVDJVYlRPcXppVjdtdFVv?=
 =?utf-8?B?OEVaQWJwNWhFRTRsaTFiYndQcU54MU1palVmMDVCMHlMTkxEcTJHQTM1OUlq?=
 =?utf-8?B?RHBMZktuaVo3U0NrVUw4a3A3WnR1MGV0eTJGK3Q5U3Y4Y09EaHl2akIwcWRL?=
 =?utf-8?B?MW1vN0xjUmFXcnh1L2plbzBRM1Y4bnZranJHaEEwZW5YTE5FV0doWUNVQi8w?=
 =?utf-8?B?Sk42QzVFbTRDSVp5dTBxVlJQdHRIRGlDQ1NDa3ZHUGpHcXF2RzRmSEhBb0pM?=
 =?utf-8?B?M0hlSFNVdDlQdXBJSnI1RndMSDhGYklPTHRuVUhqT1RLSW5DaUNQajc2SHpU?=
 =?utf-8?B?eGdYblVXZzFzMkFEelBtYldrbXpwMW5xdlora3FpVTdlQ3lzUmNLdjBBUnkz?=
 =?utf-8?B?cE9heXBiYWxtdUJOSjVqSGQwRnZFeERYU2JBdTIrenMxWnRjUmVXT2tUWlFO?=
 =?utf-8?B?Y2ZHcmpWaTJZbUVUbElrODFFTVJ6bHNZcFYvd09TNGFtMm84UTljUi8yOWt0?=
 =?utf-8?Q?hNNHxKWi/3kwmsacG0PkZGOZB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87779CCD5EC25F46B98EDB301EC2E51A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e76b5c-d0ab-4a48-4545-08db04e88dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 06:41:45.8833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LT8D7PhzSozndJHF4cK1j1NmTNoTT5Cd5AiinXPt1BJRV9UqxEn6pNdMVOXsHTr2FKLblna0kGmFnbyj3YqRzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIvMS8yMyAxOTowMSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMSBG
ZWIgMjAyMyAxMDowNzozMyArMDEwMCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4+IFRoaXMgaXMgZHVl
IHRvIHRoZSByZWNvbW1lbmRlZC9yZXF1aXJlZCBkZXZsaW5rIGxvY2svdW5sb2NrIGR1cmluZw0K
Pj4+IGRyaXZlciBpbml0aWFsaXphdGlvbi9yZW1vdmFsLg0KPj4+DQo+Pj4gSSB0aGluayBpdCBp
cyBiZXR0ZXIgdG8ga2VlcCB0aGUgbG9jay91bmxvY2sgaW5zaWRlIHRoZSBzcGVjaWZpYyBkcml2
ZXINCj4+PiBkZXZsaW5rIGNvZGUsIGFuZCB0aGUgZnVuY3Rpb25zIG5hbWluZyByZWZsZWN0cyBh
IHRpbWUgd2luZG93IHdoZW4NCj4+PiBkZXZsaW5rIHJlbGF0ZWQvZGVwZW5kZW50IHByb2Nlc3Np
bmcgaXMgYmVpbmcgZG9uZS4NCj4+Pg0KPj4+IEknbSBub3QgYWdhaW5zdCBjaGFuZ2luZyB0aGlz
LCBtYXliZSBhZGRpbmcgdGhlIGxvY2svdW5sb2NrIHN1ZmZpeCB3b3VsZA0KPj4+IGJlIHByZWZl
cmFibGU/Og0KPj4+DQo+Pj4gaW50IGVmeF9wcm9iZV9kZXZsaW5rX2FuZF9sb2NrKHN0cnVjdCBl
ZnhfbmljICplZngpOw0KPj4+IHZvaWQgZWZ4X3Byb2JlX2RldmxpbmtfdW5sb2NrKHN0cnVjdCBl
ZnhfbmljICplZngpOw0KPj4+IHZvaWQgZWZ4X2ZpbmlfZGV2bGlua19sb2NrKHN0cnVjdCBlZnhf
bmljICplZngpOw0KPj4+IHZvaWQgZWZ4X2ZpbmlfZGV2bGlua19hbmRfdW5sb2NrKHN0cnVjdCBl
ZnhfbmljICplZngpOw0KPj4gU291bmRzIGJldHRlci4gVGhhbmtzIQ0KPiBGV0lXIEknZCBqdXN0
IHRha2UgdGhlIGRldmwgbG9jayBpbiB0aGUgbWFpbiBkcml2ZXIgY29kZS4NCj4gZGV2bGluayBz
aG91bGQgYmUgdmlld2VkIGFzIGEgbGF5ZXIgYmV0d2VlbiBidXMgYW5kIGRyaXZlciByYXRoZXIN
Cj4gdGhhbiBhcyBhbm90aGVyIHN1YnN5c3RlbSB0aGUgZHJpdmVyIHJlZ2lzdGVycyB3aXRoLiBP
dGhlcndpc2UgcmVsb2Fkcw0KPiBhbmQgcG9ydCBjcmVhdGlvbiBnZXQgYXdrd2FyZC4NCj4NCj4g
QnV0IHRoZSBhYm92ZSBzb3VuZHMgb2theSwgdG9vLg0KDQpUaGF0IGlzIHdoYXQgSSBoYXZlIHRy
aWVkIHRvIGRvIHdpdGggdGhlc2UgZXh0cmEgZnVuY3Rpb25zIGludm9rZWQgZnJvbSANCnRoZSBt
YWluIGRyaXZlciBjb2RlLg0KDQpUaGUgcHJvYmxlbSBpcyBvbmUgcGFydCBvZiB0aGUgcHJvdGVj
dGlvbiBuZWVkcyB0byBiZSBkb25lIGluc2lkZSB0aGUgDQpkcml2ZXIncyBkZXZsaW5rIGNvZGUg
KGlmIHdlIHdhbnQgdG8gYXZvaWQgZGlmZmVyZW50IGNhbGxzIGZvciANCmFsbG9jYXRpbmcgdGhl
biByZWdpc3RlcmluZyBvciB1bnJlZ2lzdGVyaW5nIHRoZW4gcmVsZWFzaW5nKSwgc28gaXQgDQps
b29rZWQgYXdrd2FyZCB0byBtZSB0aGUgb3RoZXIgcHJvdGVjdGlvbiBwYXJ0IGJlaW5nIGRpcmVj
dGx5IGluIG1haW4gDQpkcml2ZXIgY29kZS4gU28sIEkgdGhpbmsgdGhlIGV4dHJhIGZ1bmN0aW9u
cyBhcmUgd29ydGggZm9yIGF2b2lkaW5nIA0KY29uZnVzaW9uLg0KDQoNCg0KDQoNCg==
