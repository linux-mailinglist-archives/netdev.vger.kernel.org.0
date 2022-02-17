Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2306F4BA7DC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244089AbiBQSMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:12:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiBQSMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:12:16 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90058.outbound.protection.outlook.com [40.107.9.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD21AE923;
        Thu, 17 Feb 2022 10:12:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpWIs/9nW2+c1PeiLV6SXwuS1HzZngtqbhdl1Xu7rpeV5fouTBIO2mndKf/B4abvVIGn7+zLYhuwYnas+wDu/MXYUYsqA0szmmFTYLEILDGM2y4puq0MgTl+PXk5zA2D5S8utmWrYAB9u44oN71X8ZD9zlVTkNG4nrdh7xWWVaVvfHHU49qRczjlaDogETCDEpra1Om3R9RHP0lez+vFTzSYS6N4YXVfZ5COhoWJRbZPvlDLdO+fVHUYHpE3d8/hVtOIr3R3k1/hgoj2wW+2LIO7Avbv8lnFbmb11MA3MZk+j4YlDqcGlj+VO+P3MLNPhbpi3Nq4bJM6iz0p1AUWWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TcvywkjNvbdOHvfKfp01gCIRYLcIPbuuyxlOUhoU58=;
 b=M3nZkOrtGbLWdumnrCV4rXjTE0qS2LQz0e6ddJFimDtW5e+Oy5jeb2qWP2ZyMh1Qgd9pDfwwHVfh7tmpnUEOTl+lquk2DaW6ssTZqgu28lMxaG/Igam/peKmcemlHFarC60wqG+XORrvJtIbzDxZWS7aKmx6AGmMTdSZkKbwX2qx5wwnQXa/44JRqsUOILFOff1O3nc8o5VZZxebFVmkIr4SCVeJ8/YFnTFKAAgqjjS9KNc7sh668+262Rmjck2YZxG4rJx+LRFGvWgScmbwBpuDg+HTFwvj0nPc/CDFnbxjeN9wypqjkMmxHJofjs6kbb4qRSYiPRfGi8jrM970gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 PR0P264MB1962.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:168::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Thu, 17 Feb 2022 18:11:58 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3d8b:a9b5:c4cc:8123]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3d8b:a9b5:c4cc:8123%8]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 18:11:58 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Thread-Topic: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Thread-Index: AQHYJBU4T77afu4me0W/yCcZHdgWLqyX/lUAgAANNAA=
Date:   Thu, 17 Feb 2022 18:11:58 +0000
Message-ID: <13805dc8-4f96-9621-3b8b-4ec5ea6aeffe@csgroup.eu>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
 <20220217092442.4948b48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217092442.4948b48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bab78f09-0fab-4c7c-f492-08d9f240fd0a
