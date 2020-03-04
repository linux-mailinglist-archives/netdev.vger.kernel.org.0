Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9AF178B06
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 07:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgCDG5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 01:57:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:52102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbgCDG5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 01:57:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 331A1B265;
        Wed,  4 Mar 2020 06:57:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5650CE037F; Wed,  4 Mar 2020 07:57:38 +0100 (CET)
Date:   Wed, 4 Mar 2020 07:57:38 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] tun: fix ethtool_ops get_msglvl and set_msglvl
 handlers
Message-ID: <20200304065738.GG4264@unicorn.suse.cz>
References: <20200303082252.81F7FE1F46@unicorn.suse.cz>
 <20200303.145916.1506066510928020193.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303.145916.1506066510928020193.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 02:59:16PM -0800, David Miller wrote:
> From: Michal Kubecek <mkubecek@suse.cz>
> Date: Tue,  3 Mar 2020 09:22:52 +0100 (CET)
> 
> > The get_msglvl and setmsglvl handlers only work as expected if TUN_DEBUG
> > is defined (which required editing the source). Otherwise tun_get_msglvl()
> > returns -EOPNOTSUPP but as this handler is not supposed to return error
> > code, it is not recognized as one and passed to userspace as is, resulting
> > in bogus output of ethtool command. The set_msglvl handler ignores its
> > argument and does nothing if TUN_DEBUG is left undefined.
> > 
> > The way to return EOPNOTSUPP to userspace for both requests is not to
> > provide these ethtool_ops callbacks at all if TUN_DEBUG is left undefined.
> > 
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> I agree with your analysis.
> 
> But this TUN_DEBUG thing stands outside of what we let drivers do.  Either
> this tracing is not so useful and can be deleted, or the tracing should
> be available unconditionally so that it can be turned on by the vast
> majority of users who do not edit the source.
> 
> I suspect making the TUN_DEBUG code unconditional is that way to go here.

I started to think in this direction too and ended up with

  - DBG1() macro checks a variable which is never set; it's also used
    only in one place which doesn't seem to differ from others where
    tun_debug() is used
  - many tun_debug() calls can be dropped as they only inform about
    entering a function and sometimes show some if its arguments; we
    have ftrace and kprobes for that
  - the rest should be rewritten to netif_info()
  - the two tun_debug() in packet processing path could use netif_dbg()
    to avoid overhead when not turned on

...which is where I stopped and went with the quick fix instead.

On the other hand, there is no rush, the issue seems to exist since
before git. And unlike some other drivers doing strange things for
debugging, tun is widely used so it deserves a cleanup.

I'll send a patch (or patches) with proper cleanup for net-next.

Michal
