Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407066E0977
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjDMI4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjDMIzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:55:46 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531DA5D5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:54:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUVlg9t9hT1GsKihJs0BX428Fl8SZnqaONidrkhIk28fsKjoG8cfD1Yuvp8hjq54wX2eI2ykAcp1TRUzlUJQucNQEQ7Z6XT+ds5ZI2/zXk7mZkpVG8Fd+mkUcm1lcg8P2FJA7htgKZemy4wi/nxlbOlO/2Pj3ORnSX3AVHQ4j54UvR2eY6xCAw3LqEEuahiA2JlL9HY4JX+7BjbGrGFEhDdYuNUyc+YFNdlGhq1RFVIAZrrIvIYa7zWE6ddqX3xTig5qFJ03BU0RHjd4cECmhZCFhSYuYS1tKK9z0/DeW9NIZcxjQ7y7c470iWKLv22bHdDoRrsARctHrjS/qStsyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6SnT/X5oVArzPLlH6nSOqCuOTsuB7pGz8emiRiLqQs=;
 b=oNruZqevbaQ34DQr0ob188UXZqCyIVF3pcUaoWaeZd98e4A8ultm4EYX8qp11lIplAClXu5cQmTVTIDKT/RsJb8kWsturiaViVNtiHCbhpIy5LgPDrFhtEU4c3P4B6B/8Mdw/dWnNjn+WPtJt1rAyAz83HbQtktAVDauLwoO33Xo3NqXx7vYvA9LLJSr7HmieRU+QOGjMpmUebDg5/s8QWwzvRmgtjrLwPgX3D5/7fbJ2pJoEPNcGXRYjN74w3teAUjwS3FzKj0seDD3KjxqDIw7I5Lboq9rty/UbLrUKNjeWH3cTa/nVpW5uGUiLMPmZ4D4jZiHMK7tQ4kwnVXZIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6SnT/X5oVArzPLlH6nSOqCuOTsuB7pGz8emiRiLqQs=;
 b=aNDg1DsmnLs8DaztbiQo4EpAfO07NtIjjd6xs23zr6k4X8I9o8Bo3nfD+QKC9DTQwT8UdTFaNyDHlw2WD27/RFx/bdCo55iYTVkkAnvF48CfapmnEHQxmvF9qmVSOBT4cUY3bIDKGflw2bz2t4YAFI0Ni3RKui/SaAhXm5RyREa6cmJKwewFBN9mbuYXZOklZp3B1PBe77Tw4MGhoxdpJvJh/FufpiRUPN7aW9R7G2xzIWEpsYjUxrvRZ7GynCOh3x8xa6f+V3DtfD/H7BFbsobLbLSJxR+Jn0nBEW9HQBwPur17F0l/ly+2X4NltjV40bTz3Iy/gBkAVO4xt/j/dg==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 08:54:14 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%6]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 08:54:14 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
 support
Thread-Topic: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
 support
Thread-Index: AQHZagj/V0dWeiWus0uVfTv6PZHn168nynqAgAEDOPCAACQfgIAABEog
Date:   Thu, 13 Apr 2023 08:54:14 +0000
Message-ID: <IA1PR12MB6353A819224714B47CE249F8AB989@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
 <20230408105735.22935-6-ehakim@nvidia.com> <ZDbHI/VLKkGib3kQ@hog>
 <IA1PR12MB6353A4C01FE89E6256C89E94AB989@IA1PR12MB6353.namprd12.prod.outlook.com>
 <ZDe7RPlkemjOBB7e@hog>
