Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1311867C92E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbjAZKxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjAZKxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:53:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D0E7280
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:53:04 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30Q786JI025971
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:53:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=jbSkIAEZ7MxtUwDtChq8rZmy6MLa6D2vJ4y3dt8qAU4=;
 b=WHdDb3lwDtGC9V1xK1yNCZ8AqgnIQEfPiEq0+kM9iW+y5BNtAEtf7ce/qPsOL4v8nwFq
 zBTwCfmu4YJxfPeF73w7393XNjHJh/t6koSfzcaQEra/fYqlnb7mcNW9fT758lNDmA+8
 rv6M/ZaA5ijoCKPe3XdN34d+09ak4URbDYcbgTwQnvZlO3nFVdGBBPL0uTwdnGVL+TlZ
 UFmG9vNjjsAn7fZFzoj7xFF55iWf3JgdQNjfBeSJAyT5kkpZiBWdCA6mBBY5Qdk4P4Nw
 y6qORHlwyZy42sT1P3k2eX4+YeFNG+lzFe4jeJWz7p1IiNQ+2bn2qpNxQADUD0FKlxfl Hw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by m0001303.ppops.net (PPS) with ESMTPS id 3nbe8ytphc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:53:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FU7Rkpt28wMPRtTFTgw4sT1TqYQxgKKyUKKYd5Ftytyejb4R7mW47HXvO5Ufgp9G1QEInzyukqF1AEwJ34VGch0rJYIPqc0bGU/MAU4OwbDA71d+yMw3syBWMa7PMP/CNneBx4LR4zi6BJDPoSWTybtgBxledCfbrQLTFSJWupzlhI6jpJZl0S6bAP+eJ/bJ2Cd0bVn76k4cqy0rvMCdBbmPF0DYz5ckqtPnLTTv25mRIYawj4XahuEWbeFQXbR2AYIFsrFhdl8hbetcKt89JnsoxOggbVv8UUVRT0Guz+EQTWXsAgvfW3mLh7YYFK3Kmg48jDxbuwlfJ43FS/lR/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbSkIAEZ7MxtUwDtChq8rZmy6MLa6D2vJ4y3dt8qAU4=;
 b=GrNvfBsuYwcAwrqPfm2ZNdGADQ8X/1JozYDj4eShQLuwN9lRqlLMlmxEKMNTgod/v/crkl0uQNSGNYop9qmY6E5d6e3pkNlNkNdiXImO+UJlyY/DcC89USnPB609s6mVi39TKqqEni5ATQPtIzTNCrtoblMMsdHafwjPGODLcLEJKN4m02kcFEuTYGQke5XIOpPS/Q+GGXuqsR79Psrd16Mvg9mNZ+JZ70G6wNInqk3DJq/h9URwaertuB6I2+nNqrryblH3tkWdtz8jgWmIe8TodXw761wwQFEWG8nrQNCY/oOhGwDcAI2iuwkh5Jqm9W7Cmg87bDyizSsajYcMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by PH0PR15MB4687.namprd15.prod.outlook.com (2603:10b6:510:8c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 10:53:01 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%5]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 10:53:00 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
CC:     Vadim Fedorenko <vadfed@meta.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Thread-Topic: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Thread-Index: AQHZMSLSAcB4fXCqNk+lG0gDA8dGQa6whm+A
Date:   Thu, 26 Jan 2023 10:53:00 +0000
Message-ID: <ba032f33-716a-b5c6-d118-0ac0527a718a@meta.com>
References: <20230126010206.13483-1-vfedorenko@novek.ru>
 <20230126010206.13483-3-vfedorenko@novek.ru> <87lelqje4u.fsf@nvidia.com>
