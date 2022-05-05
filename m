Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3E51B51C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbiEEBOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiEEBOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:14:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A474C79B;
        Wed,  4 May 2022 18:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YZ3u0VP+Dmz+bUwsOr46MWuxSWaaRBaF3I0ZydiCLpA=; b=wDsc0R4sL6hPDSTF0noRMQfruf
        mzz4NVOEq4T1/rAJmnOh6QDn2l/0XMSNDTDGyIGfHQ5zS9HgzG51JGSruyZqaQqfCKhngFbzP/mHg
        DZ8u9OGlibmBwMEKD7zOeInXcHL6iTbqIc1sSoQyx8UFTYKOchdZ+LltLkiFW85QXJXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmQ0b-001Hnn-Jk; Thu, 05 May 2022 03:10:21 +0200
Date:   Thu, 5 May 2022 03:10:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 07/11] leds: trigger: netdev: use mutex instead of
 spinlocks
Message-ID: <YnMj/SY8BhJuebFO@lunn.ch>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503151633.18760-8-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -400,7 +400,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
>  
>  	cancel_delayed_work_sync(&trigger_data->work);
>  
> -	spin_lock_bh(&trigger_data->lock);
> +	mutex_lock(&trigger_data->lock);

I'm not sure you can convert a spin_lock_bh() in a mutex_lock().

Did you check this? What context is the notifier called in?

    Andrew
