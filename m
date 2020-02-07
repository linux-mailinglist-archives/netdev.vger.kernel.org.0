Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA61555D0
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgBGKff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:35:35 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37562 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBGKfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:35:33 -0500
Received: by mail-oi1-f194.google.com with SMTP id q84so1517345oic.4
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 02:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+MTBIq0dddTeP02GHBszdbSMO1SQaDx30ue5UHNPWs=;
        b=DiBU9jLAkQjbewdrjbN+1qdsEGrM7DQgqmJwn78UhocpmXvfy+9CYnCnS3s/Zg1Mhe
         b04TsiLHoe2b2HGAKkuVJjOmgtZKPx8ffA85ExkeOeNb6xAoIsHvmOIljZOPhL+VV3eG
         VwqGygg5Nn89oUfUonQfqxTO+mzPwubcdtuzKQS27iIUF7K8kH3+y2HDxXxvfhGLqiE4
         obHccYxYoZdexU1OkIqzOtg3dQuAp7YizUPKpI+Rd5vcjY7kOHox9L28mdqLReEdtlRq
         IoOsBrDnDrwSJIFHBMFJEw960ttZIx5Vpm8LQBY3TRL1jpHMYqWjaP2z8hFAoKkzjwdQ
         KMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+MTBIq0dddTeP02GHBszdbSMO1SQaDx30ue5UHNPWs=;
        b=AD0/VBpF0Jv7hYANkZCl3yn+YW+YQMIDDzt3eT8xiuo8FHc/Lf9hpQbCBpfi9pQ1sM
         XFVpvqpFooT4tLT4XgKciItt4fJcvR1cfj6pzoICgNijv1okLPo0bW15gF6wEswfH06l
         zmzfbtFgvcu8oV05NCm5iz51DNFCOlN2R1gzHcXYjDJgtKOaucMsU/xVbonJA42u2inE
         QH5HKbh7dalzYtHqRF9m34vnDQI+VoNLfEzsC+tWurFKfa3YvPFEuwwz6JplInCIQF1d
         uTVfx4NaPGSVy3nkdUCLk6iNS5YyiH5cIOkuLvvSuy7B7uV3a3oMPktuAWtYdxud01Vv
         GwRQ==
X-Gm-Message-State: APjAAAVtzJJvg0csCPN4ELlbwisNou6rBGaWq0fcLwK16u21VopeZZzZ
        1V0OWKARzbrZ6UFTMtPOuiILi9EWyfqsWu15g4oyfA==
X-Google-Smtp-Source: APXvYqwHiDc6F97m21/1npRLG/GVJq6x8dLzKdyGW2PmY3mbfvVlRr8d1ffuFMwR2F5HO/gzSUg+dbYxSCQo8UlmAr8=
X-Received: by 2002:aca:c7ca:: with SMTP id x193mr1638203oif.70.1581071732047;
 Fri, 07 Feb 2020 02:35:32 -0800 (PST)
MIME-Version: 1.0
References: <1580841629-7102-1-git-send-email-cai@lca.pw> <20200206163844.GA432041@zx2c4.com>
 <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
In-Reply-To: <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Fri, 7 Feb 2020 11:35:20 +0100
Message-ID: <CANpmjNM+=mm0BAj=a2zh3ameKPxDaOb59r4L7c34uchcPAqbCg@mail.gmail.com>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, Qian Cai <cai@lca.pw>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Feb 2020 at 18:10, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 2/6/20 8:38 AM, Jason A. Donenfeld wrote:
> > Hi Eric,
> >
> > On Tue, Feb 04, 2020 at 01:40:29PM -0500, Qian Cai wrote:
> >> -    list->qlen--;
> >> +    WRITE_ONCE(list->qlen, list->qlen - 1);
> >
> > Sorry I'm a bit late to the party here, but this immediately jumped out.
> > This generates worse code with a bigger race in some sense:
> >
> > list->qlen-- is:
> >
> >    0:   83 6f 10 01             subl   $0x1,0x10(%rdi)
> >
> > whereas WRITE_ONCE(list->qlen, list->qlen - 1) is:
> >
> >    0:   8b 47 10                mov    0x10(%rdi),%eax
> >    3:   83 e8 01                sub    $0x1,%eax
> >    6:   89 47 10                mov    %eax,0x10(%rdi)
> >
> > Are you sure that's what we want?
> >
> > Jason
> >
>
>
> Unfortunately we do not have ADD_ONCE() or something like that.
>
> Sure, on x86 we could get much better code generation.
>
> If we agree a READ_ONCE() was needed at the read side,
> then a WRITE_ONCE() is needed as well on write sides.
>
> If we believe load-tearing and/or write-tearing must not ever happen,
> then we must document this.

Just FYI, forgot to mention: Recent KCSAN by default will forgive
unannotated aligned writes up to word-size, making the assumptions
these are safe. This would include things like 'var++' if there is
only a single writer. This was added because of kernel-wide
preferences we were told about.

Since I cannot verify if this assumption is always correct, I would
still prefer to mark writes if at all possible.  In the end it's up to
maintainers.

Thanks,
-- Marco