x-ms-traffictypediagnostic: PR0P264MB1962:EE_
x-microsoft-antispam-prvs: <PR0P264MB19626A635A372220F2AFA848ED369@PR0P264MB1962.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +1VI5qBiGvxHK2EYMPjVtaZ0Pb0ePIkavynB9tJoaxfy6ISebQ10R9Ak0+/0jsUTfa931gcohWDRIlZMQ6E6TpOlsz0kEQzZOKeh5XrWxIzzBtarvAbW8I6bjB54xc83355zSl4LiViK4k/ZozDwIqmSgMN1DzOxzn0VlFE45g7wAk6e6b/bP7P0fGsR895RdhYyex7wpG0NXAe+dNRT2g0mEKO+P38NjIxOmvRLt8MUE9JzLANrXT5tHZ0rPB/Oy86KrKB5qF4E/nq3cgGGMIfupbs25MdWTQZGoHdfSNnWz2ZW6vLa9qML4235fRtTRJC2BJ2JOzqHrsOV31KBVSROau4cSYsvG6JJn5EqOheGZav/tx5s5uUNk8OMXzH7qmRQK26fN3HPyc5xUGrft0pwNZdAODnH+tb8MzGa7qv1C6RJG80gNwAJ1smexYkINuvxAmaBTJ4VuG2CqX/tN9FGWS4izv5wCOyDdfMwcFger6QViq7LzZcX0RKEgzdrqT2p4a7pblatOtJi13uJba4QOPRCnD8/LYBy9aZUYDKQPCgAD0pjwr04b+Hyd+JtjBKCvwxbGvCZp3v3VoU09Hyp3iFfztZafxACFByOqBos5utGUGFuscaKO7EFZx6/+xeClRyu6iYEEpTbAhJ/kkV8GymPMvvodV0YfP9sNjIAxncMgpr1H2ZJqBH4skFhv6vbYfxnU0DfzXL7q45rulWdr6L+blAuDkIO5jV1PRA55hVo80mLiVs/pE23ivbU6yuEcSZShbi7XsJyZF5FcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(2616005)(122000001)(38100700002)(8676002)(66446008)(6506007)(64756008)(91956017)(66556008)(186003)(66476007)(66946007)(4326008)(26005)(508600001)(5660300002)(6512007)(38070700005)(83380400001)(44832011)(31686004)(6916009)(8936002)(316002)(86362001)(66574015)(4744005)(6486002)(54906003)(31696002)(2906002)(76116006)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDdXcjJFNVZCSElzTm80b2JnZzFtRitkVlRmcWJDK0E2Uk1rZ3dUTmoxK2Y4?=
 =?utf-8?B?ODdnT3hvZ3RyS2h0Z1dqTjBLRHd1VXBxSm1zeFdvaGJHb3l6RkNNT2ZDMkE5?=
 =?utf-8?B?SEo5K3BBTzVLVWdhWEdIYmFJOWdXVmZyQU8xUHVva3JIeG5uTUh0R3VxcjhC?=
 =?utf-8?B?ZWRVTkEwSkRPMm5QSmIwUXpEOTR6SzEwTVA2UmFFTEFTWEpwV2tmZ01qRWFG?=
 =?utf-8?B?Y0lpM3ZUYUgvci9nd2U5VU5tYkthdW9Pc2RTSHhWM2MxdG5ieFg3NlpBK0pW?=
 =?utf-8?B?cEIrSmYzSXBKSkloWlZXcnovZjkyS3ZOc054Mm82K0dWdEV1d2Z2VGhWb0Zy?=
 =?utf-8?B?d0RtN0tJREFPSXRLSXJ0M3ZmVmdNZzdEckpQSFREUkhITDU5WVhGZWtzVDZz?=
 =?utf-8?B?RTJOWi9VWnU0QjlTNWlOenNDZUJCNStYZVNHQ2VNUGhucjBuRWZ3aWNBMWhI?=
 =?utf-8?B?VXcraDg5VXo4a0xCZDRDdE1hRjZMZnFHRTJoS2x2WHpSOWZBVUw1SU01bjI1?=
 =?utf-8?B?Z1ArdGoyUEc5UE5kUXBxTUg4Z0s5YXRJUnE1NDMraHE4Um1ldUQ4dlRJZEIz?=
 =?utf-8?B?ZjI5RGpHOEJzWUE1a0NLUlhvVjl0N21vTEk1eXFLYWJWTGI4L3dkNjduc1NN?=
 =?utf-8?B?YnhzUHBIZnNqRmFIa2dsZmZ4UDdRVFlQdkU1WENsSm85ek1EcjFlakRMN2dm?=
 =?utf-8?B?eG9ibC9oVjFGaWRBWExqQkNteU9zcWpPbFlEQUUvN2F1V1c0bVBGWjh4ZHIr?=
 =?utf-8?B?enAxYWQvK2xjM1ZZUnhUSUl4TUc1WGJEUWJRZnljRGJFR1V3MmRqSDRDK0pF?=
 =?utf-8?B?Y05meUxjaFJsYUwwaFhxN3BNQmphbmcyUGdzeTdpMG5tdnNVYysxU29rSXVK?=
 =?utf-8?B?MXpWVWJGeTYydk5oUmd2OVRqeWZXcTYyc2Y5MERJbDI2RGpNWWYwL24zT01m?=
 =?utf-8?B?NDNiY0pGSHdHS1h3WThHd0FRQkx4UEtLY1VvV2l6QTB5NVdiQWxLTDl0TEpt?=
 =?utf-8?B?d2FMeWZDNzdUazNiNXptMnhvZEorYlFlc29zbm5sdDdUS2FXRUdkczBQWHRa?=
 =?utf-8?B?ak9TVWtjZnU5OXplNjFRa3BuUllBbmE4WmpnY21RY2JXZS96eFpVd2VLVjhq?=
 =?utf-8?B?djZiZlB5OEdBeWxoVXBRZ2hwc1h0RHk0OExBcmZlRzArUkRVV001NytNYTdV?=
 =?utf-8?B?Ym5Ub2wrdURQRmpqUkd4enZud1E3OCtjaThVRnNLNVEwRzQ2YXFNdVhFWHNM?=
 =?utf-8?B?VVVySEpwck9LTnF1OFlQdW5SYW5uRENtQWdPeEtaQjV2SU95dGpFTW9mQUdq?=
 =?utf-8?B?UHpHRURzUGNmc0NZc29VK2Jaand4bUZRd3VuN0ZNbFFPYWRxVmwyMUhMK3VI?=
 =?utf-8?B?SGZxbUREbVNyY2U3VzZWOXZkdmQvMURteE9JM3I3M1F5WWhNN0YyejYwUjY2?=
 =?utf-8?B?RXU4MzFGb1lnckhiVVZQYkZFNWdHVWJqZVMyMGdJOXlkK29FOXREbzFydWIv?=
 =?utf-8?B?TzNPVXVrMmNUekFnckNNM002d0Z0dUoyVkpXTGN3dnJJNHhZRERCNU05THdI?=
 =?utf-8?B?alJmTDF6eEs5K3pDM1M3cGxyV2JOdER3NW0xYUZzQTM5WVRwQjdaUzRFZEwr?=
 =?utf-8?B?S1d3bjBEYzkvZXZLL25BdFgvWERRZ0xCUEo5NjJIVnRFbGI5OUxQZXlsdC84?=
 =?utf-8?B?aElML1hBQVdRdEtNTVIxQ0cxTmM0VHZsbHF5ZTVraGxsWHFFQVFST1Y0S09k?=
 =?utf-8?B?aXJjZVVBK3Vrc2RKdnpFV2VsM3ExWUtBMWh6dGRHVTNPclFOTlB2RVJlZG9n?=
 =?utf-8?B?UUF2eEhrNDRLU0IrWmJHaEVYRDh6dG1RUUZIQWV0WmZMTW83QjZobXBGODBT?=
 =?utf-8?B?Qm5zUDJrWkw3MGg3RlBDTnorK04wS1YxU3R0NEgxSC9xMktyUGcvNDErMk9E?=
 =?utf-8?B?NkFEUTk3RWNQSDJiOFk5dnRadUJlWXdWdU5aYWQ0MFdyZ29GNzZCUUJnUC9D?=
 =?utf-8?B?Q0JCaDN4Q3h4bTdCQ2NjOHFuNnZjeWdBbjVnVVN2UGRjMVZoQ1Q4UEZpTG5P?=
 =?utf-8?B?dzk0bzE4U3VKWUFqUVI0alQwVXJyalp3NjlBVVpXYUQ2cUViQzNiTUhHUEpm?=
 =?utf-8?B?WTBtN2xoY3NSMzRraWRzRlJkYmVQaWk5M1ZCWFFUdzk4cmMrVU1LUlZ0bFZh?=
 =?utf-8?B?MHVTdCtMVmF6NXJRV3ZLWVVQZ3ZkREw3U3pqVWsxNDQrOUJ1SkNSNVV0eUdW?=
 =?utf-8?Q?SPn8OWjlJhQIlgk+hVayvZMU0QuPuH14NhlcpYsLaI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4ED32F7784C6464E8ED4F390BB6126CF@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bab78f09-0fab-4c7c-f492-08d9f240fd0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 18:11:58.6037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wKj/sZOxHEgPeFwwjs5FVs1LNlc9m47d/gvJcLAT2q910IuKyWSsJzDW06PEobyhjC490L+YdHFsFonRwZR9GZLruMuo3twahm2pVjUDQ8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB1962
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzAyLzIwMjIgw6AgMTg6MjQsIEpha3ViIEtpY2luc2tpIGEgw6ljcml0wqA6DQo+
IE9uIFRodSwgMTcgRmViIDIwMjIgMTY6NDM6NTUgKzAxMDAgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+ICAgc3RhdGljIGlubGluZSB2b2lkIG5mdF9jc3VtX3JlcGxhY2UoX19zdW0xNiAqc3Vt
LCBfX3dzdW0gZnN1bSwgX193c3VtIHRzdW0pDQo+PiAgIHsNCj4+IC0JKnN1bSA9IGNzdW1fZm9s
ZChjc3VtX2FkZChjc3VtX3N1Yih+Y3N1bV91bmZvbGQoKnN1bSksIGZzdW0pLCB0c3VtKSk7DQo+
PiArCWNzdW1fcmVwbGFjZTQoc3VtLCBmc3VtLCB0c3VtKTsNCj4gDQo+IFNwYXJzZSBzYXlzOg0K
PiANCj4gbmV0L25ldGZpbHRlci9uZnRfcGF5bG9hZC5jOjU2MDoyODogd2FybmluZzogaW5jb3Jy
ZWN0IHR5cGUgaW4gYXJndW1lbnQgMiAoZGlmZmVyZW50IGJhc2UgdHlwZXMpDQo+IG5ldC9uZXRm
aWx0ZXIvbmZ0X3BheWxvYWQuYzo1NjA6Mjg6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19iZTMy
IFt1c2VydHlwZV0gZnJvbQ0KPiBuZXQvbmV0ZmlsdGVyL25mdF9wYXlsb2FkLmM6NTYwOjI4OiAg
ICBnb3QgcmVzdHJpY3RlZCBfX3dzdW0gW3VzZXJ0eXBlXSBmc3VtDQoNClllcyBJIHNhdyBpdCBp
biBwYXRjaHdvcmssIHRoYW5rcy4NCg0KTG9va3MgbGlrZSBjc3VtX3JlcGxhY2U0KCkgZXhwZWN0
cyBfX2JlMzIgaW5wdXRzLCBJJ2xsIGxvb2sgYXQgaXQgYnV0IA0KSSdtIG5vdCBpbmNsaW5lZCBh
dCBhZGRpbmcgZm9yY2UgY2FzdCwgc28gd2lsbCBwcm9iYWJseSBsZWF2ZSANCm5mdF9jc3VtX3Jl
cGxhY2UoKSBhcyBpcy4NCg0KVGhhbmtzDQpDaHJpc3RvcGhl
