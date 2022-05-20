Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B38052F1DF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352326AbiETRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbiETRsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:48:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFC015FE04
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F383B82A71
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D80BC385A9;
        Fri, 20 May 2022 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653068896;
        bh=UrGh2Mg625kABNVjYHwua76jAnJRoPlXxy7jHzAF+v8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oXR2aE7pnzffb64zkfPODlfJsswljw+QpprEo5GAYhmeaVZ4tM/KWb4MSIhMmVNbi
         6HjI+H2AfUqn9dacTmJyoMB0KeZUrWOmtB7SnOLtOTbeMc/HL04hn/fsSafxT6xr6k
         P7FIXKuUJteDIqmMauDwvwnzTPsdfdBNog+fnfiVrE4Fnn+oApN7h4cuq3rMjCsyl2
         3stALeI/Qc9hv6kTCejoo0Fa1l4vG24ngXf5jN8Ro7doqbcVgAjICb6SeI2cbK6YHk
         HOgeiMSPvEnID51PXDFNxCVU5+oMTR7Fnipbs0O7UZ6XmdJTLwHg3+8/6tMpeH8PlX
         Xn5MRVtJJTrsA==
Date:   Fri, 20 May 2022 10:48:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "moises.veleta" <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        sreehari.kancharla@intel.com, dinesh.sharma@intel.com
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem
 logging
Message-ID: <20220520104814.091709cd@kernel.org>
In-Reply-To: <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
        <20220520103711.5f7f5b45@kernel.org>
        <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 10:42:56 -0700 moises.veleta wrote:
> On 5/20/22 10:37, Jakub Kicinski wrote:
> > On Thu, 19 May 2022 11:27:03 -0700 Moises Veleta wrote:  
> >> +	ret = copy_from_user(skb_put(skb, actual_len), buf, actual_len);
> >> +	if (ret) {
> >> +		ret = -EFAULT;
> >> +		goto err_out;
> >> +	}
> >> +
> >> +	ret = t7xx_port_send_skb(port, skb, 0, 0);
> >> +	if (ret)
> >> +		goto err_out;  
> > We don't allow using debugfs to pass random data from user space
> > to firmware in networking. You need to find another way.  
> 
> 
> Can we use debugfs to send an "on" or "off" commands, wherein the driver 
> then sends special command sequences to the the firmware triggering the 
> modem logging on and off?

On/off for all logging or for particular types of messages?
If it's for all logging can't the act of opening the debugfs 
file be used as on "on" signal and closing as "off"?

Where do the logging messages go?
