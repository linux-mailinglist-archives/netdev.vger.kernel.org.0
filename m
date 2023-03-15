Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28846BA537
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 03:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCOC1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 22:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCOC1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 22:27:21 -0400
Received: from MW2PR02CU002-vft-obe.outbound.protection.outlook.com (mail-westus2azon11013004.outbound.protection.outlook.com [52.101.49.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4932E62;
        Tue, 14 Mar 2023 19:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qsew+86LuBH9MI4dDlCpYfxudanuvxNniHHoO+yzjoqfdssEvtbMSPFt9OF8c75DDplZrol9Vs9OYWEwlIcIxYU4Mgd+sWQg0ObgU59tmNjoy6DNxzubtMdP0UcWaO8zHhpDrQ6bYDeDeJb6HPG/RCu/0wQdtl5G6YFF+OdsPpFInodmIjn7wyGcAhgy+3djElmdzCb6ZOCM5cVkqlzQj2y2Q2in9XNjMWRqo6mElCH25hBVmWn7AM2Z7SYkT2zCLiLjuqjOao8ijBfWh5KuWMptnupw+CpIVX03yTESRGRT30oVn5q4WXQsi1c92xy3ZkBUHTO87HeIkdhUYwzflA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diqpbXOV1IuYnnnURMkaKZfehaMunxjl0a+vmlQXKas=;
 b=mdoE5gYaoXycZLFUbFruiKVKWiVyK7+AbzhLKykS9KLJPtZ04ZvstWiPXyWY1BUJPmCP6oIExkJfnFsxnSbN7+0VPtqRxgqsafvbS8JjOU8ud6MASaVWOpS6dZyvVeumeYFqpnW/AiT99OW34NdwK4zNPdv4ZuNdg9tKuWIiZj8cT7GykFgG6m/wdid/ncoMEUVe4ee3cXPi9iBfvQ2t7bjvdp3MbhyI3caydo1NGOoRs7oZc03ctm+9dbQzSCNOyjHNGD1YCcHl1QXcl9Y5/aJ+013TyRetSQqh9uhAAr5odRnY+Fha0C1BMikVCOQ9hjHV4XXXF5Qs0Xfk8VQgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diqpbXOV1IuYnnnURMkaKZfehaMunxjl0a+vmlQXKas=;
 b=Odz+hSTWWMEDe6pYMioKwNLIB2ZekxxQpz2kaCQYQU0kKFljAOtGoEO8kdOzNF5Qz4XD3G3QX2XuMgppHBPT/rQXkS4cvSka5QWzfxeKi6LI+tY/kvM9HBDRbWG/J+YISs5hxcBl64+cQz8kBsdKxkQrzV9z6OGfpgdgG6GsRmA=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by DM6PR05MB6444.namprd05.prod.outlook.com (2603:10b6:5:128::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 02:27:14 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 02:27:14 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQCAAKsUgIAHJTAAgADERoD//5SOgA==
Date:   Wed, 15 Mar 2023 02:27:14 +0000
Message-ID: <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
In-Reply-To: <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|DM6PR05MB6444:EE_
x-ms-office365-filtering-correlation-id: 80341da0-c9b9-429c-5374-08db24fcca40
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kqHgwgqDEgXJc9uS9R8ItvsXnrPuD98tqlPWF2YoKWrrG8GivbqxJpJJg2k96YRXrnJJdL8rr5TXICIYStxtBktKSk8Sx2jvN6e/UzsI9nxox8LuJcrgW/MiuxtaS14aSI5STOSFeNwZKu3OSyr0/wr8LeBJqhwnULz89rltwjFkSKf/6avEdqq9/dttYw7MOpkN7yig/o44eFoC98968wJ1RoW7XtcaA7GtY4Gf9X77fmtYnFTH1Evgr3Y2LC0yA72G40mnF8YUn+bIJCwLK3SImRA6ASqhT8WYYrN1clgEuBGm8V0Zg3lZgYApMXluq+c2dmLgYt2wVuNHhMVsiGWfZQ4MSKa3VLvoPwdqol/kaG9Cy3zLKIsvNBiNKm3wuglFActu5wQLJMvG4b/7j2A4+Ij7i+mHTGhEz5me2QX5KpQpXH4UN7GDlApD9KxBZbHyrzoeMsGvUsKPdUl86Ma13BQ2gx2Wm3R8CB3lB4CGCYnehBg7aDgex1+JP6uN7HLsUh8Usi0vgtEITFNhdDhnawZStcvgEpFnNnqwUyd9sbTYWutg+0pFvwdGs+YpZmX8VlMLChhjwGuHgol4BpTHnFh12wjjcpIwlUYEsQ5lvAcLUjyU4YQMlQGHR2t/a57Boau1QlkmjtydyUftC1manOHwyLBaQlO8umKpND1ASQMeB6qRkx2i1zH89Tn93FkvRPL8sZhOebn2Q1r4D2dNnB3S8sc3MK6NW3NxG7c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199018)(36756003)(38070700005)(86362001)(33656002)(38100700002)(122000001)(2906002)(41300700001)(8936002)(5660300002)(4326008)(2616005)(110136005)(8676002)(53546011)(6512007)(6506007)(26005)(186003)(83380400001)(316002)(54906003)(66446008)(76116006)(66556008)(66476007)(64756008)(6486002)(71200400001)(478600001)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blBvaVRJVitOSkNjNnZRYnFuOFBzOWJMWTFDUHg1TmJta3hUM3VWbnNYN0Yx?=
 =?utf-8?B?OEFpd3RnUVdqUXJBbzJHcDFjbzJMQ01obkJOWUhVYmd5ZmkyV3BzQVZXZEpy?=
 =?utf-8?B?eFl6eHNpVnViTFo4MlQ4UHdBSDIvM0hPOHhBUTg5SGhWZDhITEl2RjZtdFdK?=
 =?utf-8?B?Qm8zMFFWN3lxY3NucTh1MGo4TnVTMTBOa1VoNFdUWjJNaCtQRmpwUFpDczlz?=
 =?utf-8?B?Q2hVRkc0MU9meXlHOHB5alJJUnArMFZ4ZDJLWURWRW80ZGNTb1A2Qk0xSmlP?=
 =?utf-8?B?cGg5K09qWlVDeHB2NE51ZWg5SHRqTTZNM1hJWS9hbWxrRXV2Z3ZJbUw4YVBO?=
 =?utf-8?B?UUE2VmpqR2ptekJjVWg5bERaZitISGlaWkplbXhiTWVBbkVLUVRsMFlUZVBK?=
 =?utf-8?B?M01hM3dabFdyQzJLa3NVcFd6WUJjcFFBV0QrUHQ5OGZPUWdqWGd0MFkxNFhN?=
 =?utf-8?B?RUhaQXYyRUpiaTk2M1lDLzFBRW85TjdSd2daZUhxSG1Vc0U0QmxjdGlIR25U?=
 =?utf-8?B?aGxZaXFFaE1JT05JZmxlNmNkVlBTdWd0YVo0Q0NGb1FOSGxkbmV6NWZ5OHdJ?=
 =?utf-8?B?djlTQlpWUzlMZzJnOXpIOXVDRmtJVitGaFR6NFhiYkdpbWxoUitJNk9PNFVj?=
 =?utf-8?B?eTdKSUhVbjI1eXhLOENnMHgrSTRUMmFFN3FhbkJudjRCQzZWUGF6bDkrT05n?=
 =?utf-8?B?VkcxdGt4bXRWQ083aExtdC9Kd3loekdIMndLUk1EQW44TkZHMzF4TjZFODNB?=
 =?utf-8?B?UXA1UmJDNHdBTWgyMXlXRkNWaXR2cTM5K0g0K2RjVE9TWGZQNEViZ0I0VW92?=
 =?utf-8?B?U0tzV3ppQnlVdUI1WkMydmVUbCtKMDBJdjF4OXlxZ2RUcnpLemdGWVN6MG1Q?=
 =?utf-8?B?REMxS1JLelNOMkY0SzJlYzNDcmJwTG9ldUFtaU5TZkpNSGVJdjdqM2NNVXlm?=
 =?utf-8?B?SGFNT1Z3Sldtem05RzExM2hZQW0zMHdrOStOL2N4TURaYTR2eE5GZHpHMmIz?=
 =?utf-8?B?dHRUMWNMOVVrRis0enY3MVhmckt4WWIwS1RtK1I3MDduZFJMeGZWa1E5cmdH?=
 =?utf-8?B?Q1ByYXV2WjNPQmZmTVNmZGVQRTFIem1OWXNEajVXdEoxSkRxUU5CazAwRi9z?=
 =?utf-8?B?dWRmSXVEUTdIOVhXOUFNVW5kekw4S2h2c3o1djI0Mlhva0loZW9RZ3FNS01p?=
 =?utf-8?B?R2tRQXYyQnRxYjRxRDNhZC82ZlBzSi95d00wRDIxclBVSk41TVpLVVhSUzhD?=
 =?utf-8?B?RHZHaVZVSG9HSnpHZVNvVSt3K3hpelNpdmdNYitnM1FBUkJRWkFKWXpDdXpL?=
 =?utf-8?B?L25kUit3Qm42cmMrMS92WkNsd0JJS1l4TGc3MDVQSWlXaTZubXFhbUZYd25i?=
 =?utf-8?B?MmxWYW1JODlIN3FNWWVnem9saWY5bE85RFJmaE9Eb1lEd3RSQW53S0wwdys3?=
 =?utf-8?B?M0t0MS9ZVHYydmZkWlo3UVZlRXQyN2NzOFVBRzhDQ0xrd2cvcVJsSFhySU1Y?=
 =?utf-8?B?eUFITmF3KzdCNi8wRjJaTlBSVCtudXVFUExPNTFCMjRzdzNXaW9qL290Wi90?=
 =?utf-8?B?Z3BXSjMxb0Vnb2lNa1M0c1YvanU0YmpDcXJNSnNqNW1DbmRlMmdHQUZBMEtz?=
 =?utf-8?B?alVxNUs3ZmNreVYwU1RORElXWjZyNUdMZXhUSW1FY3dCeGRrMDI0bzJIYmt4?=
 =?utf-8?B?QWh6RHY1TjhyYndMbUhOdythN085a0YrTGJhM0dDRHpYclV0Y2dnM1RCcmc0?=
 =?utf-8?B?dXZBREM5WTV5Y1BlUWJTdURtczFMWjNCMzRpcVFUN1I1eDVoUkpBM2hGS0V4?=
 =?utf-8?B?dE9zcm5aMlkxS0Zpdm1RelJmTmw2dWRmY2tQZ1dIZXZhY2p1RUM0SzZXS1Uz?=
 =?utf-8?B?ZDJYWjlmeEx0WGp3U2t6Y3VZN2RyMW1paENvbURHMGpYV1FJTWFnRHpuNk9E?=
 =?utf-8?B?UnVsYWEwMVFRalFsUTFxN09UVWNZaDR1ODBpem15aFJHeGVBOXU2MFhyZEtS?=
 =?utf-8?B?Q2ZBNWtzdHBRNTh4N1BjTWh5UjlGZHYxZ1hUTUN1NGErYXlhWTlDNW5aWUF6?=
 =?utf-8?B?azlmSWFZaVhVaXJoT3VzMVVTcGduOS9ad2F5RE9wdzI2OExXNTNPMmMydjhh?=
 =?utf-8?Q?WRUa+aSxBUQraTLe8hGMaEUIw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09699532C0D8BF4B911FD15F13B93F2A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80341da0-c9b9-429c-5374-08db24fcca40
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 02:27:14.6316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: trDe4lo6TamFtFE+hMt2SLUsl9VSXV42UpvFMTe8fHGf6LDM5IgHD9ej2J9h70OcvNv3Vqbd9xqPfLtqTy11Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIDMvMTQvMjMsIDY6NTIgUE0sICJZdW5zaGVuZyBMaW4iIDxsaW55dW5zaGVuZ0BodWF3
ZWkuY29tIDxtYWlsdG86bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4+IHdyb3RlOg0KPg0KPiBEb2Vz
IGNsZWFyaW5nIHRoZSBORVRJRl9GX0dSTyBmb3IgbmV0ZGV2LT5mZWF0dXJlcyBicmluZyBiYWNr
IHRoZSBwZXJmb3JtYW5jZT8NCj4gSWYgbm8sIG1heWJlIHRoZXJlIGlzIHNvbWV0aGluZyBuZWVk
IGludmVzdGlnYXRpbmcuDQoNClllcywgaXQgZG9lcy4gU2ltcGx5IHVzaW5nIG5ldGlmX3JlY2Vp
dmVfc2tiIHdvcmtzIGZpbmUuDQoNCj4gQ2hlY2tpbmcgcnEtPnNoYXJlZC0+dXBkYXRlUnhQcm9k
IGluIHRoZSBkcml2ZXIgdG8gZGVjaWRlIGlmIGdybyBpcyBhbGxvdyBkb2VzIG5vdCBzZWVtcyBy
aWdodCB0bw0KPiBtZSwgYXMgdGhlIG5ldHN0YWNrIGhhcyB1c2VkIHRoZSBORVRJRl9GX0dSTyBj
aGVja2luZyBpbiBuZXRpZl9lbGlkZV9ncm8oKS4NCj4NCnVwZGF0ZVJ4UHJvZCBpcyBOT1QgYmVp
bmcgdXNlZCB0byBkZXRlcm1pbmUgaWYgR1JPIGlzIGFsbG93ZWQuIEl0IGlzIGJlaW5nIHVzZWQg
dG8gaW5kaWNhdGUgVVBUIGlzDQphY3RpdmUsIHNvIHRoZSBkcml2ZXIgc2hvdWxkIGp1c3QgdXNl
IEdSTyBjYWxsYmFjay4gVGhpcyBpcyBhcyBnb29kIGFzIGhhdmluZyBvbmx5IEdSTyBjYWxsYmFj
ayBmb3IgVVBUIGRyaXZlcg0Kd2hpY2ggeW91IHdlcmUgc3VnZ2VzdGluZyBlYXJsaWVyLg0KDQo+
IERvZXMgY2xlYXJpbmcgTkVUSUZfRl9HUk8gZm9yIG5ldGRldi0+ZmVhdHVyZXMgZHVyaW5nIHRo
ZSBkcml2ZXIgaW5pdCBwcm9jZXNzIHdvcmtzIGZvciB5b3VyDQo+IGNhc2U/DQoNCk5vIHRoaXMg
ZG9lcyBub3Qgd29yayBhcyBVUFQgbW9kZSBjYW4gYmUgZW5hYmxlZC9kaXNhYmxlZCBhdCBydW50
aW1lIHdpdGhvdXQgZ3Vlc3QgYmVpbmcgaW5mb3JtZWQuDQpUaGlzIGlzIHBhcmEtdmlydHVhbGl6
ZWQgZHJpdmVyIGFuZCBkb2VzIG5vdCBrbm93IGlmIHRoZSBndWVzdCBpcyBiZWluZyBydW4gaW4g
ZW11bGF0aW9uIG9yIFVQVC4NCg0KPiBBcyBuZXRkZXYtPmh3X2ZlYXR1cmVzIGlzIGZvciB0aGUg
ZHJpdmVyIHRvIGFkdmVydGlzZSB0aGUgaHcncyBjYXBhYmlsaXR5LCBhbmQgdGhlIGRyaXZlcg0K
PiBjYW4gZW5hYmxlL2Rpc2FibGUgc3BlY2lmaWMgY2FwYWJpbGl0eSBieSBzZXR0aW5nIG5ldGRl
di0+ZmVhdHVyZXMgZHVyaW5nIHRoZSBkcml2ZXIgaW5pdA0KPiBwcm9jZXNzLCBhbmQgdXNlciBj
YW4gZ2V0IHRvIGVuYWJsZS9kaXNhYmxlIHNwZWNpZmljIGNhcGFiaWxpdHkgdXNpbmcgZXRodG9v
bCBsYXRlciBpZiB1c2VyDQo+IG5lZWQgdG8uDQoNCkFzIEkgbWVudGlvbmVkIGFib3ZlLCBndWVz
dCBpcyBub3QgaW5mb3JtZWQgYXQgcnVudGltZSBhYm91dCBVUFQgc3RhdHVzLiBTbywgd2UgbmVl
ZCB0aGlzDQptZWNoYW5pc20gdG8gYXZvaWQgcGVyZm9ybWFuY2UgcGVuYWx0eS4NCg0KVGhhbmtz
LA0KUm9uYWsNCg0KDQoNCg==
