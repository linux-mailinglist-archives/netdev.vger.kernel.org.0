Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625F44BF5C7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiBVK2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiBVK17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:27:59 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A336514997F;
        Tue, 22 Feb 2022 02:27:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWY0oT2a5bQ2KR816B/sWcNJVg09I2LRvmPCkppL2ZCVSmV0/ZBhgRHgc4v4Re7L+ODKLGEicoIjIW/zEbG1UGFotay6tT9B+9/xhCKL9M/lBq1ikLVVmSHbOicIg6HtCzQbo8xKkCgJ5s3fxTGtQv7TBwiojRrIoM9L9GeaMT54pE9gfJfaeuBv+A7apEbvnEDdnAwyrhu90tF+j1fzPa714SPuIqrrbsNm4eHNNp+2mDqFiaqjvWtYSUzulwxPVjAYUkVLU91m9Ky8SDBRHHogU8gglRn6csSS5J6BLZnoAK3docEhMOWhMPDhlaM7Uzl/QytEVxYUtE2vV+KhqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fD6rOv8AVpBVKxVZJvF2pynvIf9CS+EFyOSyqKYBvRk=;
 b=TDBMyFJcq2c7hNQzystpuk0V9VvfC2uqX9GkrbaYF8RPf1BUx3Wi2vDBb9rkikteovmy21QQOoc5QK2jLttuv+MGGpcwQhUw6N6JI/qz3I5f99Cja14rTquYEA+reHDZ/BZOHy92V388aTgtCgJTZar3XQk6SLqlTk3LAxanSrPIJl8AnmX+auNsVgM1aEjCop19+5tr7ZjRy/e761L5X9FSkKRI0DtN49vfBLLHk2kp5/3n2dzyKUaLZVZ3LgpP9/+YL7OZKToIeshsi8n77oU1HEnLvS2WFp0jlNPT9cNFWfSPNS1TcAQW0zbz1gXtknFJzaUpXvnRcxY8S7kRUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fD6rOv8AVpBVKxVZJvF2pynvIf9CS+EFyOSyqKYBvRk=;
 b=t4JxklEqZaUOnBn4sLl6qspWHVbum4TOguM3A3BjJn8rVI6h3Gft6N72FFuoDIwVp9GsBrdMmhiFChwSbfBNd0/R9Y3E1b/GbIv7FR/roxiGTl+tmVm14AmQoQGTWnTgv/8eT4D4BPArm2QS2QOjpBBG1u+2Su+ZPFblyiy4tS2xKvsNys7dpiFpZwsbRFK32K8ERdZj4gMXifDx0RiPY8qiPfvn2zgBwQeVq8vzwvj1Rc0HjmpYZ5W8/vq9TTnes+DLPIIkCMGZFeKRIAt5ZOMeyfMA2Twp5tj/0rZNAtjZnaBcSURraYYGsTZIkeLZm0A4s9iUWmWdOaLyvD/Wig==
