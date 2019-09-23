Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF08BB8B7
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbfIWPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:54:59 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36395 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbfIWPy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:54:58 -0400
Received: by mail-yw1-f67.google.com with SMTP id x64so5407991ywg.3
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 08:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RR7moPibWHQl/a2ZxtkV0CY6zuLeYSN1MB4BNnQQ5v4=;
        b=MXvvRdC8Hk9t2MkbTsCiksQOFgfNERZ7su326YIjHkMm5IV5iIq3Pn4iuu8z5sL2CA
         w8pI5QQu3XAZPh+usJhAZJ56nhdaKJfdq34NkIj69xbKdOTnzQPPmpiZ0rOkK0khKOYh
         XCOG0KHUQVdNy4oHFDcetq63fimIXNt9sM0Ure26fcNLSGtREf3zLxIl4qG1osA+PbTr
         pl/7PJIWugylxBvJ9F9WY2olK0i4tgRZmbVBvm9T/bBuasiddML4FZL3G36fLtE2DqAH
         RqQtpCYkJxBrte2At6bayzuTguvsiHV/atM9U3iFGR2b+M9lF+4/951wZZFe5+uP1Lhc
         eFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RR7moPibWHQl/a2ZxtkV0CY6zuLeYSN1MB4BNnQQ5v4=;
        b=r/Krvd31rsUG2EPIpbMfksynxrFRni8tp3TW6hRrCh13YM2GCWYcQpPzCqqFUgeM5O
         kVW6OjuImoZthIQXZ1VvHodkbmt3dc+Z2/hDPTMYanLy4yVC8fUStLhMu+3oXGct0+HS
         ame4VlghaLGCzx0lCUns6S5VaH+AvYmbmN4tH5CLXBippgvZ/WkhAKpQBJ13N+KpWwrL
         RL5EUUcQ2sFre6etXp9J0vkexDCMV17BAS1YhXUVbKzqkVXEe8BOdgbtDs6KxaN+4J6m
         EaM4B3ruqvEPd8epjh/QMexKriPXReApolxagky6tjDubxnKj+OeUybhEv8G/LMyxIDO
         AuBw==
X-Gm-Message-State: APjAAAVfQdRfkcieMa0999XhWMeLbenvoLyqIsAIZwZBwNG3uRQJMXNS
        FtzPRgvBOfcP2WLtgQWvVEter/MMiRvx9z8pjkCzxQ==
X-Google-Smtp-Source: APXvYqwtvlSuQWct9HJNph8TUlhX3NcWhcbqF7PbMXgYQMHQTuLvnZMrmFd1yTtk2xCqlppxSeYzQbp3Iax8Nvsf2Y4=
X-Received: by 2002:a81:f20a:: with SMTP id i10mr120405ywm.424.1569254097492;
 Mon, 23 Sep 2019 08:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190918150539.135042-1-edumazet@google.com> <20190920191516.073d88b6@cakuba.netronome.com>
 <722331f3-55f8-868f-0f52-60e17e28e862@gmail.com>
In-Reply-To: <722331f3-55f8-868f-0f52-60e17e28e862@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Sep 2019 08:54:45 -0700
Message-ID: <CANn89iJqrYxufcj=mCQmqYty0F9DAokBR=4jcjQEZdsNrU_Y2w@mail.gmail.com>
Subject: Re: [PATCH net] sch_netem: fix a divide by zero in tabledist()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 8:53 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 9/20/19 7:15 PM, Jakub Kicinski wrote:
> > On Wed, 18 Sep 2019 08:05:39 -0700, Eric Dumazet wrote:
> >> syzbot managed to crash the kernel in tabledist() loading
> >> an empty distribution table.
> >>
> >>      t = dist->table[rnd % dist->size];
> >>
> >> Simply return an error when such load is attempted.
> >>
> >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >> Signed-off-by: Eric Dumazet <edumazet@google.com>
> >> Reported-by: syzbot <syzkaller@googlegroups.com>
> >
> > Applied, queued, thank you!
> >
>
> Note that another divide by zero seems possible in the same function,
> if sigma = 0x8000000

I meant 0x80000000  here (aka 2^31 )

>
>
> 2*sigma becomes zero, and we have yet another issue in :
>
> if (dist == NULL)
>    return ((rnd % (2 * sigma)) + mu) - sigma;
>
>
