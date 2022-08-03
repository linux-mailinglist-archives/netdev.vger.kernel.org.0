Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6855894C1
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiHCXZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbiHCXZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:25:02 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F75B2A40D
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:25:01 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d20so10397959pfq.5
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=qTGeTcvnCUefZYE/xFVjYpxikNnna7PdM4h3a6tPfiM=;
        b=UyecZluAhG6BTxrROgCEJxpWmeHKaMGZYY/zLWio09Tn/pxoqlnUTQPSxVq6MC+lib
         rVUQ6XTiuc8LrjBf4PtvslzanK0D4aYN7sK09vlj1R7j/vds6FewMURF2lfDeF1LTCr1
         TdcJwTJDiQB6ey/80KQZJriZ9vRNEVpDR84gwKTyoCGocdwvQKwOB2TcGX49nwreVE9w
         1zDLa+Piw+YFqO1AonlA9e9OCKOoX5nHfTTSlVAAlDnuopZS5V8wLG32Kt7gc/J0xQm2
         Q3scCPxMbcdL0JKg14Fn/skIuy6j53dHI51dAuC5dTux+MRDY+Yk13cIHbiw+hsZjDVn
         ITdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=qTGeTcvnCUefZYE/xFVjYpxikNnna7PdM4h3a6tPfiM=;
        b=eaP8M39FIXd97Q2sHb2dvJ8VZmI18ckWX/ksesP219qLVDYVdFLrUxycCYPSxl6hQh
         62l3NCtS0tA+mv4IrJSRmQjGbsbV4dPlMZnWPETaF+5thY7Jm6zxIwOpd+1MAN7vuax+
         8ubc+P7r/24/iJshPYlKGjRwgyDGpmVmu3323AP451dfGMmWToQD8Eb4egrC3/ApyyI4
         fMtfd9bjDrkzMueuoskEfUdgtmHSDM+W3CFwVB1mACFSrX1VY5LWma+a0kovo9i+1CSy
         LsKrQw5op1zL6dyMj8RErMdli+vlVeTP9+/LhmcrKAz+eH4YJmUSplADqjaSsbbBJzuY
         /rDg==
X-Gm-Message-State: ACgBeo1VrLv618DfGEuSHXNAcdBBHPspbjlylBCBUdWHnuZ5hD5S9/vJ
        kTpMpRSsc1yC3WnZwnf4icZT321lsXpBFsBVbEI4bw==
X-Google-Smtp-Source: AA6agR6g5Jj9QG5hfuvAC6bblm2cNZkw4GDRlfL29cyiDl1zhaJ40EDIsYy2TIu+L8qKiu4etnL0bjkEYEZY+pRSaMU=
X-Received: by 2002:a63:ec15:0:b0:41c:2669:1e54 with SMTP id
 j21-20020a63ec15000000b0041c26691e54mr13165135pgh.253.1659569100704; Wed, 03
 Aug 2022 16:25:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220803204601.3075863-1-kafai@fb.com> <20220803204614.3077284-1-kafai@fb.com>
 <Yur9zosqo4zpVBx5@google.com> <20220803231921.nb623atry4qdrp5r@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220803231921.nb623atry4qdrp5r@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 3 Aug 2022 16:24:49 -0700
Message-ID: <CAKH8qBumw+-goDendFpcpzaq5u1ziJ97SUEQ5OwJKjbdtLDurA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/15] bpf: net: Avoid sk_setsockopt() taking
 sk lock when called from bpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 4:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Aug 03, 2022 at 03:59:26PM -0700, sdf@google.com wrote:
> > On 08/03, Martin KaFai Lau wrote:
> > > Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > the sk_setsockopt().  The number of supported optnames are
> > > increasing ever and so as the duplicated code.
> >
> > > One issue in reusing sk_setsockopt() is that the bpf prog
> > > has already acquired the sk lock.  This patch adds a in_bpf()
> > > to tell if the sk_setsockopt() is called from a bpf prog.
> > > The bpf prog calling bpf_setsockopt() is either running in_task()
> > > or in_serving_softirq().  Both cases have the current->bpf_ctx
> > > initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
> >
> > > This patch also adds sockopt_{lock,release}_sock() helpers
> > > for sk_setsockopt() to use.  These helpers will test in_bpf()
> > > before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> > > for the ipv6 module to use in a latter patch.
> >
> > > Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> > > is done in sock_setbindtodevice() instead of doing the lock_sock
> > > in sock_bindtoindex(..., lock_sk = true).
> >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >   include/linux/bpf.h |  8 ++++++++
> > >   include/net/sock.h  |  3 +++
> > >   net/core/sock.c     | 26 +++++++++++++++++++++++---
> > >   3 files changed, 34 insertions(+), 3 deletions(-)
> >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 20c26aed7896..b905b1b34fe4 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
> > >     return !sysctl_unprivileged_bpf_disabled;
> > >   }
> >
> > > +static inline bool in_bpf(void)
> > > +{
> > > +   return !!current->bpf_ctx;
> > > +}
> >
> > Good point on not needing to care about softirq!
> > That actually turned even nicer :-)
> >
> > QQ: do we need to add a comment here about potential false-negatives?
> > I see you're adding ctx to the iter, but there is still a bunch of places
> > that don't use it.
> Make sense.  I will add a comment on the requirement that the bpf prog type
> needs to setup the bpf_run_ctx.

Thanks! White at it, is it worth adding a short sentence to
sockopt_lock_sock on why it's safe to skip locking in the bpf case as
well?
Feels like the current state where bpf always runs with the locked
socket might change in the future.
