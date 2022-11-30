Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536A663CDE1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 04:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiK3DhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 22:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbiK3DhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 22:37:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2110.outbound.protection.outlook.com [40.107.220.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8534B74611
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 19:36:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9u4yu0hli2U3sEsXspH+wXh8Sh6v/4WwW4b3T7KyYgnDirNIk+d8BUFVS1ztFMIpF+0ww7bO2QodJd3othjwEJ4E83Mtb0U3vMuwl4g8mLaewBzQEnM2sHoUTTI0Gi+fZC/41C0iMvTHjWwsmBRV/u3ugOecaAntNJw3+emi7cR658xHbBQMY44BvBqv2SZL0F4Yq6nvoC42vDeSuI6767GnvaCN+macwlBfFXJU9mib4sHfX+OaygCEFOKNGV83P3urkojW+UIkcjNkr5cFyRaX5OHo51sOnKDu/58TZVu7F/PfLq8t9JJMgwXM92Aj7H/19kfw3KVsRTshnUhmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjlR25kgS4DSRTSIw+bFeGxjI9FveRskQodZINteO2I=;
 b=VWVDkpY2UQRyQlz9t+ACez74ZB9AEnLuW2gHNytwZVxEV7xJqvrxh5owYJt0JHlCUHdZLRD20PPYj12QQx8R7+nXpL9yOKwAXbkZUiUR+7Fi28qKIWRbX+n+kt3/9xaoOy/dQlnu/YCeEamj0wNBlq3+PiqGYacxCGs+MlOePl5awoT+LLdnYKnZN0sbdeDaHWdRQnKyFD/y2nV2wOoZNYxbkE0sZ45RdyfLgBT3+UWolr44/h4IxgXZX6vcUm9gIbWxI4bJbKRRltv+r//7FeTEBCrzAnPZ+w+V4J9nWfkXascvs+W2IYkcY1xpTQGUYdPSjdc0MvJE2Qylux8zvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjlR25kgS4DSRTSIw+bFeGxjI9FveRskQodZINteO2I=;
 b=T72xb12XHA9qxPpQdp228xm5HR+XbIw3QQb77x6BCptVpMxtJ055kvm+6wfIG6Fe+YBzSXIa6lMaa6VMouf7qM0Ue1pvSTmkwRxnxiuXu0A44yiw0CMXEsRp6VVrUk2oA8HZ/znSaKw5Rsh5mqADXzObHMjy7oWFyfx02FZ56N8=
Received: from PH0PR13MB4793.namprd13.prod.outlook.com (2603:10b6:510:7a::12)
 by BN0PR13MB4710.namprd13.prod.outlook.com (2603:10b6:408:123::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 03:36:57 +0000
Received: from PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489]) by PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489%4]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 03:36:57 +0000
From:   Tianyu Yuan <tianyu.yuan@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>,
        Marcelo Leitner <mleitner@redhat.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: RE: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Topic: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Index: AQHY/mSdmThOr7A34UyDPeUsz+fSLa5OwOIAgAAoYjCAAMvsAIAENEkQgABvloCAAAG8AIAABGCAgAGCGgCAAPMOMA==
Date:   Wed, 30 Nov 2022 03:36:57 +0000
Message-ID: <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
 <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
 <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
 <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com>
