Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031A2280B66
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbgJAXqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJAXqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:46:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F022075F;
        Thu,  1 Oct 2020 23:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601596014;
        bh=HerJfWWdVfwEXWa4x6wZOtf30yLbR0nrjSxkg/L8RJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ol2Q18mKPAv9ro3CJu80UkoCFeK7WdCbO1B7zAxDr6q8HzGXHHL1PtMCpjYkHmjPQ
         gTKhYC3zgvcst7Xl+XLo9tK4Z3Qi7yZZazg6hoRkw0YLi4IiOwZ/F5S/HRzTm03AIs
         j5RkHCV8/dxf1g/sj+k5vnohUTK+qD5Ec599ebic=
Date:   Thu, 1 Oct 2020 16:46:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
Message-ID: <20201001164652.0e61b810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_DukokJByTLp4QeGRrbNgC-hb9P6YX5Qh=UswPubrEnVA@mail.gmail.com>
References: <20200930192140.4192859-1-weiwan@google.com>
        <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK2-Wu8HMkWiD8U3pdRbwj2tjng-4-fJ81zVw_a3R6OqQ@mail.gmail.com>
        <20201001132607.21bcaa17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DukokJByTLp4QeGRrbNgC-hb9P6YX5Qh=UswPubrEnVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 15:12:20 -0700 Wei Wang wrote:
> Yes. I did a round of testing with workqueue as well. The "real
> workload" I mentioned is a google internal application benchmark which
> involves networking  as well as disk ops.
> There are 2 types of tests there.
> 1 is sustained tests, where the ops/s is being pushed to very high,
> and keeps the overall cpu usage to > 80%, with various sizes of
> payload.
> In this type of test case, I see a better result with the kthread
> model compared to workqueue in the latency metrics, and similar CPU
> savings, with some tuning of the kthreads. (e.g., we limit the
> kthreads to a pool of CPUs to run on, to avoid mixture with
> application threads. I did the same for workqueue as well to be fair.)

Can you share relative performance delta of this banchmark?

Could you explain why threads are slower than ksoftirqd if you pin the
application away? From your cover letter it sounded like you want the
scheduler to see the NAPI load, but then you say you pinned the
application away from the NAPI cores for the test, so I'm confused.

> The other is trace based tests, where the load is based on the actual
> trace taken from the real servers. This kind of test has less load and
> ops/s overall. (~25% total cpu usage on the host)
> In this test case, I observe a similar amount of latency savings with
> both kthread and workqueue, but workqueue seems to have better cpu
> saving here, possibly due to less # of threads woken up to process the
> load.
> 
> And one reason we would like to push forward with 1 kthread per NAPI,
> is we are also trying to do busy polling with the kthread. And it
> seems a good model to have 1 kthread dedicated to 1 NAPI to begin
> with.

And you'd pin those busy polling threads to a specific, single CPU, too?
1 cpu : 1 thread : 1 NAPI?
