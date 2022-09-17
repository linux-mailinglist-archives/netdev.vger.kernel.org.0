Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB05BB75C
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIQJAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 05:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQJAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 05:00:20 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F191D0C5;
        Sat, 17 Sep 2022 02:00:18 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 673A340004;
        Sat, 17 Sep 2022 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663405216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VEyWt/RYAY3zpkgir+Y3PaZ3FmEx5dtQi+QxOJw0aA=;
        b=MYG1Db67qpNBXmwj+s8DOP/MOl01Z07609no99A8mJAxaRtZcejq34G2SZrChj95Y+giJW
        uk5EwjOv1ZTYoh7Ea9Yr4+QXn7Iss1lqY0FqsYwP5psD2dF+KrcgDTehqa8W3rAhG1akX1
        NtBXkYiz0TzXu+YlWJHw7oOCjYQoNsC3+xeTUjOTdVjTYkCT7ClJaVnbmUdNtNy4KUJWTm
        sdrOanqjcsFST0uHAEkqlmr1IDgYuA3KuQnT6LFhMhn0zrBoIcTI4IIsU5NJhuwF+AyteM
        9JIMTHO/ajk07RpsxySEj2yUf7Srm0yh9KRtK8iYHr8iYBckUCHHDvb2y2xStw==
Date:   Sat, 17 Sep 2022 11:00:13 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20220917110013.78710782@fedora>
In-Reply-To: <20220917001521.wskocisy53vozska@skbuf>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
        <20220909152454.7462-3-maxime.chevallier@bootlin.com>
        <20220917001521.wskocisy53vozska@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

Thanks for the comment :)

On Sat, 17 Sep 2022 00:15:22 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Hi Maxime,
> 
> On Fri, Sep 09, 2022 at 05:24:51PM +0200, Maxime Chevallier wrote:
> > +int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info
> > *ti) +{
> > +	struct dsa_oob_tag_info *tag_info;
> > +
> > +	tag_info = (struct dsa_oob_tag_info *)skb->head;
> > +
> > +	tag_info->proto = ti->proto;
> > +	tag_info->dp = ti->dp;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(dsa_oob_tag_push);
> > +
> > +int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info
> > *ti) +{
> > +	struct dsa_oob_tag_info *tag_info;
> > +
> > +	tag_info = (struct dsa_oob_tag_info *)skb->head;
> > +
> > +	if (tag_info->proto != DSA_TAG_PROTO_OOB)
> > +		return -EINVAL;
> > +
> > +	ti->proto = tag_info->proto;
> > +	ti->dp = tag_info->dp;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(dsa_oob_tag_pop);
> > +
> > +static struct sk_buff *oob_tag_xmit(struct sk_buff *skb,
> > +				    struct net_device *dev)
> > +{
> > +	struct dsa_port *dp = dsa_slave_to_port(dev);
> > +	struct dsa_oob_tag_info tag_info;
> > +
> > +	tag_info.dp = dp->index;
> > +	tag_info.proto = DSA_TAG_PROTO_OOB;
> > +
> > +	if (dsa_oob_tag_push(skb, &tag_info))
> > +		return NULL;
> > +
> > +	return skb;
> > +}  
> 
> I don't have too many comments on this patch set, except for a very
> fundamental one. It is impossible to pass a DSA out of band header
> between the switch tagging protocol driver and the host Ethernet
> controller via the beginning of skb->head, and just putting some magic
> bytes there and hoping that no random junk in the buffer will have the
> same value (and that skb_push() calls will not eat into your tag_info
> structure which isn't accounted for in any way by skb->data).
> 
> Please create an skb extension for this, it is the only unambiguous
> way to deal with the given hardware, which will not give lots of
> headaches in the future.

I have no problem with the skb extension approach, my goal from the
start was to find the correct way to approach this tagging process.
I'll spin a new version with the skb extension approach then, unless
someone else sees a problem with using skb extensions ?

Thanks,

Maxime
