Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2426CB784
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjC1GyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjC1GyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:54:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFE2E0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 23:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsxWzWRYQqW3Q7RjNCLjszWT5NzYoiXWA5NCir4oWV3tTs2AmNab93xdmICZpCI95kekBA/ntFGasBvLV3EilaS/gjsbw5G5uaM93gXTMLwhG0qmvQBugaMrF8JlfgenFCSwNPKqDz3A7AbjTlFr/HL+yiSdZjsupy6rTOs0QzL0wfBtI1NUsx4aQ7ReEnuttx538+FJO19UoCmKcPUdY7QKU+NUnQ1jF1kEF85056EgxTrWDQiEdZjFoV1E9c6I3RTc5EeghtzYPQ6Q/XfXxtKbDEkdqpYuq73MX4gkuMCCtejRz13NV661xfS8q1CjN6+aOhA90cJSZ6RGrcwQVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JvL5v0oTSEzd3q9jM/KgEQYaQwVmaIjXVDZ00rx1vg=;
 b=eCz+uGZz+XdnLZsizOI1yNHIXYaXxkOLn0P8pvXNNF37reSdKYqDR2/rOru+YVk8Xq4Hw9A9lCgVIe4OHb+/nmWjI8LaMqPJNkLP7C3xVq1Hr8sP90DCtXidRQwaKqBNuW7USMFKWvzRutF/HPANbHuADl4Y/SrG8xAWwJ5fr5MRdWv8yufz0F9nC4ewU6+hRwFhR353sA6AxeX4kwYyi6f2h9/sJD4Owz2UJ1vU618PuGe4OaABDGsHbQU71AnFLpy5KmT/fzQJQh7VlQLvaTK+3s2tXZW4JXAUG8y0OhoNXbLUSw8HvHFyc8V40eYiwz37lC97ezjEJfsdo0YDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JvL5v0oTSEzd3q9jM/KgEQYaQwVmaIjXVDZ00rx1vg=;
 b=DkXYlxCgY1ib95Kze0VnUH73SlASBViOlulPA+twskYfR7Z5CAupstDKu5kHYqx+5AqSpIt4n3+topwBtSjfRpqUbg6I7mA0JL7sYjlufoRZ8ZU/ko6HK1pryoBVi6MHhwk9Xb4eC5C8cJW8aqivABZYccqdLzQwrOYZU4upaEchqP3ESJkWjZdLAW+NdBtm8gA/8yKUoW1b8ujbno3xLjProZC5FFTKZzLq1K8s+q7fl8mHdOzuXNK3qaSqIY0nSNyFFVAGQpKd0Ck+eAkK7DXTjZpYvWbA5j1xoMgcjwHkC6GtpDG4F6DDHDPErv46KJ73AXF2FpI84HXy1rTxSA==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 06:54:11 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%5]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 06:54:11 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/4] vlan: Add MACsec offload operations for VLAN
 interface
