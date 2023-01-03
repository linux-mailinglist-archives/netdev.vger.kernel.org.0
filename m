Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF0065C0CB
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbjACN1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjACN1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:27:43 -0500
X-Greylist: delayed 11191 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Jan 2023 05:27:41 PST
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0527CD62;
        Tue,  3 Jan 2023 05:27:40 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7D8CC75;
        Tue,  3 Jan 2023 14:27:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672752457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHFL2PgwhVhLIbc4WDQ0VxcndRKF+zLEggh6iiwpmQY=;
        b=JhiJnwoTDE7pFhG+6yV7Aq3RJmVT4t44k3691eIxRvPtUQuqII3Y4xs+bhozbQ7LmK5Av2
        XnALDQ/hF232xKSTXjfFhkMjHwMd/c5QRHY59HMdmYmiYrZAhxpuQ+9SD/TG0R+v9srIsp
        6sFt2FSn0JXtJs+8pd5Ykp5vlR40Ln5+jh28Zd9+qn7D70QWQBIB3bWHOtVxvHSSNM+QO9
        7Zn/Y7jwx1JKLDaslcRR/167IzifxZuNeCxzrblRR12xpOzbwFhEVaZafELh3c+/0a6vnJ
        sLt1tEtpRFKLBERSnf4b4UhQ79A3Sryb4YEu40MVBNv3nXhH+7zLGc/1riMTvQ==
MIME-Version: 1.0
Date:   Tue, 03 Jan 2023 14:27:37 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 06/12] net: mdio: mdio-bitbang: Separate
 C22 and C45 transactions
In-Reply-To: <20230103131555.5i4tj7sk72gmed5d@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-6-ddb37710e5a7@walle.cc>
 <20230103131555.5i4tj7sk72gmed5d@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <300bdff73f38b4e480d533c04126854d@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-01-03 14:15, schrieb Vladimir Oltean:
> On Wed, Dec 28, 2022 at 12:07:22AM +0100, Michael Walle wrote:
>> From: Andrew Lunn <andrew@lunn.ch>
>> 
>> The bitbbanging bus driver can perform both C22 and C45 transfers.
>> Create separate functions for each and register the C45 versions using
>> the new driver API calls.
>> 
>> The SH Ethernet driver places wrappers around these functions. In
>> order to not break boards which might be using C45, add similar
>> wrappers for C45 operations.
>> 
>> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
> 
> Incomplete conversion, this breaks the build. Need to update all users
> of the bitbang driver (also davinci_mdio). Something like the diff 
> below
> fixes that, but it leaves the davinci_mdio driver in a partially
> converted state (if data->manual_mode is true, new API is used,
> otherwise old API is used). So another patch to convert the other case
> will likely be needed.

The intel build bot already notified me about this. Unfortunately, only
privately as I just noticed.

And yes, these are just the first 12 patches of a larger series.

-michael
