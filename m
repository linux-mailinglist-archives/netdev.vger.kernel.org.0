Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B382348D1CA
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 06:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiAMFMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 00:12:39 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:16440 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiAMFMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 00:12:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1642050758; x=1642655558;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1kuMu2q8SoxYTskZNz1DYXin9D+HggYcF3d19CZ79ec=;
  b=PdNxkm2vt79yd+ej5gOzAab96TDUzSn/ipGwFC6/wm/irMgGdvk+gzZc
   VJJdZn46T4ntJcaNrNyjL2pdvA7BF6jdAbhhhmQMLi/Nc1ZlUj1WxG87Q
   QEdwWwWLbnIfdE2ky96r169f5pHOi+UeTK2XF0cnqMIbUMEMgjYDbJkrf
   U=;
Received: from mail-bn1nam07lp2046.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.46])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 05:12:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAdkjr82dCzAWQAjtQNq7EyI9xYsFqH8XT55XxG41U0ZRXXsqFvN9pmrdzdjQo5Jh0RlFBJbDG6OciYSC85OuKDVo/DEML727Yvd7T1F3l+Z9DjpLbCa9u2Mi3onLWavjvFpF6sNkp9LnafxW+sPyYEizMvuudakzW4k9qf27CKLI0KNdl3vrh6Wq1He+SYOoWRvZV4WE6K8nZeEcan4xHmyeG0fQMsl+8KOwQQJrIT7XCQOhz9rm+khu/8lDKs3aA3HMuRl9iu3oCsEo5yHw9iW9P0kDXxVDT5H2K93z7ITPFByIP5Utp3zoW+gdYD8NMLyD+fGmRDe3LCf8xhRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kuMu2q8SoxYTskZNz1DYXin9D+HggYcF3d19CZ79ec=;
 b=VOTz+O1ttuur63ekxp/B22Mlgs35j6ik2l0Axhlo7gWnQ+hBWfHlw3TMztrjGeHE1CzCV+rbX3z+r5ezmuzazdwd4/S8KVI5E2C3HRaPE9wheqeh9LoWpKSWhZYyp+aPoWI5DbpoRRJRQ95IGilyd4WFRq0XjuIdqC1VLxk1x+KyI1PXa+yKdtIDGLJ3SkNYUUp7wgUa4SEq9x6mI5dix02uQeiG8Z9NjsTdWZvi9TnNvWukT12VZqpZllQbdqIUJNWXcRpCKWTubwrJdecXIoyCx7GQif0z8ABNSQ3stu4GQzMJPFT11H79rVKSQMNG+9Ys4D2VYnEhD3ailEuNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by CO1PR02MB8689.namprd02.prod.outlook.com (2603:10b6:303:160::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 05:12:34 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%6]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 05:12:34 +0000
