Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D831942DB52
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhJNOVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhJNOVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD70C610A0;
        Thu, 14 Oct 2021 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634221151;
        bh=kpUZ41SbDwQdbWz0EA1in4Xn0nl6JI2Wvyw8S5T/Pqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nTQob4NLuQLm9nz+789gpVIcY9hOrEVC984wO91+C/SUrVLLzBFJSx63WJXEW1YYE
         /VWMh5w1037KifAuawYK2DPPZWDUxIq+KUIFynLC2erj4EEMR7j6QQIkPNf73AAqmN
         QTOV/GGQFOO56q88cmIH+Ab+Lr+33fUgOLS5TE7Y0eYu3PvY1dxwYz6n0qepkXIkNQ
         0FY8/zLby5pKUEA9XZkUMxdCjliL9g2CKIfc8aq5hfd7fU6pyA47atLVheZARLGZGi
         lDA7XU42ORHmr+77x+gsGJwMK7Cq0ad/fM5aOjOIXL2UFt5VvrGHBI7J6a8Xit4P0X
         Zdw0r2AWpIrmA==
Date:   Thu, 14 Oct 2021 07:19:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH] net: sched: fix infinite loop when trying to create tcf
 rule
Message-ID: <20211014071909.63338451@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013211000.8962-1-pmenzel@molgen.mpg.de>
References: <20211013211000.8962-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 23:09:59 +0200 Paul Menzel wrote:
> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> 
> After running a specific set of commands tc will become unresponsive:
> 
>     $ ip link add dev DEV type veth
>     $ tc qdisc add dev DEV clsact
>     $ tc chain add dev DEV chain 0 ingress
>     $ tc filter del dev DEV ingress
>     $ tc filter add dev DEV ingress flower action pass
> 
> When executing chain flush the chain->flushing field is set to true, which
> prevents insertion of new classifier instances.  It is unset in one place
> under two conditions: `refcnt - chain->action_refcnt == 0` and `!by_act`.
> Ignoring the by_act and action_refcnt arguments the `flushing procedure`
> will be over when refcnt is 0.
> 
> But if the chain is explicitly created (e.g. `tc chain add .. chain 0 ..`)
> refcnt is set to 1 without any classifier instances. Thus the condition is
> never met and the chain->flushing field is never cleared.  And because the
> default chain is `flushing` new classifiers cannot be added. tc_new_tfilter
> is stuck in a loop trying to find a chain where chain->flushing is false.
> 
> Moving `chain->flushing = false` from __tcf_chain_put to the end of
> tcf_chain_flush will avoid the condition and the field will always be reset
> after the flush procedure.
> 
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> [Upstreamed from https://github.com/dentproject/dentOS/commit/3480aceaa5244a11edfe1fda90afd92b0199ef23]
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

This had already been submitted:

https://lore.kernel.org/all/1633848948-11315-1-git-send-email-volodymyr.mytnyk@plvision.eu/
