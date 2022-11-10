Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA24A623F2A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiKJJ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKJJ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:58:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC316B226;
        Thu, 10 Nov 2022 01:58:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgxfY49fFgMpwpFIwaC0Exog2I8bKa57uvCTe37Tyh7RxOPe8az1le+Jri/kI43TY38xnu/9va3PNNDcIwSESHWg13QTx2z4wvW9vXezqovb+0+cwkeUvVLx+CI2NB9I86kBMS8ZzdC6/hTwHV24ip9dNaPW21loqaJoddNhzjVlxn4C775UyxfIPgN+tO83S/AxQjHrKnujh2bvLDy2NdjHsJJrKoyp6SzbHbAQnm5TX01fGJu5NsnveYMTDB5XQZv5LV8D9iyYh6Igrs+FUClUfo9/SIW6Iir2UNsqy/75y3KKmKV1lJA0zVz0DT66INj+IEXwQtZxr1yVM2AlGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znx+ZqbHcYZh6K7cDj93NEY6diNE5ECKrMutNpg3KsI=;
 b=ecGALCxMMlWrCl4a9jY/4qWcYP/+eHbVEvq5RMFpWmjK0ta0C1UTA3cMwf2djbG4aukfwUCXFgyvYC4cZMvvAlYVk483lgBadnwB4t9MoEnoTBQ5nqKRSunT05aB7IuNB6CG9ZUe3wFh2u7XfjsCek9WRND7KnmOUii+KD+h0pAjHi8Wsfqe7R6i7L1aJlAiiRKxB8ysAunohUnM4EKczdeuo/Nw7rh7yXS1TI/qLIk9sW3XXAfAuKj7mI3my5KnVF3koDPxzsTPZHYdCOHZjJY5+YrA91Ksbx0IJE7bHiZHrASLD2Cd/cHstyJMQzrN4wLHwQ3WTyvPXONVF+rISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znx+ZqbHcYZh6K7cDj93NEY6diNE5ECKrMutNpg3KsI=;
 b=Hi2iCxqJf2TJtOyYUno6bpe8O/9HO6dw/A05KkLIs+C88KoSUzjW77AN2cVHyVFq0NmoQ8xKPud91SBGdXvamP+xUGKy7+LrFlnD348vgNsGsPM7vvVZF1uOE/hXYGud8m/spwy/1Btp7DUpi6Bzjqqi4aCb3FKf8BM3yaqafxY=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by BN9PR12MB5194.namprd12.prod.outlook.com (2603:10b6:408:11b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Thu, 10 Nov
 2022 09:57:58 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::6280:5e4f:8cff:4f34]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::6280:5e4f:8cff:4f34%4]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 09:57:58 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Thread-Topic: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Thread-Index: AQHY5Q+/hQESpMCxEk+Zmtk3AXijhq4cIcUAgBvn0BA=
Date:   Thu, 10 Nov 2022 09:57:58 +0000
Message-ID: <MW5PR12MB559842AC3B0D4E539D653B3D87019@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
 <cfbde0da-9939-e976-52c1-88577de7d4cb@linaro.org>
