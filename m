Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5921F3AA0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgFIM2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:28:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:51012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgFIM2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 08:28:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 851C3AAC6;
        Tue,  9 Jun 2020 12:28:00 +0000 (UTC)
Date:   Tue, 9 Jun 2020 14:27:55 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 2/7] dynamic_debug: Group debug messages by level
 bitmask
Message-ID: <20200609122755.GE23752@linux-b0ei>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-3-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-3-stanimir.varbanov@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2020-06-09 13:45:59, Stanimir Varbanov wrote:
> This will allow dynamic debug users and driver writers to group
> debug messages by level bitmask.  The level bitmask should be a
> hex number.
> 
> Done this functionality by extending dynamic debug metadata with
> new level member and propagate it over all the users.  Also
> introduce new dynamic_pr_debug_level and dynamic_dev_dbg_level
> macros to be used by the drivers.

Could you please provide more details?

What is the use case?
What is the exact meaning of the level value?
How the levels will get defined?

Dynamic debug is used for messages with KERN_DEBUG log level.
Is this another dimension of the message leveling?

Given that the filter is defined by bits, it is rather grouping
by context or so.


> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 8f199f403ab5..5d28d388f6dd 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -55,6 +55,7 @@ struct ddebug_query {
>  	const char *function;
>  	const char *format;
>  	unsigned int first_lineno, last_lineno;
> +	unsigned int level;
>  };
>  
>  struct ddebug_iter {
> @@ -187,6 +188,18 @@ static int ddebug_change(const struct ddebug_query *query,
>  
>  			nfound++;
>  
> +#ifdef CONFIG_JUMP_LABEL
> +			if (query->level && query->level & dp->level) {
> +				if (flags & _DPRINTK_FLAGS_PRINT)
> +					static_branch_enable(&dp->key.dd_key_true);
> +				else
> +					static_branch_disable(&dp->key.dd_key_true);
> +			} else if (query->level &&
> +				   flags & _DPRINTK_FLAGS_PRINT) {
> +				static_branch_disable(&dp->key.dd_key_true);
> +				continue;
> +			}
> +#endif

This looks like a hack in the existing code:

  + It is suspicious that "continue" is only in one branch. It means
    that static_branch_enable/disable() might get called 2nd time
    by the code below. Or newflags are not stored when there is a change.

  + It changes the behavior and the below vpr_info("changed ...")
    is not called.

Or do I miss anything?

>			newflags = (dp->flags & mask) | flags;
>  			if (newflags == dp->flags)
>  				continue;

Best Regards,
Petr
