Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979BB58E89
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfF0X1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfF0X1u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 19:27:50 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682CD216E3
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 23:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561678069;
        bh=mwvETRIDqMs7L43FSkQDKbGmizxBXYSx/D3C9rFWcpg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TKcI4mKIbOmTQAT+gptb7xEcJi4etDhygArFA35kutGNdsj68LZpy/Y2k+t9XZ4RD
         k2hodjkdeER/jYb592nL5NxQtWUYolm4AK99A/+7CH0+U2eHtJ16X0Qt3gPl9ajXNk
         1FZBm1Fck2MmbTz+1IDkXYMN9WKOo3h1LIKY9O6s=
Received: by mail-wr1-f53.google.com with SMTP id x17so4294149wrl.9
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:27:49 -0700 (PDT)
X-Gm-Message-State: APjAAAV+gtfjXdlKuJetNLQ8nXphJyTtcY6asuyOvXNhp8boXg/ZgfyG
        QPvW83+B/CbbvaG+6g7jONBEsPSkamJrz06vw82J0A==
X-Google-Smtp-Source: APXvYqyAYKXxXWMLzoz8Fys8e53yvJg6wXXB6yJBpGm1WRY2+7qHEjSZsNcG9ZRaiLfHnA5ZGOFRrL6ahv9YYxNZdI4=
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr3198059wrm.265.1561678067927;
 Thu, 27 Jun 2019 16:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org> <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
 <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
In-Reply-To: <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 27 Jun 2019 16:27:36 -0700
X-Gmail-Original-Message-ID: <CALCETrXwt43w6rQY6zt0J_3HOaad=+E5PushJNdSOZDBuaYV+Q@mail.gmail.com>
Message-ID: <CALCETrXwt43w6rQY6zt0J_3HOaad=+E5PushJNdSOZDBuaYV+Q@mail.gmail.com>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     James Morris <jmorris@namei.org>,
        Andy Lutomirski <luto@kernel.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        linux-security@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 7:35 AM Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
> On 6/26/19 8:57 PM, Andy Lutomirski wrote:
> >
> >
> >> On Jun 26, 2019, at 1:22 PM, James Morris <jmorris@namei.org> wrote:
> >>
> >> [Adding the LSM mailing list: missed this patchset initially]
> >>
> >>> On Thu, 20 Jun 2019, Andy Lutomirski wrote:
> >>>
> >>> This patch exemplifies why I don't like this approach:
> >>>
> >>>> @@ -97,6 +97,7 @@ enum lockdown_reason {
> >>>>         LOCKDOWN_INTEGRITY_MAX,
> >>>>         LOCKDOWN_KCORE,
> >>>>         LOCKDOWN_KPROBES,
> >>>> +       LOCKDOWN_BPF,
> >>>>         LOCKDOWN_CONFIDENTIALITY_MAX,
> >>>
> >>>> --- a/security/lockdown/lockdown.c
> >>>> +++ b/security/lockdown/lockdown.c
> >>>> @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIA=
LITY_MAX+1] =3D {
> >>>>         [LOCKDOWN_INTEGRITY_MAX] =3D "integrity",
> >>>>         [LOCKDOWN_KCORE] =3D "/proc/kcore access",
> >>>>         [LOCKDOWN_KPROBES] =3D "use of kprobes",
> >>>> +       [LOCKDOWN_BPF] =3D "use of bpf",
> >>>>         [LOCKDOWN_CONFIDENTIALITY_MAX] =3D "confidentiality",
> >>>
> >>> The text here says "use of bpf", but what this patch is *really* doin=
g
> >>> is locking down use of BPF to read kernel memory.  If the details
> >>> change, then every LSM needs to get updated, and we risk breaking use=
r
> >>> policies that are based on LSMs that offer excessively fine
> >>> granularity.
> >>
> >> Can you give an example of how the details might change?
> >>
> >>> I'd be more comfortable if the LSM only got to see "confidentiality"
> >>> or "integrity".
> >>
> >> These are not sufficient for creating a useful policy for the SELinux
> >> case.
> >>
> >>
> >
> > I may have misunderstood, but I thought that SELinux mainly needed to a=
llow certain privileged programs to bypass the policy.  Is there a real exa=
mple of what SELinux wants to do that can=E2=80=99t be done in the simplifi=
ed model?
> >
> > The think that specifically makes me uneasy about exposing all of these=
 precise actions to LSMs is that they will get exposed to userspace in a wa=
y that forces us to treat them as stable ABIs.
>
> There are two scenarios where finer-grained distinctions make sense:
>
> - Users may need to enable specific functionality that falls under the
> umbrella of "confidentiality" or "integrity" lockdown.  Finer-grained
> lockdown reasons free them from having to make an all-or-nothing choice
> between lost functionality or no lockdown at all. This can be supported
> directly by the lockdown module without any help from SELinux or other
> security modules; we just need the ability to specify these
> finer-grained lockdown levels via the boot parameters and securityfs node=
s.
>
> - Different processes/programs may need to use different sets of
> functionality restricted via lockdown confidentiality or integrity
> categories.  If we have to allow all-or-none for the set of
> interfaces/functionality covered by the generic confidentiality or
> integrity categories, then we'll end up having to choose between lost
> functionality or overprivileged processes, neither of which is optimal.
>
> Is it truly the case that everything under the "confidentiality"
> category poses the same level of risk to kernel confidentiality, and
> similarly for everything under the "integrity" category?  If not, then
> being able to distinguish them definitely has benefit.
>

They're really quite similar in my mind.  Certainly some things in the
"integrity" category give absolutely trivial control over the kernel
(e.g. modules) while others make it quite challenging (ioperm), but
the end result is very similar.  And quite a few "confidentiality"
things genuinely do allow all kernel memory to be read.

I agree that finer-grained distinctions could be useful. My concern is
that it's a tradeoff, and the other end of the tradeoff is an ABI
stability issue.  If someone decides down the road that some feature
that is currently "integrity" can be split into a narrow "integrity"
feature and a "confidentiality" feature then, if the user policy knows
about the individual features, there's a risk of breaking people's
systems.  If we keep the fine-grained control, do we have a clear
compatibility story?
