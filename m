Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC45B550B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiILHJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiILHJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:09:55 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CABA13D0C
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:09:54 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id EF3257F4F5;
        Mon, 12 Sep 2022 09:09:52 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDBE834064;
        Mon, 12 Sep 2022 09:09:52 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD8333405A;
        Mon, 12 Sep 2022 09:09:52 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Mon, 12 Sep 2022 09:09:52 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 760567F4F5;
        Mon, 12 Sep 2022 09:09:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662966592; bh=pd2rJYl+dBc9jbwZTvftlqSSLEKVhxcyqNSOiXPEWpo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DKJJ4rg1yO0rkI3DynYzWH6SGIb0uqXMK+J/t1FzOR+Gnpo6SToSOCLtXO8mwZL5g
         s2cVOR/zXR6PMU3lj1E0sTjF4QJvhWgt6R+koESUc85y4UKVwtoRLSf0S8+uZNQzgd
         aymytz/EehijR45EvS0qjW7UPgHp8QDJIlBy7tFNizuWXYhYo8iJDimWNbBB5lQil1
         huBxJDlNYptFDbujT6N474yxc7MHUA2ehdnz5lA39ce6uKPkXc+UgwgcNqbx+G/Lj8
         ZaKKTfbqrr20M6WBJLMJk6e/TVOrtsJIsN5u5UmDZXy2rhh9Sy5FXtmxGRSu8TIZSH
         M7DWOcCHWiy5A==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Mon, 12 Sep 2022 09:09:52 +0200
Received: from atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7]) by
 atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7%11]) with mapi id
 15.01.2507.012; Mon, 12 Sep 2022 09:09:52 +0200
From:   =?iso-8859-2?Q?Cs=F3k=E1s_Bence?= <Csokas.Bence@prolan.hu>
To:     =?iso-8859-2?Q?Bence_Cs=F3k=E1s?= <bence98@sch.bme.hu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v3 2/2] net: fec: Use unlocked timecounter reads for
 saving state
Thread-Topic: [PATCH v3 2/2] net: fec: Use unlocked timecounter reads for
 saving state
Thread-Index: AQHYxnY65jsY4epvXEuxMw9wnC7qEa3bX7W2
Date:   Mon, 12 Sep 2022 07:09:52 +0000
Message-ID: <2d00928bc4784160b11f7de8e9858e91@prolan.hu>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>,<20220912073106.2544207-3-bence98@sch.bme.hu>
In-Reply-To: <20220912073106.2544207-3-bence98@sch.bme.hu>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [152.66.172.55]
x-esetresult: clean, is OK
x-esetid: 37303A29971EF4566D7564
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


From: Bence Cs=F3k=E1s <bence98@sch.bme.hu>
> From: Cs=F3k=E1s Bence <csokas.bence@prolan.hu>
>=20
> Please thoroughly test this, as I am still
> out-of-office, and cannot test on hardware.

(Sorry for the confusion, I am unable to access the company mail server
with `git send-email` remotely, so I had to send it via another serer. But =
it
is still me.)=