Thread-Topic: [PATCH net-next 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZX7RxM01RMOfCPEGm1w69wBk9+a8O1yKAgADrC2A=
Date:   Tue, 28 Mar 2023 06:54:11 +0000
Message-ID: <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
        <20230326072636.3507-2-ehakim@nvidia.com>
 <20230327094335.07f462f9@kernel.org>
In-Reply-To: <20230327094335.07f462f9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|CH2PR12MB4071:EE_
x-ms-office365-filtering-correlation-id: 7602581b-390d-4f4d-e005-08db2f593c85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nR3VQK502mBrNAx9rXp1rlgfPh/j2qq2NDz6r3TnYhouk/S4kbx9i1N/Lw3e2qDLM5TCGV6zvaxbMEiKdCORZeN+mNt9B0kPWNtyG26GzSPZJrs56sDKoNMx2NdRUtjg/D+3DLngdjmUCwKLuJqCf2K4rZ1r6Qb0aqcCiHH83YMSbL0It9t3PFZpctr7FwBxxwxVloBtaboJOs3g3OpIzCqr+dNvleTjOCB8XKy1oqiQT591N3ukDVR9WqP+HYR4XxI5x7UsBFMe07YlGbR4Za7Gk0KC4UBlu6BGpoaghcBORPqtvVPB0CBq3BcfhdyylvsaiF7W9fFK3EJKSV10oKcWHmDZUjDq8ST2bAEQGyBtgeJcHF7OBdSzUHxlcXPNpT40TNJSXtt4yOO8B4UdwAxYpKvhgC5ZeyCnIxGFqJ47/ajG2gvOvy7iGDo8IZZZIhYNkjpPaHn037yUeigNhpXO3eFIQt8Rh9kw/NAfcPtRz3gZqomBpBYWmlFxzjJBZQ5oVGOaPJIQNWUGbgM+GuoGoTtIwGQs18+vCV4O0/rYl2Dk8e/8Ff45emTq9uiUWUdsfi/YUvZHvT6Uks853pquijraYc/nyKuMdH+TVyS6AnxJQggU3KNqeSQcobRb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199021)(316002)(478600001)(54906003)(52536014)(122000001)(8936002)(38070700005)(5660300002)(86362001)(66476007)(2906002)(38100700002)(6916009)(4326008)(66446008)(8676002)(33656002)(76116006)(64756008)(66946007)(66556008)(41300700001)(55016003)(186003)(26005)(53546011)(9686003)(6506007)(83380400001)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzZpUXo3a1k1a2JDZGhBUk1FdWhPSjI1ell1QVJCbzBITkxhMFNHN3ZrdlNh?=
 =?utf-8?B?aDJSR0JBY1lTVStyZ0pwU2NQKytRN3BBRzl0Ry8vY0NlS3R3R3FhR05rQy9Q?=
 =?utf-8?B?aVliTUdGOW1LeHNscmhpaEdRQTVFaEdLTVFNWnlBSWw0UkNwUWp0VVpySHRr?=
 =?utf-8?B?THREbzJDdkRWWFM3TEdyc2NlcXhiMnk5VUo3V1hmUFdmRzBUYTdFTHRwU25s?=
 =?utf-8?B?M3g3T3gycCtGUGFWdFpUcFRSSkVaMXBkbjJzdHNqN0F3L3ljeTF4aUpJTm8y?=
 =?utf-8?B?Tmw5clBUNmNlZjFEQTlKKzlKd0JjaUkvODRGOVYzRHRJTWZjQU41d2FGQXdw?=
 =?utf-8?B?ZkM2VGU5Q0Y1b2dSWFVPcUVxV3M2dWVDTlBpeXVtNHZwcG1FSGdjTEFsY3U5?=
 =?utf-8?B?NXpRbVR0cWRldEFsNTRjMnJLU0RadTFjenJZbEhLd2FNT2xtR2ZVWTdGZ3NJ?=
 =?utf-8?B?QmhRaUx6YWJ1SWJxVnNJVVhUWHZRVlYxK0VwSkVLeGk2SEp5NlNiSUJLbHZR?=
 =?utf-8?B?YVIxMlZieVBaWmVxeHYvVWNVbEZtTGRwT0tpRXV0TERLVFAwMGJQWWZHRzBz?=
 =?utf-8?B?Zjg0cHYweDR6eDBkczU5eVJXUXBqYWZicGk4QXRweXRvVFJVNC9BNDNFdFJl?=
 =?utf-8?B?Y3NETGplWHoxYkFyb0VCU05KSEFzMjYxY3JuQkRRV3RxTW9zZXJYNzZZRlpS?=
 =?utf-8?B?S1ErYXg5cER1NFB4ZmxGVEluakJqdVptRlBvSmVxTmtsd0lRNDlhLzExOVpO?=
 =?utf-8?B?T29ESjNVc2d0eEQ5dW5jWDBZQ1huVnNsdjNtcGtJVWVVT3IwQVBzQURZMzBh?=
 =?utf-8?B?dU1FSGJ6TjE0dGlDWUJhYXBTelBlWVROSHhmL1d4aFFEbW9GOGY1RzhOaGx2?=
 =?utf-8?B?b2JJY2ltQ2svT0QxWjdwdGduR2hDZ2VnQ1FIQUdZWnZRSGNXVXFDVVJSRHhN?=
 =?utf-8?B?dVU5TUR6Ti9Sd0k0bno5aHlEUlJ0ZFI1dXduVVVGeDhqL2QwR2hlczB2R2Uw?=
 =?utf-8?B?YklaTjdvSlZTdXpUaEdzd0UydDRBbVByb3pqbWJmRzFmd3dJQmZyMzZvaGVZ?=
 =?utf-8?B?dWFRWE93dE9aeVlyQ0JLcFFVWWVOVkpjQkY0ZWJwYmtMNElHbGdRaVVxUTNh?=
 =?utf-8?B?d2pqSGgzUERYSnNsQkt1bDIzRjdvZ201dnJqb1lsOXEra2w3dnlaaXNuQXV1?=
 =?utf-8?B?MnFkRVFsU2V0ajMwNENUMEtkcWJLWngrcjYrNzJZYjJKZU1hUGNmQUN5TTZw?=
 =?utf-8?B?bzFsWjNhOFJMVkNBV0N4MVg2OEpkWng3djh2UHVqVmJlZWg0TmR2bTBxQytY?=
 =?utf-8?B?MDRXRGtqSmJqdEp1Mjh3ci8zamRNeWRVQ1pSUTFCZ3JMYlJ5Kys5aG1zaEhP?=
 =?utf-8?B?WUM5c2FsNHIyc3ZyckNNZ0pVZzluemNVODRBNXdVUlBDMEx4dVJkQ3ZIT1l2?=
 =?utf-8?B?K1dUeG1IeHVCS0NQb0lDZ0M4dDBPbS9SZzFWMksycE1TQlNnMTd3dUtzRURE?=
 =?utf-8?B?VHZPb3M5YVhmcEt0YlUydklkb05LLzVEb3FZTzdIdjFKdHNTYU54SEoycko2?=
 =?utf-8?B?aFNlanl5SjU5RFVtZEE5dElScHRkV05HTXlQaUZmcnBOWVFyTXMzTWI4dFhL?=
 =?utf-8?B?dnYvZTV3VzZBczZRNm9FMjE3d0NUdG01Z21MNFpkKzFrbVNKeFFvV2V1dkxz?=
 =?utf-8?B?VGV0TU1IZmRTZzM5QzJibGlBY29xZzkzazVCODJXUFo2T0RQUmpSTFZSRjEw?=
 =?utf-8?B?dGdRUGNnV1JjYkZoWm9zcHRYZmFNRkh3S3NUdG9BN0tYQUllNjV3N1ppT3R5?=
 =?utf-8?B?RmE1TmpZYjlrNFdONElubysrSHBkL0V3a1Vjb09oWEdlYURZN3liTHpDNENs?=
 =?utf-8?B?RVNCdUZZUnVIN0VaMnQvcHV6RGx5MENWY2N2TWhhcjNXbGVadmdpbUNDaEdu?=
 =?utf-8?B?dnhBTVhxS2MyTmN4OFVJaTNpbStnQm96c1RBMTRCd2R3SENMYy8vN3dXV2tN?=
 =?utf-8?B?OWowdE5jbkVBRmRESVBybWhwUlErN0NwNzVUVE82ZUl0NUtLS0dnbnpueEVm?=
 =?utf-8?B?YVBsMUlBc3ZxRGJvMWNWMXcwTGRaY3RkcTZsVEh2Q2RTNlJLYUtqRmxJUWVI?=
 =?utf-8?Q?aP5Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7602581b-390d-4f4d-e005-08db2f593c85
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 06:54:11.6433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSt78LHV6rjUkashjiMOvS3xHXkm0d9Bn0yJtN6FWHbDiSRdcfApH+buSXSIoLhjl+4W49lqq3W2xNk8+f4W9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCAyNyBNYXJjaCAyMDIzIDE5OjQ0DQo+
IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBwYWJlbmlAcmVkaGF0LmNvbTsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsNCj4gc2RAcXVl
YXN5c25haWwubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggbmV0LW5leHQgMS80XSB2bGFuOiBBZGQgTUFDc2VjIG9mZmxvYWQgb3BlcmF0aW9ucyBmb3Ig
VkxBTg0KPiBpbnRlcmZhY2UNCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVu
aW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gT24gU3VuLCAyNiBNYXIgMjAyMyAx
MDoyNjozMyArMDMwMCBFbWVlbCBIYWtpbSB3cm90ZToNCj4gPiBAQCAtNTcyLDYgKzU3Myw5IEBA
IHN0YXRpYyBpbnQgdmxhbl9kZXZfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICBORVRJRl9GX0hJR0hETUEgfCBORVRJRl9GX1NDVFBfQ1JD
IHwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgTkVUSUZfRl9BTExfRkNPRTsNCj4gPg0K
PiA+ICsgICAgIGlmIChyZWFsX2Rldi0+ZmVhdHVyZXMgJiBORVRJRl9GX0hXX01BQ1NFQykNCj4g
PiArICAgICAgICAgICAgIGRldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9IV19NQUNTRUM7DQo+
ID4gKw0KPiA+ICAgICAgIGRldi0+ZmVhdHVyZXMgfD0gZGV2LT5od19mZWF0dXJlcyB8IE5FVElG
X0ZfTExUWDsNCj4gPiAgICAgICBuZXRpZl9pbmhlcml0X3Rzb19tYXgoZGV2LCByZWFsX2Rldik7
DQo+ID4gICAgICAgaWYgKGRldi0+ZmVhdHVyZXMgJiBORVRJRl9GX1ZMQU5fRkVBVFVSRVMpIEBA
IC02NjAsNiArNjY0LDkgQEANCj4gPiBzdGF0aWMgbmV0ZGV2X2ZlYXR1cmVzX3Qgdmxhbl9kZXZf
Zml4X2ZlYXR1cmVzKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+ID4gICAgICAgZmVhdHVyZXMg
fD0gb2xkX2ZlYXR1cmVzICYgKE5FVElGX0ZfU09GVF9GRUFUVVJFUyB8DQo+IE5FVElGX0ZfR1NP
X1NPRlRXQVJFKTsNCj4gPiAgICAgICBmZWF0dXJlcyB8PSBORVRJRl9GX0xMVFg7DQo+ID4NCj4g
PiArICAgICBpZiAocmVhbF9kZXYtPmZlYXR1cmVzICYgTkVUSUZfRl9IV19NQUNTRUMpDQo+ID4g
KyAgICAgICAgICAgICBmZWF0dXJlcyB8PSBORVRJRl9GX0hXX01BQ1NFQzsNCj4gPiArDQo+ID4g
ICAgICAgcmV0dXJuIGZlYXR1cmVzOw0KPiA+ICB9DQo+IA0KPiBTaG91bGRuJ3Qgdmxhbl9mZWF0
dXJlcyBiZSBjb25zdWx0ZWQgc29tZWhvdz8NCg0KSSBkaWQgY29uc2lkZXIgaW5jbHVkaW5nIHRo
ZSB2bGFuX2ZlYXR1cmVzLCBidXQgYWZ0ZXIgY2FyZWZ1bCBjb25zaWRlcmF0aW9uLCBJIGNvdWxk
bid0IHNlZSBob3cgdGhleSB3ZXJlIHJlbGV2YW50IHRvIHRoZSB0YXNrIGF0IGhhbmQuDQpIb3dl
dmVyLCBpZiB5b3UgaGF2ZSBhbnkgc3BlY2lmaWMgc3VnZ2VzdGlvbnMgb24gaG93IEkgY291bGQg
aW5jb3Jwb3JhdGUgdGhlbSB0byBpbXByb3ZlIHRoZSBjb2RlLCBJIHdvdWxkIGJlIGhhcHB5IHRv
IGhlYXIgdGhlbS4NCg0KPiA+IEBAIC04MDMsNiArODEwLDQ5IEBAIHN0YXRpYyBpbnQgdmxhbl9k
ZXZfZmlsbF9mb3J3YXJkX3BhdGgoc3RydWN0DQo+IG5ldF9kZXZpY2VfcGF0aF9jdHggKmN0eCwN
Cj4gPiAgICAgICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gKyNpZiBJU19FTkFCTEVEKENP
TkZJR19NQUNTRUMpDQo+ID4gKyNkZWZpbmUgVkxBTl9NQUNTRUNfTURPKG1kbykgXA0KPiA+ICtz
dGF0aWMgaW50IHZsYW5fbWFjc2VjXyAjIyBtZG8oc3RydWN0IG1hY3NlY19jb250ZXh0ICpjdHgp
IFwgeyBcDQo+ID4gKyAgICAgY29uc3Qgc3RydWN0IG1hY3NlY19vcHMgKm9wczsgXA0KPiA+ICsg
ICAgIG9wcyA9ICB2bGFuX2Rldl9wcml2KGN0eC0+bmV0ZGV2KS0+cmVhbF9kZXYtPm1hY3NlY19v
cHM7IFwNCj4gPiArICAgICByZXR1cm4gb3BzID8gb3BzLT5tZG9fICMjIG1kbyhjdHgpIDogLUVP
UE5PVFNVUFA7IFwgfQ0KPiA+ICsNCj4gPiArI2RlZmluZSBWTEFOX01BQ1NFQ19ERUNMQVJFX01E
TyhtZG8pIHZsYW5fbWFjc2VjXyAjIyBtZG8NCj4gPiArDQo+ID4gK1ZMQU5fTUFDU0VDX01ETyhh
ZGRfdHhzYSk7DQo+ID4gK1ZMQU5fTUFDU0VDX01ETyh1cGRfdHhzYSk7DQo+ID4gK1ZMQU5fTUFD
U0VDX01ETyhkZWxfdHhzYSk7DQo+ID4gKw0KPiA+ICtWTEFOX01BQ1NFQ19NRE8oYWRkX3J4c2Ep
Ow0KPiA+ICtWTEFOX01BQ1NFQ19NRE8odXBkX3J4c2EpOw0KPiA+ICtWTEFOX01BQ1NFQ19NRE8o
ZGVsX3J4c2EpOw0KPiA+ICsNCj4gPiArVkxBTl9NQUNTRUNfTURPKGFkZF9yeHNjKTsNCj4gPiAr
VkxBTl9NQUNTRUNfTURPKHVwZF9yeHNjKTsNCj4gPiArVkxBTl9NQUNTRUNfTURPKGRlbF9yeHNj
KTsNCj4gPiArDQo+ID4gK1ZMQU5fTUFDU0VDX01ETyhhZGRfc2VjeSk7DQo+ID4gK1ZMQU5fTUFD
U0VDX01ETyh1cGRfc2VjeSk7DQo+ID4gK1ZMQU5fTUFDU0VDX01ETyhkZWxfc2VjeSk7DQo+IA0K
PiAtMQ0KPiANCj4gaW1wb3NzaWJsZSB0byBncmVwIGZvciB0aGUgZnVuY3Rpb25zIDooIGJ1dCBt
YXliZSBvdGhlcnMgZG9uJ3QgY2FyZQ0KDQpUaGFuayB5b3UgZm9yIGJyaW5naW5nIHVwIHRoZSBp
c3N1ZSB5b3Ugbm90aWNlZC4gSG93ZXZlciwgSSBkZWNpZGVkIHRvIGdvIHdpdGggdGhpcyBhcHBy
b2FjaA0KYmVjYXVzZSB0aGUgZnVuY3Rpb25zIGFyZSBzaW1wbGUgYW5kIGxvb2sgdmVyeSBzaW1p
bGFyLCBzbyB0aGVyZSB3YXNuJ3QgbXVjaCB0byBkZWJ1Zy4NClVzaW5nIGEgbWFjcm8gYWxsb3dl
ZCBmb3IgY2xlYW5lciBjb2RlIGluc3RlYWQgb2YgaGF2aW5nIHRvIHJlc29ydCB0byB1Z2x5IGNv
ZGUgZHVwbGljYXRpb24uDQo=
