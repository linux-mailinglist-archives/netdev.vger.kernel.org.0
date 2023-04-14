Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9CC6E1F13
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDNJO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDNJOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:14:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38061FFB
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfmANIKvCJC5xsQBLwgF3lPQGiA5PjGmwmuHpwvHl+ZpURD61LOrKGbSzvsb+5M1zX3do8Nse5HXcuYUphzjHL2uspDArYff/Wb0dterQFQ5cuAOZ1WrXGNPEOOYxq/M3KwosULtcqU2m/5EGwy9Rc/ssLqzXvSs2bUvSJAYu3ebqlLsWAHam8o6JkmttkwGCnkqnr2fZx4MJDoMDgi/Zk799iHm1+jh+9CxICFK9qgGDrpBcYx3qSFPXi1b8OzmJMxlT7uD1G8lAHjttq15E11xkaV/rR8RsorOJIDZ7gHLs5NhPzHWmDKMD8/1VAXX0Pgi4BoTfVrP2JHG81A/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRi9hEjmRM+gNn6XCP5VzAGj5v4KdAKxGidTzPnSSFQ=;
 b=CGQBXhnW+bzD/4GILB38IKX60W1HBtG1Ufmo/fo93kbRkOwFWYC0sDLU8pZzrkHfu2eL3ZU7hSYE+pbe8E2cB6ml5NcUi5MHV5asYDY2lq/plXhfu1ToYjKdrmipAKqccgYkW6r6FAIUuOu9bhO+X6VXGsvMZP85rqwyCzvg6U/KF+7orX+8EUP6/1VtKSjjWn51Gv4mIbqAG9B+yIea7Yig18dXP9NFYJR+hUQLWmv3Jq037goEWG0UX+Y7hCIaSEAp2davr/145Xs++kNfBjgypWUK01fJpXbSEAMprTTJlkiJLzcmM8eywa2b8dHjp8m9GTtXdf0n0rFgmEBxeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRi9hEjmRM+gNn6XCP5VzAGj5v4KdAKxGidTzPnSSFQ=;
 b=klNPUlI+IAJIvV+L5G7DpuSWEZ8QonFUbgoP20JyAM+wcnOB9ym6iynWu+xGDnEe7u/LSzTIFyZP5hDjqFYcGYIpb/ULom33u4WgR3l3nSTzprfqCwgEn/4aGDvY6WJ1o1332chDRgjEti/ySpDVvdOZ3fmWBaxrcbA3WvLoiq8=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by SJ2PR12MB9007.namprd12.prod.outlook.com (2603:10b6:a03:541::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 09:14:41 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 09:14:41 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "Daire.McNamara@microchip.com" <Daire.McNamara@microchip.com>,
        "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Conor.Dooley@microchip.com" <Conor.Dooley@microchip.com>
CC:     "Simek, Michal" <michal.simek@amd.com>,
        "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>
Subject: RE: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Thread-Topic: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on
 mpfs
Thread-Index: AQHZbjJS5QS1FJjqOkikSy+QCP0ZR68qgpAAgAADsBA=
Date:   Fri, 14 Apr 2023 09:14:40 +0000
Message-ID: <BYAPR12MB47731CE29417CF5B4879D3429E999@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
 <20230413180337.1399614-2-daire.mcnamara@microchip.com>
 <fb680e8f-4385-f54d-5827-6f2e3034703c@microchip.com>
In-Reply-To: <fb680e8f-4385-f54d-5827-6f2e3034703c@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|SJ2PR12MB9007:EE_
x-ms-office365-filtering-correlation-id: c8149228-c5e6-4022-613a-08db3cc8ada3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7NORBJTy4wJcmlLsXv8AtF0p7zqikuTCRIhRk9lJC6kj+zNVBrBJu268ytc2EDOV7LrC7oJHDsgbDF460EtPt+mjDuq/plM1Tnk5ZLlQInDzmF0scDP12ZcWWWTyFzo7JRkgS0P+HcTcM8Rtn9dCbyp+gMUlNCLSuJ/NMNW0eY8+hH74fjS7eGslNkEBai7AX0wJGJv3XUxtXs1hXdSCRiDoiH7WIInU/tOasOYZ9WguWlDqOotZaNu53vixD7nDNFOZGA6x98glWOwnpk+tYYLXXKhzBi+EwE5gJW8oXcG0/I/dH8Rsa1GsAbmEoaPH9Pld/c+Xvy+gBDASQM0BABooxB2oEE2OvO7EiMeYORzREt1+mYWosNSi0F6LgIbgLT1pbZ9cZyAqPiv/nNZui18KeEyMxUX29E9wqpakIfkw3A60J9ulFb3zDDhqJ1QG6XbNtvM7CVIRN8BnsnYN1ZpOe5OlVHBGcldHu9dujB+d5ey9KJ8NGdQqtrGo5YBAOurTfchUiF1CJ+rRJpA5HLOh6ymPXmoev67k+ziCU9QBmyCm/x6CRBfYHLzw24HuVPIToq8Mzz30qBn6nqA0UmG0gB2QxQ/HIjg/floytE3q6XdjXWs0F9KYri8oS0v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(7696005)(64756008)(8676002)(66446008)(66946007)(66556008)(66476007)(4326008)(54906003)(71200400001)(316002)(76116006)(110136005)(41300700001)(33656002)(478600001)(86362001)(9686003)(6506007)(26005)(53546011)(83380400001)(5660300002)(7416002)(38070700005)(55016003)(8936002)(38100700002)(52536014)(186003)(2906002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3daOThIeHNhdWJxbTZjbHRQdHhBZ0lxd21GWTNvbDRaZXQ0QkZJN2FlQmVr?=
 =?utf-8?B?VFFZeFhIYXgwdmVlWEFKYWJKUTFBbHh4YmE3Ujh2bnU0VjZ2d1hadXlYeGZ5?=
 =?utf-8?B?clpvRlFpampJRXdHeGtUbGxaNGpZUnFGWW83YmsxczFSMEtyQ1ZQa0pJMTQy?=
 =?utf-8?B?N0Npb2o4ZzZ0NmJ2NmNUZGo3WGNOTU1KVmZNU0xBOGF6SThOK2JUTXdTV0d4?=
 =?utf-8?B?Rk03Y0RZMG5OdHl4dEtNRjU3ckFXalVJN1NRT3hRUlNLRXRzZG5BZDRpL2Q4?=
 =?utf-8?B?RzJMMjFRcFEyK3JVeHlwTjFFWWRualhBaFZMQVBHL1Q4WElyK1hObG90L3JR?=
 =?utf-8?B?c2RQWFlLemhJVnc0QWpKVm1tZWZTT0lqb0p3SUtoQ0lMME9wNjV6OXhuY3Y5?=
 =?utf-8?B?YjZ5SmNKYmV6cUVpZWdOenVaYTdPR3krcDcxc01EUEoyMUNsam1sYmRPckRU?=
 =?utf-8?B?SjdHV2FqTXFCMlM3WFErWlpibHlTbk5zMVZzRDVDYndlV3dyWXMvQko5UHE1?=
 =?utf-8?B?Q3U3aHA3UHRGMU9reWk1UUl1eW43KytjMk5hQk1RL3hXQ21vNTRadW41UmJq?=
 =?utf-8?B?Ym9MbGlhcnkrQ0FZRDRheEFnRXVTdTV3czZ0ZDFwV1pVU2dLZjUzWG92T0U1?=
 =?utf-8?B?OXBFNlp3MDFWSTJGN3VLS1hXL3lYWFdueFZ6cFREQnJWYmdlbCsxZXhSWnNa?=
 =?utf-8?B?U2tscWd6OEQrVmRTRXkyK055akp3Ly9wSDA2WUliMGQraUp2VWVzU0lFNFdB?=
 =?utf-8?B?WFBmdTNyMGdtd3orbW9iTDh1OTZ3WFV0UVc2dXJTVVRWNXNZWkFDb2NFOWpM?=
 =?utf-8?B?L2JuaHdDcFpkWnFCOG1pM1FNaUFMa3NZMmRuOTczSWFnSk9KREFyc3VBR1JT?=
 =?utf-8?B?bmNUTDdhT2grUG5Ec0l4Qnh5cTBUN0MrTkJpN3RvaXNNVGk3RVZ4QlRoZ1U5?=
 =?utf-8?B?T3JBeTRCNXJyY1JubzloSXg4cmhJTDR1ZXJRcVlCdmNEd002a2NFT1lOWHZw?=
 =?utf-8?B?cTBUa0dMOHZDdWRBQ2cxKzlleVF0UXZKUFluNEVQL21tMXI4V3pMREJ5UmEy?=
 =?utf-8?B?bk9UZUZaM05CYmZpVFArMmNubEMyYUc5UE1Ob05nbFBZNlJSSStmaDcwQzVj?=
 =?utf-8?B?RndRM0owY1JML0FEcklHU1R4U0d6SHh5b1JwN3VKSU5HQlIzVTJkcXhzOWxl?=
 =?utf-8?B?dk9oWmZRR2VaemlnSEZiclhWUHhVdG9mQjRGcU5mM2FrcXA2Rkdpc25YekIy?=
 =?utf-8?B?eVQ2aEdwTlFmUERGMDgzRUM3UGFoQ3hNMkhTcVgrWERsT1dINVloUEZMMVBX?=
 =?utf-8?B?SlB2N1BJL2s0NEVRancvUmg0b21KVmJNY1hlNlNKRVdPSHhmdEZpWjd1L2Z3?=
 =?utf-8?B?R0Vka2lYNzVNK0hqd2UrRE1Vb2owK0dQY0k5RmdlQkxYbzJ0YVVFY04zNTU4?=
 =?utf-8?B?L3U4UUpaY29CeTRKais0UkJtYVc0QlMrVldHN0xPdGp2aXJWMmlwNGR5Um45?=
 =?utf-8?B?NlVsZnJhN29BNU9jblhkKzlRaVVXT2xyOExBekF4YVNISUkrRE93dksySlBM?=
 =?utf-8?B?c1E1ekZ4STdEQ2dzOFM3MnJzNXJXZ0l6WURKa3l1SHoxWVZhdnFnSUFMSjR0?=
 =?utf-8?B?OS9zbGMyOGtibXAyaUlWazVyTnpUZXAzcTBtWXhnbEZUeGNrQlc3dEgxZjdx?=
 =?utf-8?B?QlpvM2xYV281Y3UybStpN3Y1Y2gvTW1zdWNHOXRUc3o0TmxPanYvSU41KytY?=
 =?utf-8?B?bG0ySHJ2MjBCaGlxZnI2TlY2VzVueGVpMjNQM3F3QzZ3SlNTWVpPcXMwMG9K?=
 =?utf-8?B?bFRxM3ZCalcxczlhVzdUZnBPZzAvN2ZHWG1PUFY5Tml1MUxISUJSRG5QL0xx?=
 =?utf-8?B?ZTBBNDAzcTFCM3Z1UkJlRTRUdGtMZjhXblVsUC9MQWxZSFUzV0RYN2Q1bTBa?=
 =?utf-8?B?Um5xRk9ZMnhQbXJzYW5WdWE0eXZVK01CMCtXSlh1cDg1VEtkV29MN2Q4eUdy?=
 =?utf-8?B?OWt0WjM5bmFtNit4eUpmb0UwUVZoRjdPaTE5czlPUU1kOXVna0V2TG5Pc1p0?=
 =?utf-8?B?SmRvd1Evd2hHWHN0SjVpNjBFNFlMc290cVlzUngzQ3E1dWZId1EzaFFsa0Vq?=
 =?utf-8?Q?nkMA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8149228-c5e6-4022-613a-08db3cc8ada3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 09:14:40.6947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R6gKmxRlirzf+nKxaKxtnpSWDbmrpci1xS+ZsIS429St+GcG9QWky612tyxsR++y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9007
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTmljb2xhcy5GZXJyZUBt
aWNyb2NoaXAuY29tIDxOaWNvbGFzLkZlcnJlQG1pY3JvY2hpcC5jb20+DQo+IFNlbnQ6IEZyaWRh
eSwgQXByaWwgMTQsIDIwMjMgMjozMCBQTQ0KPiBUbzogRGFpcmUuTWNOYW1hcmFAbWljcm9jaGlw
LmNvbTsgQ2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0
LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gQ29ub3IuRG9vbGV5QG1pY3JvY2hpcC5j
b207IE5pY29sYXMuRmVycmVAbWljcm9jaGlwLmNvbQ0KPiBDYzogS2F0YWthbSwgSGFyaW5pIDxo
YXJpbmkua2F0YWthbUBhbWQuY29tPjsgU2ltZWssIE1pY2hhbA0KPiA8bWljaGFsLnNpbWVrQGFt
ZC5jb20+OyByb21hbi5ndXNoY2hpbkBsaW51eC5kZXY7DQo+IGphY29iLmUua2VsbGVyQGludGVs
LmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDEvMV0gbmV0OiBtYWNiOiBTaG9ydGVuIG1h
eF90eF9sZW4gdG8gNEtpQiAtIDU2IG9uDQo+IG1wZnMNCj4gDQo+IE9uIDEzLzA0LzIwMjMgYXQg
MjA6MDMsIGRhaXJlLm1jbmFtYXJhQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+ID4gRnJvbTogRGFp
cmUgTWNOYW1hcmEgPGRhaXJlLm1jbmFtYXJhQG1pY3JvY2hpcC5jb20+DQo+ID4NCj4gPiBPbiBt
cGZzLCB3aXRoIFNSQU0gY29uZmlndXJlZCBmb3IgNCBxdWV1ZXMsIHNldHRpbmcgbWF4X3R4X2xl
biB0bw0KPiA+IEdFTV9UWF9NQVhfTEVOPTB4M2YwIHJlc3VsdHMgbXVsdGlwbGUgQU1CQSBlcnJv
cnMuDQo+ID4gU2V0dGluZyBtYXhfdHhfbGVuIHRvICg0S2lCIC0gNTYpIHJlbW92ZXMgdGhvc2Ug
ZXJyb3JzLg0KPiA+DQo+ID4gVGhlIGRldGFpbHMgYXJlIGRlc2NyaWJlZCBpbiBlcnJhdHVtIDE2
ODYgYnkgQ2FkZW5jZQ0KPiA+DQo+ID4gVGhlIG1heCBqdW1ibyBmcmFtZSBzaXplIGlzIGFsc28g
cmVkdWNlZCBmb3IgbXBmcyB0byAoNEtpQiAtIDU2KS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IERhaXJlIE1jTmFtYXJhIDxkYWlyZS5tY25hbWFyYUBtaWNyb2NoaXAuY29tPg0KPiANCj4gTG9v
a3MgZ29vZCB0byBtZToNCj4gQWNrZWQtYnk6IE5pY29sYXMgRmVycmUgPG5pY29sYXMuZmVycmVA
bWljcm9jaGlwLmNvbT4NCiANClRoYW5rcw0KUmV2aWV3ZWQtYnk6IEhhcmluaSBLYXRha2FtIDxo
YXJpbmkua2F0YWthbUBhbWQuY29tPg0KDQpSZWdhcmRzLA0KSGFyaW5pDQo=
