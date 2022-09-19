Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867AA5BD82B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiISXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiISXVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:21:44 -0400
Received: from mailhost.m5p.com (mailhost.m5p.com [74.104.188.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB9711A12
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:21:40 -0700 (PDT)
Received: from m5p.com (mailhost.m5p.com [IPv6:2001:470:1f07:15ff:0:0:0:f7])
        by mailhost.m5p.com (8.16.1/8.15.2) with ESMTPS id 28JNLRj0093396
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 19 Sep 2022 19:21:33 -0400 (EDT)
        (envelope-from ehem@m5p.com)
Received: (from ehem@localhost)
        by m5p.com (8.16.1/8.15.2/Submit) id 28JNLRQU093395;
        Mon, 19 Sep 2022 16:21:27 -0700 (PDT)
        (envelope-from ehem)
Date:   Mon, 19 Sep 2022 16:21:27 -0700
From:   Elliott Mitchell <ehem+xen@m5p.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Xen developer discussion <xen-devel@lists.xenproject.org>,
        netdev@vger.kernel.org
Subject: Re: Layer 3 (point-to-point) netfront and netback drivers
Message-ID: <Yyj5d0uTeXLGmvLK@mattapan.m5p.com>
References: <YycSD/wJ9pL0VsFD@itl-email>
 <YyjVQxmIujBMzME3@mattapan.m5p.com>
 <Yyjh+EfCbiAI4vqi@itl-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyjh+EfCbiAI4vqi@itl-email>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 05:41:05PM -0400, Demi Marie Obenour wrote:
> On Mon, Sep 19, 2022 at 01:46:59PM -0700, Elliott Mitchell wrote:
> > On Sun, Sep 18, 2022 at 08:41:25AM -0400, Demi Marie Obenour wrote:
> > > How difficult would it be to provide layer 3 (point-to-point) versions
> > > of the existing netfront and netback drivers?  Ideally, these would
> > > share almost all of the code with the existing drivers, with the only
> > > difference being how they are registered with the kernel.  Advantages
> > > compared to the existing drivers include less attack surface (since the
> > > peer is no longer network-adjacent), slightly better performance, and no
> > > need for ARP or NDP traffic.
> > 
> > I've actually been wondering about a similar idea.  How about breaking
> > the entire network stack off and placing /that/ in a separate VM?
> 
> This is going to be very hard to do without awesome but difficult
> changes to applications.  Switching to layer 3 links is a much smaller
> change that should be transparent to applications.

Indeed for ones which modify network settings, but not for ones which
merely use the sockets API.  Isn't this the same issue for what you're
suggesting?

(I'm suggesting pushing more into a separate VM, but the principle is the
same)


> > One use for this is a VM could be constrained to *exclusively* have
> > network access via Tor.  This would allow a better hidden service as it
> > would have no network topology knowledge.
> 
> That is great in theory, but in practice programs will expect to use
> network protocols to connect to Tor.  Whonix already implements this
> with the current Xen netfront/netback.

Whonix is wrapping at layer 2 and simply NATing everything.  I'm
suggesting cutting at a higher layer.

> > The other use is network cards which are increasingly able to handle more
> > of the network stack.  The Linux network team have been resistant to
> > allowing more offloading, so perhaps it is time to break *everything*
> > off.
> 
> Do you have any particular examples?  The only one I can think of is
> that Linux is not okay with TCP offload engines.

That is precisely what I was thinking of.  While I understand the desire
for control, when it comes down to it a network card which lies could
simply transparently proxy everything.  Anything not protected by
cryptography is vulnerable, so worrying about raw packets doesn't seem
useful.

> > I'm unsure the benefits would justify the effort, but I keep thinking of
> > this as the solution to some interesting issues.  Filtering becomes more
> > interesting, but BPF could work across VMs.
> 
> Classic BPF perhaps, but eBPF's attack surface is far too large for this
> to be viable.  Unprivileged eBPF is already disabled by default.

I was thinking of classic BPF.  If everything below the sockets layer
was in a separate VM, filtering rules could still work by pushing BPF
rules to the other side.


Your idea is to push less into a separate VM than I was thinking.  I
wanted to bring up it might be worthwhile pushing more.  If your project
launches I imagine eventually you'll be trying to encompass more, so it
may be easier to consider what the future will hold.


-- 
(\___(\___(\______          --=> 8-) EHM <=--          ______/)___/)___/)
 \BS (    |         ehem+sigmsg@m5p.com  PGP 87145445         |    )   /
  \_CS\   |  _____  -O #include <stddisclaimer.h> O-   _____  |   /  _/
8A19\___\_|_/58D2 7E3D DDF4 7BA6 <-PGP-> 41D1 B375 37D0 8714\_|_/___/5445


