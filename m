Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F4D6DA78D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbjDGCMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbjDGCMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:12:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7421AC;
        Thu,  6 Apr 2023 19:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE08E64E8A;
        Fri,  7 Apr 2023 02:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06F0C433A7;
        Fri,  7 Apr 2023 02:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680832930;
        bh=irhquyIMOLv8aFbHLZ/CLVb/o6ZsppXDK0dippASpfg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L9N4xh16jzWS8SndxFsXU41qyS5Vl1UEfU/z51m2/CKjgnrNuwNFmAYAqG1aikaq2
         BqppE7yDJ+nz+HpsZzKa+uF6KQp084WJhKjx3VfmU+5YZEJ3+5grvUujhKGJRJW7sl
         sxD/lG2SbHaT6MHoNNDo/DpCPv9rdivnknbUrUsoq5Y/H4bVHNeJ8XHgA95FYFX9Hp
         2Sshhuc7aE5hN33wPxYKukPAXOovweSqWHUNXNGQ/jnD+H/T9At4S60itzw1jhaGyj
         +gG+fp0/0tz4aHWH8AfjyFkJpJ0MOoKb9mRcwBs1ZbEjcLKIjx+3qjAMMPVEBIhmdm
         v8K62ZqrZyBug==
Date:   Thu, 6 Apr 2023 19:02:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     linux@armlinux.org.uk
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, netdev@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, system@metrotek.ru,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: initialize sfp->i2c_block_size at sfp
 allocation
Message-ID: <20230406190208.7918c71e@kernel.org>
In-Reply-To: <20230405153900.747-1-i.bornyakov@metrotek.ru>
References: <20230405153900.747-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Apr 2023 18:39:00 +0300 Ivan Bornyakov wrote:
> sfp->i2c_block_size is initialized at SFP module insertion in
> sfp_sm_mod_probe(). Because of that, if SFP module was not inserted
> since boot, ethtool -m leads to zero-length I2C read attempt.
> 
>   # ethtool -m xge0
>   i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
>   Cannot get Module EEPROM data: Operation not supported
> 
> If SFP module was plugged then removed at least once,
> sfp->i2c_block_size will be initialized and ethtool -m will fail with
> different error
> 
>   # ethtool -m xge0
>   Cannot get Module EEPROM data: Remote I/O error
> 
> Fix this by initializing sfp->i2_block_size at struct sfp allocation
> stage so ethtool -m with SFP module removed will fail the same way, i.e.
> -EREMOTEIO, in both cases and without errors from I2C adapter.

Hi Russell - yes / no / come back when both patches are ready?
