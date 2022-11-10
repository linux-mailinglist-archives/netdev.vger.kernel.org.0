Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6F623EF5
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKJJrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKJJrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:47:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5B06A777;
        Thu, 10 Nov 2022 01:47:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhWWqv189knUNgM+4uxmc5/r4ZtLf+O8o/3E5n+TZSnddCr0e+iTWtO8lYZcw+UqwCCZK4EEsppeePfAEJLO0aTw7nwgWK+r9qSjKShyku+XJNp7ap1OglNN5BOzTo4ZkLfb5fTzk9O1sJ4m+KVg8Fyrrl0AtXKlA4Az6xd9CpsvtWD7mZRHil7NS8pgQumqaxdDmJ5uLTrXd+Wx4Gc99tkcZTYkXpA+tLZirartQxpka9UlC4W2SRI/we/uBLHizYF9Khi+VFtE32Z/kmQ8tBPDgYoxhKvt1fm5ghjG4i3QSQOcbDVkX0O7RfltKDAa2QBXwtb3C7JeAcrPqG89/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRs0mmJ6BXDDeykUKYJcEhdNFh7Vh4DKAiB9tapNVjU=;
 b=CLjgl5K5uYHxvInqQk+Hw2H0aELX3+r+0ESeYtMyCLXL9me0s3Wp3lrDy92aSO8jYosyKzrqwQR6z21Nys/33osBZ9tiVT1SFcv/PgY6dnHzOSQHnwpimiOWaGHBlqy0HbFDFwtAXHsiBfyIIVf/66WLbucUz6lg+i3RkTBXEghVonNv2rQftE9PN8+BvG+x+dEmwIPgCdiDO+T4YJQwDGACfaF/FYqJyVOoDisVYLQGwGCGp6vmA96NC7fpGWkr/rsgdsPtaCdmaFHZ9TJy9+C9otrtoIILlr9Xy4ocVXxK5g4ID9/c3WVUQHA5QL0gCXl9Y5mL31qMZTbcSPFpOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRs0mmJ6BXDDeykUKYJcEhdNFh7Vh4DKAiB9tapNVjU=;
 b=A3HI/ITTYXsJFkJ+LmnrjinEmyY6qcI4lvLmm1IVlslYO2Nxjaqi21rWLH+8FxA6Q3Fz6jB/xpJnRSKELmanP75WRaIA1t3DyXxdpOoxxxuiYLDybB1zFY1VMJrra+mxR+G/PZhinxcxrHGMKSlcdpujFqxXqwhaErb0DvieA0U=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by SN7PR12MB7324.namprd12.prod.outlook.com (2603:10b6:806:29b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Thu, 10 Nov
 2022 09:47:03 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::6280:5e4f:8cff:4f34]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::6280:5e4f:8cff:4f34%4]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 09:47:03 +0000
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
Subject: RE: [PATCH net-next] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Topic: [PATCH net-next] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Index: AQHY7pn71B/YqJQWP0eEmIaD65I6gK4sGKsAgAvbgXA=
Date:   Thu, 10 Nov 2022 09:47:02 +0000
Message-ID: <MW5PR12MB5598DC630DC3CBB8D8ACC40087019@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20221102090332.3602018-1-sarath.babu.naidu.gaddam@amd.com>
 <cb40865b-6121-d4a9-a4e3-1f705f90948c@linaro.org>