From:   Tyler Wear <twear@quicinc.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?utf-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Subject: RE: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHYCBF+ZP8hLSSObUirLFFwasTGhaxgNl8AgAAxUjA=
Date:   Thu, 13 Jan 2022 05:12:34 +0000
Message-ID: <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
In-Reply-To: <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34e83900-c9a3-4c57-148b-08d9d6534eed
x-ms-traffictypediagnostic: CO1PR02MB8689:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <CO1PR02MB8689C1A181592FC9F233E154AA539@CO1PR02MB8689.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ORuok90LkhPLsRGoaZuL15TLT8EDKSWixgrYiRnIyC6svI3Szh9hMRghAb/rkcmfp9MGjbjkeEJ9e/z08/3xLlK+hvhNwyllLwRPNatdCfp+yNt10oShdb0aZxf9trnwV7w6ZNNW3sBXD6uV40crxjsYv3cGV9gZ//aqNJH3CDnnEui01M4CAqV1wcDAoA55OuqWTQK2cyvQYOp7DuYcHg57g0adYznH3kkkBEUEIz1BFXOY9X7W6MZhDi784u7twCL4lDWvAN287PRAv4fYVcRXGnUynLi2WQhgb+eNQhXoLR3CEqn592Pw5apQQrb5hESW0RJPZLcsStPIx8fmEeObUjGM4TAiQlgCEnaPfM5ZgE1EZaRKWgNCgd+EDK4/ShClUP4/XxwD5VE3Bd6HOJkpYifpyIk2Rknphf9E5Fsl+3OdRRjEnL7YOxqTKW1IJhfeFk/sVzZPz+O9QEV8mwrGKWa5DNagpsc613iwr2+AaQco/sftFA122CUU4Q/xHTFSGMlU90AxQE1g/o4KgSgDlvnSmhAuwMWi2HFWlitNcjUSPB2gMqi3jeEKj3A3Y03pC+N9xAOss6QeWpCryJUWX2+8riRGY8a4aixkl+o2jx9nelmHzUDlQ7E0dsccmaTnnDDHgtEPgCuNasikq/mbt5GEQWjF4e9PyuO+/ZQWyt0HLvE495hm24JlNC/J+ts6qrNUplZT+tOs7q0Rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(26005)(53546011)(6506007)(54906003)(6636002)(110136005)(316002)(71200400001)(38070700005)(52536014)(5660300002)(33656002)(83380400001)(2906002)(66574015)(4326008)(55016003)(66946007)(7696005)(508600001)(38100700002)(86362001)(122000001)(9686003)(66556008)(66476007)(8936002)(64756008)(66446008)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHc3NXQyMDdtb2NkTVZrQnA5dE1kYnZreFZYd2tMWTJPZWhrRlFPSkY0ZDhV?=
 =?utf-8?B?KzQra2ZLbm1DN2h5QkJJa0U2UjV1N2duT3RORy9laVZ5Nkpwa09yU3pZczNw?=
 =?utf-8?B?V2tBWk9LVnkxaDFYS1NnejJicFloUVdUZFp1WnNOSXIyOU8rZU1VcHBDZGZj?=
 =?utf-8?B?NlczTkp6ZENBUWJ5RE9Ha2JGV2poZUhoWFVqaW5RRlB6RzduUWhjUmNmRXNF?=
 =?utf-8?B?WEJJdktLYWN0bUsvTkdUK3pQQW9iRXUyaVFXYTNnZnJwaGppeTVxeTJSRVZP?=
 =?utf-8?B?S2c3WFYvZS9qOUVvYkF3UEdxTkVqL1dyVjltZkprYjNaeFFESEVKenlQOHB4?=
 =?utf-8?B?MkpzMHVvWE5JNFhqOXd6RldQNEZLK0JnRzF3L2l6R0Q1djI4eUdXSmMwVVpo?=
 =?utf-8?B?OTc2cXNXVUFsc240WDliRzNNRzlUQ2xvM1Y2Q1dRcTBTeE1qUFF3NHBZVmxU?=
 =?utf-8?B?aDBLZWNmSDdMWXFybkI4dms0bFpwdjNWVlJTUU5SOFovUS9iUGhaY1hPOHBW?=
 =?utf-8?B?bllhT2x2S09obE1iV25xOGtFd2dQNGFaUmV4UTFYT2J1YWV4VldESk1WbWEv?=
 =?utf-8?B?LzdtUjdkVEtJeVNjNy92WGJzQ3dmQTN3MjcwNW1kL2hoOFFvMUkzNmJlL0hi?=
 =?utf-8?B?NG9rcitBaHIrTUdOQXZheGJXN0VRYnM3dEcveHFoY29Zekh5QkdwOWNVTkMr?=
 =?utf-8?B?T2syaWlrcmJwWDRpQyt4RHF2cEJuNjNNOFB1K1JIdVlxMmtqN0V4d05jU090?=
 =?utf-8?B?aVhyVUU1RVdYV041b2RFL21sbnI4YkFrbXJvck4xSlpncm1rQ09QYWlVells?=
 =?utf-8?B?aHZtWHdtcENtUWtTa1d5amVIYUhlV3hFV3NnRndEa3ZHdUlUcGNWakQwRGlC?=
 =?utf-8?B?L2ZlMXk0Ykw1ZDc5TEx1N1pSZXNRVHFmdkExeVdBZElIRW5wZ2YyZzc4eG1t?=
 =?utf-8?B?aER4SjIyRS9xUXZLcFhYZnNBNkpQWnhFTGdqQytvTmJLR2hSV2t4R1FPNGhE?=
 =?utf-8?B?L0kydmZLaUwvNVdtcDdIV0hsYURGQ21FcndnS21TZklTTStnbUsrTWtBOUJB?=
 =?utf-8?B?K3YrcGJjQkgxbW1NZ2NlZEpwTnY5M3VPOUlXOERTU2NsZkNobWJ0S0VZdUQ3?=
 =?utf-8?B?dGc1VnhCZDNGcy9VVWM0YUtCOFhveWxYMGJTRFpqVnJ0VHV5VEJNZG5RUGli?=
 =?utf-8?B?bGQyWWtFQ3NRQTMvM0gvN1NHT3JISVZ0KzFUeHlNYVdKSG9YQTZEZk9iVmJW?=
 =?utf-8?B?elQ5Y1JvcXdxenJaOEk1Q2crRXdiVlppK2xSSUd3bFQ4bDFzSUt5TURuenRV?=
 =?utf-8?B?cVE3azJnMGxnenU0RzF0L2hVTnFudmgrR3JqUUErczVBWDEzMnQwUGw2bzVV?=
 =?utf-8?B?aHZGZTBXd1g2UGhLWlJPMmV1KzFBZURFS3NvZ0N2Z0o3NzNidVpRVnhPMDJ1?=
 =?utf-8?B?TGZkQzhlNkhSNi94UWE1ZTd3VXV4VVdvTHBZb3AxbXFVbUtrQ0c3WncwZ1U3?=
 =?utf-8?B?ZUxyejl4YW9yZUdYNml2L0RpNyt0VmpvZWxVZGhBUDJvbmsvUEtDTktwZ3A5?=
 =?utf-8?B?ZWRzcTlzQ1NWSk1zZUVCaC9MYS9HY0EzOWg0ZXBXZnFKbjNtcVhvaXM1NTZq?=
 =?utf-8?B?MFVVRE9FVDM5YXY4elJjMmZ6bWZ1MXFzc2hBVHE3OU5YVnhEazJ4Sk5QVXUy?=
 =?utf-8?B?dGxXa0diVmdudzl5Wm4yeEttUWMzUDZyT1AxK1phVDRKN1VZdTgyL0dlL1k0?=
 =?utf-8?B?S2twNmFYcHRvYVZCbUkwcXI5RGNQRkFkYXZpZUE0UHRKOFcyVVZuTEl2Nzdn?=
 =?utf-8?B?d0NZYUcxNVkxOUxKeUV6ejhtTWlHSW0wV1dNTElLS29vZjVrb3BsOE45TkFt?=
 =?utf-8?B?VmpINHcvd2U5UVgwdWhnQXBaazRQMVFZbWhDTjJhQ0lPOXk2Ny9rVkFHOW9C?=
 =?utf-8?B?aklCMHNPRStwdHl4TmVNR2Frc3lTeTZzYWQrTW5vbXE3eEF0SEkvRFQ2MVpq?=
 =?utf-8?B?WnZHY3lDMFlOMm96UlVUc3Q3WDYxUlRVWm5ZZHJvemVFWUNFT1lMMURVazVp?=
 =?utf-8?B?U0tyNUdIMEg2QXZPTHdHbk9HVzEwS2NyTjZ1VFNEMU1ZL0x6WW5Nb3luc1Q5?=
 =?utf-8?B?S29jWUdhUzJXVCsyNXk2WXhEZ0VzNFIzc1FIbkdpa3V5cGlNY1FRYTBKN0la?=
 =?utf-8?Q?qkGCUECHECft+V2Dmdu8QGA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e83900-c9a3-4c57-148b-08d9d6534eed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 05:12:34.3488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wTbkCEhCIW1A+nOdoJLKd+PJuaqIlh1cq/LBEi7HA5Vdb3lgL3eEsdi2+2oLQiL//FRYAML2wVn2a1bma7P4Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGVpIFN0YXJvdm9p
