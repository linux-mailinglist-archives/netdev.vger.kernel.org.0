Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871C46B3597
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 05:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCJEZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 23:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCJEYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 23:24:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83261103ECB;
        Thu,  9 Mar 2023 20:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678422159; x=1709958159;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hQkE0/MceluWzZ3c5D89KdVLlOpIA+VEngtptz/C1Hk=;
  b=aWau0aIApPsy1knw5EUmuBFoEVgay93oXrX2yEKfsNmh+OqP55COs4no
   CoNLgaSUzfltFBubQpyRTN1bkGQz25tenVrTYq8LxA0PwMzzdoI+nJGVY
   50nPIPFb6C3q0r0tKT77D61P0RCWGQ7EQE66ikbskAfW6k5Kpdz0Po4SE
   f7Vna7I0mVkRjdUqiuo8dbMLOyJlg0LDULNk7rrSzuS1NDVBBdjeey+BK
   gy3naQfBWtl6ZzDEL9yHKX2HmyU/JnW5eGXwZS+OIA+o5svjkpZ1Q6UKK
   MFQuNXnZqIEzeCVCyD1B6RXE+tZGNahFOZ4B2+1WbQmhupuffb9MT/upV
   g==;
X-IronPort-AV: E=Sophos;i="5.98,248,1673938800"; 
   d="scan'208";a="200939170"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2023 21:22:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Mar 2023 21:22:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Mar 2023 21:22:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4z1lG2DWjakFb+bRkvoYcmoU9SA9KXtKxmgV3+CYc3ToM87s2M6siiAtQCJFq9hAzmoosggOqxkbqMUJ1Os+UvV4VG2DG7qCzynujaiYD4ozlPEfsDqPcScs+D7nzIjJPir6OvXFz3/cEUI/wm3mtVzrPDgan0SG4wPGXo7x19PTkOMS2PWbkFNtGiWNWoa/RrWb5QXeFaR3M0EM+AJj+VtEA6WQalLnzCQJyAXGmR4ycz9Y2k+kG+PpNwdouEuR+ulDeG4/djHqpzHrNV7LEJxyKKsvxEACJUxixY9qswOWfmb5uK7sq2UjkOiFAvEZwrYHPdMYPCEQg/M+fQ8oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQkE0/MceluWzZ3c5D89KdVLlOpIA+VEngtptz/C1Hk=;
 b=gQkGho6rJprjQnltOigt1bIhSDO/DMeom4p3N4YdXPH4bxXMV5aCZ6+Zzpe1keX1MyLMaTVacqRZUmvZz0LJNpFnLGxj88921UEcIubdmQIXQyRMkESx3Zuo+2DgwxKl91coS4DONbTOlig95OxeZ5Kope537dNuXoviyZ6RU3E+onDThdohDkRA3Xqc3crfudE4D7EGLSBBJTGB2cCS50qv4AUvj4/puK1H9fDHt/uthdCmK9E1Sl/EhzTzhDYdfZYbBCLeb1VJAHaUjJ9laFINsmCSWTMI3gEt0USRk2Xbu+xZ1TB3/t1iLJAZb4RM/Z9VpiuPW7d0Nd/iTUf3Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQkE0/MceluWzZ3c5D89KdVLlOpIA+VEngtptz/C1Hk=;
 b=JkZiQLRF7a8YD4Ikm4AC65jSsyNVmPmNarE7BFGYxm1AcGLuNw7NrLv5kEdif/v9bAC8eEH6rm8xKqTxIqWxQZlMRQckbFAb2X5Qc0hOgTc9Bh8Ux3zGvd5SWIJrUZTRbzzVh397dfZjv5gpiyMPPKahzr8ujy5+4FMxKxiBCes=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH7PR11MB7595.namprd11.prod.outlook.com (2603:10b6:510:27a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Fri, 10 Mar 2023 04:22:34 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 04:22:34 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: add
 ksz_setup_tc_mode() function
Thread-Topic: [PATCH net-next v2 1/2] net: dsa: microchip: add
 ksz_setup_tc_mode() function
Thread-Index: AQHZUZ5Av0nPPShPFEWlvXywg0UHSq7zZoGAgAAGI4A=
Date:   Fri, 10 Mar 2023 04:22:34 +0000
Message-ID: <95ca2bceeb4326b993a160f5c4e8b060e4f47392.camel@microchip.com>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
         <20230308091237.3483895-2-o.rempel@pengutronix.de>
         <6263ddb2ad1fb38dcde524197b5897676c3ddf8c.camel@microchip.com>
In-Reply-To: <6263ddb2ad1fb38dcde524197b5897676c3ddf8c.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH7PR11MB7595:EE_
x-ms-office365-filtering-correlation-id: 4013892a-73d8-49ec-265b-08db211f12ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7gDz96GxDSzwRbl47sHb8nlOovsfyDuvWJrMcYIwX8X7ul3co7T6VvuwPet8LOql0c83ejgAgNyc0bDMSWzXg0f6cSA14hK0Yd3I2cNOY2+yi00BjptMpa/tPbSyH0PxfKW84TfWHjOvGfs8npzUJu6c1Qi8A3Kei00quNaDw6cgdl2dMy3+Xz272p8suPPs8+u/erIofL3S43zWY4bkFOaLS/gUHTDyt1GjkxSIrBlk1IAlNnwM2s1SJcArfOtTfy4MIZKun8/3iyPf7XtH9pDeUVNuShi1UDHILYNuKjjLsAaPDEfLay57JWnU7zIXr8LWGkuugFEjsLPrk4MH65CgF6Qv+WbGEnV+JegiOa/H/tOvboBkMZKfhgZwTrxXw5LD1I1UpoXNc0d36B/0aQntahzwBZVMcJ0xEpKoZ/lc8ClTB2crCy9Ow23QQng99bpVrV/DtlfWN+ffqN+x7oMVRP5urj/Ej1+AUOXt+DoBbDkXIqROyoXzyxSHH2feOKQpmsGb53tQE2enKISBd/ERli7w0m7QqAjdl1gtUn/Ci/WJ8ZKe4nZj9UNb1OroU65WIMBRL9nhMz43xmz8+IRj9H8oidpv7jXgGfLg3UE8yqZRM7luUXpkqkQVFhZhxTK4+kaJ4g3IAngJlfMfDyu95Z8K2udKjNmuKGMQCz3iOuH1E33PNXaI0z+gTRYRqQf72OBR0wtG9prWDLbMO5E8nfO5dRfv0VWiOhdKoE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(346002)(366004)(136003)(451199018)(122000001)(2906002)(36756003)(4744005)(5660300002)(7416002)(66476007)(66556008)(66446008)(66946007)(41300700001)(64756008)(8936002)(76116006)(8676002)(4326008)(91956017)(478600001)(38070700005)(316002)(38100700002)(110136005)(86362001)(54906003)(2616005)(186003)(6512007)(26005)(71200400001)(6486002)(6506007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUdESTFmY1A0dHJuTk0rWWtUakN0ZkJ1Wk5SK1UzT1RVcHdRdWRLN21pMUh0?=
 =?utf-8?B?Sll2VVp4MzRWSUczQTgzT1pKUTBSYW01VTdyQjFVVjlFeTVZemxiMHMxaVNh?=
 =?utf-8?B?Z3I4WU0veE15YmpCd005TXJQdklOdnlDS1hQSUhRZG56cTlnSnliS1RpSnQz?=
 =?utf-8?B?Y2NBaFpmRktvZURqanBIS0FjUjhOa2FaR1hzM2JvZmxDMzU2UnpMTmdpL2JU?=
 =?utf-8?B?ZUFBbkRhREZhTkF3bFN4ZjZIZWNyR3RycTBhbExxWnd0T1FSdEV6YTNtZTJu?=
 =?utf-8?B?TytPaisrK0pyVHU1L2R4ZDJNejVRZUdGZVNueWJ2bjZaNlpDdXB5cHdsMHlq?=
 =?utf-8?B?UzJxVTZnWFY4UXBDaGFuSk41bXd3NThhTHRVd0t2aUxjRmxMVW1mMENxNndP?=
 =?utf-8?B?N0Zjc0p1ZXZwT2VzQlgxN0MvYnIwbW04SWJLVXVnZkQ2Q3RxQ1VyU3FlZUlD?=
 =?utf-8?B?TU54Q2lOZXVpM2hqaUt2OWs5TFYrTTh2alpDYjdlOW8wTkhRUkx1WmtsUER6?=
 =?utf-8?B?OUFhKzV2V055OE9LQWlQTi9Ya0pPamRMdlNoZGNnNFNrZGdRWDlLcFI3UThI?=
 =?utf-8?B?dWlHbGd1N2VYZnpDYW9LN20xWjVlNitBNkxBcU1YMjVJQ1hMb1NWWXZISnlZ?=
 =?utf-8?B?MzgzQnJMVU5SYjlvZ1VuZzMvNVpXalZ1VzRiaTZPbURydTJNdWYrOHh2WWVH?=
 =?utf-8?B?SVJFeG9uY3pYSE9nYVIrdVYzYXZoZlhqdElyZXhMTDJmSHRXckVBQ0Q3Y0lz?=
 =?utf-8?B?VFlVaW9JeTdmS2xpNFBMcVdNbkMxbmxtMWxFdWU2dnkyblR1aFB4UnNUWWxj?=
 =?utf-8?B?a3d3VkxxTmR1aG1WMm9GYzhvdlBDbWpCN2gydW1zc3NkekE1VDdabEU3QndV?=
 =?utf-8?B?eXVRaU5tSGJSY0hTd0ZabmtlVGw1cnpRaHhvbGlySUtSVDZYUWp3RitGUlVj?=
 =?utf-8?B?YjlXNDJvemVhVU8yeEZ3QjEzT0o5czA0WkRnd3czUzJjU0dHc05YS2t6eUVq?=
 =?utf-8?B?OTd5d01sWmttd2RST29jZ1Jqb09XVm93L0d5VGFuc1dNT3Bma1RURWt5c3Fa?=
 =?utf-8?B?THVRQnJwbW1JaVhvb3ZTYjdjNk0xOW82bTcrT3AwL0h6NGMyd3lKOXcvOG82?=
 =?utf-8?B?QU1hNUdDMERiT0RLMXZZd2dlbEFJbFM3dW95TzloRHdVcEptS1FQSVdndnpu?=
 =?utf-8?B?YTFoTm5KUmdtSHBxUHVnNFdJK3Iyd0ZqTjZQQWFPNVJ1WkU4dmV3dHVTR1Uy?=
 =?utf-8?B?ZjUvR1pFZUFsR2tKQlZaTElVSWNNT3lIYXREdGZuR1luZ0JqOHk2K0I2eGQ1?=
 =?utf-8?B?WGxJNG1sSzZ6ZjVpV3NhR0lYY1VYMzVXQXVqc2oxOERzTVRIVGg3Y1ZPeWEr?=
 =?utf-8?B?WUhmamFQaE50Ukt4UEk5WjhSR0lid0F6VWZvcVM5OFYrMlp6UTZKYjN0ZGRB?=
 =?utf-8?B?UDR3cU5ET3Y5MFIxK3NPMmx3Vm12dEpUMkp6OTEvd0ljdUFheGdwTzl6L2tn?=
 =?utf-8?B?MDhQMkUydkwyNG9MNlVmbmJKRitzQmdXNVJwekJteVpiU0lDVisrckdMVU1m?=
 =?utf-8?B?UFpEeGpEaDVSVE54NlBIclhNYVgwc09uREZyd0tqcHdWTWZUUis0YTRtUGJY?=
 =?utf-8?B?UDVqNXZqU2pxNTZvYzJTNWgrajNaNFdzN09RendoYzJnZ3lRWWZBN2R5cHdm?=
 =?utf-8?B?RFJFVXc3TDNpNmRnWnpWWmtYM3ZaMkhoWWFCU2U2TCtFSE1HNm92WjNIbEdR?=
 =?utf-8?B?d1htOU1VT2pVR05zWDlldmFZWWd6SW9PZUZiS0laYzA0Vmd3KzNwTFpWYVJu?=
 =?utf-8?B?SFVPR0swS0s4V3RJZGhoNFdaRmVpdXJyWFNHeEY2UU9VUE52MFM4YkxDakYx?=
 =?utf-8?B?UVd6dVNFTDdOSXI5Uyt0STRxQ3NBazlDVGx1Uzg0WlVIRDBrTWlIZ0Z1b1hr?=
 =?utf-8?B?cmsxMzJhaktUNStVLzBmRWhGSVB2ZGUxaXBFZ2hla0lpVlp6QUFpRy8vYnYr?=
 =?utf-8?B?TDlTaHNhZWJxdVRZZWlobXJWc3IrVGlENGxUNkVuUThyZHBlbndGSUNISi9V?=
 =?utf-8?B?a3RHN3BZSGFxQTdiUzh3OXpVOWhPelEwYkhUa3V0VFZtd3ZTbytyYkJuUmZ1?=
 =?utf-8?B?WDBHajlkWTBsaWFZSE54U1ZTQWd2OERlSUFtZzh3eTIvS04vUlhXM3ZLR0Uv?=
 =?utf-8?Q?pKvrYzuQKXMdEpznbTh7O5g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <650D1FAB9BEBE0498C4E25A9FABBA996@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4013892a-73d8-49ec-265b-08db211f12ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 04:22:34.3563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MB1F4RhLpyXFXydW9CXznbVxf+qGbwLZJTnrkY0xdd/E3wIRhk2y9tFKprQVasHlNibASwzxfy9Lkxoab67KZNf5Z38c/0bqhBHorO36FB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7595
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTEwIGF0IDA0OjAwICswMDAwLCBBcnVuIFJhbWFkb3NzIC0gSTE3NzY5
IHdyb3RlOg0KPiBPbiBXZWQsIDIwMjMtMDMtMDggYXQgMTA6MTIgKzAxMDAsIE9sZWtzaWogUmVt
cGVsIHdyb3RlOg0KPiA+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+ID4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
ID4gDQo+ID4gQWRkIGtzel9zZXR1cF90Y19tb2RlKCkgdG8gbWFrZSBxdWV1ZSBzY2hlZHVsaW5n
IGFuZCBzaGFwaW5nDQo+ID4gY29uZmlndXJhdGlvbiBtb3JlIHZpc2libGUuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0K
PiANCj4gQWNrZWQtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNv
bQ0KPiANCg0KSWYgdGhlIGV0cyBjb21tYW5kIGlzIHN1cHBvcnRlZCBvbmx5IGluIEtTWjk0Nzcg
c2VyaWVzIG9mIHN3aXRjaCwgZG8gd2UNCm5lZWQgdG8gcmV0dXJuIE5vdCBzdXBwb3J0ZWQgZm9y
IEtTWjg3eHgvS1NaODh4eCBzd2l0Y2ggc2ltaWxhciB0byB0Yw0KY2JzIGltcGxlbWVudGF0aW9u
LiBJIGNvdWxkIGluZmVyIGZyb20gdGhlIHBhdGNoIHNldCB0aGF0LCBhbGwgdGhlDQpyZWdpc3Rl
ciBzZXQgYXJlIGZvciBLU1o5NDc3LCBzbyBpbnZva2luZyB0aGUgY29tbWFuZCBpbg0KS1NaODd4
eC9LU1o4OHh4IHdpbGwgaGF2ZSB1bmRlZmluZWQgYmVoYXZpb3VyLiBDb3JyZWN0IG1lIGlmIEkg
YW0NCndyb25nLg0KDQo=
