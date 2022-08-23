Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F15759E7D1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245332AbiHWQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiHWQpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:45:32 -0400
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A353DC9935;
        Tue, 23 Aug 2022 07:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ogh2atKJ9UodHmzEsteEl10kYw0tZ8eyotdKvJ4XPig=; b=PQDiMIx1UJ2L7XoqAxhusxDWVz
        gMWWp3i8+t735BmFt1n250F5qFXi6++sLQh5PTZFV+zWzAW3e6OdTRW57nGThUkk2s2RYxu3gCQCr
        GB+BYz467FN3Xv66JEKizLzLH/CkqsBx7JTRbj19yi1DReYwCkNoBudvNe2CdYhng9415CR9aM1sy
        yX2cvDqT7fY1TWdMA8SoxkKLmitSUw8ZwE9OOq8LmfDG0Yjuh1waoe6tc+vXNC/Pc/6Gzcz2R0cne
        AHxqbZAPlkvFtXAEV7kqZ+XUUKTkpOTXQ039ceSDKQYlJXhuNdwxPyN/mu1uKLYmTHsMmCzmTQOpa
        S2TdN52g==;
Received: from [2a02:2454:9869:1a::98b] (helo=javelin)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oQUwL-00HVMm-2u; Tue, 23 Aug 2022 14:31:37 +0000
Date:   Tue, 23 Aug 2022 16:31:35 +0200
From:   Alexander 'lynxis' Couzens <lynxis@fe80.eu>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH 1/4] net: mediatek: sgmii: fix powering up the SGMII phy
Message-ID: <20220823163135.013ec257@javelin>
In-Reply-To: <6f147fbd31980c6155ea6e7deba26d8210ed6afd.camel@redhat.com>
References: <20220820224538.59489-1-lynxis@fe80.eu>
        <20220820224538.59489-2-lynxis@fe80.eu>
        <6f147fbd31980c6155ea6e7deba26d8210ed6afd.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

> On Sun, 2022-08-21 at 00:45 +0200, Alexander Couzens wrote:
> > There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> > prevents SGMII from working. The SGMII still shows link but no
> > traffic can flow. Writing 0x0 to the PHYA_PWD register fix the
> > issue. 0x0 was taken from a good working state of the SGMII
> > interface.  
> 
> do you have access to register documentation? what does 0x9 actually
> mean? is the '0' value based on just empirical evaluation?

I don't have any documentation which describes 0x9.
The datasheet [1] only contains the PHYA_PWD (0x10) bit and the initial
value is 0x10. 0x0 value is based on a register readout without the
patch from a working state.

I've tested it on mt7622 and Daniel Golle on mt7986.

[1] MT7622 Reference Manual, v1.0, 2018-12-19, 1972 pages

Best,
lynxis
