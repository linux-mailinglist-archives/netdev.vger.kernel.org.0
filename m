Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B445124A792
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHSUMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgHSUME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:12:04 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40ACC061757;
        Wed, 19 Aug 2020 13:12:04 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id e14so14029241ybf.4;
        Wed, 19 Aug 2020 13:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=16Bh+gtkGAtH7dti7xmGaA8DmouIKg+TxOaZrd30NIc=;
        b=Qygx6RHv4SsSoOkYVJwBkgu7g66D1MpUjKM87LS63pZ0tXIy9BkQvW2KZ97PlaL+gP
         jzsFpVpih5HBUXtsDmPYPNDk8noIxR5VlBoK2JZHlfzR+tqS789jCE2Aduz6NXU/24wo
         5wLUsGTX59J9nJwVz3GkoEMGMqg29nU3l2FU62tojUzul+So6B0rckLioC/PopeJ+KTU
         ru6Dtad9TJE8ivfSKzZZ/IohpVtfBM6KAbaeU7Th0cRt3/SI996cmmlIbSQsH34xIh2X
         gKSCNhjUHLsnCiSfUsHa95Y0slNGZVslRWw0hM59FJlvYuIZt+A4xxd7pF1c+4VMntFA
         tRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=16Bh+gtkGAtH7dti7xmGaA8DmouIKg+TxOaZrd30NIc=;
        b=ka5+bFKrPuOkyUfTYfSr+5I9/+nKpi05UM78HTyhYmk8QZSX0tJcJUFXL7xdH+ZqL/
         PPKlaAIl00EASWj86p4nDx6sOikXhaZMekoq99fqNT3WqZUaQgWuXZA574ZARgCzXukn
         g/jPhyFvJ6uB+PpbSww0NeGoS/rlyWxKlkeS4rU9BWoVkYlU+JsJ2GGGU1KqVHsJg4J9
         PoZ4vZP02AVLAnYqSQkN2uUrMwivHZIQYcZ1ZpvVfo6hZC61jdgkWfiifS6R0AvCfEZM
         o+P+eyME2LKVzQFKodOAJW15rDlpKM/Q9Vd+0zIDHxXEjNk1Te+Ybm+kDRYvffj0209c
         44Ww==
X-Gm-Message-State: AOAM530z7yzSOUR9DxAcPggIyKPoySFvuDjqEyQc1HDk1xwFsyI52Mg4
        QxM5XoITPnfBsZZcYxE7m7OUEiky6XDX/SfgXxHSpA2+
X-Google-Smtp-Source: ABdhPJzWENap35qtB0Iu5Qnnyg/EhnjNfUCDs4PWGYOXF2DbYf/Z7K3lLLG95dMXu51OBirQOp5QipSrLGAYfpk0jKU=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr176161ybk.230.1597867923867;
 Wed, 19 Aug 2020 13:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200818213356.2629020-1-andriin@fb.com> <20200818213356.2629020-5-andriin@fb.com>
 <e37c5162-3c94-4c73-d598-f2a048b2ff27@fb.com>
In-Reply-To: <e37c5162-3c94-4c73-d598-f2a048b2ff27@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 13:11:52 -0700
Message-ID: <CAEf4BzZ8y=fFBhwP_+owtYA45WNaa324OVftUF3jW-=Mgy45Yw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] libbpf: sanitize BPF program code for bpf_probe_read_{kernel,user}[_str]
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:42 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
> > Add BPF program code sanitization pass, replacing calls to BPF
> > bpf_probe_read_{kernel,user}[_str]() helpers with bpf_probe_read[_str](), if
> > libbpf detects that kernel doesn't support new variants.
>
> I know this has been merged. The whole patch set looks good to me.
> A few nit or questions below.
>
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c | 80 ++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 80 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ab0c3a409eea..bdc08f89a5c0 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -180,6 +180,8 @@ enum kern_feature_id {
> >       FEAT_ARRAY_MMAP,
> >       /* kernel support for expected_attach_type in BPF_PROG_LOAD */
> >       FEAT_EXP_ATTACH_TYPE,
> > +     /* bpf_probe_read_{kernel,user}[_str] helpers */
> > +     FEAT_PROBE_READ_KERN,
> >       __FEAT_CNT,
> >   };
> >
> > @@ -3591,6 +3593,27 @@ static int probe_kern_exp_attach_type(void)
> >       return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
> >   }
> >
> [...]
> >
> > +static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id *func_id)
> > +{
> > +     __u8 class = BPF_CLASS(insn->code);
> > +
> > +     if ((class == BPF_JMP || class == BPF_JMP32) &&
>
> Do we support BPF_JMP32 + BPF_CALL ... as a helper call?
> I am not aware of this.

Verifier seems to support both. Check do_check in
kernel/bpf/verifier.c, around line 9000. So I decided to also support
it, even if Clang doesn't emit it (yet?).

>
> > +         BPF_OP(insn->code) == BPF_CALL &&
> > +         BPF_SRC(insn->code) == BPF_K &&
> > +         insn->src_reg == 0 && insn->dst_reg == 0) {
> > +                 if (func_id)
> > +                         *func_id = insn->imm;
>
> looks like func_id is always non-NULL. Unless this is to support future
> usage where func_id may be NULL, the above condition probably not needed.

Yeah, not sure why I assumed it might be optional, maybe the first
version of the code used to pass NULL in some other place. But I think
it's fine, this is a generic helper function that might be used later
as well. So I'd just keep it as is, it doesn't hurt.

>
> > +                 return true;
> > +     }
> > +     return false;
> > +}
> > +
> [...]