In-Reply-To: <ZDe7RPlkemjOBB7e@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SA1PR12MB6972:EE_
x-ms-office365-filtering-correlation-id: 409d2ff2-ed53-47df-308a-08db3bfca87f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ez0JwCQ5DygiY2qZGRZZzMa11ga651s6KMySbo1Evjon40mPzPS6K4f11qcpnCsPiBKbryEojGc/h6MVyzn2SrjGQiMJu/8w3FZmzitW0UKy0DFRTE4/LgGarDxwo+MepSH5cM7qFyupRTAsrcsy2MYuWW7Yt01ANel7edqSSEvD1jTlrnAuCi7gTTHA98bzG4nvjp3Fi81jcx6GxJJmNDQAYGs3KOjLNLKQ6IwTCpfrVrqaETdyBjyUsyOT4Y1i+ABNj9kohfJjMxiD2lx/ftmx8t+NreXSxSBJwyA93hay5wIBHAaAxRgACkUgm1jopuod+J0PNdOdeE+r2zE6w1/OP9HJOSnaG5sVTqz2iaIgPl9cGqK+5DUlkva48EzirjXkAtIwiN/7mNNhKq7f45IP+HJO1kvFHHJaxczn9xKnlqxp0JyectfyOSB+zGOejGbQdRsitMqAj2TmjcXFbZ5/JJ8O0zUL9UZLE7BIpqDqYJWVUMF9QbIn1t1SJBU8rY56ArdMjbJmdYDeqQ/MMrDuVvFrJU9P8AkbNHWH2cfmnZwf7XdThu0EpD01ZuBcbR/UPdqfI4WWhujjDrYAvwRYPMhjhdcsuzS9CSrC7RHbP70WVcoN35hLF3O+m2nr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199021)(5660300002)(8936002)(52536014)(41300700001)(33656002)(66476007)(66556008)(83380400001)(6916009)(4326008)(8676002)(66946007)(2906002)(76116006)(71200400001)(316002)(7696005)(64756008)(66446008)(478600001)(54906003)(55016003)(122000001)(38100700002)(38070700005)(86362001)(9686003)(26005)(53546011)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGhta0xBNVZ5a3VFSmVXT1hrelJDK2RCRnRDZ2poMzRlU3EwVEFaLzUwcFZE?=
 =?utf-8?B?ajVkdHd6TXJVaHZ3RDVvdklibVdsWFNwbG5oNVIzcGpDdUdGV0YrZDcvcmtN?=
 =?utf-8?B?WjVEQ3YxYnpadm9DVDlJRHMzNlN4bm1aOCs5ZzRxN0FDTzY3VGVNb3Mxakxt?=
 =?utf-8?B?VGhxN3h0eE9wdytwYTIxeXZ5V3ZFS2ZZM3o0UDBpSHhJOXNEdFdHTlZUU0la?=
 =?utf-8?B?cTd2amJaQm1ycENEV2swUGxjcEdkWXdRaVBSQ0d3bm54QThIYmxuNmNvaCtU?=
 =?utf-8?B?MjM5aEd4N2NDWFRjNnJpQlFDRCt1R0VWby9RYTJ1TnB0UHJQcDhTemVQWllF?=
 =?utf-8?B?VFdMV3htZHhsa0srWVo4UnFnMHJlbkZGcU9ZNzFlVE9pVDd4cnAyV2RRL3Z3?=
 =?utf-8?B?WUc1WFZUdFgvdmdLRlhXUEY5My8rQVFlRHQzdTFPejFIUjhtWFNNbmlkL1Rz?=
 =?utf-8?B?alpkQkdEazFsSGp1a3lZTmdqR3VBTE41V3AvV0l2UVc2US84NC9BWVdwUDJv?=
 =?utf-8?B?MTlRQnl4TUJkaEk5SmpXdUVpSWNUcm1aRThOUzc1Yk1wZjRCbm5QQU93VGNm?=
 =?utf-8?B?clVzSnkxTVlJSnQ5RTRaV2VjamZ1WTFGUzNuREM2bWFwa0s3NFVuRlhPSzFr?=
 =?utf-8?B?Nlh1Y0Y0L2MrUk1sY2JEandUU1FGMFBSaThsQWN6Rk54V3MwNWdMeGdkV3F3?=
 =?utf-8?B?ektKRC9KS2U0RXo2a0tJODJsNmRaTGtWSm1ra1RUREZVSTdTOWUvOWs4UTBS?=
 =?utf-8?B?bXRkS0RkbFZSNlZkR2thWXh4V0VQOFAxelErMEpFMStSTWpBYkxEQWNxTC9F?=
 =?utf-8?B?bjNweDE0cjRlTWVEWEI0S2pMMFlCMDdJT0FQL2dwTVdhNXVOQzIvMlRFZUlx?=
 =?utf-8?B?dkpzbVI3a1ZYYXVOQTMwSThvbGdjRVhMWTlJOUNEUmNsSDNyK3F0RjQwSGY0?=
 =?utf-8?B?RHEwOHc4dmNBc21TQm9wNlF5NnVMamtueEVDQXdOV0FSTUtTQ1FJb0dzU21y?=
 =?utf-8?B?d0lzWVFGR2xta1k5L254Zmh6K2RUeWlXQzZUVDliTTcwcnIxWTRZWmVBV1Zy?=
 =?utf-8?B?eGVkSFVseEtXWTllaGJDSXhNZkxUTnVMbGtxbnVuWVNJTEZadGhpN2xMdjhM?=
 =?utf-8?B?OEt6N2Y1WmNrZkRtL2laZGdXQUp3YUpjMlQzVjIvVFRhTVlMRExzMldqekQz?=
 =?utf-8?B?RUMvMjl4aVdwVGlZaVlJYnplME1qYWFvTWtwYTVac3lJelo2UWVnbWxHTi9s?=
 =?utf-8?B?NGRmbFRJWXRDRjh3bkpZaXdNbUQrWmVJK0RlSnpVV0V5M2phWTR4WThKNXEx?=
 =?utf-8?B?N3ZraU90QnVNemFxUXhhUUNlOE45TmhDZGJZRjc1b0NJbHhPWkdRRk93dDhG?=
 =?utf-8?B?WGlPSkhoajI2Z2FRNW9tMlJUZk5pbVVFcmdMK25oRkR1YzRSclZUTXBwRXFX?=
 =?utf-8?B?NG5RQm9ncnl4QW1WMFlvQ2dGbzhOUDhBcWQwSW83aVhTL3pXaU96VWdtUm9U?=
 =?utf-8?B?Mk9QTVhDVkJuM2VDWjFnL3ljNDAvMWlBbEh4VU01Q2ZBMHlwSGVXdC9nWGs5?=
 =?utf-8?B?VnBzQzF5cDg2LytoTHRWTjRZYzRVdjNUTGRXdHdKbFVuWkhSQWllZ2JVeEM2?=
 =?utf-8?B?U2xLZTFRajdNSFlJcXBMZFVDNDRibW5tOE9lbTlhSWxXUXBMUDBKWHRCRTBU?=
 =?utf-8?B?aC9WeUkvWFE3ckFFRmpMSjRraU9YLzBOQnN5SmxielJmd0NjUnlBNExiVSta?=
 =?utf-8?B?RWdmUForbHhycFc0VWdTcVBkYTZjS0JTQkdVMjFFTForU1VQN1dVUmlwVHZr?=
 =?utf-8?B?NXZsQmJ2WWVsVnRROVAxekxabEV2MENNTXV3YjR2N05wWjZlc3FqcXVnUnJu?=
 =?utf-8?B?VkJOZEJLRVA0Z3FQRzNFRkhtTVBESEJsMmUxS0VaT1E0WDVNQm1meVlpMFJE?=
 =?utf-8?B?TVA5amQydG5FY0NSRDQ0SlhMN2dHNmNiZEhISXhIaEJPMHlnMTBCeGdmMEx1?=
 =?utf-8?B?Wm9GdVJUTEJHRExuaUp3SmJqVkR4ZktwY0NCUEtOTHhVSjF2ZE9idkhQZEZQ?=
 =?utf-8?B?OTQwVFNOS2YzbmFRZmF4dU4ybGxwUU9EdHphLzc5V2w4UUgzQzIxbXM4Rmdq?=
 =?utf-8?Q?o9V8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409d2ff2-ed53-47df-308a-08db3bfca87f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 08:54:14.7441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JD/b7xw70e12kpByg2pY74/zR0dW71F6E7oLeWiqkPmJujRAOUX4ufCPlx4TXC/9qbljs2we5fjsAhvB38+9IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFRodXJzZGF5LCAxMyBBcHJpbCAyMDIzIDEx
