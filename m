Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F656F2B6A
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 00:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjD3Wmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 18:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjD3Wmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 18:42:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A83C1A6;
        Sun, 30 Apr 2023 15:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IUE5amqL9BucAB7kjVHcdUTO9lbn54HNTdXpB2O3GWo=; b=S5G4muzsQiNHompW+/7NLfCi/j
        a1S/2mXy0uwc0m2pZSf/OvblklkSFzoQNL9rCj6Q21uM4CqsPKPDA+5xQTuYV0T27F5q19uwMmzDf
        WYBhCwtFMjSUkxndoLQJoFsViJ0BSq/G196+VTFiPeNYZ/Z33GjdA0kQ3HKGT33Ui2h4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ptFkJ-00BZoa-Fk; Mon, 01 May 2023 00:42:19 +0200
Date:   Mon, 1 May 2023 00:42:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 05/11] leds: trigger: netdev: introduce validating
 requested mode
Message-ID: <43f6a729-7003-4d52-b806-964dec4f9447@lunn.ch>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <20230427001541.18704-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427001541.18704-6-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -168,7 +174,7 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
>  				     size_t size, enum led_trigger_netdev_modes attr)
>  {
>  	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
> -	unsigned long state;
> +	unsigned long state, new_mode = trigger_data->mode;
>  	int ret;
>  	int bit;
>  
> @@ -186,12 +192,18 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
>  		return -EINVAL;
>  	}
>  
> -	cancel_delayed_work_sync(&trigger_data->work);
> -
>  	if (state)
> -		set_bit(bit, &trigger_data->mode);
> +		set_bit(bit, &new_mode);
>  	else
> -		clear_bit(bit, &trigger_data->mode);
> +		clear_bit(bit, &new_mode);
> +
> +	ret = validate_requested_mode(trigger_data, new_mode);
> +	if (ret)
> +		return ret;
> +
> +	cancel_delayed_work_sync(&trigger_data->work);
> +
> +	trigger_data->mode = new_mode;
>  
>  	set_baseline_state(trigger_data);

I think you need to hold the trigger_data lock here, otherwise there
are potential race conditions.

    Andrew
