Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4789F607813
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJUNQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiJUNQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:16:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF07A52DF7;
        Fri, 21 Oct 2022 06:15:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A9EC21F8D2;
        Fri, 21 Oct 2022 13:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666358102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KPkwRB0ZaXn3gTiwfIqXO+ySgLQVULSLT2Kgg3vEfks=;
        b=sCO1RpyQa5IzXzKe/KKbcuF+ShsCbLPJIsHCVdj+dv164p9qZJQrvERkVgqr4/Yt3bP0CP
        Ro4PNqM6FdB6oXuL5qAwW9nKX8/k0gzJ1gKAxN23ukxSrH3qo9onwtHYfHblkxwYheVH76
        vR+CvRw6VXajBulvT+7GVwvkt4TCIFs=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 470E42C141;
        Fri, 21 Oct 2022 13:15:02 +0000 (UTC)
Date:   Fri, 21 Oct 2022 15:14:59 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH printk v2 09/38] netconsole: use console_is_enabled()
Message-ID: <Y1KbU2r09bEm2rHX@alley>
References: <20221019145600.1282823-1-john.ogness@linutronix.de>
 <20221019145600.1282823-10-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019145600.1282823-10-john.ogness@linutronix.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-10-19 17:01:31, John Ogness wrote:
> Replace (console->flags & CON_ENABLED) usage with console_is_enabled().
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

The change is straightforward:

Reviewed-by: Petr Mladek <pmladek@suse.com>

The comment below is just a lamentation about the netconsole code.

> ---
>  drivers/net/netconsole.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index bdff9ac5056d..073e59a06f21 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -332,7 +332,7 @@ static ssize_t enabled_store(struct config_item *item,
>  	}
>  
>  	if (enabled) {	/* true */
> -		if (nt->extended && !(netconsole_ext.flags & CON_ENABLED)) {
> +		if (nt->extended && !console_is_enabled(&netconsole_ext)) {
>  			netconsole_ext.flags |= CON_ENABLED;
>  			register_console(&netconsole_ext);
>  		}
> @@ -915,7 +915,7 @@ static int __init init_netconsole(void)
>  	if (err)
>  		goto undonotifier;
>  
> -	if (netconsole_ext.flags & CON_ENABLED)
> +	if (console_is_enabled(&netconsole_ext))
>  		register_console(&netconsole_ext);
>  	register_console(&netconsole);
>  	pr_info("network logging started\n");

Just for record:

This looks like a (mis)use of CON_ENABLED flag. It took me some time
to understand why pre-enabled consoles are handled special way in
register_console(). I partly documented it in
try_enable_preferred_console():

	/*
	 * Some consoles, such as pstore and netconsole, can be enabled even
	 * without matching. Accept the pre-enabled consoles only when match()
	 * and setup() had a chance to be called.
	 */
	if (console_is_enabled(newcon) && (c->user_specified == user_specified))
		return 0;

In my bottom driver, I have a patch cleaning this. It is part of a bigger
clean up that is not ready for upstream :-/

Best Regards,
Petr
