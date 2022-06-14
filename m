Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681E454BB94
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358051AbiFNUVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbiFNUVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:21:31 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021018.outbound.protection.outlook.com [52.101.62.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B119EB1E1;
        Tue, 14 Jun 2022 13:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvRawyFULkkiUmUlu260rlbpplYI7hoGas1XNbHqyVDVGG6PUxHr3tFT0YGdN7E24qPd665fwKL9datK9y5RXp04rNUJ1L5UlNfvYMrd4528Zcu4UV55sh9Se4BJjc8AH+o4CrCQalK4Z+kiiTkEVf3iBibDW4z4ZR7583SQt0tyq63lCLWwp8iUsibOKXxKuvA4u+WRXcdofbSi8VYv/mCvr6EUfnsH4m6KdKJnctVIBDsJGWKYUlaJ2ZekCqGIF+q6cY8S/AeMGeti/SUXJL3AoEfBjUCgm5acjVpm6NNdS9CtXSI7SFY4GdDYktmp8AUEf9drHVXgP5TvABEMsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/G6yteHu9ZkRml8ppfEFFx7TQzsPpd+CXvbs2Aziek=;
 b=EshuTHVeBvTIld1PVhCOXDkXbioT7E1yurRuT8eO97yNr499kQj18SMg5bZgCsoc4YW8hxQhtN5Z68UDttRWFmut6cQGusn0vPp2FQhuNYUzsNvkXXr15VyqOl8oqmWsvIvrQ7jyMhm8PWz+IE9+4Eu40Qc5k3/ASAlH6lqDbRLiAwvAyM5bL/pyrdXI6fmd5h28y9rP9ThUt83kd7ycx4xGuaa+H8qqAahSJAMfj0myup4AEXAKe4bnno3wR8RzPx52Wu/FsH5tzdQ9h67aNiso+Jc2xXcpz2yhwAFTctuPYq17APwsIwdzqStOQBPyhfVfpOT7fcmP8YIv+6C4vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/G6yteHu9ZkRml8ppfEFFx7TQzsPpd+CXvbs2Aziek=;
 b=OVHrJF2OZB1guceIQE1DkFONKk2jdAweHN1cC1LpNto2cgLXVFc7PU0Pm8Soj/uXoXSPvneRXBNe/9gxJfS7HosKYRh0G6SEQ8ffqWFSexvwtegFvo589MvP80MWz25F246gqu/ST+zrnxDRslpPKyJ5H5o1+YmIuIkNtjd92Kk=
Received: from DM5PR21MB1749.namprd21.prod.outlook.com (2603:10b6:4:9f::21) by
 IA1PR21MB3568.namprd21.prod.outlook.com (2603:10b6:208:3e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.8; Tue, 14 Jun
 2022 20:06:27 +0000
Received: from DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::9953:f2bc:5a8b:9d3e]) by DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::9953:f2bc:5a8b:9d3e%5]) with mapi id 15.20.5353.006; Tue, 14 Jun 2022
 20:06:27 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,2/2] net: mana: Add support of XDP_REDIRECT
 action
Thread-Topic: [PATCH net-next,2/2] net: mana: Add support of XDP_REDIRECT
 action
Thread-Index: AQHYfEwK7Ctt2yGZSEquwsCxkjvkzK1Oj7kAgADKrNA=
Date:   Tue, 14 Jun 2022 20:06:27 +0000
Message-ID: <DM5PR21MB1749DCA6D96680F004B35013CAAA9@DM5PR21MB1749.namprd21.prod.outlook.com>
References: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
         <1654811828-25339-3-git-send-email-haiyangz@microsoft.com>
 <cd01402d7567184c39fc0cc884cd58232b2e65c9.camel@redhat.com>
