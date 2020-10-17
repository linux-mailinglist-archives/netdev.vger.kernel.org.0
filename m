Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B792914F0
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439814AbgJQWbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:31:25 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:55366
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439706AbgJQWbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 18:31:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8GhDMvyjowaSIG3S8XsOim4RuXq4yhY9a41Er5/N9DDquKipQ9DtCEmRT5x5SUIoBQh015oufrsdZGsnxYzIABYUU8DgaMxiqOhJejdejsKCWR2iGuYWjA/2N2R06/7huwG4+9CXqsbYPIvQbGyHj+u4eWeUKD22DaUuN4pE6d+GptXIW70l4nAf+I/evgdm+rIBVaZxPz6L/T67ltgQfrcqmjFNT9mI4fn0bAFLrf3TFWWw6/miTZ86qdHluce04Ehr7CG/yVj5mwPi7S0CrfYoMULB3rGGA6fUyu2WMrY5+XGpMIHBJu24sxsgl9zFU0NHhlPkka+qOxhaMwM+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I79L4e/LaDtnzrnV2JQnrj84lM7l5ZvtCbHo8gST2KI=;
 b=Z/9kRvJ9dBHd4ose/peX/4DEJcxnaZ2k78fif2hmOa6iGi95aDdzS5hAYK4LNft1tyeX1svfsWwSFMbDhI0WG/YMAI0j0CPqhXU9wFICt2e2IQewsU23Pis/WFW1UjZRibQFNvjBfd8wQsI5svjCXKwWik4TdQ55Ks7M6BoNu6+Ns0YMDwoBRUcGWbiTX+UNnoWJRBD4ohjtk9w89lycT4Zfr8MENJ0KWEBZ1vdxqdwpiL9Jsxy6vGLXZuf8wbjukERQjYlgfvNCIX01FTWp59dmqjg6F7Y634h2VzbYNZlcGk5uic1ouOfZNiuzBG8Jv7Z9XFI32UUAMqEhL+4Ksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I79L4e/LaDtnzrnV2JQnrj84lM7l5ZvtCbHo8gST2KI=;
 b=BqyC2wzrBESQRm4AIKJOSd9GQXcs/KdOVQbMqp4kcD8zyy953bpl51tHHMTV/XoAFiT14+WIDuHiLLOtDBSFOex9uBGLElLiQet+M8UM0ntHAanyqrH7X+NsYzlvUBf/KXjZtzKuAObdctVbvZ+rgnLux5AYTPFyMTMNXIzl96E=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 22:31:20 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 22:31:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAAIdQA=
Date:   Sat, 17 Oct 2020 22:31:20 +0000
Message-ID: <20201017223120.em6bp245oyfuzepk@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
In-Reply-To: <20201017220104.wejlxn2a4seefkfv@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 802a685a-3ec8-465f-e761-08d872ec5f44
x-ms-traffictypediagnostic: VI1PR0402MB3407:
x-microsoft-antispam-prvs: <VI1PR0402MB3407F565553951373F640700E0000@VI1PR0402MB3407.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QasBMO0cIMKaX7RY/GGTBqF+1+FoFbjMXBOaNc6mcbsOluV8AVrZQ9Tv7IQYS7Yjah3MzPBjPSPkPwPa9H0/rk0NqZNALm2hL0pOYTGCCyPjruVUyxsA+2SgXpQzWe3bIKiMhnkB8IjZti458UlUV8Uv4GhHXetKzfdvN1wr1laCdpV6JHT92WHV2UddOKt/APvx154lInqoE/Zq4it2TEX8Jsz/2JnwiESrQ/Z0w6XfcY3boHtR0MNi5jSuFYfs2vfuN7U4K2DQ/SJbhwlzzsZZoZ6at48RRwkIHtgu2ZP1gAp+0sZIL1MWJ1S9hhbed5x/NFGEWgVQA1L1fzqlTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(136003)(39850400004)(376002)(366004)(396003)(186003)(316002)(5660300002)(44832011)(54906003)(66476007)(66556008)(6512007)(6916009)(76116006)(4326008)(64756008)(91956017)(66446008)(66946007)(2906002)(86362001)(9686003)(1076003)(8676002)(8936002)(478600001)(4744005)(33716001)(6486002)(71200400001)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: InaiCOyJNMxQscDzs5hzDhqdp5yFnekS4mSTrdUvyKyrtK0uvPFPgoJbYuEoDBBWigwAe9Mb3kGtXeKI0d/3wrSqehWFPeoUL3gOrgPIXnT+oH3M0Nv/qMXjIZM0gTRzOReoFrw3t293cZcOPt2sIMVtKCLkQK57HcnVN0O0I0lmssCzcdTFp8rq/3s90409FmvaQYQr7c1ZSk3K8EGOkrmmiHUuMCn3tviorzvdj/3lbO4eFNaLVVSzVYRe6cfRkaUnzijbiN17ESgpnmkjnJVLbNuTSLU0dgW9xDlyHynvnZXtQgx01EzlcSOrF9IZRQbpWEmR2mZAQmpSp+sjb5KQx8YBQ0lUmLGT5FTbCQKuk1+/G1da19C71R1mGZMxkLHCGtbvMAclX2rCrCDoZrP8pTdim+GpGE48b7EMny/pOJqt1vQK+ibw+giH8WXRGNKH7ygTib9Gb821w2CTXKsoZ9w6A7hIVWdkDd655eE6MKlN+dPMcWj2IDs8EIVHvEdCArml+Lv6m30YKOxeQT2qU3YWOtqG8Lbz2bGlun/Tq/gJDoncl2tHF2/N2A7BE1z5DM2IopvcAJ6ijFe0wbtdzaS+n448P8JxXVUdzUvPQLyROqlGN68dzUUqfYn5iZk0DaJZc0TWlr/G1Jv17Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0758BB9B7205B043BC134FBF3725DF89@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802a685a-3ec8-465f-e761-08d872ec5f44
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 22:31:20.8195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43KSoDRj1NAC20Rs5Md7VeAZ2J8QraUZMKq7mk8RAJ7NFhf8B3KnI8B7BlcAqIk9/mdyYN63bEDP7voRQ4Uc3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 01:01:04AM +0300, Vladimir Oltean wrote:
> > +	return pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 	err =3D pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
> 	if (err < 0 || !padlen)
> 		return err;
>=20
> 	return __skb_put_padto(skb, padlen, false);

Oops, another one here. Should be:

	return __skb_put_padto(skb, skb->len + padlen, false);
> > +}=
