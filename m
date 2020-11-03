Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979362A4D45
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgKCRlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:41:40 -0500
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:29861
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbgKCRlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:41:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewkDpRRmj+KAsH3CKl0w5BJbwmHqIL9CoiwMyaFDVgPZE9wZ9aImAlPakf90Dgbd9Zj9S9E39HhJjyaibxjGxYW0ZaeO3fIImPWu64SnRMMTqXdG+82GLg9Ik1jvZ/Zco+G2auRvSpZ/woIe5dOgK7DiErTWnjiH2hircALgyNfM+PP1dYCl2RVFhYF0G0zBZCuRCpFFJc+vQc+LQM1PLHV2fpIIX6ykydzzMPn0YPTMsCJCWvhcPrQbUmGNmSk6qY++DJY2QmWXxQ3w1DT8PCGy1PCpnXDWP6UUJ4D4qk2FsSfyA7fC41dSh0sm8w03eNKTHgcf06+Vtclwg74tbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7snisl89bYpb3UXCbD3MvwUBRBVnhMUWUoXgVwFwO/M=;
 b=EXaJHb+RZfFWisstpBThsNCu+CkDaPvSWjP4HByj5fuwJpV4A3jSJLl5lPReXUYFS0b62ZZ0NGx8Q/wxSQib+KXlt55rHHc9P+lEjhkxXbMniF1C74jsnzMDHVq/wWimxR5HV+NT6X3ftWAn82w6k+3FgpelMOSuTA1ZYJLtK22ot/IjVaCh2GSNDyeME9iVos1lll6wds3Mcy0NeQqShI5If7yZVKzRLaXeLRTqP4mos1ZUctuqRQQDc/Xeme5YVd0ETHjv8Y5iYKChv/2lLM4I6bZJ5crMklCpBeaL4eNTNchg/o3D26BbOx82oCf9RFTNr3bp1LQHwwtCKVN6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7snisl89bYpb3UXCbD3MvwUBRBVnhMUWUoXgVwFwO/M=;
 b=Wbl7PFqWvjnwukvZbOaelZHmoQXyg4KyYjzMrM2NUiEUTq64BpAwPU3IYoIDPEWIty/bXc4ytY64MOj7E6TANjFbyhDWZS/miGDlAdkslvrQFUVNbdhkbPq3oMFcVElIoZomePlU/SMvRpu8FHIEHXKSiNwd+EJwK97Ortn1pJA=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 17:41:36 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:41:36 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: RE: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Topic: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Index: AQHWrcsPyv6BypdD30yr6oyPLeI0Tqm2nOaAgAAE5QCAAAsikIAABW6AgAAC01A=
Date:   Tue, 3 Nov 2020 17:41:36 +0000
Message-ID: <AM0PR04MB6754E51184163B357DAACDFB96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103173007.23ttgm3rpmbletee@skbuf>
In-Reply-To: <20201103173007.23ttgm3rpmbletee@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df1496ca-7e8f-4d46-c046-08d8801fb652
x-ms-traffictypediagnostic: AM8PR04MB7281:
x-microsoft-antispam-prvs: <AM8PR04MB728110AC58321D7EB3F7D54D96110@AM8PR04MB7281.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eP+LhX8Xbbqhb6IDgco0F0VkmvfEP6otGEzIbAI5u3btVpjeBVyDMO+mcagEN4KzR0C5yhSIM8D5syoPki3blp1Sz89sJ7RcU9DBqtIKvkzrI+P09FaxFNLaYrlh+bN2b1+nMtoMeMSpP3fEDbzIwacEVPu/6I/MQQlL1nk494KNBcCe/L7H4rlIhRRTJIdg77xugeCxj+3vpjmdHU5Zhg+gzxqYo3Yx68RSiGUvxnDzGQvIHLSqNgZpHSV/NLjvoB4ySVDnXMz6FBXe2MIWBpXOX6vNNC0DCFpbgwfs9/+ImIW3IaIH7Ut9RTMBrxVRv3D+FNP5ANL7LiCIc9B5ZYLwunJl+ZbOWULG9qNFReZWFevNerXpZvkzIr1BO8zszL25asBn8nCipHXSy+3jMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(376002)(366004)(346002)(64756008)(8676002)(66446008)(66476007)(8936002)(66556008)(66946007)(52536014)(186003)(54906003)(83380400001)(26005)(9686003)(44832011)(55016002)(4744005)(76116006)(6506007)(6916009)(2906002)(71200400001)(478600001)(7696005)(4326008)(966005)(33656002)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gZGw3BN/HsVf2wJRHSNJTIBgdHSrBTmj2gpNQH0sVEO9oKzWGvCpjtgzTnJx2f85L6PnVPSdVhIr4jgLV8iquo3cDqlPmmVc6zqWV59gMs8uJqGF1jI/AkkWnAoI1zJyBe3Ubg7haiILTMwqOLRyWMbDfDU2gM2fAIWWP8898Ibp/5yoldsvCU2BijzEuBKqbzX+jB8HIopN3McgXvX8DoRLMpqa1h/9rOlWK7lYrHVT3svU3xNeiFK/5IPeEbW/VawSqmjxLgFfCe/y0wWCijukOTABH4k3Nj/AsyUydyD06/UKihVf84Oo3R4sAJBKLwOh4h2lra2AtDzR/EOMl/b+T4HKrBNaBZWFhreQFgFBMx3X8Z3ub3Docu8/3YT4E91lSO1y89Dkn/AsHpZlmwMUpt+p0PrmO8cPVzwiSEGyYdwd4P9uy0fSk7OzLbG28c0Xc7V8z7aKdGwq3pH+yJlbffST8khCUxMVzvSkYVYW+qzW96bdgRt0hUxrx6hAjqQerD1nCN42ZZiCuKeD0xsPFhug5e5JrwU6f7s02FdMCwJp+oT4y1mtds6Ld8vRemUx+7K2JQoE9aBJ00fpK+p5+VIrLVmsg4YoL9eWVicG38eleQTDfH/zLbG/myQOlXFfzSsYZYuzi/IiHqXwNQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1496ca-7e8f-4d46-c046-08d8801fb652
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:41:36.3383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PDn9+q3MgZQh7eIrdJ+hoiW7bkstiMAaOI7139D/ebQ43kzE6bnNCNpdmyXX4YcGdxBN+6rN+g8CDFDmbEb1og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Tuesday, November 3, 2020 7:30 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org; David S .
>Miller <davem@davemloft.net>; james.jurack@ametek.com
>Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
>skb_cow_head for PTP
>
>On Tue, Nov 03, 2020 at 05:18:25PM +0000, Claudiu Manoil wrote:
>> It's either the dev_kfree_skb_any from the dma mapping error path or the
>one
>> from skb_cow_head()'s error path.  A confirmation would help indeed.
>
>It says "consume", not "kfree", which in my mind would make it point
>towards the only caller of consume_skb from the gianfar driver, i.e. the
>dev_consume_skb_any that you just added.

This is the patch:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3Dd145c9031325fed963a887851d9fa42516efd52b

are you sure you have it applied?