In-Reply-To: <cd01402d7567184c39fc0cc884cd58232b2e65c9.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=652368f0-3e87-4be7-a9ee-0a58ee0b5db1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-14T20:01:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ed9f9d6-7673-4fcc-9aa7-08da4e415d46
x-ms-traffictypediagnostic: IA1PR21MB3568:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <IA1PR21MB3568CD5AF221D0DC1C12958FCAAA9@IA1PR21MB3568.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vA9wqGNuZGya9a3Y4lfqp9ng2XOUkIP6nyMh9gJvyudfmgMPiM7kpLPfQ85KCBxWfj8huzLnUnShJwELLKSOC5UfR66WCdKdXpQWUa5y2fd7VXwqGBp5DhdtovFYkoTcjr9J3hLx3iKJ6en4iQexVYCifvCLtLCRFNyVG0TNQ7/jx9MNuJOvpPkGlLQITBynqJZQgsny86mkWcowcjwGL2+f7n1CeZNfIh6vrUZ+U5Rx4xYIOXmeQnzv0xkyEuVxC000hqcOwQzX/zNz6UnLb3zmPcDpVusyinPZVTHmrbNpdCtJVrrL78/fEGzdXt9SPaSD1QmXUl0iVYR5iS2graMpG625xv3AFsa/5ItQyH8OtNqmi9ZTnVxLbTPkes1Mf6BpWsrXZpBMOWLaGfuXdNTvpdXFJacr0G01dBGNwCfBurlnrLalMqo+fxlhC87EM03mjKHRyu3izB2o8G6SpHGvHTvZ56RcVsTvwLcU/nIcuK+ZuuD4ijYAoAq7HgQIHh4Iw6+8x+IWoyiZ1d4AJaVBct0lwy+8LzBBM+aD9Sh61eWP04opvPzBA7wUpRme9to55My80gtDzJcivlb4EjsyarPGRE9d5CJO9nIl1SR77ez7UHeHyXPoNJqybsXRHYdQurwQcat8K1tj5GLiCwtH9GSxb9+SwI1yo58eNrs09YugvXv/QsTlT7YRXw5i//hpFwIBrWh+hdStLUrFT1Dz4fqImflJ2hIyKF9s2ikcpvWPs5w+QJ5N+PBx6yBo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR21MB1749.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(451199009)(38100700002)(82960400001)(9686003)(86362001)(82950400001)(38070700005)(83380400001)(53546011)(122000001)(186003)(71200400001)(26005)(508600001)(110136005)(316002)(66556008)(66446008)(66476007)(52536014)(64756008)(76116006)(66946007)(4326008)(33656002)(2906002)(8676002)(8936002)(10290500003)(8990500004)(7696005)(54906003)(5660300002)(6506007)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0VnSU1neGJPMDRqSWlYaGpKbkdMYnhoSlVGYmkwaDQxb3pPNy94L1RjSzlv?=
 =?utf-8?B?R29TcGpSdENKWU1LMjg1ZjVMd3Zuc2lMUVM5K1NRMWp4L3pLbkgrTFI5Q0Jo?=
 =?utf-8?B?YzZBWlloYnFPa296aElOaTBTVW5PdlYyZloyRWxNbzNKWHdoanZTQnQ0ZFpN?=
 =?utf-8?B?NGVPVnpGeDhnT2dtaUdjMUpxNVIyeDlkNTRLZTE2WWJtYjU3cmZYRVNrbTVn?=
 =?utf-8?B?SDNKWk45MEV3NWFRVU1Pd09jRWtkblhVY0lxb09zVkh0NUJzMy8yblNPcDZG?=
 =?utf-8?B?LzkyMC9mM0VhSi9hTzcvMEJhaHFOdFdLSmh0RThwMnQzM2VnRTFnWnlXRWFs?=
 =?utf-8?B?dnNXL3BOK0hwWkttSElJclEvZ2hJM2Q3L3U5U3dUTTZ2VVdka0hJZUMyUm1q?=
 =?utf-8?B?bldWbFl6N1kxQ1htalI0Y1UrVGdJazNySFJhSG9vYmtYaDVxdXV6YUdOL3BL?=
 =?utf-8?B?MURlSjBGUU9sWExZajJ4ZXhEanZSYmhBeVc4TlU3c3hNTzNldmJ4cVQ3dWhk?=
 =?utf-8?B?MFBXWTlwZzFTSGRBVXI1WWNyY3pJTlYyczhOTllLWDdWT0hNZ3NPQTl1QUlH?=
 =?utf-8?B?SSsxaElROWw5K2pScDh0VWtRYzlGK1luOGRPSHFmNFNKV1NKUzI4NVQvVjdx?=
 =?utf-8?B?bkt3cDNjU1JYR2FMbWZlME05cnpscndjMVpVY0tvam5WME5vU3F3a0xQKzRD?=
 =?utf-8?B?WS9oUDdEVWtkOUd0WmZqUVhXRXRpdS8waGJoYlJCay9pYnlucFZtR3c3UzRB?=
 =?utf-8?B?WjZTTFZIL0V5TStoWnlxZjhwTWhBM2tHTDgwZDhBUmZjTEsyTjR0NzRRM2M4?=
 =?utf-8?B?VVc1Z0pwUFNrK1ZvM0ZYT3FWa2NSbjNLdXNjUkNBaGJXaUZBVzJZNkdEd1po?=
 =?utf-8?B?SVBsaUZTb3lMTXlrM3cvcjV3UmhUd0JWQ04xSHNlbk5JZWNBSmtQSWl1b0Ey?=
 =?utf-8?B?Wkh1bEFvWHJwMTlyODNCNVZRdFJaYjcxa2tUYUh0TVd1RFNpaVhEVFBBK2h2?=
 =?utf-8?B?SDFOK2RVeHg1NnVrS29ZbGJKbXBxUld6Q29ZQjVscXhuWnQ0bnVNdkY0SzZ2?=
 =?utf-8?B?MHJkcEJmcThKYXZoM0hvMkNITm1YbzlRSzNUbmJUMDF5WllpRDlFTFNDeGlZ?=
 =?utf-8?B?MThEOHB2alVueVcvbGFKeG9nUkdId1NZdS9ERVRKRDJwUHlKM1QvODNZeGJm?=
 =?utf-8?B?bUdyWkJCZlhCeW5lZzhrNm5qam1JKzBKWW5yTUxlTG9rZ1h2ajYvMTk5Z0Jv?=
 =?utf-8?B?WW5hbm9WQ0VSU1Nxcnp1N084UXZpY1RSK2ViTkZKQVJBSXVCeXhPd3JWcDhX?=
 =?utf-8?B?dUQ2T3BGdWVpaVJ4QzZSQjczWmhaVnpvZkdUYkwrOXpBMHNocy9sZGtxa3k4?=
 =?utf-8?B?ZmUrblNOQkd5Y3YrYVFodnVNOVNGZ3pWNi9XWFlkMUl0WXhjVWk3eUs5ZVFi?=
 =?utf-8?B?c1REZU9hN2NjT2ZPZEtScEd5UVZCQTI2cUs1MmlPOVo0STVNenBmbmlyTm5s?=
 =?utf-8?B?U0QwR2M4UE9OV3MzSC91SElCMmtsWFJvbzRENndSVkRYNnQwL3Y0UUtOZ3h2?=
 =?utf-8?B?UWg3ZUZUR1RYVSt0Z2lIZHFucEgwcngyNFljeGhHSWRtVnUvQ0JDeGRZRTIz?=
 =?utf-8?B?bjBpdXVOUWEzYndKenp2b0RnS05jZWNweDBnWDFZVVo4SUM1MnMzQVVOcXhi?=
 =?utf-8?B?bUZSSWR3eXJqQ1BCdUNUSUxzdEFSSEdBZm04eU9OZXF0MDNKa0VRdnFMRmdm?=
 =?utf-8?B?dGJBZmh4cHMxdzlqSmFnWDUvVmpPNnFTL2k0N3cyNEJtMkRNODRURVNvRElQ?=
 =?utf-8?B?STVDMW4zTTBXVG9UeUV5L1N0QndBTEVCQ0tocWNOWmNvSWFnMGZuT2Nxdjgv?=
 =?utf-8?B?N3QvSmZXdnhnQlBhZDBKOXFBcFpNOGlIVi93QjlFODQ2WEIrcE5MKzY2MUkw?=
 =?utf-8?B?SWo0MGZsQ0VBY2NHdUlEWVA5L0lhWGJyTnpwYWRJS1BaeG1WZGxSQU5XWTZE?=
 =?utf-8?B?YVBTSVpGK1dMOThFU0NPbUp3MTlRT0o4bHFVQ2RnVHBUUllkWWk2T2xsS2Vh?=
 =?utf-8?B?ZHZydE5zTVdPT3ZZbHROaFpMMXpTZ3hOdlgxK2cycHJHRks3YnNRZlkvLzB5?=
 =?utf-8?B?Rit3NE1hbEVmUDRoOFhwcmlEdWVhYVhYaW1SQnE5NTNMVndicmt1VHk0d3B4?=
 =?utf-8?B?QTRoMU0rRmd0M2dkRWRGTGFnS3RONGNjYmFIb2JvRzF1QnJ0d2ZvQ1VBNzdX?=
 =?utf-8?B?TTlORmpkLzRGQkc5bE1uR0RYQzRaMEpGMm9jV1VNMjAvSXQyVWpaMFpsdCtq?=
 =?utf-8?B?c1RCb1hZbUxhUkN4SHNHbTBZY1ZtNFJnZ29LTkZKejF4aTJLK1ZvZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR21MB1749.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed9f9d6-7673-4fcc-9aa7-08da4e415d46
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 20:06:27.0626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hkYatADMrrZf35BfLuL5baa8d31eyixx5+zo9AhK41RZLw7nJoX+2vjJL18WS3XvV5PcN9ZchAW/eMx6w6YJ9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3568
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKdW5lIDE0LCAyMDIyIDM6NTYgQU0N
Cj4gVG86IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBsaW51eC1oeXBl
cnZAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBEZXh1
YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29m
dC5jb20+Ow0KPiBTdGVwaGVuIEhlbW1pbmdlciA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT47IFBh
dWwgUm9zc3d1cm0NCj4gPHBhdWxyb3NAbWljcm9zb2Z0LmNvbT47IFNoYWNoYXIgUmFpbmRlbCA8
c2hhY2hhcnJAbWljcm9zb2Z0LmNvbT47DQo+IG9sYWZAYWVwZmxlLmRlOyB2a3V6bmV0cyA8dmt1
em5ldHNAcmVkaGF0LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCwyLzJdIG5ldDog
bWFuYTogQWRkIHN1cHBvcnQgb2YgWERQX1JFRElSRUNUDQo+IGFjdGlvbg0KPiANCj4gT24gVGh1
LCAyMDIyLTA2LTA5IGF0IDE0OjU3IC0wNzAwLCBIYWl5YW5nIFpoYW5nIHdyb3RlOg0KPiA+IFN1
cHBvcnQgWERQX1JFRElSRUNUIGFjdGlvbg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSGFpeWFu
ZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4NCj4gDQo+IFlvdSByZWFsbHkgc2hvdWxk
IGV4cGFuZCB0aGUgY2hhbmdlbG9nIGEgbGl0dGxlIGJpdC4uLg0KPiANCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEvbWFuYS5oICAgIHwgIDYgKysNCj4g
PiAgLi4uL25ldC9ldGhlcm5ldC9taWNyb3NvZnQvbWFuYS9tYW5hX2JwZi5jICAgIHwgNjQNCj4g
KysrKysrKysrKysrKysrKysrKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb3NvZnQv
bWFuYS9tYW5hX2VuLmMgfCAxMyArKystDQo+ID4gIC4uLi9ldGhlcm5ldC9taWNyb3NvZnQvbWFu
YS9tYW5hX2V0aHRvb2wuYyAgICB8IDEyICsrKy0NCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCA5MyBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmEuaA0KPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmEuaA0KPiA+IGluZGV4IGYxOThiMzRjMjMyZi4uZDU4
YmU2NDM3NGM4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jvc29m
dC9tYW5hL21hbmEuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jvc29mdC9t
YW5hL21hbmEuaA0KPiA+IEBAIC01MywxMiArNTMsMTQgQEAgc3RydWN0IG1hbmFfc3RhdHNfcngg
ew0KPiA+ICAJdTY0IGJ5dGVzOw0KPiA+ICAJdTY0IHhkcF9kcm9wOw0KPiA+ICAJdTY0IHhkcF90
eDsNCj4gPiArCXU2NCB4ZHBfcmVkaXJlY3Q7DQo+ID4gIAlzdHJ1Y3QgdTY0X3N0YXRzX3N5bmMg
c3luY3A7DQo+ID4gIH07DQo+ID4NCj4gPiAgc3RydWN0IG1hbmFfc3RhdHNfdHggew0KPiA+ICAJ
dTY0IHBhY2tldHM7DQo+ID4gIAl1NjQgYnl0ZXM7DQo+ID4gKwl1NjQgeGRwX3htaXQ7DQo+ID4g
IAlzdHJ1Y3QgdTY0X3N0YXRzX3N5bmMgc3luY3A7DQo+ID4gIH07DQo+ID4NCj4gPiBAQCAtMzEx
LDYgKzMxMyw4IEBAIHN0cnVjdCBtYW5hX3J4cSB7DQo+ID4gIAlzdHJ1Y3QgYnBmX3Byb2cgX19y
Y3UgKmJwZl9wcm9nOw0KPiA+ICAJc3RydWN0IHhkcF9yeHFfaW5mbyB4ZHBfcnhxOw0KPiA+ICAJ
c3RydWN0IHBhZ2UgKnhkcF9zYXZlX3BhZ2U7DQo+ID4gKwlib29sIHhkcF9mbHVzaDsNCj4gPiAr
CWludCB4ZHBfcmM7IC8qIFhEUCByZWRpcmVjdCByZXR1cm4gY29kZSAqLw0KPiA+DQo+ID4gIAkv
KiBNVVNUIEJFIFRIRSBMQVNUIE1FTUJFUjoNCj4gPiAgCSAqIEVhY2ggcmVjZWl2ZSBidWZmZXIg
aGFzIGFuIGFzc29jaWF0ZWQgbWFuYV9yZWN2X2J1Zl9vb2IuDQo+ID4gQEAgLTM5Niw2ICs0MDAs
OCBAQCBpbnQgbWFuYV9wcm9iZShzdHJ1Y3QgZ2RtYV9kZXYgKmdkLCBib29sDQo+IHJlc3VtaW5n
KTsNCj4gPiAgdm9pZCBtYW5hX3JlbW92ZShzdHJ1Y3QgZ2RtYV9kZXYgKmdkLCBib29sIHN1c3Bl
bmRpbmcpOw0KPiA+DQo+ID4gIHZvaWQgbWFuYV94ZHBfdHgoc3RydWN0IHNrX2J1ZmYgKnNrYiwg
c3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpOw0KPiA+ICtpbnQgbWFuYV94ZHBfeG1pdChzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwgaW50IG4sIHN0cnVjdCB4ZHBfZnJhbWUNCj4gKipmcmFtZXMsDQo+
ID4gKwkJICB1MzIgZmxhZ3MpOw0KPiA+ICB1MzIgbWFuYV9ydW5feGRwKHN0cnVjdCBuZXRfZGV2
aWNlICpuZGV2LCBzdHJ1Y3QgbWFuYV9yeHEgKnJ4cSwNCj4gPiAgCQkgc3RydWN0IHhkcF9idWZm
ICp4ZHAsIHZvaWQgKmJ1Zl92YSwgdWludCBwa3RfbGVuKTsNCj4gPiAgc3RydWN0IGJwZl9wcm9n
ICptYW5hX3hkcF9nZXQoc3RydWN0IG1hbmFfcG9ydF9jb250ZXh0ICphcGMpOw0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb3NvZnQvbWFuYS9tYW5hX2JwZi5jDQo+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEvbWFuYV9icGYuYw0KPiA+IGlu
ZGV4IDFkMmY5NDhiNWMwMC4uNDIxZmQzOWZmM2E4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21pY3Jvc29mdC9tYW5hL21hbmFfYnBmLmMNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9taWNyb3NvZnQvbWFuYS9tYW5hX2JwZi5jDQo+ID4gQEAgLTMyLDkgKzMy
LDU1IEBAIHZvaWQgbWFuYV94ZHBfdHgoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0DQo+IG5l
dF9kZXZpY2UgKm5kZXYpDQo+ID4gIAluZGV2LT5zdGF0cy50eF9kcm9wcGVkKys7DQo+ID4gIH0N
Cj4gPg0KPiA+ICtzdGF0aWMgaW50IG1hbmFfeGRwX3htaXRfZm0oc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYsIHN0cnVjdCB4ZHBfZnJhbWUNCj4gKmZyYW1lLA0KPiA+ICsJCQkgICAgdTE2IHFfaWR4
KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPiA+ICsNCj4gPiArCXNrYiA9
IHhkcF9idWlsZF9za2JfZnJvbV9mcmFtZShmcmFtZSwgbmRldik7DQo+ID4gKwlpZiAodW5saWtl
bHkoIXNrYikpDQo+ID4gKwkJcmV0dXJuIC1FTk9NRU07DQo+IA0KPiAuLi4gZXNwZWNpYWxseSBj
b25zaWRlcmluZyB0aGlzIGltcGxlbWVudGF0aW9uIGNob2ljZTogY29udmVydGluZyB0aGUNCj4g
eGRwIGZyYW1lIHRvIGFuIHNrYiBpbiB2ZXJ5IGJhZCBmb3IgcGVyZm9ybWFuY2VzLg0KPiANCj4g
WW91IGNvdWxkIGltcGxlbWVudCBhIG1hbmEgeG1pdCBoZWxwZXIgd29ya2luZyBvbiB0b3Agb2Yg
dGhlIHhkcF9mcmFtZQ0KPiBzdHJ1Y3QsIGFuZCB1c2UgaXQgaGVyZS4NCj4gDQo+IEFkZGl0aW9u
YWxseSB5b3UgY291bGQgY29uc2lkZXIgcmV2aXNpdGluZyB0aGUgWERQX1RYIHBhdGg6IGN1cnJl
bnRseQ0KPiBpdCBidWlsZHMgYSBza2IgZnJvbSB0aGUgeGRwX2J1ZmYgdG8geG1pdCBpdCBsb2Nh
bGx5LCB3aGlsZSBpdCBjb3VsZA0KPiByZXNvcnQgdG8gYSBtdWNoIGNoZWFwZXIgeGRwX2J1ZmYg
dG8geGRwX2ZyYW1lIGNvbnZlcnNpb24uDQo+IA0KPiBUaGUgdHJhZGl0aW9uYWwgd2F5IHRvIGhh
bmRsZSBhbGwgdGhlIGFib3ZlIGlzIGtlZXAgYWxsIHRoZQ0KPiBYRFBfVFgvWERQX1JFRElSRUNU
IGJpdHMgaW4gdGhlIGRldmljZS1zcGVjaWZpYyBfcnVuX3hkcCBoZWxwZXIsIHRoYXQNCj4gd2ls
bCBhZGRpdGlvbmFsIGF2b2lkIHNldmVyYWwgY29uZGl0aW9uYWxzIGluIG1hbmFfcnhfc2tiKCku
DQo+IA0KPiBUaGUgYWJvdmUgcmVmYWN0b3Jpbmcgd291bGQgcHJvYmFibHkgcmVxdWlyZSBhIGJp
dCBvZiB3b3JrLCBidXQgaXQgd2lsbA0KPiBwYXktb2ZmIGZvciBzdXJlIGFuZCB3aWxsIGJlY29t
ZSBtb3JlIGNvc3RpbHkgd2l0aCB0aW1lLiBZb3VyIGNob2ljZSA7KQ0KPiANCj4gQnV0IGF0IHRo
ZSB2ZXJ5IGxlYXN0IHdlIG5lZWQgYSBiZXR0ZXIgY2hhbmdlbG9nIGhlcmUuDQoNCkhpIFBhb2xv
LA0KDQpUaGFuayB5b3UgZm9yIHRoZSByZXZpZXcuDQpTdXJlLCBJIHdpbGwgcHV0IG1vcmUgZGV0
YWlscyBpbnRvIHRoZSBjaGFuZ2UgbG9nLg0KDQpPdGhlciBzdWdnZXN0aW9ucyBvbiByZW1vdmlu
ZyB0aGUgU0tCIGNvbnZlcnNpb24sIGV0Yy4sIEkgd2lsbCB3b3JrIG9uDQp0aGVtIGxhdGVyLg0K
DQpUaGFua3MsDQotIEhhaXlhbmcNCg==
