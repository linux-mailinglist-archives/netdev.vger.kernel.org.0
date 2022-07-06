Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953F6568E6E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiGFPzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiGFPzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:55:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2122E9;
        Wed,  6 Jul 2022 08:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAAC66206E;
        Wed,  6 Jul 2022 15:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A657C3411C;
        Wed,  6 Jul 2022 15:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657122940;
        bh=aA4JALtTjKfWpGQsJjku07uWAxF2Bd6rRbc4dnHeKfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8iJ3KGWzblrvf0KV7G2zKHGi056n0Og5GrRvhY4FbPR1YPYo1dfV7xySBaKFmBmq
         8x0+c7szTMAEyuvB26IeeXdfFGd/+kd7nwoalbOtQJGD8aayWlKZK23jkPH6vaM4KU
         BTbmtIcP0tRsxBKxsSEQJ01nr3ICrMxJFabzD36M=
Date:   Wed, 6 Jul 2022 17:55:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH RFC] net: dsa: qca8k: move driver to qca dir
Message-ID: <YsWwebvaTcsERXGq@kroah.com>
References: <20220630134606.25847-1-ansuelsmth@gmail.com>
 <20220706153904.jtu2qxczjjcgcoty@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706153904.jtu2qxczjjcgcoty@skbuf>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 06:39:04PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 30, 2022 at 03:46:06PM +0200, Christian Marangi wrote:
> > Move qca8k driver to qca dir in preparation for code split and
> > introduction of ipq4019 switch based on qca8k.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> > 
> > Posting this as a RFC to discuss the problems of such change.
> > 
> > This is needed as in the next future the qca8k driver will be split
> > to a common code. This needs to be done as the ipq4019 is based on qca8k
> > but will have some additional configuration thing and other phylink
> > handling so it will require different setup function. Aside from these
> > difference almost all the regs are the same of qca8k.
> > 
> > For this reason keeping the driver in the generic dsa dir would create
> > some caos and I think it would be better to move it the dedicated qca
> > dir.
> > 
> > This will for sure creates some problems with backporting patch.
> > 
> > So the question is... Is this change acceptable or we are cursed to
> > keeping this driver in the generic dsa directory?
> > 
> > Additional bonus question, since the ethernet part still requires some
> > time to get merged, wonder if it's possible to send the code split with
> > qca8k as the only user (currently) and later just add the relevant
> > ipq4019 changes.
> > 
> > (this ideally is to prepare stuff and not send a big scary series when
> > it's time to send ipq4019 changes)
> 
> I think we discussed this before. You can make the driver migration but
> you need to be willing to manually backport bug fixes if/when the stable
> team reports that backporting to a certain kernel failed. It has been
> done before, see commit a9770eac511a ("net: mdio: Move MDIO drivers into
> a new subdirectory") as an example. I think "git cherry-pick" has magic
> to detect file movement, while "git am" doesn't. Here I'm not 100%
> certain which command is used to backport to stable. If it's by cherry
> picking it shouldn't even require manual intervention.

People move files around in the kernel all the time, it's not a big deal
and should never be an issue (i.e. don't worry about stable backports.)
Normally we can handle the move easily, and if not, we will punt to the
developer and ask if they want to do the backport if they feel it is
necessary.

So this should not be an issue for anything here.

thanks,

greg k-h
