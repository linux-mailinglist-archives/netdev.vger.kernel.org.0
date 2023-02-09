Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3185668FC74
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjBIBLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjBIBLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:11:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC980241C8
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 17:10:53 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3190Lm8P008141
        for <netdev@vger.kernel.org>; Wed, 8 Feb 2023 17:10:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=6IjEMJZcoEpTmUWY1qMT0/XtY0JdKWpcGnvX66yV5U4=;
 b=blRrJKiOhaeOScokeYV9hEi86Dejw7VVmeoC+4Hoqi092lztz/qvp3/ORXzlxsgXrTt9
 kvCBxkAEpBNG1JMWT0FWivTuWRsDSuAQP4F/mNhicntPD8Ae/BaOgcTUs7swqD9l6/SZ
 nCBJ3H22QYqyzHUNmh60bv8W1JYXaXSUIJoUIblOInh6kFY9AD6E2mj2k0iDWjHIbeI0
 RGPqNjTVnX3Dl1NSBsOCVqXucrghsoqwdFA4Uz8kitDmhNoCEHX1OZY0Wh2DhlgpsnLV
 uHkrXtACJTXIcTEQHad/0fsumINcDYdvLVNwOm92HyG5Ws/trLjC0fsYgVDjRkp6Clj4 pg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nmc0en5y1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 17:10:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jL79b1gBypPWY5VudIRg90J2zdl3jIkkyOw255jzXJSYgZBagBAJHMsShjXuPrQm5J1nM5EAdKbn4bSd9C9xFrw2bzor0uPp/Hy5sHtlKjXqEEZqkUMJmfQc28TPH+PyzW8Nc+aQsc89QAYPHwPuvdB18lm7iKgJvhBGgetS6jxOTkZYkhpHUw1ntKKvWvSCgN51gRr7wlo6GQAimhwPtVoMGyn4AdzuOIXkogo852fmmc4iP2QtF87rLF/9/TxsuI8+K98yw5HKBkMA9QakD9A51Q6iec2GFDELT/2Xe7y+PkpZ+Z52G8YYNwzkX58JayyXfqZc9kFHFrmoA2ZcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IjEMJZcoEpTmUWY1qMT0/XtY0JdKWpcGnvX66yV5U4=;
 b=jaEffDKml4GmP+KmdGgNZSNwSqMtL0dlKpfgFzCNV9Z3+5hlsDdpRtjq6YOcdUGzEweARdTJscHyYAI5Ajfsi/zDthxVPAEsdwp4/9qYOwvyoz5riEqnxkKQrFwjc5VEw/IJAkuRlEYlAzbVepGY6PIwizTkRaPqhhVca3LbM09zwVYmEV19db1TOHDb9kkBZeVwcpBc83+wAvNoBYAtO6XFvriKGsCyOsxmotPYrX0YSp5e8Q2eMlB2P5Fdye/yG+5yO4AAHwCyBRgoIWskRQyMaCCXipOlZEL20cBFGomRrPlD+K8dv+mxZ92DLGg39rm4m4UhGjftXuySLVcFOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by BLAPR15MB3796.namprd15.prod.outlook.com (2603:10b6:208:254::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Thu, 9 Feb
 2023 01:10:50 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%4]) with mapi id 15.20.6064.036; Thu, 9 Feb 2023
 01:10:50 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
Thread-Topic: [pull request][net 00/10] mlx5 fixes 2023-02-07
Thread-Index: AQHZO7p4l5PrEWm23kCDSJXiK57f2K7Fhy2AgAAGl9aAAAWxAIAAJgKpgAAVxYA=
Date:   Thu, 9 Feb 2023 01:10:50 +0000
Message-ID: <5c6cad41-b54f-ed86-e067-b84c0e4bd647@meta.com>
References: <20230208030302.95378-1-saeed@kernel.org>
 <66d29f48-f8e1-7a2e-cc46-3872a963c33a@meta.com>
 <DM5PR12MB134054EC92BC13E36B6C5711B3D89@DM5PR12MB1340.namprd12.prod.outlook.com>
 <871qmzoo2r.fsf@nvidia.com> <3af8d360-bccb-a121-8e97-82a00472c93e@meta.com>
 <87ttzvn2ab.fsf@nvidia.com>
