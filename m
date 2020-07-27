Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8722F95C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgG0TqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0TqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:46:04 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9028BC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:46:04 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l4so18208027ejd.13
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RkCxoudjrhH8Hq3zmA6W2tiZv6PkqN81jv9epZiiEKc=;
        b=BaIC/fMD2q9W1eXeWQ2uWZaZqyoLy59USCz7KlyxNC4eJKcXBRNW/ejuCAkKY3wVIg
         Bo1BYFxkFRnRTiGCwsROxYOCQVg/LEWlWsbO0foLNEhdAe9g+rtodneiSZjhzPbM4hqe
         OZWnR6sJmMnDgRhWTa9GfsIJpdww845ouLRKt51mAkA7ZcK4nB0+Hrct6eyl1380Ozb9
         6Hd93mRCIHAEtsxf0kMv7cr4X0oPaniHp7jg+gGvmXZ8SpsOgw6w9WuaHl3EWG2EWJ5S
         TquxiNxeG5pOunOds9GcCCf8vVRnw1XdvUT1jHTQWkolHVBstL6Dgn2i0RbW4nXSIU4n
         lnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RkCxoudjrhH8Hq3zmA6W2tiZv6PkqN81jv9epZiiEKc=;
        b=nCJhSKzuUkoIrlChk6gsqYzDCjlQ6rtgTJseeP0ReEycrALB6FOu6xEi/76pjl9ebs
         P0djwqCQA2RZyVDwlSJOh3KRi8cd7I0oNMoSsrZBL7gsw7tWIvhjjmVERkk+GKXN+kv3
         er6isI+cFvIZHOTyvvs0EwWEwhn9sgyH737pspJdQFz1bIVnekX1FTrBhW3AmtOOaY2K
         5f7CuEHzhwk3KAJVHgmWe+Dd/4VfWnxAzxQVXu8VLhlFQ4DPBx2vS/BuJ1QiHBGDWh3H
         ZFhic77o4pJQS1uG+bhbdWTpVb8i7ylzDFCdpep7y9qzp8u4nheJnPdE9OYtINqjNJNO
         1ELw==
X-Gm-Message-State: AOAM532Fpl5pKUDbluT9vzS1WQ53vkJEVFNAjfKCWukc5UwjfecxgyjB
        HZu3HlO1T9vm9tK93si90Bg=
X-Google-Smtp-Source: ABdhPJyeLlCxJ+pVlNQJLEHo01yNiZywBvE4LmJO8ktzleJnQMdTuvYtJnOhDjkajdsRk8wZqP26bw==
X-Received: by 2002:a17:906:ef2:: with SMTP id x18mr21996107eji.547.1595879163298;
        Mon, 27 Jul 2020 12:46:03 -0700 (PDT)
Received: from skbuf ([188.25.95.40])
        by smtp.gmail.com with ESMTPSA id pv28sm4494802ejb.71.2020.07.27.12.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 12:46:02 -0700 (PDT)
Date:   Mon, 27 Jul 2020 22:46:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     yangbo.lu@nxp.com, netdev@vger.kernel.org, laurent.brando@nxp.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH] net: mscc: ocelot: fix hardware timestamp dequeue logic
Message-ID: <20200727194600.pbtzcyrbg33fots5@skbuf>
References: <20200727102614.24570-1-yangbo.lu@nxp.com>
 <20200727.120608.2245293587733963820.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727.120608.2245293587733963820.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:06:08PM -0700, David Miller wrote:
> From: Yangbo Lu <yangbo.lu@nxp.com>
> Date: Mon, 27 Jul 2020 18:26:14 +0800
> 
> > From: laurent brando <laurent.brando@nxp.com>
> > 
> > The next hw timestamp should be snapshoot to the read registers
> > only once the current timestamp has been read.
> > If none of the pending skbs matches the current HW timestamp
> > just gracefully flush the available timestamp by reading it.
> > 
> > Signed-off-by: laurent brando <laurent.brando@nxp.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> 
> Applied and queued up for -stable, thanks.
> 
> So you have to read the hwtimestamp, even if you won't use it for
> any packets?

That's not the main point, but rather that you must read the timestamp
corresponding to the _current_ packet, and not the _next_ one in the
FIFO.

I slightly disagree with the commit description, in that it paints only
half of the story, and that can raise eyebrows about how this ever
worked. When in reality, it isn't fixing a problem we ever saw in real
life (although, nonetheless, it is a valid fix).

The ocelot_get_hwtimestamp function reads the 30-bit SYS::PTP_TXSTAMP
register in order to reconstruct a full 64-bit TX timestamp that will be
delivered to user space.

But the VSC7514 datasheet specifies this:

    Writing to the one-shot register SYS::PTP_NXT removes the current
    head-of-line entry and advances the pointer to the next entry in the
    time stamp queue.

So, if ocelot_get_hwtimestamp is called after writing to SYS_PTP_NXT,
then there is a chance that the TX timestamp that has been collected
actually doesn't correspond to the expected timestamp ID which was
matched to skb->cb[0], but it corresponds to the next timestamp in the
FIFO. In fact, this chance should be 100% and this should raise the
question of why this wasn't caught earlier. But it looks like if the TX
timestamp FIFO contains a single entry, then SYS_PTP_TXSTAMP does not
get updated when writing to SYS_PTP_NXT. And it looks like our IRQ
handler is always processing the TX timestamps early enough that
there's a single entry in the FIFO, no matter how hard we tried to
stress it.

Because the logic in ocelot_get_txtstamp tries to match skb's awaiting a
TX timestamp with actual TX timestamps once they become available, there
needs to be logic for iterating through the entire TX FIFO, and still do
something in case the TX timestamp could not be matched. That
"something" is to acknowledge the current TX timestamp, and go on. So
that's the reason why writing to SYS_PTP_NXT is done early. But it is
_too_ early.

So, to fix the bug, first we read the TX timestamp, even if skb_match is
going to be NULL, and only _then_ should we ack the timestamp. In
practice, skb_match being NULL is probably a big fat bug. There's
nothing 'graceful' about that, we should be issuing a WARN_ON, because
if nothing was matched, it means that the hardware has raised an
interrupt for a TX timestamp corresponding to a frame that the operating
system has no idea about. But the driver happily ignores it and carries
on.

Thanks,
-Vladimir
