Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE894523595
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244694AbiEKOdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240682AbiEKOdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:33:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB77668F80;
        Wed, 11 May 2022 07:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bEAJtgnMEKMbBgh9iYBqIdW4JqbXFYk0M7Z0CTygwNQ=; b=EK9OTj7tkiqGEEdsbkjzOt8cx+
        9PIAG7mefFSDJPIn5ZVbt62K5LHyorLQQHfuhVglXto87oC3GVbpSJdKrSltBrOQo9vm0W42kpgC1
        J7XQo/TiiBKbxVnZD+Xs1NW4V73B38KhiaGIbhVXlliV8iLudKNUzPMu10egYaNWJf64=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nonOY-002Jqv-2H; Wed, 11 May 2022 16:32:54 +0200
Date:   Wed, 11 May 2022 16:32:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, Sean Wang <sean.wang@mediatek.com>,
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
Message-ID: <YnvJFmX+BRscJOtm@lunn.ch>
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
 <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
 <20220511093245.3266lqdze2b4odh5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511093245.3266lqdze2b4odh5@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Let's see what others have to say. I've been wanting to make the policy
> of whether to call __skb_put_padto() standardized for all tagging protocol
> drivers (similar to what is done in dsa_realloc_skb() and below it).
> We pad for tail taggers, maybe we can always pad and this removes a
> conditional, and simplifies taggers. Side note, I already dislike that
> the comment in tag_brcm.c is out of sync with the code. It says that
> padding up to ETH_ZLEN is necessary, but proceeds to pad up until
> ETH_ZLEN + tag len, only to add the tag len once more below via skb_push().
> It would be nice if we could use the simple eth_skb_pad().

There are some master devices which will perform padding on their own,
in hardware. So for taggers which insert the header at the head,
forcing such padding would be a waste of CPU time.

For tail taggers, padding short packets by default does however make
sense. The master device is probably going to pad in the wrong way if
it does padding.

   Andrew
