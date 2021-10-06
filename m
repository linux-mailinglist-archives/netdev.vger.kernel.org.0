Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34759423997
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbhJFIUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:20:32 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36234 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhJFIUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:20:31 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B2E0C20335;
        Wed,  6 Oct 2021 08:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633508318;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRAF9XQbKrlzJn8BZCX3Hi9xm9TVoz2BxZrKoRbPKAo=;
        b=BO9gIx80fyRID1UM/udQW68aQSz6x9ndFZ3bZI7QcKODlD1Efu9lVVkv+FOi9o9rbVHQ2Q
        7CF0SB2jAHX70Q02pbNKNzxYiBNn0StPUmR1Ux7Kgwc3Jd3cc3V8cC77EWFJF4KFN5AOs3
        44vSwc+jOrBijc2FPA3xiskbdEyKc6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633508318;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRAF9XQbKrlzJn8BZCX3Hi9xm9TVoz2BxZrKoRbPKAo=;
        b=p6k9Y6Ivyz1mhKX6cDAyohwVQTBRLcieE5RV7FCrYgMxJl/ges0xWL7ZLWAV/xe9EtmTp6
        cOomHR8f9fNJmOBA==
Received: from g78 (unknown [10.163.24.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E61D5A3B83;
        Wed,  6 Oct 2021 08:18:37 +0000 (UTC)
References: <20211006074547.14724-1-rpalethorpe@suse.com>
 <CAK8P3a0COfvLvnL7WCZY6xp+y=gKhm_RakUJbR9DSbzjit3pGQ@mail.gmail.com>
User-agent: mu4e 1.6.5; emacs 27.2
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, rpalethorpe@richiejp.com
Subject: Re: [PATCH] vsock: Handle compat 32-bit timeout
Date:   Wed, 06 Oct 2021 09:13:37 +0100
Reply-To: rpalethorpe@suse.de
In-reply-to: <CAK8P3a0COfvLvnL7WCZY6xp+y=gKhm_RakUJbR9DSbzjit3pGQ@mail.gmail.com>
Message-ID: <87ee8ybm76.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arnd,

Arnd Bergmann <arnd@arndb.de> writes:

> On Wed, Oct 6, 2021 at 9:48 AM Richard Palethorpe <rpalethorpe@suse.com> wrote:
>>
>> Allow 32-bit timevals to be used with a 64-bit kernel.
>>
>> This allows the LTP regression test vsock01 to run without
>> modification in 32-bit compat mode.
>>
>> Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
>> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
>>
>> ---
>>
>> This is one of those fixes where I am not sure if we should just
>> change the test instead. Because it's not clear if someone is likely
>> to use vsock's in 32-bit compat mode?
>
> We try very hard to ensure that compat mode works for every interface,
> so it should be fixed in the kernel. Running compat mode is common
> on memory-restricted machines, e.g. on cloud platforms and on deeply
> embedded systems.

Thanks!

>
> However, I think fixing the SO_VM_SOCKETS_CONNECT_TIMEOUT
> to support 64-bit timeouts would actually be more important here. I think
> what you need to do is to define the macro the same way
> as the SO_TIMESTAMP one:
>
> #define SO_RCVTIMEO (sizeof(time_t) == sizeof(__kernel_long_t) ? \
>              SO_RCVTIMEO_OLD : SO_RCVTIMEO_NEW)
> #define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? \
>              SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
> ...
>
> to ensure that user space picks an interface that matches the
> user space definition of 'struct timeval'.
>
> Your change looks correct otherwise, but I think you should first
> add the new interface for 64-bit timeouts, since that likely changes
> the code in a way that makes your current patch no longer the
> best way to write it.
>
>        Arnd

Ah, yes, it will still be broken if libc is configured with 64bit
timeval only.

-- 
Thank you,
Richard.
