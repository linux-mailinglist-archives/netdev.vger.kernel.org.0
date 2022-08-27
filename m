Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1C5A39A1
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiH0Sy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiH0Sy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:54:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EB5D633E;
        Sat, 27 Aug 2022 11:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uD+63HgUhkxXVowO2tofksrYfh23EPdwjmkCclgm85w=; b=XVfFEUefrVqEyL+98Sem+QqvbG
        OsGS9RpYK3yVwK7ZGi9DwhKyEhqgim1o/b7WyaAr1eOIR+/0Od6epWPjWx+oq8qUlrtHuMPXnFeFE
        ioZ130J1jdCEW+rjY+IoREn0N+uNJ/kDw8rE//i4TCLFZbKMP/JMYmRxIk+cHXtVhLiw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oS0wo-00EnUE-NA; Sat, 27 Aug 2022 20:54:22 +0200
Date:   Sat, 27 Aug 2022 20:54:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <YwpoXpcRickYzD9K@lunn.ch>
References: <20220826154650.615582-1-maxime.chevallier@bootlin.com>
 <20220826154650.615582-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826154650.615582-3-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct dsa_oob_tag_info {
> +	u16 proto;
> +	u16 dp;
> +};

> +#define DSA_OOB_TAG_LEN 4
> +
> +int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
> +{
> +	struct dsa_oob_tag_info *tag_info;
> +
> +	tag_info = (struct dsa_oob_tag_info *)skb->head;
> +
> +	tag_info->proto = ti->proto;
> +	tag_info->dp = ti->dp;

Do you need to be worried about alignment here? Is skb->head
guaranteed to be at least 16 bit aligned? I think you would be safer
to use get_unaligned_le16(val, tag);

	Andrew
