Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F90B65EF96
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjAEPCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbjAEPCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:02:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229FBAE70
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:02:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk57PNEoeM1tyWEsnT9Q60ZNUJhrIwGSJDkvmvHjXOthe7gHt158suMwzDQdB+nC9J/G6sV456ishlOa01h84JymeoB8buWiMg1+SSWtdWuxj4TCXFI2/ptyoellBtT3bpONoodW/J1Hf2/AJMFmHsabVzdTqsEv8yBdsSNTsX/RCIxmcNM7e4jQFJtdmuNV2Y6NyiPdPAn+JJPQt/v9Z9n6mqXKCQvNbMSLZbgoJQEKPYF8Qga/Yk+I2aVJOabT3ENsvto1JOBhpg9ZOGRwsyGvmvqyxu1bP8zKTX8gjslwvdPkXSaCTA/0+jiygfZOrWbbCxsgPj6KryWyheDFWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ex0NCiRfJfdnxCcpPhlmUj20Af54a6afdrneJXmVo0M=;
 b=liqzONZ0fcUQ7JISnEdXwAfCo3oiBLiyrZSw256OH9h0THND2vsH/r6XLH8U/JFkGzPdwbJD/XGuxwEj854fN6hGH2DkxNz6DCdg2X2705QMcJ3oAV1xqLR9cD7e0coAIY4TA06CRhUoyeUFIpY/rXLEF7nAS9gwzdqPNeaipJ1nkyxzZ37jxfD9mZLaI30oiE3u97UAE+HzaTgT1fBVVqPqbI13DNUH4H47JQ/YXIAFkizXxFwe73qDSC08OOOfHnfgHy0uPh5bwYWgAss5UWUlHBE4Xv/zPImfEzzDu4YECxV2qzXKAy5OU2hqbjSkUB04YOOzAXvUiH5zY1GOqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex0NCiRfJfdnxCcpPhlmUj20Af54a6afdrneJXmVo0M=;
 b=kHDC+WKs0Y07jp4YK7LjG7b5roqABNOfaKkS+WkoipRRNex5Lm9Xh+zPegAEbKwr8iWdQHQNueFPT9ChHNNoib1mM2x80ibQmixZbSDBMNlknf6IYXUerhGECwVhusu8lmMun+fGFhQQrQ4TKl0LbzdQ4I2PT2qfkIMMb4S9hrF69tYtAy4bWcheqpjGEKjGVPVx3aBmi6oWwnTaMO9aJLD4AQuuVpvugkqxc/z1e9hkZnZUcNW0LT5OT5osMUw4IzoiCbsWjfrdcxydlv2juWor9UEQL7KIbDV8Rf8odERAZ+RYcroyLQhqm8ABTZeI26khfDpuIfm+r+PPXma1Hg==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SA1PR12MB5639.namprd12.prod.outlook.com (2603:10b6:806:22a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 15:02:07 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 15:02:07 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [PATCH net-next 0/2] Add support to offload macsec using netlink
 update
Thread-Topic: [PATCH net-next 0/2] Add support to offload macsec using netlink
 update
Thread-Index: AQHZINxpgD0SLzUGf0uz64GBgtaDj66P25cAgAAPaFA=
Date:   Thu, 5 Jan 2023 15:02:06 +0000
Message-ID: <IA1PR12MB6353778987E1DBFA4B3489D2ABFA9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230105080442.17873-1-ehakim@nvidia.com>
 <Y7bY+oYkMojpMCJU@nanopsycho>
In-Reply-To: <Y7bY+oYkMojpMCJU@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SA1PR12MB5639:EE_
x-ms-office365-filtering-correlation-id: f88ba1e8-bf7e-4d17-09a3-08daef2dd020
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IwJGCCGN6ah/E7vXBNCSO+ZAuGo16BI1RfKgFWvrUgHJfZwesy1404XKMusMoWn8X+vGCFuRL+ae9zFwFPxcr2NJqbGNakI2bXjaiGPoLcYNgJ3CuQsDFNOSUO83twgBxh1Mp6+Y+EeJsqjjgf6yCv3ZI5uQsVEA+K0b+neSdCHRYyTUWaoQqZQWJgAWoJN74SmV10wVPd0nrd1lKxxPBShGIzA3DxcR0+yHJCPv53c4JYnTDSXtSCKnuLZfCMoPT1R/0cUpMXul2kLPXmqH7d1xfLOTEg36ZGc3XBq1qFFOosG1sm4JRrDrWjo6Y4sA2a+pOydXdd6ni8tnvgM4TFmqFVf9+K8Hi2+173Dt66bCBbxam8pZ02vPfCL7algAhYm5wWKxv99Yq8P+GwFPgsc5BViUB0tHorOQMedR1/WCu6+5d44+Zxbq02koobMgRGTrftve9Jf3cpPKGShbvSmnVusk8CAHFXNzvJCDxJZ4DPnbqxHTgLP41VKM7bMTZp5/1pbPswePIh9EWFo+p9B4T1UDWmJctthu2Wp/EGgXZa1652nDvPpPSOR/2LyPs0Pupwegti757CR8MUDSPLvwC99OhR+MtYFVzRGs0D1GwvEm52fWnrhsTWRiOGrE4yN0Abc6D9CLkDe7yHWQ+FyVLVJ8HWBzk8xnd8X+zpPeAhNXyJuiM+ZM5z5OM+8ze472YFBpPIaR2DOjCrhCLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(38100700002)(33656002)(2906002)(5660300002)(15650500001)(8936002)(52536014)(41300700001)(83380400001)(122000001)(6916009)(54906003)(71200400001)(66556008)(76116006)(66946007)(38070700005)(86362001)(7696005)(53546011)(66476007)(4326008)(6506007)(26005)(66446008)(64756008)(9686003)(478600001)(55016003)(316002)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWswT2NSeGhtRHhYRmRJWER1RElOVi94dTdZWXk3bEswNlQxSFVOWkl2ZU5W?=
 =?utf-8?B?UW5kQTA1dkdQRVhoQno3VkNwVmNlMnV4Vk9OTVNtU1hqQ09rSGdIVkZ0dmhh?=
 =?utf-8?B?WEZxM2ZhQ0c5YnRWM055aU93ZWplQmt4OE9NV1ZVTXluNklWanV6SmR3NnB3?=
 =?utf-8?B?K3llQzc3cmJGcjI0TVFSaW5PT3Uxb2Z4QzVPR044UzlnbHRmYUI1bmo2elAy?=
 =?utf-8?B?VzJLN0FuVmhKcUpkVThBVUpSN00yR052cHFhSzFENzVXcW9EYmg5OWVmNnht?=
 =?utf-8?B?dmxrSjdiR0JpSVNKWEZiSktNRjBLWWh2R0YrMkJTM1pDUElwSSt5OU5BU2Q3?=
 =?utf-8?B?TzZlYVpLdjVuc2JwOXZ0c0RjSnhCdlQzcVRIcHE0TWFHOGxpc090dEVJbTFj?=
 =?utf-8?B?eXorUUVzbE5CUm9XZGVPNnBVN2QwdUwwZVBEMUdvZnRzZjdHNlExa2VUbHc1?=
 =?utf-8?B?a2xDcFczS2JSYUxWU21CY1lEYlNOV2ZNaFdrL2hHOXFxMHVwMGVUQk84R1VG?=
 =?utf-8?B?cndyalVEazBzMXdlY1JwS0c3bkZySFdwZDBWOU1qUUJVY2RzR2tVcnFMcTJM?=
 =?utf-8?B?OGNZN1FUWCtveUlQNVQrWVpnMFd0NjNpaTFrT2JrZnhjTFhIK0dBNjE3SmhE?=
 =?utf-8?B?VTJzZ3lDNVBERHlubVNtL3hvbnM5Q3FXc2FvY1Q2RXgwNnRrWVdwZEZhWHlQ?=
 =?utf-8?B?QmgwWlZLWFcvS3pDd25nbjRNQzJxNytWd3FkeU9WOXZPZkY2STZDQXBMUXpZ?=
 =?utf-8?B?eFNaa0JZL2szNjVlWnFPWTYxcGZPSFlzc2ZlSnluV0RwRHljZ3VyWGUyVWhN?=
 =?utf-8?B?MzJyUS9KaHF4MUNkMjljWVgxRGZzSmN0cVRDTCtJUWQ3SURXT0VDelVrajNO?=
 =?utf-8?B?c1c4UGtkWlVKQ2lnTVlqWGRmcnNIbVc4VzBSUjV2ZEpNNVVrUXE4V1VYdnl4?=
 =?utf-8?B?ZHBYWTVGdE91TythZHZZdXFUN2JveGY1eURtOGhENDMwN29HZUlYTTA2Qm1G?=
 =?utf-8?B?VWw2aGY1L0ZyUEdMVXFLemhIUGVOV3JVWVB0dDVlYkdpRFFXQ3JGeFNudEs4?=
 =?utf-8?B?bGJHUGE5SXpnR0pUN0lKZ21uM2hhMG90MGc1VTdWazRBWDZsK016cXEwRTI1?=
 =?utf-8?B?eUZQM3B1ZGdhM2svc1RjVDdTbTNLODR6YlBqSTdRZ2NyZmtBMUNFT2tkalZG?=
 =?utf-8?B?WjhCNkw5TmpYZ0czUDhEbTgyV3VZSWRqU2tzaysrVnpTRmlWRGNRN0lhVCt5?=
 =?utf-8?B?RXdBQk5nM05WVXB3YUp1RFB1eHJVeVFiWng1L0xVRXpaV2dIb2RrQjM0bVJz?=
 =?utf-8?B?b2ZXSEluckltZWZyKzBhanhGd09TYm16bXFhdlplajlPWjY3RjFzNlRkZDRJ?=
 =?utf-8?B?VEh4b1FIRHZqS2o2aXVvZGl5SGM1MlIrVTRVYUxBTndFRkl4M2VPSEN0WUhI?=
 =?utf-8?B?cmhNVmJjeW5DSko4VTBJSEE4YkhsT2FnVGUvOFM5WU5SZHc4bVlEOC91dDlB?=
 =?utf-8?B?V1ZFTW5ndW5sZzJaWXNCakJLanhLUWQrV1UyaS9qM0RleXlzbktsbjJheFkz?=
 =?utf-8?B?VG80UHZYc3RLaXQ1QnQxNzVkZVhVQjhkTWFyVXJVY1haaWN6Ujd0ajQzNWw2?=
 =?utf-8?B?V0VWQkg5c3lIVEpReXY4NitPaFl3ZEJEa2sxeldldVRkWEhXODllalFONVlj?=
 =?utf-8?B?bWg4NHM3RFMrQlJKOFYxUlJTekRPSGZYc1F6K21WaW5LcVk3SkNlVXJjc3RX?=
 =?utf-8?B?K0RQb1BtTE0wZktSR2QrQXdHZ0dyeTNDeDVMRWdHTnVnWXRwNSt5c2gzV1pV?=
 =?utf-8?B?RC9FL2xMRStPS2tiK0gwUUlxVmc5MjJoeHp5ek9kZUl0aU4zOWcvaTg1UFpL?=
 =?utf-8?B?QnRJZVFqVjBhUkZ1MlQrNGduOWcvYUNlWHFKc1NlTEtxU1BUb2o5SERmSTJo?=
 =?utf-8?B?N0FuREVLTUt1STk5Znh4cXo4bE5DNjl1bm5pU0I1ak5xZlQ2L1JCY2ZER1d6?=
 =?utf-8?B?ZUZ0elR4OGRFK0x1Vm4yQ3I1VGFPYXNnRVV2b0VDeDNOaDlvak9OTGRvNURq?=
 =?utf-8?B?UlhsV1JPNURZdks0NFVWd0swMlpXcVNNYThhVzduTWM2TXdvcVdZRDJQN0M5?=
 =?utf-8?Q?1Usj6R9T4X61+FxaA+yMKfVGX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f88ba1e8-bf7e-4d17-09a3-08daef2dd020
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 15:02:07.0048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blJgyHEjUSGazojXj8WA8gJu2jL7yHshpNhN+/oYoqj0uIIP/eZc/h4FZN3GI3PFELv0O/B61e1w4XGCbiA8eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5639
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmlyaSBQaXJrbyA8amly
aUByZXNudWxsaS51cz4NCj4gU2VudDogVGh1cnNkYXksIDUgSmFudWFyeSAyMDIzIDE2OjA1DQo+
IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBSYWVkIFNhbGVtIDxyYWVkc0BudmlkaWEuY29tPjsNCj4gZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlA
cmVkaGF0LmNvbTsgc2RAcXVlYXN5c25haWwubmV0OyBhdGVuYXJ0QGtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwLzJdIEFkZCBzdXBwb3J0IHRvIG9mZmxvYWQgbWFj
c2VjIHVzaW5nIG5ldGxpbmsNCj4gdXBkYXRlDQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNh
dXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IFRoZSB3aG9sZSBw
YXRjaHNldCBlbWFpbHMsIGluY2x1ZGluZyBhbGwgcGF0Y2hlcyBhbmQgY292ZXJsZXR0ZXIgc2hv
dWxkIGJlIG1hcmtlZA0KPiB3aXRoIHRoZSBzYW1lIHZlcnNpb24gbnVtYmVyLg0KDQpBY2ssIHdh
bnRlZCB0byBtYWtlIGl0IGNsZWFyIHRoYXQgdGhpcyBpcyBiZWluZyBzZW50IGZvciB0aGUgZmly
c3QgdGltZSwgYWxzbyANCmRvIEkgbGVhdmUgdGhlIGNoYW5nZSBsb2cgb2Ygbm9uLWNoYW5nZWQg
cGF0Y2hlcyBlbXB0eT8NCnNob3VsZCBJIHJlc2VuZCB0aGUgcGF0Y2hlcz8NCiANCj4NCj4gVGh1
LCBKYW4gMDUsIDIwMjMgYXQgMDk6MDQ6NDBBTSBDRVQsIGVoYWtpbUBudmlkaWEuY29tIHdyb3Rl
Og0KPiA+RnJvbTogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiA+DQo+ID5UaGlz
IHNlcmllcyBhZGRzIHN1cHBvcnQgZm9yIG9mZmxvYWRpbmcgbWFjc2VjIGFzIHBhcnQgb2YgdGhl
IG5ldGxpbmsNCj4gPnVwZGF0ZSByb3V0aW5lICwgY29tbWFuZCBleGFtcGxlOg0KPiA+aXAgbGlu
ayBzZXQgbGluayBldGgyIG1hY3NlYzAgdHlwZSBtYWNzZWMgb2ZmbG9hZCBtYWMNCj4gPg0KPiA+
VGhlIGFib3ZlIGlzIGRvbmUgdXNpbmcgdGhlIElGTEFfTUFDU0VDX09GRkxPQUQgYXR0cmlidXRl
IGhlbmNlIHRoZQ0KPiA+c2Vjb25kIHBhdGNoIG9mIGR1bXBpbmcgdGhpcyBhdHRyaWJ1dGUgYXMg
cGFydCBvZiB0aGUgbWFjc2VjIGR1bXAuDQo+ID4NCj4gPkVtZWVsIEhha2ltICgyKToNCj4gPiAg
bWFjc2VjOiBhZGQgc3VwcG9ydCBmb3IgSUZMQV9NQUNTRUNfT0ZGTE9BRCBpbiBtYWNzZWNfY2hh
bmdlbGluaw0KPiA+ICBtYWNzZWM6IGR1bXAgSUZMQV9NQUNTRUNfT0ZGTE9BRCBhdHRyaWJ1dGUg
YXMgcGFydCBvZiBtYWNzZWMgZHVtcA0KPiA+DQo+ID4gZHJpdmVycy9uZXQvbWFjc2VjLmMgfCAx
MjcgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IDEgZmls
ZSBjaGFuZ2VkLCA2NiBpbnNlcnRpb25zKCspLCA2MSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+LS0N
Cj4gPjIuMjEuMw0KPiA+DQo=
