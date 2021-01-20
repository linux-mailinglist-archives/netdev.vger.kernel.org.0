Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9703A2FD37F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbhATPGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbhATPAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:00:07 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80438C0613ED
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:59:18 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id a6so5715603vkb.8
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92voY08IZADF8VSAe7mUUscjgvBNlKl56LSDAGOlq8k=;
        b=fUPgu0M1djjMHfbjR1KGgxHeM5Wnu5WCJUWA89Vr5+oY1q5ZNEoMRzw1NccnlR1/E3
         btHHFBlNuu1k5F41eofJrleULnxC5X2v7QKgRJXudyFK1FbrXmKq2osq2p4ZqxyZ7ups
         W9v0yvRZdTaCQ/8/cUqXV2NQ+gXKL8Q7P5IOu9/SG80SeB1/ECScHBjkMrwzfnu2CPIL
         i6M94YDGZtGqZhvDI+Ku2W1cHCKmIoIgHHNijPKlJbeHk8s8vZx1mpYOy9Q/Ob5Rr9/M
         uMTfop3yCDaSpIP38hGG+WRRtun2LufX55NmHaBUB3TGBQfKUr0x2zdhk/Qx3zTQATsB
         vQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92voY08IZADF8VSAe7mUUscjgvBNlKl56LSDAGOlq8k=;
        b=sQCaSbHPUI67VuulApKHXg450Ti110Ui0bpNCwy/TICFbeUrBPyznSoTytzrZpyq1S
         +i0MerErGSOHMKHH6gSua6JWFN1WcRaoSOlWTyU3Vp7Q4hIW9PT9R3eErx+Mu6OOxYhK
         NNS5tu+61KYoosZ4ptZ97LYZsdwupG+NMVizvRot8KdiU9CE6aDxLcnDXo8jhn83Rb27
         IOpvNDHMkENc9H/xjOvxuB3GzzLdx/OYvZ1AGXlOGTF/VBRaxOzzZ1BedbYRQTOyJXJc
         L17dwpSTKs5R2mNxV3ZXP6FEB83gzccIOksoKkp+9B9FH3cZ/ZXGAgfvGVKz2PGopNon
         GlzA==
X-Gm-Message-State: AOAM530Soe2jmzLLCD4kKima/ZrSXwWti0rPUOGxIOZkKC6ifyEDPwIX
        lHN6rKwOfRxZ+ajK81HH6SPR55KwmMcrXwkbsFKlGg==
X-Google-Smtp-Source: ABdhPJzRIVlXBio4aZCBzLI54flkkLws1wi8y7ngVZ28U2LaBrAIMeKq508t1AynCEZJerqTMCT3twVVlrsrQMp9b5k=
X-Received: by 2002:a1f:f44d:: with SMTP id s74mr7292980vkh.14.1611154757469;
 Wed, 20 Jan 2021 06:59:17 -0800 (PST)
MIME-Version: 1.0
References: <1611139794-11254-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611139794-11254-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 20 Jan 2021 09:59:00 -0500
Message-ID: <CADVnQykgYGc4_U+eyXU72fky2C5tDQKuOuQ=BdfqfROTG++w7Q@mail.gmail.com>
Subject: Re: tcp: rearm RTO timer does not comply with RFC6298
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 5:50 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> hi,
>
> I have a doubt about tcp_rearm_rto().
>
> Early TCP always rearm the RTO timer to NOW+RTO when it receives
> an ACK that acknowledges new data.
>
> Referring to RFC6298 SECTION 5.3: "When an ACK is received that
> acknowledges new data, restart the retransmission timer so that
> it will expire after RTO seconds (for the current value of RTO)."
>
> After ER and TLP, we rearm the RTO timer to *tstamp_of_head+RTO*
> when switching from ER/TLP/RACK to original RTO in tcp_rearm_rto(),
> in this case the RTO timer is triggered earlier than described in
> RFC6298, otherwise the same.
>
> Is this planned? Or can we always rearm the RTO timer to
> tstamp_of_head+RTO?
>
> Thanks.
>

This is a good question. As far as I can tell, this difference in
behavior would only come into play in a few corner cases, like:

(1) The TLP timer fires and the connection is unable to transmit a TLP
probe packet. This could happen due to memory allocation failure  or
the local qdisc being full.

(2) The RACK reorder timer fires but the connection does not take the
normal course of action and mark some packets lost and retransmit at
least one of them. I'm not sure how this would happen. Maybe someone
can think of a case.

My sense would be that given how relatively rare (1)/(2) are, it is
probably not worth changing the current behavior, given that it seems
it would require extra state (an extra u32 snd_una_advanced_tstamp? )
to save the time at which snd_una advanced (a cumulative ACK covered
some data) in order to rearm the RTO timer for snd_una_advanced_tstamp
+ rto.

neal
