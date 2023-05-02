Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C026F40B1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 12:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjEBKJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 06:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbjEBKJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 06:09:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B425270;
        Tue,  2 May 2023 03:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4y8qwvK+VwsXl/s4CkMZP0updyp1fK6fkqiWKV+xGRlWfXguf/N4Rbfa5qDoJf9xdG4gHBwvD30AScJG4+uwBDANlVLbWHgQ/1uNTAxYH3HexoXFrxyz8fQyRUV83FtT55KSSgaveGagPBD6Wy2PmI/IVU/R5ETqorYG7K5oV3WuqNd1HuPloea+ANkOwOP9/EN1yvsfeCCo9pPXiM+qGgmbl1ZkXQ17ZvDFv7OQDk6dbctagJvdqyvlHCSMtlxlSqGft6gRpPqIIS0T3lmOfJK4L5C1CJecrRTdiXd6n7I/WK2br5pE7LKEbc4yvNPid4invL3+iNhkWRyIb3i+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glHWVR7Xto1/btfR/F+kj7Cdtj++2YWDkT8/D/xm5rs=;
 b=Ej8saCnS4EyzC/0RYb1cwvPZDVqq8MjHTerVWku1jx54wssB7CP8DdZ/Y8wNqEKVjcuZd8EVBtg4Ndw0O2Sgd2nu9V5G2gBrTw0EIxrU6JvBUfiyagstE2Hoexajo/e+segBFJEu78ZH1woeUuXIuuR9D+GZdcpITy4qVlQYDBuULqmRVw+lKdqxjirQD1R7ZMTFC8o1pATpRnO9A+cnhbFQNfefrFVhxGAg12XXsfbzqQs32d/pSIKGyaOr0Q75Q6qnSzbUMsjD1gweZZBWBiK3dMTt7At814l7erMV4vI4tMiikFQ0UNEijUS7Bx0o9pOysvMWo1EJs2XkMPPuIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glHWVR7Xto1/btfR/F+kj7Cdtj++2YWDkT8/D/xm5rs=;
 b=5eo34tu70m/WArxbVhBwsHoLEQCCMPnQLdRWgQrbfaJ00XvuMtWy4127QHVQKP6xZKyhyehGmJ3jecBmr7a5EAi161ZKWp1ya1TKyQfyPA/y+H5pB3eovTQoFJLvltBoBSGPxi88X+qLYTxKaMeMZKKCLGNugofi/q3qKivMY4Q=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by BL0PR12MB4993.namprd12.prod.outlook.com (2603:10b6:208:17e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 10:09:18 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%5]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 10:09:17 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
Subject: RE: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Topic: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Index: AQHZUYT4JLsiahlKOkOq6wiaqDsKBK76dskAgBXCyhCAAD18MIA2oTPg
Date:   Tue, 2 May 2023 10:09:17 +0000
Message-ID: <MW5PR12MB559857065E298E7A8485305D876F9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
 <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
 <MW5PR12MB5598678BB9AB6EC2FFC424F487889@MW5PR12MB5598.namprd12.prod.outlook.com>
