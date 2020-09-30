Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A1927F2FD
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgI3UIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3UIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:08:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F062072E;
        Wed, 30 Sep 2020 20:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601496521;
        bh=8d7C14NSqgOZ/PSqsFsxR8XUIOh/+9WFS+AypZBJi3g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hheF5D97Qhhz3czUWFoPxYADWs1F5ZIqElJdhJwneTaGcMKiee06poff7QgNSb8Ee
         EaKfa2Gp2lBg+t00zV6+8rW2t3wLcdelm6KqnevkEW4KHOCT8KE5jCIuixRUZwEQ8H
         oKW6Kud1ljbrEmaL7rXJIOhkgX1NL/jGfkQaB3Ls=
Date:   Wed, 30 Sep 2020 13:08:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
Message-ID: <20200930130839.427eafa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930192140.4192859-1-weiwan@google.com>
References: <20200930192140.4192859-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 12:21:35 -0700 Wei Wang wrote:
> With napi poll moved to kthread, scheduler is in charge of scheduling both
> the kthreads handling network load, and the user threads, and is able to
> make better decisions. In the previous benchmark, if we do this and we
> pin the kthreads processing napi poll to specific CPUs, scheduler is
> able to schedule user threads away from these CPUs automatically.
> 
> And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> entity per host, is that kthread is more configurable than workqueue,
> and we could leverage existing tuning tools for threads, like taskset,
> chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> if we eventually want to provide busy poll feature using kernel threads
> for napi poll, kthread seems to be more suitable than workqueue. 

As I said in my reply to the RFC I see better performance with the
workqueue implementation, so I would hold off until we have more
conclusive results there, as this set adds fairly strong uAPI that 
we'll have to support for ever.

