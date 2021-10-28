Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5776543DAD7
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 07:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhJ1Ftl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 01:49:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27902 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229689AbhJ1Ftl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 01:49:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RNPiWS011438;
        Wed, 27 Oct 2021 22:47:12 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-0016f401.pphosted.com with ESMTP id 3by9rtttf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 22:47:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFydDDTw6pvK2P7ps9Nt7VIFTZK6Q2N/hl+6i1ysupOieLcDjZOLveAXwuP1OrYjDOBulX/P18IGn2MqwXy+xFeXKebmanHNWv2h5SFw7kT5oapAEvSVf67Y3BmcDBSZBop89CS42MOX9XGwhIAbaIHwr+1NY5mjnemX5buqeCbTqtglk9Zw2FdfGQrBk7fgfDd6Soy1NwdZQ+LsWlMZxX73kCVaeNsPCNNLIjYDzMtZrf3e0vcS7GOm5z60IjydrcmWQ0PJYuV3lvEeJ6vgSDOnfYdC7gtcfAv4AjWKw/1MjGgfuHGD4ouZw0KMcu6Hhni0gwNU0m1lagyhCLlGYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gI9yoowaMsE1tRt7azxPtiVSO/t60ta1SVTimDFnEbU=;
 b=OAZG6Do3MnQ3FyDysKn+XNP9fQF92q68ELWrHfwEjRe3/lCBP6VocSrS9QkjMkHGWcuMMeb5NAKg3czfOhRuITTi/X4YnL1ctEhY97m813axH0da2X6Gbnuphw0bxH9f3QQa/+ra/OirNI9e19C6FRb5VPBLcx/q7fUi4Js1qHigi/texhrWqJVpKm6Cp/V9pbTsaZ/i58ro8UJ/zZUMirHbs2OfztN+xfyDTXrlNx10YQjhswQt+lsNccCWm9ECPnmvocY3eW3x6tmafIklGm/m+45s/x/GHkQG1ic35I0rS4dF/4LSqn2cZHfL64t9S1C76vQ5ne4FpZRc7Ddapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gI9yoowaMsE1tRt7azxPtiVSO/t60ta1SVTimDFnEbU=;
 b=O66a/Z5TVXxqu/amJ1xYF2vQ97J8UMgVKiUaaK9xlk9J72HadZIvdnoiXJO0YW9myJZydPXQY4xNwa0V2wcZJeVrLmOP+1JUs8T8SsR05Yl1zRUwFEbaROLqR8MhWiHan95o81IyL91MoHM+4PD7yKpAY2MJxYBxnb7tg9rBElw=
Received: from PH0PR18MB4655.namprd18.prod.outlook.com (2603:10b6:510:c6::17)
 by PH0PR18MB4558.namprd18.prod.outlook.com (2603:10b6:510:ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 05:47:10 +0000
Received: from PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::18a1:f96:a309:3bfb]) by PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::18a1:f96:a309:3bfb%5]) with mapi id 15.20.4628.023; Thu, 28 Oct 2021
 05:47:10 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Caleb Sander <csander@purestorage.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Joern Engel <joern@purestorage.com>
Subject: RE: [EXT] Re: [PATCH] qed: avoid spin loops in
 _qed_mcp_cmd_and_union()
Thread-Topic: [EXT] Re: [PATCH] qed: avoid spin loops in
 _qed_mcp_cmd_and_union()
Thread-Index: AQHXy4GRHeWX0tunskWDJjdTDpiVHavnjBgAgABaHHA=
Date:   Thu, 28 Oct 2021 05:47:10 +0000
Message-ID: <PH0PR18MB465585F216AEC6E441B7E0E4C4869@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211027214519.606096-1-csander@purestorage.com>
 <d9d4b6d1-d64d-4bfb-17d9-b28153e02b9e@gmail.com>
 <CADUfDZqx6EjOY=JcQuC6hfPjGgTZCk6BcV5_D1Dp+WQJiXmEnQ@mail.gmail.com>