In-Reply-To: <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB4793:EE_|BN0PR13MB4710:EE_
x-ms-office365-filtering-correlation-id: 6f47e54a-8011-41cb-0aa1-08dad28421ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BUxiEltvMQBBbrf6usCEMPXvHVpGHCP4QW9Pn3/pW1L3vCwCQXsbCFgbOoL/Hs23LNOuEbW9/gSErMJwaUatHMeVLJxdUBVnk+Zrm9Vi4B2rYhvTYuLVhk7lG+olB2ChLd3kHYmzQffXkj1tOH/8eI2fKEcrakkf3dbl1rqXXXlKTWGWbxRBRb1LZak6Nh3T0A5kmkPSil1YI66k3IVzdmJ92xO4YfXw6yhkHfHv/dMNbJHF16H+S3brGbJvZ0xzr69jxYr7n/lkDa4gRqKwFlLZV10/zgh6fs9J07LSbTymQ+LpmcFwF1JWvF841pA2+FbAE/Z0zjflXYPJh4i3aYl553XjGCOVVWp62yQdYeayWJOV5fR8OdEOqUgynO78pnjnKSj3r/Lg7ptJX/HBw9Norp4HBncSlpS/TjirWgbm/Z02fVv5uZLtFAMz8WU0CMrzv8WOK4X7gNOmdgLe1dD85Tam6ZF7x+ZWo1XdtXF1cQCHGZhd2OTKLudr4/OvHdKuLYnPxKgFHt/8u0v70S0DQEzFSTNCFz4mXTOx+um8SCR9nj3cnRr7VEMOxk4Yjc2ElhML2fVaM1/3MRIc+c0yu8hfkQiFOSJ7Pn/sVE+KTwoIK6voD94Y/uz6anRydK+4Ena/GSxWhA18jYMBh0eNaFsbFrTYp/nNdb6XKp3jBgxM8viq6vkOzkQPz/XGROoCd2ar7q5us672URfJ99U7qsGxoXC0rWcpYP+vcsYEe7gSAidXNVzvPD+J/9UY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4793.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39840400004)(376002)(366004)(136003)(396003)(451199015)(5660300002)(7416002)(44832011)(55016003)(33656002)(110136005)(9686003)(26005)(54906003)(52536014)(41300700001)(66556008)(66946007)(76116006)(8676002)(64756008)(4326008)(66476007)(66446008)(122000001)(38100700002)(8936002)(2906002)(38070700005)(186003)(71200400001)(86362001)(316002)(7696005)(6506007)(53546011)(107886003)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WW9KL1B5UTIxVVN5WUNJNEpRd1g1MEdPQVY4ak1ub2hkWThMSzJNVDdVcGdO?=
 =?utf-8?B?cjJrLzI2QnZrcjg2S0gwb0RKR0ZGVVN1OVhDK1FxYXFzcTZncTNmOW10MVNX?=
 =?utf-8?B?S05XUlNGQ1hrdURqQmxTZHJ6MUdEaDM0UUFDUU9kcEh6MFZ4cEF2MTFMUXdG?=
 =?utf-8?B?Sk9qdGFCSEZhYUdDZjhCSzlmKzJQcVdIZWVKUzErS09OU3FuWXovVUdBUTNE?=
 =?utf-8?B?M09GVEdGSDdXNm5JZk9ibS9LMGVEMGY5SnNQTFAvRHNDdWgvZmZ0UkRXL20v?=
 =?utf-8?B?T3VBOEpvdFk4eDRYSVUreTRhL1o3c041c1c1UWFia1ZsTWN1cDlmbDhtaGpZ?=
 =?utf-8?B?amVBOUlSM0IzK1ZHTjFiR0hmOS9ENEVscHNQdXpiWkhyRVgxU3JCU2xHRC9D?=
 =?utf-8?B?Vm5TZXpFTjVIMEdGTys2MlNMd1hiOXU2Ym56Y3ZVOWdhL3JTZzNQZUhveGNU?=
 =?utf-8?B?V0UzSTloTHBwOURyM2dvNW9UMGoxOStNME9LZHBkZDdMU1l2dmRKY0NFQit5?=
 =?utf-8?B?SkRsYm9Sc3Y5UEY2SGlrYzB5OERpdnBaYlVoS1BVRHZBUWtMU1diYnlGcEFj?=
 =?utf-8?B?NUFPL3ZTNlhQOHVWNXZmcWxxQVgyTmJUZEhaSFh5dWxka0h5UDNIOEc1eFlw?=
 =?utf-8?B?UXgrQjhKNEhFeFFJelhyWU5CaHNMTkRJenFuWkdnL21yV1ZJcE5yeWc4em5o?=
 =?utf-8?B?QzdvcEtseFpIVldxbjRTcWoyTjd5SFMzRVZOQ3dNSG1aL0hyT0d6VXVnL3ZW?=
 =?utf-8?B?Z25GUkc2WlM5dVpPbTZwWmRzREs2N2xzRHpqWTZCRm9MYnVySm1UeVMxRnMz?=
 =?utf-8?B?ZWEwZlVJdE14RVAxM0FZOGNoSWhpTUJKck1XTTBFd1JkVEhVREtyVnFKMU5C?=
 =?utf-8?B?Rmw4NXNDYUl6bXBmaEd5Y0x3aUtxUXVKSnJVZjU2NDRaMjc3Q043VmluTWV5?=
 =?utf-8?B?Y1RJNVNwSzhNOFdhQVRTZmhZR2xHZHhKZ1ltTG02WUcyeXQxallaWXNjS0tU?=
 =?utf-8?B?eEtic2d1Tkk1ZHlmbExvV3FXUmRpUFZ2WE05N1pMYWZLTU1QZmtEbCtZellx?=
 =?utf-8?B?U25CR2d0d1VxU0Y1VWIwZStNaGVZTWRTL0J2T3lEb0cvNFpDRTVJZlVnTFlL?=
 =?utf-8?B?cGNKWmFDdk5Pb0RabVVDb0lKOWNURmlETmZGOVc0eTNUMVdJbGJobkE0OFZl?=
 =?utf-8?B?MjMrcENZTTBRZWIwdHZTeU4waWZscForU3RpcFRRN3ZpVDljVWpSQStuTkZ1?=
 =?utf-8?B?bGRpRERDc29YWjN4N2JSV2ZaaEFlVFJhRWtDNzRwTi9UTTBBejhHV2hBSW1m?=
 =?utf-8?B?VHM4TWp6ZFhpUTVoUlJDa2lkM1YxbEx6d3FKSmx1dVhOYUxVN2hXMGwwWHd1?=
 =?utf-8?B?VkNwcDkwbCs1dWZEQTlpVE5pU0RUSWRtNmhmWklTcEVuNkM5YUxjWkNWZzRr?=
 =?utf-8?B?a2l6U1lwa2JTTFRJb21WMy9QdjkvUDFCRkdBU0RXL0dtTUNLeUJiM3JqeXRl?=
 =?utf-8?B?eDJtRHUrc1haZUlCQ1Fjd0YyclJBS0ZjVEhSTWpySVhBaWtLUkJ4TzB1MzBP?=
 =?utf-8?B?eTI3MmI5R1QvSmFjeGFlckQzeFlzVWlScm85V29NUjBmNlI4RWJiTE9tc29S?=
 =?utf-8?B?RXk3VmtqODVJcHgxNklJeWFOdWpyUTNIelNoSFVpbTAyaDJING1QV0dmb0t0?=
 =?utf-8?B?K3g3K2RJN0FFM1lyV3VuQ1A2RTVQRjVrOThvc3ZYaXVYbndsSkcrWTUwaUVa?=
 =?utf-8?B?bE9SSFFpOFRsMVhzekM0SHZXOTNhK2w1OEJmdXEzSHJRZHdzV3FkdkJTeVFt?=
 =?utf-8?B?WjYycjNYV0FIcXQyUU5QV1diSHZld016Q3FyajhhMEt4YSt1MExiOHhqcG4y?=
 =?utf-8?B?dEhrMUZzZkFzWEdObGdBOFNoeTRJbnE0ZG5QYkVTK1FXNndycnZ1SlBodit0?=
 =?utf-8?B?Smd5UmtuK2MwSTdDSGdBRVNITUtLQUt6THN1YzVuVGwzYmdNbEhvMWNnalor?=
 =?utf-8?B?bnFmZ2x4bnJUQ0NaN2RYOXdGR3lwR1NORnQzRG5MK3ZpcERLWEVqd1hublpN?=
 =?utf-8?B?SkttYkFRTnp0clRBMzBsQS94ZDVNS2YzeFlHRUlJUTZjVHVMRUNSQm00MFpH?=
 =?utf-8?Q?8FtbVJU+6SdvvbfOP5MNlRtc7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4793.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f47e54a-8011-41cb-0aa1-08dad28421ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 03:36:57.2551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nGpg15YeHowHDp+AxPpyaAjCzfIoZbOqiZUQEIkUEfZtdJspzVphk89X+z9Npm6QBqa/p3/PV1YrqWtIauBz/dhmqG/yiC8rGIUfVBUuib0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4710
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBNb24sIE5vdiAyOSwgMjAyMiBhdCA4OjM1IFBNICwgRWVsY28gQ2hhdWRyb24gd3JvdGU6
DQo+IA0KPiBPbiAyOCBOb3YgMjAyMiwgYXQgMTQ6MzMsIE1hcmNlbG8gTGVpdG5lciB3cm90ZToN
Cj4gDQo+ID4gT24gTW9uLCBOb3YgMjgsIDIwMjIgYXQgMDI6MTc6NDBQTSArMDEwMCwgRWVsY28g
Q2hhdWRyb24gd3JvdGU6DQo+ID4+DQo+ID4+DQo+ID4+IE9uIDI4IE5vdiAyMDIyLCBhdCAxNDox
MSwgTWFyY2VsbyBMZWl0bmVyIHdyb3RlOg0KPiA+Pg0KPiA+Pj4gT24gTW9uLCBOb3YgMjgsIDIw
MjIgYXQgMDc6MTE6MDVBTSArMDAwMCwgVGlhbnl1IFl1YW4gd3JvdGU6DQo+ID4gLi4uDQo+ID4+
Pj4NCj4gPj4+PiBGdXJ0aGVybW9yZSwgSSB0aGluayB0aGUgY3VycmVudCBzdGF0cyBmb3IgZWFj
aCBhY3Rpb24gbWVudGlvbmVkIGluDQo+ID4+Pj4gMikgY2Fubm90IHJlcHJlc2VudCB0aGUgcmVh
bCBodyBzdGF0cyBhbmQgdGhpcyBpcyB3aHkgWyBSRkMNCj4gPj4+PiBuZXQtbmV4dCB2MiAwLzJd
IChuZXQ6IGZsb3dfb2ZmbG9hZDogYWRkIHN1cHBvcnQgZm9yIHBlciBhY3Rpb24gaHcgc3RhdHMp
DQo+IHdpbGwgY29tZSB1cC4NCj4gPj4+DQo+ID4+PiBFeGFjdGx5LiBUaGVuLCB3aGVuIHRoaXMg
cGF0Y2hzZXQgKG9yIHNpbWlsYXIpIGNvbWUgdXAsIGl0IHdvbid0DQo+ID4+PiB1cGRhdGUgYWxs
IGFjdGlvbnMgd2l0aCB0aGUgc2FtZSBzdGF0cyBhbnltb3JlLiBJdCB3aWxsIHJlcXVpcmUgYQ0K
PiA+Pj4gc2V0IG9mIHN0YXRzIGZyb20gaHcgZm9yIHRoZSBnYWN0IHdpdGggUElQRSBhY3Rpb24g
aGVyZS4gQnV0IGlmDQo+ID4+PiBkcml2ZXJzIGFyZSBpZ25vcmluZyB0aGlzIGFjdGlvbiwgdGhl
eSBjYW4ndCBoYXZlIHNwZWNpZmljIHN0YXRzIGZvcg0KPiA+Pj4gaXQuIE9yIGFtIEkgbWlzc2lu
ZyBzb21ldGhpbmc/DQo+ID4+Pg0KPiA+Pj4gU28gaXQgaXMgYmV0dGVyIGZvciB0aGUgZHJpdmVy
cyB0byByZWplY3QgdGhlIHdob2xlIGZsb3cgaW5zdGVhZCBvZg0KPiA+Pj4gc2ltcGx5IGlnbm9y
aW5nIGl0LCBhbmQgbGV0IHZzd2l0Y2hkIHByb2JlIGlmIGl0IHNob3VsZCBvciBzaG91bGQNCj4g
Pj4+IG5vdCB1c2UgdGhpcyBhY3Rpb24uDQo+ID4+DQo+ID4+IFBsZWFzZSBub3RlIHRoYXQgT1ZT
IGRvZXMgbm90IHByb2JlIGZlYXR1cmVzIHBlciBpbnRlcmZhY2UsIGJ1dCBkb2VzIGl0DQo+IHBl
ciBkYXRhcGF0aC4gU28gaWYgaXTigJlzIHN1cHBvcnRlZCBpbiBwaXBlIGluIHRjIHNvZnR3YXJl
LCB3ZSB3aWxsIHVzZSBpdC4gSWYgdGhlDQo+IGRyaXZlciByZWplY3RzIGl0LCB3ZSB3aWxsIHBy
b2JhYmx5IGVuZCB1cCB3aXRoIHRoZSB0YyBzb2Z0d2FyZSBydWxlIG9ubHkuDQo+ID4NCj4gPiBB
aCByaWdodC4gSSByZW1lbWJlciBpdCB3aWxsIHBpY2sgMSBpbnRlcmZhY2UgZm9yIHRlc3Rpbmcg
YW5kIHVzZQ0KPiA+IHRob3NlIHJlc3VsdHMgZXZlcnl3aGVyZSwgd2hpY2ggdGhlbiBJIGRvbid0
IGtub3cgaWYgaXQgbWF5IG9yIG1heSBub3QNCj4gPiBiZSBhIHJlcHJlc2VudG9yIHBvcnQgb3Ig
bm90LiBBbnlob3csIHRoZW4gaXQgc2hvdWxkIHVzZSBza2lwX3N3LCB0bw0KPiA+IHRyeSB0byBw
cm9iZSBmb3IgdGhlIG9mZmxvYWRpbmcgcGFydC4gT3RoZXJ3aXNlIEknbSBhZnJhaWQgdGMgc3cg
d2lsbA0KPiA+IGFsd2F5cyBhY2NlcHQgdGhpcyBmbG93IGFuZCB0cmljayB0aGUgcHJvYmluZywg
eWVzLg0KPiANCj4gV2VsbCwgaXQgZGVwZW5kcyBvbiBob3cgeW91IGxvb2sgYXQgaXQuIEluIHRo
ZW9yeSwgd2Ugc2hvdWxkIGJlIGhhcmR3YXJlDQo+IGFnbm9zdGljLCBtZWFuaW5nIHdoYXQgaWYg
eW91IGhhdmUgZGlmZmVyZW50IGhhcmR3YXJlIGluIHlvdXIgc3lzdGVtPyBPVlMNCj4gb25seSBz
dXBwb3J0cyBnbG9iYWwgb2ZmbG9hZCBlbmFibGVtZW50Lg0KPiANCj4gVGlhbnl1IGhvdyBhcmUg
eW91IHBsYW5uaW5nIHRvIHN1cHBvcnQgdGhpcyBmcm9tIHRoZSBPVlMgc2lkZT8gSG93IHdvdWxk
DQo+IHlvdSBwcm9iZSBrZXJuZWwgYW5kL29yIGhhcmR3YXJlIHN1cHBvcnQgZm9yIHRoaXMgY2hh
bmdlPw0KDQpDdXJyZW50bHkgaW4gdGhlIHRlc3QgZGVtbywgSSBqdXN0IGV4dGVuZCBnYWN0IHdp
dGggUElQRSAocHJldmlvdXNseSBvbmx5IFNIT1QgYXMgZGVmYXVsdCBhbmQgDQpHT1RPX0NIQUlO
IHdoZW4gY2hhaW4gZXhpc3RzKSwgYW5kIHRoZW4gcHV0IHN1Y2ggYSBnYWN0IHdpdGggUElQRSBh
dCB0aGUgZmlyc3QgcGxhY2Ugb2YgZWFjaA0KZmlsdGVyIHdoaWNoIHdpbGwgYmUgdHJhbnNhY3Rl
ZCB3aXRoIGtlcm5lbCB0Yy4NCg0KQWJvdXQgdGhlIHRjIHN3IGRhdGFwYXRoIG1lbnRpb25lZCwg
d2UgZG9uJ3QgaGF2ZSB0byBtYWtlIGNoYW5nZXMgYmVjYXVzZSBnYWN0IHdpdGggUElQRQ0KaGFz
IGFscmVhZHkgYmVlbiBzdXBwb3J0ZWQgaW4gY3VycmVudCB0YyBpbXBsZW1lbnRhdGlvbiBhbmQg
aXQgY291bGQgYWN0IGxpa2UgYSAnY291bnRlcicgQW5kDQpmb3IgdGhlIGhhcmR3YXJlIHdlIGp1
c3QgbmVlZCB0byBpZ25vcmUgdGhpcyBQSVBFIGFuZCB0aGUgc3RhdHMgb2YgdGhpcyBhY3Rpb24g
d2lsbCBzdGlsbCBiZSB1cGRhdGVkDQppbiBrZXJuZWwgc2lkZSBhbmQgc2VudCB0byB1c2Vyc3Bh
Y2UuDQoNCkkgYWdyZWUgd2l0aCB0aGF0IHRoZSB1bnN1cHBvcnRlZCBhY3Rpb25zIHNob3VsZCBi
ZSByZWplY3RlZCBieSBkcml2ZXJzLCBzbyBtYXkgYW5vdGhlciBhcHByb2FjaA0KY291bGQgd29y
ayB3aXRob3V0IGlnbm9yaW5nIFBJUEUgaW4gYWxsIHRoZSByZWxhdGVkIGRyaXZlcnMsIHRoYXQg
d2UgZGlyZWN0bHkgbWFrZSBwdXQgdGhlIGZsb3dlciBzdGF0cw0KZnJvbSBkcml2ZXIgaW50byB0
aGUgc29ja2V0IHdoaWNoIGlzIHVzZWQgdG8gdHJhbnNhY3Qgd2l0aCB1c2Vyc3BhY2UgYW5kIHVz
ZXJzcGFjZShlLmcuIE9WUykgdXBkYXRlDQp0aGUgZmxvdyBzdGF0cyB1c2luZyB0aGlzIHN0YXRz
IGluc3RlYWQgb2YgdGhlIHBhcnNpbmcgdGhlIGFjdGlvbiBzdGF0cy4gSG93IGRvIHlvdSB0aGlu
ayBvZiB0aGlzPw0KDQpDaGVlcnMsDQpUaWFueXUNCj4gDQo+IC8vRWVsY28NCg0K
