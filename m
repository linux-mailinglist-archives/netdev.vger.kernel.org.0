Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1EC458F70
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbhKVNfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:35:38 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:47929 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhKVNff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 08:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=fhLYsN37BNK91WHy0l5pcGO68F+xD/Qi0X1ctJLUJPA=; b=afvdlbHrksI8nqCRxeFljPpIwr
        qsutE3PqllxGcYq4gEDoERF/5i/YaPzdatZMp1reCLJAvrvmhTjsLV6cuiFq5NkBp/WHGloF2QH4B
        stTwzQkUsPd7kowGNCMtTaqu+qboaNGhQUnJIqAib+sXomTGZ7l3z9/P5gbhra6br5BiEF6l2CtEa
        5AcKQZ0Z1Xc+V+MTOx49FKfh96AfghmTu8rgdHhTf2hEB2/ldE7sBazcuafRijCU0m5/pgS4Aj0Wa
        vavoeIMinNwYHuzfQ+bkZtqVphvE0TZZBSHJnCcdvkN1RzlM8196woI5cflKV8ZSO84Qw2wyBhS0R
        bFqwWNAZkVfdpY6sgKgxO7TJI5Dn36dovbd1jW9ZXxrX3JKyAdYpNoHoZ0ODcCmx646pvNQBnPWXZ
        NqnyhkfLMhP4XBz3CEUFtn8VtcHBmE0JHrhNvERamqiz+da2W077pjOXbB/8xntPF+QeOqzzlGlXs
        0HcAYH+avM2V8BFMHGBmwV0YTxCuCU4p+7XL6MJUcVaM5NSgnmDn3owzC9aiW8PwXmnhtkoL1vsEu
        70kcyvGF2sbEypaxu0lN09c0HhZn7hJLG/EDSdWlX9w1IKPkFUT0LelV3tIKIFs8zMyMr4iCJ7xdT
        BwTZuANNvgXFRxMVMdpXFAxwwwJEJj3lbm3G8tSpI=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Date:   Mon, 22 Nov 2021 14:32:23 +0100
Message-ID: <1797352.eH9cFvQebf@silver>
In-Reply-To: <YZrEPj9WLx36Pm3k@codewreck.org>
References: <YZl+eD6r0iIGzS43@codewreck.org> <4244024.q9Xco3kuGk@silver> <YZrEPj9WLx36Pm3k@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sonntag, 21. November 2021 23:12:14 CET Dominique Martinet wrote:
> Christian Schoenebeck wrote on Sun, Nov 21, 2021 at 05:57:30PM +0100:
> > > Although frankly as I said if we're going to do this, we actual can
> > > majorate the actual max for all operations pretty easily thanks to the
> > > count parameter -- I guess it's a bit more work but we can put arbitrary
> > > values (e.g. 8k for all the small stuff) instead of trying to figure it
> > > out more precisely; I'd just like the code path to be able to do it so
> > > we only do that rechurn once.
> > 
> > Looks like we had a similar idea on this. My plan was something like this:
> > 
> > static int max_msg_size(enum msg_type) {
> > 
> >     switch (msg_type) {
> >     
> >         /* large zero copy messages */
> >         case Twrite:
> >         case Tread:
> >         
> >         case Treaddir:
> >             BUG_ON(true);
> >         
> >         /* small messages */
> >         case Tversion:
> >         ....
> >         
> >             return 8k; /* to be replaced with appropriate max value */
> >     
> >     }
> > 
> > }
> > 
> > That would be a quick start and allow to fine grade in future. It would
> > also provide a safety net, e.g. the compiler would bark if a new message
> > type is added in future.
> 
> I assume that'd only be used if the caller does not set an explicit
> limit, at which point we're basically using a constant and the function
> coud be replaced by a P9_SMALL_MSG_SIZE constant... But yes, I agree
> with the idea, it's these three calls that deal with big buffers in
> either emission or reception (might as well not allocate a 128MB send
> buffer for Tread ;))

I "think" this could be used for all 9p message types except for the listed 
former three, but I'll review the 9p specs more carefully before v4. For Tread 
and Twrite we already received the requested size, which just leaves Treaddir, 
which is however indeed tricky, because I don't think we have any info how 
many directory entries we could expect.

A simple compile time constant (e.g. one macro) could be used instead of this 
function. If you prefer a constant instead, I could go for it in v4 of course. 
For this 9p client I would recommend a function though, simply because this 
code has already seen some authors come and go over the years, so it might be 
worth the redundant code for future safety. But I'll adapt to what others 
think.

Greg, opinion?

Best regards,
Christian Schoenebeck


