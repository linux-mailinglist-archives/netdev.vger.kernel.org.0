Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A46812730B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLTBxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:53:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLTBxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:53:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34CBD1540E092;
        Thu, 19 Dec 2019 17:53:32 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:53:31 -0800 (PST)
Message-Id: <20191219.175331.2104515305508917057.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladbu@mellanox.com, mrv@mojatatu.com
Subject: Re: [PATCH net 0/2] net/sched: cls_u32: fix refcount leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576623250.git.dcaratti@redhat.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:53:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Wed, 18 Dec 2019 00:00:03 +0100

> a refcount leak in the error path of u32_change() has been recently
> introduced. It can be observed with the following commands:
 ...
> they all legitimately return -EINVAL; however, they leave semi-configured
> filters at eth0 tc ingress:
 ...
> With older kernels, filters were unconditionally considered empty (and
> thus de-refcounted) on the error path of ->change().
> After commit 8b64678e0af8 ("net: sched: refactor tp insert/delete for
> concurrent execution"), filters were considered empty when the walk()
> function didn't set 'walker.stop' to 1.
> Finally, with commit 6676d5e416ee ("net: sched: set dedicated tcf_walker
> flag when tp is empty"), tc filters are considered empty unless the walker
> function is called with a non-NULL handle. This last change doesn't fit
> cls_u32 design, because at least the "root hnode" is (almost) always
> non-NULL, as it's allocated in u32_init().
> 
> - patch 1/2 is a proposal to restore the original kernel behavior, where
>   no filter was installed in the error path of u32_change().
> - patch 2/2 adds tdc selftests that can be ued to verify the correct
>   behavior of u32 in the error path of ->change().

Series applied, thanks.