dG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEph
bnVhcnkgMTIsIDIwMjIgNjoxNCBQTQ0KPiBUbzogVHlsZXIgV2VhciAoUVVJQykgPHF1aWNfdHdl
YXJAcXVpY2luYy5jb20+DQo+IENjOiBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5r
ZXJuZWwub3JnPjsgYnBmDQo+IDxicGZAdmdlci5rZXJuZWwub3JnPjsgTWFjaWVqIMW7ZW5jenlr
b3dza2kgPG1hemVAZ29vZ2xlLmNvbT47DQo+IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+OyBN
YXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+OyBUb2tlDQo+IEjDuGlsYW5kLUrDuHJnZW5z
ZW4gPHRva2VAcmVkaGF0LmNvbT47IERhbmllbCBCb3JrbWFubg0KPiA8ZGFuaWVsQGlvZ2VhcmJv
eC5uZXQ+OyBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IGJwZi1uZXh0IHY2IDEvMl0gQWRkIHNrYl9zdG9yZV9ieXRlcygpIGZvcg0KPiBCUEZfUFJPR19U
WVBFX0NHUk9VUF9TS0INCj4gDQo+IFdBUk5JTkc6IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9t
IG91dHNpZGUgb2YgUXVhbGNvbW0uIFBsZWFzZSBiZSB3YXJ5DQo+IG9mIGFueSBsaW5rcyBvciBh
dHRhY2htZW50cywgYW5kIGRvIG5vdCBlbmFibGUgbWFjcm9zLg0KPiANCj4gT24gV2VkLCBKYW4g
MTIsIDIwMjIgYXQgNToxNSBQTSBUeWxlciBXZWFyIDxxdWljX3R3ZWFyQHF1aWNpbmMuY29tPg0K
PiB3cm90ZToNCj4gPg0KPiA+IE5lZWQgdG8gbW9kaWZ5IHRoZSBkcyBmaWVsZCB0byBzdXBwb3J0
IHVwY29taW5nIFdpZmkgUW9TIEFsbGlhbmNlIHNwZWMuDQo+ID4gSW5zdGVhZCBvZiBhZGRpbmcg
Z2VuZXJpYyBmdW5jdGlvbiBmb3IganVzdCBtb2RpZnlpbmcgdGhlIGRzIGZpZWxkLA0KPiA+IGFk
ZCBza2Jfc3RvcmVfYnl0ZXMgZm9yIEJQRl9QUk9HX1RZUEVfQ0dST1VQX1NLQi4NCj4gPiBUaGlz
IGFsbG93cyBvdGhlciBmaWVsZHMgaW4gdGhlIG5ldHdvcmsgYW5kIHRyYW5zcG9ydCBoZWFkZXIg
dG8gYmUNCj4gPiBtb2RpZmllZCBpbiB0aGUgZnV0dXJlLg0KPiA+DQo+ID4gQ2hlY2tzdW0gQVBJ
J3MgYWxzbyBuZWVkIHRvIGJlIGFkZGVkIGZvciBjb21wbGV0ZW5lc3MuDQo+ID4NCj4gPiBJdCBp
cyBub3QgcG9zc2libGUgdG8gdXNlIENHUk9VUF8oU0VUfEdFVClTT0NLT1BUIHNpbmNlIHRoZSBw
b2xpY3kgbWF5DQo+ID4gY2hhbmdlIGR1cmluZyBydW50aW1lIGFuZCB3b3VsZCByZXN1bHQgaW4g
YSBsYXJnZSBudW1iZXIgb2YgZW50cmllcw0KPiA+IHdpdGggd2lsZGNhcmRzLg0KPiA+DQo+ID4g
VjQgcGF0Y2ggZml4ZXMgd2FybmluZ3MgYW5kIGVycm9ycyBmcm9tIGNoZWNrcGF0Y2guDQo+ID4N
Cj4gPiBUaGUgZXhpc3RpbmcgY2hlY2sgZm9yIGJwZl90cnlfbWFrZV93cml0YWJsZSgpIHNob3Vs
ZCBtZWFuIHRoYXQNCj4gPiBza2Jfc2hhcmVfY2hlY2soKSBpcyBub3QgbmVlZGVkLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogVHlsZXIgV2VhciA8cXVpY190d2VhckBxdWljaW5jLmNvbT4NCj4g
PiAtLS0NCj4gPiAgbmV0L2NvcmUvZmlsdGVyLmMgfCAxMiArKysrKysrKysrKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9uZXQv
Y29yZS9maWx0ZXIuYyBiL25ldC9jb3JlL2ZpbHRlci5jIGluZGV4DQo+ID4gNjEwMmYwOTNkNTlh
Li5mMzBkOTM5Y2I0Y2YgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2NvcmUvZmlsdGVyLmMNCj4gPiAr
KysgYi9uZXQvY29yZS9maWx0ZXIuYw0KPiA+IEBAIC03Mjk5LDYgKzcyOTksMTggQEAgY2dfc2ti
X2Z1bmNfcHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLA0KPiBjb25zdCBzdHJ1Y3QgYnBm
X3Byb2cgKnByb2cpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAmYnBmX3NrX3N0b3JhZ2Vf
ZGVsZXRlX3Byb3RvOw0KPiA+ICAgICAgICAgY2FzZSBCUEZfRlVOQ19wZXJmX2V2ZW50X291dHB1
dDoNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuICZicGZfc2tiX2V2ZW50X291dHB1dF9wcm90
bzsNCj4gPiArICAgICAgIGNhc2UgQlBGX0ZVTkNfc2tiX3N0b3JlX2J5dGVzOg0KPiA+ICsgICAg
ICAgICAgICAgICByZXR1cm4gJmJwZl9za2Jfc3RvcmVfYnl0ZXNfcHJvdG87DQo+ID4gKyAgICAg
ICBjYXNlIEJQRl9GVU5DX2NzdW1fdXBkYXRlOg0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4g
JmJwZl9jc3VtX3VwZGF0ZV9wcm90bzsNCj4gPiArICAgICAgIGNhc2UgQlBGX0ZVTkNfY3N1bV9s
ZXZlbDoNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuICZicGZfY3N1bV9sZXZlbF9wcm90bzsN
Cj4gPiArICAgICAgIGNhc2UgQlBGX0ZVTkNfbDNfY3N1bV9yZXBsYWNlOg0KPiA+ICsgICAgICAg
ICAgICAgICByZXR1cm4gJmJwZl9sM19jc3VtX3JlcGxhY2VfcHJvdG87DQo+ID4gKyAgICAgICBj
YXNlIEJQRl9GVU5DX2w0X2NzdW1fcmVwbGFjZToNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJu
ICZicGZfbDRfY3N1bV9yZXBsYWNlX3Byb3RvOw0KPiA+ICsgICAgICAgY2FzZSBCUEZfRlVOQ19j
c3VtX2RpZmY6DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAmYnBmX2NzdW1fZGlmZl9wcm90
bzsNCj4gDQo+IFRoaXMgaXMgd3JvbmcuDQo+IENHUk9VUF9JTkVUX0VHUkVTUyBicGYgcHJvZyBj
YW5ub3QgYXJiaXRyYXJ5IGNoYW5nZSBwYWNrZXQgZGF0YS4NCj4gVGhlIG5ldHdvcmtpbmcgc3Rh
Y2sgcG9wdWxhdGVkIHRoZSBJUCBoZWFkZXIgYXQgdGhhdCBwb2ludC4NCj4gSWYgdGhlIHByb2cg
Y2hhbmdlcyBpdCB0byBzb21ldGhpbmcgZWxzZSBpdCB3aWxsIGJlIGNvbmZ1c2luZyBvdGhlciBs
YXllcnMgb2YNCj4gc3RhY2suIG5laWdoKEwyKSB3aWxsIGJlIHdyb25nLCBldGMuDQo+IFdlIGNh
biBzdGlsbCBjaGFuZ2UgY2VydGFpbiB0aGluZ3MgaW4gdGhlIHBhY2tldCwgYnV0IG5vdCBhcmJp
dHJhcnkgYnl0ZXMuDQo+IA0KPiBXZSBjYW5ub3QgY2hhbmdlIHRoZSBEUyBmaWVsZCBkaXJlY3Rs
eSBpbiB0aGUgcGFja2V0IGVpdGhlci4NCj4gSXQgY2FuIG9ubHkgYmUgY2hhbmdlZCBieSBjaGFu
Z2luZyBpdHMgdmFsdWUgaW4gdGhlIHNvY2tldC4NCg0KV2h5IGlzIHRoZSBEUyBmaWVsZCB1bmNo
YW5nZWFibGUsIGJ1dCBlY24gaXMgY2hhbmdlYWJsZT8NCg0KPiANCj4gVEMgbGF5ZXIgaXMgd2hl
cmUgcGFja2V0IG1vZGlmaWNhdGlvbnMgYXJlIGFsbG93ZWQuDQo=
