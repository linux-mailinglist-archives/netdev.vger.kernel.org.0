Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F55235C3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244876AbiEKOjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244878AbiEKOjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:39:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCB6B36F9;
        Wed, 11 May 2022 07:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FiKDI9HhA7r1AHskj6iUp9mVld6qQ9o+A800DaQAHwQ=; b=XlpCopCA1tvMM4IGD6BfsvKJJ3
        6Ne4J4K8ICTVijFI20gMdznQKN26v+HzXDOqQM+gLJnQNUlf18YCULwS+DYBTr1W2CT//sXr/pzm/
        N3v2xqYRQugLIno12BUCu9wbMJJ9pYaAWEJDtK/7iqRJ4KtfCExbag4imqu4x1d6YffI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nonUx-002Jv1-LY; Wed, 11 May 2022 16:39:31 +0200
Date:   Wed, 11 May 2022 16:39:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <YnvKo2sMChiXaiFN@lunn.ch>
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
 <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The garbage data is still present in the ARP packets without my patch
> though. So regardless of whether ARP packets are processed correctly or if
> they just trip up on some receivers under specific conditions, I believe my
> patch is valid and should be applied.
> 
> Who knows, maybe the garbage padding even leaks some data from previous
> packets, or some other information from within the switch.

I somewhat agree with Vladimir at the moment. We don't seem to fully
understand why the change makes things work better. And without that
understanding, it is hard to say if this is the correct fix or not.

If this fix is making the transmitter work around bugs in the
receiver, we really should be fixing the receiver, otherwise the
receiver is going to be broken in other scenarios involving padded
short packets.

	 Andrew
