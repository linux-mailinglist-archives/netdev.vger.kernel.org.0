Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E837B345
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 03:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhELBJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 21:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhELBJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 21:09:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E498261287;
        Wed, 12 May 2021 01:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620781674;
        bh=vejHMAxGc7FiC9+wxTvA61RKkqkP17oM46Z9lf4hYHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jfEvZqFFUIY6ZjHbdTdZnyVTF+Pu9St3VJEgbTruMx9Mna0Gu+S0ITgda74xLVuXB
         mVXwZj3P8juUQaeOHzTMgppUVrqGcpgkLVEAmALD8kw12UDbAEHhTUmirYABKTapB5
         IRSEnN6qwZS8/ukleFca5AM3RIAQN/ie9iFe40cf8/PYgJnaqiGw/X39rTJKH15YXr
         B4Nd/xhNu736fJzxmWEzS9GznDjGg3eejAdJ9PJ2NionxHAnXxeYxYIqW5vwvl7T4n
         N6ySD+q686p5/BTcUfMureaXMMmzdNXHbJEaFEjs19fwOXRzhZ9Hxq+Kqrm5Fi+Hbc
         iAb+ca1fNwY6w==
Date:   Tue, 11 May 2021 18:07:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [RFC PATCH net-next v1 0/2] Threaded NAPI configurability
Message-ID: <20210511180752.5d51da1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <aab2fda9-b838-e367-75ef-3a0e13d066b3@oss.nxp.com>
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
        <20210506151837.27373dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <aab2fda9-b838-e367-75ef-3a0e13d066b3@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 May 2021 18:46:16 +0200 Yannick Vignon wrote:
> On 5/7/2021 12:18 AM, Jakub Kicinski wrote:
> > On Thu,  6 May 2021 19:20:19 +0200 Yannick Vignon wrote:  
> >> The purpose of these 2 patches is to be able to configure the scheduling
> >> properties (e.g. affinity, priority...) of the NAPI threads more easily
> >> at run-time, based on the hardware queues each thread is handling.
> >> The main goal is really to expose which thread does what, as the current
> >> naming doesn't exactly make that clear.
> >>
> >> Posting this as an RFC in case people have different opinions on how to
> >> do that.  
> > 
> > WQ <-> CQ <-> irq <-> napi mapping needs an exhaustive netlink
> > interface. We've been saying this for a while. Neither hard coded
> > naming schemes nor one-off sysfs files are a great idea IMHO.
> 
> Could you elaborate on the kind of netlink interface you are thinking about?
> We already have standard ways of configuring process priorities and 
> affinities, what we need is rather to expose which queue(s) each NAPI 
> thread/instance is responsible for (and as I just said, I fear this will 
> involve driver changes).

An interface to carry information about the queues, interrupts and NAPI
instances, and relationship between them. 

As you noted in your reply to Eric such API would require driver
changes, but one driver using it is enough to add the API.

> Now, one place were a netlink API could be of use is for statistics: we 
> currently do not have any per-queue counters, and that would be useful 
> when working on multi-queue setups.

Yup, such API is exactly where we should add standard per queue
statistics.
