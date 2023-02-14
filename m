Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4766961BA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 12:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjBNLDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 06:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjBNLDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 06:03:54 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D147E2595B;
        Tue, 14 Feb 2023 03:03:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYtVAwDFHBu+yd07u1Zg05jpEgzEQ0Gxa8tJMNwjXQNb+dJo8MXWkX/VQMS+D6kY2Fb/KYcEaiBPCIR134pB34aZTAzviQmJObimiGlVSeCxxeP+xPRUxYQmpmuTL8bm0GP7oTU8tNIP5UcU7geFAWXvsM+uY3POlwylERA5gPeUCqs6yLnrL4shnMSq46q55G8B4BL+xJAA8M/0JglbIW4KbjGq4Jbb08FCZJUVa5yid3E4FkhMXIGkTJDxdwEjFJ68Wi/li4O0+0hxTgi3Z+Q62TeYQ/tkLNpWr06mZtY6pU4xf29CeTPk39SJPnNlmEr+//yaRJje5bu/Bi5Oiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAaLM8oZ1wJrFpKV2cSJUgE5fZ5VzFg6xs4ksi206XE=;
 b=GqM1aMSiK0VuWLjNvYjR8BEqmG3kW07BKj4dr1HnadzNhyIXEssgh5BEhN9d/EUYzh9GMfUTOMDRZdzIkeQmJC+ZDlGH44sjVIoD4KrgQiYR34hDJbq/QiMiQNpIWgxJ1zM+9fYrKqowYax6j4WkIVn0lB1ZRRtPaSUN0tCPxGsOUVBj4+CPXNvhAPUr4AulAaL/KE/3AYQ3qsb3eno+tXyJ/l+IFfoO+vVl+QzZBHPEV5ofrzFpUvS0PkaTNXD7PcM3BX1+cGur+MYJtp6yrV9UlGZP2PFEpKe8DJwJRpSr6qbxh8SqwyGmdNogTR1tXFhugrDQej0is4fdX5+z1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAaLM8oZ1wJrFpKV2cSJUgE5fZ5VzFg6xs4ksi206XE=;
 b=Q/h+tR3wTfH/WVIyV+QVvj2z6W8GDt5NEjUezXsKsWqaqT5cO6i+QQoCEPHCGL5FVVPXp3s0KxWwHqkEcxQWnZgtLOSWN+NE6g6sccSGWwaxmrCZUv7yz+446N0RcGuDj3Qi9Xuw3MdrKJnv8eaXX7VGF5po2glnABNc2tgBgnc=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by CY8PR12MB8364.namprd12.prod.outlook.com (2603:10b6:930:7f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 11:03:47 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::768d:8c42:8fa5:fed7]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::768d:8c42:8fa5:fed7%4]) with mapi id 15.20.6086.023; Tue, 14 Feb 2023
 11:03:47 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
CC:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V4] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Topic: [PATCH net-next V4] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Index: AQHZQGAzYraJlHmeo0mPRFL0uO5GN67OQVIAgAAEQoA=
Date:   Tue, 14 Feb 2023 11:03:47 +0000
Message-ID: <MN0PR12MB5953FD8448FF6005A14ECF52B7A29@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <20230214103611.3599624-1-sarath.babu.naidu.gaddam@amd.com>
 <e70ac74a-c5b6-798d-d7ef-9cec432313f4@linaro.org>
