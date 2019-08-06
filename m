Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FEA838C2
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfHFSlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:41:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFSlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:41:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E3CB152488F2;
        Tue,  6 Aug 2019 11:41:14 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:41:14 -0700 (PDT)
Message-Id: <20190806.114114.1672670570404825284.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: sch_taprio: fix memleak in error path for
 sched list parse
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806100425.4356-1-ivan.khoronzhuk@linaro.org>
References: <20190806100425.4356-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:41:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Tue,  6 Aug 2019 13:04:25 +0300

> Based on net/master

I wonder about that because:

> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1451,7 +1451,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	spin_unlock_bh(qdisc_lock(sch));
>  
>  free_sched:
> -	kfree(new_admin);
> +	if (new_admin)
> +		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
>  
>  	return err;

In my tree the context around line 1451 is:

	nla_nest_end(skb, sched_nest);

done:
	rcu_read_unlock();

	return nla_nest_end(skb, nest);


which is part of function taprio_dump().

Please respin this properly against current 'net' sources.
