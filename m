Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614C946CE3
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFNXX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:23:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38084 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFNXX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:23:56 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so3959517ljg.5;
        Fri, 14 Jun 2019 16:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pDUDSK7aY+fziRLTyE5gQ/97uoVyficveK+IhkDVU/s=;
        b=WisDtLLcc9fBrSNTwajji89OE8JpSP3EnNg0ovjwNHxtLQeWB1mkqn+0jjNgrww67l
         5bj7DQ4F656ArFMX4vRbtsRU47PW9DvU27E5AcI33LlN87bpO6CI9dQlu1bqBVvmxsmG
         rP78nN+1YdkrMtA5Ym9mAeqHccUK/WFg1+NxNFxz/GRxuG4qksXKLkhufMXYKTMaDUfs
         heny44h88kewMJFu+q3OaNCFcvdoxFQVd6AFt+dODurKz+PdHAT3p7TS/Eh7+n/oD2/n
         DmKthDe3Rzkl0rcbF7REB7QE1ezbbwHywvC2QjSeyQwJmikLjm7787fvrAT8Sl0Y+AWW
         2Bbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pDUDSK7aY+fziRLTyE5gQ/97uoVyficveK+IhkDVU/s=;
        b=m3a9aJw5P5n8bmK17Pq+qsx656tJotTtQH7tkRnMC9WFET9gduYf5YZJUEEe27gDH1
         kHqx51KlfQAZD4QnPI77PnSPmPXOhCpnFt3kXh3ckoi04Zfu8WmPjF/IAxUCfn4gqraD
         IsGTeCIY56p3sk/XHceczqtw54rz/AwVQc/G79OPjePwqREbpcMVzereaq0SSlfLx14o
         gslkvKdk4PBwm+L2a5RnI+Tn6R91o9lFmmEhvvoFo3/qtD4sh+qX0T3cZHsh3VIK/+2P
         TWgxpwv3O/gdb6JIcMWUjzXYPxt4iUorNfktVN0e1n9qdzVvfVOQWkxekN/uXvXIPkqZ
         c7OA==
X-Gm-Message-State: APjAAAXeX0ANGBde1Bli9ovUkqTzkcXC69btXiZDkIfyjXNUp9JnITjm
        ePyPNL794YMgK/UqZz7RqDubiS3ilQlDRCVzYBQ=
X-Google-Smtp-Source: APXvYqwzsrM06S59JVQf6DjWTNnsTo2H3EA3pcRq1Q7xqDC81psVMJwwepWv85hR4eAb6Wu4ESaQNKKyjMB2Kifj7dI=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr31760132lje.214.1560554633648;
 Fri, 14 Jun 2019 16:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
 <20190614211916.jnxakyfwilcv6r57@treble> <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
 <20190614231311.gfeb47rpjoholuov@treble>
In-Reply-To: <20190614231311.gfeb47rpjoholuov@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 16:23:41 -0700
Message-ID: <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:13 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 02:27:30PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Fri, Jun 14, 2019 at 02:05:56PM -0700, Alexei Starovoitov wrote:
> > > > Have you tested it ?
> > > > I really doubt, since in my test both CONFIG_UNWINDER_ORC and
> > > > CONFIG_UNWINDER_FRAME_POINTER failed to unwind through such odd frame.
> > >
> > > Hm, are you seeing selftest failures?  They seem to work for me.
> > >
> > > > Here is much simple patch that I mentioned in the email yesterday,
> > > > but you failed to listen instead of focusing on perceived 'code readability'.
> > > >
> > > > It makes one proper frame and both frame and orc unwinders are happy.
> > >
> > > I'm on my way out the door and I just skimmed it, but it looks fine.
> > >
> > > Some of the code and patch description look familiar, please be sure to
> > > give me proper credit.
> >
> > credit means something positive.
>
> So you only give credit for *good* stolen code.  I must have missed that
> section of the kernel patch guidelines.

what are you talking about?
you've posted one bad patch. I pointed out multiple issues in it.
Then proposed another bad idea. I pointed out another set of issues.
Than David proposed yet another idea that you've implemented
and claimed that it's working when it was not.
Then I got fed up with this thread and fix it for real by reverting
that old commit that I mentioned way earlier.
https://patchwork.ozlabs.org/patch/1116307/
Where do you see your code or ideas being used?
I see none.
