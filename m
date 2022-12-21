Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1133B653690
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiLUSsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiLUSsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E01E70C;
        Wed, 21 Dec 2022 10:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D247B81BA6;
        Wed, 21 Dec 2022 18:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6C4C433EF;
        Wed, 21 Dec 2022 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648479;
        bh=hTuIjHBHd+Tec1DAOqqIPFW5jFXlpQ7ZWnftXs2hg6Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XiS53svtnGlZKUpJLWpjIb00pvlTavkGyE/yhXeS7hKFYS8V/5Xav/+mlpRGezW6h
         BljUFnHKQWw/igsJKn42+z68Zwy3Z5sPZrjhFME/Kwqkbwjx7njFSsJY/zjJWCYIs2
         hg7VB/Upxxl01DViL7TGCOLjNQW9ZDg1YFt1aai4iFOc2yVu8ujua8wy7VEyZXvui4
         /1bJ/zTi5VZkqa0c9me5b9nyIRR+8AGM7a6aXGScjL7jgysNOOGh6mrX4vs3UGAGXF
         1s0aX5L7Ze9A8zWY2oezGwBJF7QaIiwiLIJLyqjhe4qpPeepExO7oc4XqzOCONcDBc
         /pYLvZHxEpyuQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>, linux-sh@vger.kernel.org,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bluetooth@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-scsi@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-ext4@vger.kernel.org,
        linux-nilfs@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        lvs-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: Re: [PATCH] treewide: Convert del_timer*() to timer_shutdown*()
References: <20221220134519.3dd1318b@gandalf.local.home>
Date:   Wed, 21 Dec 2022 20:47:50 +0200
In-Reply-To: <20221220134519.3dd1318b@gandalf.local.home> (Steven Rostedt's
        message of "Tue, 20 Dec 2022 13:45:19 -0500")
Message-ID: <87mt7gk2zt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> [
>   Linus,
>
>     I ran the script against your latest master branch:
>     commit b6bb9676f2165d518b35ba3bea5f1fcfc0d969bf
>
>     As the timer_shutdown*() code is now in your tree, I figured
>     we can start doing the conversions. At least add the trivial ones
>     now as Thomas suggested that this gets applied at the end of the
>     merge window, to avoid conflicts with linux-next during the
>     development cycle. I can wait to Friday to run it again, and
>     resubmit.
>
>     What is the best way to handle this?
> ]
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Due to several bugs caused by timers being re-armed after they are
> shutdown and just before they are freed, a new state of timers was added
> called "shutdown". After a timer is set to this state, then it can no
> longer be re-armed.
>
> The following script was run to find all the trivial locations where
> del_timer() or del_timer_sync() is called in the same function that the
> object holding the timer is freed. It also ignores any locations where the
> timer->function is modified between the del_timer*() and the free(), as
> that is not considered a "trivial" case.
>
> This was created by using a coccinelle script and the following commands:
>
>  $ cat timer.cocci
> @@
> expression ptr, slab;
> identifier timer, rfield;
> @@
> (
> -       del_timer(&ptr->timer);
> +       timer_shutdown(&ptr->timer);
> |
> -       del_timer_sync(&ptr->timer);
> +       timer_shutdown_sync(&ptr->timer);
> )
>   ... when strict
>       when != ptr->timer
> (
>         kfree_rcu(ptr, rfield);
> |
>         kmem_cache_free(slab, ptr);
> |
>         kfree(ptr);
> )
>
>  $ spatch timer.cocci . > /tmp/t.patch
>  $ patch -p1 < /tmp/t.patch
>
> Link: https://lore.kernel.org/lkml/20221123201306.823305113@linutronix.de/
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

For wireless:

>  .../broadcom/brcm80211/brcmfmac/btcoex.c         |  2 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |  2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c     |  2 +-
>  drivers/net/wireless/intersil/hostap/hostap_ap.c |  2 +-
>  drivers/net/wireless/marvell/mwifiex/main.c      |  2 +-
>  drivers/net/wireless/microchip/wilc1000/hif.c    |  6 +++---

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
