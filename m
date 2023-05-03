Return-Path: <netdev+bounces-124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 084756F54BE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 173ED1C20CF8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AD79471;
	Wed,  3 May 2023 09:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205BF1109
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:30:43 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B1F420B;
	Wed,  3 May 2023 02:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7YptDr5zDZ8WEmAbo3fEtOoAoRGngkoEHAJYBIHtCCiClws08wiNbICW1+JGkRH6SRkbBHIij9GMiNasDyLjAAUBetbLmA9c64VQiDP2M1t4828ZDBfprucXvFcDIxMCamVT9XHkvwphp2B7d9+VtthUuy7J2zTVUGn3s4J4T2i5lJtYNbUtb6gL2qIwEWM9sNJuKVQikj7lgrFy275/86oCEy9AYe5HxDR+iDrFR4IFDzsliD+DsFN6wkYKl5TZnO2rHLSgt+Nu+QPz18Aup8of2lpN6PbbMOXIv7e/6RxosX4FdGKQFfEvl8rqP0Me8xu3/OiNxvUUUw+Xof8qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdE8Hdw4buAATCFUShu21o7tXfMWuvqo9zsqsd6pqnA=;
 b=aRNdmLGtr1psolvSUafy9GUT65/RzaWDI9QyHWd6O9epSiZX/x5rYFCKKNBvrBP7U3/6uSFVJpzkfq6n8YrejD5RrWdv1wHa5sv5OOwR6lCGVydPkXkKf2f0xO2s8bfaB8LmszPNov8fNOQKoj+dP0rgy7rrN10xlhA53l88JmJb61fu0I0YGtIJuvYGUg1wAaQ+RW3EA3eY0mKzd6jR7tP5Ff2spfeIeTuj0OyxSX4DmvALIr8w3V9x5TVNGIe8rlN9Tks/jWKNHw9Ar2cdGVabjHdp8kE+sqKhojr+5nVdoKav/CoJt9A54kQZrf6xrmLGTyEUBisDY/IuN4Xqlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdE8Hdw4buAATCFUShu21o7tXfMWuvqo9zsqsd6pqnA=;
 b=YiVXcPc8hDLUaVPBCq9kV3SMNPBS/xsZEuHpoA+guqZVwL5al8qFbi5VaMVOMEu0lImIRct69i9U/VVfiGMq+RWN4sPr6n7rMmJPMcCRyQ4KZ4VWvaJryxzdstqSidbLqydyo/Qx8Lgmw0Bajq5YKGv2HpIKUSDK+xle4fKQwpw=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by IA0PR12MB8837.namprd12.prod.outlook.com (2603:10b6:208:491::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Wed, 3 May
 2023 09:30:38 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%6]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 09:30:37 +0000
From: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "robh+dt@kernel.org"
	<robh+dt@kernel.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>
