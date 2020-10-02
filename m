Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F877281EA8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJBWxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJBWxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 18:53:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 634AC206DD;
        Fri,  2 Oct 2020 22:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601679211;
        bh=AdH5r23f44NBzy/7Jdol5t7cEpzWyHN7rzujGw24RKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LkgLBS4N9jykbHkEJaJVXnFE8r6JHOCbCqJD5phBqVLAKGok7jYjoBcsSxbdwie1z
         hqHRzrFWgZKlSC3MHTGZLNFd1cBgfiKBFHJG18//jc0Oi3iR2JF9iA9nMNQ1yhBqMh
         tYGDeTm/VyiPCCG07qF4EFR0vcgUsj9pxfJcXLAE=
Date:   Fri, 2 Oct 2020 15:53:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
Message-ID: <20201002155329.3bb56911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_DWVGV9hOh3CcuWPcxSDmOSb94qHMft-o+Ts8KNoKqxxQ@mail.gmail.com>
References: <20200930192140.4192859-1-weiwan@google.com>
        <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
        <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DukokJByTLp4QeGRrbNgC-hb9P6YX5Qh=UswPubrEnVA@mail.gmail.com>
        <20201001164652.0e61b810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DWVGV9hOh3CcuWPcxSDmOSb94qHMft-o+Ts8KNoKqxxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 18:44:40 -0700 Wei Wang wrote:
> > Can you share relative performance delta of this banchmark?
> >
> > Could you explain why threads are slower than ksoftirqd if you pin the
> > application away? From your cover letter it sounded like you want the
> > scheduler to see the NAPI load, but then you say you pinned the
> > application away from the NAPI cores for the test, so I'm confused.
> 
> No. We did not explicitly pin the application threads away.
> Application threads are free to run anywhere. What we do is we
> restrict the NAPI kthreads to only those CPUs handling rx interrupts.

Whatever. You pin the NAPI threads and hand-tune their number so the
load of the NAPI CPUs is always higher. If the workload changes the
system will get very unhappy.

> (For us, 8 cpus out of 56.) So the load on those CPUs are very high
> when running the test. And the scheduler is smart enough to avoid
> using those CPUs for the application threads automatically.
> Here is the results of 1 representative test result:
>                      cpu/op   50%tile     95%tile       99%tile
> base            71.47        417us      1.01ms          2.9ms
> kthread         67.84       396us      976us            2.4ms
> workqueue   69.68       386us      791us             1.9ms

Did you renice ksoftirqd in "base"?

> Actually, I remembered it wrong. It does seem workqueue is doing
> better on latencies. But cpu/op wise, kthread seems to be a bit
> better.

Q.E.D.
