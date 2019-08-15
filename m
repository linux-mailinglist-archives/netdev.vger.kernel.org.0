Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C258EA28
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfHOLZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:25:05 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:11257 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfHOLZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 07:25:05 -0400
Date:   Thu, 15 Aug 2019 11:24:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1565868301;
        bh=iAtcP7FshA2GtR0+YOCUr2f4BggVvEAXCTScdeBsrvc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=EX6yYuIfxAu8/7RblrN9Ataw3CyhPC60P1i7RpPAEYWwjtvTkeyKzrxBDSxkEMVOG
         g4O0QTbSKL4QqMjkJ4VwK83123YG5yl6bLkCnl11spEFo/UPte1Ra0fB2js6OCTVSV
         FUWHQkrJiPxFCzWcSRaGfPcn9vJfbOV2+kiQ/Q2I=
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
In-Reply-To: <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, August 14, 2019 10:05 PM, Alexei Starovoitov <alexei.starovoi=
tov@gmail.com> wrote:

> On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
>
> > If eBPF is genuinely not usable by programs that are not fully trusted
> > by the admin, then no kernel changes at all are needed. Programs that
> > want to reduce their own privileges can easily fork() a privileged
> > subprocess or run a little helper to which they delegate BPF
> > operations. This is far more flexible than anything that will ever be
> > in the kernel because it allows the helper to verify that the rest of
> > the program is doing exactly what it's supposed to and restrict eBPF
> > operations to exactly the subset that is needed. So a container
> > manager or network manager that drops some provilege could have a
> > little bpf-helper that manages its BPF XDP, firewalling, etc
> > configuration. The two processes would talk over a socketpair.
>
> there were three projects that tried to delegate bpf operations.
> All of them failed.
> bpf operational workflow is much more complex than you're imagining.
> fork() also doesn't work for all cases.
> I gave this example before: consider multiple systemd-like deamons
> that need to do bpf operations that want to pass this 'bpf capability'
> to other deamons written by other teams. Some of them will start
> non-root, but still need to do bpf. They will be rpm installed
> and live upgraded while running.
> We considered to make systemd such centralized bpf delegation
> authority too. It didn't work. bpf in kernel grows quickly.
> libbpf part grows independently. llvm keeps evolving.
> All of them are being changed while system overall has to stay
> operational. Centralized approach breaks apart.
>
> > The interesting cases you're talking about really do involved
> > unprivileged or less privileged eBPF, though. Let's see:
> > systemd --user: systemd --user is not privileged at all. There's no
> > issue of reducing privilege, since systemd --user doesn't have any
> > privilege to begin with. But systemd supports some eBPF features, and
> > presumably it would like to support them in the systemd --user case.
> > This is unprivileged eBPF.
>
> Let's disambiguate the terminology.
> This /dev/bpf patch set started as describing the feature as 'unprivilege=
d bpf'.
> I think that was a mistake.
> Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
> This is not unprivileged.
> 'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled contro=
ls.
>
> There is a huge difference between the two.
> I'm against extending 'unprivileged bpf' even a bit more than what it is
> today for many reasons mentioned earlier.
> The /dev/bpf is about 'less privileged'.
> Less privileged than root. We need to split part of full root capability
> into bpf capability. So that most of the root can be dropped.
> This is very similar to what cap_net_admin does.
> cap_net_amdin can bring down eth0 which is just as bad as crashing the bo=
x.
> cap_net_admin is very much privileged. Just 'less privileged' than root.
> Same thing for cap_bpf.
>
> May be we should do both cap_bpf and /dev/bpf to make it clear that
> this is the same thing. Two interfaces to achieve the same result.
>

systemd --user processes aren't "less privileged". The are COMPLETELY unpri=
vileged.
Granting them cap_bpf is the same as granting it to every other unprivilege=
d user
process. Also unprivileged user process can start systemd --user process wi=
th any
command they like.

Jordan
