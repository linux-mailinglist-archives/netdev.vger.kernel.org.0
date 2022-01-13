Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD2648DD22
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiAMRt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:49:58 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:55782 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbiAMRt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:49:57 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DCYjcs020776;
        Thu, 13 Jan 2022 12:49:46 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2050.outbound.protection.outlook.com [104.47.60.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2gmc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:49:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/Ak3ct5/sE2jsXIvNbJmICFs9Q+yNAJhLqafhpQ6hVudiWRgkfB+Jmv0QzicHEbP8nFB4XxnS0EywJi7bLeF2ouNxlg0eCY305D82GLDNJ2u3wvVxN+oUWwcSaWtMMSzbGEbtKBH1jDRXP54YadaJnnlKNRV5L5LscaXEd2C3bXdMpQ+WFVULKhDOdCj8mxZ/xMUbxPGPPCuJ9O6z47JHFK9sl6LPhD/CswEJglm4Dp3ovmrfpYDLUpm57iuPRC140nPvKPhLFbdi8nlR6/OulMpR3PWswNh+cZ00iNUwMMibov0zSccuYa56JAi/N6Ax51r/KWvq0GrKUveTCpdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdOXzGwJSNmqgLFQkvj5+IbrlHWDsbuj2pL7Is+jscQ=;
 b=OfAFajbEce4fp3jyDL3eNDOgcYY4bp4r5OUvupnI4C4Jw7x7jDqJChgD+gUusXvCHPjhAMgl5BAiGXmYNjebJwWiQ00SIbBvTggjRsJWjhs9Nz1hv2x3agvbyaj9ZtP6sdpsScM9kBhsV/H/IkiTRX3yud5ENQ5X2FVhiIfxJvo0SjEzDFsesrMNJ/FoeBhFMg/po7k/c0L9Z6ivw+55u+NViXsju4C9C0AkB3EK6t/EHLCqS9t3v2IPzl5mYe7TOMVBzo5orBJAxLt8hXwJpdOlL8QRtvh/eKEkrUpk26QHJrjkq8ekviJxBROLUvBxgXvub9Z8a5Iu3aLVSkwnFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdOXzGwJSNmqgLFQkvj5+IbrlHWDsbuj2pL7Is+jscQ=;
 b=2NYiYM3Uw+Pb6ZhBX5OzlbAVktMiPkGasqESFDFRWcTXN413FGoe3+8o0ukU9Ekt5gs0yRJYVb0fpaYRnhfeh9MN4g8vehO3CsZd2wcc6wAsHPRymV4Iaq2f9t9juGpxRh0Gbq14flCzv4M6oKA8yZy8VWmgQNjQXe8INZ/XwAc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB4400.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:34::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 17:49:44 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:49:44 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "geert@linux-m68k.org" <geert@linux-m68k.org>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>
Subject: Re: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and
 reset mappings for ZynqMP
Thread-Topic: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and
 reset mappings for ZynqMP
Thread-Index: AQHYB+AFnpyx9QceS0yLrcrcPty5NqxgjbIAgACZS4CAABODgIAAAaUA
Date:   Thu, 13 Jan 2022 17:49:44 +0000
Message-ID: <4bbacb62e1469331aded1e73a82358e18cbd77b7.camel@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
         <20220112181113.875567-2-robert.hancock@calian.com>
         <d5952271-a90f-4794-0087-9781d2258e17@xilinx.com>
         <b8612073ebd24e4bf9f4e729bd5ea7c4678494e2.camel@calian.com>
         <CAMuHMdUyBF5XkoVVK9zrWf6f7cP+jEBC-dW_APfw_a=upqpDhQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUyBF5XkoVVK9zrWf6f7cP+jEBC-dW_APfw_a=upqpDhQ@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a70784c-fe8e-4d0e-ec6e-08d9d6bd1587
x-ms-traffictypediagnostic: YT2PR01MB4400:EE_
x-microsoft-antispam-prvs: <YT2PR01MB440076150C4EDFA06259B95DEC539@YT2PR01MB4400.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /GrkGamrd4eB6GopEv4y9xKyrtRSXrA8gENDMa8+VQepD/oh76CZM2vzb2pqmVkJskN70RlS8E6S0F6XBVMsSBGhV7Tku1LbPXNKfKOIG9zHZFSF4zC6PNGNayJKcyFm7wbFRJpkyaHy1ZkH7eI7oIw/7DmkWBUU+ic7VSyS5rr9x179crG9h0fr3V/P6W7rRR0ZUK5vxhrJn2U26w1o8FHliR0IYA2D4BQTAk4kyQKl4RSf4NI3EdBvMpOQWdHW6f2SvvsKlRw2Q8uxc6prLoheyGj5q+4FFKNSwSuYz73ka/UtW/oNgwgj8/5GE0kqc+Fvjd3hmII09JcmoysDBRVr3hl3Het/JfhHodYrxctrtRmsPUbhspqJBHVATyiE+4oMDAKfM+KR+iTOP12LZ2cm7Ua6SNAZ52E18dkRy4o+P4Kp5jnliGXsK2bTK7wp7jjxfS6EdFMH7doUE51DzIhsxPPRc17f4KozriGIlvKeurb0GQn0bfpASncrphnRekM4GE3hk1YCOtmbg5PO1Na+a2RzW1Q+tZClfbJ0rADODtx50Y4Iq7mybmfeH5sWSki288rhLA51tamYDFN/LFhJdQkfxump64tPiA+hRacxiRsJR2aLh9edApigTAbqHUoZfEH0OEtj7wXCTvfnzY5lzJ6ICk8RamkUsSvzV+baYwmYiqPxgQbpff79tphFPRHe1wZWfOX67FYMG2T0ruumD4hXtYcAR7oH8RphQfxACppriBy38FG5hMESa4C/iewp523YFcZlWTOtC90Rg5HR3o/rOp+hTfQyMKqeKgfNew96GAbOwVtc7MRcb+catqUBQ8Uhym0fKIR+LHXrEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2906002)(44832011)(36756003)(26005)(4326008)(38070700005)(2616005)(76116006)(91956017)(83380400001)(71200400001)(6916009)(8936002)(66446008)(86362001)(54906003)(8676002)(966005)(6506007)(53546011)(508600001)(6512007)(6486002)(5660300002)(122000001)(38100700002)(66556008)(316002)(66476007)(64756008)(7416002)(66946007)(99106002)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bllQaitKbi9Xb2gxckE3WDZ6VTcyMXNFMWpoMnZ5RytBeGI4bkVzV0hnWlow?=
 =?utf-8?B?U3NPdmhRcmhlcEpRejlOWUo0aWttd3hwNTFlMHVMYmxmeUoxZ1l0Z3JLU0sv?=
 =?utf-8?B?STcrNERzZ2x5d3VvOE9CTVZwSEFjRFJyVzFOYzlwYnl1MWllem0rd2xPQzUy?=
 =?utf-8?B?aVdWS21KWUlkSWNTZ21iOGNmZTZSM3NvcDhYT3ZIMGdHbXNqU3ZjbGJ4ejNO?=
 =?utf-8?B?UDhjT00rUHpXaFM2R0FpNzlJd0EvK3c0SUVhTEs2NFRRL1E5Y0UzVzNBaStk?=
 =?utf-8?B?ajJkRkdEWkRENE1TeUpDbThIK05WaDRZYW9mLzZoOVVQSS9jdXpvbVJQT1Yw?=
 =?utf-8?B?aEl1QVBUYVRhWm9EbTZNZFNpNTYvMzhHNmNlb0JQWkttZ2lZWVBmSithZ0lD?=
 =?utf-8?B?T0JlYm9FNUs2bTNPcWlZd3NsN0dTZ05Za0dOZm9UMU4xdis2bSs0SkxIYjE5?=
 =?utf-8?B?SnlYNjA3VDZ6eDIrbmZENHhPQWRQSUFDN09Sbi9OcndsRnBEOTZtMkVxbCtp?=
 =?utf-8?B?eDhWcGRDbFdVYVZtWUlsZVRIYTdjRTg0VVR2eS9PelJ6bGdkU0RoeGhTNWRR?=
 =?utf-8?B?RW0vYk9pU1crVVF0WWwyUzI5VDdjN1cycDVYZmx2K0hTYVdSQ3JITlYwZUVx?=
 =?utf-8?B?Y2wvb2VIbnExdU1tRlNZL0ZYVk9pS3hWMU5qQTk2QmgyeHZuSVNjNlZnc1NG?=
 =?utf-8?B?MWQvcGNLTTFsRk5QR1VRczR4eUo4UmoxbnYybnNJNlFnQ2V5NVdOVkxJVlB6?=
 =?utf-8?B?Qk9QUDNHZzlrLzF0UU1lSFNSZkJLcUdlVVdyVzE1Q3g0ZFd4RHk3ajhoQ3Z0?=
 =?utf-8?B?czNvdmVPQjY0cUNuaWFuaW1PeGt2RUwxY2o0VjZTSDNYUXQ4K2lUQjV6KzBh?=
 =?utf-8?B?KytUUUc4b0trZFZEYTBuOUlUK3d0UGY4dFg1TStLbGtJc0pVNU5hckZoeDRD?=
 =?utf-8?B?NXhRZXNMeUpaWExsdGRrbGJlYTE2UmYwVjVlMHUrZVhSWHJ4b1J0bk1kUDQ3?=
 =?utf-8?B?NjRtWXIxd2hDS2FnWVA2bUZaek53cGZnLyt6V2plY2t1dnZKbHFwOWNTTUNZ?=
 =?utf-8?B?SGVJZHUxMWZmdzdFMEFaRW1tT2R6dS9OVmx2NjJ5MW1qS0s3anNNc0pyWDZH?=
 =?utf-8?B?UVhEa1ZOZGVnUFJUZ3BkSkVmQk9NTEhDbFBUSHVzdUtCWWE5d0ZHbmlma1ln?=
 =?utf-8?B?eEhQQUtocHV4MVFvblJKQjFUTmtlNFIzR05qdEF0VmR4U0QrZEJqWEJXRTJu?=
 =?utf-8?B?UW12cUM5TExjQWJSb0YvU1N5TGdWU2NRckRpdGxsdTlQR29RcWtZU3RSeEVY?=
 =?utf-8?B?WkhQQUpaUlBjbkdqbzZuRWFEajB2VGpNdE9RWGJ4ZE9OdkdpR25DQVVRNzBO?=
 =?utf-8?B?TWk3d3J6MnZxdk5STUl6SjN2VUU4cGw2cWRuODllcXRQUUs4bWlqVUNCOTRx?=
 =?utf-8?B?UWo2T0pydUZwOW0ySmVncXIxSVhkV1grVlAvNW02NW5hdEhsQ2ZiYWYwSWZq?=
 =?utf-8?B?MHNKelcrNTY2MHYvL1BWOWNDbEl4WkN1Zy9QSDUzR2ZZdERlcmtyZ21GUTd1?=
 =?utf-8?B?MndsY3BSTWdza1VyclE4YWVuckJldU9Jem1VNDcweEFYRDFRcFU4LysxcjQz?=
 =?utf-8?B?WWcxMlUxQkw4aEl5R2QxMHY2K3ZjMHI0bmx2QTR3UkdPM3BSSTZsNUsvbk81?=
 =?utf-8?B?b1RrTTFCclRESVRyS1EzbEp6Zlk2YkF2alByNytmZ1R6YnhTVWQ5WmIrd01Q?=
 =?utf-8?B?WjFZRTQ3NXhxZGpyNkJKSXFtblpvMkF1TWRFMUJGWUdNaDVpSWt3dDVGbWo0?=
 =?utf-8?B?R2ZKSFZFKzZkUWhQYkVzK3pGM2pkb1FVbEFrem1KSlpoOU95M3lPdHFsL0JW?=
 =?utf-8?B?SUZrRHRrV1ZZSDBvRGZHb1VSQ3RUWVVjdUFUS09LOEFXTnBnemhYMDZ2ZmdK?=
 =?utf-8?B?MUk3Z0UxZGVBWFhrb3YzOHZuL0ttYitUdHphT2h5cUprYjlMaEZGd0tjSzFk?=
 =?utf-8?B?d2hBcmd1UTZJWUFtT0tLN1Y2ZmQ2dmVDbmtWMno5Qks1Q0ZFTEtCRVVuZWdZ?=
 =?utf-8?B?NUd3YUlWRGlHaW5HVXpIQXlSdDRTY1h6ZVNweURWMDFVMzAyS05iOUVCZDlU?=
 =?utf-8?B?eGNaKzVGUUxiTFBIVzlhUmwySE9Ka1dBbEtCUC82Q1hCcVEwdUlnK1pmTFhn?=
 =?utf-8?B?Y2xtNVcyN3c2b1VxV3dSZ0lHN0hlYWJhYU5NNVpwcVJKcVludHVHa1RhWnJR?=
 =?utf-8?Q?i5mGomYBJCyR7hgFF1fjXnUcoQ0PBjDJZ7zprhi4yw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7060D522C72E41468B46172D396C21C2@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a70784c-fe8e-4d0e-ec6e-08d9d6bd1587
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:49:44.7547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnYmarkN80xmw6TeiXq8tGZCtVjh8knjyzmQ6N7zUdmM83ktsKS1UCOBmvtNbJHxFzC10S/MbtENxrG2eaSrJeb2FUcKP19NfW5MGCaceCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4400
X-Proofpoint-GUID: fNTZw_oqRkn7sUynpz8DM9p6V04Kb5T2
X-Proofpoint-ORIG-GUID: fNTZw_oqRkn7sUynpz8DM9p6V04Kb5T2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTEzIGF0IDE4OjQzICswMTAwLCBHZWVydCBVeXR0ZXJob2V2ZW4gd3Jv
dGU6DQo+IEhpIFJvYmVydCwNCj4gDQo+IE9uIFRodSwgSmFuIDEzLCAyMDIyIGF0IDU6MzQgUE0g
Um9iZXJ0IEhhbmNvY2sNCj4gPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+IHdyb3RlOg0KPiA+
IE9uIFRodSwgMjAyMi0wMS0xMyBhdCAwODoyNSArMDEwMCwgTWljaGFsIFNpbWVrIHdyb3RlOg0K
PiA+ID4gT24gMS8xMi8yMiAxOToxMSwgUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+ID4gPiA+IFVw
ZGF0ZWQgbWFjYiBEVCBiaW5kaW5nIGRvY3VtZW50YXRpb24gdG8gcmVmbGVjdCB0aGUgcGh5LW5h
bWVzLCBwaHlzLA0KPiA+ID4gPiByZXNldHMsIHJlc2V0LW5hbWVzIHByb3BlcnRpZXMgd2hpY2gg
YXJlIG5vdyB1c2VkIHdpdGggWnlucU1QIEdFTQ0KPiA+ID4gPiBkZXZpY2VzLCBhbmQgYWRkZWQg
YSBaeW5xTVAtc3BlY2lmaWMgRFQgZXhhbXBsZS4NCj4gPiA+ID4gDQo+ID4gPiA+IFNpZ25lZC1v
ZmYtYnk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+ID4g
PiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21hY2IudHh0DQo+
ID4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFjYi50
eHQNCj4gPiA+IEdlZXJ0IGFscmVhZHkgY29udmVydGVkIHRoaXMgZmlsZSB0byB5YW1sIHRoYXQn
cyB3aHkgeW91IHNob3VsZCB0YXJnZXQNCj4gPiA+IHRoaXMNCj4gPiA+IHZlcnNpb24uDQo+ID4g
DQo+ID4gSXMgdGhhdCB2ZXJzaW9uIGluIGEgdHJlZSBzb21ld2hlcmUgdGhhdCBjYW4gYmUgcGF0
Y2hlZCBhZ2FpbnN0Pw0KPiANCj4gSXQgaGFzIGp1c3QgZW50ZXJlZCB1cHN0cmVhbSwgYW5kIHdp
bGwgYmUgcGFydCBvZiB2NS4xNy1yYzE6DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19o
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9s
aW51eC5naXQvY29tbWl0Lz9pZD00ZTViNmRlMWY0NmQwZWEwX187ISFJT0dvczBrIXlSYm1jREVh
QzJPZ29aQUs5aHlnLUZVSWtJY1lnNkpLcU5GN3kwVHl3LWZiblh2S0FJUnNjY045SzVpR0Raa2hU
a28kIA0KPiANCg0KQWgsIEkgc2VlLCBpdCB3ZW50IGluIHRocm91Z2ggdGhlIGRldmljZXRyZWUg
dHJlZSBzbyBpdCdzIG5vdCBpbiBuZXQtbmV4dCB5ZXQuDQpTaG91bGQgYmUgYWJsZSB0byBwaWNr
IHRoYXQgY2hhbmdlIHVwIG9uY2UgdGhlIG1lcmdlIHdpbmRvdyBjbG9zZXMgYW5kIHVwZGF0ZQ0K
dGhlIHBhdGNoIGFjY29yZGluZ2x5Lg0KDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgR2VlcnQNCj4gDQo+IC0tDQo+IEdlZXJ0IFV5dHRlcmhvZXZl
biAtLSBUaGVyZSdzIGxvdHMgb2YgTGludXggYmV5b25kIGlhMzIgLS0gDQo+IGdlZXJ0QGxpbnV4
LW02OGsub3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2Fs
IHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0DQo+IHdoZW4gSSdtIHRhbGtpbmcg
dG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nIGxpa2UN
Cj4gdGhhdC4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2
YWxkcw0K
