Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D24FE2F7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356123AbiDLNoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354147AbiDLNoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCCF14ECD4
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649770955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BBe8NJbB/NGE5hfWVeZ1eXc/XEjoOVUEazhRhSRRhFM=;
        b=P647y1yAqB/7m8QEm5Rh1KbvIMRBn56AW4JW9fkYDcVBrnsFNupnaGVCVH0keNZtALyoD0
        pz7K8CMcdeVdDtY+KxxtFKLixEZ5oYrq1TtaIkMZnj+sQ6V+7zvESQuAL/W2qTgk7lmykP
        irbPTKU/1WZ0jKK3XR8lXvqRbNW8CFg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-g2xYTWatOzi0crlkhcxa7A-1; Tue, 12 Apr 2022 09:42:33 -0400
X-MC-Unique: g2xYTWatOzi0crlkhcxa7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F15DD2999B4E;
        Tue, 12 Apr 2022 13:42:32 +0000 (UTC)
Received: from wtfbox.lan (unknown [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BC0C9D6E;
        Tue, 12 Apr 2022 13:42:20 +0000 (UTC)
Date:   Tue, 12 Apr 2022 15:42:18 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, asavkov@redhat.com,
        Eugene Syromiatnikov <esyr@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] timer: add a function to adjust timeouts to be
 upper bound
Message-ID: <YlWBun1whllq2BDt@wtfbox.lan>
References: <20220407075242.118253-2-asavkov@redhat.com>
 <87zgkwjtq2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87zgkwjtq2.ffs@tglx>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 02:37:25AM +0200, Thomas Gleixner wrote:
> On Thu, Apr 07 2022 at 09:52, Artem Savkov wrote:
> > +	return -1;
> > +}
> > +
> > +static int calc_wheel_index(unsigned long expires, unsigned long clk,
> > +			    unsigned long *bucket_expiry)
> > +{
> > +	unsigned long delta = expires - clk;
> > +	unsigned int idx;
> > +	int lvl = get_wheel_lvl(delta);
> > +
> > +	if (lvl >= 0) {
> > +		idx = calc_index(expires, lvl, bucket_expiry);
> >  	} else if ((long) delta < 0) {
> >  		idx = clk & LVL_MASK;
> >  		*bucket_expiry = clk;
> > @@ -545,6 +555,38 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk,
> >  	return idx;
> >  }
> 
> This generates horrible code on various compilers. I ran that through a
> couple of perf test scenarios and came up with the following, which
> still is a tad slower for the level 0 case depending on the branch
> predictor state. But it at least prevents the compilers from doing
> stupid things and on average it's on par.
> 
> Though the level 0 case matters because of *drumroll* networking.
> 
> Just for the record. I told you last time that your patch creates a
> measurable overhead and I explained you in depth why the performance of
> this stupid thing matters. So why are you not providing a proper
> analysis for that?

I did do a simple check of measuring the time it takes for
calc_wheel_index to execute and it turned out a tad lower after the
patch. Your measurements are sure to be much more refined so would you
give me any pointers on what to measure and which cases to check to have
a better view on the impact of these patches?

> > +/**
> > + * upper_bound_timeout - return granularity-adjusted timeout
> > + * @timeout: timeout value in jiffies
> > + *
> > + * This function return supplied timeout adjusted based on timer wheel
> > + * granularity effectively making supplied value an upper bound at which the
> > + * timer will expire. Due to the way timer wheel works timeouts smaller than
> > + * LVL_GRAN on their respecrive levels will be _at least_
> > + * LVL_GRAN(lvl) - LVL_GRAN(lvl -1)) jiffies early.
> 
> Contrary to the simple "timeout - timeout/8" this gives better accuracy
> as it does not converge to the early side for long timeouts.
> 
> With the quirk that this cuts timeout=1 to 0, which means it expires
> immediately. The wonders of integer math avoid that with the simple
> timeout -= timeout >> 3 approach for timeouts up to 8 ticks. :)
> 
> But that want's to be properly documented.
> 
> > +unsigned long upper_bound_timeout(unsigned long timeout)
> > +{
> > +	int lvl = get_wheel_lvl(timeout);
> 
> which is equivalent to:
> 
>          lvl = calc_wheel_index(timeout, 0, &dummy) >> LVL_BITS;
> 
> Sorry, could not resist. :)

Right, but that would mean a significantly more overhead, right?

> The more interesting question is, how frequently this upper bounds
> function is used. It's definitely not something which you want to
> inflict onto a high frequency (re)arming timer.

As of now not that frequent. Instead of re-arming the timer networking
code allows it to expire and makes the decisions in the handler, so it
shouldn't be a problem because keepalives are usually quite big.

> Did you analyse that? And if so, then why is that analysis missing from
> the change log of the keepalive timer patch?

I agree, this needs to be added.

> Aside of that it clearly lacks any argument why the simple, stupid, but
> fast approach of shortening the timeout by 12.5% is not good enough and
> why we need yet another function which is just going to be another
> source of 'optimizations' for the wrong reasons.

I am just not used to this mode of thinking I guess. This will be more
efficient at the cost of being less obvious and requiring to be
remembered about in case the 12.5% figure changes.

> Seriously, I apprecitate that you want to make this 'perfect', but it's
> never going to be perfect and the real question is whether there is any
> reasonable difference between 'good' and almost 'perfect'.
> 
> And this clearly resonates in your changelog of the network patch:
> 
>  "Make sure TCP keepalive timer does not expire late. Switching to upper
>   bound timers means it can fire off early but in case of keepalive
>   tcp_keepalive_timer() handler checks elapsed time and resets the timer
>   if it was triggered early. This results in timer "cascading" to a
>   higher precision and being just a couple of milliseconds off it's
>   original mark."
> 
> Which reinvents the cascading effect of the original timer wheel just
> with more overhead. Where is the justification for this?
> 
> Is this really true for all the reasons where the keep alive timers are
> armed? I seriously doubt that. Why?
> 
> On the end which waits for the keep alive packet to arrive in time it
> does not matter at all, whether the cutoff is a bit later than defined.
> 
>      So why do you want to let the timer fire early just to rearm it? 
> 
> But it matters a lot on the sender side. If that is late and the other
> end is strict about the timeout then you lost. But does it matter
> whether you send the packet too early? No, it does not matter at all
> because the important point is that you send it _before_ the other side
> decides to give up.
> 
>      So why do you want to let the timer fire precise?
> 
> You are solving the sender side problem by introducing a receiver side
> problem and both suffer from the overhead for no reason.

I was hoping to discuss this during the second patch review. Keepalive
timer handler complexity makes me think that it handles a lot of cases I
am not currently aware of and dropping the "cascading" code would result
in problems in places not obvious to me.

Josh's point also makes sense to me. For cases when keepalive is used to
check for dead clients I don't think we want to be early.

> Aside of the theoerical issue why this matters at all I have yet ot see
> a reasonable argument what the practical problen is. If this would be a
> real problem in the wild then why haven't we ssen a reassonable bug
> report within 6 years?

I think it is unusual for keepalive timers to be set so close to the
timeout so it is not an easy problem to hit. But regardless of that from
what I saw in related discussions nobody sees this keepalive timer behavior
as normal let alone expected. If you think it is better to keep it as is
this will need to be clearly described/justified somewhere, but I am not
sure how one would approach that.

-- 
Regards,
  Artem

