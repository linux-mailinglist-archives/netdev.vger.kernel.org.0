Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A395A2C78
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245617AbiHZQlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245029AbiHZQlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:41:20 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CCA2D1E2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnO1a6poO3MLT+7dFGxmGCfx9CmhAbHGIfI26YoTg646l+OfMWEYzTqQwaiFQaN1ldDLiSTWwCEcp+fd2FKA8P7eeDRYenPbX2kWXsQjqPLtErjvd17btROMDeJrlEQlsrtisCnUgwP4g5irYitCjDIIaTNW4TcorK9mAhmRUrnRKmcGhxQ5ZX6LMbCIn7I05V1/1UVNfoD6PjUzgFtoJuoAzr7gAuEGPAUb04KWn8WZ1kV7FRJFaPzMyUkQGRAVh6gU5zoy+G7iaPkdtWoT8ZOiKgLX9AY5Z1gXMRQexDrD4qzmPpULs2prvvkyqUnWq2c8/HX3JHPPSDAa+z9h5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaE9PF8KLY/xsf0RS0KH8IxAh+6mV5nq7it517NM44Y=;
 b=gOhvShg1xe6GMalfQuW0Kw9mHTC62K3IyHfETkbLbR9WXiAf34QUt4/x1RRk/d7JmaD1i9ML5hKvqq0gvypqkpnv0n9mVHNbP3r/ZvIEVdGMLUJSVw1UuVZrqPdGeSTKaZeHHq1pggRqOHKqMd/2KiLNgTK0ilcoqzslo85vjrUICs+KTMlESAQN2SGxMCj19SHHIwG8WzVwQUZ6gb+QP64DobSkvfRgWkKa0AYn8+JHZd7Q/MtUVcHxZ/46xy8TNuAJfTUHCmZvrysKq2L3UR3ebE2GN00u8XX/I4a3L6EFHjGkXvYV4zUqwFIqRSu7sbNnmHmRgs0hQqYlzLoShw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaE9PF8KLY/xsf0RS0KH8IxAh+6mV5nq7it517NM44Y=;
 b=XiMuY5MCEOgrot53SoWHqvhaNejFOMFlZNgS+2cQuXIuIpf7+naNOFI/RBDwAE84AGrtHhsGzVSWqHnkPgPdkXtqEnvKsUZvC4K6+gcoEdHJSa1pIal6cl6aJqKN4IDoni2HGajsY6hFmcXd2ZamzE4l/C/WvIVm3RDCWeqc3/krWmDfRhirtsm5Q7BsHBUCuk01phSpvJMfDs90Gpc8ZtMXc3aT2ISl0RzrMYRAOnCdmCqi2/sZk0bJY/WNq7QuvY99C/BVhSX/EoLnACx6pHxDD3KLv0A2sV112bFnen05ItMUdC9ibVSWOXSuH06Vt5e0yugiMAlNuu7dCX1eEg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA1PR12MB6137.namprd12.prod.outlook.com (2603:10b6:208:3eb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 16:41:16 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%7]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 16:41:16 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>, Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "mst@redhat.com" <mst@redhat.com>
CC:     Gavi Teitz <gavi@nvidia.com>
Subject: RE: [virtio-dev] [PATCH RESEND v2 2/2] virtio-net: use mtu size as
 buffer length for big packets
Thread-Topic: [virtio-dev] [PATCH RESEND v2 2/2] virtio-net: use mtu size as
 buffer length for big packets
Thread-Index: AQHYuH+wBUa5TQ3am0iRtxWTyhCUA63A4UyAgACAwLA=
Date:   Fri, 26 Aug 2022 16:41:16 +0000
Message-ID: <PH0PR12MB5481BB5F85A7115A07FBC315DC759@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220825123840.20239-1-gavinl@nvidia.com>
 <20220825123840.20239-3-gavinl@nvidia.com>
 <27204c1c-1767-c968-0481-c052370875d8@oracle.com>
