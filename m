Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5682D334D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgLHUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
Date:   Tue, 8 Dec 2020 11:38:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607456307;
        bh=4xIgevDP7/ZGGz5vmkJ8zIO+NIU+cuUQaVaBwbzuc5I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=puG9BwYSAJ7e6ZPqIbzIEvMJoNdGD/nRqvjr61QKZuIR24H2WQ/1pK7kkTZWTVyVC
         D8kmlJ/J7d93CeBddN9+EEWdT0Y3L7t5V73jXEqdFRXKY2LtLv2P/P6K6Lr7NeqENU
         Uwd6Do5ZhKj9PKHpA4LnwicRabU4+KaOiL3DF9yD0IOsY3coqpFmnAo1kTzbqwnK7b
         kzZdF2sW2PAUfeDcKLJm2KmQCjfTXCfsRSaa2soFiffrtXdMkP+dNMDXcETYfOfARj
         o3e6m0PsFJYo6u8CaP2lnbReOYw5tiJgxfoG5ddH/wh+qsO7dkAO07xvAC8O0k45Gw
         lhdFoy7/3V6cw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: reduce rtnl lock contention in mii monitor
 thread
Message-ID: <20201208113820.179ed5ca@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205234354.1710-1-jarod@redhat.com>
References: <20201205234354.1710-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 18:43:54 -0500 Jarod Wilson wrote:
> I'm seeing a system get stuck unable to bring a downed interface back up
> when it's got an updelay value set, behavior which ceased when logging
> spew was removed from bond_miimon_inspect(). I'm monitoring logs on this
> system over another network connection, and it seems that the act of
> spewing logs at all there increases rtnl lock contention, because
> instrumented code showed bond_mii_monitor() never able to succeed in it's
> attempts to call rtnl_trylock() to actually commit link state changes,
> leaving the downed link stuck in BOND_LINK_DOWN. The system in question
> appears to be fine with the log spew being moved to
> bond_commit_link_state(), which is called after the successful
> rtnl_trylock().

But it's not called under rtnl_lock AFAICT. So something else is also
spewing messages?

While bond_commit_link_state() _is_ called under the lock. So you're
increasing the retry rate, by putting the slow operation under the
lock, is that right?

Also isn't bond_commit_link_state() called from many more places?
So we're adding new prints, effectively?

> I'm actually wondering if perhaps we ultimately need/want
> some bond-specific lock here to prevent racing with bond_close() instead
> of using rtnl, but this shift of the output appears to work. I believe
> this started happening when de77ecd4ef02 ("bonding: improve link-status
> update in mii-monitoring") went in, but I'm not 100% on that.
> 
> The addition of a case BOND_LINK_BACK in bond_miimon_inspect() is somewhat
> separate from the fix for the actual hang, but it eliminates a constant
> "invalid new link 3 on slave" message seen related to this issue, and it's
> not actually an invalid state here, so we shouldn't be reporting it as an
> error.

Let's make it a separate patch, then.
