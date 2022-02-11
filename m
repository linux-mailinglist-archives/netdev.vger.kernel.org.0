Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC04B2DE0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352929AbiBKTjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:39:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240151AbiBKTjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:39:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FCFCEB
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UEUJidSPz1K/ebt60HoNzQ8Zxm3eD1B8fdKJMAfnNlg=; b=EBGw9KEB14rbgWjn31NTw6YXJs
        Ovc1mXoPGGuI6N8DdfHI2wvy3m5cOKC1f8EoirfOf9knZ13mjittfxSVIlBJGhfxAtdC17IU6O7QP
        gyexf4ndZUkL2xzExy4sGsHp7ep1jNIJYwrT1+c/is3YcxS5+DHpyMR7u/3kYou3NL24=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIbl1-005VtW-21; Fri, 11 Feb 2022 20:39:03 +0100
Date:   Fri, 11 Feb 2022 20:39:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_rtl8_4: add rtl8_4t tailing
 variant
Message-ID: <Yga7V1UuC10ao88j@lunn.ch>
References: <20220209211312.7242-1-luizluca@gmail.com>
 <20220209211312.7242-2-luizluca@gmail.com>
 <20220209215158.qdjg7ko4epylwuv7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209215158.qdjg7ko4epylwuv7@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 11:51:58PM +0200, Vladimir Oltean wrote:
> Re: title. Tail or trailing?
> 
> On Wed, Feb 09, 2022 at 06:13:11PM -0300, Luiz Angelo Daros de Luca wrote:
> > +static inline void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev,
> > +				    char *tag)
> >  {
> >  	struct dsa_port *dp = dsa_slave_to_port(dev);
> > -	__be16 *tag;
> > -
> > -	skb_push(skb, RTL8_4_TAG_LEN);
> > -
> > -	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> > -	tag = dsa_etype_header_pos_tx(skb);
> > +	__be16 *tag16 = (__be16 *)tag;
> 
> Can the tail tag be aligned to an odd offset? In that case, should you
> access byte by byte, maybe? I'm not sure how arches handle this.

You should use get_unaligned_be16().

    Andrew
