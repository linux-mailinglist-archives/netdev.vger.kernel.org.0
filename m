Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7376050BA
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJSTur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJSTuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:50:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654DC1C432
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6B3ECE243B
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8876EC433C1;
        Wed, 19 Oct 2022 19:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666209042;
        bh=PvNruB0YkNGydkSJTIcTceCmDV6kFMWdQAGavSxaji4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=psQH0fDyJ8pjXDLEu5O0D4v4WaOvFqvre83eM8dvjaDgCf3X6lN5n+8XcN32n/hQc
         +y3gqgZKnVclbFyfBhEhXaA/KMqom7dIdGIVOuc28tuKzWgZbs0rui8emmzN4AY0bO
         vm4xcotgrcwZHfPMMTBVTIXHauVhG2/QSj89Q2RwJ2GW+qfXBI2Hw7cGnbsobdoBe+
         g7/P2ChvEX8/6JfzOxFM8wR3FMXzBfE8Dz08wapGkVeyhnFOMBOP/D3yAqjV1MAxY3
         5dwIuLQrpQvin1okXzAzQOjue3vy7fyxNEmTf/19M0mBjcgvPSkTyUAuseV3DKIZIH
         7IrYjCWyNectQ==
Date:   Wed, 19 Oct 2022 12:50:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        jiri@nvidia.com, nhorman@tuxdriver.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org
Subject: Re: [PATCH net-next 03/13] genetlink: introduce split op
 representation
Message-ID: <20221019125040.07751ce8@kernel.org>
In-Reply-To: <e5ae37ae75bac9af6d6a7c324acd4e3c97059d50.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-4-kuba@kernel.org>
        <93e9137fb80f63cd13fa226bcca3007c473a74d4.camel@sipsolutions.net>
        <20221019121422.799eee78@kernel.org>
        <e5ae37ae75bac9af6d6a7c324acd4e3c97059d50.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 21:36:00 +0200 Johannes Berg wrote:
> > It's used as an output argument here, so that's what initializes it.
> > genl_get_cmd* should always init the split command because in policy
> > dumping we don't care about the errors, we just want the structure
> > to be zeroed if do/dump is not implemented, and we'll skip accordingly.
> > Wiping the 40B just to write all the fields felt... wrong. 
> > Let KASAN catch us if we fail to init something.  
> 
> KASAN doesn't, I think, you'd need KMSAN?

Quite possibly :S  Too many SANs :S
