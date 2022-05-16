Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9B528783
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244714AbiEPOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244712AbiEPOuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:50:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92272ED44;
        Mon, 16 May 2022 07:50:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 897CC21F73;
        Mon, 16 May 2022 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652712613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KQiIlBeAtlsgCeLOjjHzTpkuGh7+XAuIIUDB14idFd4=;
        b=S4QT9bHIulh2DX7+Td1E1eHZ8ylXqLGd87dgOU5qON7f0TC2viT1I31ABT9u1YFo+zVF7s
        CRf1jIcOXQaAUTOOLTnLyfyBeX0en2TY7mgyp7gvJnFWNhPu01YU8FRcK1p4/UGj8Io8lk
        XM2tY8ZdnQQ59J0fQXUB5igw6KG7gMQ=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0B9D32C142;
        Mon, 16 May 2022 14:50:13 +0000 (UTC)
Date:   Mon, 16 May 2022 16:50:12 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, akpm@linux-foundation.org,
        bhe@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org
Subject: Re: [PATCH 23/30] printk: kmsg_dump: Introduce helper to inform
 number of dumpers
Message-ID: <YoJkpAp8XdS7ROgd@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-24-gpiccoli@igalia.com>
 <20220510134014.3923ccba@gandalf.local.home>
 <c8818906-f113-82b6-b58b-d47ae0c16b4f@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8818906-f113-82b6-b58b-d47ae0c16b4f@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-05-11 17:03:51, Guilherme G. Piccoli wrote:
> On 10/05/2022 14:40, Steven Rostedt wrote:
> > On Wed, 27 Apr 2022 19:49:17 -0300
> > "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> > 
> >> Currently we don't have a way to check if there are dumpers set,
> >> except counting the list members maybe. This patch introduces a very
> >> simple helper to provide this information, by just keeping track of
> >> registered/unregistered kmsg dumpers. It's going to be used on the
> >> panic path in the subsequent patch.
> > 
> > FYI, it is considered "bad form" to reference in the change log "this
> > patch". We know this is a patch. The change log should just talk about what
> > is being done. So can you reword your change logs (you do this is almost
> > every patch). Here's what I would reword the above to be:
> > 
> >  Currently we don't have a way to check if there are dumpers set, except
> >  perhaps by counting the list members. Introduce a very simple helper to
> >  provide this information, by just keeping track of registered/unregistered
> >  kmsg dumpers. This will simplify the refactoring of the panic path.
> 
> Thanks for the hint, you're right - it's almost in all of my patches.
> I'll reword all of them (except the ones already merged) to remove this
> "bad form".

Shame on me that I do not care that much about the style of the commit
message :-)

Anyway, the code looks good to me. With the better commit message:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
