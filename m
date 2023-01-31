Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7507B683336
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjAaRBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjAaRBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:01:11 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021023.outbound.protection.outlook.com [52.101.62.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C3D2BEF0;
        Tue, 31 Jan 2023 09:01:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1+inASAQqLaZP6jqc6L/uW8iPAcyNuLNG8bBOKPzPCEI8kY4OpizI48T4z+rqcDZt50BMXrMaItE9CCdfJMNFUyfCfp/R9ruS3qf43MxWU+JfBrhQlpGhW8ONnZrHCIm5sE89IFELbuBGWux9jVXUoTMKLWRDBDC7qnPd9ko/ka4eY2ThOjMMvEJ53/c3ZP+1TB+EztlCLQkBMR8gcj4IZjryz3XZVh5qFXUcAJVf/MKzfK6p84nLQkhC4JMORO2G5KzM0xTS9tjAuFkvd/RirFLgIXhvOQZigE29XtLZehv0NEYUZ7JGbE/tpSwunKbqLVUh/1kKAIcT7xCAB95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygEJRDeJN1KLxRhpcr/8ocUgxJ6jQyuXaIDbMr6Cb6A=;
 b=ja2j4wQYUFbOalihvAraTOdldrZduD3WuiYsz0oVgQWD2JmtZ0N/TKD6GI5q9z1vAJinkfpiSlKNtXog0juPQmFd0rU+qZuYGbjtc3meGv4LWZgFqRRB+F7Cj2MAltBU1p0izud3kKXLkeGk74pqLgCQGKuwrf0eBNkwBPtic9qyKouISjjmQfHzFbex4QLU87T2o5aGv+PfnCYFDfzW64zhaycHaRnlH9gyfAmO7e9uAWbDkNgxU7Y3JdHHO/VU8BheNUKlGwwlPXZtSKuRwkPe+dxjRHs2OB5H9Ba8vejkV0e2sV5iAhi38Ndi8WSJ46Xf9I1TKTGVdb2+P4ysqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygEJRDeJN1KLxRhpcr/8ocUgxJ6jQyuXaIDbMr6Cb6A=;
 b=hCewMH066K0+EuEmqTzHIhf0isvbOtSuDzyeAetOlzzKXQ59/OdZInmX5Pz/Hq6RBFw16/C5Yr+4c83S28nOgo67CwM8MgBdg3+aWD4k4n8/jtQcVKpdazSmLmxdDfwZderptU4yUmT+3V61UFRzzVxIvla73lYmPV3/d5FzEt8=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DS7PR21MB3454.namprd21.prod.outlook.com (2603:10b6:8:91::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.19; Tue, 31 Jan 2023 17:01:05 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%3]) with mapi id 15.20.6086.004; Tue, 31 Jan 2023
 17:01:04 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Thread-Topic: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Thread-Index: AQHZNSTmxoKaNnr7HE21/oDPKHZJrq64wDlQ
