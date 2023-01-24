Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31C4679B87
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbjAXOST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbjAXOSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:18:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497F8559F;
        Tue, 24 Jan 2023 06:17:45 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F1AD72184E;
        Tue, 24 Jan 2023 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674569864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xUFgq94lkIoqvnmIFB3kAZsDWNfWS7YvIhKyrZhAeC4=;
        b=cUqfsX3IZ+giAmku8cVWd/P58Q+rmT2DXmyKBfNz0LtIzD29jL7lZlg8RYWEPO7aaZxIlL
        2xwLkA7gDax4Br4cqoXGlZeF3yGW78vQs6MwG971l35sQp85hsgmakSDGBnDGKGU0bvggT
        MEwKU8jEODMygbr2xaU6usZxG7Z8AxU=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CB5AC2C141;
        Tue, 24 Jan 2023 14:17:43 +0000 (UTC)
Date:   Tue, 24 Jan 2023 15:17:43 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: check for pending livepatches from vhost
 worker kthreads
Message-ID: <Y8/ohzRGcOiqsh69@alley>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2023-01-20 16:12:22, Seth Forshee (DigitalOcean) wrote:
> Livepatch relies on stack checking of sleeping tasks to switch kthreads,
> so a busy kthread can block a livepatch transition indefinitely. We've
> seen this happen fairly often with busy vhost kthreads.

To be precise, it would be "indefinitely" only when the kthread never
sleeps.

But yes. I believe that the problem is real. It might be almost
impossible to livepatch some busy kthreads, especially when they
have a dedicated CPU.


> Add a check to call klp_switch_current() from vhost_worker() when a
> livepatch is pending. In testing this allowed vhost kthreads to switch
> immediately when they had previously blocked livepatch transitions for
> long periods of time.
> 
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> ---
>  drivers/vhost/vhost.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index cbe72bfd2f1f..d8624f1f2d64 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -366,6 +367,9 @@ static int vhost_worker(void *data)
>  			if (need_resched())
>  				schedule();
>  		}
> +
> +		if (unlikely(klp_patch_pending(current)))
> +			klp_switch_current();

I suggest to use the following intead:

		if (unlikely(klp_patch_pending(current)))
			klp_update_patch_state(current);

We already use this in do_idle(). The reason is basically the same.
It is almost impossible to livepatch the idle task when a CPU is
very idle.

klp_update_patch_state(current) does not check the stack.
It switches the task immediately.

It should be safe because the kthread never leaves vhost_worker().
It means that the same kthread could never re-enter this function
and use the new code.

Best Regards,
Petr
