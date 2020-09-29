Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEED27D6BB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgI2TTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI2TTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 15:19:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA0D207F7;
        Tue, 29 Sep 2020 19:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601407144;
        bh=g0384LRsmwsk7zANDSUHAHYqQ8NulcRMLzvpw2uRj6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZlQsQqWviRHBvxSXGqmLPU00dzVEAWR6Fx52yuCJvYRlXzMvzwRNvoBrMQaBR0eXK
         EJgT54Vjd9zg1hAvL+jnepJipQ6IwTcGs25zJHORH7fj8p73Fw1onyzQHAgstpz4+T
         iQ8LyrhcTPtFVgffMgKIPlCKmaRp+OFP8Q3Cgmo4=
Date:   Tue, 29 Sep 2020 12:19:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
Message-ID: <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 19:43:36 +0200 Eric Dumazet wrote:
> Wei, this is a very nice work.
> 
> Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.

The problem is for the application I'm testing with this implementation
is significantly slower (in terms of RPS) than Felix's code:

              |        L  A  T  E  N  C  Y       |  App   |     C P U     |
       |  RPS |   AVG  |  P50  |   P99  |   P999 | Overld |  busy |  PSI  |
thread | 1.1% | -15.6% | -0.3% | -42.5% |  -8.1% | -83.4% | -2.3% | 60.6% |
work q | 4.3% | -13.1% |  0.1% | -44.4% |  -1.1% |   2.3% | -1.2% | 90.1% |
TAPI   | 4.4% | -17.1% | -1.4% | -43.8% | -11.0% | -60.2% | -2.3% | 46.7% |

thread is this code, "work q" is Felix's code, TAPI is my hacks.

The numbers are comparing performance to normal NAPI.

In all cases (but not the baseline) I configured timer-based polling
(defer_hard_irqs), with around 100us timeout. Without deferring hard
IRQs threaded NAPI is actually slower for this app. Also I'm not
modifying niceness, this again causes application performance
regression here.

1 NUMA node. 18 NAPI instances each is around 25% of a single CPU.

I was initially hoping that TAPI would fit nicely as an extension 
of this code, but I don't think that will be the case.

Are there any assumptions you're making about the configuration that 
I should try to replicate?