CC: "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
	"radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Sarangi, Anirudha"
	<anirudha.sarangi@amd.com>, "Katakam, Harini" <harini.katakam@amd.com>, "git
 (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Topic: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Index: AQHZUYT4JLsiahlKOkOq6wiaqDsKBK76dskAgBXCyhCANuRuAIABfynw
Date: Wed, 3 May 2023 09:30:37 +0000
Message-ID:
 <MW5PR12MB5598ED29E01601585963D5D0876C9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
 <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
 <a5e18c4f-b906-5c9d-ec93-836401dcd3ea@linaro.org>
In-Reply-To: <a5e18c4f-b906-5c9d-ec93-836401dcd3ea@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|IA0PR12MB8837:EE_
x-ms-office365-filtering-correlation-id: ae311774-2ab8-4c84-b6a6-08db4bb90d9e
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KCQQx68X/eboVh41w/Wl4GFl4tKXiG5LirXeVgBwkfsT8weKZQ9JrWgT3GkKW3pv8jl2e3jlU6YMBUEVszCmZzyeyclpI/7amcxP/P7t6oeKybBNJG/qxxSvZFMmS79w79hZgA35kG1N2b9zT7VbN/Kh5e9MsHuFGvqZV+HorW63vylHoQzNqRz8i85blp4nQp10e4wfPjeHsNdELSJ5Gnasel+D+Mo8Wj/ZzAV823nmMvXceZHKSMqWZkfjmfDOQ7swfKY6gTEUMYEqdi8YWzgFEYF6ZO8LYj0tizW66O1WD82DRCDy1/REsYi2ZmZzTRk4TztQvhroYVQ4lBi4IQOSjEHnVirK3yhc0Ze7ZKwuGgttgPLTtsuH1i9n3mYXRL3sRiHWq9n+rEAo/Fimi3l2qNfoUXUjpfKu+DEy55JQ0MmF5suKv3vC5t+ocLCOhVkR5spRRNPAijYW7VucjdIyRknf46Z9zl0zWNRBHFN+jJaQ4BKdBDhQZ2dqX5bN3V76Mx4qcxhYlKRJC5fCGej0x60pb0r1MyuOEMS9zPoREEodej7oRuDZBFStYFT335dK8YF0FPqbN5RGwEt76vROf3BeWXg9YoC9s+P2bnjLgjuMgbrJmVvhWlKKZtxZ+BDDixFVaYRiRrn7eGsTFQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(83380400001)(8676002)(38070700005)(6506007)(53546011)(9686003)(8936002)(26005)(2906002)(7416002)(5660300002)(52536014)(38100700002)(41300700001)(122000001)(316002)(4326008)(66476007)(66946007)(76116006)(66446008)(64756008)(66556008)(966005)(86362001)(71200400001)(33656002)(54906003)(110136005)(186003)(55016003)(7696005)(478600001)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bEFkZVhlYzFDTVNMVVZtZ1pJMFIzTUlrb1N1SWsyTmlzWUNpODJBelpNc1J1?=
 =?utf-8?B?Qm1YL1hGQXNnc0RFT2pydUcwQ20zZU9ONFVPZms1cExQd045eVB1bHlhOVk4?=
 =?utf-8?B?c2paRHE2Vk8yY3JWOFQvcEE0T1V2MWpWbEwvRS95Vis0QjVuZjgzYzhtemNu?=
 =?utf-8?B?RlJNeUp0eVNXYnMza3VtaitNcjcreGpwY01wbnZGYUpQOVZPTXlxNmJNVlRZ?=
 =?utf-8?B?eGtGaEs2dWoxWGdGbDhZT0M1WDR5WDVEZUpYYnRnVnZxNlN2ZFdyUkF6Wm14?=
 =?utf-8?B?QmRJbmlQQkNXZzRpUXk4V2dmajlyU2ZaUExjYUMvOXUvNWJLemJ4K0xKL3BP?=
 =?utf-8?B?U3YrQ0xPREFrMlQ5Z21NcjRaN3hmVEpOTW9JK2tyTHpnV0wzV2JjSjdvbkdr?=
 =?utf-8?B?dmVydzZPUCtudzJ4YThMeEM2ZVNqY01EYzdEeUtDd0NDVXFXc0hybkNBTHJl?=
 =?utf-8?B?NE8xTmFqMXRoc1MwU2dwaDZNSStYRFJ2aGVKZnFINUNGZ0dQb21vK0R4c0Q0?=
 =?utf-8?B?Rm5iRVd2RWliTTdObzN4blJVMjAyK1Z1RzVpVm1pclUvK2l1NVh3cHVxSDlX?=
 =?utf-8?B?RkJMOGVUMUZGTlNReHIrNG4rZVlrakk5OVozSldyMW5YYVA5bmRUaVc0ai9C?=
 =?utf-8?B?R3M2MGhDWEZHQVhnWFdiakc0aEtjZ01WQVlXZXpBS3pneCtoYXZRdEczWGtK?=
 =?utf-8?B?QURIcGdmKzZ5WHhlRk5aUlRjYTJ5WGNlT2xYZzZIWWN6SkZISnhtZWwwL3RR?=
 =?utf-8?B?WGdZeWtlUzFvOGVNVEorajlhSUg1L2VQS2pKTlJabkxLNXpXd09saHRDU3Fy?=
 =?utf-8?B?cmZYeWozMUdHaEw1dytSdGtXWFAyTVBEdlcxblB0V3ZxWEpMVmQ5ZXMzTmtD?=
 =?utf-8?B?UTV5bEpUZTJGL0E0dUFzNEMxTDQvK0pFRzU5THNlVEIvRDRqRk84N0ZQY0xL?=
 =?utf-8?B?QWpvN2VIdEtOOUtVTlVHN2w0cW9FS1Nia21MUmIza0lZWGZXbjhQMGxHOVBo?=
 =?utf-8?B?M2xQbGM0bVhkN01sQ1hqcEtRSDNHRVNwY0lXbWR2Ym5LQ0RxRGVkamdXZ1NB?=
 =?utf-8?B?TytHTWZWbElNQWhTTTRNSjQ0ME40Nm9Zb2J5YUw3aXdDV0VyMHVpQTZDOXFV?=
 =?utf-8?B?NC9jWjVpUWtxU2luc052REgrekxENGhZQmx6L2pFMkp2YktEQXlTak1oK0NB?=
 =?utf-8?B?VTdiYWNlWWQvbVA1VWQySVdHaFJaenAzN3lDdktPclNCbEpzOGFOa2FPK2tM?=
 =?utf-8?B?elFTeDFuN1pVOE8yblA1YnZCK2JGMzAycGcwTEg2czlmMlFaenZIOUZJWG43?=
 =?utf-8?B?b29qOW9EUkUrOTc0ckpXTkpCOWlpRXR6OTVQQmt6VXExeGQvY3RVaG1ETDRa?=
 =?utf-8?B?NnZWQ2s2elBLU0JIeTRnUGVLYXdFMmt3RzkzczFwSCttRzVQeXovbUNRaEJS?=
 =?utf-8?B?UFAzWitlRDlTVWxnTlNVbTFzbEh0RWgrdkhrYmtiZktRYXl6RFdxQjVWREV6?=
 =?utf-8?B?Z3RRTjZXbm92d293ZUlIRGtyQWFVbVQza3FhT2phZ1U3MzRXOGNNZUpsM0VC?=
 =?utf-8?B?MzIwRzQ5ZDBTbWJ4TGJxRjRiMzBnMzhBU0hGR2cvNjE3czE2WGlZckR5OWRL?=
 =?utf-8?B?YXowdDBXZVl6a3g3Wk1SSlZieGthNTU4RjdqN3JUNHQ1WFhaZ1NLaVZFZ1NM?=
 =?utf-8?B?OVNSZm1DVjRCaWNQbGdMV05zYmZLRUJqYjB3ZG1SZlRGWndaQ1dpR0NWS2JU?=
 =?utf-8?B?NHlsbVE5QXJnWll5bktXSGlzSGFuUGVRdUMrWG1aWW5XZVVEb3MrNGFJR1pv?=
 =?utf-8?B?QjBwUW5RT05ndmJxcm9tcFdmRFpjNzhwSy9rTVF6cktvYVVvYjRaU296ZmRt?=
 =?utf-8?B?bndkS3YvUjZudUNaYU8yR0toZE5SZ2thUWRKOG16cCswMGVxc0F5dmdtaFBI?=
 =?utf-8?B?Z3VVNVd1L3VqSGJTSEVUM0JLbmtPMHQwdlg2NCtsa25zR0ZKN3RYL3I4Nkdw?=
 =?utf-8?B?WTkrSk5zTTM0a2ZvdzlLcENDWllnV285Nks2aWh5SXFqQjZBOFFJTERCU04x?=
 =?utf-8?B?bllaWlpHdXBramVIYWRmM2xya1V0dktkSHpRMEJlaUNpam90TFJhK1JkQ1Mr?=
 =?utf-8?Q?x1UQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae311774-2ab8-4c84-b6a6-08db4bb90d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 09:30:37.2211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: flAwoxSZ2uA27GhVZ2iImbLYw8ftkdMkclnalkjqAoRLV14yRiDR8Y1psf6VUZ1KT32DdGOnya19fs0hI1x1/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8837
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBN
YXkgMiwgMjAyMyAzOjU2IFBNDQo+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+IDxz
YXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+
IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207
DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3Jn
DQo+IENjOiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgcmFkaGV5LnNoeWFtLnBhbmRleUB4aWxp
bnguY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVs
Lm9yZzsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4gQW5pcnVkaGEgPGFuaXJ1ZGhhLnNhcmFu
Z2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA8aGFyaW5pLmthdGFrYW1AYW1kLmNvbT47
IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5l
dC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0OiB4bG54LGF4aS1ldGhlcm5ldDoNCj4gY29udmVy
dCBiaW5kaW5ncyBkb2N1bWVudCB0byB5YW1sDQo+IA0KPiBPbiAyOC8wMy8yMDIzIDE0OjUyLCBH
YWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1IHdyb3RlOg0KPiA+DQo+ID4NCj4gPj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6eXN6
dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBNYXJjaCAxNCwg
MjAyMyA5OjIyIFBNDQo+ID4+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+ID4+IDxz
YXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+
ID4+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5j
b207DQo+ID4+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5h
cm8ub3JnDQo+ID4+IENjOiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgcmFkaGV5LnNoeWFtLnBh
bmRleUB4aWxpbnguY29tOw0KPiA+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVl
QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiA+PiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFk
Lm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4gPj4gQW5pcnVk
aGEgPGFuaXJ1ZGhhLnNhcmFuZ2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA+PiA8aGFy
aW5pLmthdGFrYW1AYW1kLmNvbT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiA+
PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0OiB4bG54
LGF4aS1ldGhlcm5ldDoNCj4gPj4gY29udmVydCBiaW5kaW5ncyBkb2N1bWVudCB0byB5YW1sDQo+
ID4+DQo+ID4+IE9uIDA4LzAzLzIwMjMgMDc6MTIsIFNhcmF0aCBCYWJ1IE5haWR1IEdhZGRhbSB3
cm90ZToNCj4gPj4+IEZyb206IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5wYW5k
ZXlAeGlsaW54LmNvbT4NCj4gPj4+DQo+ID4+PiBDb252ZXJ0IHRoZSBiaW5kaW5ncyBkb2N1bWVu
dCBmb3IgWGlsaW54IEFYSSBFdGhlcm5ldCBTdWJzeXN0ZW0NCj4gZnJvbQ0KPiA+Pj4gdHh0IHRv
IHlhbWwuIE5vIGNoYW5nZXMgdG8gZXhpc3RpbmcgYmluZGluZyBkZXNjcmlwdGlvbi4NCj4gPj4+
DQo+ID4+DQo+ID4+ICguLi4pDQo+ID4+DQo+ID4+PiArcHJvcGVydGllczoNCj4gPj4+ICsgIGNv
bXBhdGlibGU6DQo+ID4+PiArICAgIGVudW06DQo+ID4+PiArICAgICAgLSB4bG54LGF4aS1ldGhl
cm5ldC0xLjAwLmENCj4gPj4+ICsgICAgICAtIHhsbngsYXhpLWV0aGVybmV0LTEuMDEuYQ0KPiA+
Pj4gKyAgICAgIC0geGxueCxheGktZXRoZXJuZXQtMi4wMS5hDQo+ID4+PiArDQo+ID4+PiArICBy
ZWc6DQo+ID4+PiArICAgIGRlc2NyaXB0aW9uOg0KPiA+Pj4gKyAgICAgIEFkZHJlc3MgYW5kIGxl
bmd0aCBvZiB0aGUgSU8gc3BhY2UsIGFzIHdlbGwgYXMgdGhlIGFkZHJlc3MNCj4gPj4+ICsgICAg
ICBhbmQgbGVuZ3RoIG9mIHRoZSBBWEkgRE1BIGNvbnRyb2xsZXIgSU8gc3BhY2UsIHVubGVzcw0K
PiA+Pj4gKyAgICAgIGF4aXN0cmVhbS1jb25uZWN0ZWQgaXMgc3BlY2lmaWVkLCBpbiB3aGljaCBj
YXNlIHRoZSByZWcNCj4gPj4+ICsgICAgICBhdHRyaWJ1dGUgb2YgdGhlIG5vZGUgcmVmZXJlbmNl
ZCBieSBpdCBpcyB1c2VkLg0KPiA+Pg0KPiA+PiBEaWQgeW91IHRlc3QgaXQgd2l0aCBheGlzdHJl
YW0tY29ubmVjdGVkPyBUaGUgc2NoZW1hIGFuZCBkZXNjcmlwdGlvbg0KPiA+PiBmZWVsIGNvbnRy
YWRpY3RvcnkgYW5kIHRlc3RzIHdvdWxkIHBvaW50IHRoZSBpc3N1ZS4NCj4gPg0KPiA+IFRoYW5r
cyBmb3IgcmV2aWV3IGNvbW1lbnRzLiBXZSB0ZXN0ZWQgd2l0aCBheGlzdHJlYW0tY29ubmVjdGVk
IGFuZA0KPiBkaWQNCj4gPiBub3Qgb2JzZXJ2ZSBhbnkgZXJyb3JzLiBEbyB5b3UgYW50aWNpcGF0
ZSBhbnkgaXNzdWVzL2Vycm9ycyA/DQo+IA0KPiBZZXMsIEkgYW50aWNpcGF0ZSBlcnJvcnMuIFdo
YXQgeW91IHdyb3RlIGhlcmUgbG9va3MgaW5jb3JyZWN0IGJhc2VkIG9uIHRoZQ0KPiBzY2hlbWEu
DQo+IA0KPiBBbHNvLCBTZWUgYWxzbyBteSBmdXJ0aGVyIGNvbW1lbnRzIChvciB5b3UgaWdub3Jl
ZCB0aGVtPykuDQo+IA0KPiBZb3UgY2FuIGNvbWUgbWFueSBtb250aHMgYWZ0ZXIgbXkgcmV2aWV3
IHRvIGFzayBhYm91dCBkZXRhaWxzLCB0byBiZQ0KPiBzdXJlIEkgd2lsbCBmb3JnZXQgdGhlIHRv
cGljLg0KDQoNCkhpIEtyenlzenRvZiwgQXBvbG9naWVzIGZvciBtaXNjb21tdW5pY2F0aW9uLiBJ
IHJlcGxpZWQgdG8gdGhpcyB0aHJlYWQgb24NCk1hcmNoIDI4IGFuZCBzYWlkIHRoYXQgSSB3b3Vs
ZCBhZGRyZXNzIHJlbWFpbmluZyByZXZpZXcgY29tbWVudHMgaW4NCnRoZSBuZXh0IHZlcnNpb24u
DQoNCkxvcmUgbGluazoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9NVzVQUjEyTUI1NTk4
ODBCMEUyMjBCREJENjRFMDZEMjQ4Nzg4OUBNVzVQUjEyTUI1NTk4Lm5hbXByZDEyLnByb2Qub3V0
bG9vay5jb20vDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvTVc1UFIxMk1CNTU5ODY3OEJC
OUFCNkVDMkZGQzQyNEY0ODc4ODlATVc1UFIxMk1CNTU5OC5uYW1wcmQxMi5wcm9kLm91dGxvb2su
Y29tLw0KDQpJIHBsYW5uZWQgdG8gc2VuZCBuZXh0IHZlcnNpb24gd2l0aCBwaHktbW9kZSBhbmQg
cGNzLWhhbmRsZSBtYXhJdGVtcw0KZml4ZWQuYnV0IEkgd2FudGVkIHRvIGNsb3NlIG9uIHRoZSBh
eGlzdHJlYW0tY29ubmVjdGVkIGRpc2N1c3Npb24gYmVmb3JlDQpkb2luZyBzby4NCg0KUmVsYXRl
ZCB0byBheGlzdHJlYW0tY29ubmVjdGVkIGRpc2N1c3Npb246DQpJIGFscmVhZHkgcmFuIGR0IGJp
bmRpbmcgY2hlY2sgZm9yIHNjaGVtYSBhbmQgZHRzIG5vZGUgdmFsaWRhdGlvbi4gSSBhc3N1bWUN
CnRoaXMgc2hvdWxkIHBvaW50IGFueSBlcnJvcnMgb24gaXQuDQoNClRoYW5rcywNClNhcmF0aA0K
DQoNCg0K

