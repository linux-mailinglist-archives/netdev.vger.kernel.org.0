Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78BD2D58A2
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389119AbgLJKx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:53:29 -0500
Received: from mail-eopbgr00053.outbound.protection.outlook.com ([40.107.0.53]:27879
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388672AbgLJKxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 05:53:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA0+EdL9pdZztXaoX/RBFSALa0lrugn+O6SwdfJ6jJVGMlFgfwhiyEQk8qq/JE6Cmc9VS7sNN5p8inEThOl9hPGPf1duqlebYxPZUzZ7EsEZrtBmVhlS0GGsNEQ0hwOX5GuCVwaupe6fiznXO6p3gl4Y/RVnRP3B/267TozZuUSYEVDlCqCw1kjiB2JNTo/dliN+RGi7heHDrJIW1KmHqnFNu0FnoNgM4FrPaHtjQwjtRl4XQUdK/qFqpFgdL0HZw/qVlbdw/Ab5qQytmgxo3YoXqP/QwgaGoFcTv+D6+tM3ie7PlZedt3W0gFzFPjTWubumllSCxeOjlXvGWIbLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO5oNVz2pKTrx3MMj8LeLrL0HeYf37Fp4B4brLBkEwk=;
 b=MXxV/8kM10auqWUXbx7uBc2zstsf88ObwsV9UdykLVWYp3c1yF8LUKJdQN6A7aPeH0eMZXOmZ52+ZN6FE8ON7Oy2kPqsmh73Y8tWjkGt0c4Re8tqNCdADyTbtbDIKhJ4mYrHnAqWJ4ynup5EIBUEby2kVf8Vp0Ium+WrkpNhkkhr7iEXUDDOQESyIq5+59W214lS/t8QRuSdBWuow50GGKqV27cZbEjd1GCo3a8tO7K4ee0BGSIwy/W3NsS+ukkUOlN0ObCwqYbe+MfvAOygka3lOdQJil+wlyf9jxrKWCH7DmFM8V7N+2Dje1IKxAlYsEfT26UaA8p3iVGkS5axpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO5oNVz2pKTrx3MMj8LeLrL0HeYf37Fp4B4brLBkEwk=;
 b=NseQMh6DXQOrdcUVY3IQe4JYYdCYnkV3UTrC0DG+h9ZP+RJ4ewEsqZcy67uUJaWKi8WGR7pB6qm5FKUxw8FuLG/etLDH9yiHOKiixNFXfBEnmNwARB+bp2UhoNSsHwlrcgFFJiF3zh5jcGAa2k26Xy8NYs8I08tCFr2YXxIVQ3E=
Received: from HE1PR0701MB2299.eurprd07.prod.outlook.com (2603:10a6:3:6c::8)
 by HE1PR07MB3178.eurprd07.prod.outlook.com (2603:10a6:7:31::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.8; Thu, 10 Dec
 2020 10:52:27 +0000
Received: from HE1PR0701MB2299.eurprd07.prod.outlook.com
 ([fe80::6898:c00e:a986:6131]) by HE1PR0701MB2299.eurprd07.prod.outlook.com
 ([fe80::6898:c00e:a986:6131%2]) with mapi id 15.20.3654.012; Thu, 10 Dec 2020
 10:52:27 +0000
From:   Ingemar Johansson S <ingemar.s.johansson@ericsson.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>
Subject: RE: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral where we
 send nothing
Thread-Topic: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral where we
 send nothing
Thread-Index: AQHWzd+AavC1J4zlxkKZQAsxe8qDaKnvdvyAgACeraCAABFCgIAAAjdg
Date:   Thu, 10 Dec 2020 10:52:26 +0000
Message-ID: <HE1PR0701MB22992D932301DC559B8A4D46C2CB0@HE1PR0701MB2299.eurprd07.prod.outlook.com>
References: <20201209035759.1225145-1-ncardwell.kernel@gmail.com>
 <20201209161403.47177093@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <HE1PR0701MB229928A122B9AAF4EF66322AC2CB0@HE1PR0701MB2299.eurprd07.prod.outlook.com>
 <944d0a94-1ec1-539b-a463-b762ebf5ed8f@gmail.com>
In-Reply-To: <944d0a94-1ec1-539b-a463-b762ebf5ed8f@gmail.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=ericsson.com;
x-originating-ip: [83.227.122.88]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a668c568-4cad-4d0d-07c5-08d89cf9af11
x-ms-traffictypediagnostic: HE1PR07MB3178:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR07MB31789A2C5F06927090A0A1C8C2CB0@HE1PR07MB3178.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XLhIP80lCqbvLEC56pRWVMLtlHsJAJqPAkXw65S+1WV+hVnBSbg/rWggNpCJqdL6iogg+CtwGeIUZIBQrMB8xd8HJpGz/NPjLdC3IhkcQLLJ4prB1J/OQyCJe0U59zjBlOkOx3KfJmgU/UjBpBIEWsx4fq0EpUD96B75bUJwrSQwRu5HCsIyfMBWMZ26sUV9EYRuvSLFzugjJi0SUDCyS5roaCSoUAboaW5Kjo7dwoKizFap4R/Zp+ZvE94syFvbGO3YTJv6tPqqDrq3YhdICcKnlifV+pvA3+U2mIdimGLp8BDysC1sI2CSyNRXe7f0ILdm8siJpwiNZ6ZVEc+3vGGrgW1yN7ODPOY4InsapncK57Mr/Vz5ye7ut9Q4JQwlANRDN3+G0uyP9tLW7c7UsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0701MB2299.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(66556008)(6506007)(33656002)(71200400001)(54906003)(7696005)(2906002)(110136005)(99936003)(86362001)(55016002)(66946007)(186003)(107886003)(8676002)(9686003)(83380400001)(26005)(5660300002)(4326008)(8936002)(76116006)(52536014)(66476007)(66446008)(66616009)(508600001)(64756008)(53546011)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?alBLZUdZQTRXRkprVzNCUVBjVTUreURoV0hLemRwYUc2Um5rQnpIWFBDQWlQ?=
 =?utf-8?B?eEx5bWlGdUFKZkNqcFo1bDFRK2ZpSmNJbWEyQ3FPOUl6RkZQMFVZK1Z1dktL?=
 =?utf-8?B?U1o5MzVhQ2Y3QWVEK3F2bWZvVG90T2Ntb1VEd2tlRm5DdndPdmk4dnNGVjZG?=
 =?utf-8?B?ZWpzbEQ5SnJDTTJkanJZM0ZGTzFqZGp0dGNFaTJncnR0bFJQam0xQnU4b1BU?=
 =?utf-8?B?U29aOGI0VGJ3dDdTOUM3Qk42eDZoREdFMEptUmNSVjUvTklMTzlBRHNPckNJ?=
 =?utf-8?B?dzZOSU1adjlwK3VDY09SOXhzMVlDbEwvSFNVVXo3OUdSL0VUcEtiWWdnczRS?=
 =?utf-8?B?cG45QjZGSFByVkc3YktKY0ZlcVY2MmRDLy9rRTFJMWd2dk4zK2hHeDlOWE85?=
 =?utf-8?B?dzc5c1NtZkZaZWkvVGczUk16QkpETzBwKytpVGJHL2hCZ1hPam04SE1RWDhU?=
 =?utf-8?B?aENBSDhxM3JHWGJFUituU295YVl4Q1JtT2hTekQwdk1iRlh6bG9hNTZwQmxa?=
 =?utf-8?B?TjkwNGpTbFlzZTJPNlJ0QzRJYUlqUDhNR3FBOFhwbXh5UktqbzcwRzd4eWVs?=
 =?utf-8?B?NTljbE1PWi9CRktnbjdDNnJ2Q1RqWVAwSU1zZmJKZnVDelQ5TEZLTEpmSnBw?=
 =?utf-8?B?VUFYYTVqelZBaTczRGFYNmIzUDF2WG5QQ1ZQd1pkTGhadDEzRGE5ZHJGaVVz?=
 =?utf-8?B?OHE5RUVFelhya05uUzB5Q3FyTUFuS2xZZ01zOExsMXlGMmV0WnFwKzUvN25S?=
 =?utf-8?B?bG9tZ3YwK1JyeXd3SmpJelljR3NpSU9EcG5QMHVGbU93bnpXeFlPTFFTLzFm?=
 =?utf-8?B?VlJhc1kydTgvVmJQbkFrNmFzYmc2OU9pcndOTGZQN0lFb3JZdTIwNGxWclpz?=
 =?utf-8?B?Vk5LcFV5a3JYalZhSVBrSWNheUFpNm5KN2JBU1doS09VUk9qRXlzTTlzS1NG?=
 =?utf-8?B?UkFRUkx5elNYVlhiMmhUQTgrSTdXMmdWVTUrNFBoY2hhaHh3bGoyUEU0eW1C?=
 =?utf-8?B?T0JIaHJ4MWlBZ1Z2bHZHem1HZGRxS0swNFVxRWEyQ042c2U4c0doQklNZE9J?=
 =?utf-8?B?UmVibm5reW5teHlyWW92L3N2cG1MbnZKcFRDZWJXbUk5VlhMMWp0dVVMRSto?=
 =?utf-8?B?bWJYNnc4WWRWUWRsMnljL2dxSmNwR3drU2Z6Y3h4dktGY3hBMmdRRmluTW9v?=
 =?utf-8?B?cEtoeDI1ZkZuMHNSWGhCMG1WQnB4dnNyZlNhK0Q5T1hRNlRzbWNFRUxobDI2?=
 =?utf-8?B?aFFvNjUxM25ocklqUGplRmZmbzNpU1NhNXRaa2EwT1FRT3NhdVhScWdMb1d6?=
 =?utf-8?Q?/eaDO+f8Qqkjk=3D?=
Content-Type: multipart/signed;
        protocol="application/x-pkcs7-signature";
        micalg=SHA1;
        boundary="----=_NextPart_000_0819_01D6CEEA.ED7427D0"
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0701MB2299.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a668c568-4cad-4d0d-07c5-08d89cf9af11
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 10:52:26.9774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gL6W7QTFcJ/hA1Pt5MmONFbNhCARAwmvYSGDazWI3ruXLBNSg6MNPYpkYJB1hnnRQHTu9KU54rLaKl6MGBdHUEvtD9IXN2uZrtFshNs5cT7FkMQraYUMfveNOSJll3Lj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB3178
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

------=_NextPart_000_0819_01D6CEEA.ED7427D0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Obviously my memory needs a backup =F0=9F=98=8A

Thanks
/Ingemar

> -----Original Message-----
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Sent: den 10 december 2020 11:44
> To: Ingemar Johansson S <ingemar.s.johansson@ericsson.com>; Jakub =
Kicinski
> <kuba@kernel.org>; Neal Cardwell <ncardwell.kernel@gmail.com>
> Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org; Neal
> Cardwell <ncardwell@google.com>; Yuchung Cheng <ycheng@google.com>;
> Soheil Hassas Yeganeh <soheil@google.com>; Eric Dumazet
> <edumazet@google.com>
> Subject: Re: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral =
where we
> send nothing
>=20
>=20
>=20
> On 12/10/20 10:50 AM, Ingemar Johansson S wrote:
> > Hi
> > Slighty off topic
> > It is a smaller mystery why I am listed as having reported this =
artifact ?.
> > I don't have any memory that I did so.. strange =F0=9F=98=90.
> >
>=20
> I think this was your report :
>=20
> =
https://mailarchive.ietf.org/arch/msg/tcpm/3U--r1vC81blOfZ5JwAYWIbm4vE/
>=20
> Have fun !
>=20
> > Regards
> > Ingemar
> >
> >> -----Original Message-----
> >> From: Jakub Kicinski <kuba@kernel.org>
> >> Sent: den 10 december 2020 01:14
> >> To: Neal Cardwell <ncardwell.kernel@gmail.com>
> >> Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org; =
Neal
> >> Cardwell <ncardwell@google.com>; Ingemar Johansson S
> >> <ingemar.s.johansson@ericsson.com>; Yuchung Cheng
> >> <ycheng@google.com>; Soheil Hassas Yeganeh <soheil@google.com>; =
Eric
> >> Dumazet <edumazet@google.com>
> >> Subject: Re: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral =
where
> we
> >> send nothing
> >>
> >> On Tue,  8 Dec 2020 22:57:59 -0500 Neal Cardwell wrote:
> >>> From: Neal Cardwell <ncardwell@google.com>
> >>>
> >>> When cwnd is not a multiple of the TSO skb size of N*MSS, we can =
get
> >>> into persistent scenarios where we have the following sequence:
> >>>
> >>> (1) ACK for full-sized skb of N*MSS arrives
> >>>   -> tcp_write_xmit() transmit full-sized skb with N*MSS
> >>>   -> move pacing release time forward
> >>>   -> exit tcp_write_xmit() because pacing time is in the future
> >>>
> >>> (2) TSQ callback or TCP internal pacing timer fires
> >>>   -> try to transmit next skb, but TSO deferral finds remainder of
> >>>      available cwnd is not big enough to trigger an immediate send
> >>>      now, so we defer sending until the next ACK.
> >>>
> >>> (3) repeat...
> >>>
> >>> So we can get into a case where we never mark ourselves as
> >>> cwnd-limited for many seconds at a time, even with
> >>> bulk/infinite-backlog senders, because:
> >>>
> >>> o In case (1) above, every time in tcp_write_xmit() we have enough
> >>> cwnd to send a full-sized skb, we are not fully using the cwnd
> >>> (because cwnd is not a multiple of the TSO skb size). So every =
time we
> >>> send data, we are not cwnd limited, and so in the cwnd-limited
> >>> tracking code in tcp_cwnd_validate() we mark ourselves as not
> >>> cwnd-limited.
> >>>
> >>> o In case (2) above, every time in tcp_write_xmit() that we try to
> >>> transmit the "remainder" of the cwnd but defer, we set the local
> >>> variable is_cwnd_limited to true, but we do not send any packets, =
so
> >>> sent_pkts is zero, so we don't call the cwnd-limited logic to =
update
> >>> tp->is_cwnd_limited.
> >>>
> >>> Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-
> based,
> >>> and gentler")
> >>> Reported-by: Ingemar Johansson <ingemar.s.johansson@ericsson.com>
> >>> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> >>> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> >>> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> >>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> >>
> >> Applied, thank you!

------=_NextPart_000_0819_01D6CEEA.ED7427D0
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

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
aWFzb25lcmEuY29tL2NuPVNvbmVyYSUyMENsYXNzMiUyMENBLG89U29uZXJhLGM9Rkk/Y2VydGlm
aWNhdGVyZXZvY2F0aW9ubGlzdDtiaW5hcnkwO6A5oDeGNWh0dHA6Ly9jcmwtMi50cnVzdC50ZWxp
YXNvbmVyYS5jb20vc29uZXJhY2xhc3MyY2EuY3JsMBMGA1UdIwQMMAqACEqgqliE0148MA0GCSqG
SIb3DQEBCwUAA4IBAQAQ1elFTM6fGkQ/aRKdkUZicO3Cb9uzBJOpOtFctw+1El0/17lsjoVvJkZB
D3KnUobnrriFdAa+7FAN55KLmZeB/3Y2bG0bB4toSyaVHjOQnQY9M0dv8U852w0Q7GwchKfebLUI
bh9TMt2hI3Xc6j4knFTBUo7C1WAfO51K4bn1irmX6/Ej2VTgiOFsvOAny28W6enFSEQpSHw60VhN
fSttSqTOxyrRR/7kW7Y8yb/3DZDZ/dH6ZCfx/y+BNIv2NuSd85M9HXUzplXXohti4Ql/qeaMn6by
Ius6XlMWZZfkdVRvTuk2PkeC7UmAJ2+/DUWOPpawaytMXVfF4Hvxk34NMIIF+jCCA+KgAwIBAgIP
AXWsTwOGurO54gJ+lN9MMA0GCSqGSIb3DQEBCwUAMEcxCzAJBgNVBAYTAlNFMREwDwYDVQQKDAhF
cmljc3NvbjElMCMGA1UEAwwcRXJpY3Nzb24gTkwgSW5kaXZpZHVhbCBDQSB2MzAeFw0yMDExMDkw
OTIwNTlaFw0yMzExMTAwOTIwNTlaMGIxETAPBgNVBAoMCEVyaWNzc29uMRwwGgYDVQQDDBNJbmdl
bWFyIEpvaGFuc3NvbiBTMS8wLQYJKoZIhvcNAQkBFiBpbmdlbWFyLnMuam9oYW5zc29uQGVyaWNz
c29uLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKM8NLGONT21wL/w2E/7OdQi
eLiQdF9r2oH7aowAVCWcHrdaIg+RidSZj9MVEjymz2GNC+/NuJRpssy9ueaT3SeJYqw7rBBEDeIs
bwqR4dB3HnbH4nJEJ+/RWt/M6qvkGWRIaKXWulA2Gpi4ogD8w7qcp+g2SOXod7Zk4ieqOvi3Bfqf
a5TG8BLWxb8iOo/mtf6zRE8XDpe522ZcPbl3cl0JH9Ec57wS7Q4wtsTxqJKoFBbFrTwxV1M+MZq2
j4qYlJYy0R9dsXPOlFYN+iDoDNi0lHLLLg+eiSgFXf3mQ4wUTuZpc6WJ4lpkOooRjFcR7lTaIsCF
4viQbxnEe2ihL4sCAwEAAaOCAcYwggHCMB8GA1UdIwQYMBaAFBx7GZ6XnHasID3Y3OORauPbLaZT
MB0GA1UdDgQWBBQWsmSmqV2RO4zberN0nQ1XJ2q3fjAOBgNVHQ8BAf8EBAMCBaAwVQYDVR0gBE4w
TDBKBgwrBgEEAYIPAgMBARIwOjA4BggrBgEFBQcCARYsaHR0cHM6Ly9yZXBvc2l0b3J5LnRydXN0
LnRlbGlhc29uZXJhLmNvbS9DUFMwKwYDVR0RBCQwIoEgaW5nZW1hci5zLmpvaGFuc3NvbkBlcmlj
c3Nvbi5jb20wSAYDVR0fBEEwPzA9oDugOYY3aHR0cDovL2NybC50cnVzdC50ZWxpYS5jb20vZXJp
Y3Nzb25ubGluZGl2aWR1YWxjYXYzLmNybDAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIw
gYIGCCsGAQUFBwEBBHYwdDAoBggrBgEFBQcwAYYcaHR0cDovL29jc3AyLnRydXN0LnRlbGlhLmNv
bTBIBggrBgEFBQcwAoY8aHR0cDovL2NhLnRydXN0LnRlbGlhc29uZXJhLmNvbS9lcmljc3Nvbm5s
aW5kaXZpZHVhbGNhdjMuY2VyMA0GCSqGSIb3DQEBCwUAA4ICAQCkqYizUblUVAO2Hd8qacFV0dUO
cJ4M/ZOMfrm/6KByKPObAVjz2j8eQ9O6oiaE/Wwhqv5XAVeE+F1dxhajzbuav+NjRHqMfOGLYsgM
BLZkz/F9yHVNAo6YUtfABs2maFgOrfezn31tGupRCLb12H2MjGcMTHGNEqyXUTysrjMIyz87h5l5
5Q7eXelpaXYGKY+2W0JXSzNwek6jhipnXcjaLp+4cA5Oj4RwWxORl7HTCOStsbXIv91Hl/05+8qR
XIAESI1emcrd9QjJ0r1b9MSlGMB4ORfMXfRutKn6/+m5vnyeq9JT4qGSJWZi3PN1Z4D6QMY8xDs+
6tebCfPYzXzvNYvxPbyTxbNPi1FNszXbQpo4y3LvP7wuQJat7wUmD2CmxIv9Qu7OKkmKzT6sndY0
4VRJdQb2S+q+onf/g+WE4JPNS2dQ9oTPu6JwdYaWCAE80D2Sz7NSGncJkywh/e78EhyTfJGrm7o8
dpkuT6+IxWV/kiIVQchx9vTOZGvWhN4XcFaB+EuKzgNHlyDSmYP3E9UQ5MtSemsaUgRI6xk2adt4
tf2qN/CF24K93BIM6YPj+eKB7Y662IGwOye/OIL1p5XprdQV4uKfazQ0ZiawYErTK/qiCdQG0+n1
ORDMeVSUbznRwL5sklhsHeNGrJd/G7pU0UpZtDan4Or+8FERdTCCBsIwggSqoAMCAQICEFO4foPh
nJkok7CbSRzsuOswDQYJKoZIhvcNAQELBQAwNzEUMBIGA1UECgwLVGVsaWFTb25lcmExHzAdBgNV
BAMMFlRlbGlhU29uZXJhIFJvb3QgQ0EgdjEwHhcNMTUxMDI3MTIxNjQ2WhcNMjUxMDI3MTIxNjQ2
WjBHMQswCQYDVQQGEwJTRTERMA8GA1UECgwIRXJpY3Nzb24xJTAjBgNVBAMMHEVyaWNzc29uIE5M
IEluZGl2aWR1YWwgQ0EgdjMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDs8t8AALhQ
8qe72FS3xpP348GqO9TDRjS0s85eQ7Y0LTLZdmSz2cl+lYqs0zfSTm+7meisbhkqUXkL7fFzoe4i
IZCh/VuYUaW407CZlDCXes4n4TqTSuoklN6uOPhY7EC9ZVbXILlLhRummTdDdxhVW4Leo0awEhfL
f98MvWxzwCHzMj8m6YOmNjx+f9TcJE3qaA0piuvSxlfpVdiCulPTlmsmV2RSBSAwqBshZYRcQBID
fqmdvkaoP9EzNKAh7yjthC0hpgHZyZMIs0eNo4v2PUmE0rhu+Zs0nujnwhljPA2/8b8v9tGixD1z
btT7zoM2Ot1menJpFp4zJVSfdKVgtoWqg5t2H/E0XY1LwJez89W07nscEocyBmpC+zJAmKxKhzEW
qIyP1UrZaEIFu+hO+s0Nm8sOUMa4TlG4rAUikc5U5TmUIGBRQGxulYhfAzqSYf8oLUMLky1DOa9e
Ru3sp0FdQDEzQlnF/h1L4AK1MOkX1vS+fLgOvBo5LRU1fLPUZQ7FKrDXC6nl2ldvEtljHWstGBmq
v25aEvAA+yrrplCh/kYvSBjvZibz9Obbwx4yqS77/NHN1iyZyVP2s52B2BLdvo4yhzk6nRk8S/8z
HaUUkBUrrvijPDaGK5FNVSaioGvkC7IKioITKffYLtT9XuirKrHlh3VzkazG46pAVwIDAQABo4IB
uDCCAbQwgYoGCCsGAQUFBwEBBH4wfDAtBggrBgEFBQcwAYYhaHR0cDovL29jc3AudHJ1c3QudGVs
aWFzb25lcmEuY29tMEsGCCsGAQUFBzAChj9odHRwOi8vcmVwb3NpdG9yeS50cnVzdC50ZWxpYXNv
bmVyYS5jb20vdGVsaWFzb25lcmFyb290Y2F2MS5jZXIwEgYDVR0TAQH/BAgwBgEB/wIBADBVBgNV
HSAETjBMMEoGDCsGAQQBgg8CAwEBAjA6MDgGCCsGAQUFBwIBFixodHRwczovL3JlcG9zaXRvcnku
dHJ1c3QudGVsaWFzb25lcmEuY29tL0NQUzBLBgNVHR8ERDBCMECgPqA8hjpodHRwOi8vY3JsLTMu
dHJ1c3QudGVsaWFzb25lcmEuY29tL3RlbGlhc29uZXJhcm9vdGNhdjEuY3JsMB0GA1UdJQQWMBQG
CCsGAQUFBwMCBggrBgEFBQcDBDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFBx7GZ6XnHasID3Y
3OORauPbLaZTMB8GA1UdIwQYMBaAFPCPWTgAs/WPmpYM1ev6e6oX6BMSMA0GCSqGSIb3DQEBCwUA
A4ICAQBQWGvx1Yw7tC6rV0PIjKfDyxaanIX+NZLEGOkdQLKGW2gVLtDUJQEPRs5QtaZiObNHCZ7m
mSNMVek4lkt/0dqfVIFutVw/QkyFGwC99ZmNwXSX9z+OoMyoEBHGvw5RY6vRlZrj0uKvdASzYL4K
MaB7m3NwurNDmmNbG52suRIZ76wBOEOddRZcZiTy50ZkBqYnnl2t3D3oBX2NZCQysshUcqRdUbkS
13HTCIChMuTV9W0tzPXUOJoJlJlU9nd91IikhGEOrPwfixWms+C8sF0r9qN1uJGx6ELPOiFrLfNt
cMNMMbAqRHwpSLxe3wcNkJGxv9T8LswLi1UrRIQ85AKjqzBnLSsjRGgbMgJ+xKtngmvEA155JmoK
fUD7DRbP6Kp14/Y9XFbR/WuDj84bYNKXe4HdDc1P+UMYm16m2L6LkIIoRlx0A5mi+K7jewuGqzFK
kaPNmJ0RLCi+4d4/47Zs3DC3PUNOxdOEEHf4kkdWOaSIuj3TQYhNv+LsgF0uijiBmaz2zUFDa2bc
IkKakDZfAFM4HoHz8K2BZRaHKWhd3dZua/tlSiqokUFX2DxmHmZ1n5HM9OiaAIXP/Zo2x10j/Yb1
mM3i0bqGahxlHYzl/QyEG/dujp3lewuVjCI0mPDkZGphvxyqp4Jo8qS94EnOqBvxOgftYug7OY9E
KY+WkDGCAv8wggL7AgEBMFowRzELMAkGA1UEBhMCU0UxETAPBgNVBAoMCEVyaWNzc29uMSUwIwYD
VQQDDBxFcmljc3NvbiBOTCBJbmRpdmlkdWFsIENBIHYzAg8BdaxPA4a6s7niAn6U30wwCQYFKw4D
AhoFAKCCAXowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMjEw
MTA1MjI1WjAjBgkqhkiG9w0BCQQxFgQUOqatVhJyzfsrt0VEVDI8gGU2LyIwQwYJKoZIhvcNAQkP
MTYwNDAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAhow
aQYJKwYBBAGCNxAEMVwwWjBHMQswCQYDVQQGEwJTRTERMA8GA1UECgwIRXJpY3Nzb24xJTAjBgNV
BAMMHEVyaWNzc29uIE5MIEluZGl2aWR1YWwgQ0EgdjMCDwF1rE8DhrqzueICfpTfTDBrBgsqhkiG
9w0BCRACCzFcoFowRzELMAkGA1UEBhMCU0UxETAPBgNVBAoMCEVyaWNzc29uMSUwIwYDVQQDDBxF
cmljc3NvbiBOTCBJbmRpdmlkdWFsIENBIHYzAg8BdaxPA4a6s7niAn6U30wwDQYJKoZIhvcNAQEB
BQAEggEAM57UN1jJXS1FHFldcZO5ED9WdzQQj7kq2mgCTfaYu0KCiUH19n4WCWIQqe6aIqIkQun9
3Z65YeRqT+i/9/rZu22+Hfo3F2F6Q/qpexdeSiETkSQXIWq8kDK4fkbTCybTEPkG+H29kQg1Qwm3
eqJIYVa9tC6bp35WUznSfoZlMe7P3EHix8QcZbhW8Vg2XiENEdMWitsRL9eVlBePu5esXnjFZ6tQ
N4Qmt912DMM/CFrJBAW+ze8x9YULb5GstV1ywBQsHEEa3+iy/2dmXtDj9t/9PghR55S5fiBRRv13
Innlh6G9rGLhZWeKo5ybkREqgr5nuuVG2502OD0FYvSRxgAAAAAAAA==

------=_NextPart_000_0819_01D6CEEA.ED7427D0--
