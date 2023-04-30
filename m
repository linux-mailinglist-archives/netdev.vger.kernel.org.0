Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4316F2A2D
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjD3SIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjD3SIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:08:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EA52D67;
        Sun, 30 Apr 2023 11:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/d/ZEszhW30qZrVlUU36K4Posqf8iHlf+AhyLNI5JVU=; b=hUwmFd+5iBoMxu7Z1eDhqta3Ma
        F7jqSep2gK5m4EAT/E+cufTc0AwqdeVulJkBNdKX0wv07AyC743PALjYxPoWmww9bd6mfZJkaUJXl
        MxoflGX0kRi9LlLgDZA3jnkiubiiVAFik1tSIZh1boZWaiH3Yo8FnIcQijj4VRgwoAkk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ptBTP-00BZ1G-3X; Sun, 30 Apr 2023 20:08:35 +0200
Date:   Sun, 30 Apr 2023 20:08:35 +0200
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
Subject: Re: [PATCH 02/11] leds: add binding to check support for LED hw
 control
Message-ID: <71cde8c3-527d-4072-a05f-a463c5d3bf43@lunn.ch>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <20230427001541.18704-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427001541.18704-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/*
> +	 * Check if the LED driver supports the requested mode provided by the
> +	 * defined supported trigger to setup the LED to hw control mode.
> +	 */
> +	int			(*hw_control_is_supported)(struct led_classdev *led_cdev,
> +							   unsigned long flags);

Hi Christian

This needs better documentation. What is the expected return value? My
initial implementation for the Marvell driver did not work. I returned
-EINVAL if it was not supported and some value >= 0 if it was
supported. And most times, it was > 0, not 0.

However, when i look at the trigger code:

	/* Check if the requested mode is supported */
	ret = led_cdev->hw_control_is_supported(led_cdev, hw_mode);
	if (ret)
		return ret;

	*can_use_hw_control = true;

Anything other than 0 means it is not supported.

	 Andrew
