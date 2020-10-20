Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC0C2934A2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392032AbgJTGPA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Oct 2020 02:15:00 -0400
Received: from mail-eopbgr1300134.outbound.protection.outlook.com ([40.107.130.134]:24064
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391940AbgJTGO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 02:14:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSbvpgDdrGRgQJePnabiD3AJ36pBa0rHb3lfUuGXAY2DZfNDUs43RXjxjAjrn4My1h94TrJ0T7DZJhwMoIQHAayVK4HPRjvI+H9hgEAC2animhkb8wij2IE1xtrHg2v6uVOHF1xzDYus//GdiOt2zEufFeXYZ07mSyJQjGQyXfle48+ZHw3wX1omnhJ5qPPyAKaKPTJmEjZewEs896j3aKhSY7MIOB6D8ihq8u5N1v532z37W6QH+XqT+mmh/IfsHXdzmBZsSydqLUJt9jxMD0f5mC3bdzyV8NHLp6FkLntEf/TIYmO5CaQEBNhBBeCeK2wHP0iIwpIgqYVX8oR2gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5IAB6oB5ixjTfIG9//RehQ6zLG7vSpmh8sEUGuwIZg=;
 b=GSgn43PuyknpNX41nhKILwBSUf3IlC7k8LcSMyhnhT6N5QzcTUwzdAGUTZsfN3fUcM/any2xV/O7d8/Xi7ToXVkXtnJ1YdhKn0DNY57ZB61n4iyP1i2qBr+/3WfS59Q0TReixFBuwAZMYYJwgZF24UBZdKRhKbFqi0dv31HTtLX9pVxEfMRFTwPkzvS0343ixMU19iKlOlHc6AoHpJRD9SPpamEkOZrVcjZwomDJ+R9/8mCwA1vAYwJ9FDfxQXe9zwzGeQCSPucNCpc6vvqawgRhHF0G4refw7IiEKtORP8xlPPpbJ2GQFy3YKzrqlOJLHGhl+wd5iko5Nitz2o+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com (2603:1096:803:6::17)
 by PSAPR06MB4199.apcprd06.prod.outlook.com (2603:1096:301:3c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 06:14:52 +0000
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc]) by PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 06:14:52 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Jakub Kicinski <kuba@kernel.org>, Joel Stanley <joel@jms.id.au>
CC:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Thread-Topic: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Thread-Index: AQHWper5b6m5IMpmJk2Uyk3yAiWzCqmen8qAgACopgCAALYZ4A==
Date:   Tue, 20 Oct 2020 06:14:52 +0000
Message-ID: <PS1PR0601MB1849166CBF6D1678E6E1210C9C1F0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
        <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
 <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=aspeedtech.com;
