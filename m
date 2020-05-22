Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D31DED06
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgEVQPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:15:39 -0400
Received: from mail.buslov.dev ([199.247.26.29]:50049 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgEVQPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 12:15:38 -0400
Received: from vlad-x1g6 (unknown [IPv6:2a01:d0:40b3:9801:fec2:781d:de90:e768])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id B04A420C18;
        Fri, 22 May 2020 19:15:35 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1590164136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aif5wZe3c36xCzWOUDl3iJT/1NWMtlWgfmYME53x00k=;
        b=lXdO6wUQhP6UM+yMs91zQyNiv9/j1IYZIzd+qa0OSJotYrnzm57YhgW6ASM/DM0C5UJ41E
        oNfKUtgkJrYvMJiyxljAH+XztHFADByPm84Bb6TLWMFjuhCExKRL+tmkzbnjqf5LeM4eFK
        p8+JMCjuBKsszSyDagtjU2zltDOWkMpdqfEv3H7R/UhL1FV7rVDlgETPT4hTK6HV/9YF+j
        PX9tiqHhGaHa0py29fa0hYiZPaCZu52N3OCrGJs7MQ1Q1maZc+oSBn3omvbXpOd5BjfQxH
        pMgLexutbB7q9uGdIZxK/XEEZnBMV2oLnyYTig96NTFKpJZeP9r1JSrIEFxFHw==
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com> <vbf1rndz76r.fsf@mellanox.com> <20200521100214.700348e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.4; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Edward Cree <ecree@solarflare.com>, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <20200521100214.700348e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 22 May 2020 19:16:09 +0300
Message-ID: <87imgo9c8m.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 21 May 2020 at 20:02, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 21 May 2020 17:36:12 +0300 Vlad Buslov wrote:
>> Hi Edward, Cong,
>> 
>> On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
>> > On 15/05/2020 12:40, Vlad Buslov wrote:  
>> >> In order to
>> >> significantly improve filter dump rate this patch sets implement new
>> >> mode of TC filter dump operation named "terse dump" mode. In this mode
>> >> only parameters necessary to identify the filter (handle, action cookie,
>> >> etc.) and data that can change during filter lifecycle (filter flags,
>> >> action stats, etc.) are preserved in dump output while everything else
>> >> is omitted.  
>> > I realise I'm a bit late, but isn't this the kind of policy that shouldn't
>> >  be hard-coded in the kernel?  I.e. if next year it turns out that some
>> >  user needs one parameter that's been omitted here, but not the whole dump,
>> >  are they going to want to add another mode to the uapi?
>> > Should this not instead have been done as a set of flags to specify which
>> >  pieces of information the caller wanted in the dump, rather than a mode
>> >  flag selecting a pre-defined set?
>> >
>> > -ed  
>> 
>> I've been thinking some more about this. While the idea of making
>> fine-grained dump where user controls exact contents field-by-field is
>> unfeasible due to performance considerations, we can try to come up with
>> something more coarse-grained but not fully hardcoded (like current terse
>> dump implementation). Something like having a set of flags that allows
>> to skip output of groups of attributes.
>> 
>> For example, CLS_SKIP_KEY flag would skip the whole expensive classifier
>> key dump without having to go through all 200 lines of conditionals in
>
> Do you really need to dump classifiers? If you care about stats 
> the actions could be sufficient if the offload code was fixed
> appropriately... Sorry I had to say that.

Technically I need neither classifier nor action. All I need is cookie
and stats of single terminating action attached to filter (redirect,
drop, etc.). This can be achieved by making terse dump output that data
for last extension on filter. However, when I discussed my initial terse
dump idea with Jamal he asked me not to ossify such behavior to allow
for implementation of offloaded shared actions in future.

Speaking about shared action offload, I remember looking at some RFC
patches by Edward implementing such functionality and allowing action
stats update directly from act, as opposed to current design that relies
on classifier to update action stats from hardware. Is that what you
mean by appropriately fixing offload code? With such implementation,
just dumping relevant action types would also work. My only concern is
that the only way to dump actions is per-namespace as opposed to
per-Qdisc of filters, which would clash with any other cls/act users on
same machine/hypervisor.


[...]