In-Reply-To: <87lelqje4u.fsf@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|PH0PR15MB4687:EE_
x-ms-office365-filtering-correlation-id: 0ccb5dc4-46ad-4a4d-e5c0-08daff8b7e24
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7R2tKK9hAxHP2eD550Fih0oroiJhbNYvaQk70YmNQxFYnKo3OhnfqMySXbeEhPXQt+qxq8ysy1EHQtyZWxMOOuJlsnPbgyboSFjwfsD4cOR6M5FGQ1W1quXCQDmgpZbkTjeqy8vavgpppEl6DwBc11IuJeetR9/h4djTrEg2bAMg0V5YlBk2YNRUKeAvFwhNOgpARMK1OPww4V+V/BA227Cchx6sNsBB1Ls3ZDJkN0Svxar/jPa5/5zxJigfA1gv/xAslq0d0kuzGg/WxVdNhDcM9xUnfqoxj/B7DNTILNp+HGfnaEPHQfUSyqs1+6AjzUf6sMmSsUcRCz14gTRICkS2Iw0wxxn7ReLnzO9LfCFPHi0QY0QJ/8m7zi8iarUFCwmVsO0x+YIu0hvs8nU1Rb3F1OKFFVsI1loPSdAaDXzhgchvbua0C5Z5sAkqUnRpOrKhrgMVHLdojVOmeZc2K0HvwEdPSDaSv2xNsZ2eoTrD+krEN2M6rIylSK6jkGZZ8+8f8omzLvf5yBcWvyeP6G3KL2V7XvzAAWk5ftt8VmculkiwG+8MZtX4s6el0+5c9aEV+Yka/zBQipm/CAKcZjsIGRM0vbaP7VOLVx/y3gd8Ba4BoBG126ZZx0qR4PPXWc8J/ugtij0zUg1symdN6kjTQE8LnqPT5r3pZbqsibTInaHgVVm61REWZDHgIi8UyUqXulRe9Bfqmc06gL2BZfzeFaIhSw2iZTZerZnNsmo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199018)(2616005)(71200400001)(4326008)(8676002)(66476007)(91956017)(6512007)(26005)(66556008)(478600001)(76116006)(6916009)(31686004)(122000001)(86362001)(38100700002)(31696002)(38070700005)(316002)(36756003)(54906003)(8936002)(64756008)(66446008)(6506007)(53546011)(66946007)(6486002)(186003)(5660300002)(41300700001)(83380400001)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHBnbFdqMVk4aHF3ZlRScFllMGQyeW9HU2VOOU5WNGJOQkxYNS9sdlJ1WGd3?=
 =?utf-8?B?OEUzS1pDSUVNYzkrdjFPMk1UUFBmMGtSalRhOFZ3OFo2MWk2ajhmMlIxR014?=
 =?utf-8?B?S3ZFT3pYWE05SFpBRVdnUWpBK3BVZzY2cDZ4TUQ5M21scEJ2a2dxcUZCamIr?=
 =?utf-8?B?Q1lRb2wrOS9zbEZ0dDhWVG9RRXUxSzRjZ2thV0dIR2RtQ2pkVFFnNjRHaHho?=
 =?utf-8?B?VE1CeXN2WGprbWx6RlNEcWZzQTRVZnZnTHdSL0NrWCtlZXNlNzNEUHZTc25p?=
 =?utf-8?B?cUFnV0xsenVrQS9nUnM5S1NZWEd2SjgxWEtNeHFSNHNBbjhCRlZVRzFlOXcz?=
 =?utf-8?B?YmxrdFNHYkVJcy9IT2NJeHFGbGJ1Z3FxdWh3dUsyUmlidUhkM3oyaUhHNzAw?=
 =?utf-8?B?ekZxZ1lqU1pwMmRmeTBOazc1VHNiNmhoQzNOZG5PVHo4M3h4SElYaE14VjhJ?=
 =?utf-8?B?TThGTjlSTVUreHVkbVpSNENTVnlXWG5BWVVnNzI5R212OUllNGU1aFlXZ3V3?=
 =?utf-8?B?cXVZL09wRm56clV5WERmWWg4SVJ3UmxqR3lUVDZtUzNzTWErN3F6OVRnUU50?=
 =?utf-8?B?bFdhdlBudTZ3NjErSUZ1NU9CYUFHRmlDSVdVTTRRbE9nRHp1L1piNnVaeDJX?=
 =?utf-8?B?S01vYWFzcmtuRTRNSHhJODE5VFlRVmc1RGlhdXhCZThyUDc2ak9lTEZMNFVR?=
 =?utf-8?B?WUtuL0FHbG12KzhFZWtIMFJveXA1eTNieVg3TUJsOFA5V01ZVytzSkhnVVBC?=
 =?utf-8?B?dVpoN25yOVIvQWhPViswMEwvaTgvMDB1OTE5Nk94ZE4yaytOb25vMURQTjlu?=
 =?utf-8?B?ZHYreEJTNUpVVFd3WUVCdGErNVFTejB6VHlEcFMvV01WUlpoakpDNnF5YTF2?=
 =?utf-8?B?ZGQrbW5UVSthR0dZWHN3MVRHNWJxZ2JjbVM3TTRDNi95TnJTWWxJSytLVjZx?=
 =?utf-8?B?c0Q3K2JzWUxTd2N5b2VyMFRSd1hjTnM4clQ5d01JK2RGRmtlb21xZDJoVWNp?=
 =?utf-8?B?MnF5YjJOMnF2SWxTMUU1MmowWW1jYW83eVk3SEFodmp5NVlsaWxIbEJYY2VW?=
 =?utf-8?B?UHU5bitNeDNBdVpTdk41SVlhKzdya2VGemR5TktaMmJkTWVnRisvUUlVeEF1?=
 =?utf-8?B?THBENjEwakp3c25SS1djUzVUZVdWVkZFRmgraFhZOEFaRCsyUVZsbDFDVmxF?=
 =?utf-8?B?REE0WXo5MmZVQ1VNK1Rxc1FxZlhNdFdzaXNLNzJUWnN4U3h5bWsyeW5vU05u?=
 =?utf-8?B?eUhXZUxUV3ZpQ2c0TUhtcXVLSWFWZWJITVRZcnR3bUZ0L1B5WXYyaW93Sjg3?=
 =?utf-8?B?aTRIN2tSK2RZT1p6K05mcExHTkwraGd1VWszS21JZTd2eWZIUDJ0WTBaZUNj?=
 =?utf-8?B?WVpNbDlaZ1JTamw0NG02ZmlMUlRJYUt1SzBzM1FZZ1l0NGlqeGp3dkt1RHhh?=
 =?utf-8?B?OWp1MEZ5OWRZck1yTkxSbXoxbWl0TGRVZUtPdlJvQkZ2T0pMMnl5NTdCSUdO?=
 =?utf-8?B?L2dTWnZ5R1dKNERsZGZNRWViNHcySGltSFcxY0NrNk51ak5pZlFSRUZnaXI0?=
 =?utf-8?B?QXJFQ2RaK0VEQ0tsd3Q0MTVDOXVSY3JSQmJEak5wR2drV0cyZitQYlRNWDFV?=
 =?utf-8?B?cDJ0RElLSFF3RHNkSG1HcEFPZVNZQmJ1RGtjOVdpMkdmd1M3Mi9DYkpId1Yz?=
 =?utf-8?B?dDhaRTlpYkR6KzFOdmVYT2NWY3lPRCt6OG1XWWRGQjdFb0RrbjdkNFFhbHNR?=
 =?utf-8?B?bUp3ZFo4elAzNWF6enZCaWZ3UjRiQVVnSW1pQTVEbUFCTUtTcWFRbVhkOGNB?=
 =?utf-8?B?azZlVFRMVTBGMGFNRjFPQlZPdlFCMEZVNFB6NHVtNW91alV6SVF2NHlLM1Rs?=
 =?utf-8?B?MUFpY0JFdTljN1Q4Q3ZUeXFSU2ZyQ3doUTZPNTJyS1IxYmxrTFlIc01FRDJY?=
 =?utf-8?B?dzkxNXpHWG83SFZXa3IxeTVVTmJNRjRBSU8wM0hQUEc4UDhsK3hpenhlT1No?=
 =?utf-8?B?RFdEM2FKelZBdEx4N2pFRDlCVG42dloxTWcySjRlSzd6M0ZPV3ltZ0FRNEor?=
 =?utf-8?B?b2pSZWxLV2xZcHZtWTlaMWVJeFhIVFhzYy9UelowZzVaUjBsOUhCWUExS3Q1?=
 =?utf-8?Q?yePg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC8EC46367B28549AD4F0C6FEDF59395@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ccb5dc4-46ad-4a4d-e5c0-08daff8b7e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 10:53:00.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fKoLs/S+mRIsaF1U/JiySJeskkdAoj8Dom7XJlo5crUjbEKLsICgGokDe66epAZk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4687