In-Reply-To: <87ttzvn2ab.fsf@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|BLAPR15MB3796:EE_
x-ms-office365-filtering-correlation-id: efd8245f-6f10-4ce6-7fa2-08db0a3a7baf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGQIrsiiEUGP79Hw3bi2UwcWdhBaD0JrTsKEaK4svJWSvu6NIOjsmTtufOb/x3zt91s59IEtjUnTC33Jw2n3jkjiFuVxsiMe7KEzvoF1xhRngKx/hcNU6DkiVy2et9upAGoGI3VKX1HpRGvLk+vnOo7+vJ46PcU6b8FqPBh6gN4vEjE5lNsb1wbd2dVO2lcGbXPFrPD56J5am/NvUJdNh4MTH1cPKQaWMCorU7NArbZOpRWxd4AzgOKOcMvi4+sNUt8KSbBZFQBcAmwADG9KkEB9r/nHKdiXjGcDNrvZyFley/KpfQ2poCMu4HnwwdFdqIvhAtc4md2vWLoScdoo3npdgX0lKCWQfGvI0EO2r5+j4GEb6cJUdGETlHXTw9F7hCDL5s1go4I+0T0dgUkpgb2YIuhzJJmP4v1YRKVeos2m3vmTVwaV9ZWPv7bD4Ahy7zqLcwrph6lWyXd5ZCFplboWgeZStGGugutrw99+DTY3QkwuxAb4Dwdy/5vua8BQ53cRSR5mtHhdTG6JRFSbNvJzcginU4IlYPIkS3UyTyC+YFj0A2EhIKR/GaAJB6UkkU5qWEVWBZ9FX/7U/zH7WGZgSe4A30QaViw2Gd6sdK8xAbxP+7KdXCn3q9YAYdpXjtnKxItVZjSfIDZTL9XQRRRCmmazKfY/v7QzTQJ3+fkwP8yL3/gRj6g9i27goyxZRyHubSD3oaEfqSlWQZ3pXeJ0CIi4ZH9ansX5zePn0gU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199018)(54906003)(53546011)(6506007)(38070700005)(31696002)(38100700002)(6512007)(316002)(186003)(71200400001)(86362001)(8676002)(122000001)(6486002)(478600001)(26005)(41300700001)(83380400001)(5660300002)(8936002)(36756003)(6916009)(76116006)(4326008)(66446008)(66476007)(64756008)(91956017)(2616005)(66946007)(66556008)(2906002)(31686004)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFBjRUZodTRSZWcvUCt2eU8zYlNMQ1NlNjNFcjdXTWRnZ1ZwV0oyM2NqYUVY?=
 =?utf-8?B?eEdiK0phQnZTWU9JcW1zbUt3ZTJZTldxODI0NkVkZml0c0tNNFFCZ2FqNUdK?=
 =?utf-8?B?cGZIUDV3OVdRUk1ZYXY2bUVyY2RMek8zNFpSaXVrSXBVbXBibGdzUDQrM2pn?=
 =?utf-8?B?WXBZRFRJdjlONUVGMTZnaGZybE5rZ1FwRGthb0RmcXN3RlMxZW1Sb2s4a1NY?=
 =?utf-8?B?dGgramlhSk1mRzZBRVZnR1Arc21RKzRaaDhKS3pqTktiYm5pR3lDdTEzTlRB?=
 =?utf-8?B?MGJNMFFPYktRSEM1SnZwemtyeDhqVnRJNjc5a2NTL0d2UnJ3L0dld3puMUh2?=
 =?utf-8?B?QTFpZnd2Y0JVR2JnZHI2ZHhaQTVVWnh0MGlXbHNmQ1o1eWlLdkhNY3Z1Kzcx?=
 =?utf-8?B?N1ZDWUI0amdJNnVYbTMxSEExQng5dDV0dzI0VFRReWZYR3ptdmgvMm9zeHZR?=
 =?utf-8?B?bGN4RTUxMkNlaXB5cVBqZlpqYWJXVUx1ZnlDY1RHWEdCUXNUMUNIYklHZTI5?=
 =?utf-8?B?YU81YUp0S0dmK1FBd2Rab2FGcWxzckpDaHZMSUtLY291K2pMdUZ3QjVzZ0tJ?=
 =?utf-8?B?SVdGeDdVNWRGdXJyeVdhTTM4WlV6Wk1iUFZmbzhUQTllTCs2Nmp4bTN6UkxB?=
 =?utf-8?B?YVF5cG1hQ3JXblNJWmlkWnEyVmc3NVRnYlFMZHdpSmVaNEE2Z1kvc2wzNWVy?=
 =?utf-8?B?K05KOExSTmZZSFdQNWxSNDMyZ0xHUVRKQStuaTVFWUNwUXE4WVFQbUhRcGlm?=
 =?utf-8?B?RUZkbEFidlMxTXVIQUdqVXN2Z3VqMy9ITCsrczBTUDdXcHdqSmJrV1VWWWI2?=
 =?utf-8?B?Wm9JZEJOSS9acGhXcGFRVldoS0ZUVDF0aURra3M5V2tRckd2aS9VMmt3WDd6?=
 =?utf-8?B?UE5iVThsQVkzQXFkTVBqUDBjQnk0bFRkV0JIQkZnSzlmNTRid0JGbWhqNnVK?=
 =?utf-8?B?MW00eGJwT3VicjJMWnAvdzhiK2J0ejQ0MVdnVllGdnVQeFNFdmI1dytmdG1x?=
 =?utf-8?B?VDNkaUViUTNrcVlMdGVjdmFZOTZBcXZENEFKUDR4TFVFN0hEOW8xZnVka09Q?=
 =?utf-8?B?NjZROHNSaVM3c25IejRQZFVtVnhUaVlrc1N6R2V5ZTNzYW83V2czUDR6cEpn?=
 =?utf-8?B?YWZUOWZpYVFxUEMwaEV2aVhUUWU3NTBCdzV6QXpVYUlJdDA5c2RiMnFDRHp0?=
 =?utf-8?B?T1hiTTh1cnlEaEhJcUVTbmxyNWF3QWhVM2tRV29kZ09kTXM4aWxGcjR4ZDUv?=
 =?utf-8?B?VkhSWldUNmMvSmEvM2pzb1BSZmd6ek95WDEzOEJKeVgvbElEYUVXekIwaHdL?=
 =?utf-8?B?K0hHK3dmeHhjd3drb1I1b0hDcVF0Y2tNeHh1R3FhUWp2ZXhBZ29TV3pjV2N6?=
 =?utf-8?B?eXQwRU85cDUwaXRsd0xaTzF2Q0I3dkNCVzZRMGo5cE1oQldieGl0TXREM0JF?=
 =?utf-8?B?eDV6OWNkV2ltQ1c3di9BWmt2SEY4TmVXVzMyMkxYQ1lEa1FKVXoxTVpnME5F?=
 =?utf-8?B?UmVHejZtZWJxS2dhQmlwQUlsbkIvZmRJeDdiMXVWOExUWDVSd3RzTzdYaTZu?=
 =?utf-8?B?bmJyQmd5YUhMWDJzNHYwVno4ZmdnUUtFUHhHREp3em1yQ2hCZkxBcXk1dDh4?=
 =?utf-8?B?all3TThYZjhIamhsZHYvcE92NTNrWjFybU5rUGp0N1NWeVcxTDVnVXpkaVRJ?=
 =?utf-8?B?clNvejAvVjM1RzJOYU03LzNHVU14TlhqdmhOcFJyOC95STVsU1A1bXc4UnFo?=
 =?utf-8?B?Z1NncUw1YXFrd0E1T3hPNGo1ZHRsbWJMTUxRWWVTNnBsellXNXM3OFp1UEF0?=
 =?utf-8?B?akJpdytZRVRXQU5TaVI3SGsxWmlaNUY1cDlCY0pVY05rSHlSaFV1NTVDbjJi?=
 =?utf-8?B?YWxLZzdvMVR1RHB6aTBkbzVVMmJjZWJPWGlYbWlpbS9kZjlwZ05qYzhrRGlF?=
 =?utf-8?B?MFh2eUpnQjdvMTV6MTFUZkxvRlZZN3FHMmorZ3crajVaN3VIdmUyalQ1d3JV?=
 =?utf-8?B?dVdHMEJ3cGFNeDYwbWRUTVQrZlB2QnphNkU0eFVJSGlRdkZ1VzFnZmRaV1Yx?=
 =?utf-8?B?blNPRHZ4bWRZdDUvNXgwTC85OExBTzJDS0pHWlhoSXZUM2FndE9Pdy91TlRD?=
 =?utf-8?Q?kwbM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <079852F5A5AECB49B0F5F77E9FCB78FF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd8245f-6f10-4ce6-7fa2-08db0a3a7baf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 01:10:50.2225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: noqoR4SOasXoU6obFYjRdA4lA0tN/yRmp9sP45AFkEsui2rH64lHyJy2TDqKsAr4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3796
