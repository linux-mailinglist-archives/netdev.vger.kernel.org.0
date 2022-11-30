Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE6D63E305
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiK3WAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiK3WAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B159868C55;
        Wed, 30 Nov 2022 14:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CC1761E18;
        Wed, 30 Nov 2022 22:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E88C433D6;
        Wed, 30 Nov 2022 22:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669845621;
        bh=g3A5KUacfmnin24YJvVDXkFc1IwjJ9SrljQja1I2RAk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=kfxQcS37kn2dP9PpI1Hs39WcA6LINiMrFkbJ32I0NnHEIzMLYE4b+jZx2/xmXpb+a
         GO4wUI+1pYvLRGWx8J/Zb0p9f9xDt2YEBL8oFPvX0rRJvq0nPtEkFNIBKNS4IJ80S4
         h8iEKtnUext+7gMFFs2sARpN78si1qpy48+5ypPgbyna5tH6NiFa6dZX6DaENWSVtw
         G9R1dI2X7hYhAOPlaAvaI3OPsf0eZB//LhFR4qMWOXFbNSNu0iGPEw3ykvTkWQMXTi
         qw+m5aR3yDEM8bm73nlcZX5OJyQf6mHYAYyLiT7R84f9VxAkfyWjREx81asCOOqQ32
         cUZceK/+ZByyg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 473135C051C; Wed, 30 Nov 2022 14:00:21 -0800 (PST)
Date:   Wed, 30 Nov 2022 14:00:21 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of
 call_rcu()
Message-ID: <20221130220021.GZ4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-14-paulmck@kernel.org>
 <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
 <CANn89iKg-Ka96yGFHCUWXtug494eO5i2KU_c8GTPNXDi6mWpYg@mail.gmail.com>
 <20221130214552.GW4001@paulmck-ThinkPad-P17-Gen-1>
 <20221130164949.26282b9a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130164949.26282b9a@gandalf.local.home>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 04:49:49PM -0500, Steven Rostedt wrote:
> On Wed, 30 Nov 2022 13:45:52 -0800
> "Paul E. McKenney" <paulmck@kernel.org> wrote:
> 
> > On Wed, Nov 30, 2022 at 07:37:07PM +0100, Eric Dumazet wrote:
> > > Ah, I see a slightly better name has been chosen ;)  
> > 
> > call_rcu_vite()?  call_rcu_tres_grande_vitesse()?  call_rcu_tgv()?
> > 
> > Sorry, couldn't resist!  ;-)
> 
>   call_rcu_twitter_2_0()  ?

call_rcu_grace_period_finishes_before_it_starts() ?

							Thanx, Paul