Date:   Tue, 31 Jan 2023 17:01:04 +0000
Message-ID: <PH7PR21MB311633C0D952FF9BBF51E345CAD09@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ea553a18-c352-45dc-909c-37e8185f49c2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-31T16:58:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DS7PR21MB3454:EE_
x-ms-office365-filtering-correlation-id: f7e4f917-6808-4bee-8306-08db03acbd44
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ceGp8avUgqIi25y9i/+FpgJ53+gCQgVYGJjDLNrV+bJT1ZcoG8BmqI0LUdK/ucXmrKsUUhvZFBoTK2uRXg1QghMzGhAJRNNgJ9XLkTuBghkZNnJMkJ/9IgjP1g21fgElzMwGyr3NkMmJPQfBq39cJukPRgpWF7URJJu5cFcOGyz4gzVO5UzOL9K66SjphomPkv8ePn+0eDkxew7FMgDmiStEwQKbxcuIREHinigaWc+Bnrbv45lCh9utV5robAPnUF52HlShAIyOyC+RD1e2bI0azEDCSUK8npzG0vXvJ1FnXAQ/wsR6Iae/VjnBFE20ruW6/rwk2JRlq9f5bS4A0AB61PyMAyZxw5D3lBN17F1mmYmh0ajMisr8DFekm4sZIcKMPXFsNF/hQwVIwzJTgzBnr1eMSkSSC4y0e+nPFsdbrAgO+15N/ApEnisLTaXAAvdOzd79mygMQNs4YuzmsTqJYsoQgP+LJqo1vuKoIIkmLSNwS+GJ6CHkvNUvJpBLKJ8uiCDOyIdFa4uThIAW56FKcU5NjVulrwJ3xrZWXvt/ExSN3qazf2Nv7SCQFGhVuHtCLSCWZqxSyWvIc0Z1UnSQClM5NoOn4m95B68uR4FjaNfJaO1m/4of5axNwg6EFRFoLCvGwFQA7YVlefOrGjqNgyJdmVYBoQK8S84+uXAuTa41lbyPc4CU2H1l0Zy160I3JxN+CZIlJe6EMW88wjQMkeyFXe/IGEb3aFvEebinJjcbCJmtXJuJYQ7MvS4EAo5V6QCXsKclqa3Dbr1QxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199018)(2906002)(52536014)(8936002)(5660300002)(186003)(83380400001)(55016003)(86362001)(41300700001)(53546011)(66446008)(6506007)(33656002)(66946007)(66476007)(110136005)(64756008)(76116006)(8676002)(4326008)(478600001)(66556008)(8990500004)(26005)(9686003)(71200400001)(7696005)(82950400001)(82960400001)(38070700005)(316002)(10290500003)(38100700002)(921005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1ZRN1lVdnE4UGFCcDloVXF0UU5XOXJhanFZT0VLZ1JmVXc1a3ZvWElmZnVz?=
 =?utf-8?B?dm43T1d5bVVMVmhUd1Joc1o3OEJ6YmVxb1BOWHY0TE5xalk1dit2cFVxdFNG?=
 =?utf-8?B?SWE1Q1J0L1dSV1ZEY1J2b1JEWTFIYm9TTlY5cG9rZ2ZudEYxVmZCNHc4cVc3?=
 =?utf-8?B?WStrU0xHdjRTWGtlNUdNSGlQZHN3NmpzOGJLUVYyQmVDNVhvSGNrQ2RYeko1?=
 =?utf-8?B?cFpMTUJZTVl1L3N1Sy91ZkI1WFNMdjZoZjZjeFBjUFE1WmhrQWU2TmIvZHFz?=
 =?utf-8?B?Mnp6Nnl2VlcyUXlDcWtoNkpncW1oZXgrZVV6S3RTSEt0ZEtQcFBBdkFqdVFZ?=
 =?utf-8?B?QmgyUDY1YmsyYkE2TkpFaUFxeXVqOS9kSDFTL1daWDlacE0vUXcwMGdYQ0ZO?=
 =?utf-8?B?dnYvSXNMQ2oyMWxqYmpSM1BuZE5aNGtZK1Q2ZkF3WE9XaFg3bUx0SGEzUTQx?=
 =?utf-8?B?RWhKT2FjcUdPRDlhVEs0dDU1aTBRVjFEeWNIQjdzRTRhSFpMd1JlYVY3cW1X?=
 =?utf-8?B?M2U0ME5vSWliTHFRWUlkWkdXeUppK1o2dVJTTzZ5MDJSTFRzWXN2N0F5NVRY?=
 =?utf-8?B?L05abHFvSTBOc3d1SGREUE5ScklzeVVMOTVyTEorMUVJd1Y4NGU3ajNOalV2?=
 =?utf-8?B?dUc4ZDJWQ2MvVFMwWlBrSDZONWZET3N5N1RLVkV2VHpjV3RuNTVqUzZuMHpw?=
 =?utf-8?B?UjB5RGtvWXlRWmRJWUNvVmNCbHdYMm1jN251U0hTd3Y3L00yUzd5WS9iOXY1?=
 =?utf-8?B?ZSsvUjJXeURRcjV3d0o0TEVIMXRUNzAxRTVnTENaRFYvaWtwdmk3eHppNEdQ?=
 =?utf-8?B?WnZMakY3ajYwUGdCdVBKK3pYSEEzL2dsOWIzVUNQOUJqd282b1l0RW5FeGQ3?=
 =?utf-8?B?bEkyZ2srVXFoVFJ6ZmNFY1FYV2tvelBNVjVZT2dKN0txYllaaGhFc2o5bGw1?=
 =?utf-8?B?MlBPSUVSR05tRjV5RCtmTk1HdW1HcjBvV0pIeVhIMk1QeGFuY1VJaUpIbm9B?=
 =?utf-8?B?Mm1RMG9tSy9CVjBrYlltcDAvOENmN3dFNzVMcUtUa09Lczl4ZGp6ZXBhQmpn?=
 =?utf-8?B?YUVSc1B4cjRMb0Jid2NiUHdMd3dPaHR0NjVOYldPeGJISjFNN1dENURiekhR?=
 =?utf-8?B?NVFyRU5ZdDVDY3VhaEh1bFpyeDB5SkxGQ2xhYUd2MEE4aWJQR00yVkwzTnBr?=
 =?utf-8?B?Q3B2bzFJUW9MYmFUeXQ2ZDlqeFNHL1VVV0JlNlJZS0RNYmpMK0laczlxUmxH?=
 =?utf-8?B?eFBVaitENWV0cm1Pc3BqVVhjR2UweFltTU83T0RWV0UySkRJREdsbitJYld0?=
 =?utf-8?B?eE5XVVZMWnhxQzJES3BKODg2dHBlM3ZpQXBZRzlKdTk3RVQzZjM5V01KWGox?=
 =?utf-8?B?Q2FGTVZDOFFCbkVwNkhrVWdETHpJNFN4KzNmd29IM3JmazFnaHBsRUp3cVYw?=
 =?utf-8?B?cXJTUElHcnEwamZTL2UwRE9oeWw3SEhVOFFKV3FJR20xNUhTL0tpMktXaVlN?=
 =?utf-8?B?VHorWitCZEU5dWVzMGJkakVXZ1U4cnFVVkZ4S01scUEvUFZvQWRhbitFUWNa?=
 =?utf-8?B?MGlqYlhJRDg1M01teUdTTkF6L0plWlQzU3ArUTdYcDBYNGxlS0JRTWpOL2Zx?=
 =?utf-8?B?NzNHbk91QkNvbG5ya0Q4aU5EdVF6YkVUdElUc0VMaEc1YUhxSFBQeG9meDd1?=
 =?utf-8?B?NjNQOXFKYlJEU1pibzVwRS8rZ01oKzZaOXJOSjRZL3YxV2c0UVpoRnA1dUZM?=
 =?utf-8?B?QWxkei85dkNBRENRS1BNaWYvZ1VXeU1RbnR1elB4ZXZob0hQdlFIa3hFamlZ?=
 =?utf-8?B?VzUvUSs2ME8wZnVPS2R6Y3NlamRhMWhKcmk5ODVaZGkxekhpN1hWL3JoRW5r?=
 =?utf-8?B?Z2FBU25lYTBUbXdhaDhVeGthTE1xY3dhU1hwN2g3MUJEY0V3dHozaitsVTlm?=
 =?utf-8?B?RC9EdEFuZlZxVjJUR3lSdW9GZXp5UStKRThHRHRSUGtzVkx1ZGlEQUxNbUR5?=
 =?utf-8?B?c0pnc0Qxb2p3b1Q1OFcyam1YT2FUbVlJVFhiejI1R1EyQ282Z2tNOFk0S2tK?=
 =?utf-8?B?SWEzYUhpVzR6RXVnR3BuRDFFbk0xWEcwU2x0dUhzTnZ0NnNKdEtja01TbFBK?=
 =?utf-8?Q?YLyocXh/fvvY9aeJiL4w+4on3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e4f917-6808-4bee-8306-08db03acbd44
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 17:01:04.7229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQEegoN96+S0e4oIjuUaSuQp7DRbn/9l/mRrTuWHZ/+CjkOax4r5JEXFpn8HogNq+cgL9B/ZCYVCrOxx2Jh30Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWljaGFlbCBLZWxsZXkg
KExJTlVYKSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5
IDMwLCAyMDIzIDEwOjMzIFBNDQo+IFRvOiBLWSBTcmluaXZhc2FuIDxreXNAbWljcm9zb2Z0LmNv
bT47IEhhaXlhbmcgWmhhbmcNCj4gPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyB3ZWkubGl1QGtl
cm5lbC5vcmc7IERleHVhbiBDdWkNCj4gPGRlY3VpQG1pY3Jvc29mdC5jb20+OyBkYXZlbUBkYXZl
bWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVu
aUByZWRoYXQuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gaHlwZXJ2QHZn
ZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBDYzogTWljaGFl
bCBLZWxsZXkgKExJTlVYKSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT47IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogW1BBVENIIG5ldCAxLzFdIGh2X25ldHZzYzogRml4IG1pc3Nl
ZCBwYWdlYnVmIGVudHJpZXMgaW4NCj4gbmV0dnNjX2RtYV9tYXAvdW5tYXAoKQ0KPiANCj4gbmV0
dnNjX2RtYV9tYXAoKSBhbmQgbmV0dnNjX2RtYV91bm1hcCgpIGN1cnJlbnRseSBjaGVjayB0aGUg
Y3BfcGFydGlhbA0KPiBmbGFnIGFuZCBhZGp1c3QgdGhlIHBhZ2VfY291bnQgc28gdGhhdCBwYWdl
YnVmIGVudHJpZXMgZm9yIHRoZSBSTkRJUw0KPiBwb3J0aW9uIG9mIHRoZSBtZXNzYWdlIGFyZSBz
a2lwcGVkIHdoZW4gaXQgaGFzIGFscmVhZHkgYmVlbiBjb3BpZWQgaW50bw0KPiBhIHNlbmQgYnVm
ZmVyLiBCdXQgdGhpcyBhZGp1c3RtZW50IGhhcyBhbHJlYWR5IGJlZW4gbWFkZSBieSBjb2RlIGlu
DQo+IG5ldHZzY19zZW5kKCkuIFRoZSBkdXBsaWNhdGUgYWRqdXN0bWVudCBjYXVzZXMgc29tZSBw
YWdlYnVmIGVudHJpZXMgdG8NCj4gbm90IGJlIG1hcHBlZC4gSW4gYSBub3JtYWwgVk0sIHRoaXMg
ZG9lc24ndCBicmVhayBhbnl0aGluZyBiZWNhdXNlIHRoZQ0KPiBtYXBwaW5nIGRvZXNu4oCZdCBj
aGFuZ2UgdGhlIFBGTi4gQnV0IGluIGEgQ29uZmlkZW50aWFsIFZNLA0KPiBkbWFfbWFwX3Npbmds
ZSgpIGRvZXMgYm91bmNlIGJ1ZmZlcmluZyBhbmQgcHJvdmlkZXMgYSBkaWZmZXJlbnQgUEZOLg0K
PiBGYWlsaW5nIHRvIGRvIHRoZSBtYXBwaW5nIGNhdXNlcyB0aGUgd3JvbmcgUEZOIHRvIGJlIHBh
c3NlZCB0byBIeXBlci1WLA0KPiBhbmQgdmFyaW91cyBlcnJvcnMgZW5zdWUuDQo+IA0KPiBGaXgg
dGhpcyBieSByZW1vdmluZyB0aGUgZHVwbGljYXRlIGFkanVzdG1lbnQgaW4gbmV0dnNjX2RtYV9t
YXAoKSBhbmQNCj4gbmV0dnNjX2RtYV91bm1hcCgpLg0KPiANCj4gRml4ZXM6IDg0NmRhMzhkZTBl
OCAoIm5ldDogbmV0dnNjOiBBZGQgSXNvbGF0aW9uIFZNIHN1cHBvcnQgZm9yIG5ldHZzYw0KPiBk
cml2ZXIiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBN
aWNoYWVsIEtlbGxleSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEhh
aXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+DQoNClRoYW5rcyENCg==
