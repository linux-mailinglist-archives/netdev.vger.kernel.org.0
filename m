Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BEA674059
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjASRwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjASRws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:52:48 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653417E4AF
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:52:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsNQJbABTM5rtAhCVvALz1IvJkSxXO4eSqOW15N4XXMYnIMpArsLQj3t3kx2xMuzO0NskuJAmBvwh/qPEZLoKs0pUzEcRg7RshqdR1/121PVkx6lyRX0sQOyZdguSD4Km5fx1T1C1PGmclx9gOc65YLkFUbcUXtWOv6gdRKR8AGry00BCAmlLfodf4ePU9XHUlMwxWeFmwlYyMV+oam6ZOEONJvQcBMbaZ6WWiQZl6LS4dBzDzk/KYFYRXvAx1CuK5GAf0R2umuaa3URh0NUz0Eno5EdOO5esJr6Qlu4bsw4u7iFp62pCMes9stkU+K2sXvktq1+HOIorP14MW/jWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXR3dRZXtUDIMVnAaVfeJWTTD7/gYWM8tpJVdjD+S70=;
 b=YKvaQts1X7El9Hz14sx0I7u1hNiF9RnNO272J+lrgoScBRT1t3g/hLvH42m83BRIeVTT6rfy5M9bPVieof9LgqjINPdikrQ8eOIj9gh8y/DBqPdnwzOWPf/bQNySJW5b1EFBFTKKvj+ClW29v4DReGBTVxOQePtS+KkthY1PvMw11+LPikA1IlDMtOU9zOt6jZlDMXmLQpVA0OyGmyNLsQI33VAAQJrGS7xm3zV6nA1nn33pOfG1PrYxdf/UTUDdtFeJgX4vSjKh1TnIhxtT+O8CnnWXv0nD1Q3Fvf/yRAQddbgTpYBjX6vxGQHAU8lvlibobeeQJd4zU1yUsa67hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXR3dRZXtUDIMVnAaVfeJWTTD7/gYWM8tpJVdjD+S70=;
 b=hsmuR2mREF0l6S0E7spTFkCig0x8EA5Ou4yFSpOobK/8kZVpiU50uVVD+iKTL3/OMTJYidQSMyelBPF7tYR69/YFSB9v78lhXUSC0uENhiyixCD1ubpm5p9dekGHHVzi51Nk4Eu3oPoNb7QQn8zSmXqIKLyLClFcjEaA71/yWXE=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by BL1PR12MB5946.namprd12.prod.outlook.com (2603:10b6:208:399::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 17:52:43 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 17:52:42 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Thread-Topic: [PATCH net-next 1/7] sfc: add devlink support for ef100
Thread-Index: AQHZK/m3dRrScZP960COfMprLSU9Pa6l+3oAgAAKC4A=
Date:   Thu, 19 Jan 2023 17:52:42 +0000
Message-ID: <82a57ba1-bd28-3742-0027-a6a284569aee@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
 <20230119091606.2ee5a807@kernel.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|BL1PR12MB5946:EE_
x-ms-office365-filtering-correlation-id: 1c011a0a-3ffb-42ec-f0a2-08dafa45f692
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOqGZuTJBBV7C7I7yRtwl8O/xvND3bsM74AbT/hsx7VoYuBozVdn4rRy4R3EWle1S1BSYaruFD6qgAG2QiG9a5iQOMWxXv2xGmO8JXa8BhWR3TCo14k98+ftDDeePdeEtgS6D+W3jUrW7Kuo0Sk23jgfzZeZi9FNxBG/0GcLtNHRcL3Dk/Z+dox26Vx1iH/fYP270nnVEHY+iAZF7+LpzHTvs5YXAFVU1bZuE+YSlTL7QJR5pLnCnAT5fCmH04WUAjnTyfHHu+zor7YaD+dYKb+WLuqYcrRnA86PJE8EaxWptxzxn7WGFL3Zpw+e6yYIW73gb08bojWnskydxaZBKbo46IarnZsLG5COp969Ny9CAKLR4Bu7ulGo00EalJ97ApMds1KbyC3VXWaA64rEus/02HbH2FwMwbUt+k/+dseb5qkYlqAoWArJWcoFgpP4VLatJkRo+2zMnH8n3SWMxtWqiRg86OHfubmdZHzRtyqT16/uuzqoaZtOZQY1lXKxLvojSBt0c9sMSsa6Wf4tq1H9S8Ul4/6nBq4DFtIVrQQ3bPedZ9i4nSR9mzeSFEBPgBAFRJj7coEamrZjcWFb/0e/BpGXesuWLroJ+v2o0qCoZtYtPuMon/dt4UhoaOaQvH/7Thhx+752sBgIz6v6GubpDst8sP7Z8ZVJ6kAJu1Bs40VAZuFtO4SvywXTDCrbk2CMa5Ww6GSy3r7+pliTLOY7+1ZeASmFxg0cR/idWAQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(31686004)(2616005)(64756008)(6512007)(76116006)(4326008)(66476007)(53546011)(41300700001)(26005)(8676002)(66446008)(186003)(86362001)(31696002)(91956017)(66556008)(36756003)(5660300002)(8936002)(66946007)(316002)(54906003)(83380400001)(6506007)(478600001)(2906002)(110136005)(38100700002)(71200400001)(38070700005)(4744005)(122000001)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXU2aUkvVHJaQ3hxQngyK2VZYTZoK0lRR0lOTHphSFBnbHBaSmRvT3lqUEhu?=
 =?utf-8?B?YVI0WHBEenMvYlVvT3RsUytHZmJGQmNwYTVBekFGYm1sQSs2VXc5Znp5R1BX?=
 =?utf-8?B?cHdBTWVpR1Uxdk1TMnlBRWRXdHBubC9jV2lseGRoSkRpSzNTUE9xcWwzNXpV?=
 =?utf-8?B?M0w4SXNGejlmK2VGejJPWGdxMWxFaWJNZTcwU292RUNpUGFQOE1LT0lRYTQ5?=
 =?utf-8?B?YUZxSnpzTUlVWlZJOFVwanJCdjYzc0JHdk9JdTNpT002VWNTbjZXTWJjTGhD?=
 =?utf-8?B?RXliTEFKeXNCaitkdURBY0tweUJxTWt2aXJBU0JKbXlQUGU4eXFtd3Y5S2ll?=
 =?utf-8?B?WHY3akdKSllkZjZQQVQ3dSsxZjZwZ1BTNm1qRkQwOGtYbld2Y2NPL09PVmYw?=
 =?utf-8?B?ejk0THRzQi9RQVg4Y294Mmh5ZzF3VlZ1QS9GTFU2UnJnZ2NLYnhlYlkwTU9t?=
 =?utf-8?B?V0RWRXFNaGdZbnhtb2krYkJLZmIxQU9qV1RQc281dzhrR3hYa2ZoQWJ5SFkz?=
 =?utf-8?B?bGJJb0VjcjV0cWJzZnFRQWh5aUhWRm5OeUJvMkgxYk4zSVR3aEU4VVZWMnVT?=
 =?utf-8?B?dmJKOUZ4RUowT3BIU1NGVUppcWxFM3N3YXI2VVN0NTVRY01ySHNqbHk2Q3pS?=
 =?utf-8?B?TDB5ay81YjNpb1QwYXBBMlhwek9MdTBDME1wb2hXV09YSWdob3VVbDlNaVFS?=
 =?utf-8?B?blVDWWJYeW9SYmlRRmZianFUeE90OTNpbmYzWHVqdnBkcFUxTEhJK3BvNTln?=
 =?utf-8?B?eGM1b1dEWVdkQlFDcjMva2dlTG5kWURGeld4OWsxYjg0Ukp1a25hZHV3U1pM?=
 =?utf-8?B?RmJrUmpiWnNJSS9nY2RUN3U2V1I4eFM5Qm1lbDZtbzV5YlBheHQrS2NVOFpk?=
 =?utf-8?B?UVV6ZGdvVWVxR1ZQSzd0a2JQbzllR0NBTE9zMk93YmlyYlY0cVB4ZDJlUkp1?=
 =?utf-8?B?aXI5SFVycGg0K09hTHYyWU5Ea0QyQXhDY2FkZ05RcGRYcUZDSUdTZ3c2eDFt?=
 =?utf-8?B?WmRvSklId2JNalNwYU1KOUFqRnlLZ1NsS1pObnoydmNkZG40YVpGeFlTZlpa?=
 =?utf-8?B?ZkNsTHh4VndXd04wTVVsbnh3QWRxOGZTVXlkNHFJNVMxMThBMGtpSEFJajdt?=
 =?utf-8?B?djNDMFdOYjlXYVE4SVpCNklMN1FCSDB6RnhwM1YxUm05MTQ5UWhyUHNkWDRa?=
 =?utf-8?B?RFNFMVRNN3pUS25ObEtzcHRiM08wMURtaTRzMmtqZkJZakwxOHM3ZjNSdENl?=
 =?utf-8?B?ZkxqcVoxNHRVdjJyVEJPL21pZFExZGJlRCtVc0IvUjJaeWlsVnJTUko3N3U0?=
 =?utf-8?B?aUlMb1dET1hTV1I1cWRveDRjNFBGN3BteDB2WTNFMVJjNW4xdkRUMGtlTk1k?=
 =?utf-8?B?RDVvMkFhb3c0VDNhVWsvblQweVJmc0VKeWxCc2hjQXUvUGdGN2F2bklqYm9R?=
 =?utf-8?B?OUFEMDhMdERBd1diVWNsOWRtRUV3QklhKzdnNyt5VjF1a29jbjdlV3VHQlZl?=
 =?utf-8?B?Z3hNV3Nndm9EdHNJUlArU29NNkpIRS92TUcyWVFhZXV5ajJseE9NLzY5cHJZ?=
 =?utf-8?B?anJLRmlXdm1CKzhLUlhqb01zN3lnZG5HaXUvbUxzdXkrNFFlYlE4UE5ZdTFm?=
 =?utf-8?B?dUJnRE56blpvZnhlRExVL0xxWFBnVFR2UnZpQ2JMWEpnQkxGbjhaTithVUJR?=
 =?utf-8?B?WHRCM0dST0psQ3dLbzBVZDkvNnpFSHl6bmRxSmJnSEFQV2dRLzh2SFprSEth?=
 =?utf-8?B?UjZmdHZhSVVrZC9JSHl1Qk5GRE5Ecm5qSkxIZ051NFRlUlUzdFVPenBvbXNk?=
 =?utf-8?B?TDBmdncxTXI3bzROLzFqelJLTDQrSkUxamRoQ0pOeDNLKzFrUHlIdkZLcmlJ?=
 =?utf-8?B?UzRLMTRubmJHSFg5QklBbVN0ZTZ3ZCtUblk3YU9BM0NDSUg2WUZSaUtvYjdM?=
 =?utf-8?B?aWpZdlBsaUw4NktONStZY0NRcVZTUytqR3g3ZktSbXVPeDlOVDVLQ3lTVkFH?=
 =?utf-8?B?RE13ZGhGTkc4OUpFS09CTG5UR1cyUWV1b1NqZUU3SWl6cGdBZTZadFlreERo?=
 =?utf-8?B?elQzMmMzcHRUemFuKzZiUWN4OTVuZSsydlNoa3NOOUYweU5IWjJ0ODdIeEJQ?=
 =?utf-8?Q?NltGzOqQRoKyXlwrC+DptW3jx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F63748B63775C46AE64D7FF7DDE7003@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c011a0a-3ffb-42ec-f0a2-08dafa45f692
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 17:52:42.2702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKpOBMyMgA3BIMfW/2x9p0qXl+7db7rW1m8cEqQg4ftvui/dOhLWEz2lFkO+IZBb8qVaYCZLEeLlc7eSGP/SjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5946
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE5LzIzIDE3OjE2LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVGh1LCAxOSBK
YW4gMjAyMyAxMTozMTozNCArMDAwMCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3Jv
dGU6DQo+PiArCQlkZXZsaW5rX3VucmVnaXN0ZXIoZWZ4LT5kZXZsaW5rKTsNCj4+ICsJCWRldmxp
bmtfZnJlZShlZngtPmRldmxpbmspOw0KPiBQbGVhc2UgdXNlIHRoZSBkZXZsXyBBUElzIGFuZCB0
YWtlIHRoZSBkZXZsX2xvY2soKSBleHBsaWNpdGx5Lg0KPiBPbmNlIHlvdSBzdGFydCBhZGRpbmcg
c3ViLW9iamVjdHMgdGhlIEFQSSB3aXRoIGltcGxpY2l0IGxvY2tpbmcNCj4gZ2V0cyByYWN5Lg0K
DQoNCkkgbmVlZCBtb3JlIGhlbHAgaGVyZS4NCg0KVGhlIGV4cGxpY2l0IGxvY2tpbmcgeW91IHJl
ZmVyIHRvLCBpcyBpdCBmb3IgdGhpcyBzcGVjaWZpYyBjb2RlIG9ubHk/DQoNCkFsc28sIEkgY2Fu
IG5vdCBzZWUgYWxsIGRyaXZlcnMgbG9ja2luZy91bmxvY2tpbmcgd2hlbiBkb2luZyANCmRldmxp
bmtfdW5yZWdpc3Rlci4gVGhvc2UgZG9pbmcgaXQgYXJlIGNhbGxpbmcgY29kZSB3aGljaCBpbnZv
a2UgDQp1bnJlZ2lzdGVyIGRldmxpbmsgcG9ydHMsIGxpa2UgdGhlIE5GUCBhbmQgSSB0aGluayBt
bDV4IGFzIHdlbGwuDQoNCkluIHRoaXMgY2FzZSwgbm8gZGV2bGluayBwb3J0IHJlbWFpbnMgYXQg
dGhpcyBwb2ludCwgYW5kIG5vIG5ldGRldiBlaXRoZXIuDQoNCldoYXQgaXMgdGhlIHBvdGVudGlh
bCByYWNlIGFnYWluc3Q/DQoNCg0K