OjM2DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBlZHVt
YXpldEBnb29nbGUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsZW9uQGtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2NCA1LzVdIG1hY3NlYzogQWRkIE1BQ3Nl
YyByeF9oYW5kbGVyIGNoYW5nZQ0KPiBzdXBwb3J0DQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNl
IGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IDIwMjMtMDQt
MTMsIDA2OjM4OjEyICswMDAwLCBFbWVlbCBIYWtpbSB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogU2FicmluYSBEdWJyb2NhIDxz
ZEBxdWVhc3lzbmFpbC5uZXQ+DQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIDEyIEFwcmlsIDIwMjMg
MTc6NTkNCj4gPiA+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+ID4gPiBD
YzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNv
bTsNCj4gPiA+IGVkdW1hemV0QGdvb2dsZS5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxl
b25Aa2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2NCA1LzVd
IG1hY3NlYzogQWRkIE1BQ3NlYyByeF9oYW5kbGVyDQo+ID4gPiBjaGFuZ2Ugc3VwcG9ydA0KPiA+
ID4NCj4gPiA+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0
dGFjaG1lbnRzDQo+ID4gPg0KPiA+ID4NCj4gPiA+IDIwMjMtMDQtMDgsIDEzOjU3OjM1ICswMzAw
LCBFbWVlbCBIYWtpbSB3cm90ZToNCj4gPiA+ID4gT2ZmbG9hZGluZyBkZXZpY2UgZHJpdmVycyB3
aWxsIG1hcmsgb2ZmbG9hZGVkIE1BQ3NlYyBTS0JzIHdpdGggdGhlDQo+ID4gPiA+IGNvcnJlc3Bv
bmRpbmcgU0NJIGluIHRoZSBza2JfbWV0YWRhdGFfZHN0IHNvIHRoZSBtYWNzZWMgcnggaGFuZGxl
cg0KPiA+ID4gPiB3aWxsIGtub3cgdG8gd2hpY2ggaW50ZXJmYWNlIHRvIGRpdmVydCB0aG9zZSBz
a2JzLCBpbiBjYXNlIG9mIGENCj4gPiA+ID4gbWFya2VkIHNrYiBhbmQgYSBtaXNtYXRjaCBvbiB0
aGUgZHN0IE1BQyBhZGRyZXNzLCBkaXZlcnQgdGhlIHNrYg0KPiA+ID4gPiB0byB0aGUgbWFjc2Vj
IG5ldF9kZXZpY2Ugd2hlcmUgdGhlIG1hY3NlYyByeF9oYW5kbGVyIHdpbGwgYmUgY2FsbGVkLg0K
PiA+ID4NCj4gPiA+IFF1b3RpbmcgbXkgcmVwbHkgdG8gdjI6DQo+ID4gPg0KPiA+ID4gPT09PT09
PT0NCj4gPiA+DQo+ID4gPiBTb3JyeSwgSSBkb24ndCB1bmRlcnN0YW5kIHdoYXQgeW91J3JlIHRy
eWluZyB0byBzYXkgaGVyZSBhbmQgaW4gdGhlIHN1YmplY3QNCj4gbGluZS4NCj4gPiA+DQo+ID4g
PiBUbyBtZSwgIkFkZCBNQUNzZWMgcnhfaGFuZGxlciBjaGFuZ2Ugc3VwcG9ydCIgc291bmRzIGxp
a2UgeW91J3JlDQo+ID4gPiBjaGFuZ2luZyB3aGF0IGZ1bmN0aW9uIGlzIHVzZWQgYXMgLT5yeF9o
YW5kbGVyLCB3aGljaCBpcyBub3Qgd2hhdCB0aGlzIHBhdGNoIGlzDQo+IGRvaW5nLg0KPiA+ID4N
Cj4gPiA+ID09PT09PT09DQo+ID4NCj4gPiBTb3JyeSB0aGF0IEkgbWlzc2VkIGl0Lg0KPiA+IHdo
YXQgZG8geW91IHRoaW5rIG9mICJEb24ndCByZWx5IHNvbGVseSBvbiB0aGUgZHN0IE1BQyBhZGRy
ZXNzIGZvciBza2IgZGl2ZXJzaW9uDQo+IHVwb24gTUFDc2VjIHJ4X2hhbmRsZXIgY2hhbmdlIg0K
PiA+IGlzIGl0IGdvb2QgZW5vdWdoPw0KPiANCj4gQnV0IHRoZXJlJ3Mgbm8gImNoYW5nZSBvZiBy
eF9oYW5kbGVyIi4gWW91J3JlIGp1c3QgcmVjZWl2aW5nIHRoZSBwYWNrZXQgb24gdGhlDQo+IG1h
Y3NlYyBkZXZpY2UuIEkgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IHlvdSdyZSB0cnlpbmcgdG8gc2F5
IHdpdGggImNoYW5nZSBvZg0KPiByeF9oYW5kbGVyIiwgYnV0IHRvIG1lIHRoYXQncyBub3QgZGVz
Y3JpYmluZyB0aGlzIHBhdGNoIGF0IGFsbC4gImNoYW5nZSBvZg0KPiByeF9oYW5kbGVyIiB3b3Vs
ZCBkZXNjcmliZSBhIHBhdGNoIHRoYXQgbW9kaWZpZXMgZGV2LT5yeF9oYW5kbGVyLg0KPiANCj4g
IkRvbid0IHJlbHkgc29sZWx5IG9uIHRoZSBkc3QgTUFDIGFkZHJlc3MgdG8gaWRlbnRpZnkgZGVz
dGluYXRpb24gTUFDc2VjIGRldmljZSINCj4gbG9va3Mgb2ssIGFuZCBzaG91bGQgYmUgZm9sbG93
ZWQgYnkgYW4gZXhwbGFuYXRpb246DQo+ICAtIHdoeSB0aGUgZHN0IE1BQyBhZGRyZXNzIG1heSBu
b3QgYmUgZW5vdWdoDQo+ICAtIHdoeSBpdCdzIG5vdCBuZWVkZWQgd2hlbiB3ZSBoYXZlIG1ldGFk
YXRhDQoNCkFDSyAsIEkgd2lsbCBmaXggaXQgYW5kIHNlbmQgYSBuZXcgdmVyc2lvbi4NCg0KPiA+
ID4gPiBAQCAtMTA0OCw2ICsxMDUyLDE0IEBAIHN0YXRpYyBlbnVtIHJ4X2hhbmRsZXJfcmVzdWx0
DQo+ID4gPiA+IGhhbmRsZV9ub3RfbWFjc2VjKHN0cnVjdCBza19idWZmICpza2IpDQo+ID4gPiA+
DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fbmV0aWZfcngobnNrYik7
DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAg
ICAgICAgICAgICAgICAgICAgIGlmIChtZF9kc3QgJiYgbWRfZHN0LT50eXBlID09DQo+ID4gPiA+
ICsgTUVUQURBVEFfTUFDU0VDICYmDQo+ID4gPiByeF9zY19mb3VuZCkgew0KPiANCj4gQlRXLCB3
aHkgZGlkIHlvdSBjaG9vc2UgdG8gc2VwYXJhdGUgdGhhdCBmcm9tIHRoZSBwcmV2aW91cyBpZi9l
bHNlIGlmPw0KDQpJIGZlbHQgdGhhdCB0aGUgaWYvZWxzZSBpZiAgaXMgaGFuZGxpbmcgdGhlICJy
ZWx5aW5nIG9uIGRzdCBtYWMiIGNhc2Ugc28gSSBzZXBhcmF0ZWQgaXQsIGJ1dCANCkkgc2VlIG5v
IGhhcm0gaW4gYWRkaW5nIGl0IGFzIGFuIGVsc2UgaWYuDQpXaWxsIGFkZHJlc3MgdGhpcyBib3Ro
IHdpdGggdGhlIGNvbW1pdCBtZXNzYWdlIGFuZCBzZW5kIGEgbmV3IHZlcnNpb24uDQpUaGFua3Mg
U2FicmluYS4NCg0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBza2ItPmRl
diA9IG5kZXY7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNrYi0+cGt0
X3R5cGUgPSBQQUNLRVRfSE9TVDsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgcmV0ID0gUlhfSEFORExFUl9BTk9USEVSOw0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBnb3RvIG91dDsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIH0NCj4g
PiA+ID4gKw0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ID4gPiA+
ICAgICAgICAgICAgICAgfQ0KPiANCj4gLS0NCj4gU2FicmluYQ0KDQo=