In-Reply-To: <cb40865b-6121-d4a9-a4e3-1f705f90948c@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|SN7PR12MB7324:EE_
x-ms-office365-filtering-correlation-id: e2b2ff10-72f0-4dab-8669-08dac3008548
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z+ECbl4AQPYDJ8+jTYOsj60ohtU66aKaFa0fE9WPklUQQDq+V0Kp5HEnrvlyTIsoqYQWfWAIY06Lg9OvH63LomRiMplSGW71p1Xp6wChw3THAtYwKzhTGyXzxoeF0fqDIb72khRZncYqnw/WCZA1GC+dpdsZcCKWDnOiu9dA7WCGA4O6jCIn4OFuQWfN+53GYaL8bRUcIUMFm8V8rr3AaT8XR1BAVsMszF19mzqM5wCKbQX/ftkJfuW8s3I9sXnYTrpiJEqwjV38tZlYFc/Uaz/la2BwsOTc9lkIoyL0Y1QyxnrgUuDM933ZAa91ku51rbGHN50AyO/8uDnogbI4puMxK5ArwbfgPOQur2fE9oY3NhWD4+0e/lxKQgCAxFmCZO/PT2QrY+IOSgD7Np3KKPdptO7nS5r/rs7ujtDCwGazuNO7kYojVts5djEGNhxeQFrcZ8R7PdINbM6SgqHL0OGkivJqWk+Q7G064KTz3v3yGW5wLPIxNn9CLrhRu3T6WKorwG7qOeb/rDeFD1gK5dQr703zyrBaAlogANEYNWEfACrw/bjQNDMWrTzEu3q0DPBWS0gs8L79OmEDR66mVchVyeJlEe84F/fQz5r1MNqSYmioE/bmkpZ8Hf1C66NB15xkAMr7nyaXfSC8Np0AdqVqIWWF4w6EXM/X0sFT/caMlOyKdjOkvE+a9BF1/h8e8lmWDVHpnU0swmlyD3hn4BrL11pvf2jpCNoWuB5JcwJLDL+dsyP/4Hx/Um4aaFI2w1m5ohZ357543NwXzwmqqmElfAjiWwAYJMWQhsiroEA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(478600001)(966005)(71200400001)(86362001)(122000001)(54906003)(38100700002)(110136005)(6506007)(33656002)(52536014)(8936002)(26005)(316002)(53546011)(83380400001)(7696005)(9686003)(76116006)(41300700001)(8676002)(38070700005)(66476007)(66556008)(64756008)(66946007)(4326008)(186003)(55016003)(5660300002)(66446008)(7416002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWJoc3haYStUdXB6YXpZK1c3UklnTXJmQkg2bGNvcW1pekFZQkx4VzdkSVND?=
 =?utf-8?B?Rlk3Yy8vWDJrWWFnTEp0OENkSHg5K05obVZab2Rqb1VKYVUzSk9xMXFvc0I0?=
 =?utf-8?B?MjVrS05TTkFVZ1FGL0Q4QlNqQStqVVF2UmVMZU04YjhUbUo2b2hieC9TVGNQ?=
 =?utf-8?B?c2ZscTB3eGpKT2hqMGk5QjJXNHNMeGFnckc5UndMekNCcDc1US9kb3pKUk1k?=
 =?utf-8?B?V3FqMUk1WGx0MnllT1VqbXg5a3RNQlpGNHl1d3VpUXRJWFJLekVSc0czbXdj?=
 =?utf-8?B?OVVEMStQRkl2cnpXdnpRREVjRG4ySGFPU25STHYrbWZFSG05azRkTzlsZ0VV?=
 =?utf-8?B?U1N6NmdLQjJtdTRZTGZqZHVCaUIvYytZWUVHd1U4VTRSV1pyZDdCNEsvNGsw?=
 =?utf-8?B?U2lDRjh1TzJsb3NvczN6NFdBakRuTHh1UzNUUDFtSkFUWHdNRys3QzRwNkZO?=
 =?utf-8?B?d3c1SVNwRmtMMEZ2UkFpZTNOQVIwRzJwQU9JWnpTRDBMM2U4cVdwdWZvVWZi?=
 =?utf-8?B?MGdsK2lJUkt6WE9mdERtRXR3WXRKYjNFdWs0UWE1cWJMTTRjNkhRN0c1Qkwr?=
 =?utf-8?B?cnBKdnhjRDVWQkRNcFlHUXhvbmNramJFc1dmSkdvWU12Z3UxSzc1TW1NYTYz?=
 =?utf-8?B?Z3V2blJPdUpsVHdjT2p4MzE1MHRuYlNFVGJNQ29mdEJreTVwRGpPTWtvVXo5?=
 =?utf-8?B?endLOFBabE44aS9LNDA2dGRmMjc3RDFKd1lNVkFBakNrTk5xTysrcHpmVTZJ?=
 =?utf-8?B?djdPcXBhaHEvWENJTENlV0dpeHBhbDAzOWo3Wnk4SkZnaENqR2h1WG9BWDdP?=
 =?utf-8?B?M3RJTWh4Sk9EOUNpRGlFZkI1L2pwSjVkNFhnQXdFSWdIT1dpV0x6Mk1QTmtm?=
 =?utf-8?B?RDJpd2w4SEJlQVEwcndZZmtucWp4SDdDU3VFeno5aFhVUlRtUVhxZU9tbFAv?=
 =?utf-8?B?VjNRbFFQY2pZSjFDNlkxOGM0SlB1UWU1blh3TXlBQ255QjFaM3N3bXF0WVBO?=
 =?utf-8?B?K25zV0d1VitySUpndWFlUEVCbE1RQ3k2c0V5eUlaU1NqS1MxMVBXa2JWRmhO?=
 =?utf-8?B?dnp5Ym9CZU5uRms3K09pc0loZWU2dk9nS2ZQVTJ3L2VOMXRJUlcxdkZjbjJY?=
 =?utf-8?B?QVhHUWlRUFZycVVQMURTRjZSOVdGamRYV1VYMlhxZitGdEcvT2xzMmpVT3hN?=
 =?utf-8?B?czRDWjVzaC9GcUVJK3V6MmpCWW1iQVVFTUVkamZjdmd5MzRtaTNLS2k2a3F2?=
 =?utf-8?B?bUJ4bDFlV25IanV1NUVEQmo4ZDlQdE8veGpjTng3bEJ1K2c3Y2FjZlpiYS9w?=
 =?utf-8?B?TWo0b0M2Wm1LWjZ2NkJHZFlmY2JGNWZPR3g5SUNqeE54SWIxbHdxOEpaeElY?=
 =?utf-8?B?S1orMkZDNUM2WEc2V3drNUdXOHBDOVBCOGVaQU9CeTdZQ21kWVY1ZUpqSWJ3?=
 =?utf-8?B?QTVZQWx6cXB3RjNsWnBZMnh1b0tFbnBPSXVnWTMyUG1yS2lzcUwzN0RvcFd6?=
 =?utf-8?B?UDBSQ0lmT2VBQnhkUVdaU3Z3WjNYRVIyUTcyMzBTbjNJNi92TkY2VTV0Um00?=
 =?utf-8?B?bDc3RGNyOWJaaHNzeXZwSUhRTk10T2VvV3FxUEI3N1JTZk9RcXFnRDVSSmV4?=
 =?utf-8?B?QWZKZURQTkE0QUVVUTArcG1zTE96bmdNODM2UklJRXZlMTlzRmNWdEVkOWtS?=
 =?utf-8?B?Q0ZobWRTOUZIdXNpR2cyOFY4eEs5WTFSam9mUFF0ZFNsM3pFblgzL2oxMUZH?=
 =?utf-8?B?MjVKK3IrU0xlVDRhbGV4eXlUR24yeG1LN2ZzZUxQU1EwYWQ3V2ZYcTMwVTFr?=
 =?utf-8?B?b1cwc2hkT0NOZVRpbk9WU0psczVIalFUdFVRbWdINHNOWmhPM2dRYWV5dmo4?=
 =?utf-8?B?Qm9LTW53ejBIRkx5OFZyR2NYQ3VBOUd2UmhGdHZKUW5iRVJtREFsWmZEeUFD?=
 =?utf-8?B?Z2xQaWVlVHhSN2dBWnpUeVNRclFsK2VrUUVmMjN0Z1R1bTdIeVNJNG0rQzVH?=
 =?utf-8?B?NWh6QjIrWDUzV2NrVHhLQnpCZG9JeTlnZXNvSE11UG9vb3FuVkhUdjdFeHNp?=
 =?utf-8?B?NHIwZmwyalpGZTNLS09DY29jNU91TVJUZGw3M1l0c1J1MGRkNmc4SEFiamxJ?=
 =?utf-8?Q?1y60=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b2ff10-72f0-4dab-8669-08dac3008548
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 09:47:02.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kvKQWQqtisbz04L47Euv5gw7eg35Og7w16QcYiyAzmhjumHtFxK1ZIH+0cug+U+Q7Zz2C+RVZlE9A4gOgo7L/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7324
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBUaHVyc2RheSwg
Tm92ZW1iZXIgMywgMjAyMiAyOjA4IEFNDQo+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1
IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47DQo+IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhh
dC5jb207IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4ga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5h
cm8ub3JnDQo+IENjOiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgcmFkaGV5LnNoeWFtLnBhbmRl
eUB4aWxpbnguY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIu
a2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwgQW5pcnVkaGENCj4gPGFuaXJ1ZGhh
LnNhcmFuZ2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA8aGFyaW5pLmthdGFrYW1AYW1k
LmNvbT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldC1uZXh0XSBkdC1iaW5kaW5nczogbmV0OiB4bG54LGF4aS1ldGhlcm5ldDogY29udmVy
dA0KPiBiaW5kaW5ncyBkb2N1bWVudCB0byB5YW1sDQo+IA0KPiBPbiAwMi8xMS8yMDIyIDA1OjAz
LCBTYXJhdGggQmFidSBOYWlkdSBHYWRkYW0gd3JvdGU6DQo+ID4gRnJvbTogUmFkaGV5IFNoeWFt
IFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tPg0KPiA+DQo+ID4gQ29udmVy
dCB0aGUgYmluZGluZ3MgZG9jdW1lbnQgZm9yIFhpbGlueCBBWEkgRXRoZXJuZXQgU3Vic3lzdGVt
IGZyb20NCj4gPiB0eHQgdG8geWFtbC4gTm8gY2hhbmdlcyB0byBleGlzdGluZyBiaW5kaW5nIGRl
c2NyaXB0aW9uLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleQ0K
PiA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNh
cmF0aCBCYWJ1IE5haWR1IEdhZGRhbQ0KPiA+IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1k
LmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQg
ICAgICAgICAgIHwgIDk5IC0tLS0tLS0tLS0tLQ0KPiA+ICAuLi4vYmluZGluZ3MvbmV0L3hsbngs
YXhpLWV0aGVybmV0LnlhbWwgICAgICAgfCAxNTAgKysrKysrKysrKysrKysrKysrDQo+ID4gIE1B
SU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ID4g
IDMgZmlsZXMgY2hhbmdlZCwgMTUxIGluc2VydGlvbnMoKyksIDk5IGRlbGV0aW9ucygtKSAgZGVs
ZXRlIG1vZGUNCj4gPiAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC94aWxpbnhfYXhpZW5ldC50eHQNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+ID4gRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94bG54LGF4aS1ldGhlcm5ldC55YW1sDQo+
IA0KPiBUaGVyZSB3YXMgYSB2MiBvZiB0aGlzOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgtZGV2aWNldHJlZS8yMDIyMDkyMDA1NTcwMy4xMzI0Ni0yLQ0KPiBzYXJhdGguYmFi
dS5uYWlkdS5nYWRkYW1AYW1kLmNvbS8NCj4gDQo+IFJldmlld2VyJ3MgdGltZSBpcyBwcmVjaW91
cy4gRG9uJ3Qgd2FzdGUgaXQuDQoNClRoYW5rcyBmb3IgUmV2aWV3IGNvbW1lbnQuDQogU29ycnks
IGl0IHdhcyBkdWUgdG8gUkZDIC0+IFBBVENIIHZlcnNpb25pbmcuIFdpbGwgZml4IGFuZCBzZW5k
IG5leHQgdmVyc2lvbi4NCg0KVGhhbmtzLA0KU2FyYXRoDQoNCg==
