Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAA5547F49
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 08:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiFMGAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 02:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiFMGAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 02:00:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBCB13F74
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 22:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ohc1uGzveyZTHXO1J4zIULETW4wI/merplMEPC6G5yFcDsVSItE+JGFXxWNfWkopBMDCp66hsCuA1M4tXNzqml0rGEIvDwr1zE0ssn1dN8mazPiZSWjtC1R2VxVSrU44vOswr6cUJxVNd/di51ecfykiCPyGRjLT+SnbEAt8iHA+Cgtsxsz6lvXX4RNE6HB5zK/Pw6G2KLvXv5goHARL4ZuQSm0VPPqpVNBllNlaTMujwATOk2eFMCdEKkAvmgG3er5uc5t9Dn1s2UHarNbnPcOOOHHnr8E/ENtfUV1RHhHBs/I4CLIO8KlXnLVj8tWlp67DJ7UsogUozQ7bufLtzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDxJUFOmdWYgNEQJEcOBHskmEAtIVKbnV98v9kyWoeQ=;
 b=aHvLSyyB7D7aDC30uRNW2sjt6Wlop6mndbW47xYrXLQaowRlxItAGM8PBtoSP9oVHNEsoT8rf9qy010RGcNYUKi5n4atNlbdMuEWjmjZGL+6sp/g5NuMUD9F5qU/Hr835lK4rk71JVUifhMahpTzDDuHlab4Oq0bGKAamqV4j4nGiilqrqOiuW7XVpjAHod+kIC9L8qF8tc7eYZRmjGN5fVUIuQM8THt8IrlDPtwdRx5e88ajCqZ2pl/m6zP/gFm0jRQkRn+wlxgnLrfl3b2eu09iOMdbQ4zeXLaEFzmesN3tO4TCmlWIB4GEV4XmG5ZbG6J7mXakGTm8cHHn80m5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDxJUFOmdWYgNEQJEcOBHskmEAtIVKbnV98v9kyWoeQ=;
 b=JLl9GDppUnyyjKNz/wcU1EA2jA4sAV0iWVVQ+B/En5KcuZ6+/21wAdsVeiuOcT18VZal4ab0Tezqcz+Qan/zYfrlI0sd8f2sJ9SqCSiqlx0ldAWeHE1Pl1aNY8CuhDKE7ywGEAC06vHk76H5GWBHYDn9Zku6omA7SDSORPLnFhrq+VNlyMnobv1T1WsTCmyF2OFY91+1hh4pYiYW4GEmPW76hVDQ2qnKsN/csn4OVpZWpgj3vwnw4KvNNoWroVSaURGQie6SGy0p8eITQLfpAC9w+B+SwtRRtF68DIJppoIBN4eEUU5wl4MzsnESg2PE9jxtwcstjyUDxg/bZdnPzA==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 DS7PR12MB6261.namprd12.prod.outlook.com (2603:10b6:8:97::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Mon, 13 Jun 2022 05:59:58 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::4c43:6ebe:1190:b398]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::4c43:6ebe:1190:b398%6]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 05:59:57 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH] vdpa: Add support for reading vdpa device statistics
Thread-Topic: [PATCH] vdpa: Add support for reading vdpa device statistics
Thread-Index: AQHYdbCkqUjuARXMQUyjX8n4Trk95a1HOteAgAWuRkA=
Date:   Mon, 13 Jun 2022 05:59:57 +0000
Message-ID: <DM8PR12MB5400234FC1BCC7308163FE04ABAB9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220601121021.487664-1-elic@nvidia.com>
 <05585cd3-95e9-1379-967a-7fa6e8d065f3@kernel.org>