In-Reply-To: <CADUfDZqx6EjOY=JcQuC6hfPjGgTZCk6BcV5_D1Dp+WQJiXmEnQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c565f5a-0a63-4511-8607-08d999d6627c
x-ms-traffictypediagnostic: PH0PR18MB4558:
x-microsoft-antispam-prvs: <PH0PR18MB4558373CC13CB57DD5AD37F0C4869@PH0PR18MB4558.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LLZyxE+S3hOuvxLjbgR9X+MWkobyMlR6qPqJoUXsT/dR0537hjlttFj+YGXDhWZj4t9F/Yj3aZWCgCeSuhW4zHvPtRTP/LPNbi/xwIbaOFo1tmtvWc5kKh15W7iRQcVDWjGsCcIA3Ao/kV5O6LoVCrkYOukZbO/5bzUWNqkerrf60U8OJylFlulZN3Nzgnbv3hL6/Y9CKGQ/kQNS+RMEclAAG3B/Muq7CizRFNKfpRAcAEXY8EXPau2ToE58Rhi4F6AJyRfihpygjD5NrhwsqzNPEdoYOTtkekBntQ8kA9l0oZRLaEahTqnhECmSh5r8K4vqzh0ALnSffcAHeGdfwpKKKFjbGd6l25rSLdSV5PZtRnOtxYNyWJB5gJilO7Ysg5IUBkk42SNvNM5iY1/KrrBE+aW7Cr2c3s56MQ6eOE8CDX3SMCemHYthtw8/vjMgR69fJUW6R3vuvfgyF3iilf4lNzXJjsS1P6L24cCCna8bM3BBEAhS/5H3icTJ0lVrtnd6sbdrbALwxrpRcy36Z3mFjsiLkAtXa8URvm2Bz2Wup6xfPto3rFkjMW3ZR+7Hn+s83ndcIpX+fGzJQcmQbrVq7Yxs7PFWzoX9z3Y6VtBg3635NGoovTK7fxasHYqV2eOnqCQpZcbGJIR/ZPGDvbonsnlOferiBtDjKNC71v6Frvqm7Mt6+dItcIUA8CVQ9mK1zJhBEIXEdx8TgNi6/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4655.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(33656002)(53546011)(71200400001)(6506007)(66476007)(66556008)(66446008)(66946007)(110136005)(76116006)(64756008)(122000001)(186003)(26005)(8936002)(52536014)(2906002)(54906003)(316002)(8676002)(4326008)(86362001)(7696005)(508600001)(9686003)(38070700005)(38100700002)(83380400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STJkRnNWNHZNbitPUGVmb3BlbjJHQ25SR2U2SzVIRHJ5WGd6V0JuQTNSVith?=
 =?utf-8?B?M3ZIb1FUT2FFbHBrbE5lZWt6VjlEczVjMFIwbHpoY3hGTk5nRzRtNUlsQmVY?=
 =?utf-8?B?aHZYK2c2ZVg3ZUZhNjBhZjRkK3RXbVlIUE5MdlFLc2xqam5kZUtuQzNlOVlu?=
 =?utf-8?B?RUNuVjM5N2UzK2h2Zkl5UGRJQjRWeDJwUVFwbW5VQkptc2NERVFNNG5JeCs1?=
 =?utf-8?B?eVFWRWpod0ZqcU4xOU5vcHZQbVJOZ2hQN2x5UmpsUjRDbTFsYTltaTl3eUx6?=
 =?utf-8?B?Um0yTmo3VHdRenVWb3lhNmovSW9Qay9UQTUyNUJuS2l0N2c1c1RCaHIvU0hy?=
 =?utf-8?B?WnMwendxSklKZzQ5UUtnUTA5R1hrSzJEcER1THF2dUJENTMveVF1TEsrL21Y?=
 =?utf-8?B?WnlaR0pjVzlKbGFzZDVFQmdIMDZGTGw3YVZNN1A5SW12TEcyNEg1YTJGeWFn?=
 =?utf-8?B?Vmwvb1VxTitIM1o4Ri9BbHpzWEJ4MVJZYVdHY0dyOFpMTm1SZ1hhbkJ2YnFn?=
 =?utf-8?B?amMxL0pqcTJkekYydzFERVpldk14eS92UUtIVisyQWlzVnlxY0pWd0hEZzhk?=
 =?utf-8?B?T09WR1IzRDR5emJCSjE3WmtmN1RQMTMrcmxxWGVHZzhWOEFnQWlsY0VPcldD?=
 =?utf-8?B?alFVSWI3S3BUbUk2cCtpcUVWdWhWcjdWZTZZdERvQ1JFdDhCYmlUVnErc2lj?=
 =?utf-8?B?U20rbzcwUDhJbWIyOHZiTDQ1ZFhyVjMzaCtSeHpDUkI3TFBRUHVxaVdQdXdR?=
 =?utf-8?B?am8rM3FoZHl3SzZQOEtKRXBMVHcxVThjdXY2Qlpidm9yaFViR0ZVblE0d05z?=
 =?utf-8?B?S1lrMHlhcTVTMi8zS3FTbnJVZ1lXckkvSlBjemdMb2o5MzR4MU9ZUVBNVEo1?=
 =?utf-8?B?YVVteW5sWTFGUjNCdmlacjNBSk82N1dxbWxrVVFUMmdpN3ZJSVYza1FCd1JU?=
 =?utf-8?B?UEgrWEU5cHdXa3ZsM0t2Z1hRTnNua1h4Vy9UWm9uMlhiVHZmT0liWWM1Q09F?=
 =?utf-8?B?eHBTb1VBMGV0SnNqMDlxSlA2RDdJQ0dFQk51d2RGdjVhVWJtbjV3dU5oZGRy?=
 =?utf-8?B?UGVNME9DQzBTZkphOWFubndyZlVHSWdnT3dCM21lZ05MZ3dZa1MxQTdFbDdy?=
 =?utf-8?B?OUtXVWR0c2R5bTcwTHJId1dNTENIc0laVzAvb2dVUGV4NE1ONjZSVVpqRjhz?=
 =?utf-8?B?Vm03NHNSVE1WdDY5RzlMY0tzbENTK1h6aXM1bUtRWC9OR1hoNTZDZW9RazNa?=
 =?utf-8?B?WWJHaU82WTI0R2dIcjlpYVZvSnlXM01RbGFZZ1V0SnZvN3Z6Tk9JaktpS2Zk?=
 =?utf-8?B?MURJNG9oMjBucUFJTmVVNWp0ek9oOU1LMGNjTzhUQXI2blZ0RnJ3RG0ydGE1?=
 =?utf-8?B?WnJuZ09peC9xMEIwbG5zYzVUWUZzNmNGbm1VS29oLzNyZjE3L1hNSXFHdXd6?=
 =?utf-8?B?MUhLSW53d2crTDgvaVFaZ29oaU1Bc1d2OXFEOHJzSllTT3BqOUNwMng0OWZC?=
 =?utf-8?B?ajY1Z3huYTVXZDNzazlaK3FpbUdXa3ozVkNnTDZHVCtVYStOMUl2eUF2ZlhC?=
 =?utf-8?B?aFhGZ05wcGpaYUVwL1NiOW1IeWVzc0RpQ002V283Q25UMDU5UTRPNTJHdFFR?=
 =?utf-8?B?ZjZaTGllYzR3M3V3TkhMMWZHU2FJNGFaQXZYSy92U0FNUW45dXprNW81MUpG?=
 =?utf-8?B?SURGclhsMGNPOGkyNGQyWDJmU2d2NUxJcitNaVEyeEJQd085bkFCblk1RlVq?=
 =?utf-8?B?bFNpK21seVdMS1pyRnlxcnFlZEtmYmpCYjR1eTM3NnpqTVVkRGJKYW9XVzdw?=
 =?utf-8?B?REJXTzlKN2tYTFpRNTRXRkFEdWtpb3BrUXFIRmtPN2xVcWV6VXZWaWJvNE5k?=
 =?utf-8?B?OU9Kd1dOMUdydW41NTVGUjh1R1pVeGcvb29iSmxFTWc0dkFzVDBLZE9hU1pq?=
 =?utf-8?B?cEZ3RjZicHpjUkJRQlJyNTBkRlhpRjVMU0VmWGlZeDR2U0xleVBxU0d5UURU?=
 =?utf-8?B?cHZBMWVPakJyaUY2eU5XWDN2NTdBWk02VU1ZSFU3RUZWTXo3bENYY29Ramoy?=
 =?utf-8?B?amxEUUIwWjJmT1hZUWFXQ2ZMS3U1Vy9VQXhJQndiamxYKzJWKzVWVGRnTXFD?=
 =?utf-8?B?b3loeksySTNvVVllTVRLWHNxOVFsZU5VUjhiZlcxY0NKUHVScUYrNkQ1K1R1?=
 =?utf-8?Q?kS5gNID1x+cdDziMeUUrjgo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4655.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c565f5a-0a63-4511-8607-08d999d6627c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 05:47:10.2352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KZpxFnHgyy3BsdmgumF6sHIFCkhEEJxdj2WhPueXAQYt3f1GTlgcYJIsTtZ9XagFpGngBWuEkKRKohtrNUT+2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4558
X-Proofpoint-ORIG-GUID: rlzOaNL597B_6Ug--wd6kvGdl_fu5L0V
X-Proofpoint-GUID: rlzOaNL597B_6Ug--wd6kvGdl_fu5L0V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IE9uIDEwLzI3LzIxIDI6NDUgUE0sIENhbGViIFNhbmRlciB3cm90ZToNCj4gPiA+IEJ5IGRl
ZmF1bHQsIHFlZF9tY3BfY21kX2FuZF91bmlvbigpIHNldHMgbWF4X3JldHJpZXMgdG8gNTAwSyBh
bmQNCj4gPiA+IHVzZWNzIHRvIDEwLCBzbyB0aGVzZSBsb29wcyBjYW4gdG9nZXRoZXIgZGVsYXkg
dXAgdG8gNXMuDQo+ID4gPiBXZSBvYnNlcnZlZCB0aHJlYWQgc2NoZWR1bGluZyBkZWxheXMgb2Yg
b3ZlciA3MDBtcyBpbiBwcm9kdWN0aW9uLA0KPiA+ID4gd2l0aCBzdGFja3RyYWNlcyBwb2ludGlu
ZyB0byB0aGlzIGNvZGUgYXMgdGhlIGN1bHByaXQuDQo+ID4gPg0KPiA+ID4gQWRkIGNhbGxzIHRv
IGNvbmRfcmVzY2hlZCgpIGluIGJvdGggbG9vcHMgdG8geWllbGQgdGhlIENQVSBpZiBuZWNlc3Nh
cnkuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQ2FsZWIgU2FuZGVyIDxjc2FuZGVyQHB1
cmVzdG9yYWdlLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBKb2VybiBFbmdlbCA8am9lcm5AcHVy
ZXN0b3JhZ2UuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxv
Z2ljL3FlZC9xZWRfbWNwLmMgfCAxMiArKysrKysrKy0tLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWVkL3FlZF9tY3AuYw0KPiA+ID4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWVkL3FlZF9tY3AuYw0KPiA+ID4gaW5kZXggMjRj
ZDQxNTY3Li5kNjk0NGYwMjAgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9xbG9naWMvcWVkL3FlZF9tY3AuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cWxvZ2ljL3FlZC9xZWRfbWNwLmMNCj4gPiA+IEBAIC00ODUsMTAgKzQ4NSwxMiBAQCBfcWVkX21j
cF9jbWRfYW5kX3VuaW9uKHN0cnVjdCBxZWRfaHdmbg0KPiA+ID4gKnBfaHdmbiwNCj4gPiA+DQo+
ID4gPiAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2JoKCZwX2h3Zm4tPm1jcF9pbmZvLT5jbWRf
bG9jayk7DQo+ID4gPg0KPiA+ID4gLSAgICAgICAgICAgICBpZiAoUUVEX01CX0ZMQUdTX0lTX1NF
VChwX21iX3BhcmFtcywgQ0FOX1NMRUVQKSkNCj4gPiA+ICsgICAgICAgICAgICAgaWYgKFFFRF9N
Ql9GTEFHU19JU19TRVQocF9tYl9wYXJhbXMsIENBTl9TTEVFUCkpIHsNCj4gPg0KPiA+IEkgZG8g
bm90IGtub3cgdGhpcyBkcml2ZXIsIGJ1dCBhcHBhcmVudGx5LCB0aGVyZSBpcyB0aGlzIENBTl9T
TEVFUA0KPiA+IHRlc3QgaGludGluZyBhYm91dCBiZWluZyBhYmxlIHRvIHNsZWVwLg0KSGksDQpJ
bmRlZWQgdGhpcyBmdW5jdGlvbiBzZW5kcyBtZXNzYWdlcyB0byB0aGUgbWFuYWdlbWVudCBGVywg
YW5kIG1heQ0KYmUgaW52b2tlZCBib3RoIGZyb20gYXRvbWljIGNvbnRleHRzIGFuZCBmcm9tIG5v
biBhdG9taWMgb25lcy4NCkNBTl9TTEVFUCBpbmRpY2F0ZWQgd2hldGhlciBpdCBpcyBwZXJtaXNz
aWJsZSBpbiB0aGUgY29udGV4dCBmcm9tIHdoaWNoDQppdCB3YXMgaW52b2tlZCB0byBzbGVlcC4N
Cg0K
