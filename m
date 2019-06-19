Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E23A4BDAF
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfFSQH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:07:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbfFSQH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:07:28 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38CC615258964;
        Wed, 19 Jun 2019 09:07:27 -0700 (PDT)
Date:   Wed, 19 Jun 2019 12:07:26 -0400 (EDT)
Message-Id: <20190619.120726.374612750372065747.davem@davemloft.net>
To:     tracywwnj@gmail.com
Cc:     netdev@vger.kernel.org, kafai@fb.com, edumazet@google.com,
        maheshb@google.com, dsahern@gmail.com, weiwan@google.com
Subject: Re: [PATCH net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in
 rule lookup logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618182543.65477-4-tracywwnj@gmail.com>
References: <20190618182543.65477-1-tracywwnj@gmail.com>
        <20190618182543.65477-4-tracywwnj@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 09:07:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <tracywwnj@gmail.com>
Date: Tue, 18 Jun 2019 11:25:41 -0700

> @@ -237,13 +240,16 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
>  			goto out;
>  	}
>  again:
> -	ip6_rt_put(rt);
> +	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
> +	    !list_empty(&rt->rt6i_uncached))
> +		ip6_rt_put(rt);

This conditional release logic, with the special treatment of uncache items
when using DST_NOREF, seems error prone.

Maybe you can put this logic into a helper like ip6_rt_put_any() and do the
list empty test etc. there?

	ip6_rt_put_any(struct rt6_info *rt, int flags);

What do you think?