X-Proofpoint-ORIG-GUID: nMf4GZItl7Z592SCrCbQ6KZRLEN4JuRN
X-Proofpoint-GUID: nMf4GZItl7Z592SCrCbQ6KZRLEN4JuRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_04,2023-01-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYvMDEvMjAyMyAwMTowOSwgUmFodWwgUmFtZXNoYmFidSB3cm90ZToNCj4gT24gVGh1LCAy
NiBKYW4sIDIwMjMgMDQ6MDI6MDYgKzAzMDAgVmFkaW0gRmVkb3JlbmtvIDx2ZmVkb3JlbmtvQG5v
dmVrLnJ1PiB3cm90ZToNCj4+IEZyb206IFZhZGltIEZlZG9yZW5rbyA8dmFkZmVkQG1ldGEuY29t
Pg0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4vdHhyeC5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuL3R4cnguaA0KPj4gaW5kZXggMTVhNWE1N2I0N2I4Li42ZTU1OWI4NTZhZmIgMTAwNjQ0DQo+
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdHhyeC5o
DQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdHhy
eC5oDQo+PiBAQCAtMjg5LDE0ICsyODksMTkgQEAgc3RydWN0IHNrX2J1ZmYgKiptbHg1ZV9za2Jf
Zmlmb19nZXQoc3RydWN0IG1seDVlX3NrYl9maWZvICpmaWZvLCB1MTYgaSkNCj4+ICAgc3RhdGlj
IGlubGluZQ0KPj4gICB2b2lkIG1seDVlX3NrYl9maWZvX3B1c2goc3RydWN0IG1seDVlX3NrYl9m
aWZvICpmaWZvLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4gICB7DQo+PiAtCXN0cnVjdCBza19i
dWZmICoqc2tiX2l0ZW0gPSBtbHg1ZV9za2JfZmlmb19nZXQoZmlmbywgKCpmaWZvLT5wYykrKyk7
DQo+PiArCXN0cnVjdCBza19idWZmICoqc2tiX2l0ZW07DQo+PiAgIA0KPj4gKwlXQVJOX09OQ0Uo
bWx4NWVfc2tiX2ZpZm9faGFzX3Jvb20oZmlmbyksICJwdHAgZmlmbyBvdmVyZmxvdyIpOw0KPiAN
Cj4gSSB0aGluayB5b3UgbWVhbnQgJ1dBUk5fT05DRSghbWx4NWVfc2tiX2ZpZm9faGFzX3Jvb20o
ZmlmbyksICJwdHAgZmlmbyBvdmVyZmxvdyIpOyc/DQo+IA0KWWVzLCB5b3UgYXJlIGFic29sdXRl
bHkgcmlnaHQsIG1pc3R5cGluZyBkdXJpbmcgcmUtYXJyYW5nZS4NCldpbGwgaW1wcm92ZSBpbiB0
aGUgbmV4dCBzcGluLg0KDQo+IEl0IGlzIG9ubHkgc2FmZSB0byBwdXNoIGluIHRoZSBmaWZvIHdo
ZW4gdGhlIGZpZm8gaGFzIHJvb20uIFRoZXJlZm9yZSwNCj4gd2Ugc2hvdWxkIHdhcm4gd2hlbiBh
IHB1c2ggaXMgYXR0ZW1wdGVkIHdpdGggbm8gbW9yZSByb29tIGluIHRoZSBmaWZvLg0KPiBEb2Vz
IHRoaXMgd2FybmluZywgYXMgaXMsIG5vdCB0cmlnZ2VyIGZvciB5b3UgZHVyaW5nIHRlc3Rpbmcg
aW4gbm9ybWFsDQo+IGNvbmRpdGlvbnM/DQo+IA0KPj4gKwlza2JfaXRlbSA9IG1seDVlX3NrYl9m
aWZvX2dldChmaWZvLCAoKmZpZm8tPnBjKSsrKTsNCj4+ICAgCSpza2JfaXRlbSA9IHNrYjsNCj4+
ICAgfQ0KDQo=
