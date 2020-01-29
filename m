Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2BB14C88C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgA2KLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:11:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2KLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:11:20 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CE0D15C01237;
        Wed, 29 Jan 2020 02:11:18 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:11:16 +0100 (CET)
Message-Id: <20200129.111116.26679152804758998.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v2 1/3] taprio: Fix enabling offload with wrong
 number of traffic classes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200128235227.3942256-2-vinicius.gomes@intel.com>
References: <20200128235227.3942256-1-vinicius.gomes@intel.com>
        <20200128235227.3942256-2-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 02:11:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Tue, 28 Jan 2020 15:52:25 -0800

> @@ -1444,6 +1444,19 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  
>  	taprio_set_picos_per_byte(dev, q);
>  
> +	if (mqprio) {
> +		netdev_set_num_tc(dev, mqprio->num_tc);
> +		for (i = 0; i < mqprio->num_tc; i++)
> +			netdev_set_tc_queue(dev, i,
> +					    mqprio->count[i],
> +					    mqprio->offset[i]);
> +
> +		/* Always use supplied priority mappings */
> +		for (i = 0; i <= TC_BITMASK; i++)
> +			netdev_set_prio_tc_map(dev, i,
> +					       mqprio->prio_tc_map[i]);
> +	}
> +
>  	if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
>  		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
>  	else

This feedback applies to the existing code too, but don't we need to have
a call to netdev_reset_tc() in the error paths after we commit these
settings?

Because ->num_tc for the device should be reset to zero for sure if we
can't complete this configuration change successfully.
