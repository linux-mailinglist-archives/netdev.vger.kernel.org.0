Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AA34F818F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343925AbiDGO11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343922AbiDGO10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:27:26 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596121890F5;
        Thu,  7 Apr 2022 07:25:19 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D9F2A22175;
        Thu,  7 Apr 2022 16:25:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649341517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=abVSGUtVqh7YhBzozb2Ledi0KRyuVzhaDaQwQ2/xe4Q=;
        b=EUE9hI39dJT14mTtuO4CnjNi7TIu3w38uphBJJcD6Z5vko9UdKCQ0fT5QUqll9IAryTuxf
        M5Y3Jpq7YGIJb/XIiK4aeOS9iihzryK3QU3GhRF+ax0mzVfIK53R5JsU6Px4ysrXrEs64u
        VaxFGDkCBipV60YHTZhEpnuaqSPI6iI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Apr 2022 16:25:16 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
In-Reply-To: <20220407141254.3kpg75l4byytwfye@skbuf>
References: <20220407130625.190078-1-michael@walle.cc>
 <20220407135613.rlblrckb2h633bps@skbuf>
 <cd433399998c2f58884f08b4fc0fd66a@walle.cc>
 <20220407141254.3kpg75l4byytwfye@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <30ea2ed5bcc7e9c97d132ea30a8dd774@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-04-07 16:12, schrieb Vladimir Oltean:
> On Thu, Apr 07, 2022 at 04:04:20PM +0200, Michael Walle wrote:
>> Am 2022-04-07 15:56, schrieb Vladimir Oltean:
>> > On Thu, Apr 07, 2022 at 03:06:25PM +0200, Michael Walle wrote:
>> > > Due to missing prerequisites the probe of the felix switch might be
>> > > deferred:
>> > > [    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA
>> > > switch: -517
>> > >
>> > > It's not an error. Use dev_err_probe() to demote the error to a debug
>> > > message. While at it, replace all the dev_err()'s in the probe with
>> > > dev_err_probe().
>> > >
>> > > Signed-off-by: Michael Walle <michael@walle.cc>
>> > > ---
>> >
>> > Please limit the dev_err_probe() to dsa_register_switch(). The resource
>> > that is missing is the DSA master, see of_find_net_device_by_node().
>> > The others cannot possibly return -EPROBE_DEFER.
>> 
>> This was my rationale (from the function doc):
>> 
>>  * Note that it is deemed acceptable to use this function for error
>>  * prints during probe even if the @err is known to never be 
>> -EPROBE_DEFER.
>>  * The benefit compared to a normal dev_err() is the standardized 
>> format
>>  * of the error code and the fact that the error code is returned.
>> 
>> In any case I don't have a strong opinion.
> 
> Take this case:
> 
>  		err = -ENOMEM;
> -		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
> +		dev_err_probe(&pdev->dev, err, "Failed to allocate driver 
> memory\n");
> 
> (1) there is no need to print ENOMEM if we say "failed to allocate 
> memory"

That was actually a brain fart of mine ;) But AFAIK there is no need in
reporting ENOMEM errors anyway.

-michael

> (2) we don't use the return value of dev_err_probe() anyway, we have
>     actual teardown to do (pci_disable_device).
> (3) we _surely_ know that -ENOMEM != -EPROBE_DEFER
>> 
>> > >
>> > > Should this be a patch with a Fixes tag?
>> >
>> > Whichever way you wish, no preference.
>> 
>> I'll limit it to just the one dev_err() and add a Fixes,
>> there might be scripts out there who greps dmesg for errors.
> 
> Ok.
