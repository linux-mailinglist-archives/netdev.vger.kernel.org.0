Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EBA5B4797
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 19:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiIJRJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 13:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIJRJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 13:09:03 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB713F30
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 10:09:01 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 452497F4A1;
        Sat, 10 Sep 2022 19:08:58 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D29D34064;
        Sat, 10 Sep 2022 19:08:58 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 120C23405A;
        Sat, 10 Sep 2022 19:08:58 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Sat, 10 Sep 2022 19:08:58 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id D4A117F4A1;
        Sat, 10 Sep 2022 19:08:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662829737; bh=U3auSTATNZzG1Ut8+X/fys/FVzvaVdR2gwZcHl43KP4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DWUHt/YtM/hK98N5YHY4PST2U9mupbutJdZIJcaKr5wORbxAxXVj1RIccBMkbEcRh
         YNktawIX+/84txBV+0JINftOVaCgZRhTBfcmD+epnza78GI4odSI2entY/hpSM2507
         UnZ1mnW0egsOPrZcHkQimhV2OZIT7bH0WsD8iGGv6g01XVtvHieh9ckjNBpLs0IsA5
         SDpLrfoJg6c4kPuvrt/GNurA5r/X3BKz52UbE3XysrxNNB/9AkOH8hCXlZHoM3AhHf
         mdD6s8J9Sg8n8O/J+LR+cxdO22OB7jv9Jy06qOeoj6BRLsUwKO7bIeI+K/zf4VX4V/
         hurskJbu9OY2g==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Sat, 10 Sep 2022 19:08:57 +0200
Received: from atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7]) by
 atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7%11]) with mapi id
 15.01.2507.012; Sat, 10 Sep 2022 19:08:57 +0200
From:   =?iso-8859-2?Q?Cs=F3k=E1s_Bence?= <Csokas.Bence@prolan.hu>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Thread-Topic: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Thread-Index: AQHYvgvAqYxcZiVWlEa6YD11dIMWJq3QVz4AgAOaV4CABQDeDw==
Date:   Sat, 10 Sep 2022 17:08:57 +0000
Message-ID: <ff2a4e2901dd4fedbc73deead3579bc3@prolan.hu>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <9f03470a-99a3-0f98-8057-bc07b0c869a5@pengutronix.de>,<20220907143915.5w65kainpykfobte@pengutronix.de>
In-Reply-To: <20220907143915.5w65kainpykfobte@pengutronix.de>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [152.66.181.220]
x-esetresult: clean, is OK
x-esetid: 37303A29971EF456627C66
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 05.09.2022 09:38:04, Marc Kleine-Budde wrote:
> > On 9/1/22 4:04 PM, Cs=F3k=E1s Bence wrote:
> > > Mutexes cannot be taken in a non-preemptible context,
> > > causing a panic in `fec_ptp_save_state()`. Replacing
> > > `ptp_clk_mutex` by `tmreg_lock` fixes this.
> >
> >I was on holidays, but this doesn't look good.
>=20
> Does anyone care to fix this? Cs=F3k=E1s?

Yes, I will attempt to fix it. But, like you the week before, I am also out=
 of office right now, so please be patient.

Bence=