In-Reply-To: <27204c1c-1767-c968-0481-c052370875d8@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 669fd72e-f896-46f2-599c-08da8781cba1
x-ms-traffictypediagnostic: IA1PR12MB6137:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yxAox5ul7t12rnh0rrFu3ihxj9RFq+FBfn6Mtvfus/TauvWCtLbUhdjb/A9Dd0Q4lnL0S2o1gjsokJczqg/ZOCg3zcS9MbcJ5d29YcVPLinXrppc8lIelohy2+UsERbe9XzKZifcP+P+LZrGELdsJ5cQFhKBCB6Ly14pq570JvIm71b4lF4gZgHGSlKr6zoBv41aL49Dnm/iJNhlyxFiI04+6GcjyG44/y15UOqBSnjnsOPXnEfKsY0yBB/Tt8/CEbyJQBLwMzyZS5x8boIHfTa8x1dfZ2SIDvdajQqB4pK0vePUBfPqiSAPns/FukAKM+r0deVGS3T9BWxitUU9Hy6w4P4V4eNFzwmlB1gxujGWjN7ZJkaviXx4c/05AHLPlWz7bpX1Aqnq7UWmn0Zu/Mi6GUx1h929aUJVnPA2ex/9aKwzPgO/4pW13Cg/kZqiaiLNpjqGXkWtf2YaqaUc3LUXEIuZKIvRSRi++BxdyRWPatSnlkAApyCvE9clffDLBwaGr/EnaTeQuvuYoYo5DU4tU5LynVvyReN6qA7kuYpIKlRVwEr/JTnULwOMN2bxK/qVSMfjHUMfn/3j21FpR2JcWaOKL3vQIewiZvZWOnsvBCgimMKZiLU2MEAzWoEyCf8yJE1zIR/GuG9E4oT0t1AFnbAMEjCIu+xygSVaapz+zvS+JNcB6g7r7ow60gI98GjbJELvn0yreOS2fISwhsBL+sezpqmjfemosDVKHIhqRLoVt6oX2XeDyYuvp2iyLv2SrGqGSRtxH6CWCi8+CvO7U5SY+LdcoM0IWU9scJc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(4326008)(52536014)(316002)(8676002)(66946007)(64756008)(122000001)(110136005)(8936002)(66446008)(66556008)(55016003)(38100700002)(41300700001)(76116006)(71200400001)(5660300002)(478600001)(7416002)(66476007)(107886003)(26005)(7696005)(2906002)(186003)(6506007)(33656002)(83380400001)(86362001)(921005)(38070700005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TERzVm10OGtxa2FVMW1oRnJYS3g2WkM5MkIyY0E4cVJ4ZXk2V3NaZ1RWU2oy?=
 =?utf-8?B?OFR1bXNub3dTeTRKV3FRMGQrbGRURFV4YWh2VHVCb3RRMFh3T1dUelZkeWJN?=
 =?utf-8?B?UjJya0RhdEt2MTB4S0krSVY4WiszZkRjaEtGRUVnbjVCWmFIemszQkNlUzVZ?=
 =?utf-8?B?YUMrYzV2NXc3dDZ6RzhpUmVsSlZRcTZiZFZqUjEvcUFMd29JSUZSd1BNQUdp?=
 =?utf-8?B?M210TGZsNElSdVhydzYrQmlOUUtwdzNUZ201bHoyMXRQRnFJZlEyRm1BYk9R?=
 =?utf-8?B?VS9wZmN1NzUyd2lvVHZhRUZBOG9kNlRqT0czckNQVk0xQmNNYjR0aEVxVEZ1?=
 =?utf-8?B?ZmlMc04xSWlMWHowc3IvaHM1cjdYVkZnRkVZeWJSYkhiZVp4WDdzYnI5MnVP?=
 =?utf-8?B?djdheHRuYzNJNXZNY2E1b3ZsbGRwaEg5VjN6N3NvT1E3bFczZ3pqejFoWUty?=
 =?utf-8?B?cXkrQzV0cFlPc3dmN2tZRjhXbVpRWCtadVJveTJuOUQzN0tuVUcrUnl6TDNv?=
 =?utf-8?B?cmtkOVNwZjJReElKaE5SMjdyc2pQUWhxeWJHKzRmWklXYXVXa2w5cDNCZnkw?=
 =?utf-8?B?SWNJWmJPaGU5R2JmeEw2cGg5TTJTYmh2S2JuNXV5N2kybFB3bHpZQlF2WkZj?=
 =?utf-8?B?TDBNaEYyamtsaWsvcWRQQTRXSmgxSTRVNUpEYjM1NTljY1BtMU80OWl0L0lp?=
 =?utf-8?B?VjFFR0VJR3hTSnNwUG01OXZaWVRJVGtSMnBFN3BJREl5YVVZUDJEdEtGWDR3?=
 =?utf-8?B?QlJaVkNRMDVvNUJndCtrb1JJK25jeXBoOU9Bd0J1WGZpZElZMzNXM1RsNHcv?=
 =?utf-8?B?VSt6SnpwUGpTUWtYRHlaME1pam9ER0MvQkp1OWJ1WG10NUVTMVkrTEpqQTN5?=
 =?utf-8?B?a09TcDVXd1BIVk45WmtHa3FIOVFLWk5mcUd5anN6eFR3aGxZRkNQay8xY0xq?=
 =?utf-8?B?SGd3ZG56SHpFVkRaS1JLelFtUTFwSll5ZWtFZkhTOTh4WVluS2ZwNllQNURr?=
 =?utf-8?B?R3J6RjdRcFJqMmF0NFRzNGUveUNJL1ZWVGZtQ2dnYi9MV2ZYbWlIcVg5T3lv?=
 =?utf-8?B?dGl3c0dwZFNpQS9QOUpkNkFtSFlYR3QrMldiNS9GTkZsY3F0bXBuN0RhUDY3?=
 =?utf-8?B?cUhCNS9rN0dVNEhKYWE2RXNaWGZuYkNRc3BFV3M5K2tBaTZwUlJvRUZiSlJP?=
 =?utf-8?B?ZkQxbzlPR040a3JoUFAyYWNzaE5wUVdHdWRJR2hmSmRlOXdqS0xVei91RkhN?=
 =?utf-8?B?WmVGdzdWb0h4aFl0TW5EWFFSWGVBemVSZXRIUGFIRkcyRW9XUlJqdTRpcjl1?=
 =?utf-8?B?ejBRZXNMTGZVd2h6dUI0dG9peVpod3Z3ZldpZi9ZZTNGT3RPNk9NdU9tVGt3?=
 =?utf-8?B?Z011emhUT2Mzem1XdkcvUGtZeFgvaEhCb2UxWG9LRDc1eXk0cnpqSE9CZzZU?=
 =?utf-8?B?RnhkTVlHaXdET3JIM1Vna0o2bHVGWXpsMkZtUlVTRG1OV3Nad3UvZVBOd2Q2?=
 =?utf-8?B?MGs5M29wVGtWZ3ZxZXZicnpzNXMyRWN0M2NHVi9Ld3J5U282M2xNVkdMS3py?=
 =?utf-8?B?ZFJGQnpvVzl6TXB1UWg2c1RuTUh5Wm8zdlNlVnlqMXh6MlR1SlZzQjlrL0dE?=
 =?utf-8?B?ang0NmRJQ2ltS2R3aEdPM3hJb2hsQVlPTHhldU1xMngxR1NLV0FQU3NDWkoz?=
 =?utf-8?B?MThqR2pBYmJ6RjdSeFVLc1UrOXdQYXRIOWg4N0dLcWVCNmo5Y2ZlcVlVd0FR?=
 =?utf-8?B?YlJTZnJqUGN2ZGx1RyttWWVnWG15UVVVWFBlL2dMWUpkdUpYa1E4VUZjSThR?=
 =?utf-8?B?SnZEc21Wb1pxamx0YXcyVktrMTZIclhqRmJ4N0dqeGl4RWh1MXBCYVEydnhr?=
 =?utf-8?B?cnQvb3YzU2dVZW1LVjhHeEdOU1lVQTdBanE4cjkwWmMyVEpxWk4yUHlYRDc4?=
 =?utf-8?B?TlVMYnpRUExKOEtWZmpmYi9WL2pJVTlybWNJKzdsT2VNYTkzNGxER09lWDV2?=
 =?utf-8?B?V29XVzRTY0V1S2I1cjRnVURkRnhCVGwySkVNVVpreTkwZEF5N3hpTkpzQjU3?=
 =?utf-8?B?RDRZZW9Ma2RJOHg4UU81enlZOFFzZmRHM2JmRlZsTTZES2pSUlFhVFRFT2xC?=
 =?utf-8?Q?6QYI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669fd72e-f896-46f2-599c-08da8781cba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 16:41:16.2914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X/HdEY2aoZmO/MvUzwCBlSh49uI5agauP18IpdZ40GLVez5u9q6jklNrbkby4kvN3ApKHgnFtPo2MSZsBIO/7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6137
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CQ0KDQpGcm9tOiBTaS1XZWkgTGl1IDxzaS13ZWkubGl1QG9yYWNsZS5jb20+IA0KU2VudDogRnJp
ZGF5LCBBdWd1c3QgMjYsIDIwMjIgNDo1MiBBTQ0KDQo+IFNvcnJ5IGZvciB0aGUgZGVsYXkuIERp
ZG4ndCBub3RpY2UgYXMgdGhpcyB0aHJlYWQgd2FzIG5vdCBhZGRyZXNzZWQgdG8gbXkgd29yayBl
bWFpbC4gUGxlYXNlIGNvcHkgdG8gbXkgd29yayBlbWFpbCBpZiBpdCBuZWVkcyBteSBpbW1lZGlh
dGUgYXR0ZW50aW9uLg0KDQpDYW4geW91IHBsZWFzZSBzZXR1cCB5b3VyIG1haWwgY2xpZW50IHRv
IHBvc3QgcGxhaW4gdGV4dCBtYWlsIGFzIHJlcXVpcmVkIGJ5IG1haWxpbmcgbGlzdC4NCkNvbnZl
cnNhdGlvbiB3aXRob3V0IGl0IGlzIGNsb3NlIHRvIGltcG9zc2libGUgdG8gdHJhY2suDQorCS8q
IElmIHdlIGNhbiByZWNlaXZlIEFOWSBHU08gcGFja2V0cywgd2UgbXVzdCBhbGxvY2F0ZSBsYXJn
ZSBvbmVzLiAqLw0KKwlpZiAobXR1ID4gRVRIX0RBVEFfTEVOIHx8IGd1ZXN0X2dzbykgew0KKwkJ
dmktPmJpZ19wYWNrZXRzID0gdHJ1ZTsNCisJCS8qIGlmIHRoZSBndWVzdCBvZmZsb2FkIGlzIG9m
ZmVyZWQgYnkgdGhlIGRldmljZSwgdXNlciBjYW4gbW9kaWZ5DQorCQkgKiBvZmZsb2FkIGNhcGFi
aWxpdHkuIEluIHN1Y2ggcG9zdGVkIGJ1ZmZlcnMgbWF5IHNob3J0IGZhbGwgb2Ygc2l6ZS4NCisJ
CSAqIEhlbmNlIGFsbG9jYXRlIGZvciBtYXggc2l6ZS4NCisJCSAqLw0KKwkJaWYgKHZpcnRpb19o
YXNfZmVhdHVyZSh2aS0+dmRldiwgVklSVElPX05FVF9GX0NUUkxfR1VFU1RfT0ZGTE9BRFMpKQ0K
KwkJCXZpLT5iaWdfcGFja2V0c19zZ19udW0gPSBNQVhfU0tCX0ZSQUdTOw0KPiBNQVhfU0tCX0ZS
QUdTIGlzIG5lZWRlZCB3aGVuIGFueSBvZiB0aGUgZ3Vlc3RfZ3NvIGNhcGFiaWxpdHkgaXMgb2Zm
ZXJlZC4gVGhpcyBpcyBwZXIgc3BlYyByZWdhcmRsZXNzIGlmIFZJUlRJT19ORVRfRl9DVFJMX0dV
RVNUX09GRkxPQURTIGlzIG5lZ290aWF0ZWQgb3Igbm90LiBRdW90aW5nIHNwZWM6DQoNCg0KPiBJ
ZiBWSVJUSU9fTkVUX0ZfTVJHX1JYQlVGIGlzIG5vdCBuZWdvdGlhdGVkOiANCj4gSWYgVklSVElP
X05FVF9GX0dVRVNUX1RTTzQsIFZJUlRJT19ORVRfRl9HVUVTVF9UU082IG9yIFZJUlRJT19ORVRf
Rl9HVUVTVF9VRk8gYXJlIG5lZ290aWF0ZWQsIHRoZSBkcml2ZXIgU0hPVUxEIHBvcHVsYXRlIHRo
ZSByZWNlaXZlIHF1ZXVlKHMpIHdpdGggYnVmZmVycyBvZiBhdCBsZWFzdCA2NTU2MiBieXRlcy4N
Cg0KU3BlYyByZWNvbW1lbmRhdGlvbiBpcyBnb29kIGhlcmUsIGJ1dCBMaW51eCBkcml2ZXIga25v
d3MgdGhhdCBzdWNoIG9mZmxvYWQgc2V0dGluZ3MgY2Fubm90IGNoYW5nZSBpZiB0aGUgYWJvdmUg
ZmVhdHVyZSBpcyBub3Qgb2ZmZXJlZC4NClNvIEkgdGhpbmsgd2Ugc2hvdWxkIGFkZCB0aGUgY29t
bWVudCBhbmQgcmVmZXJlbmNlIHRvIHRoZSBjb2RlIHRvIGhhdmUgdGhpcyBvcHRpbWl6YXRpb24u
DQo=