In-Reply-To: <05585cd3-95e9-1379-967a-7fa6e8d065f3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b03fd322-2886-4b26-c75f-08da4d01f221
x-ms-traffictypediagnostic: DS7PR12MB6261:EE_
x-microsoft-antispam-prvs: <DS7PR12MB62611ACA233590F1D205F5BEABAB9@DS7PR12MB6261.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e9OciQ2P+bKiqTPm/zP1dLd9am/aXrqFay/kf7x21ivbmKH1sMjrWgtTLHLQi/Y09TzMv3UclOAQRLxRKO02oMoucgrzTLVdybOh8A0s7P2UaP/tFhvw2dOCZhuR7fwt8dZSwqNuJ0xQGSeXqto8uqfpFtSU+3qAXQKG74fWhJd0CAn/sa3dwL+QI4ok9ytF9shKBi92q+IYrdyxelbdwZljA8Wv6aq4kPFAmYPHIE3tOJrzHkGQUb2+mAiwl+zhJXBW5Ld2fSG6c4LkIUzCLcXG/Hz4qKhetxiEtk8OTNIATN1lNWb4y1twcxorottO+xQcNFg0tBv0X9N6luuNiOnvQRaTNKAI7ni+ET/yk9qwh7uVIP6cGt+SNBlXoiMDM65Y/aHU6wV//jbkbL7ucAt+967SOEkSQKnCcRz5YdEGzSbdfDtcMdSC6iHa0FCU2eC6IV/nWAuDjALhitBGMU1fRD3P6UZDZM9Rgd5irbWgL9LYP/pnzIgFJI7hqqIzNVcbWtPRdEgdS0q8teslsC2bD6CaVyNFcZI2yU+NCpuzzEE3mGLaNxzUYqd6KhRCU+q1v4gapdP0M2jqn9j3GnTAH+XLXsS2m/WJnd3sGSW96BzsGCIq1tVAmnCojlrwDPMfDUAeFFXnH2cyQrgu0jplzQueC3tDw1IJJc9wPNcN4K4jxPIGvIf7l6c0vnzeHnzUhV2T3wKbTX7V5fuURw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(38070700005)(316002)(83380400001)(55016003)(9686003)(5660300002)(26005)(33656002)(110136005)(7696005)(52536014)(66946007)(66556008)(508600001)(86362001)(66446008)(64756008)(2906002)(8676002)(76116006)(186003)(8936002)(6506007)(53546011)(122000001)(71200400001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SW9TcmNKRzJuL2ZSZmE0eno1MndOQzJCK1dBc3Z2c1EzYThSbElzNnNYZmxm?=
 =?utf-8?B?dkFMZHUwbXFJcWJ4LzNZcWJWemFpRHpXRzJMU04xa3pRR1IyVzNLWGkydytR?=
 =?utf-8?B?NllxVDFiS3hxRTZzdXd1OC9nY245NlBVenFldjFBVi8yK3ZmSWlxZEZYSVZC?=
 =?utf-8?B?RndaY2oxVVRWcVpHZmRNYmZpbW5ERCtWVXVFVUFkV2V1Q0p6OGc5bGxRWjhi?=
 =?utf-8?B?bnN3RHFIcklVWW54UjZRK3dXb0VYTXA5NWoybWFKUmhrcFR1MHZNQlR6NkJq?=
 =?utf-8?B?Nyt3SkxvaThzWGF6MEtEMHl3VXpnQTlnNDhhd0w2Zkh5R2pqbGpsMTgzNmcx?=
 =?utf-8?B?RGNyd3VhMU82TkxOTEgvdG95aVZtR2h4aFYvVFR5Tk1yWHRvTTJzeFdTTkZV?=
 =?utf-8?B?T290dWovTnFwNmhhM24vN280S2RVUGY4U3ZENWcxYUthVUliSHRYYlhqR2Ja?=
 =?utf-8?B?WkNRVzdyMFVQd2x6TEV1blk3ZFhaeFhIQjNtNjF5KzgzdG9IZGJSZzVjckRv?=
 =?utf-8?B?aHMvaHlpS0lQYkQwTlRRWGRmdjltQzBhMjVnRjZacmxRcnVTd0lPKzlRckI2?=
 =?utf-8?B?d2duV29EWW01cHNSTzJ0L0ppNTJUUmVRa3htZlJRZy9QQTRmZE80V1lybG1L?=
 =?utf-8?B?a1ZvQU02SzN1dmhkNUpwM0NwaEZuS0tWajRwaGhucElrRVlvSFBNWXBwTUVG?=
 =?utf-8?B?M3o0Q2VGYXhxV1JRd0JRUlVLVFBIZkpRMXpJWXdYcE1uVDI1amNtMEwxSVh4?=
 =?utf-8?B?VUdGMVViNEMrNXR3NTVQV2lKVTBvcVZCY1pKczUvUGU2MmtZc25rb3FPRzFo?=
 =?utf-8?B?Y3Fibm9iL1JOOGhVeUYvcnFJT2N0Zk9HUUl3MW1aOTlaK1ZCVDZQSm80eFdz?=
 =?utf-8?B?U2hiOVZCWTFGZmpuTUVzazdESHpmKzgyMEF6eFNTRDlkVnhQemErWlBMWmty?=
 =?utf-8?B?TjI3cmY1NWZtNmdSLzRHOGtDaS9rdE5DVGtxQktFZTRYREhYK0x2UzVkSm5H?=
 =?utf-8?B?dzNHU0tGbDVLbW5XeWZjb1poMVM4ZElnYytjMWZEWFM4ZityZnZwczU5MDAx?=
 =?utf-8?B?M1V1V0kwbkJBRW0vQ2UwbkcwQ1hBa0IvYTNUWXdYUWRhQVNPUWRuZUdROHJ4?=
 =?utf-8?B?bzdMZnlTMktQSm1JMmVONDhUdklNQUtyUUNROUNkei9FeEFONjZxM2RTcFNW?=
 =?utf-8?B?aU1Pd2RYNEJIZDJsWVdreWViOTM3eWM0alJnQU1rT2puZTlSZGF0cGxHaHpj?=
 =?utf-8?B?amtNQnE4QnhnajFLUW9QYUo0Mjh2clhmY0grQzl4WUhuREp1NXhTdm1XWDh5?=
 =?utf-8?B?UmlPUWVtZitrdEg0VDRoT1diZjBZd2lhV0NMcUpZVHl3dGZSWUloSkRVaVJB?=
 =?utf-8?B?Y3JDbGpLS1FFclhKT1BjdFFtall2K0ZONloxVUsrRFVFdXZNOCtULzkwNUZF?=
 =?utf-8?B?eDdlMDhOMFBxTjMrZlRQYXlUOHlxajRxdEpNOEpFNGl3ZlNBc05rZ1dETXJz?=
 =?utf-8?B?bzFLdDdnYjRqY2cyS3JKaEt6ZStRc0t0VzI4TGdQMVJrUHhwSXYyaXBPWlJK?=
 =?utf-8?B?MTlOS3NTb0NJTlkvQjJFb3dMeGtCR1drL2VSaUVCR0tZOEtSQ01kU085TytY?=
 =?utf-8?B?REFpdnd2YVRLYUttSnhnMkhoZUx2K2F3aFJ4RDF1dzJjQTQyc2N5ZmVOaTlW?=
 =?utf-8?B?OVpnWG5jem5yaXJwWmVmL1RBMno0OTczRUlHVU9wWVNwR0I5MTFFSUlPRWc4?=
 =?utf-8?B?eHRlMURqaUdJMFoyUjBWd3cxaEtZaWlBVG9VZ3ZDNWRrbU1KNnFSY1lRYXRN?=
 =?utf-8?B?MnhBczBHNTczRnljM1c5WFNhdFVxWFFXWjFNOTVVSGZycDgxTXlrMUFoc1po?=
 =?utf-8?B?QlU3MHdZYXRTSWx2Q0UvM3BmcWF4SkJXY3ZQdGJOTlFZczlLSHYxVUs2cFhL?=
 =?utf-8?B?cEVDeDNpc1p5MjZYdkpyVzFibnNVdHJRUzB2c29LODB1cEI1akJhRE93YmdW?=
 =?utf-8?B?bnlOREZhSjQ3dDBMQ1pQTVRCNXE3clM2WHdZaU55Yks1cG85UE5MdWJqdWZG?=
 =?utf-8?B?T0xhNmJnbUtzMUhJdVVDTS9POEd5Z05nTk5oa3BSRkUzejZYeXBEMFdmUzdP?=
 =?utf-8?B?Z0YrbEhVbnlhQUZFQk1JVGt5dHMyM1IyM1dENGhGLzdONmFpTFRRU3lYeElj?=
 =?utf-8?B?UWhzellXRGUyWEg0SGFLN3pEcWdwNEdjK3BpZXl3bnRTTVo1dzF4WjhUeDY4?=
 =?utf-8?B?TUtYVkpObzh6NHBYMlVvOXhPUi9lMktQWUFYU1lXamJKei85RlFsRlFkam83?=
 =?utf-8?Q?MbUSg1wLtMuw8Vi5KY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03fd322-2886-4b26-c75f-08da4d01f221
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 05:59:57.8796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iiyy+ZOcq5rkwOCUHTm5YJ0D4xukXzqyii1KbMWxWWAXqMM9c0LjGkScLL4hJ5eI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6261
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSA5LCAyMDIyIDY6MTEgUE0NCj4gVG86IEVsaSBDb2hlbiA8ZWxpY0BudmlkaWEuY29t
PjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91
bmRhdGlvbi5vcmc7IGphc293YW5nQHJlZGhhdC5jb207IHNpLQ0KPiB3ZWkubGl1QG9yYWNsZS5j
b207IG1zdEByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHZkcGE6IEFkZCBzdXBw
b3J0IGZvciByZWFkaW5nIHZkcGEgZGV2aWNlIHN0YXRpc3RpY3MNCj4gDQo+IE9uIDYvMS8yMiA2
OjEwIEFNLCBFbGkgQ29oZW4gd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL3ZkcGEvaW5jbHVkZS91
YXBpL2xpbnV4L3ZkcGEuaCBiL3ZkcGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZkcGEuaA0KPiA+IGlu
ZGV4IGNjNTc1YTgyNWE3Yy4uN2Y1MmU3MDNmMWFkIDEwMDY0NA0KPiA+IC0tLSBhL3ZkcGEvaW5j
bHVkZS91YXBpL2xpbnV4L3ZkcGEuaA0KPiA+ICsrKyBiL3ZkcGEvaW5jbHVkZS91YXBpL2xpbnV4
L3ZkcGEuaA0KPiA+IEBAIC0xOCw2ICsxOCw3IEBAIGVudW0gdmRwYV9jb21tYW5kIHsNCj4gPiAg
CVZEUEFfQ01EX0RFVl9ERUwsDQo+ID4gIAlWRFBBX0NNRF9ERVZfR0VULAkJLyogY2FuIGR1bXAg
Ki8NCj4gPiAgCVZEUEFfQ01EX0RFVl9DT05GSUdfR0VULAkvKiBjYW4gZHVtcCAqLw0KPiA+ICsJ
VkRQQV9DTURfREVWX1NUQVRTX0dFVCwNCj4gPiAgfTsNCj4gPg0KPiA+ICBlbnVtIHZkcGFfYXR0
ciB7DQo+ID4gQEAgLTQ2LDYgKzQ3LDExIEBAIGVudW0gdmRwYV9hdHRyIHsNCj4gPiAgCVZEUEFf
QVRUUl9ERVZfTkVHT1RJQVRFRF9GRUFUVVJFUywJLyogdTY0ICovDQo+ID4gIAlWRFBBX0FUVFJf
REVWX01HTVRERVZfTUFYX1ZRUywJCS8qIHUzMiAqLw0KPiA+ICAJVkRQQV9BVFRSX0RFVl9TVVBQ
T1JURURfRkVBVFVSRVMsCS8qIHU2NCAqLw0KPiA+ICsNCj4gPiArCVZEUEFfQVRUUl9ERVZfUVVF
VUVfSU5ERVgsCQkvKiB1MzIgKi8NCj4gPiArCVZEUEFfQVRUUl9ERVZfVkVORE9SX0FUVFJfTkFN
RSwJCS8qIHN0cmluZyAqLw0KPiA+ICsJVkRQQV9BVFRSX0RFVl9WRU5ET1JfQVRUUl9WQUxVRSwJ
LyogdTY0ICovDQo+ID4gKw0KPiA+ICAJLyogbmV3IGF0dHJpYnV0ZXMgbXVzdCBiZSBhZGRlZCBh
Ym92ZSBoZXJlICovDQo+ID4gIAlWRFBBX0FUVFJfTUFYLA0KPiA+ICB9Ow0KPiANCj4gDQo+IG5v
IHJlZmVyZW5jZSB0byB0aGUga2VybmVsIHBhdGNoLCBzbyBJIGhhdmUgbm8gaWRlYSBpZiB0aGlz
IHVhcGkgaGFzDQo+IGJlZW4gY29tbWl0dGVkIHRvIGEga2VybmVsIHRyZWUuDQoNCkl0IGhhcyBi
ZWVuIG1lcmdlZCB1cHN0cmVhbToNCg0KY29tbWl0IDEzYjAwYjEzNTY2NWM5MjA2NWEyN2MwYzM5
ZGQ5N2UwZjM4MGJkNGYNCkF1dGhvcjogRWxpIENvaGVuIDxlbGljQG52aWRpYS5jb20+DQpEYXRl
OiAgIFdlZCBNYXkgMTggMTY6Mzg6MDAgMjAyMiArMDMwMA0KDQogICAgdmRwYTogQWRkIHN1cHBv
cnQgZm9yIHF1ZXJ5aW5nIHZlbmRvciBzdGF0aXN0aWNzDQoNCkkgYW0gbm90IHN1cmUgd2hhdCdz
IHRoZSBjb252ZW50aW9uIGZvciByZXBvcnRpbmcgc3VjaCByZWZlcmVuY2UuDQpJbiBhbnkgY2Fz
ZSwgSSBjYW4gcmVwb3N0IHRoZSBwYXRjaCBpZiB5b3UgY291bGQgbGV0IG1lIGtub3cgaG93IEkg
c2hvdWxkIHdyaXRlIHRoYXQgcmVmZXJlbmNlLg0KDQo=