In-Reply-To: <MW5PR12MB5598678BB9AB6EC2FFC424F487889@MW5PR12MB5598.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|BL0PR12MB4993:EE_
x-ms-office365-filtering-correlation-id: 935a1c9b-e268-4a78-a47a-08db4af549f8
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IhLmtt7SIM1hx2APQ4zn9J4GfK+ock7/P5Upzp0UcqfuYB+hCg0rh1GC5bPnclEQDwJn/GRb6FhyyRPRsT403770pN4wcJ90x+PMjYWcryBE3BQrbzK3mGAt6qZbNU9QM+rbJiEodp/T9ifsAhpSmWuGWr1c+xJUYnwPEjXQiCAy4Hgk9d+fK7I6IHS7HFGm5/JSESaMkomHiXk4lFXyk3s23uS+7xLQe0TLHSfUBYyziHi/281rWfzsGO5NIt6NhOBirhkdyMoDJHRbAKJDwyWNyuCVBZLf4HMIqkHkuFyt+b8PMhH6uA2VYa1WRGQXwmBwNr7Fx8DC2Xdxc2oXUFd4NUggl6fhykaROvHr3ICokSNQpS2/a5t2y/E0moq15awgs28vyxfE12mLwa8/epu50pPCVA2cwyJCFPPTGe5zKI7rp59cgfeuu9hxEyFt6Wnhe7TFaPIXPzvFnLb3tQrvFfymOncvJ7QnBikn2aouyFxrqwy1S2HVyG2ofOBTpQE+6+PrzRuNgpkA74E0IM9/HK63aUzTF1TIV9/7bQdW+Pfqqg1kk5SeJ5iPH5Yhzr6HN9qPXt+GzWwHfJr2AlD2sQmcBkJDr5Bn/lEEy1ne4D1dSIFqZUUNNZ2DIYgR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199021)(53546011)(54906003)(83380400001)(478600001)(7696005)(71200400001)(55016003)(26005)(9686003)(6506007)(66476007)(66446008)(66556008)(64756008)(66946007)(316002)(76116006)(4326008)(110136005)(186003)(7416002)(122000001)(41300700001)(8676002)(5660300002)(52536014)(38070700005)(8936002)(38100700002)(2906002)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ukt6RGdocFFlMXdmdEtPaEJBbnhTanlsZ3dvRnljL2daaysyRkdQYjNmVFZO?=
 =?utf-8?B?VWxlK2JLQ0txMk5TUmttSHpFUE4rT3JUMmI1ZFVITm5qZWFkOURGVHBZbnFa?=
 =?utf-8?B?NjZXcDc4YmRWOWh5ekhqa3B0VmpHWmhlcDhRVkxEaUxVc2Nublp1UDZqeVhQ?=
 =?utf-8?B?S3ZsWlkzMXUvcHFuRnFEZmt6dEZrT1NLd1o1OVVXakJmY0lZSWpyS1pxSExi?=
 =?utf-8?B?bG5PeThBQ25KbytJZytBdDhla2RPVHZzZURoc0V3cithamVoZ3pqcWFoeU5R?=
 =?utf-8?B?WFkrclYwL1NUbS9rLzFrYnVCN0VkZjRoSENPK2NSRXpON3dQalh3SFZEY1Ji?=
 =?utf-8?B?RWRud0ZJTE9KUU5HcklvMGdwL2N0cFNSTnI0OFN6VHpETmM5SmdIL3ZmNXVF?=
 =?utf-8?B?Mnp2MzBqangxVHpqTjR0NGR4S2FSYjgyMzVkR3pMclBSKzFIcit1MjV1bzln?=
 =?utf-8?B?SGEra0pNTDZsTTBYZU1FZ1o0NFlJRWZIMVAyaW5HaEhHTEtPV2tBd0UxM2dS?=
 =?utf-8?B?eWQ0MllERFg2Q2I3UkNqRjVXYzFiRGVhSjVqN3BGRUJFV000SkVZQm1RMGpF?=
 =?utf-8?B?S2hmT1lmSG93TnlxdHhYUG1KblYwNlJFcC83NURkVXdObGFhRDllMFpLTHhi?=
 =?utf-8?B?RVZldU5LdGl2b0N2bTJSM281Y2MyTmc4NEducUIzYjdSSnQ4T3RTK0RsRXRJ?=
 =?utf-8?B?cW5VWmh5M2FYS0JoSzBoeVJlajVLcVd4RXNKeWprWkV3UDFyRmNnWVlEU084?=
 =?utf-8?B?M0JZR1JGdGNFZmxGM3hUZHZwRE55cmtVNGY4YVpFZXlSNVI0dGhWRUJHeVRy?=
 =?utf-8?B?YjdERTYxcDNCMlhKdFFpWXEwM3dtb2U2cXVUVnVHQ0pLMmlFVHY0RE9wSVZ0?=
 =?utf-8?B?aDRPcDNkdlFZMWFqY1pNUDdxWnk5Uld4em1SRVlaVTZGcklvWnR4Yk1qSm1I?=
 =?utf-8?B?cWlnT05wZ3J0SnhpMW94eHZ6UjVmWCt5Z0kxQkRXMFBoOFdJTTNYUUdoc3Q1?=
 =?utf-8?B?bGRieTB3QzNhU2JnTGRHRXRaOGN4bFVHRkQ4OS91bDA0NGFyK3o2VlhMbS8r?=
 =?utf-8?B?azFiNGJkV2FtOExxak1PV3ErdkU5K2U0N2dhZFU1V0VyM05UVUFtWUlYR29Q?=
 =?utf-8?B?Z01RZjZiN1puMWZnUFFwQU1SanhUWEtYeCtkejUwdVNDN3B5N09hTjFZSk1r?=
 =?utf-8?B?NEUxVGNnWmJYLzlTNDY2ZFdqN0l1bHZTNVV0MXh3eXcvdlRSdUREajZkM05F?=
 =?utf-8?B?UENBY1RXeUhodm9ITEMvaUM2Y0p1bHBySU8ydVh3UExYK1NUT01yeGlKUlFQ?=
 =?utf-8?B?YUVUTmNEVlBTNHYyeE0wZHNoMXoxNkkyWFUwYUc1Rzl4ZXJhRlFaYVR6aDNS?=
 =?utf-8?B?cSs1bEduaVNUQUlwZ3kyV0xzM0U4TExId0xtQ0NGYk5ZdnFpTGpaSllFZUdR?=
 =?utf-8?B?a3NkTFRMTlNySzBlK0czZ0lrbzVoUURGeUVmVm9TRDBtMGJkR1VYZmNFaWI0?=
 =?utf-8?B?Q25hSmtEYTNZTFpKbU10SDM4Kzd6WE1UeEkzT2ZFQldPNU8wa1RjRHozVWFz?=
 =?utf-8?B?Y2x4dnlCUW1sK0hiZFhYK081dm9lSEJkL01yVXdUNnlNMENSK3RzT1JGY3Ar?=
 =?utf-8?B?NGtWQ3FESndzZTZnVTRWdm5DbWFzYkpHZzBkb25YUzdIcnZHMDdSRURYWjFY?=
 =?utf-8?B?WDVvL2FuSW4yZzJzTXp3eHV4bWU0KzYrTXNLSHgvZTR1K2FFUENjUmQxRlFT?=
 =?utf-8?B?T2dGbXNoSUl2andid1lGWlg2enRmRTFuUVRSUXdVY0hoemowZHI1cWljMUlK?=
 =?utf-8?B?czBGU3gxN2I3NkQ3bUZydDRQZHlyY3BXbFlHM3AwVUZBOGlvd1FjbVlCNnJP?=
 =?utf-8?B?aTkvL1RKL29qa2NUOFM4N1NTYlRiMTdNMlJEaVdyaS9XcXIzY0FHUHJ0SHpG?=
 =?utf-8?B?MENFTTkvVG9rY3pIZnEwdWs4dW5kZU9TaXJnZ0pEdVp3dkFlbE9qYk9adXlV?=
 =?utf-8?B?R0V2SFg1dHZsZ3NYZHhPV1NDUis0cndENEQ3elBHeFdtVlFqMDJiaXhSbENn?=
 =?utf-8?B?aDAwejZwK3IyOWxXMnFuREJvU3Q5ZTV4cmlVeXhPMkYyOE5uNXREWTkvMWk3?=
 =?utf-8?Q?T1fw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935a1c9b-e268-4a78-a47a-08db4af549f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 10:09:17.1143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z/VQnUur2rY4Bizsun8JDy6jShb7DfrV4jdBsFS2bMXtzdxTRPqHyVwpk4zFRCbV9qmWPULA+b6bSkfFF0cekA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4993
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FkZGFtLCBTYXJhdGgg
QmFidSBOYWlkdQ0KPiA8c2FyYXRoLmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIE1hcmNoIDI4LCAyMDIzIDk6MzEgUE0NCj4gVG86IEtyenlzenRvZiBLb3psb3dz
a2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9yZz47DQo+IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhh
dC5jb207IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4ga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5h
cm8ub3JnDQo+IENjOiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgcmFkaGV5LnNoeWFtLnBhbmRl
eUB4aWxpbnguY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIu
a2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4gQW5pcnVkaGEgPGFuaXJ1ZGhh
LnNhcmFuZ2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA8aGFyaW5pLmthdGFrYW1AYW1k
LmNvbT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BB
VENIIG5ldC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0OiB4bG54LGF4aS1ldGhlcm5ldDoNCj4g
Y29udmVydCBiaW5kaW5ncyBkb2N1bWVudCB0byB5YW1sDQo+IA0KPiANCj4gDQo+ID4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1
DQo+ID4gPHNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhbUBhbWQuY29tPg0KPiA+IFNlbnQ6IFR1ZXNk
YXksIE1hcmNoIDI4LCAyMDIzIDY6MjIgUE0NCj4gPiBUbzogS3J6eXN6dG9mIEtvemxvd3NraSA8
a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPjsNCj4gPiBkYXZlbUBkYXZlbWxvZnQubmV0
OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+ID4gcGFiZW5pQHJlZGhh
dC5jb207IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4gPiBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxp
bmFyby5vcmcNCj4gPiBDYzogbWljaGFsLnNpbWVrQHhpbGlueC5jb207IHJhZGhleS5zaHlhbS5w
YW5kZXlAeGlsaW54LmNvbTsNCj4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVl
QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiA+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYXJhbmdpLA0KPiA+IEFuaXJ1ZGhh
IDxhbmlydWRoYS5zYXJhbmdpQGFtZC5jb20+OyBLYXRha2FtLCBIYXJpbmkNCj4gPiA8aGFyaW5p
LmthdGFrYW1AYW1kLmNvbT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiA+IFN1
YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgVjddIGR0LWJpbmRpbmdzOiBuZXQ6IHhsbngsYXhp
LWV0aGVybmV0Og0KPiA+IGNvbnZlcnQgYmluZGluZ3MgZG9jdW1lbnQgdG8geWFtbA0KPiA+DQo+
ID4NCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IEty
enlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9yZz4NCj4gPiA+
IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDE0LCAyMDIzIDk6MjIgUE0NCj4gPiA+IFRvOiBHYWRkYW0s
IFNhcmF0aCBCYWJ1IE5haWR1DQo+ID4gPiA8c2FyYXRoLmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5j
b20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+ID4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3Vi
YUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gPiA+IHJvYmgrZHRAa2VybmVsLm9y
Zzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnDQo+ID4gPiBDYzogbWljaGFsLnNp
bWVrQHhpbGlueC5jb207IHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNvbTsNCj4gPiA+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1h
cm0tDQo+ID4gPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsgU2FyYW5naSwNCj4gPiA+IEFuaXJ1ZGhhIDxhbmlydWRoYS5zYXJhbmdpQGFt
ZC5jb20+OyBLYXRha2FtLCBIYXJpbmkNCj4gPiA+IDxoYXJpbmkua2F0YWthbUBhbWQuY29tPjsg
Z2l0IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0OiB4bG54LGF4aS1ldGhlcm5ldDoNCj4gPiA+
IGNvbnZlcnQgYmluZGluZ3MgZG9jdW1lbnQgdG8geWFtbA0KPiA+ID4NCj4gPiA+IE9uIDA4LzAz
LzIwMjMgMDc6MTIsIFNhcmF0aCBCYWJ1IE5haWR1IEdhZGRhbSB3cm90ZToNCj4gPiA+ID4gRnJv
bTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tPg0K
PiA+ID4gPg0KPiA+ID4gPiBDb252ZXJ0IHRoZSBiaW5kaW5ncyBkb2N1bWVudCBmb3IgWGlsaW54
IEFYSSBFdGhlcm5ldCBTdWJzeXN0ZW0NCj4gPiBmcm9tDQo+ID4gPiA+IHR4dCB0byB5YW1sLiBO
byBjaGFuZ2VzIHRvIGV4aXN0aW5nIGJpbmRpbmcgZGVzY3JpcHRpb24uDQo+ID4gPiA+DQo+ID4g
Pg0KPiA+ID4gKC4uLikNCj4gPiA+DQo+ID4gPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ID4gPiArICBj
b21wYXRpYmxlOg0KPiA+ID4gPiArICAgIGVudW06DQo+ID4gPiA+ICsgICAgICAtIHhsbngsYXhp
LWV0aGVybmV0LTEuMDAuYQ0KPiA+ID4gPiArICAgICAgLSB4bG54LGF4aS1ldGhlcm5ldC0xLjAx
LmENCj4gPiA+ID4gKyAgICAgIC0geGxueCxheGktZXRoZXJuZXQtMi4wMS5hDQo+ID4gPiA+ICsN
Cj4gPiA+ID4gKyAgcmVnOg0KPiA+ID4gPiArICAgIGRlc2NyaXB0aW9uOg0KPiA+ID4gPiArICAg
ICAgQWRkcmVzcyBhbmQgbGVuZ3RoIG9mIHRoZSBJTyBzcGFjZSwgYXMgd2VsbCBhcyB0aGUgYWRk
cmVzcw0KPiA+ID4gPiArICAgICAgYW5kIGxlbmd0aCBvZiB0aGUgQVhJIERNQSBjb250cm9sbGVy
IElPIHNwYWNlLCB1bmxlc3MNCj4gPiA+ID4gKyAgICAgIGF4aXN0cmVhbS1jb25uZWN0ZWQgaXMg
c3BlY2lmaWVkLCBpbiB3aGljaCBjYXNlIHRoZSByZWcNCj4gPiA+ID4gKyAgICAgIGF0dHJpYnV0
ZSBvZiB0aGUgbm9kZSByZWZlcmVuY2VkIGJ5IGl0IGlzIHVzZWQuDQo+ID4gPg0KPiA+ID4gRGlk
IHlvdSB0ZXN0IGl0IHdpdGggYXhpc3RyZWFtLWNvbm5lY3RlZD8gVGhlIHNjaGVtYSBhbmQgZGVz
Y3JpcHRpb24NCj4gPiA+IGZlZWwgY29udHJhZGljdG9yeSBhbmQgdGVzdHMgd291bGQgcG9pbnQg
dGhlIGlzc3VlLg0KPiA+DQo+ID4gVGhhbmtzIGZvciByZXZpZXcgY29tbWVudHMuIFdlIHRlc3Rl
ZCB3aXRoIGF4aXN0cmVhbS1jb25uZWN0ZWQgYW5kDQo+IGRpZA0KPiA+IG5vdCBvYnNlcnZlIGFu
eSBlcnJvcnMuIERvIHlvdSBhbnRpY2lwYXRlIGFueSBpc3N1ZXMvZXJyb3JzID8NCj4gDQo+IEp1
c3QgdG8gYWRkIG1vcmUgZGV0YWlscywgd2UgaGF2ZSB0ZXN0ZWQgaXQgdXNpbmcgYmVsb3cgZHQg
bm9kZQ0KPiANCj4gCWF4aWVuZXRAMCB7DQo+IAkgICAgICAgIGF4aXN0cmVhbS1jb25uZWN0ZWQg
PSA8JmRtYT47DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHJlZyA9IDwweDAwIDB4ODAwMDAw
MDAgMHgwMCAweDQwMDAwPjsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9
ICJ4bG54LGF4aS1ldGhlcm5ldC0yLjAxLmEiOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBj
bG9jay1uYW1lcyA9ICJzX2F4aV9saXRlX2Nsa1wwYXhpc19jbGtcMHJlZl9jbGsiOw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICBjbG9ja3MgPSA8MHgwMyAweDQ3IDB4MDMgMHg0NyAweDE4PjsN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgcGh5LW1vZGUgPSAic2dtaWkiOw0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICB4bG54LHJ4Y3N1bSA9IDwweDAyPjsNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgeGxueCxyeG1lbSA9IDwweDEwMDA+Ow0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICB4bG54LHR4Y3N1bSA9IDwweDAyPjsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgcGNzLWhh
bmRsZSA9IDwweDE5PjsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgcGh5LWhhbmRsZSA9IDww
eDc4PjsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgZG1hcyA9IDwweDE3IDB4MDAgMHgxNyAw
eDAxPjsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgZG1hLW5hbWVzID0gInR4X2NoYW4wXDBy
eF9jaGFuMCI7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIG1hYy1hZGRyZXNzID0gW2ZmIGZm
IGZmIGZmIGZmIGZmXTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgbWFuYWdlZCA9ICJpbi1i
YW5kLXN0YXR1cyI7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHBoYW5kbGUgPSA8MHg3OT47
DQo+IAkJbWRpbyB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI2FkZHJlc3Mt
Y2VsbHMgPSA8MHgwMT47DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgI3NpemUt
Y2VsbHMgPSA8MHgwMD47DQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBo
eUAwIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbXBhdGli
bGUgPSAiZXRoZXJuZXQtcGh5LWllZWU4MDIuMy1jMjIiOw0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgcmVnID0gPDB4MDA+Ow0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgcGhhbmRsZSA9IDwweDc4PjsNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB9Ow0KPiANCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBldGhlcm5ldC1waHlAMiB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBkZXZpY2VfdHlwZSA9ICJldGhlcm5ldC1waHkiOw0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgcmVnID0gPDB4MDI+Ow0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgcGhhbmRsZSA9IDwweDE5PjsNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB9Ow0KPiAgICAgICAgICAgICAgICAgICAgICAgICB9Ow0KPiAJfTsN
Cj4gVGhpcyBEVCBub2RlIHdvcmtzIHdpdGggb3VyIGJvYXJkLiAiJmRtYSIgaXMgdGhlIGRtYSBE
VCBub2RlICBhbmQgdG8NCj4gdGVzdCB0aGUgc2Vjb25kIGNhc2Ugd2hlcmUgZG1hICBhZGRyZXNz
IGFuZCBsZW5ndGggIGluY2x1ZGVkICBpbiB0aGUNCj4gYXhpZW5ldCByZWcncyBwcm9wZXJ0eSBh
cyBiZWxvdyAicmVnID0gPDB4MDAgMHg4MDAwMDAwMCAweDAwIDB4NDAwMDANCj4gMHgwIDB4ODAw
NDAwMDAgMHgwIDB4MTAwMD47Ig0KPiANCj4gSSBkaWQgbm90IG9ic2VydmUgYW55IGlzc3VlIHdp
dGggYWJvdmUgdHdvIGNhc2VzLiBVc2VkIGJlbG93IGNvbW1hbmQNCj4gdG8gdmFsaWRhdGUgdGhl
IHlhbWwgdXNpbmcgYWJvdmUgRFQgbm9kZS4NCj4gbWFrZSBkdGJzX2NoZWNrDQo+IERUX1NDSEVN
QV9GSUxFUz1Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpLQ0K
PiBldGhlcm5ldC55YW1sDQo+IA0KDQpIaSBLcnp5c3p0b2YsICBDYW4geW91IHBsZWFzZSBjb21t
ZW50IElmIGFib3ZlIGV4cGxhbmF0aW9uIGlzIGFjY2VwdGFibGUgPw0KSSB3aWxsIGFkZHJlc3Mg
cmVtYWluaW5nIHJldmlldyBjb21tZW50cyBhbmQgc2VuZCB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpU
aGFua3MsDQpTYXJhdGgNCg==
