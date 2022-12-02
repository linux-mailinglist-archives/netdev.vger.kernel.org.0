Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320D5640E94
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiLBTgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiLBTgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:36:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C51BF3F8F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 11:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2955362213
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 19:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512D9C433C1;
        Fri,  2 Dec 2022 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670009783;
        bh=LOEiNCITPHOMuu6xenIRrgJ2u9jFxfM8/xsOdf3SS7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LnwUbEnMGiB8uSORU8VQCkrp+KMyqui8EGyV3cDrzyl498d5BotLsJWmbeeQWbflr
         Rn5IgryVOaPkrycDDpCorIOzEBVLHRYgmOIJ553U+0/RkBysTey0FDRcyg8ISaxc1Z
         lsB3Wnch8Kc4d3n9pNiVN83QsbTJPBMOhnNIkZP3rR+9F+cyZ1sHuupqbKZIz6huQQ
         K6MimgnTD/E94zE8RnQVdYNBCpc/N3GtAVtIof10rURVHbXgBlMVbJP5/YJNSE8mNH
         LeqNSWI0QHP5trCwpkPpfJqCPD6BzprQvKrAvEEG5BAIcjSeM0bfrIAQ8QuAPrcDCP
         tvuxXl4ITGpyg==
Date:   Fri, 2 Dec 2022 11:36:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Jerry.Ray@microchip.com>
Cc:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221202113622.21289116@kernel.org>
In-Reply-To: <MWHPR11MB169342D6B1CC71B8805A741AEF179@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
        <20221130205651.4kgh7dpqp72ywbuq@skbuf>
        <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
        <20221201084559.5ac2f1e6@kernel.org>
        <MWHPR11MB169342D6B1CC71B8805A741AEF179@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 15:22:55 +0000 Jerry.Ray@microchip.com wrote:
> >Huh? I'm guessing you're referring to some patches you have queued
> >already and don't want to rebase across? Or some project planning?
> >Otherwise I don't see a connection :S
> 
> In looking around at other implementations, I see where the link_up
> and link_down are used to start or clean up the periodic workqueue
> used to retrieve and accumulate the mib stats into the driver.  Can't tell
> if that's a requirement or only needed when the device interface is
> considered too slow.  The device interface is not atomic.

Atomic as in it reads over a bus which requires sleeping?
Yes, the stats ndo can't sleep because of the old procfs interface
which ifconfig uses and which is invoked under the RCU lock.
