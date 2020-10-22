Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6829640B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368182AbgJVRtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900871AbgJVRtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 13:49:31 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EC2C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:49:30 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id n18so1378822vsl.2
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IUzzpepgoq6OyByP4iwak7spj02El2UTg2hayUrAPh8=;
        b=kwf8WPh6k+rgq4BlX1IHIyQ7c3jRGZlir3YGQIZUy8doAtL53W9ppn7VtMuA7Y9xGI
         ajJhTcIf0j/pG9QZbHRSUD9vlSFmo2dsXdYydQwNvH7mRaFMDFMdj1IhXFJksIgYQpN3
         PwCcM+USLgMPqkiQDgRSYtMX552ibk3iCkZPiZRwzOfbFlPqG0F8MTYOXbPHOi2OsRa+
         N8jfBzqW/aItFzpp2xRND2KNP8/lrbftycYhvMSeDHw2cPuxOa0Yb5IaNhsF4WJ6HLrm
         IxiE5tujwfhukDLIIQZ/km6UFbDenpYjcbQGAAOXB9AkJq+yjcG3KiUpDGCA4GFJOQU3
         I7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IUzzpepgoq6OyByP4iwak7spj02El2UTg2hayUrAPh8=;
        b=BcMeZx6ISiz18HUiJqR0luEpHzo7jh3oBYFUH0ausjXI1+iAG09Tv9e11obka3B9NG
         MAOF8Xip+dg6j+8OCuJupiyECAnuv7RdR35dsR3SRUavutbcZHIukdNDPOiysYG71jzs
         ufQAIUkLF1vx+t06XUKxnVoEFdUPL55GtofoFV0oIGOMPcwon5i+nnsiW6sACt70IWNb
         wvSQ3s9QEcps9Bvam7VMe4JHGRfS7ZGu5Sbu3SNDroO73cwbB7UK/djatyPD/vBfYXUG
         CLjFznBAUKkysORZYtrdZmJvOZHOYcmZ0ufvQSIw+vVb5+UvFe9O6Zy5iEI8R0F0k+LC
         +RgQ==
X-Gm-Message-State: AOAM5307DMknBYOY5RefjvOJAzDEAAwNnwWbPOszQEL191+qWpIJrMmc
        EMDE267h61ASB9Ba7k9OiD99QmY1W9uEDm6bS791Ip8z7GA=
X-Google-Smtp-Source: ABdhPJxJWYtDcKJgi7eiJ7DEZLz57ZYdN9dP03hMyA0j8kwZdz/56JPK47+I5RbL4YpMcP104y8at+e1TJsEby5xDXM=
X-Received: by 2002:a05:6102:9cd:: with SMTP id g13mr3114549vsi.44.1603388969733;
 Thu, 22 Oct 2020 10:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
 <20201022090757.4ac6ba0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADVnQy=KhEZ6OA+Kr2M8iP7zuPO7uc2jLJ1rxi1Qq8pau2KZ2w@mail.gmail.com> <20201022104742.5093cce1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022104742.5093cce1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 22 Oct 2020 13:49:12 -0400
Message-ID: <CADVnQynQubiQndksqbcrMgKPnhay35aFC0vOMwTv6RQyyY0mUw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix to update snd_wl1 in bulk receiver fast path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 1:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Oct 2020 13:04:04 -0400 Neal Cardwell wrote:
> > > In that case - can I slap:
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > >
> > > on it?
> >
> > Yes, slapping that Fixes footer on it sounds fine to me. I see
> > that it does apply cleanly to 1da177e4c3f4.
>
> FWIW even if it didn't - my modus operandi is to have the tag pointing
> at the earliest point in the git history where the bug exists. Even if
> the implementation was completely rewritten - we want to let the people
> who run old kernels know they may experience the issue.
>
> Backporters will see the patch doesn't apply and make the right call.
>
> That said I don't think the process documentation is very clear on
> this, so maybe someone more experienced will correct my course :)
>
> > Or let me know if you would prefer for me to resubmit a v2 with that footer.
>
> I'll add it, no worries.

Great. Thanks!

neal
