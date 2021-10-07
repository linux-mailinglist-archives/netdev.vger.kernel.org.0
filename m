Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7171425A5E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243495AbhJGSJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:09:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43420 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhJGSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 14:09:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5F20F223E3;
        Thu,  7 Oct 2021 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633630074;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0G/EZX1ji0urQFo+dhNDqFjO20mWiPUHbeo8LllXszk=;
        b=PvcIVNCfj1johWP2REIOdNWSOShWQHtV1hKf5Y8RtJkyuFJOiPXp7HsG6pYeVtlWvXcYAK
        hCJOrPNqjkW7GDPy7Mi7rkqFizH9MPlsMiM8RSoA2vqwpad5byIeLRK1Vms7TFm4DyALVV
        tZ0JYThDP+UObfA+CfXQY9twr+uLPrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633630074;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0G/EZX1ji0urQFo+dhNDqFjO20mWiPUHbeo8LllXszk=;
        b=+QIqnoKdOGrqMJL2QEAF6i2xS/4b74l0WShmLZlZhhHZVyuAhH3qsdaTr2Zg8RpVMXXcO/
        k8MigbXepP1hgSCQ==
Received: from g78 (unknown [10.163.24.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 74700A3B81;
        Thu,  7 Oct 2021 18:07:53 +0000 (UTC)
References: <20211007123147.5780-1-rpalethorpe@suse.com>
 <20211007123147.5780-2-rpalethorpe@suse.com>
 <20211007090404.20e555d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.6.5; emacs 27.2
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@richiejp.com>
Subject: Re: [PATCH v2 2/2] vsock: Enable y2038 safe timeval for timeout
Date:   Thu, 07 Oct 2021 18:14:39 +0100
Reply-To: rpalethorpe@suse.de
In-reply-to: <20211007090404.20e555d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <87a6jkbte4.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu,  7 Oct 2021 13:31:47 +0100 Richard Palethorpe wrote:
>> Reuse the timeval compat code from core/sock to handle 32-bit and
>> 64-bit timeval structures. Also introduce a new socket option define
>> to allow using y2038 safe timeval under 32-bit.
>> 
>> The existing behavior of sock_set_timeout and vsock's timeout setter
>> differ when the time value is out of bounds. vsocks current behavior
>> is retained at the expense of not being able to share the full
>> implementation.
>> 
>> This allows the LTP test vsock01 to pass under 32-bit compat mode.
>> 
>> Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
>> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
>> Cc: Richard Palethorpe <rpalethorpe@richiejp.com>
>
> This breaks 32bit x86 build:
>
> ERROR: modpost: "__divdi3" [net/vmw_vsock/vsock.ko] undefined!
>
> If the 64 bit division is intention you need to use an appropriate
> helper.

Ah, sorry, that's why sock.c casts usecs to unsigned long. I will do
some more testing a reroll.

-- 
Thank you,
Richard.