X-Proofpoint-GUID: fE-3ApMX1PVh3NeCkICBe6TFVk4u6Cvg
X-Proofpoint-ORIG-GUID: fE-3ApMX1PVh3NeCkICBe6TFVk4u6Cvg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_11,2023-02-08_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDgvMDIvMjAyMyAyMzo1MiwgUmFodWwgUmFtZXNoYmFidSB3cm90ZToNCj4gT24gV2VkLCAw
OCBGZWIsIDIwMjMgMjE6MzY6NTIgKzAwMDAgVmFkaW0gRmVkb3JlbmtvIDx2YWRmZWRAbWV0YS5j
b20+IHdyb3RlOg0KPj4gT24gMDgvMDIvMjAyMyAyMToxNiwgUmFodWwgUmFtZXNoYmFidSB3cm90
ZToNCj4+PiBPbiBXZWQsIDA4IEZlYiwgMjAyMyAxMjo1Mjo1NSAtMDgwMCBTYWVlZCBNYWhhbWVl
ZCA8c2FlZWRtQG52aWRpYS5jb20+IHdyb3RlOg0KPj4+PiBIaSBWYWRpbSwNCj4+Pj4NCj4+Pj4g
V2UgaGF2ZSBzb21lIG5ldyBmaW5kaW5ncyBpbnRlcm5hbGx5IGFuZCBSYWh1bCBpcyB0ZXN0aW5n
IHlvdXIgcGF0Y2hlcywNCj4+Pj4gaGUgZm91bmQgc29tZSBpc3N1ZXMgd2hlcmUgdGhlIHBhdGNo
ZXMgZG9uJ3QgaGFuZGxlIHRoZSBjYXNlIHdoZXJlIG9ubHkgZHJvcHMgYXJlIGhhcHBlbmluZywg
bWVhbmluZ3Mgbm8gT09PLg0KPj4+Pg0KPj4+PiBSYWh1bCBjYW4gc2hhcmUgbW9yZSBkZXRhaWxz
LCBoZSdzIHN0aWxsIHdvcmtpbmcgb24gdGhpcyBhbmQgSSBiZWxpZXZlIHdlIHdpbGwgaGF2ZSBh
IGZ1bGx5IGRldGFpbGVkIGZvbGxvdy11cCBieSB0aGUgZW5kIG9mIHRoZSB3ZWVrLg0KPj4+IE9u
ZSB0aGluZyBJIG5vdGljZWQgd2FzIHRoZSBjb25kaXRpb25hbCBpbiBtbHg1ZV9wdHBfdHNfY3Fl
X29vbyBpbiB2NQ0KPj4+IGRvZXMgaGFuZGxlIE9PTyBidXQgY29uc2lkZXJzIHRoZSBtb25vdG9t
aWNhbGx5IGluY3JlYXNpbmcgY2FzZSBvZiAxLDMsNA0KPj4+IGZvciBleGFtcGxlIHRvIGJlIE9P
TyBhcyB3ZWxsIChhIHJlc3luYyBkb2VzIG5vdCBvY2N1ciB3aGVuIEkgdGVzdGVkDQo+Pj4gdGhp
cyBjYXNlKS4NCj4+PiBBIHNpbXBsZSBwYXRjaCBJIG1hZGUgdG8gdmVyaWZ5IHRoaXMuDQo+Pj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9w
dHAuYw0KPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3B0
cC5jDQo+Pj4gaW5kZXggYWU3NWUyMzAxNzBiLi5kZmE1YzUzYmQwZDUgMTAwNjQ0DQo+Pj4gLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3B0cC5jDQo+Pj4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3B0cC5jDQo+
Pj4gQEAgLTEyNSw2ICsxMjUsOCBAQCBzdGF0aWMgdm9pZCBtbHg1ZV9wdHBfaGFuZGxlX3RzX2Nx
ZShzdHJ1Y3QgbWx4NWVfcHRwc3EgKnB0cHNxLA0KPj4+ICAgIAlzdHJ1Y3Qgc2tfYnVmZiAqc2ti
Ow0KPj4+ICAgIAlrdGltZV90IGh3dHN0YW1wOw0KPj4+ICAgICsJcHJfaW5mbygid3FlX2NvdW50
ZXIgdmFsdWU6ICV1XG4iLCBza2JfaWQpOw0KPj4+ICsNCj4+PiAgICAJaWYgKHVubGlrZWx5KE1M
WDVFX1JYX0VSUl9DUUUoY3FlKSkpIHsNCj4+PiAgICAJCXNrYiA9IG1seDVlX3NrYl9maWZvX3Bv
cCgmcHRwc3EtPnNrYl9maWZvKTsNCj4+PiAgICAJCXB0cHNxLT5jcV9zdGF0cy0+ZXJyX2NxZSsr
Ow0KPj4+IEBAIC0xMzMsNiArMTM1LDcgQEAgc3RhdGljIHZvaWQgbWx4NWVfcHRwX2hhbmRsZV90
c19jcWUoc3RydWN0IG1seDVlX3B0cHNxICpwdHBzcSwNCj4+PiAgICAgIAlpZiAobWx4NWVfcHRw
X3RzX2NxZV9kcm9wKHB0cHNxLCBza2JfY2MsIHNrYl9pZCkpIHsNCj4+PiAgICAJCWlmIChtbHg1
ZV9wdHBfdHNfY3FlX29vbyhwdHBzcSwgc2tiX2lkKSkgew0KPj4+ICsJCQlwcl9pbmZvKCJNYXJr
ZWQgb29vIHdxZV9jb3VudGVyOiAldVxuIiwgc2tiX2lkKTsNCj4+PiAgICAJCQkvKiBhbHJlYWR5
IGhhbmRsZWQgYnkgYSBwcmV2aW91cyByZXN5bmMgKi8NCj4+PiAgICAJCQlwdHBzcS0+Y3Ffc3Rh
dHMtPm9vb19jcWVfZHJvcCsrOw0KPj4+ICAgIAkJCXJldHVybjsNCj4+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3R4LmMgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdHguYw0KPj4+IGluZGV4IGY3ODk3
ZGRiMjljNS4uODU4MmYwNTM1ZTIxIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eC5jDQo+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3R4LmMNCj4+PiBAQCAtNjQ2LDcgKzY0Niw3IEBA
IHN0YXRpYyB2b2lkIG1seDVlX2NxZV90c19pZF9lc2VnKHN0cnVjdCBtbHg1ZV9wdHBzcSAqcHRw
c3EsIHN0cnVjdCBza19idWZmICpza2IsDQo+Pj4gICAgCQkJCSBzdHJ1Y3QgbWx4NV93cWVfZXRo
X3NlZyAqZXNlZykNCj4+PiAgICB7DQo+Pj4gICAgCWlmIChwdHBzcS0+dHNfY3FlX2N0cl9tYXNr
ICYmIHVubGlrZWx5KHNrYl9zaGluZm8oc2tiKS0+dHhfZmxhZ3MgJiBTS0JUWF9IV19UU1RBTVAp
KQ0KPj4+IC0JCWVzZWctPmZsb3dfdGFibGVfbWV0YWRhdGEgPSBjcHVfdG9fYmUzMihwdHBzcS0+
c2tiX2ZpZm9fcGMgJg0KPj4+ICsJCWVzZWctPmZsb3dfdGFibGVfbWV0YWRhdGEgPSBjcHVfdG9f
YmUzMigocHRwc3EtPnNrYl9maWZvX3BjICogMikgJg0KPj4+ICAgIAkJCQkJCQlwdHBzcS0+dHNf
Y3FlX2N0cl9tYXNrKTsNCj4+PiAgICB9DQo+Pj4gICAgQmFzaWNhbGx5LCBJIG11bHRpcGx5IHRo
ZSB3cWVfY291bnRlciB3cml0dGVuIGluIHRoZSBXUUUgYnkgdHdvLiBUaGUNCj4+PiB0aGluZyBo
ZXJlIGlzIHdlIGhhdmUgYSBzaXR1YXRpb24gd2hlcmUgd2UgaGF2ZSAibG9zdCIgYSBDUUUgd2l0
aA0KPj4+IHdxZV9jb3VudGVyIGluZGV4IG9mIG9uZSwgYnV0IHRoZSBwYXRjaCB0cmVhdHMgdGhh
dCBhcyBPT08sIHdoaWNoDQo+Pj4gYmFzaWNhbGx5IGRpc2FibGVzIG91ciBub3JtYWwgcmVzaWxp
ZW5jeSBwYXRoIGZvciByZXN5bmNzIG9uIGRyb3BzLiBBdA0KPj4+IHRoYXQgcG9pbnQsIHRoZSBw
YXRjaCBjb3VsZCBqdXN0IHJlbW92ZSB0aGUgcmVzeW5jIGxvZ2ljIGFsdG9nZXRoZXIgd2hlbg0K
Pj4+IGEgZHJvcCBpcyBkZXRlY3RlZC4NCj4+PiBXaGF0IEkgbm90aWNlZCB0aGVuIHdhcyB0aGF0
IHRoZSBjYXNlIG9mIDAsMiB3YXMgbWFya2VkIGFzIE9PTyBldmVuDQo+Pj4gdGhvdWdoIG91dCBv
ZiBvcmRlciB3b3VsZCBiZSBzb21ldGhpbmcgbGlrZSAwLDIsMS4NCj4+PiAgICAgW0ZlYiA4IDAy
OjQwXSB3cWVfY291bnRlciB2YWx1ZTogMA0KPj4+ICAgICBbICsyNC4xOTk0MDRdIHdxZV9jb3Vu
dGVyIHZhbHVlOiAyDQo+Pj4gICAgIFvCoCArMC4wMDEwNDFdIE1hcmtlZCBvb28gd3FlX2NvdW50
ZXI6IDINCj4+PiBJIGFja25vd2xlZGdlIHRoZSBPT08gaXNzdWUgYnV0IG5vdCBzdXJlIHRoZSBw
YXRjaCBhcyBpcywgY29ycmVjdGx5DQo+Pj4gc29sdmVzIHRoZSBpc3N1ZS4NCj4+Pg0KPj4NCj4+
IFdpdGggdGhpcyBwYXRjaCBpdCdzIG5vdCBjbGVhciBob3cgbWFueSBza2JzIHdlcmUgaW4gdGhl
IHF1ZXVlLiBBRkFJVSBpZiB0aGVyZQ0KPj4gd2FzIG9ubHkgc2tiIGlkID0gMSBpbiB0aGUgcXVl
dWUsIHRoZW4gdGhlIGlkID0gMiBpcyBkZWZpbml0ZWx5IE9PTyBiZWNhdXNlIGl0DQo+PiBjb3Vs
ZG4ndCBiZSBmb3VuZCBpbiB0aGUgcXVldWUuIE90aGVyd2lzZSByZXN5bmMgc2hvdWxkIGJlIHRy
aWdnZXJlZCBhbmQgdGhhdCBpcw0KPj4gd2hhdCBJIGhhdmUgc2VlbiBpbiBvdXIgc2V0dXAgd2l0
aCB2NSBwYXRjaGVzLg0KPiANCj4gV2l0aCB0aGlzIHBhdGNoIGF0IHRoZSB0aW1lIG9mIHRlc3Rp
bmcsIHRoZSBwYyBpcyBvbmx5IDIgYmVjYXVzZSB3ZQ0KPiBza2lwcGVkIGdlbmVyYXRpbmcgYSBX
UUUgd2l0aCBhIHdxZV9jb3VudGVyIG9mIDEuIFRoaXMgbWF0Y2hlcyB5b3VyDQo+IGV4cGVjdGF0
aW9uIHRoYXQgaXQncyBPT08gc2luY2Ugd2UgZG9uJ3QgaGF2ZSBhIHBjIG9mIDMgKHdxZV9jb3Vu
dGVyDQo+IDxza2IgaWQ+IDEgd2FzIG5ldmVyIGFjdHVhbGx5IHB1dCBvbiB0aGUgV1EpLg0KPiAN
Cj4gT25lIHRoaW5nIEkgYW0gc3RpbGwgY29uY2VybmVkIGFib3V0IHRoZW4uDQo+IA0KPiAgICB3
cWVfY291bnRlciAgIDAgICAzICAgMSAgIDINCj4gICAgc2tiX2NjICAgICAgICAwICAgMSAgIDIg
ICAzDQo+ICAgIHNrYl9wYyAgICAgICAgNCAgIDQgICA0ICAgNA0KPiANCj4gTGV0cyBzYXkgd2Ug
ZW5jb3VudGVyIHdxZV9jb3VudGVyIDMgYW5kIHRoZSBwYyBpcyBjdXJyZW50bHkgNC4gT09PIGlz
DQo+IG5vdCB0cmlnZ2VyZWQgYW5kIHdlIGdvIGludG8gdGhlIHJlc3luYyBsb2dpYy4gVGhlIHJl
c3luYyBsb2dpYyB0aGVuDQo+IGNvbnN1bWVycyAzLCAxLCBhbmQgMiBvdXQgb2Ygb3JkZXIgd2hp
Y2ggaXMgc3RpbGwgYW4gaXNzdWU/DQoNClJlc3luYyBsb2dpYyB3aWxsIGRyb3AgMSBhbmQgMi4g
VGhlIDMgd2lsbCBiZSBjb25zdW1lZCBhbmQgdGhlIGxvZ2ljIA0Kd2lsbCB3YWl0IGZvciA0IGFz
IHRoZSBuZXh0IG9uZS4gQW5kIGluIHRoaXMgY2FzZSBpdCdzIE9LIHRvIGNvdW50IDEgYW5kIA0K
MiBhcyBPT08gYmVjYXVzZSBib3RoIG9mIHRoZW0gaGF2ZSBhcnJpdmVkIGFmdGVyIDMuIEkgaGF2
ZSB0byBtZW50aW9uIA0KdGhhdCBJIGRpZG4ndCBpbXBsZW1lbnQgInJlc3luYyBsb2dpYyIuIEl0
IHdhcyBpbXBsZW1lbnRlZCBiZWZvcmUgYXMgDQp0aGVyZSBzaG91bGQgbmV2ZXIgYmUgT09PIGNx
ZXMgYWNjb3JkaW5nIHRvIHdoYXQgd2FzIHN0YXRlZCBpbiB0aGUgDQpwcmV2aW91cyB2ZXJzaW9u
cyBvZiBwYXRjaGVzIGJ5IHJldmlld2Vycy4gTXkgcGF0Y2hlcyBkbyBub3QgY2hhbmdlIA0KbG9n
aWMsIHRoZXkganVzdCBmaXggdGhlIGltcGxlbWVudGF0aW9uIHdoaWNoIGlzIGN1cnJlbnRseSBj
cmFzaGVzIHRoZSANCmtlcm5lbC4gT25jZSB0aGUgcm9vdCBjYXVzZSBpbiBGVyAod2hpY2ggaXMg
Y29tcGxldGVseSBjbG9zZWQgc291cmNlIGFuZCANCkkgY2FuIG9ubHkgZ3Vlc3Mgd2hhdCBsb2dp
YyBpcyBpbXBsZW1lbnRlZCBpbiBpdCkgaXMgZm91bmQgd2UgY2FuIA0KcmUtdGhpbmsgdGhlIGxv
Z2ljLiBCdXQgZm9yIG5vdyBJIGp1c3Qgd2FudCB0byBmaXggdGhlIGVhc3kgcmVwcm9kdWNpYmxl
IA0KY3Jhc2gsIGV2ZW4gaWYgdGhlIHBhdGNoIGlzICJiYW5kYWdlIi4NCg0KPiANCj4+DQo+Pg0K
Pj4+Pg0KPj4+PiBTb3JyeSBmb3IgdGhlIGxhdGUgdXBkYXRlIGJ1dCB0aGVzZSBuZXcgZmluZGlu
Z3MgYXJlIG9ubHkgZnJvbSB5ZXN0ZXJkYXkuDQo+Pj4+DQo+Pj4+IFRoYW5rcywNCj4+Pj4gU2Fl
ZWQuDQo+Pj4+DQo+Pj4+ICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+Pj4gRnJvbTogVmFkaW0gRmVkb3JlbmtvIDx2
YWRmZWRAbWV0YS5jb20+DQo+Pj4+IFNlbnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgOCwgMjAyMyA0
OjQwIEFNDQo+Pj4+IFRvOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz47IEpha3Vi
IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+Pj4+IENjOiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG52aWRpYS5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnIDxuZXRkZXZAdmdlci5rZXJu
ZWwub3JnPjsgVGFyaXEgVG91a2FuIDx0YXJpcXRAbnZpZGlhLmNvbT4NCj4+Pj4gU3ViamVjdDog
UmU6IFtwdWxsIHJlcXVlc3RdW25ldCAwMC8xMF0gbWx4NSBmaXhlcyAyMDIzLTAyLTA3DQo+Pj4+
ICAgIE9uIDA4LzAyLzIwMjMgMDM6MDIsIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPj4+Pj4gRnJv
bTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPg0KPj4+Pj4NCj4+Pj4+IFRoaXMg
c2VyaWVzIHByb3ZpZGVzIGJ1ZyBmaXhlcyB0byBtbHg1IGRyaXZlci4NCj4+Pj4+IFBsZWFzZSBw
dWxsIGFuZCBsZXQgbWUga25vdyBpZiB0aGVyZSBpcyBhbnkgcHJvYmxlbS4NCj4+Pj4+DQo+Pj4+
IFN0aWxsIG5vIHBhdGNoZXMgZm9yIFBUUCBxdWV1ZT8gVGhhdCdzIGEgYml0IHdpZXJkLg0KPj4+
PiBEbyB5b3UgdGhpbmsgdGhhdCB0aGV5IGFyZSBub3QgcmVhZHkgdG8gYmUgaW4gLW5ldD8NCj4+
PiAtLSBSYWh1bCBSYW1lc2hiYWJ1DQoNCg==
