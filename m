Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1F6C5BA6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjCWBEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 21:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCWBEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 21:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38AB27986
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6766D6237C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3EAC433D2;
        Thu, 23 Mar 2023 01:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679533448;
        bh=yTkGinnidb0wxvyc4GgIs0dymE4OLoIYT3gTmzhMqQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TpfitazGTdU2d8RVtXtYaK1/I4rfYwX50WbkTqyGud4lAYs7vAN9zm4lHePUQJmuz
         R+RC/5kKrhqvgoVAJwT7TRv98QH3Xi4Yzh4I6SNYpjZtm4aNXX4wGUwklsWWXuzUOQ
         EGIoEM+NT9EUUodOS2meZwyhPy2ySl7vTQrRrRv7AO7tNyYyb4GPcDFXXQZKi/vpnY
         ytVHmhl7IMBtrDATGaIjrodA7mc0N50l+xgZ/AkFJRA18Hd7G4vnt/sjPpLgfXXWKv
         JW2X1QFr6OmkxKrB6K7hKBffQTgTUunkBIVDBiIwjfkkBQ7hr+JEI3PYFS2MUxybwM
         ggsRKGrdm3JBA==
Date:   Wed, 22 Mar 2023 18:04:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, alexander.duyck@gmail.com,
        michael.chan@broadcom.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230322180406.2a46c3bd@kernel.org>
In-Reply-To: <06d6a33e-60d4-45ea-b928-d3691912b85e@lunn.ch>
References: <20230322233028.269410-1-kuba@kernel.org>
        <06d6a33e-60d4-45ea-b928-d3691912b85e@lunn.ch>
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

CC: maintainers, in case there isn't a repost
https://lore.kernel.org/all/20230322233028.269410-1-kuba@kernel.org/

On Thu, 23 Mar 2023 01:35:34 +0100 Andrew Lunn wrote:
> On Wed, Mar 22, 2023 at 04:30:26PM -0700, Jakub Kicinski wrote:
> > A lot of drivers follow the same scheme to stop / start queues
> > without introducing locks between xmit and NAPI tx completions.
> > I'm guessing they all copy'n'paste each other's code.
> >
> > Smaller drivers shy away from the scheme and introduce a lock
> > which may cause deadlocks in netpoll.  
> 
> I notice there is no patch 0/X. Seems like the above would be good
> material for it, along with a comment that a few drivers are converted
> to make use of the new macros.

Then do I repeat the same text in the commit? Or cut the commit down?
Doesn't that just take away information from the commit which will
show up in git blame?

Having a cover letter is a good default, and required if the series 
is a larger change decomposed into steps. But here there is a major
change and a bunch of loose conversions. More sample users than
meaningful part.

LMK what your preference for splitting this info is, I'm unsure.
