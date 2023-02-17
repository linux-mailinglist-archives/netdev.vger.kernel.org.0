Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF69569AF84
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjBQPak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBQPaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:30:39 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AF96F3E7;
        Fri, 17 Feb 2023 07:30:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZKaL8ndOJpBgqNRe2yflHLWngxHCz/xKvt4X2AXpBve5To60eBABbDKTb6V3VenKjywOogvKs1+o/+Ci4xMB3x9OVAO48BexpG6LMyVW0GUkFGhk5xhxwdCr25M4RVgBakHzWA6hquPRKEhuieh7N2jHS7E0rKFAloq1hJh6BgMOA5YlY2WUxDPF3aFoD1bk6Tt8ymvt1mziODWvBhTRLNLU6WPc+lBp1XE7hdqJSTFdUWlyYdx3pGPaJz2wduubdf/PBfrwyYW3PV11P9FF8ocfbNU0YGGgPFpeWpJVY6xhOCX0PuhXqfMflJFCnLfc6BtIk4REaz1AZCOlw37TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZAEIKjVJoXqMJFK7dday+CqWzEG4xB42J1RT4rm8FU=;
 b=WpAFcnS92wl6f8qjRRBuPTpgafKG8HClpGjrFc1M+Td7N95OG92AL5tXvozIUdH/y8vo62vGRRtBnTiwFUegZdtAUwJzz2hwZ+ZaNROi/2UWYjNjmWgE0gLbk0EPtF9WmD9+Thdh3Bgd/QZKsrdMI+bUFLeolI7ErsPJlZtd/dLa9OD5IoVgMf2U9hx774wP0nMgQjN3cQnETyn2H/RvQS8LFGDKPxZF1DY4QmhLCskBhEWKKHkittJ5t8gpjSjIZG5pOE728YRl6xjfAaXlvEA18b71Jgj+1F1aUDTlzI/YZbKDV1X33PgL87/txfXXriMYGh/w93RRUvgl5TSKNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZAEIKjVJoXqMJFK7dday+CqWzEG4xB42J1RT4rm8FU=;
 b=cQqQbcsh0vUudnLYCoptuBQCa1mc7GxRc2CmpQWzCO0p/MS8PQzIP2NiDBTyWz3VYMF64veLFSDrbaUq1PfTQrDK/WuONOE8BjfnhvC1H6IMD0CvBd9H7JH+ziOEkg7Lms/ZDVfM4SlFUiwceJvy86Wu8RP7EClOFwwj7EDklpw=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CH3PR12MB7739.namprd12.prod.outlook.com (2603:10b6:610:151::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 15:30:32 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 15:30:32 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Thread-Topic: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Thread-Index: AQHZQrnJAHNEhfVI2kSybI2yGNc3I67TN/+AgAAJLACAAALGAA==
Date:   Fri, 17 Feb 2023 15:30:32 +0000
Message-ID: <DM6PR12MB420241B35AB4B8846AB4F568C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
 <ef38e919-f7ea-0b11-f5d5-2eb4fb665c72@intel.com>
 <DM6PR12MB4202D1FA796BF66E6AD4C6C0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB4202D1FA796BF66E6AD4C6C0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4579.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|CH3PR12MB7739:EE_
x-ms-office365-filtering-correlation-id: d2a106f2-b325-48b0-4233-08db10fbe84d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26df6N3wBwoBEXfZZg0uGWK2e4GKAeZKva8ffu5TThnyrjMNu5z2p72744FlphWj8Q+5NQOVcO+Cp+vf841T1ifOLsk0CquEDh5baVyciIdXqwyyVmhKMQUvn2+yIt5y/8jZmCX0pCXVZ7PyI5EqEc2F3DmDySGxDUuJriYGoQNflOBMyjViIVug5XslTZzSgIMIVpFjKmFlSsB0MhdVzdz6GsmEBVQidR6dofSHBXs74QavUQx+ucEZK3E1eFemJimYk9wiQgixzlKxo8tqYZkEpuf0DCZRB6GTT0Q1Sq9JAMQvHY0SVVP/msgmCRjnt+DUlKTxZf9ygr3AY6wdu4qYyd13wScHsCTnxTSiBZOaJ5QaUgBPZB/u5wWObvhIrywZQl9TIQEuV71yz9xzZLYgXTuu8+M7qHF1cKY3aVwR6zb75XQCBWM/KEzW5mFWKxX9/ZdH7T8mFvrBas1KGV0gNUBHB6lvn8BIH//ZaAJbfIBDC/pn/MMibT8U9ar8QCxtyYTtcjeMx6hHXlRMKBKZdVTjxwq/NkZk8rl3NYmoyk85eQuj6nzmn7059tX4ejoA3F4MO4/AJno1DCEdaJUDvDavWVDEyNFhW4TB64w9Wxza2cIy6RsRYYhQnqsgercq30TZ1mShNHfL9CESoBHbPArNq676OPNb0vmO6imUtSf/3O/4agrtY6tOpd64HnhZ0GR8w+mUWZ73lAeHWfupfFdqRCg4W2KcNa1iizDJvLwkip1/o/rKb6DHFxcp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199018)(38070700005)(2906002)(122000001)(38100700002)(966005)(71200400001)(7696005)(110136005)(6506007)(53546011)(2940100002)(26005)(54906003)(478600001)(186003)(33656002)(55016003)(76116006)(66946007)(83380400001)(8676002)(64756008)(66556008)(66446008)(66476007)(316002)(9686003)(41300700001)(52536014)(4326008)(8936002)(7416002)(5660300002)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGV6QlB6ZzZXN25SOVc5ZEZTZjJIZlNnUUJXWFBmeGFudGZPYnZBdG8wcmRC?=
 =?utf-8?B?M05vaU5PZTdTdkd0VWRacTJtVUd6N2ZFL1BkSVFEY1VaYVdka3Y2emZMUUhZ?=
 =?utf-8?B?d1pXNTZNRmowSWp3MHhhVUtmYlBaQjFSN0N1RnhXcGw5R2JLR3RlOXNGYmd3?=
 =?utf-8?B?bHJYY0pMSnE5K1Ivd0ZyREpHN0c2d1Y5M0VxVEpoMi9ralNZRVpMZEFidDFJ?=
 =?utf-8?B?ajUzSDNHVFNmazZnS2dUTzRZSjdMK1ZzOG5yaWx0MzVUdG5FaXYxeGhkQ1Fp?=
 =?utf-8?B?WnE0RDNSRC93MldOU3BjdFBFaU9RRDVTc3RFdEtmUFNKbWRGNk40c085Wlov?=
 =?utf-8?B?NWl5aDRESVcvQlZrclMzQ1ZPeHNIOHgxalVYTVVncGY3YmNHVVRXSTd1aVRp?=
 =?utf-8?B?K0JTeHJkMXVRQ3hwdld0SXVsVmZHeHpwbzFFOE13WnVZeG1MNThrYzVHbHQw?=
 =?utf-8?B?ajlORUl0dHRkQ2cwU1dDd09LT0Z5dXNFY2Eycm1BMTRSVTVhOVBKcyt0eXhw?=
 =?utf-8?B?QVA4ZjQydUQ5Z0s4eEowbEpZNlQ5KzBnK0p3UGFSeGZycHNsaHY1Q2dKRUVT?=
 =?utf-8?B?WUV3bmVBR0JZWjhVWC9mUUpOYUJOODFBZ0E5bWI4OEZyeFlJK3NERGYzYmZy?=
 =?utf-8?B?b3h3WUpHclE2UENyenl4T25JS0h5ZURINWZnQkFMOXJQOFJteFdtN1IrS2xN?=
 =?utf-8?B?M1diMlFVdUhvN2VkYmlFaitxbFhsMTdBMzZ5VEpia3RvUGJHUzJ5aGF1SVNu?=
 =?utf-8?B?N3plbWIwMitkTlpVUGJGVjN3ZHQ5SkpnVk44a1dQVWVQbGxMMFJoSXl4bkMy?=
 =?utf-8?B?N1QvVjk4M0ZEb0dIbkFvU1pwdXlaUnY1ejVLNllxd0NvbnpLZGYvTkV6dEY0?=
 =?utf-8?B?cE52SEIxSmR4aGlybzhIRHFEVXYrTjBPbVVPdHQzeitvSXM3S0VlakYyUWps?=
 =?utf-8?B?cCtGRmszNXdyVzcrWlF5ZVdUYTF4T0VTMGJiS2ZZRU8xQndPZnRjcjRGeEVk?=
 =?utf-8?B?NTkvdklTaktvUm5XTG9yYWVBcVVPRGk5RnM4VUo0ZW1KTXl1WlUzdEJHSjVo?=
 =?utf-8?B?TmJPd2xoMjJabndIeVVzNTVnU2l0dUNNT0l3V1hRSkJsMXZUM29ISkx0Ny9P?=
 =?utf-8?B?ekdva1J5RFpHa25EVVlYOE9vTlBaa3hLYWlad3JGR3dOVmZENmVlRnkxVnNF?=
 =?utf-8?B?a2ZpRW9TVC9nVC9pTDFQNWlUV21keEhXZ092cHk0Ry9EVkF5eWNMUDBQN3ZL?=
 =?utf-8?B?UVF5bnhKd3VtNSt4K0JoeWRRSlBRZDBvNG45a0o3MC9CVkVtT3hNa3NQdUxz?=
 =?utf-8?B?SGkrYk1ubnU3MmhDc1RxOCtmaytjNGlVV21lZlhvc3hubm41TU10dmR5ditC?=
 =?utf-8?B?Q1hpLzRjanVTM0Z1L25qck5GSUlhaWpvVDV4Wis4NnJ2OElmZ0VtUDdSRTVO?=
 =?utf-8?B?MDZmRFdMTm41djc3Rm15THo3VFFFS0R5aE1PV0ZZZEhvamJrbytndWJvQjRE?=
 =?utf-8?B?SkFaWktIbDJPcjh4UHB5YWV6SlJ2cXNXNXM0RURoTmlUb3F5YXVsTThqdnd6?=
 =?utf-8?B?N1VrVzdncVp2bmdMT0ViVTJVYk5oTTljUmpqUnZpcmV6WEp5K0xicS9LdWJ1?=
 =?utf-8?B?UkxySDdDMk9lV0NhWCs5cUphNDUwUUtueWRRYzlrOXFXS2tWaUpFVEZQMEt3?=
 =?utf-8?B?WXpVTkVlMEVNbElEZ0V4Skl0ZWs1cUVENFAzREMxZkJXOFJreGpHcDZKbjBk?=
 =?utf-8?B?eU5tYlgvWEk1MjMxdlNjcTVmdnd1eTFjelNvNm5NbzBORktQQjZNZWtHYmFG?=
 =?utf-8?B?TE1MOFBiMW9CdXN5enNjdG95MnE0cTVOaTdHalhqMUZiSFdVeWxZMTdKcUww?=
 =?utf-8?B?REgrOElGcENFVXI1TmFmK1BUUDIxZXNNL1RrZU1kamg0d2FJcGdCNHBKUjZH?=
 =?utf-8?B?VlNkQS9oY1VFck14NDBobnEvaS8zcUJzRHY0VUc2NzBVRUVzM0RzcTRHRUhP?=
 =?utf-8?B?a2FhNzErald1eEJoMUFxS040RGJXWXUrTkdZenJQbmsrNFBKbS93b0tHcEh3?=
 =?utf-8?B?Qkh6Sk1lQ2NlQzE4YzlqS3hFYkpNZ1ZmbHlJUjV3NDFEU0M3MXkrOGJ4Q1h2?=
 =?utf-8?Q?xaCc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F756A7D55780C740B08BFF7EFF306F01@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a106f2-b325-48b0-4233-08db10fbe84d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 15:30:32.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXxtteTvaew6PSC+Gi/gZblWgZyLFFrLtRunQW/+3uU/1i8oTJpF5j7ipJ+eoSXFsy3ys5kd2JrTYuqUGJnF0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7739
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QlRXLCBJIGRpZCBub3Qgc2VuZCB0aGUgbmV0LW5leHQgdGFnIHdoYXQgSSdtIG5vdCBzdXJlIGlm
IGl0IGlzIHJlcXVpcmVkIA0KKEkgd291bGQgc2F5IHNvKS4NCg0KU2hvdWxkIEkgYWRkIGl0Pw0K
DQpUaGFua3MNCg0KT24gMi8xNy8yMyAxNToyMCwgTHVjZXJvIFBhbGF1LCBBbGVqYW5kcm8gd3Jv
dGU6DQo+IE9uIDIvMTcvMjMgMTQ6NDcsIEFsZXhhbmRlciBMb2Jha2luIHdyb3RlOg0KPj4gRnJv
bTogTHVjZXJvIFBhbGF1LCBBbGVqYW5kcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNv
bT4NCj4+IERhdGU6IEZyaSwgMTcgRmViIDIwMjMgMTA6MjI6MzYgKzAwMDANCj4+DQo+Pj4gRnJv
bTogQWxlamFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tPg0KPj4+
DQo+Pj4gQWRkaW5nIGFuIGVtYmFycmFzaW5nIG1pc3Npbmcgc2VtaWNvbG9uIHByZWNsdWRpbmcg
a2VybmVsIGJ1aWxkaW5nDQo+PiA6RA0KPj4NCj4+ICdFbWJhcnJhc3NpbmcnIHRobywgd2l0aCB0
d28gJ3MnLiBBbmQgSSBndWVzcyAiZW1iYXJyYXNzaW5nbHkgbWlzc2VkIiwNCj4+IHNpbmNlIGEg
c2VtaWNvbG9uIGl0c2VsZiBjYW4ndCBiZSAiZW1iYXJyYXNzaW5nIiBJIGJlbGlldmU/IDpEDQo+
IFRoaXMgaXMgZ29pbmcgd29yc2UgLi4uIDpEDQo+DQo+IEknbGwgY2hhbmdlIGl0Lg0KPg0KPj4g
KyAiYWRkIiwgbm90ICJhZGRpbmciDQo+PiArICJwcmVjbHVkaW5nIj8gWW91IG1lYW4gImJyZWFr
aW5nIj8NCj4gUHJlY2x1ZGU6ICJwcmV2ZW50IGZyb20gaGFwcGVuaW5nOyBtYWtlIGltcG9zc2li
bGUuIg0KPg0KPiBCdXQgSSBjYW4gdXNlIGJyZWFraW5nIGluc3RlYWQuDQo+DQo+IFRoYW5rcyEN
Cj4NCj4+PiBpbiBpYTY0IGNvbmZpZ3MuDQo+Pj4NCj4+PiBSZXBvcnRlZC1ieToga2VybmVsIHRl
c3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+Pj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvb2Uta2J1aWxkLWFsbC8yMDIzMDIxNzAwNDcuRWpDUGl6dTMtbGtwQGludGVsLmNvbS8NCj4+
PiBGaXhlczogMTQ3NDNkZGQyNDk1ICgic2ZjOiBhZGQgZGV2bGluayBpbmZvIHN1cHBvcnQgZm9y
IGVmMTAwIikNCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8u
bHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+Pj4gLS0tDQo+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc2ZjL2VmeF9kZXZsaW5rLmMgfCAyICstDQo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMv
ZWZ4X2RldmxpbmsuYw0KPj4+IGluZGV4IGQyZWI2NzEyYmEzNS4uM2ViMzU1ZmQ0MjgyIDEwMDY0
NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+Pj4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMNCj4+PiBAQCAtMzIz
LDcgKzMyMyw3IEBAIHN0YXRpYyB2b2lkIGVmeF9kZXZsaW5rX2luZm9fcnVubmluZ192MihzdHJ1
Y3QgZWZ4X25pYyAqZWZ4LA0KPj4+ICAgIAkJCQkgICAgR0VUX1ZFUlNJT05fVjJfT1VUX1NVQ0ZX
X0JVSUxEX0RBVEUpOw0KPj4+ICAgIAkJcnRjX3RpbWU2NF90b190bSh0c3RhbXAsICZidWlsZF9k
YXRlKTsNCj4+PiAgICAjZWxzZQ0KPj4+IC0JCW1lbXNldCgmYnVpbGRfZGF0ZSwgMCwgc2l6ZW9m
KGJ1aWxkX2RhdGUpDQo+Pj4gKwkJbWVtc2V0KCZidWlsZF9kYXRlLCAwLCBzaXplb2YoYnVpbGRf
ZGF0ZSk7DQo+Pj4gICAgI2VuZGlmDQo+Pj4gICAgCQlidWlsZF9pZCA9IE1DRElfRFdPUkQob3V0
YnVmLCBHRVRfVkVSU0lPTl9WMl9PVVRfU1VDRldfQ0hJUF9JRCk7DQo+Pj4gICAgDQo+PiBUaGFu
a3MsDQo+PiBPbGVrDQo=
