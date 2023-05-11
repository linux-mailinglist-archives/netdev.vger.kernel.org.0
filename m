Return-Path: <netdev+bounces-1742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 782FC6FF08D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A261F281727
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5563E19BB3;
	Thu, 11 May 2023 11:32:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B4E1377
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:32:13 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BA27DA7;
	Thu, 11 May 2023 04:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLQjENeVdfgdMayV1IKeMEJBRQyYZVv3AgVffum2wlu5k3Us/LuJzR2szrfglqnqEPwh9eXSesEMcjYMqBZ/t968JvaPm++8zLMHH9qjk7A3BE0zbCGrCOscpE9NaFkLeEYmQA1sB0Dlg0897MGC2EAUbewlUsOQrJyi0XGXItWLN5A4qQiPm3qxEbXX3BOsFtPRyvS+n2ynjfSTiqBSIM0hao1WCm2Zw/FSF15zg/czQC9JLxjX29WabTx8sVgAsg7yp1TXkruE7jSojFMJZEnx4phdvK0mQ+Az6Ff78IyJXevNnBuJyMa1OQAHKvBw1UmRsLgRisyHNbDaWgoaqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YINjzV6XMjsCgvdfActKj1pInzM54SKP/xQMhjiEsc=;
 b=jxAj+paP0FgQbHux//m4XrdO6Pwis+llGAuZ923i4tZzYKFf7ejozI/Cuv7QUBGZe3lDaHeDnmypmoLB/QewqunNXg4K/7ilB20e5PQjwLk3o3utO1P5qsT236a9KU+b6a+6nJRhSCAOPp5ONhzC+FMaUsrsv5U55dgarb2of+mnKS4bALbIilecLUX9SzyckxAtglSfMqt/9ATldTZ3S+d/RLfdTqxJGcmtwIBA3jBP4sqUSuBerxcM6cSAfu+7VCv0aCsR8Oa4k+aaUIXBDEJUdN1Xyk10MHfxbe9AwcsK+k1LET114tbIbgMFviuDcIv4LO1mNEWgREl25us3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YINjzV6XMjsCgvdfActKj1pInzM54SKP/xQMhjiEsc=;
 b=J2uPS0IgH7xza89mH4UPMwKFGBMp5xqhToFOVQILYQ7XrcSIYk64ZBddp+HbAGQwk5eJTmVUCWlGiQ9jye96p3Mh5lGaZv5UU7e6TDlGhT16B4Fv8F9lpP1rNBJQCQ7AH6i5w+4R0cQMS+3eUACL2Z5j8lbp8jA7+baOmwhDPXs=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by IA1PR12MB7662.namprd12.prod.outlook.com (2603:10b6:208:425::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Thu, 11 May
 2023 11:32:05 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%6]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 11:32:05 +0000
