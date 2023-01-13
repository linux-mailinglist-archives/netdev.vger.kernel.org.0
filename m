Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD5669A47
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAMOdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjAMOcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:32:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEECC2675;
        Fri, 13 Jan 2023 06:25:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00EEA61EEC;
        Fri, 13 Jan 2023 14:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA2C433D2;
        Fri, 13 Jan 2023 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673619926;
        bh=1pZBYp1XzZda5BFRWCG19b48xYjRl0QwW3PCvy5dCgE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OjLb9b1eE9wS0eoLqvu7ZMjLTvH1hAGXXwECuE/dLadjS/HIcs6XAJXUUN6DkgqDY
         tJZALLc/MrgYJhJoCeHG5/TvOIBfHvjc6zMklxhdFUSd8PI/a58zB8XXsKks6Wy5i1
         oQOWg0nPQjKBV7h78ug4XotrRfF1PprOJ5WYr2aMdUYgbsyw0Joplmolf3pyZ1YoTp
         VX+4u8o8wts9idIbu4VlIPdX+cXcORn5EYVct7tYXgoTdPGv+joCPaioCbKaUKTlzS
         iO5zSh32asg931jtKi0LDZo9rzjDrD/mWD/OLAwFg8EPpZHaqe/zZ6Aw551WIwy+in
         ztYb0kuOw9M2Q==
Message-ID: <64bf2456-e1cb-3b4a-af19-454cf0bb86aa@kernel.org>
Date:   Fri, 13 Jan 2023 16:25:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS
 release action
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
References: <20230113104816.132815-1-s-vadapalli@ti.com>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230113104816.132815-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/01/2023 12:48, Siddharth Vadapalli wrote:
> The am65_cpts_release() function is registered as a devm_action in the
> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
> actions associated with the am65-cpsw driver's device.
> 
> In the event of probe failure or probe deferral, the platform_drv_probe()
> function invokes dev_pm_domain_detach() which powers off the CPSW and the
> CPSW's CPTS hardware, both of which share the same power domain. Since the
> am65_cpts_disable() function invoked by the am65_cpts_release() function
> attempts to reset the CPTS hardware by writing to its registers, the CPTS
> hardware is assumed to be powered on at this point. However, the hardware
> is powered off before the devm actions are executed.
> 
> Fix this by getting rid of the devm action for am65_cpts_release() and
> invoking it directly on the cleanup and exit paths.
> 
> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>

cheers,
-roger