In-Reply-To: <e70ac74a-c5b6-798d-d7ef-9cec432313f4@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB5953:EE_|CY8PR12MB8364:EE_
x-ms-office365-filtering-correlation-id: a0beab24-9e61-4bea-89ea-08db0e7b2597
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c8epB1vFoIykKQ61QPWiT3JVyDpg7Wu6rBUv0EUlj1CF2AJEIdTqtII3mKZboPScxtsFKRybozWG8VoB93vf64ckQKz6BdcLQT5KpmDmFjD3Z30Y3y0WY2pE7MQig8xuUnrDlVyO8KBnRaPe33zoFGzWQbrG+nuuTFvCXssy7oqpMApl7EDvnMNVBVMbLcqMmb1zcGXihIKp1Im3pAeYIYjKqS4nhwWDHjpU6X/rPk14FPFPTgk8gsVB1GN7CyPNfZJ4VdGI8MLZTOIAro3Qf+cmrqWq6d5mKpPJn7pEcEqq7fEnog5xGhLyAVXSdK1pkAfePyA85mSfUPTppCG2KVQRjfsceW5913i7StrNsQWFePqSP3y0UABvw/+LHj8XoCqzeRToB2bThx68T02+uRZCgSrV+quqXr1z+VZS1TnrvgmUR+Rk75dsGefeW98B2UnIzSE7/zT+LulphDkimjAYkC4Sw23usE6f7/+7INF/wiOWZSGg9qIvltHR5ujZMgjkcQUx6B5l/zCDRd7nuWZXHnH/7cmAoFH7Ru3yf0xjRsNssNcXEPntZhjij5lBgVavgfv0asl2JhQDQNqKI62voJ3y23ql+dre1M5BoKZ9ZcJnx1RzSoLPhk9Z2lF7cuzEnlTE+eg3KZ846Vsfjwo6aROMdCRBKWqNuksqsDCdt4huRHl9F7PIcT3efegJtApHVhQTI9ubrZBrZOHqag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(66946007)(33656002)(83380400001)(122000001)(66476007)(55016003)(38100700002)(38070700005)(2906002)(52536014)(41300700001)(7416002)(71200400001)(8676002)(54906003)(5660300002)(8936002)(53546011)(9686003)(6506007)(186003)(110136005)(76116006)(7696005)(86362001)(66556008)(66446008)(64756008)(4326008)(478600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkV5UXBudjVIaVp0WWYzUHgrOW10T3dHYUVRMVVvZlcxMFdicDJ6ZzRzQXBZ?=
 =?utf-8?B?MjNBUUZBT3JTM3l3ODhKZ2kzTllreS9zZ0dXeGpuakpDQmJ6QkhYOWpPOXo2?=
 =?utf-8?B?RnNRcnMzR0NYWkNwOTc0STRVZWNZMi8yR3lNSmtjRjFWcjZkN1l6ZXllVTJu?=
 =?utf-8?B?VldyWUJnbGtWV0JuWFkvbEJXeFIrN1pySzFVQXd4dEdjUlFmd2RWSVNqVjBI?=
 =?utf-8?B?TGpjZFkreEJQc0hhNVIrVTVVMGo5QjJsUkc5OGxJc2M1a1l0amxNN0tSdjN1?=
 =?utf-8?B?eE8rRVloWnd3blI3T2dTbmlBaVlWb2FVWi9BRFpiM3hubjVYQjczSVJRa0Ra?=
 =?utf-8?B?MXZmSHJVQXV2Z2VKeVBRUFU4N1FuNWhtQ3VNdE9hRldrcS84SnFpWGJQU2g3?=
 =?utf-8?B?UEVPT3RRYnIvbURuZWtCNGYwekh1TjJ0WnFmRFJPdGJQcWdVSTZlTGlZT0R4?=
 =?utf-8?B?d3lnUWx2bDdRT011S2dLYmxxcXltUlVWaXhndi9hOERxYUJWb1ZTR3NJUnYw?=
 =?utf-8?B?NzdTbHVpQUFvdno0dU5GL2w1NjRseXI4YnNvVFRjK0pWb09KbGtpWnlGaWpS?=
 =?utf-8?B?L1dxU1N6SGE5ZTJwakhOSjhuS1U1d0JubzlRTFhGMDBFSCtpQ1VPdjllUmpn?=
 =?utf-8?B?d3BJeTBvSE5Zdmw3M2JwazVYWU84L0tYSDN2Nmo4dThHM3BIU01XMmQ3a2U0?=
 =?utf-8?B?KzBiMDEyajBpaVZEeTU0cGpBY3hGdXRPZFFSUi96ekh4OUUrMExQdVZaVnpC?=
 =?utf-8?B?eURHSHRwQU1sampuNkdJNXFYSkpMa293c2RxUnRLOWNpQmlCSXRsdWtOWmQ3?=
 =?utf-8?B?eEh6VTJST0k1M0tWVUNQVHpSSzExVEVpbkdnUGRjb1NjZEtzdmdQanBRbnhS?=
 =?utf-8?B?S1NlZjN4K0YwSVB5R0JJeW5wSFU0cG90RktNUUkwT0JadytFMGVEN0FIMmFG?=
 =?utf-8?B?QnF4TE8vV3JpVTV4OFpKS01PeTh5S0xjekVFUStPcFlVM3JnNTUydFpZNE9n?=
 =?utf-8?B?UEJGK01JekNaTHFmWXRlSWZlNWMvVUMwUzJTRXhzSzcvaDJYZlBzWGhiM1I5?=
 =?utf-8?B?M0tvRG5FWXNwVHFxTmx3aC9CbWRHYzFjcDBMM2FQc21xSWprTTEvZDA3clNa?=
 =?utf-8?B?djFKZnZXNHF6Skl5cmg1ckZXQ0VORGxkbTAvdEU1ZGZwLzNwVU9ib3cvb3lq?=
 =?utf-8?B?MG1aVFY3WFR4U3FIQzlhczlyTUdOMjhHRmVleld2dGhUY0J6UWxvb3Fhd3R2?=
 =?utf-8?B?ZmVZTVQ4Q1ZFY1lkcE81ZHB6VlMyNlMxZDJmWno2TlFBbS9IRUxTTmlibWVY?=
 =?utf-8?B?SFBLWE1vTHZXRVJaUWFrWnZqa0VtcCtFc2JBVUc0eFZvZDRFVTVTemJ4bHNK?=
 =?utf-8?B?QzZqVVdBeWluSlZJdUZJVCtMak1VUnVDWlR2MWZFcG92bzBvVGVoTG9pbllK?=
 =?utf-8?B?U0FHUXNMc0xyZm95aSt6V0ZaYUpYOFBmNjVXL2phOXZjNGdrVUhoQzlmZ3M4?=
 =?utf-8?B?ek11OWRydURLaDNjWWFKUFNmU2FTdnlwTnNkMTAyTU84TUtWcFBGRzl6OWF1?=
 =?utf-8?B?VlZPK0NhWGJWVVY5ejROZ3Z5MzRMby8wbU5IMWJ6S3lpdnp2QzZMN1FYS2Jl?=
 =?utf-8?B?LzI5c0FMU0Q4dnpFNXVBWmxZcS9FWFg1ZTUwelM0dGQ4RmliVGRhN3JSU0xW?=
 =?utf-8?B?YWlaMDlyZFFlWm5Sck9pOE9Nb2ZmOWR1blFhZmllSWd0eWZLYUcwN3E3Ukxr?=
 =?utf-8?B?MFBJRmFNOFFDQkJxQ0pBR2t0QVo2M1RxMWZ2RTk1SDVzZkI3WkdvQS9JOTcw?=
 =?utf-8?B?ekdZRUd0ZmQ4Vng3T1FsaVRmYkYveVVocS9Db1JlWFV5aGpXbklIWFJwcDcw?=
 =?utf-8?B?VDI4cDVybEZZZHdFdjBHWjFsZ0tUeWw3ampta0NkVDVZQm5DUXRBN2dqY1B2?=
 =?utf-8?B?ZTQ4K0QzU2JyVFNCM1Q2TG53clhVRFhWMlFyZUlteXNNRFNCRGExQWV5R2dX?=
 =?utf-8?B?anhkVVR6TWF4akFPb0QzVGUraVB5YXA0aUFaa0JEcldjWTVDT2JrbkFlMU9y?=
 =?utf-8?B?dk14Wld6T3RaNDhWRk5UQUVpK3hvQzRvY3RCYWhLTWo1MnA0UU90N1JJWitQ?=
 =?utf-8?B?MzR6bG5hNzlDT01YUExlamg3aUg5TENaWitva01qbjU1MDVlSXdWU2FiVWxl?=
 =?utf-8?Q?7AqvJjZIB2QyHR18qN+s8js=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0beab24-9e61-4bea-89ea-08db0e7b2597
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 11:03:47.7044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gJBJMdfDhO6BG/GIZHqPYCuT7RJGQW/Du2+pq0egx1xwd9+0UBMbLfk+Rw8hlr/L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+IFNlbnQ6IFR1ZXNkYXksIEZlYnJ1
YXJ5IDE0LCAyMDIzIDQ6MTMgUE0NCj4gVG86IEdhZGRhbSwgU2FyYXRoIEJhYnUgTmFpZHUgPHNh
cmF0aC5iYWJ1Lm5haWR1LmdhZGRhbUBhbWQuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
ZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNv
bTsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5v
cmcNCj4gQ2M6IG1pY2hhbC5zaW1la0B4aWxpbnguY29tOyByYWRoZXkuc2h5YW0ucGFuZGV5QHhp
bGlueC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1hcm0tDQo+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYXJhbmdpLCBBbmlydWRoYQ0KPiA8YW5pcnVkaGEuc2Fy
YW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5pDQo+IDxoYXJpbmkua2F0YWthbUBhbWQuY29t
PjsgZ2l0IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
bmV0LW5leHQgVjRdIGR0LWJpbmRpbmdzOiBuZXQ6IHhsbngsYXhpLWV0aGVybmV0OiBjb252ZXJ0
DQo+IGJpbmRpbmdzIGRvY3VtZW50IHRvIHlhbWwNCj4gDQo+IE9uIDE0LzAyLzIwMjMgMTE6MzYs
IFNhcmF0aCBCYWJ1IE5haWR1IEdhZGRhbSB3cm90ZToNCj4gPiBGcm9tOiBSYWRoZXkgU2h5YW0g
UGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+ID4NCj4gPiBDb252ZXJ0
IHRoZSBiaW5kaW5ncyBkb2N1bWVudCBmb3IgWGlsaW54IEFYSSBFdGhlcm5ldCBTdWJzeXN0ZW0g
ZnJvbQ0KPiA+IHR4dCB0byB5YW1sLiBObyBjaGFuZ2VzIHRvIGV4aXN0aW5nIGJpbmRpbmcgZGVz
Y3JpcHRpb24uDQo+IA0KPiBJIGRvbid0IHNlZSBhbnkgY29udmVyc2lvbiBoZXJlLg0KDQpJdCBz
ZWVtcyByZW1vdmFsIG9mIC50eHQgYmluZGluZyBmaWxlIGlzIG1pc3NlZCBpbiB2NC4gDQpTYXJh
dGg6IFBsZWFzZSBmaXggYW5kIHNlbmQgb3V0IGFuIHVwZGF0ZWQgdmVyc2lvbi4NCg0KPiANCj4g
QmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg0K