Received: from DM4PR12MB5198.namprd12.prod.outlook.com (2603:10b6:5:395::17)
 by PH7PR12MB5711.namprd12.prod.outlook.com (2603:10b6:510:1e2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 10:27:26 +0000
Received: from DM4PR12MB5198.namprd12.prod.outlook.com
 ([fe80::ccdd:3262:885f:6f5e]) by DM4PR12MB5198.namprd12.prod.outlook.com
 ([fe80::ccdd:3262:885f:6f5e%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 10:27:25 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     Petr Machata <petrm@nvidia.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "peng.zhang@corigine.com" <peng.zhang@corigine.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Topic: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Index: AQHYI9hnxKB/8XMkm0uWEB4X3Xu2BqyXsfCAgAcltYCAAIk4gIAABQIA
Date:   Tue, 22 Feb 2022 10:27:25 +0000
Message-ID: <e315fbb8dd3ed7aa263c7e44e92f673f463cc98d.camel@nvidia.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
         <20220217082803.3881-3-jianbol@nvidia.com>
         <20220217124935.p7pbgv2cfmhpshxv@skbuf>
         <6291dabcca7dd2d95b4961f660ec8b0226b8fbce.camel@nvidia.com>
         <20220222100929.gj2my4maclyrwz35@skbuf>
In-Reply-To: <20220222100929.gj2my4maclyrwz35@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e395e443-1a9c-4c8d-8234-08d9f5edebaf
x-ms-traffictypediagnostic: PH7PR12MB5711:EE_
x-microsoft-antispam-prvs: <PH7PR12MB5711AA7BA04CF88DF5E17FE7C53B9@PH7PR12MB5711.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i351ToSJgR4O4moIwb8bzoW2Enes32KRR3oQbiQWcFUtNO1OGPysPOnFw/yeY+ci5Lk8kW8clp/utQ1qgBj3gaM9gQNEEBcsC7U1KiOkDgaomxIMEwffLPW98Uq/i8VKWY4ndvOekUrsioy+fEfcHlKDlYLzRLuCrPLh5pfaMZMvJ+DbEYFFlpav/15uESeM6Wl/wjIPPw3wmJnAU4RXDeLxFDq6yPHVaMBGwtxxu02GmrqlAyGiDfgXpKRBO7vnvQlsq5m0YdSF8SmCjLSW2ppMmCo8UA8qAO3zUqKU3MnvaE+Po313N5L38kpOLJpJYiwN4VvcGwwiMAInGmYWVIBuc/JTxi6iFP+j7qS5255Mlb84b5agOEGuKgsmrqlcgBPncdxGZBI6pBLgjF3y57iP+RkyW5Enk1zyJy+Z35B56MGnalkhDZHW6YXvBR2/9TslLFgH2/0A8qYjYhUQGzgdYDLhW5Ab/UH4DejHcOhUZZnq1XWCt5CynBNXbej2a+NyNZu4RqUaUh2ENySoYmxGsK6Rpg/cvReFsv43s7ELcBv4lXgVWSvKYeXeq7y+DDp81Q3TjVHVArGPkz2eRZIaETBRDiqC2iRpHesD+m0Q3qlSENP3YdLylrXU42jC5MUmdQ+Pg0mmI4t+KJeW9Xrm1fzYtq/drfPNvR4gaXUA/V3fpkjskN1WpJuGGcluYLRwGxlbTvYmAoIlIpJOnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5198.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(122000001)(186003)(66476007)(7416002)(4744005)(8676002)(91956017)(2906002)(66446008)(64756008)(76116006)(66556008)(66946007)(4326008)(38100700002)(86362001)(83380400001)(5660300002)(8936002)(54906003)(6916009)(2616005)(316002)(6506007)(38070700005)(71200400001)(6486002)(6512007)(36756003)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzFRM2JDd1B4Z1FvV2FvTWIzcDdxV21SZjVjZ05pQUxsSDc2SnVKMlA0dEhy?=
 =?utf-8?B?Ym9iZEJMenQ0RTNEb1h1d3hjZW5mQUZ1RnBxWkRkWkF6dEFDREVpazZlMkhC?=
 =?utf-8?B?dmIraEFGNEhmTmI4ekc3N3A3b0xvbG05aTgxbTVLekV2UWV2Tmp2WU5FcjVz?=
 =?utf-8?B?akJ2eUlDWkFqT0JUeTJpQUEvZ1ExbUZaWWlkVW1DTXFKeGlrN2hHcmlpVVI3?=
 =?utf-8?B?Qm5vRHlLUlE2OGp2am80cTJ1am1SdjVmMkdYb01ORUpYakFHeTZhQXdMTExD?=
 =?utf-8?B?ZjZlU2VmMVpEd3BMNGYvYWk5ZHNXclQ0dVdVb0xCbk5GS3NScE5OOGhWUXdO?=
 =?utf-8?B?UW0zTE9CSXl3N3BqaGhSb2lBcTlndW55QmdWMjRVcVJkSzA1TFRkZ3gwczlK?=
 =?utf-8?B?aEh3M1dhN2h0QlhCUzFXUkZDOVlHZCtheDViWm1YSXlIZEo0dURRTlRnOTdR?=
 =?utf-8?B?R3RHQ0NWaHBxbGw3Q0h0b2owWE90V1dqcDJOWjhJNk1MeXNSRkdWcWxoNWhN?=
 =?utf-8?B?d3JPajNLN3FMeDNFRmFpV1BhenBjOEZRL1FkRmNOQU9nVUE2VndUVmJ4NHJD?=
 =?utf-8?B?RlIxbGJzd3o3a2kwanlZSC82Rm9oVDRzNzgyYjBxR0ZBN1hlNkRMSWRIVVdz?=
 =?utf-8?B?MGN0YVAzMzlIazcwN3JCcDRXanNLMGs1bEQyckJnZWNXVjFTMjJJZEd4UXBX?=
 =?utf-8?B?NHpuRUttVVhPbDFDcUZPdG43cjBqSER6YWFWc2E0UjdCK1hNMUdhdkZFK0Y5?=
 =?utf-8?B?d2QyRTBuOVhTVEMzWGU4UDdPblc0Vzh4dWlsU3VBWjZONmpwVEE0NjVldzJN?=
 =?utf-8?B?U2JDY05aUjFEazAyWjZTVmtHRFd5MTkwS0IzS25VSnR4Q1ZJeERYSmhSRldB?=
 =?utf-8?B?VUZGNmtjV1Vob0lSb2ltampPWUg3SWxUM2htWVYrenU0cDZOT01tUkpvYkRi?=
 =?utf-8?B?NHY0WnMvUXdlNWdUcFNrbUNPYjV5cXZDQ0RvS2IvRG9IVXFwSHN3dDRKZ0Zi?=
 =?utf-8?B?cEhJaHgrcHpLNVdRZzlRSnpVZFI1WWg3aHpOQmdDUjMzTUpRSnI0R2FpMFFj?=
 =?utf-8?B?TTNxeFJ1aUlNVDluY0NlelptOHg4dDlOMzBMU0NKMDRXU1B2UjFMdWpReWJX?=
 =?utf-8?B?aGlUWnNOMFZRdm11TjBzVGlZMGNoTklFOHRIWU9nOHZOTEZJUDkxYlVzUXRQ?=
 =?utf-8?B?dHpDaE9NRnBobDNxRWJoKzBXaHBSRkNRYWFXcEJKTWtHaEl6aGl3OWN4R0Np?=
 =?utf-8?B?em0xQWFDVmhUZFltcEtEQ1hyTDNnMzBLT2VpdnV1ejJLNUE3L3VVRitWYkdM?=
 =?utf-8?B?V01UdVdGVGE5T0RDZkVJMVdyeXo3Y2JoYXV0RFhlZXFTc0xlR1l4MEs3WDB1?=
 =?utf-8?B?OVoyQy8rYWpudDNwbkNML3BvN1QwTS9aNmcrNU8wUS9PMnJnUktqajhRS3BR?=
 =?utf-8?B?WWVIak5ZVk4rV1cxejdMZmpYS1RieUtWWW1IUjhQR0o3S1g4bk9iWGF0QXZs?=
 =?utf-8?B?VDAwQ0xiUnpXL085a05kcUZRU3YwTnRyMzVDWVBHWWZ5ZytZNFlTcmpVVkdZ?=
 =?utf-8?B?NExGaWlqdCtXRzcwT0JrUVFNa3hTYmtldTVFNVB2RDZjTFVuNXo2eVplRFBv?=
 =?utf-8?B?UGZhQlRuczlPOXFzb0pjWTZzcHlDWG1Qc0lEbSt0WG9jK0x0WXRKMnRrM2Mr?=
 =?utf-8?B?NzhyMGxYTzRQOXdVRWIvbWgrditKb1hJWU9abExkUlYvMi9VWGVRNmlIb3lz?=
 =?utf-8?B?UWR0WTIzUGUrZ1VhL0lBYXVSelBlWXF5MXE1ZVdha2tLQ21Fd3daTjFZOEpO?=
 =?utf-8?B?RlBQamhLUmhRZHhKY2ZxYUx5a0hpRmsvQ3JXeHYxK2oxa2I1cHVFMUt3c1Bi?=
 =?utf-8?B?c2FndnJOTWZ6aEZ2SlNLSVNzQ2dKeS85UmZsT1RKLzRlODNydHNzcHlPQlhN?=
 =?utf-8?B?c1RQMTZ5QkNPWXdEMUlCYUVOZk9namtuQVovVU8wQ2I4WWRGcGpkWU5ockJl?=
 =?utf-8?B?Zm96K0JZcEdaSTVsbHkxQXozMXJZZ2VSL1gzRHRDdGx2ZDdGSDNTUk5ERlh0?=
 =?utf-8?B?RW1NbU1WcXo5WmJZTWIva25oZUZ4Y2Q4MGoycEpCS2V2b3cxend6QS9vZDVm?=
 =?utf-8?B?OFRnVW1iUlI4dE5GYm9KWVpLcVp6MjRDTHJ6WE9pVG1xd0pWSzRWYkNBZTFW?=
 =?utf-8?Q?v71LTAjgdZ8VuKSaR8re6GU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70BA7C0A4E5CD640ACBD0B09BE87B8E0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5198.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e395e443-1a9c-4c8d-8234-08d9f5edebaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 10:27:25.7735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cKyDmviHyFnVXt5V+Gt0I1bW9N6AOdsXZ27B1CPHP4fycHJGF9JKpML20mMB4iaK0lPeS3H+wHqlNUrOWpEkXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5711
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAyLTIyIGF0IDEwOjA5ICswMDAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEhpIEppYW5ibywNCj4gDQo+IE9uIFR1ZSwgRmViIDIyLCAyMDIyIGF0IDAxOjU4OjIzQU0g
KzAwMDAsIEppYW5ibyBMaXUgd3JvdGU6DQo+ID4gSGkgVmxhZGltaXIsDQo+ID4gDQo+ID4gSSdk
IGxvdmUgdG8gaGVhciB5b3VyIHN1Z2dlc3Rpb24gcmVnYXJkaW5nIHdoZXJlIHRoaXMgdmFsaWRh
dGUNCj4gPiBmdW5jdGlvbg0KPiA+IHRvIGJlIHBsYWNlZCBmb3IgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbXNjYywgYXMgaXQgd2lsbCBiZSB1c2VkIGJ5DQo+ID4gYm90aA0KPiA+IG9jZWxvdF9uZXQu
YyBhbmQgb2NlbG90X2Zsb3dlci5jLiANCj4gPiANCj4gPiBUaGFua3MhDQo+ID4gSmlhbmJvDQo+
IA0KPiBUcnkgdGhlIGF0dGFjaGVkIHBhdGNoIG9uIHRvcCBvZiB5b3Vycy4NCg0KT0ssIHRoYW5r
cyENCg==