x-originating-ip: [211.20.114.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 023f13ec-add6-4ab2-7cdb-08d874bf74ef
x-ms-traffictypediagnostic: PSAPR06MB4199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PSAPR06MB41992F0820FA0FBD4B0FD91A9C1F0@PSAPR06MB4199.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3gs3Wg0+IYx09pV5UvisNBrTBT3lGMx3d4Vy5WH7I//ybfXJ9LihryTt5sOXv0X5tvEG7DiO8uc7hjK4FGIOUMaFIjGKRYmhut2IkCWZEWhZkKRNRRX7/T8IrCX/t0MmziQCjtCzzJouqrK0k6roILdKuKlAeWNeK0Ozynn37JQn8+r1Q4mN5TmBWnM8mpgv5LL0x7CjFK/oTHz5w7yAFRZpZTbe4e31RlFZO19mQyFOebhRzzoudNKrRzTB9x2tw7MGjN7xNX+CMfGBKZhV3NXK7axKQKQ8S+wAWhYoRZzuc7mPNBU7q5eoNxrWLxA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB1849.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(366004)(136003)(376002)(26005)(478600001)(186003)(53546011)(4326008)(55236004)(6506007)(7696005)(66556008)(107886003)(66446008)(64756008)(66476007)(66946007)(8676002)(76116006)(33656002)(83380400001)(8936002)(9686003)(52536014)(71200400001)(54906003)(316002)(2906002)(55016002)(86362001)(110136005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vCEH3TrBmvhbhSpX4zZU7O3az9IY4CFCrXP0cORx0zOtHU+vASoMlGG4dpuy9Cl/qdsgH9jrYzV0j+Nu4+ibbxIB/EgwDT100pLVj9D6/Mj7LDzk3mCU9gr1ArzWYyyFEIRXXW+RtPf2ryet0Pn2s4R2zqaasyUvNfgZfLV30LNyj+bMO6/qHCf7yNPSL5bKgf6UDwsiLVdUyhd3tqCecHSFLYnBrxL74iWPhHzSVv8ssLtAYx+WL1Hb2kUHvDVCook3s+vsTrhydUOxtXbq9bHB8PRdz/CCYQ69k1LH5rZCqFO/hdvBsKwsOiTpOHFtGRZVJmF0ByelfhqIKlx8nUM1MwqbHghNbNO0+lwNh+ZDh5xKeUAYYzATF2ApNOIoyMmsWmiwRfYa+84PxlNRbdgLBVeXxkyBh4EDxMFrxpVUhqqOTDG3+9Cgv4x/sE0jh/ik7oRMmiS7aNEzrNoALVpIY9JHbBp7HhfRVGvt/vetT78Yus94uPW/pH1jTXUDjArZtP52TiLWOFQ4ITRocxZp+6xq/M5yfrlgORWuvFULPlmJiH3mHWgkS4/GL5i/HEIXXwIbUD2qKyReta8u9tASL+JlGME9MEAobmwgGMtL22n0QR2lmsvdlkYezTjynw+LnseJ+CRhSRXc00oi+w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB1849.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023f13ec-add6-4ab2-7cdb-08d874bf74ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 06:14:52.0803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: krmCOmELoPfbcXqW0UmA8BqBObRkne6gEft8sGpLyeC3XU2aqOAYc2FhOjMikmA0O+fzUdYgUTeef9g23aECG0/uPscJTj9evZV2xHhMCK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Tuesday, October 20, 2020 3:01 AM
> To: Joel Stanley <joel@jms.id.au>
> Cc: Dylan Hung <dylan_hung@aspeedtech.com>; Benjamin Herrenschmidt
> <benh@kernel.crashing.org>; David S . Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org>; Po-Yu Chuang <ratbert@faraday-tech.com>;
> linux-aspeed <linux-aspeed@lists.ozlabs.org>; OpenBMC Maillist
> <openbmc@lists.ozlabs.org>; BMC-SW <BMC-SW@aspeedtech.com>
> Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
> 
> On Mon, 19 Oct 2020 08:57:03 +0000 Joel Stanley wrote:
> > > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > > b/drivers/net/ethernet/faraday/ftgmac100.c
> > > index 00024dd41147..9a99a87f29f3 100644
> > > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > > @@ -804,7 +804,8 @@ static netdev_tx_t
> ftgmac100_hard_start_xmit(struct sk_buff *skb,
> > >          * before setting the OWN bit on the first descriptor.
> > >          */
> > >         dma_wmb();
> > > -       first->txdes0 = cpu_to_le32(f_ctl_stat);
> > > +       WRITE_ONCE(first->txdes0, cpu_to_le32(f_ctl_stat));
> > > +       READ_ONCE(first->txdes0);
> >
> > I understand what you're trying to do here, but I'm not sure that this
> > is the correct way to go about it.
> >
> > It does cause the compiler to produce a store and then a load.

Yes, the load instruction here is to guarantee the previous store is indeed pushed onto the physical memory.

> 
> +1 @first is system memory from dma_alloc_coherent(), right?
> 
> You shouldn't have to do this. Is coherent DMA memory broken on your
> platform?

It is about the arbitration on the DRAM controller.  There are two queues in the dram controller, one is for the CPU access and the other is for the HW engines.
When CPU issues a store command, the dram controller just acknowledges cpu's request and pushes the request into the queue.  Then CPU triggers the HW MAC engine, the HW engine starts to fetch the DMA memory.
But since the cpu's request may still stay in the queue, the HW engine may fetch the wrong data.
