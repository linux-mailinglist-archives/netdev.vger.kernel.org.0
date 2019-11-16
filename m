Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CADAFF586
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfKPUmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:42:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbfKPUme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:42:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB7EA1517B3D0;
        Sat, 16 Nov 2019 12:42:33 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:42:33 -0800 (PST)
Message-Id: <20191116.124233.2034551092704813586.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] taprio: don't reject same mqprio settings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
References: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:42:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Fri, 15 Nov 2019 03:56:07 +0200

> @@ -1347,6 +1347,26 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
>  	return err;
>  }
>  
> +static int taprio_mqprio_cmp(struct net_device *dev,
> +			     struct tc_mqprio_qopt *mqprio)
> +{
 ...
>  static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  			 struct netlink_ext_ack *extack)
>  {
> @@ -1398,6 +1418,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	admin = rcu_dereference(q->admin_sched);
>  	rcu_read_unlock();
>  
> +	/* no changes - no new mqprio settings */
> +	if (mqprio && !taprio_mqprio_cmp(dev, mqprio))
> +		mqprio = NULL;
> +

I like Vinicius's feedback, please make the new helper function have
the signature:

static int taprio_mqprio_cmp(const struct net_device *dev,
			     const struct tc_mqprio_qopt *mqprio)

And make the NULL check in there instead of at the caller.

Please also remember to add the Fixes: tag.

Thanks.