In-Reply-To: <cfbde0da-9939-e976-52c1-88577de7d4cb@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|BN9PR12MB5194:EE_
x-ms-office365-filtering-correlation-id: 3f20ddb2-994d-46da-73b0-08dac3020be8
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t02DV0VrKmj0Daus4LbUF+oS7oT8Pv+pAFsSE/cEiUweB2eGvrbcSrKoSwkccaXcJcV4Vg6paqDa2Pw6cgOYvb9W78QKEgZUcn0NgG8h5LE353xgCxN/GHhCJVJTCYjw/ocK1VKLNYd9w+wRkE/gnYfeoL2GmxL/n7qeAaayF0/3hZwoBRy5hZdrX7h+aCICEZcJXQleq69AkChhgYLjHhpBbSqx088ujeJ46j7zBE9b5faEhGZ1Uhg2BTorGr1wZmOwwjE49lvLIoCMDFTmw0/LujHHI1vQb6oRWYXkVdbU89uRpQ1pdP3uOmy1xnfk5k9WusrcnMw7NYlpS/5LI/AdYUDuYobxKBoQkQEq9qa60RBgv1h82zNXVSnoPMpcGtCbqSQlSiQfU4uC5iYSaDaGeQ7xA7IrGZM7ybjxbgx9rd7v38809dwnbQ9IdS0V5kQAzUhT1gmQkw0O6ID8NBOhKauWost6dy0EBYrkBVfQbNiPZhEFN//fNtkZlkwqRbwSSdwUFmrS7b0ddu0e7B4dj6v+kh+RoTv7V9Tpi6zP916ysj/tW29XdA8gzVV5QneNBpmGxhQ5p/Om/jyL3dM4i3jl8yQQY65N3l2FPOltcR/OLlH73DVYsRFCo+ohmcXkVY+JkPlLYhTgV8v+GzgTkiLbd0lYP8rKPAjSvE9IBhwMU/An16P9W/QP5pYMVHdow5qOSPd03Fnpy4QVPxFedk7cr5lNOqEE783WdUMe67K3Bnv/uoYDGufezbcn51loeKb2oCI+Oi5qPz9qZnfVcHDAwoLDxcd1IdHmmvc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199015)(76116006)(478600001)(38100700002)(2906002)(966005)(38070700005)(71200400001)(186003)(122000001)(83380400001)(7696005)(64756008)(33656002)(53546011)(9686003)(6506007)(66476007)(66556008)(66446008)(316002)(4326008)(8676002)(26005)(66946007)(86362001)(55016003)(54906003)(52536014)(8936002)(5660300002)(7416002)(110136005)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGprMVF5T0VLR3N6dWpJRHpGMlVSVDVrcFZOWUVFdkdlNFhtcHNrVi95TlEz?=
 =?utf-8?B?RlFhbXVQTUUrVC92dXlZc3JlaFhSNDNwSGFKZk9lTlVBaytRWjhUMWtKM09I?=
 =?utf-8?B?TEFJV3NmaXhVYVYrSitaU2RiYlhySVU5ZmNhYndWdUFnd0tnbi9JV0xZZ0k4?=
 =?utf-8?B?enZvQ0hiVEVKZjFNLzYyZFpNS2NHWVpBVnd1NTVsczVpdEYwSXFBbjZHYU9m?=
 =?utf-8?B?aExYWW9VeFNrcml1bUp1M25sbHZQU1o2MFJCY3NzcFFxZnFrVDkwcHhweE9V?=
 =?utf-8?B?Z0ZRenN0dmszekpkYXg1eGJ6ajU0MkhTT054OUJjLzhTRnFXb1pEd1VWd0tq?=
 =?utf-8?B?b3VmNEVwZlhHbm9hUkpKYWwyRXNhdTMxZFo2MkFPYkJXR1puRGpVclBjZm5o?=
 =?utf-8?B?YmRiTmUxUCs3bFVteTVmb0c2aU5RTUY5VVBaUWFaWktoTmtObHRQZmhNNUIy?=
 =?utf-8?B?cTgxTGU3MmN4eHhKMmF4ZUFGWjJ2WjdTTHdnZXRLVjVvQkQ2R3BuRzBoVEVo?=
 =?utf-8?B?U2lPZkMrR2gyQjdsRTREY2JRczJZQytnb3ZlemNwOXJEZGRBMTZoWGdEdkhH?=
 =?utf-8?B?bzBLN2c5MVdZckNibVFnK2sza3F2RHFIWFlhZDV6Uk1FUFl6Z2dhZTB4bEQ0?=
 =?utf-8?B?RDNtSXFtRUozNFFqeEFuUDZvS0hzZGFSdXRZNDJHNUxBb1Nid2J5MktMM0Qx?=
 =?utf-8?B?cE5CdWpRRnBDaGRNNWw3bG9YcCtyNDdTY0NEZkFvRFE0NEhPb295U1YvTU5o?=
 =?utf-8?B?VXFYaGQ2T05hUVdDc21rUDJQUXFDcFV2MzMxWkZPbjltdTJDSnB1UXZGSEg0?=
 =?utf-8?B?K09TYm8wVFFFeXpLNnYxZlEwOVBRbVVPMWF6MGZhK2FyWmMxb09MazU3NHRS?=
 =?utf-8?B?YXpNMUdVam5uenJuTVZCUjFnOVh0UHM4YnQySE80NDJLdHFONEJ6c0ZQUXNK?=
 =?utf-8?B?V1I3RW41Tk1xak4yOXl6Zjl4Z2pCU05BbXNKeUZVMDdjam9PcEFUKzlOQVFq?=
 =?utf-8?B?SmtrWnFma2JCZWpoS1gyVitxelE0YTIxRTBJa1ZFbjkwOEFVd1R6NnBRcndX?=
 =?utf-8?B?SXgrYkFQVCsvOUljbnNqdUozWkxPVWNwR1NvbUdVMlIvTURObGp1VVduazFt?=
 =?utf-8?B?cjhjMndNNnhHT2xCR25KMXV3SmxlRTRHT0krSUpSazZTZnF3VFdyTW80VVRD?=
 =?utf-8?B?VTRNYlphZW1hbVdVcmVraUtGazdSYVlOa2pJVDZSejhRNVRSNllrUk5oeVBM?=
 =?utf-8?B?TWw2RzNpcjdBRzIvQmYvd1RqNDQzNFdqN21FU0VFN0JBSXFhdWYyK3d3dmdN?=
 =?utf-8?B?OGhTSDNKdTZmK0dRSXhZSitURC9BOWNseHRlQlN3TGVpUTloL210c25DR0dO?=
 =?utf-8?B?cGNpMmhSYzRTM0dpeGNXR1FTVXRseVJCT29vcTNkckFXRmQwOW1ib3RDYVQr?=
 =?utf-8?B?L2o1c1R1MXAxQnF2Ly95Y3Z0Zk9xd3VjYzdNWlgrUFZGWHp2d0lNYUNReVB6?=
 =?utf-8?B?Q29aNmNnR3pkcHk2OGxxOVVFSXBiTUZ4MExPQlVhaEtmQno0WFdtdDBpYVU3?=
 =?utf-8?B?S2poSVl5eDBxcFlQWGFtSGhRM2Z0Q29FMUJOVUlxZTZQM2pGRG5OOXZYZkE1?=
 =?utf-8?B?YnN0Vkd6cFIzODQ3ZElBRG95RC94QUxjSEFPWkg0cXZKZnhURE0ycHhHeFZu?=
 =?utf-8?B?M0NQbWJwdnI1NHRpNUpNUlFXK252bDZoMHROaXdQT3FNSzQ3Y2srUmJOY0I1?=
 =?utf-8?B?amRFZVliSnV3RktLN3NEdzJKWU94S1lEZS9YQW00NWhMUHYyMmxJaC93V2ls?=
 =?utf-8?B?bXlaM05jZk5yeDhEbVFackYwTTkrYnUyclhkN3lpbjZLQk1rVEpQcnJIV3VH?=
 =?utf-8?B?T3A2L2MxTkY1QlJOLzBVZVlEeTU4aG1YdnJUWFUvYnUvYitsZmp5MGVLaG1h?=
 =?utf-8?B?SjNYVTFuYis2OERWS0VVaExMWkdvejJOQlUyNjNZTjdFZE5POVlCbWE0MWZV?=
 =?utf-8?B?Q0ZsSEwreWZKTklBREtqMDhsSXdZU1pYM0xNRDBkcmZodXhodk1XY0ZMclI0?=
 =?utf-8?B?cHY5aDFmNWgzcHJXSjFRR1FzZnVTVytrdWszaWJMUWdlQnk5U3Nxc1BLSDhz?=
 =?utf-8?Q?q+UE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f20ddb2-994d-46da-73b0-08dac3020be8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 09:57:58.3168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mppZ2LE5PpZpYDvIzCWZxX65mLq7+gdjNS6v6iGxZlhVmPODv+fXFcUq21lzMLDS/yLVb2kXFS2o1l8cbT+UWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5194
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
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBTdW5kYXksIE9j
dG9iZXIgMjMsIDIwMjIgOToxMiBQTQ0KPiBUbzogR2FkZGFtLCBTYXJhdGggQmFidSBOYWlkdSA8
c2FyYXRoLmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0
OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQu
Y29tOyByb2JoK2R0QGtlcm5lbC5vcmc7IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbQ0KPiBDYzog
a3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
Ow0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsNCj4geWFuZ2JvLmx1QG54cC5jb207IFBhbmRleSwgUmFkaGV5IFNoeWFtDQo+IDxyYWRo
ZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+OyBTYXJhbmdpLCBBbmlydWRoYQ0KPiA8YW5pcnVkaGEu
c2FyYW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5pDQo+IDxoYXJpbmkua2F0YWthbUBhbWQu
Y29tPjsgZ2l0IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggbmV0LW5leHQgVjJdIGR0LWJpbmRpbmdzOiBuZXQ6IGV0aGVybmV0LWNvbnRyb2xsZXI6IEFk
ZA0KPiBwdHAtaGFyZHdhcmUtY2xvY2sNCj4gDQo+IE9uIDIxLzEwLzIwMjIgMDE6NDEsIFNhcmF0
aCBCYWJ1IE5haWR1IEdhZGRhbSB3cm90ZToNCj4gPiBUaGVyZSBpcyBjdXJyZW50bHkgbm8gc3Rh
bmRhcmQgcHJvcGVydHkgdG8gcGFzcyBQVFAgZGV2aWNlIGluZGV4DQo+ID4gaW5mb3JtYXRpb24g
dG8gZXRoZXJuZXQgZHJpdmVyIHdoZW4gdGhleSBhcmUgaW5kZXBlbmRlbnQuDQo+ID4NCj4gPiBw
dHAtaGFyZHdhcmUtY2xvY2sgcHJvcGVydHkgd2lsbCBjb250YWluIHBoYW5kbGUgdG8gUFRQIGNs
b2NrIG5vZGUuDQo+ID4NCj4gPiBGcmVlc2NhbGUgZHJpdmVyIGN1cnJlbnRseSBoYXMgdGhpcyBp
bXBsZW1lbnRhdGlvbiBidXQgaXQgd2lsbCBiZSBnb29kDQo+ID4gdG8gYWdyZWUgb24gYSBnZW5l
cmljIChvcHRpb25hbCkgcHJvcGVydHkgbmFtZSB0byBsaW5rIHRvIFBUUCBwaGFuZGxlDQo+ID4g
dG8gRXRoZXJuZXQgbm9kZS4gSW4gZnV0dXJlIG9yIGFueSBjdXJyZW50IGV0aGVybmV0IGRyaXZl
ciB3YW50cyB0bw0KPiA+IHVzZSB0aGlzIG1ldGhvZCBvZiByZWFkaW5nIHRoZSBQSEMgaW5kZXgs
dGhleSBjYW4gc2ltcGx5IHVzZSB0aGlzDQo+ID4gZ2VuZXJpYyBuYW1lIGFuZCBwb2ludCB0aGVp
ciBvd24gUFRQIGNsb2NrIG5vZGUsIGluc3RlYWQgb2YgY3JlYXRpbmcNCj4gPiBzZXBhcmF0ZSBw
cm9wZXJ0eSBuYW1lcyBpbiBlYWNoIGV0aGVybmV0IGRyaXZlciBEVCBub2RlLg0KPiA+DQo+ID4g
YXhpZXRoZXJuZXQgZHJpdmVyIHVzZXMgdGhpcyBtZXRob2Qgd2hlbiBQVFAgc3VwcG9ydCBpcyBp
bnRlZ3JhdGVkLg0KPiA+DQo+ID4gRXhhbXBsZToNCj4gPiAJZm1hbjA6IGZtYW5AMWEwMDAwMCB7
DQo+ID4gCQlwdHAtaGFyZHdhcmUtY2xvY2sgPSA8JnB0cF90aW1lcjA+Ow0KPiA+IAl9DQo+ID4N
Cj4gPiAJcHRwX3RpbWVyMDogcHRwLXRpbWVyQDFhZmUwMDAgew0KPiA+IAkJY29tcGF0aWJsZSA9
ICJmc2wsZm1hbi1wdHAtdGltZXIiOw0KPiA+IAkJcmVnID0gPDB4MCAweDFhZmUwMDAgMHgwIDB4
MTAwMD47DQo+ID4gCX0NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhcmF0aCBCYWJ1IE5haWR1
IEdhZGRhbQ0KPiA+IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT4NCj4gPiAtLS0N
Cj4gPiBXZSB3YW50IGJpbmRpbmcgdG8gYmUgcmV2aWV3ZWQvYWNjZXB0ZWQgYW5kIHRoZW4gbWFr
ZSBjaGFuZ2VzIGluDQo+ID4gZnJlZXNjYWxlIGJpbmRpbmcgZG9jdW1lbnRhdGlvbiB0byB1c2Ug
dGhpcyBnZW5lcmljIGJpbmRpbmcuDQo+IA0KPiBObywgc2VuZCBlbnRpcmUgc2V0LiBXZSBuZWVk
IHRvIHNlZSB0aGUgdXNlcnMgb2YgaXQuDQo+IA0KPiA+DQo+ID4gRFQgaW5mb3JtYXRpb246DQo+
ID4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFs
ZHMvbGludXguZ2l0Lw0KPiA+IHRyZWUvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvcW9y
aXEtZm1hbjMtMC5kdHNpI24yMw0KPiANCj4gRG9uJ3Qgd3JhcCBsaW5rcy4gSXQncyBub3QgcG9z
c2libGUgdG8gY2xpY2sgdGhlbS4uLg0KPiANCj4gPg0KPiA+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC8NCj4gPiB0cmVl
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLWZtYW4udHh0I24zMjAN
Cj4gPg0KPiA+IEZyZWVzY2FsZSBkcml2ZXI6DQo+ID4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0Lw0KPiA+IHRyZWUvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGh0b29sLmMjbjQ2Nw0KPiA+
DQo+ID4gQ2hhbmdlcyBpbiBWMjoNCj4gPiAxKSBDaGFuZ2VkIHRoZSBwdGltZXItaGFuZGxlIHRv
IHB0cC1oYXJkd2FyZS1jbG9jayBiYXNlZCBvbg0KPiA+ICAgIFJpY2hhcmQgQ29jaHJhbidzIGNv
bW1lbnQuDQo+ID4gMikgVXBkYXRlZCBjb21taXQgZGVzY3JpcHRpb24uDQo+ID4gLS0tDQo+ID4g
IC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9ldGhlcm5ldC1jb250cm9sbGVyLnlhbWwgICAg
ICAgICB8IDUgKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdA0KPiA+IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9ldGhlcm5ldC1jb250cm9sbGVyLnlhbWwNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQtY29udHJvbGxlci55YW1sDQo+ID4gaW5kZXggM2Fl
ZjUwNmZhMTU4Li5kMjg2M2MxZGQ1ODUgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9ldGhlcm5ldC1jb250cm9sbGVyLnlhbWwNCj4gPiArKysg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2V0aGVybmV0LWNvbnRyb2xs
ZXIueWFtbA0KPiA+IEBAIC0xNjEsNiArMTYxLDExIEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAg
IC0gYXV0bw0KPiA+ICAgICAgICAtIGluLWJhbmQtc3RhdHVzDQo+ID4NCj4gPiArICBwdHAtaGFy
ZHdhcmUtY2xvY2s6DQo+ID4gKyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0
aW9ucy9waGFuZGxlDQo+ID4gKyAgICBkZXNjcmlwdGlvbjoNCj4gPiArICAgICAgU3BlY2lmaWVz
IGEgcmVmZXJlbmNlIHRvIGEgbm9kZSByZXByZXNlbnRpbmcgYSBJRUVFMTU4OCB0aW1lci4NCj4g
DQo+IERyb3AgIlNwZWNpZmllcyBhIHJlZmVyZW5jZSB0byIuIEl0J3Mgb2J2aW91cyBmcm9tIHRo
ZSBzY2hlbWEuDQo+IA0KPiBBcmVuJ3QgeW91IGV4cGVjdGluZyBoZXJlIHNvbWUgc3BlY2lmaWMg
RGV2aWNldHJlZSBub2RlIG9mIElFRUUxNTg4IHRpbWVyPw0KPiBJT1csIHlvdSBleHBlY3QgdG8g
cG9pbnQgdG8gdGltZXIsIGJ1dCB3aGF0IHRoaXMgdGltZXIgbXVzdCBwcm92aWRlPyBIb3cgaXMN
Cj4gdGhpcyBnZW5lcmljPw0KDQpUaGFua3MgZm9yIHJldmlldyBjb21tZW50cy4NCiBGb3JtYXQg
Y2FuIGJlIGFzIGRvY3VtZW50ZWQgYnkgdXNlcnMgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL3B0cC8gbWVtYmVycy4gVGhlIG5vZGUgc2hvdWxkIGJlIGFjY2Vzc2libGUgdG8gZGVy
aXZlIHRoZSBpbmRleCBidXQgdGhlIGZvcm1hdCBvZiB0aGUgUFRQIGNsb2NrIG5vZGUgaXMgdXB0
byB0aGUgdmVuZG9yLg0KDQoNCj4gDQo+IEluIHlvdXIgY29tbWl0IG1zZyB5b3UgdXNlIG11bHRp
cGxlIHRpbWVzICJkcml2ZXIiLCBzbyBhcmUgeW91IGFkZGluZyBpdCBvbmx5DQo+IHRvIHNhdGlz
ZnkgTGludXggZHJpdmVyIHJlcXVpcmVtZW50cz8gV2hhdCBhYm91dCBvdGhlciBkcml2ZXJzLCBl
LmcuIG9uIEJTRA0KPiBvciBVLUJvb3Q/DQoNCkFGQUlLIHRoaXMgaXMgZm9yIExpbnV4LiBJdCBp
cyBub3QgcmVsZXZhbnQgdG8gdWJvb3QgYXMgdGhlcmUncyBubyBQVFAgc3VwcG9ydCB0aGVyZS4N
Cg0KVGhhbmtzLA0KU2FyYXRoDQo=
