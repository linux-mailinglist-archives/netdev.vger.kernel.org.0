Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F3F325ED
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFCBLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:11:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCBLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:11:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A626B1340D538;
        Sun,  2 Jun 2019 18:11:07 -0700 (PDT)
Date:   Sun, 02 Jun 2019 18:11:07 -0700 (PDT)
Message-Id: <20190602.181107.2095462509842063351.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: add rcu annotations for ifa_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531162709.9895-1-fw@strlen.de>
References: <20190531162709.9895-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 18:11:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 31 May 2019 18:27:02 +0200

> v3: fix typo in patch1 commit message
>     All other patches are unchanged.
> v2: remove ifa_list iteration in afs instead of conversion
> 
> Eric Dumazet reported following problem:
> 
>   It looks that unless RTNL is held, accessing ifa_list needs proper RCU
>   protection.  indev->ifa_list can be changed under us by another cpu
>   (which owns RTNL) [..]
> 
>   A proper rcu_dereference() with an happy sparse support would require
>   adding __rcu attribute.
> 
> This patch series does that: add __rcu to the ifa_list pointers.
> That makes sparse complain, so the series also adds the required
> rcu_assign_pointer/dereference helpers where needed.
> 
> All patches except the last one are preparation work.
> Two new macros are introduced for in_ifaddr walks.
> 
> Last patch adds the __rcu annotations and the assign_pointer/dereference
> helper calls.
> 
> This patch is a bit large, but I found no better way -- other
> approaches (annotate-first or add helpers-first) all result in
> mid-series sparse warnings.
> 
> This series is submitted vs. net-next rather than net for several
> reasons:
> 
> 1. Its (mostly) compile-tested only
> 2. 3rd patch changes behaviour wrt. secondary addresses
>    (see changelog)
> 3. The problem exists for a very long time (2004), so it doesn't
>    seem to be urgent to fix this -- rcu use to free ifa_list
>    predates the git era.

Series applied, thanks Florian.
