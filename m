Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06465B7287
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 07:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387921AbfISFPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 01:15:36 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33395 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387504AbfISFPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 01:15:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id t11so1063671plo.0
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 22:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Vq0a8WD9gtmgvUFWz21hWJGSxYjJkuzimTo692aaBM=;
        b=WVTcMwoOr0q0/p/t7JCM3HguUI5rE4tITkzmNedtWweeeBNBd5GO/hkeQaEUJv73Yb
         a75pwVuz3yU76mN4TbQc6j4wrocNVVXCqEFZl/PzPyt/1i0golJ2W5Y7edi2kdDaS30o
         hNQK/6whe2khKP2FyKBGGW366imP2ieFk4QdWabAQDZuOyH2qW5QVducnOrM9kXzb4mv
         uS2P4ssBS5RNQwR9SCiqvAiP8H8HTEyqjIpSCt6PvejX5u5BRXkzjOOLfhILMBNgOpgS
         wFvv+1U2U7BWCeG3IpMOIcLGrfFu8BOK61oNtumtL1jTB5ti1N21R9seHrATrDJut0a9
         xYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Vq0a8WD9gtmgvUFWz21hWJGSxYjJkuzimTo692aaBM=;
        b=MJ2prnwN2GH5/eh5YLR9yFq1bqv+wKese0ChyG+GVEZgMBIe9aknlhjYg1QHl4oCtC
         ey6Z7R3cHpsVCMM//M1DdldcQwF45fRFOl8gvpQztemfmj5SPbxl1cvMV/a/dZYpiP/F
         f6F0EGQdks8LkkapdI4Skmg5ocLsQqCPI0wE4zNciS8EFd69KvecCKYfcQr+w8Y4ZHhn
         7qrQpJx7n+P2/3++dTX4OTkGHvhJcUMZtlIJ4N+mbaHv9sz/XtYm3mfwvfsGUebWvwqC
         +Lu7xdOLyx3U99zsjrxNuoAQax7NgblBu6pQQdcE9iM71mh6tqOA3oGkN2DC4zd43yog
         QmxQ==
X-Gm-Message-State: APjAAAUopukkrF9RvGUYSAFzMtVC0Jj0IRPPPPd4+LZOdxKvJIxFeYTJ
        r1ZCxmPiUrG7fd7VVfEJud9bnP4TuehVJHlsIXY=
X-Google-Smtp-Source: APXvYqwldsmi45wanIHMRsVTCmcYzSdiger0GTGMjMuK4IYvXYdXzx87JlcRJd3veb9LhoWinxkj6FGQgWfLmsKEvxE=
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr7687181plq.316.1568870135200;
 Wed, 18 Sep 2019 22:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com> <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
In-Reply-To: <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 18 Sep 2019 22:15:24 -0700
Message-ID: <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 7:41 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/18/19 5:24 PM, Cong Wang wrote:
> > The TCA_KIND attribute is of NLA_STRING which does not check
> > the NUL char. KMSAN reported an uninit-value of TCA_KIND which
> > is likely caused by the lack of NUL.
> >
> > Change it to NLA_NUL_STRING and add a max len too.
> >
> > Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")
>
> The commit referenced here did not introduce the ability to go beyond
> memory boundaries with string comparisons. Rather, it was not complete
> solution for attribute validation. I say that wrt to the fix getting
> propagated to the correct stable releases.

I think this patch should be backported to wherever commit 8b4c3cdd9dd8
goes, this is why I picked it as Fixes.

>
> > Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com
>
> What is the actual sysbot report?

https://marc.info/?l=linux-kernel&m=156862916112881&w=2
