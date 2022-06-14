Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7754BC8B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358034AbiFNVJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240857AbiFNVJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:09:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8924F1DF;
        Tue, 14 Jun 2022 14:09:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUXeEKq0Kx8CFe4JtN9+fmAhgN0aKvFwC86GzSgIeKchGB3Eod76v3+QRYHtx9F+vvQfDp1I6qUZYyYcTAKmZsYfn9m/QFfLLzpvIMXOyRkjv8uiw93MBCJNNu9VHScQpaGyUFwTBEzZGxF1OrSsMGaGLkk2qRD0rIFNTf9/RvG9qme3XYfC3A8GcxMpzbav2nYuzZyuRWMqE9dQYo+7Be/mGbLuY5UnNxfEWKT8gzLnMaJtwH0F0pjPgzenbuFzWSKxGHCRk6C3yPShZw5d3pOMHFUbZWs9YE2bQkMWqzxLqENDxYL/NuvWfymBXiPhse6vdx1X6qn5d3IJnQlIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNVq/7/+7tVV0T7Mh7V33RjUYr9wa3lRzStdrQoY94Q=;
 b=NWtEHNoHuh9IC0drvBra6nF2hMlnorplH2S2JuEsmF44urPe7RS/nIkKz8Ft98nLOQxwcuZ8JarFVNx6XD87UTbC9SjqZ9/NLuniBdQs9OQBZFd04tbZBXlFbD2w3IjTvrRkA0d4g8M8XpptQcLF+iwzBECVDqpBXlmLQZ04iOEMV+EtaShr+nAVepDqs0Ya+yJTXvwVxwVvOZGm6p7rNTS2EizNWQLVY4OW1tkRbsGVPhl57bluvxe1Ob4aN9TdWpsmr+G6HFH2XcrjUVScv51R9c3s/tnV5xXb6ZcTdBkJvoi3IvVKIMwG4hJREh/ZxlxK3VuB70nXnLrOR8jzmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNVq/7/+7tVV0T7Mh7V33RjUYr9wa3lRzStdrQoY94Q=;
 b=OBj3tY+AfGGlql0Dz2PLks2+TWZ7eU7/Oe8JBMNrz9ly0RFnWOweqA6+Jy6KNFeQEaacPvRaqbDS/eOpEeIhF+x8bHwrkx4wezvIc39UK6Ct84k8lnPrZcSjh/WJuU4/HeLEt49e3y/4BhYNroNIWzXPf1L6Dn38jzC54daGHYY=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by BN9PR12MB5339.namprd12.prod.outlook.com (2603:10b6:408:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Tue, 14 Jun
 2022 21:09:28 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::cd5c:e903:573f:bda5]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::cd5c:e903:573f:bda5%8]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 21:09:28 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "Katakam, Harini" <harini.katakam@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH v2 net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Topic: [PATCH v2 net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Index: AQHYfCGwxNhvfGqwSkinlveqX1oqma1OpKiAgADErEA=
Date:   Tue, 14 Jun 2022 21:09:28 +0000
Message-ID: <MN0PR12MB5953590F8098E46C02943AFEB7AA9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1654793615-21290-1-git-send-email-radhey.shyam.pandey@amd.com>
 <5e5580c4d3f84b9e9ae43e1e4ae43ac0a2162a75.camel@redhat.com>
In-Reply-To: <5e5580c4d3f84b9e9ae43e1e4ae43ac0a2162a75.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=54fb13e1-cd9c-4c34-a801-0000daf0df43;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-14T20:53:27Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30c132b5-953b-4bca-aad8-08da4e4a2b33
x-ms-traffictypediagnostic: BN9PR12MB5339:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd,ExtAddr
x-microsoft-antispam-prvs: <BN9PR12MB5339DC0B6A559A939FAE8018B7AA9@BN9PR12MB5339.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /8TVFJ61zWgOhbetQ/wVmuuV4cK5cOJ7Wo77SGlnwjm+tszKEPmGAudyWk5ZveMmKIOsQUMAAWJtosjiSj2iY1hHUv6RFg+nFOjBQKpAI7ExxYGdKZgrO3GRXStfgFm+QtzN0wMmAx/RBLRsLze9z4+BMmZ+kuN2OhvsdEkjwJiVFe1oBQEiziRI7TkJMg72GcCJw9sdqeiWfAsAXDslKa6PuSQYGPy1oCqcr3F+V4HVXmzf0duH6o4LBvu/P0fNd0lHoVxoIe0H/gLlVZamZHOseue6HwF0mueEJj4ofxJvdHrM/m2rT7ETBdJFeksMJiSuwZPv6eiGv8lar75qnAAKKTccAK9ME/UPbY6dyvHNQF+QvZUCQc9xm6KpAIJLPM62aSHpJXGpqxV/iRCDY/9WxnSBSNlz2ow+GCbnzByBekE5i5I8R5QtoauZ2uFFZ4JgEnn5QnppDEAjnPHHowytkAI7Cy/2TYrucc0PjmtlG9UXhqSu/jLlcdp/IS9c87xtjScKeskKJR1E6WXX/LTUS5sMybnFtw7ioXeRCBJ0nqfY433QrTNmR0mfFZX53QXq8/k94so3hlwLjK6MxK66izJeOPreLK34hX8WlSZCOaQWNtRhLqWxiolqM0LtRcLgMf68KDssi1EVz/A0WcLAj503cGKmuTGLPClvoR3WRE3SY025fw2kWjlI87PvpCQls7LDCEY+2sCDyTTGxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(186003)(86362001)(55016003)(83380400001)(64756008)(76116006)(316002)(66476007)(66946007)(66446008)(110136005)(66556008)(71200400001)(54906003)(6636002)(8676002)(4326008)(508600001)(6506007)(7696005)(53546011)(7416002)(8936002)(52536014)(33656002)(2906002)(38100700002)(122000001)(38070700005)(9686003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHM4TTNabjh1VlVaMDJoZ0lBYldaNWlHOTFqdTB1U2FWZDZ0aERrVFY3MFYz?=
 =?utf-8?B?UlZac3VkYmxNdVFlU0FmdTEzcnd2eUwyQUhsTzBGN2V6UzF5MjE0TnR6VlJE?=
 =?utf-8?B?MWRSWEM3ZG91S2ZZOWVvRDhiWVNNaDVGZldqL01zQ1FMWjNQTHN6N1Y2aHR6?=
 =?utf-8?B?WjBsRitBcitiQ3M4Z3dSSi8xeWRYZkhidjd4WXYwcS9kUmhSczhzdENyWFBW?=
 =?utf-8?B?N25kcDVncVAzRUlmOXhHaTZERE5Ta0JlajYrNmp1SzE0d0Q5Rm50endVWll2?=
 =?utf-8?B?a1hTM0w5cjJvQ2tuRVBzWG8wM0lISzRPYUk3a0RZUExLbU9hUWZybjUycHg2?=
 =?utf-8?B?ZFh0VmFCOWlFSjFDZ3BxR0Zrdjc4MXZQZS9OMThmbFlCSVNFN3FseFN1RTJw?=
 =?utf-8?B?cFF5Zlo4WDMrVFFpdEFVNEd2dkhOazk2aU42clg0SThtejJjSjU2MWE4WW9J?=
 =?utf-8?B?T08zZW9KRDQxYy96b1lGM1pKbEtLdVhtcExCV2xOZjI0UGVDOE94aVI1SUtq?=
 =?utf-8?B?NDVBWDM1bSsyZm1CRUZZYlYvOWRlS1QwM0ZQemk5dHEvK3hPSkFTRlJObjZB?=
 =?utf-8?B?VSs5YVY0YWVVamdpb2dnTWlTZ0RWSE12eTJPMUl4RHJqeE9MOTMzWEtFenUx?=
 =?utf-8?B?cVc1ZUx4MTM2TlkxalRzakZra1dCT0RBQXBDVW1XcmR2cm5naVpLT3k5K2ZP?=
 =?utf-8?B?bHFuREhPVHR2UC81em1NZUphb0ZJV1FMdEQ1OGZwR2daNDhGcFZ2YzhReFdr?=
 =?utf-8?B?Lyt4b2hyU0N4VHEwem5scUw5QzhJcnVZY1Qvbkc1LzJPckdmQm93Z3ZVUllL?=
 =?utf-8?B?Y3VOcklkU2VyN2NNbDVMNk1OenZGME1aVkx6T1p4WFlubnVvSXlmNFhDcktI?=
 =?utf-8?B?ejRkVkVlZTNpUU8wQkpMdUpYNGxtN01yMmRWekh5Q1hCQkM3dEhoSDBJWnFK?=
 =?utf-8?B?QWE2VDVwaTB2RlRXS1V5RVV3K0llZnlNZjdvWGdvYlNRRnRRQnQvSlNEUE9Q?=
 =?utf-8?B?emhHN2hyNHdOdzQvbGRJNzRZVXZEQ2pLMzdQOEVybHB3bFZOUW0yL3V5cTdm?=
 =?utf-8?B?bTkzbnZaalVKQmRrNEdGTjFoa0hqR2FiYXdScGw5SjQ0ZVYwZDJKMVJ5cFdH?=
 =?utf-8?B?UXBTamNmbmVCU0c1MlVsYjBwRnByZmUvb25RK0pzZ29ESDRwY2VxY2loSjBk?=
 =?utf-8?B?cWx3elJqbFdIdk1VTkFQYXBRZHN6R1FqZFpKNE1OeFpmcW5tL1FSakZ2aTN2?=
 =?utf-8?B?dXlwNzErdlNucUk3N2t1WVY5RGxNbHd6MXJNTWlLZCtCZ2JlbE5sazM0Vklw?=
 =?utf-8?B?UldtVkM1bzBsdlYvcXJSNHpiREtBWUhuaGZYOFV6TlhWemVvN3BxbVlqVXFy?=
 =?utf-8?B?V1lHUWNsS09HQ0czcElKaTg3MFZnMCt2WkpBdjhJT3NlY0RwdXAyS2R0eW1z?=
 =?utf-8?B?c05BNlRIYVczZUs0cjFqMTNRczF0MVRjZjVmV1NwQ2d6bUd4OFVHYTRJdmhN?=
 =?utf-8?B?UGx1VXJLbFMxMHc0RTd3dzVxTVhLTkw0bURkZ2g3T3dPcnpTdm9xZ0hKQ1pE?=
 =?utf-8?B?ZUY3OUU2ZWZPTmkyb3JwVG5HTVNIT3ZpVW55bHM2bXNRREs4b1RoMXpSSXhB?=
 =?utf-8?B?eEVMeTZIU0cxRW84RWpVclFMYXcvN1dZOCtYc3lRTjN4bUlycWFTcEZCQlkr?=
 =?utf-8?B?c01MbTQvZU9vd29sZStHTEtkWnNUTWZTNmpEb1F3cFZVSWlkYnN1R3BFNHNV?=
 =?utf-8?B?dS9jRWxlMWFraTdXTXNHMk9qTjBDbEl6a2JuVEdBemJvSVVwbktZUXlXNWJJ?=
 =?utf-8?B?Y2Yrdk40WC8xaUpycWtRdlpSZjdGT1pURGZkNldpUys1RDJ2dlExSU4xdVB1?=
 =?utf-8?B?N29Da2VCSVRIWTExRVJGcUo5anQ1bGNFT21RcDZuS2MyYTdtNU1zVytRNlN2?=
 =?utf-8?B?L2tZOXRBWEVSV1FpelZrWS9NYzk0YnpYZmVZYjE3MzBDS1FOWGgvY05SY2RF?=
 =?utf-8?B?RVpKVWV3TDlrbkl4aTNtSml5cjgyelRIallEU0RNTWxkV3NmckpvYk9na1Jl?=
 =?utf-8?B?cm1MVTU1Q3hyVFBrRVh1MHBFL3M4WUZnZUhZVzJEZjBiSXAvNnBhUTNOM2Vh?=
 =?utf-8?B?U0JReW92dXFPcnp4bStPaHVPWnU4QVpkMGsyOGhOVmFoYk9zMENEenlBTWFm?=
 =?utf-8?B?Y0w3bUlSUXpCY3dwQ1lUaktkU3IxTTZMVTBqYmRHTVMraTlXQkx2aEJBVUNs?=
 =?utf-8?B?Ym82aW1xVXYxTXZselFQQnYvUlYwTWZPNEtvaWNOeE1QVzdMNXlEQUNUaUFE?=
 =?utf-8?B?TW1KdXREYVRFK1ZvM2J1U1pOcGtMYXU2MU9VaWpmQzI2aHFVaG96bnArQ3F5?=
 =?utf-8?Q?5vs0PH2pMYbKp30sI2Hz7WjoKiYlaqh4yP/qH4CSx9TVW?=
x-ms-exchange-antispam-messagedata-1: gJ3XtKkjB+ge7w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c132b5-953b-4bca-aad8-08da4e4a2b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 21:09:28.5543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6jbB14CJwIFVpNmvrwkj8QVk+hES3CoDz323zkvdKRaaut9smb3hg7Nm/V+yK0W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5339
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPiBTZW50
OiBUdWVzZGF5LCBKdW5lIDE0LCAyMDIyIDI6NDAgUE0NCj4gVG86IFBhbmRleSwgUmFkaGV5IFNo
eWFtIDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0
OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHJvYmgrZHRAa2VybmVs
Lm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOyBLYXRha2FtLCBIYXJpbmkN
Cj4gPGhhcmluaS5rYXRha2FtQGFtZC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHYyIG5ldC1uZXh0XSBkdC1iaW5kaW5nczogbmV0OiB4aWxpbng6IGRvY3VtZW50IHhpbGlu
eA0KPiBlbWFjbGl0ZSBkcml2ZXIgYmluZGluZw0KPg0KPiBPbiBUaHUsIDIwMjItMDYtMDkgYXQg
MjI6MjMgKzA1MzAsIFJhZGhleSBTaHlhbSBQYW5kZXkgd3JvdGU6DQo+ID4gQWRkIGJhc2ljIGRl
c2NyaXB0aW9uIGZvciB0aGUgeGlsaW54IGVtYWNsaXRlIGRyaXZlciBEVCBiaW5kaW5ncy4NCj4g
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5w
YW5kZXlAYW1kLmNvbT4NCj4NCj4gRXZlbiBpZiBtYXJrZWQgZm9yICduZXQtbmV4dCcsIG15IHVu
ZGVyc3RhbmRpbmcgaXMgdGhhdCBzaG91bGQgZ28gdmlhIHRoZQ0KPiBkZXZpY2UgdHJlZSByZXBv
LiBJJ20gZHJvcHBpbmcgZnJvbSB0aGUgbmV0ZGV2IHBhdGNod29yaywgcGxlYXNlIGNvcnJlY3Qg
bWUgaWYNCj4gSSdtIHdyb25nLCB0aGFua3MhDQoNCkkgaGF2ZSBzZWVuIGEgbWl4ZWQgc2V0IG9m
IHRoZSBjb252ZW50aW9uIGZvciBkdHMgcGF0Y2hlcy4gVGhleSBhcmUgZm9sbG93aW5nDQpib3Ro
IHJvdXRlcyBpLmUgZGV2aWNlIHRyZWUgb3Igc3Vic3lzdGVtIHJlcG9zIHByb3ZpZGVkIGFja2Vk
IGZyb20gZGV2aWNlDQp0cmVlIG1haW50YWluZXIuICBJZiB0aGVyZSBpcyBwcmVmZXJlbmNlIGZv
ciBkZXZpY2UgdHJlZSByZXBvIHRoZW4gSSBjYW4gZHJvcA0KbmV0LW5leHQgZnJvbSBzdWJqZWN0
IHByZWZpeCBhbmQgcmVzZW5kIGl0IGZvciB0aGUgZHQgcmVwby4NCg0KPg0KPiBQYW9sbw0KDQo=
