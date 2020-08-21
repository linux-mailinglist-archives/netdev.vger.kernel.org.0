Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590BE24E265
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHUVFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgHUVF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:05:27 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D020C061573;
        Fri, 21 Aug 2020 14:05:27 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id t6so3307483ljk.9;
        Fri, 21 Aug 2020 14:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OQXCUp29lb6BqjJO2CJAZWNuIsyksrXiOIVbI4SnuhQ=;
        b=ZkRrP7nnSwu4H7WRZHwDY0FyeQx8taCAGN8U1bbJSDUf1hSWc3hA5TFEqucs6O/Hjt
         teaEDF6S8VznfC7i1/bP6wgoUPgTBf27tV+PYZ2iApilhyzR+eWVvCheAUdlDammD5Sn
         vM1fzGSQqoRtKeaQXZAnceSx+E4ThGH3nMM1Bzr68y9s0PICDu8b0C7/uAEE6reFAehT
         iX1Ek/vucYWPbUq2stzMEtZTNzUudctC4KZhOwuWsro40NHqPdfBrSFewkogFD8BHJ3L
         yDYrbfBh4cWd8IyyKdHuxOi9E8XMRSbmtGEgQxHDKlmFMZtuK75tMrQUZL12HWryInHY
         QDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OQXCUp29lb6BqjJO2CJAZWNuIsyksrXiOIVbI4SnuhQ=;
        b=jcfP50OuLjmZ4K7KDwghas6A5tgaxAEC9qDw95YOLwl9yJ0cwKDq6lKC38NYmFaeX9
         9ftgTatSasiMq0ZKJl/CvKiGXzdXueFMvm6X0uW4juDjzoDCbW4otK17Y6Sl5buB2xMz
         noPm0VaFE/zvJ3LOWoBW3s7tX9XgDa0WHW3mlesA47ui8ccKG7jsGm0TnjtO+zXRme+c
         XmQW55ECTfenhLZ+1avccb5PTnk2cSiP4L3BSqudV6hRW5bi/cQbaqSYYabjBg7motfv
         hfpuPUGQ1VIpGin63ZExbGr+PMfWbFJvFXsH0W/bcFb0HwZOHcx8UFEHANc1lFFl5T3p
         sMuA==
X-Gm-Message-State: AOAM530P6JvIWGBJdOLykJtmbJZ8pFBCZTR9UXTIiGAAWnRUY6uXPA01
        UDUDwbyej1/xRayXdzFTmM01iLxGnHBANazyAJk=
X-Google-Smtp-Source: ABdhPJzCS/hj1pS9gJUQ+V5IqVhP/2VC7dUNmb5w0LCazM/un1hjROKfAKKNio3MPeqKiKR89FuGnPBZ0QrWZt4JzjQ=
X-Received: by 2002:a05:651c:82:: with SMTP id 2mr2380426ljq.2.1598043925659;
 Fri, 21 Aug 2020 14:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200821002804.546826-1-udippant@fb.com> <9e829756-e943-e9a8-82f2-1a27a55afeec@fb.com>
 <d9df934c-4b64-1e28-cc7e-fb03939d687d@fb.com> <F6EEEFF4-F749-4D51-9366-1B1845EF0526@fb.com>
 <732c9be0-cccd-c180-1c18-e7cfce24ac88@fb.com>
In-Reply-To: <732c9be0-cccd-c180-1c18-e7cfce24ac88@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Aug 2020 14:05:13 -0700
Message-ID: <CAADnVQJfAR5Z2zXsyRNbFikJ+Zx+sGi7ogTj4UhcC8gS=eKNjQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access
 based on target prog
To:     Yonghong Song <yhs@fb.com>
Cc:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 1:53 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/21/20 12:07 PM, Udip Pant wrote:
> >
> >
> > =EF=BB=BF> On 8/20/20, 11:17 PM, "Yonghong Song" <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 8/20/20 11:13 PM, Yonghong Song wrote:
> >>>
> >>>
> >>> On 8/20/20 5:28 PM, Udip Pant wrote:
> >>>> While using dynamic program extension (of type BPF_PROG_TYPE_EXT), w=
e
> >>>> need to check the program type of the target program to grant the re=
ad /
> >>>> write access to the packet data.
> >>>>
> >>>> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, =
SKB
> >>>> and others. Since the BPF_PROG_TYPE_EXT program type on itself is ju=
st a
> >>>> placeholder for those, we need this extended check for those target
> >>>> programs to actually work while using this option.
> >>>>
> >>>> Tested this with a freplace xdp program. Without this patch, the
> >>>> verifier fails with error 'cannot write into packet'.
> >>>>
> >>>> Signed-off-by: Udip Pant <udippant@fb.com>
> >>>> ---
> >>>>    kernel/bpf/verifier.c | 6 +++++-
> >>>>    1 file changed, 5 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>> index ef938f17b944..4d7604430994 100644
> >>>> --- a/kernel/bpf/verifier.c
> >>>> +++ b/kernel/bpf/verifier.c
> >>>> @@ -2629,7 +2629,11 @@ static bool may_access_direct_pkt_data(struct
> >>>> bpf_verifier_env *env,
> >>>>                           const struct bpf_call_arg_meta *meta,
> >>>>                           enum bpf_access_type t)
> >>>>    {
> >>>> -    switch (env->prog->type) {
> >>>> +    struct bpf_prog *prog =3D env->prog;
> >>>> +    enum bpf_prog_type prog_type =3D prog->aux->linked_prog ?
> >>>> +          prog->aux->linked_prog->type : prog->type;
> >>>
> >>> I checked the verifier code. There are several places where
> >>> prog->type is checked and EXT program type will behave differently
> >>> from the linked program.
> >>>
> >>> Maybe abstract the the above logic to one static function like
> >>>
> >>> static enum bpf_prog_type resolved_prog_type(struct bpf_prog *prog)
> >>> {
> >>>       return prog->aux->linked_prog ? prog->aux->linked_prog->type
> >>>                         : prog->type;
> >>> }
> >>>
> >
> > Sure.
> >
> >>> This function can then be used in different places to give the resolv=
ed
> >>> prog type.
> >>>
> >>> Besides here checking pkt access permission,
> >>> another possible places to consider is return value
> >>> in function check_return_code(). Currently,
> >>> for EXT program, the result value can be anything. This may need to
> >>> be enforced. Could you take a look? It could be others as well.
> >>> You can take a look at verifier.c by searching "prog->type".
> >>
> >
> > Yeah there are few other places in the verifier where it decides withou=
t resolving for the 'extended' type. But I am not too sure if it makes sens=
e to extend this logic as part of this commit. For example, as you mentione=
d, in the check_return_code() it explicitly ignores the return type for the=
 EXT prog (kernel/bpf/verifier.c#L7446).  Likewise, I noticed similar issue=
 inside the check_ld_abs(), where it checks for may_access_skb(env->prog->t=
ype).
> >
> > I'm happy to extend this logic there as well if deemed appropriate.
>
> Thanks. I would like to see the verifier parity between original program
> and replace program. That is, if the original program and the replace
> program are the same, they should be both either accepted or rejected
> by verifier. Yes, this may imply more changes e.g., check_return_code()
> or check_ld_abs() than your original patch.
> Alexei or Daniel, what is your opinion on this?

The set was already marked as 'changes requested' in patchworks.
That's an indication that maintainers agree with the feedback :)
In this particular case it certainly makes sense to address all cases
instead of doing them one at a time.
