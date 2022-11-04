Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5F3619B22
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiKDPNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiKDPMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:12:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C072528C;
        Fri,  4 Nov 2022 08:12:44 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667574762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9fNXuNAZIaRVYddQx+KbxBq3ufFg5G5ZaGpH6NBeNLI=;
        b=pkMNdG7uiZXWqiVdAog5eC2NPfFgSkwaQvl8wX9eLkqhULG5dycMkgKBoLN7gf3Qjd6WG/
        om8O0BNVcnC31uXSvZfxQzSWEFAa4uFRLHnSOTjbcT9TUPVYisPJRU7yz7Yf93Gxii8qMC
        CvedxxjC+JsAZlrdVD4ennVxtqcEXAJA8q/ljeKbK2frUxtHlAli8GS+DOzuNojzLuXT+6
        W5LS1pftuVsvXaXs3erI3PnZyzqpFMgC3L6W0n2UWIJuhr7TSLxZHBdVEjfrx9lp4vhTCA
        4W8unTP8/wTQ+O4UiWw+b3/BwBtjxCFMVpSiD15Er+Q8M9ZviJvNnblIoNhuag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667574762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9fNXuNAZIaRVYddQx+KbxBq3ufFg5G5ZaGpH6NBeNLI=;
        b=3rtLf7E3Mjf6OgBJQQOzDJcuCaGZpMFzQdicfMP9Q9BndJybusy4Qo0qD43T6Ti79mKfSz
        UC/Vjz0+22funYAA==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH printk v2 09/38] netconsole: use console_is_enabled()
In-Reply-To: <Y1KbU2r09bEm2rHX@alley>
References: <20221019145600.1282823-1-john.ogness@linutronix.de>
 <20221019145600.1282823-10-john.ogness@linutronix.de>
 <Y1KbU2r09bEm2rHX@alley>
Date:   Fri, 04 Nov 2022 16:18:41 +0106
Message-ID: <87h6ze7nyu.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,INVALID_DATE_TZ_ABSURD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-21, Petr Mladek <pmladek@suse.com> wrote:
>> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
>> index bdff9ac5056d..073e59a06f21 100644
>> --- a/drivers/net/netconsole.c
>> +++ b/drivers/net/netconsole.c
>> @@ -332,7 +332,7 @@ static ssize_t enabled_store(struct config_item *item,
>>  	}
>>  
>>  	if (enabled) {	/* true */
>> -		if (nt->extended && !(netconsole_ext.flags & CON_ENABLED)) {
>> +		if (nt->extended && !console_is_enabled(&netconsole_ext)) {
>>  			netconsole_ext.flags |= CON_ENABLED;
>>  			register_console(&netconsole_ext);
>>  		}
>> @@ -915,7 +915,7 @@ static int __init init_netconsole(void)
>>  	if (err)
>>  		goto undonotifier;
>>  
>> -	if (netconsole_ext.flags & CON_ENABLED)
>> +	if (console_is_enabled(&netconsole_ext))
>>  		register_console(&netconsole_ext);
>>  	register_console(&netconsole);
>>  	pr_info("network logging started\n");
>
> This looks like a (mis)use of CON_ENABLED flag.

Yes. When @netconsole_ext is registered, CON_ENABLED is always set. So
it should be set in the static initialization. The first hunk should be
using the new console_is_registered(). The second hunk should be using a
local @extended bool variable. Also, in cleanup_netconsole() it should
check if the console is registered:

if (console_is_registered(&netconsole_ext))
        unregister_console(&netconsole_ext);

I will make all of these changes for v3. Then there will be no
checking/setting of CON_ENABLED in the driver.

John Ogness
