Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F106275FB9
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgIWSXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWSXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 14:23:55 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D55920791;
        Wed, 23 Sep 2020 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600885434;
        bh=TrQfdun7SoFiPD+NMb8LfvrfPYjIpnOfWQJ80CPsUWI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=2HMijDj/Dgw7UAjf3QbnPYfBLVAtToCqwxP99Vk5G6bVMKvdN6X2PqGrHowsfJZ5f
         vxgiqQrl/Bs1LuuN1Hmq4qZNAQnGQVuX5yO0o/p4lc0UTsWmVVUX9VK5cUKbhDwJqa
         l2xPV4mvn6WcZmwcwXyr5hr6rdTx56IFbPbae2bY=
Message-ID: <34193ee66f39b7fd28cd732ff95b00ed1bbbb065.camel@kernel.org>
Subject: Re: [pull request][net-next 00/15] mlx5 Connection Tracking in NIC
 mode
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 23 Sep 2020 11:23:53 -0700
In-Reply-To: <20200923102124.4f54aadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200923062438.15997-1-saeed@kernel.org>
         <20200923102124.4f54aadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-23 at 10:21 -0700, Jakub Kicinski wrote:
> On Tue, 22 Sep 2020 23:24:23 -0700 saeed@kernel.org wrote:
> > This series adds the support for connection tracking in NIC mode,
> > and attached to this series some trivial cleanup patches.
> > 
> > For more information please see tag log below.
> > 
> > Please pull and let me know if there is any problem.
> > This series includes mlx5 updates
> > 
> > 1) Add support for Connection Tracking offload in NIC mode.
> >  1.1) Refactor current flow steering chains infrastructure and
> >       updates TC nic mode implementation to use flow table chains.
> >  1.2) Refactor current Connection Tracking (CT) infrastructure to
> > not
> >       assume E-switch backend, and make the CT layer agnostic to
> >       underlying steering mode (E-Switch/NIC)
> >  1.3) Plumbing to support CT offload in NIC mode.
> > 
> > 2) Trivial code cleanups.
> 
> I'm surprised you need so much surgery here.
> 

Well, we have this problem with most of our switchdev features.. 
the main issue is Switch model vs NIC model, it is not an easy task to
write the offloads to work on any model transparently, since the model
is different so HW configuration will be different, we are lucky in
this series we managed to re-use 95% of the CT code .. 

> Am I understanding correctly that you're talking "switchdev mode" vs
> legacy mode?
> 

Not exactly legacy, Connection tracking for single NIC mode is the
actual use case no sriov involved.

But yes we are taking a feature that was only supported on switchdev
mode and now can also work in single NIC mode.

> Could you add a little bit more color about use cases and challenges?
> 

Will add it to v2.

> What happens to the rules installed in "NIC mode" when you switch to
> "switchdev mode"? IIUC you don't recreated netdevs on switch, right?

We still recreate netdevs, so everything is flushed when netdev is
unregistered, we have an upcoming series that will re-use the same
netdev to become the uplink representor in switchdev mode, in such case
we will block any mode changes until user removes all the TC rules.




