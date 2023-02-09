Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E4C6905A1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBIKsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBIKsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:48:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3845F6A322;
        Thu,  9 Feb 2023 02:46:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhz27bOn/jJTmGItw2Ac5AMe38OYId2BhysZofjnmR5ks1TaPNLaiMFM9Mp+8scSH/0m7tYSp0MloJHiu4E0Gld7qiDc6qZ99hOtREWGCFLzUwrKyGiAMbDca/crMWQVULQbXsCGEQrWgPf0QNIfklbqt3VRgOliPGOp+Pc4Lapo3NL2a3sMPHOV008LYzOF3mG0BbEHHsqr2yAvQmZQvmX5lVuxx0HHbMmsJoXfJlvQPX6L53kaRaZeNtU1hVWeZo6wdLpnVhGVLt5NKqjhaKgbW8/QgLb8wmWBU9sDl+ojAjcrinNzvmDvX3S8L5CGcHkTG6sYjsLRbI9MChTqlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/blsU3Vd6rd6Ki2nIsZL/G5kx94l5/+7do9MXTi9nk=;
 b=meqoq9b07HSmxsGUenQazymhegm/yll6JtvGxPljEK/58KjLSuFcC8QmwJc+R+Zivwf24DfBDPPopMDvwgu8h4lqA+XnIMDCpW1Un+fEl19pELvXPhZv+aW7NKswe0w2l+uNKGzjCYMgCjl3ANXZSVWECwgoQAihHZdONa1hSk2n4b/zFnsAZOJ9P6ubj/YvLkaZsqpISsL4LU0Mku6FqQDbyjuV4u3HoxVRamKuq6/s555j6cgg4kiMpWK1jas6xlhiA+B1MibhAfVPesFWpYOKDtUCz3hEfyJAAGOcX5ctah5DaFYhzl+31p8VTBbHuI/SdF9WG57fc0bZSjrvOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/blsU3Vd6rd6Ki2nIsZL/G5kx94l5/+7do9MXTi9nk=;
 b=LDo+vCSObxX6X/IHXHIvcYyJI+uRBlTtyhrY9swiZgUfzvFOZXa4GC3yhZNgLvcQXJbdg7nJz0kxHY2yA7buIHwsaODSSIUDF3Z4uB7jtiKuIfd5fMIS8yitVK/DwYDzOVafgrC7UWG26DlQOv6VBGYdtYuB9BKAk9fDNCsKKdc=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Thu, 9 Feb
 2023 10:46:04 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 10:46:04 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Jiri Pirko <jiri@resnulli.us>
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
Subject: Re: [PATCH v6 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v6 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZO8k2arH7LrGh5UafCo1ruvtaz67FHpaAgAAMqICAAUR1AA==
Date:   Thu, 9 Feb 2023 10:46:04 +0000
Message-ID: <DM6PR12MB4202A784865D367996F4A3BBC1D99@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-3-alejandro.lucero-palau@amd.com>
 <Y+O0A5Bk/zWur76J@nanopsycho>
 <DM6PR12MB4202FE90A833282B28053DF7C1D89@DM6PR12MB4202.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB4202FE90A833282B28053DF7C1D89@DM6PR12MB4202.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4203.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|IA1PR12MB6356:EE_
x-ms-office365-filtering-correlation-id: 17991e00-4e7a-4f5d-b96b-08db0a8ad799
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lFcgAYqUiNJe9Fud8VMAcbOwzQI43jgkUWPxfIEfZgVsuLPuMnKbSvkir4GpTBfdRtm9SQHBjW4ETr2La7jdLIKDx5FzQtpt43zuPhEtxuWxP1O4fTQSdALZ8K+Duy8cp60sBwArUkxpGyHIRHZi95nNwJ1ejIfq7aBdQYMQQueDoxEbFvorHIS/KpPwzSb9Lde4VBq0bZbfBGOMgsZi9RexM7Z66ENvkq0eeWPjzhYraUuoerAyknKGsrkW98FpwJkniNjk1OFRY6MUnRuUWRHcTceV6bov6hZ/+EckTB9r1XgE/c6Fj0Njtz/u65Cv1y4PrJWNWOKtsi3dpdpDJimwY3+El9TZfLzmNxfBjx/l8n479KhTGSI5uirDZrflW5Dl5FypsTbKQdhEtul4P/wQYTpdylK6EOOSVHlD9QhUPrIoCLtB0GJcyptIaesH2ccLhv0AZRVNQQDHA3zvVzHEYvh67+KOwO9b7reGSJBjrx5xtYyIlvH+UgnVQ5Lxt/A7e7rxvczb+8PJ1PS5/v/vY/9xj0ne7EwD18iSXj7T5Dfq14iVrLlGywu2n0Wet9AuMhl0rLtc7dt4R+wyr0mgKrTLOLc9oNI5Bi7tWHjvDQFr4t55ZK0R0x2/KYxf+GcQCEtTlwd6oN22X7QQzb/8+vICM/gxIkIpZQMqEGCrI9/1GZn+nojLx0rhhztUYHqC/UdIaNWwauJj25wrs8QSfskgsDvw/3Gzd8yPK54zl3KY4bIjaTlp2HzOw+y6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(7416002)(54906003)(38070700005)(6506007)(53546011)(9686003)(38100700002)(186003)(71200400001)(110136005)(55016003)(122000001)(7696005)(316002)(26005)(478600001)(8676002)(33656002)(41300700001)(83380400001)(52536014)(5660300002)(8936002)(76116006)(4326008)(66476007)(66446008)(64756008)(66946007)(66556008)(2906002)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1o5SFlyRXlCSVNFRWIxSzlJRmZJQlJscVFtM0laRUJmNElOS1ZqU3lxRzl4?=
 =?utf-8?B?WXIzQ3NmOWNkZHRoa1FlbHQ1aWF2Vlp2cWZQSm5mdnBnbGMyUzk1YzZwdlhR?=
 =?utf-8?B?N2Z3ZldjM3YyclNpSmxZUWhFMk82RnRDT3NPMEt3cmhRQ3Q3dEdaSHdFR2RL?=
 =?utf-8?B?V2F3TUFkdXdzVTVMUTNwRDlRbUhWQWNubURWSlJZOTJlbmp3NS9TcVVlSFZD?=
 =?utf-8?B?a3lIeHE3eSt6ZFk5OTlMSzJXMWxsL1VTTWg2bWZweHlPMEJTZW1aL1cvT1hQ?=
 =?utf-8?B?K3laYXIzK1dnZlBiUThuVWFVbXhmblhLQ2tpbDdVZGdxMDFRQUxmTUhPbUJj?=
 =?utf-8?B?RHNBVXVmVXZwc3JpRkRWS0VCUTdxUG1Jc25hSGQ1ajdQVXVYWjhueVpycUR6?=
 =?utf-8?B?YWgxNnE5aG1WQW9oeWpQN1ZJSG9INHhtTjVWbitkcFdLeFJ6TnlRQnZTdFZX?=
 =?utf-8?B?VzQzZWdhaisxeFErLzc3KzdPdDFGUFFGUDljN3hTYzhrZE5HUXZlYVNhQytO?=
 =?utf-8?B?OWFDQkkxNXdpK3piVUI1YUVLOGw4a0lEK2h0YWF3SlozOTFxekx4YlVFUVFs?=
 =?utf-8?B?QXI0enlKSllOR1pqZnFZclFzUncxOG5kZnIwbCsrUldQR28zcFIzRmdQaTIx?=
 =?utf-8?B?WXhCQ1IzRUJCQVJPaHp0SFRBSm9FRVlWdzJuQjZ0UlgzY2k5MG5JUlJaMERL?=
 =?utf-8?B?UlptR0llVU0wWXh0NTdHUDB1SEJvb1ZjbGpNVU5wT20zVjM3bzlxQ0R3MFh2?=
 =?utf-8?B?NklzTGtyK0RtL2F0dGRNb04rUm1OZFZzWlZpV0tJZnBSVlNFcUErZkdTQlpw?=
 =?utf-8?B?ZHU3SzZXL0pmNmVMbXFuZVJhZVFDNlIvRnlRS2F3bFZ5TjF4Y0d1YmxMRk9n?=
 =?utf-8?B?Zk5IUFFSOXRObEJpSUczeWkxZm5GTU5EK2dDTUdVdkJXWmhwSks0TXU4L2FM?=
 =?utf-8?B?RzlWSDM5dDhERk95SXVRd2FNS1hDZW9lWFZKYlFvQ2wxT21XQWd6TFJBSnFH?=
 =?utf-8?B?WDEvRytyVFNDRlpTQ21WSjM5Ti9kWmpxTmFDWmo0SmhuSUxpOEJkaVovRFJo?=
 =?utf-8?B?U3FEYTlRK1FZZUw2V2g4RWxiV21RM2hnUWU5ang4cHBHYlVPTkhwZjJSWVBQ?=
 =?utf-8?B?OVBwM3RzWlcxaHhVbitxZ2Q4ZmhkVDcrclJmQjhOS2laQ2VzVk9xWXl3YkZC?=
 =?utf-8?B?UFQwczR3d3dlblR4b2pZcDMraHNpVTRsU2M1bHM5c1RJV1RyQVU4dWo5S0Jv?=
 =?utf-8?B?YlNEVUdzbEVIKzVYc3dCQTZ2QWRMNDArbk1weUJPa1JIZXdHQUhZS1I5RUxG?=
 =?utf-8?B?djU4TWlDWnNEdGpCcUZlam1YaytibVFYeGE1MU1ZNHRpT3pIWnREYnFNUUhl?=
 =?utf-8?B?cUJRSXpMc2h5cUJneWtlVUo3dnFNZWEyZ0JhYldOUnNRQTdjTjBZY0FmZ2VT?=
 =?utf-8?B?NlZaeWg3RzQ0N2ZGRk5IdTRkK0J4U2QxdGplSnZFQXFraSthOUNFUnNKSFZo?=
 =?utf-8?B?RVd1WkxnQXZzY0YydXNNWTlaNnZObHNnbnMrS2Qwam81clNtcWh0aXpWS3Ju?=
 =?utf-8?B?VTZIWldLRkRZTXFJM1NUZWlqcjUzSGQ3dWwxb0dReTkxbWpYWTlDNTFYeUk1?=
 =?utf-8?B?UFpJQ3orVys4eEJQL1VjVUdnK3JDUVRXMlN6WmhPKzZYTGdYcElydUJpdmZH?=
 =?utf-8?B?Qk1mS3B0QWRZcVBNSWQxb2ZWejlnUExnTEJuNHNsSmJkeGVjT3ZBMFZHamt2?=
 =?utf-8?B?ZGE2OVh0Y0xiL2tBRTlzc2Y5a2t2aUgycEluNkREOWhrNTBJdlo2a29oTzJt?=
 =?utf-8?B?UjdoZ1FnNTBtM3Z1SzQ3SWZ4VXEzNXlvUGZJK2I0RXNHY2JVR1NIK2VWbVpC?=
 =?utf-8?B?RmFzWmI4R3FHaVl4bHNZcFJIZEs1TlRxL2tzSVBZQ0dhZGZZaTNzd01xT1JT?=
 =?utf-8?B?b2ptWmU2eVozcHBJYjNhWHpSUkRsL1RVODlneEp6SDFCZEQ5Wlp6UW5pNDA0?=
 =?utf-8?B?WjRZKzd4ckJHTkMyam1LcWF5dEROMzJLZXp5SWljYU1vajJrQlFiWXpwbGhs?=
 =?utf-8?B?RjZGb2tBSkdkMmpaK2lqOXRaZDc2REFGNHNnVGNmNTNEWWpmQm9CVUxiRVdC?=
 =?utf-8?Q?+3EU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DDEDD424A576D4B8B5CD21010423143@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17991e00-4e7a-4f5d-b96b-08db0a8ad799
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 10:46:04.1684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AQNdkOvM6w7aP/U9rAT47euxPGvy/UBgPOUpz3csh7s6A9tmv9dQx8l8q37V9jiXXu0tWYLjYNetYyQCNsSpJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzgvMjMgMTU6MjQsIEx1Y2VybyBQYWxhdSwgQWxlamFuZHJvIHdyb3RlOg0KPiBPbiAy
LzgvMjMgMTQ6MzgsIEppcmkgUGlya28gd3JvdGU6DQo+PiBXZWQsIEZlYiAwOCwgMjAyMyBhdCAw
MzoyNToxM1BNIENFVCwgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdyb3RlOg0KPj4+
IEZyb206IEFsZWphbmRybyBMdWNlcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbT4N
Cj4+IFsuLl0NCj4+DQo+Pg0KPj4+ICtzdGF0aWMgaW50IGVmeF9kZXZsaW5rX2luZm9fZ2V0KHN0
cnVjdCBkZXZsaW5rICpkZXZsaW5rLA0KPj4+ICsJCQkJc3RydWN0IGRldmxpbmtfaW5mb19yZXEg
KnJlcSwNCj4+PiArCQkJCXN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCj4+PiArew0K
Pj4+ICsJc3RydWN0IGVmeF9kZXZsaW5rICpkZXZsaW5rX3ByaXZhdGUgPSBkZXZsaW5rX3ByaXYo
ZGV2bGluayk7DQo+Pj4gKwlzdHJ1Y3QgZWZ4X25pYyAqZWZ4ID0gZGV2bGlua19wcml2YXRlLT5l
Zng7DQo+Pj4gKwlpbnQgcmM7DQo+Pj4gKw0KPj4+ICsJLyogU2V2ZXJhbCBkaWZmZXJlbnQgTUNE
SSBjb21tYW5kcyBhcmUgdXNlZC4gV2UgcmVwb3J0IGZpcnN0IGVycm9yDQo+Pj4gKwkgKiB0aHJv
dWdoIGV4dGFjayBhbG9uZyB3aXRoIHRvdGFsIG51bWJlciBvZiBlcnJvcnMuIFNwZWNpZmljIGVy
cm9yDQo+Pj4gKwkgKiBpbmZvcm1hdGlvbiB2aWEgc3lzdGVtIG1lc3NhZ2VzLg0KPj4gSSB0aGlu
ayB5b3UgZm9yZ290IHRvIHJlbW92ZSB0aGlzIGNvbW1lbnQuDQo+Pg0KPj4gV2l0aCB0aGlzIG5p
dCBmaXhlZCwgZnJlZSBmcmVlIHRvIGFkZDoNCj4+IFJldmlld2VkLWJ5OiBKaXJpIFBpcmtvIDxq
aXJpQG52aWRpYS5jb20+DQo+Pg0KPiBJJ2xsIGRvLg0KPg0KPiBUaGFua3MNCg0KSnVzdCB3b25k
ZXJpbmcgaWYgdGhpcyBzaW5nbGUgbml0IGRlc2VydmVzIGEgdjcgb3IgYmV0dGVyIHRvIGRlbGF5
IGl0IGFzIA0KYW5vdGhlciBwYXRjaC4NCg0KV2UgZ290IGFub3RoZXIgcGF0Y2hzZXQgZm9yIGVm
MTAwIHJlYWR5IHRvIGJlIHNlbnQgYW5kIHdlIHdvdWxkIHByZWZlciANCnRvIG5vdCBkZWxheSB0
aGlzIG9uZSBtb3JlIHRoYW4gbmVlZGVkLg0KDQo+Pj4gKwkgKi8NCj4+PiArCXJjID0gZWZ4X2Rl
dmxpbmtfaW5mb19ib2FyZF9jZmcoZWZ4LCByZXEpOw0KPj4+ICsJaWYgKHJjKSB7DQo+Pj4gKwkJ
TkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywgIkdldHRpbmcgYm9hcmQgaW5mbyBmYWlsZWQiKTsN
Cj4+PiArCQlyZXR1cm4gcmM7DQo+Pj4gKwl9DQo+Pj4gKwlyYyA9IGVmeF9kZXZsaW5rX2luZm9f
c3RvcmVkX3ZlcnNpb25zKGVmeCwgcmVxKTsNCj4+PiArCWlmIChyYykgew0KPj4+ICsJCU5MX1NF
VF9FUlJfTVNHX01PRChleHRhY2ssICJHZXR0aW5nIHN0b3JlZCB2ZXJzaW9ucyBmYWlsZWQiKTsN
Cj4+PiArCQlyZXR1cm4gcmM7DQo+Pj4gKwl9DQo+Pj4gKwlyYyA9IGVmeF9kZXZsaW5rX2luZm9f
cnVubmluZ192ZXJzaW9ucyhlZngsIHJlcSk7DQo+Pj4gKwlpZiAocmMpIHsNCj4+PiArCQlOTF9T
RVRfRVJSX01TR19NT0QoZXh0YWNrLCAiR2V0dGluZyBydW5uaW5nIHZlcnNpb25zIGZhaWxlZCIp
Ow0KPj4+ICsJCXJldHVybiByYzsNCj4+PiArCX0NCj4+PiArDQo+Pj4gKwlyZXR1cm4gMDsNCj4+
PiArfQ0KPj4+ICsjZW5kaWYNCj4+IFsuLl0NCj4+DQo=
