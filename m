Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18790ADD
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfHPWXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:23:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38047 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbfHPWXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:23:00 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1hykcY-0002ah-Qy; Fri, 16 Aug 2019 22:22:54 +0000
Date:   Sat, 17 Aug 2019 00:22:53 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
References: <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
 <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 02:45:44PM -0700, Alexei Starovoitov wrote:
> On Thu, Aug 15, 2019 at 05:54:59PM -0700, Andy Lutomirski wrote:
> > 
> > 
> > > On Aug 15, 2019, at 4:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > 
> > >> 
> > >> I'm not sure why you draw the line for VMs -- they're just as buggy
> > >> as anything else. Regardless, I reject this line of thinking: yes,
> > >> all software is buggy, but that isn't a reason to give up.
> > > 
> > > hmm. are you saying you want kernel community to work towards
> > > making containers (namespaces) being able to run arbitrary code
> > > downloaded from the internet?
> > 
> > Yes.

If I may weigh in here too: Yes. In fact, we already do that large
scale!

> > 
> > As an example, Sandstorm uses a combination of namespaces (user, network, mount, ipc) and a moderately permissive seccomp policy to run arbitrary code. Not just little snippets, either — node.js, Mongo, MySQL, Meteor, and other fairly heavyweight stacks can all run under Sandstorm, with the whole stack (database engine binaries, etc) supplied by entirely untrusted customers.  During the time Sandstorm was under active development, I can recall *one* bug that would have allowed a sandbox escape. That’s a pretty good track record.  (Also, Meltdown and Spectre, sigh.)
> 
> exactly: "meltdown", "spectre", "sigh".
> Side channels effectively stalled the work on secure containers.
> And killed projects like sandstorm.

If I may, Sandstorm's death has very likely nothing to do with
Meltdown/Spectre etc. since that should've also killed Qemu, Crosvm and
all the others in one fell swoop. It's also not a very good example (no
offense, Andy :)) and probably a bit dated.
We have LXD which is a full-fledged container manager that runs
*unprivileged system* containers on a large scale and is very much
alive. That is it runs systemd, openrc, what have you, i.e. simply
unmodifed distro images at this point.

It's used to run Linux workloads on all Chromebooks and in a bunch of
other places. Since its inception we did not have a single
*unprivileged* container to init userns/host breakout.
At this point in time the really bad CVEs are almost exclusively against
*privileged* containers (see this year's leading nomination for
container CVE grand mal of the year: CVE-2019-5736) which were never and
will never be considered root safe despite everyone pretending
otherwise.


> Why work on improving kaslr when there are several ways to
> get kernel addresses through hw bugs? Patch mouse holes when roof is leaking ?
> In case of unprivileged bpf I'm confident that all known holes are patched.
> Until disclosures stop happening with the frequency they do now the time
> of bpf developers is better spent on something other than unprivileged bpf.
> 
> > I’m suggesting that you engage the security community ...
> > .. so that normal users can use bpf filtering
> 
> yes, but not soon. unfortunately.

Tbh, I do not have a strong opinion on unprivileged bpf at this moment.
If the community thinks that the bits and pieces are not in place or the
timing is not right that's fine with me.
What we should make sure though is that we don't end up with something
halfbaked. And this /dev/bpf thing very much feels like a hack. If
unprivileged bpf is not a thing why bother with /dev/bpf or CAP_BPF at
all.

(The one usecase I'd care about is to extend seccomp to do pointer-based
syscall filtering. Whether or not that'd require (unprivileged) ebpf is
up for discussion at KSummit.)

Christian
