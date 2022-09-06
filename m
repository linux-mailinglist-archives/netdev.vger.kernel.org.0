Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5565AE91A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbiIFNIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiIFNI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:08:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083EC42ACA
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5fOizBSEnH1T+1aYCx0lQG6RxvkRn/DZ9banCFRZ6iI=; b=Z61mw15JzB+OjpmloG0zvoiwGh
        halpL/HWnIMwDDODITD/rXDellgsDqCoy41Y/CuqIY2W6i8Sce47/0dSOi3VeMxsWpI+n30LdJ+1n
        DS1y2OL7JVN8vNzfSZmatJdNKbDRrk1NnLSD3sKODgyGpOoFkCdTKoU4jxEe0wOaeCg4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVYJT-00FkfU-R6; Tue, 06 Sep 2022 15:08:23 +0200
Date:   Tue, 6 Sep 2022 15:08:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 3/6] net: dsa: Introduce dsa tagger data
 operation.
Message-ID: <YxdGR/TPuNf7E0w1@lunn.ch>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-4-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906063450.3698671-4-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  		switch (code) {
>  		case DSA_CODE_FRAME2REG:
> -			/* Remote management is not implemented yet,
> -			 * drop.
> -			 */
> +			tagger_data = ds->tagger_data;
> +			if (likely(tagger_data->decode_frame2reg))
> +				tagger_data->decode_frame2reg(dev, skb);
>  			return NULL;
>  		case DSA_CODE_ARP_MIRROR:
>  		case DSA_CODE_POLICY_MIRROR:
> @@ -323,6 +326,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  	return skb;
>  }
  
> +static void dsa_tag_disconnect(struct dsa_switch *ds)
> +{
> +	kfree(ds->tagger_data);
> +	ds->tagger_data = NULL;
> +}


Probably a question for Vladimir.

Is there a potential use after free here? Is it guaranteed that the
masters dev->dsa_ptr will be cleared before the disconnect function is
called?

Also, the receive function checks for tagger_data->decode_frame2reg,
but does not check for tagger_data != NULL.

This is just a straight copy of tag_qca, so if there are issues here,
they are probably not new issues.

     Andrew
