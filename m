Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15F35AE89E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbiIFMny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiIFMnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:43:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F423719E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7VE+jkwvqAbaeXxHbQdon/6tlMvzrqELMHGtRsornzo=; b=CJ04SoUtrE5teit2JVRoioNEwc
        l7fML0UWXvKSmx6aJDDe9+i3et2XexGMNmVZeKqaZ8pLt0jSCd5ecQUoNN6bYdEs/NFcynh9bWFy0
        ZWQBSVxgns+z5ZeEpjmxPuEcdXMYf1JcCgv0cwjMOr+1BPnD+Ql+nbeB/38d0mOzutc8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVXvg-00FkZ7-KR; Tue, 06 Sep 2022 14:43:48 +0200
Date:   Tue, 6 Sep 2022 14:43:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 2/6] net: dsa: Add convenience functions for
 frame handling
Message-ID: <YxdAhDHy1V22HFw+@lunn.ch>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906063450.3698671-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 08:34:46AM +0200, Mattias Forsblad wrote:
> Add common control functions for drivers that need
> to send and wait for control frames.

It would be nice to explain why a custom complete is needed. Ideally,
it should not be needed at all.

> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h | 13 +++++++++++++
>  net/dsa/dsa.c     | 28 ++++++++++++++++++++++++++++
>  net/dsa/dsa2.c    |  2 ++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..70a358641235 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -495,6 +495,8 @@ struct dsa_switch {
>  	unsigned int		max_num_bridges;
>  
>  	unsigned int		num_ports;
> +
> +	struct completion	inband_done;
>  };
>  
>  static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
> @@ -1390,6 +1392,17 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
>  void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
>  				unsigned int count);
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout);

Blank line please.

> +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> +{
> +	/* Custom completion? */
> +	if (completion)
> +		complete(completion);
> +	else
> +		complete(&ds->inband_done);
> +}
> +
>  #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
>  static int __init dsa_tag_driver_module_init(void)			\
>  {									\
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index be7b320cda76..2d7add779b6f 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -324,6 +324,34 @@ int dsa_switch_resume(struct dsa_switch *ds)
>  EXPORT_SYMBOL_GPL(dsa_switch_resume);
>  #endif
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout)
> +{
> +	int ret;
> +	struct completion *com;

Reverse christmas tree. Longest lines first.

> +
> +	/* Custom completion? */
> +	if (completion)
> +		com = completion;
> +	else
> +		com = &ds->inband_done;
> +
> +	reinit_completion(com);
> +
> +	if (skb)
> +		dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
> +	if (ret <= 0) {
> +		dev_dbg(ds->dev, "DSA inband: timeout waiting for answer\n");
> +
> +		return -ETIMEDOUT;
> +	}

It looks like wait_for_completion_timeout() can return a negative
error code. You should return that error code, not replace it with
-ETIMEDOUT. If it returns 0, then it has timed out, and returning
-ETIMEDOUT does make sense. If the completion is indicated before the
timeout, the return value is the remaining time. So you can return a
positive number here. It is worth documenting that, since a common
patterns is:

	err = dsa_switch_inband_tx()
	if (err)
		return err;

does not work in this case.

     Andrew