From: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "robh+dt@kernel.org"
	<robh+dt@kernel.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "Simek, Michal"
	<michal.simek@amd.com>, "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Sarangi, Anirudha"
	<anirudha.sarangi@amd.com>, "Katakam, Harini" <harini.katakam@amd.com>, "git
 (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Thread-Topic: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Thread-Index: AQHZgxyMhcxz4C0Hi06uaEd1rO/7na9TSJIAgAGnKOA=
Date: Thu, 11 May 2023 11:32:05 +0000
Message-ID:
 <MW5PR12MB55986A4865DB56F7F024EA7687749@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
 <95f61847-2ec3-a4e0-d277-5d68836f66cf@linaro.org>
In-Reply-To: <95f61847-2ec3-a4e0-d277-5d68836f66cf@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|IA1PR12MB7662:EE_
x-ms-office365-filtering-correlation-id: c9d5c8f7-bde8-4ea1-69d3-08db521358f7
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 m723pQbNCkw0HsRZB7Q7nbKv9B1Gj6jsb2JX0F/lyImiVFFPjIpGVZwjYjckIMWdmhFn55SHcJtJrgrFkTPQw+E+G31HFwW6e0QG0YB1gqWuC7xAWrag6bIMGuOCxPjRxyNLbXCC9qK8vIjEFGnw+dADLUoI++hFOtJrx2MsqcwgjE0FKyT7QCI9SUIQu0orlCwGW8IG55Ki4vWWre4lzsu/p7Bd4GUE66IjB295lo/qhNSYDht88creC/0hIUwmn0g5nV2G7RMHB1F3RKB6+tFf/6qGTiiKCEkh9x2E2Qy6QyCwEbkR5M6/CPuHlrYLbvOfz2I+ixcWli3XWMzEFiDwpNKCkwidG4FEyCYe8vgJvDWd4kh7c3thRFrOQL/WwPEk/4tQkdcecgxWvQMr3d+4Sxmk+NvxuiUj+HPvFl78eYqxGdTaWNfcd1TwgUAPjuEwitiJTa+9FqbOaWX1Ja80HZQWBM+0rGH+mYyuPVZaUimeggsmzgDmAsjZ1/ekuBncBZbqpHwPrDINwkEwlcGk6gKN7ucNQJyxfwxFHlZ/mfT9fHJs2PDVOWxWTKm66h+InfqLPL08U7Wq27MLOgFkwN2azSwCJQNtYUyMTbbkVzjf4Qvzcu8NQ6trOvwwgbEjTPerqU+D+FQ94focKw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(66446008)(33656002)(66556008)(64756008)(966005)(54906003)(316002)(478600001)(76116006)(66476007)(7696005)(4326008)(66946007)(110136005)(5660300002)(55016003)(2906002)(6506007)(8676002)(52536014)(41300700001)(8936002)(7416002)(71200400001)(186003)(38100700002)(122000001)(38070700005)(9686003)(86362001)(26005)(83380400001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akx3dEsvR2k1Vzc0SkJzdDBMaVpOVktrem9UemJydldxNU1kMVlyYSs5cDBR?=
 =?utf-8?B?d3VwL2xiMnR5Zm01NTZQak4xQ05Vd1RZSGtwMWdiWjUwaVdVLzg4VnRZeHN4?=
 =?utf-8?B?VmRVK0lDRkl0N3UvNXg0cW4ySGVXRXFZaExrVVdXUStnRTUwVjlaaXpyR3pF?=
 =?utf-8?B?L2Rnc0kwcFVKMEY4Yll4TWJCbEdTZTYzdmNqZ2YrL0Z3ODZpYUNlS1Fjdmx5?=
 =?utf-8?B?dWhVTC9Sd1k2dDloM1VUTzRmOFQvZDE1cU1hVm5PbVQrSm1CNklDY2haVlow?=
 =?utf-8?B?OUhzVWxyTTJhYlNvcFBod3hGMk5ERTRBMkRYdjJSdjdCTkJsUTF0SFVyN0Rs?=
 =?utf-8?B?STJVRjB2aUZUVWxrcG5nTnBaNlQyZ0VFQ3AvRGNzeUo0K29IV3kxckt5dTVj?=
 =?utf-8?B?NFA2M0tPUndqdFZIaG9uV2VOVFpQTlcvWVdlcDQ4Y2RjZk9JSEkvWURDTU5q?=
 =?utf-8?B?NWlvWm1MVFFWYTI1VElUbGxZR0RLQ1RjSlRpQzlEUTg2dHBWRW1FR3BtYUVw?=
 =?utf-8?B?M1VibXNqQVJ1bElyY2FLZksvVkdKTTZFY2dUK2JoUlFyNFFMQ3I0M21Zb1No?=
 =?utf-8?B?eS80aXJmU3kzWjFKcDVFUEx6SmJSb0M2Y2F1Y1ZyMGdKUEpJMDkvQTEyQ0Nl?=
 =?utf-8?B?UXhQS2E2cHhNam96WEx0YVJNVHNBaEMzbGh5aDM2N0M1blA2S2VYZ3Q1VjQ4?=
 =?utf-8?B?anBGZkVhMytPOGhobXM2bFFZa055MzNiR2VlZHdQdkRWbHdJWEpNNzFyR2t2?=
 =?utf-8?B?VnpKQTdVajFvQjNvZm5NcXRSUU9JNmFMaU8rRG5CUTl4VkRSbE05WnVqR3lz?=
 =?utf-8?B?V0h0WU5sNlllWTlrV3F4NTBTbUJGejdwMlo5WlF0Q1JqZ0hMNVQwQ2JOUlBv?=
 =?utf-8?B?c0RUWE9ibGlGM2owNGhHL1VrYmxkQU81MWdJYU16bXdHUlYrQ3BncWdhc3Rj?=
 =?utf-8?B?SmJST1YrOE03R015N2JyOXNPODRuWFhvMWJudm91N3JmeWZYR0JBaW5hbDJy?=
 =?utf-8?B?UXRTMnQwVVZWdExrWmptVHM3aERrY3JWd2tMbkwzbXNJbVhLa2hzRDdPaTRG?=
 =?utf-8?B?NkwxYVZMVDlxeXdFTzloV2JkeDc3dy93MCtoRGl2VEY1L0QvbkFzV0V1c3Qw?=
 =?utf-8?B?UnVRMGlHWDVsSVZ5eGEyZ0JEVUNpdno5MmZkNzhEWU40dlZXZklCK2tJcDJ2?=
 =?utf-8?B?RllhNDV0YUhIQTNtTjQzUmdZMG9QTVk2bTJ1U2ZIL015TysyNXUrYzYyZUFM?=
 =?utf-8?B?RHpQblJVL3FqdnNVNDFRMTFUWXhQZUp4N3krYlRwamJyRUtuZHJLSTh1QmNO?=
 =?utf-8?B?QjZGbkV4WStJSWR5THMzVkFHcDJoM3dDaXptc1dBUXBOeVlDelVUTE9FVTFi?=
 =?utf-8?B?WElabmp1U2FVL01sdHRxY0djTGF5Um03UGhtLzI5SlZSWjJ4RnFHN01hRjQ4?=
 =?utf-8?B?SUw3dGhoUUpZMVlndjJvOXU1TTZMVGdtNVFhMTFWUnJSODQ3ZFNNdkpQMzl5?=
 =?utf-8?B?S0tra2pDZVFZMy94RytvSXdML3BXb1paYVhOZ0NaOTB0Y1JoNmVoRFppT2ZK?=
 =?utf-8?B?YzBXOFkrN1U4WTVmc2RkNWhFT2tPRlVETmF5WC94Tis3c0xsUU0vVFRMZHFX?=
 =?utf-8?B?cUhZYWFYZGFlV1p2OHZJcExjcW1qVmMxb2dUaS80NUNSblgrMFMreW9UbFJ1?=
 =?utf-8?B?K1Jsb0lHSVpOVmJFMWwwcmFGT1NnVnJzU09kdDdsUy9HdUxJZi9VS29hK09V?=
 =?utf-8?B?bFVlM05UQ1ViSHdhWWNDaHE0Zmg5UGxKSXRSZHNXVUNSVUpNYlVjS3FFSFNQ?=
 =?utf-8?B?V0cxckxUQ2RNQ1AxL1h5anAzT1V4T3VnSWJwcjlOYzNPTE9uRDFoWkVlWFhM?=
 =?utf-8?B?dTgzcnJlVnFvdWRaeDhRYjk4OEJTQnppSFFNTTNjNnQ1Q3h1R1JTK2toOFVn?=
 =?utf-8?B?RVBNSXlQMktXK1dzTm9ucjV4eGI5NUpTUXNsMWZLZWJub0pZczlVMW51cjlF?=
 =?utf-8?B?ZDVBWHVpRXlWemNhRWQ0OXhkUDRrMkFMdmRlblZEc0RBbDRxRHpxQi9lUkxX?=
 =?utf-8?B?SFJZRzFIYVpUVnltRWFLU0t3V0ZhOUdjcmlQV1p0OGZVYmdDbHQzYkhpRkhE?=
 =?utf-8?Q?vUrs=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d5c8f7-bde8-4ea1-69d3-08db521358f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 11:32:05.3174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ESJh4YH80tfclEE1ECqcM6n5vxcchQ6okqdCL7H7IUbqWZNGMZOrQ/0BVFivWLTgVo2ZiyuIvb3numSBYTty2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7662
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXks
IE1heSAxMCwgMjAyMyAzOjM5IFBNDQo+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+
IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5j
b207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8u
b3JnDQo+IENjOiBsaW51eEBhcm1saW51eC5vcmcudWs7IFNpbWVrLCBNaWNoYWwgPG1pY2hhbC5z
aW1la0BhbWQuY29tPjsNCj4gUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5k
ZXlAYW1kLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1hcm0tDQo+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYXJhbmdpLA0KPiBBbmlydWRoYSA8YW5pcnVkaGEu
c2FyYW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5pDQo+IDxoYXJpbmkua2F0YWthbUBhbWQu
Y29tPjsgZ2l0IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggbmV0LW5leHQgVjMgMS8zXSBkdC1iaW5kaW5nczogbmV0OiB4aWxpbnhfYXhpZW5ldDoNCj4g
SW50cm9kdWNlIGRtYWVuZ2luZSBiaW5kaW5nIHN1cHBvcnQNCj4gDQo+IE9uIDEwLzA1LzIwMjMg
MTA6NTAsIFNhcmF0aCBCYWJ1IE5haWR1IEdhZGRhbSB3cm90ZToNCj4gPiBGcm9tOiBSYWRoZXkg
U2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+ID4NCj4gPiBU
aGUgYXhpZXRoZXJuZXQgZHJpdmVyIHdpbGwgdXNlIGRtYWVuZ2luZSBmcmFtZXdvcmsgdG8gY29t
bXVuaWNhdGUNCj4gPiB3aXRoIGRtYSBjb250cm9sbGVyIElQIGluc3RlYWQgb2YgYnVpbHQtaW4g
ZG1hIHByb2dyYW1taW5nIHNlcXVlbmNlLg0KPiANCj4gU3ViamVjdDogZHJvcCBzZWNvbmQvbGFz
dCwgcmVkdW5kYW50ICJiaW5kaW5ncyIuIFRoZSAiZHQtYmluZGluZ3MiDQo+IHByZWZpeCBpcyBh
bHJlYWR5IHN0YXRpbmcgdGhhdCB0aGVzZSBhcmUgYmluZGluZ3MuDQo+IA0KPiBBY3R1YWxseSBh
bHNvIGRyb3AgImRtYWVuZ2luZyIgYXMgaXQgaXMgTGludXhpc20uIEZvY3VzIG9uIGhhcmR3YXJl
LCBlLmcuDQo+ICJBZGQgRE1BIHN1cHBvcnQiLg0KPiANCj4gPg0KPiA+IFRvIHJlcXVlc3QgZG1h
IHRyYW5zbWl0IGFuZCByZWNlaXZlIGNoYW5uZWxzIHRoZSBheGlldGhlcm5ldCBkcml2ZXINCj4g
PiB1c2VzIGdlbmVyaWMgZG1hcywgZG1hLW5hbWVzIHByb3BlcnRpZXMuDQo+ID4NCj4gPiBBbHNv
IHRvIHN1cHBvcnQgdGhlIGJhY2t3YXJkIGNvbXBhdGliaWxpdHksIHVzZSAiZG1hcyIgcHJvcGVy
dHkgdG8NCj4gPiBpZGVudGlmeSBhcyBpdCBzaG91bGQgdXNlIGRtYWVuZ2luZSBmcmFtZXdvcmsg
b3IgbGVnYWN5DQo+ID4gZHJpdmVyKGJ1aWx0LWluIGRtYSBwcm9ncmFtbWluZykuDQo+ID4NCj4g
PiBBdCB0aGlzIHBvaW50IGl0IGlzIHJlY29tbWVuZGVkIHRvIHVzZSBkbWFlbmdpbmUgZnJhbWV3
b3JrIGJ1dCBpdCdzDQo+ID4gb3B0aW9uYWwuIE9uY2UgdGhlIHNvbHV0aW9uIGlzIHN0YWJsZSB3
aWxsIG1ha2UgZG1hcyBhcyByZXF1aXJlZA0KPiA+IHByb3BlcnRpZXMuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBSYWRoZXkgU2h5YW0gUGFuZGV5DQo+IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhp
bGlueC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FyYXRoIEJhYnUgTmFpZHUgR2FkZGFtDQo+
ID4gPHNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhbUBhbWQuY29tPg0KPiA+IC0tLQ0KPiA+IFRoZXNl
IGNoYW5nZXMgYXJlIG9uIHRvcCBvZiBiZWxvdyB0eHQgdG8geWFtbCBjb252ZXJzaW9uIGRpc2N1
c3Npb24NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzAzMDgwNjEyMjMuMTM1
ODYzNy0xLQ0KPiBzYXJhdGguYmFidS5uYWlkdQ0KPiA+IC5nYWRkYW1AYW1kLmNvbS8jWjJlLjoy
MDIzMDMwODA2MTIyMy4xMzU4NjM3LTEtDQo+IHNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhDQo+ID4g
bTo6NDBhbWQuY29tOjFiaW5kaW5nczpuZXQ6eGxueDo6MmNheGktZXRoZXJuZXQueWFtbA0KPiA+
DQo+ID4gQ2hhbmdlcyBpbiBWMzoNCj4gPiAxKSBSZXZlcnRlZCByZWcgYW5kIGludGVycnVwdHMg
cHJvcGVydHkgdG8gIHN1cHBvcnQgYmFja3dhcmQNCj4gY29tcGF0aWJpbGl0eS4NCj4gPiAyKSBN
b3ZlZCBkbWFzIGFuZCBkbWEtbmFtZXMgcHJvcGVydGllcyBmcm9tIFJlcXVpcmVkIHByb3BlcnRp
ZXMuDQo+ID4NCj4gPiBDaGFuZ2VzIGluIFYyOg0KPiA+IC0gTm9uZS4NCj4gPiAtLS0NCj4gPiAg
Li4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpLWV0aGVybmV0LnlhbWwgICB8IDEy
DQo+ICsrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdA0KPiA+IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC94bG54LGF4aS1ldGhlcm5ldC55YW1sDQo+ID4gYi9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpLWV0aGVybmV0LnlhbWwNCj4gPiBpbmRleCA4MDg0
M2MxNzcwMjkuLjlkZmExOTc2ZTI2MCAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpLWV0aGVybmV0LnlhbWwNCj4gPiArKysgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpLWV0aGVybmV0Lnlh
bWwNCj4gPiBAQCAtMTIyLDYgKzEyMiwxNiBAQCBwcm9wZXJ0aWVzOg0KPiA+ICAgICAgICBtb2Rl
cywgd2hlcmUgInBjcy1oYW5kbGUiIHNob3VsZCBiZSB1c2VkIHRvIHBvaW50IHRvIHRoZSBQQ1Mv
UE1BDQo+IFBIWSwNCj4gPiAgICAgICAgYW5kICJwaHktaGFuZGxlIiBzaG91bGQgcG9pbnQgdG8g
YW4gZXh0ZXJuYWwgUEhZIGlmIGV4aXN0cy4NCj4gPg0KPiA+ICsgIGRtYXM6DQo+ID4gKyAgICBp
dGVtczoNCj4gPiArICAgICAgLSBkZXNjcmlwdGlvbjogVFggRE1BIENoYW5uZWwgcGhhbmRsZSBh
bmQgRE1BIHJlcXVlc3QgbGluZQ0KPiBudW1iZXINCj4gPiArICAgICAgLSBkZXNjcmlwdGlvbjog
UlggRE1BIENoYW5uZWwgcGhhbmRsZSBhbmQgRE1BIHJlcXVlc3QgbGluZQ0KPiA+ICsgbnVtYmVy
DQo+ID4gKw0KPiA+ICsgIGRtYS1uYW1lczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAt
IGNvbnN0OiB0eF9jaGFuMA0KPiANCj4gdHgNCj4gDQo+ID4gKyAgICAgIC0gY29uc3Q6IHJ4X2No
YW4wDQo+IA0KPiByeA0KDQpXZSB3YW50IHRvIHN1cHBvcnQgbW9yZSBjaGFubmVscyBpbiB0aGUg
ZnV0dXJlLCBjdXJyZW50bHkgd2Ugc3VwcG9ydA0KQVhJIERNQSB3aGljaCBoYXMgb25seSBvbmUg
dHggYW5kIHJ4IGNoYW5uZWwuIEluIGZ1dHVyZSB3ZSB3YW50IHRvIA0KZXh0ZW5kIHN1cHBvcnQg
Zm9yIG11bHRpY2hhbm5lbCBETUEgKE1DRE1BKSB3aGljaCBoYXMgMTYgVFggYW5kDQoxNiBSWCBj
aGFubmVscy4gVG8gdW5pcXVlbHkgaWRlbnRpZnkgZWFjaCBjaGFubmVsLCB3ZSBhcmUgdXNpbmcg
Y2hhbg0Kc3VmZml4LiBEZXBlbmRpbmcgb24gdGhlIHVzZWNhc2UgQVhJIGV0aGVybmV0IGRyaXZl
ciBjYW4gcmVxdWVzdCBhbnkNCmNvbWJpbmF0aW9uIG9mIG11bHRpY2hhbm5lbCBETUEgIGNoYW5u
ZWxzLg0KDQpkbWEtbmFtZXMgPSB0eF9jaGFuMCwgdHhfY2hhbjEsIHJ4X2NoYW4wLCByeF9jaGFu
MTsNCg0Kd2lsbCB1cGRhdGUgdGhlIGNvbW1pdCBtZXNzYWdlIHdpdGggc2FtZS4NCiANCj4gV2h5
IGRvaW5nIHRoZXNlIGRpZmZlcmVudGx5IHRoYW4gYWxsIG90aGVyIGRldmljZXM/DQoNClRvIG1h
a2UgdGhlIGF4aSBldGhlcm5ldCBkcml2ZXIgZ2VuZXJpYyB0byBiZSBob29rZWQgdG8gYW55IGNv
bXBsYWludA0KZG1hIElQIGkuZSBBWElETUEsIEFYSU1DRE1BIHdpdGhvdXQgYW55IG1vZGlmaWNh
dGlvbi5UaGUgaW5zcGlyYXRpb24NCmJlaGluZCB0aGlzIGRtYWVuZ2luZSBhZG9wdGlvbiBpcyB0
byByZXVzZSB0aGUgaW4ta2VybmVsIHhpbGlueCBkbWEgZW5naW5lDQpkcml2ZXIgYW5kIHJlbW92
ZSByZWR1bmRhbnQgZG1hIHByb2dyYW1taW5nIHNlcXVlbmNlIGZyb20gdGhlDQpldGhlcm5ldCBk
cml2ZXIuDQoNCkFib3ZlIGluZm9ybWF0aW9uIGlzIGV4cGxhaW5lZCBpbiB0aGUgY292ZXIgbGV0
dGVyDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzA1MTAwODUwMzEuMTExNjMyNy0x
LXNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhbUBhbWQuY29tLw0KDQpUaGFua3MsDQpTYXJhdGgNCg0K

