Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45299997E4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfHVPSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388320AbfHVPSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:18:09 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA8023406
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566487087;
        bh=YnHYMAFHnhwjWSCmHA1lalHVaWrapDVItQXtXHIh/i4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kKdhidJni9oVHZulnocOvR68S2C9Dn7RJI6j7z0k35Stv5Tl/0SJf3y8lnYLufydW
         0E15j7zWxkJZXS6m+VGgYaO7wg6+Bj1NABjbev8SizjldorzTqnJvylvbtTEo5urCJ
         Dyyr/OtGp0n0QrmmPycgLZzYpDfp/wVZ1suX4In0=
Received: by mail-wr1-f53.google.com with SMTP id b16so5785928wrq.9
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 08:18:07 -0700 (PDT)
X-Gm-Message-State: APjAAAW0r3C6YTgn0ibVKrSgq10SEOyRfWo09Nh0IgnxIPDys4lO8M0C
        /ph6N4dkCGOtlQ440nHKc2yMpv/m9lxGeS/3kIUVyg==
X-Google-Smtp-Source: APXvYqxpiOdLxbwIYHP+AESms9onR8AgvvW9tqQ+YzHqlJl2LsZx76/vthdf207FJITtNteDtAwcawyRgTmchAkN8LU=
X-Received: by 2002:a05:6000:4f:: with SMTP id k15mr10594496wrx.221.1566487085936;
 Thu, 22 Aug 2019 08:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net> <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
In-Reply-To: <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 22 Aug 2019 08:17:54 -0700
X-Gmail-Original-Message-ID: <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
Message-ID: <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
Subject: RFC: very rough draft of a bpf permission model
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF security strawman, v0.1

This is very rough.  Most of this, especially the API details, needs
work before it's ready to implement.  The whole concept also needs
review.

= Goals =

The overall goal is to make it possible to use eBPF without having
what is effectively administrator access.  For example, an eBPF user
should not be able to directly tamper with other processes (unless
this permission is explicitly granted) and should not be able to
read or write other users' eBPF maps.

It should be possible to use eBPF inside a user namespace without breaking
the userns security model.

Due to the risk of speculation attacks and such being carried out via
eBPF, it should not become possible to use too much of eBPF without the
administrator's permission.  (NB: it is already possible to use
*classic* BPF without any permission, and classic BPF is translated
internally to eBPF, so this goal can only be met to a limited extent.)

= Definitions =

Global capability: A capability bit in the caller's effective mask, so
long as the caller is in the root user namespace.  Tasks in non-root
user namespaces never have global capabilibies.  This is what capable()
checks.

Namespace capability: A capability over a specific user namespace.
Tasks in a user namespace have all the capabilities in their effective
mask over their user namespace.  A namespace capability generally
indicates that the capability applies to the user namespace itself and
to all non-user namespaces that live in the user namespace.  For
example, CAP_NET_ADMIN means that you can configure all networks
namespaces in the current user namespace.  This is what ns_capable()
checks.

Anything that requires a global capability will not work in a non-root
user namespace.

= unprivileged_bpf_disabled =

Nothing in here supercedes unprivileged_bpf_disabled.  If
unprivileged_bpf_disabled = 1, then these proposals should not allow anything
that is disallowed today.  The idea is to make unprivileged_bpf_disabled=0
both safer and more useful.

= Test runs =

Global CAP_SYS_ADMIN is needed to test-run a program.  Test-running a program
exposes its own attack surface.  It's also the only way to run a program at
all if you merely have permission to load the program but not to attach it
anywhere.  Some of the proposed changes below will make it possible to load
most program types without

= Access to programs and maps =

There are two basic security concerns when accessing programs and maps:
the attack surface against the kernel and the ability to access other
people's maps.

Unprivileged processes may read a map if they have an FMODE_READ descriptor
for the map.  Unprivileged processes may write a map if they have an
FMODE_WRITE descriptor to the map.  Unprivileged processes may open a
persistent map with a mode consistent with the permissions in bpffs.

Unprivileged processes may create a bpffs inode for an existing map
if the have an RW file descriptor for the map.  (This is a change to
current behavior.  Daniel, Alexei thought the current behavior was
intentional.  Do you recall whether this is the case?)

The _BY_ID map APIs inherently have no concept of ownership of maps.  These
APIs will continue to require global CAP_SYS_ADMIN.

The small number of things that currently require the _BY_ID APIs, e.g.,
reading maps of maps, can be addressed if needed with new APIs that
return fds instead of ids.  Otherwise using them will continue to require
global capabilities.

Unprivileged processes may create exactly the set of maps that they can
create today.  Future proposals may extend this by a variety of means;
this current proposal makes no changes.

= Program loading =

Loading a program carries the following risks:

 - It exposes the attack surface in the program verifier itself.  That is
   possible, although unlikely, that merely verifying a malicious program
   could crash or otherwise cause a kernel malfunction.

 - It exposes the attack surface of insufficient checks in the verifier.
   That is, a verifier bug could allow a malicious program that is dangerous
   when run.

 - It exposes all of the functions that the program type can call.
   Some functions, e.g. bpf_probe_read(), should require privilege to call.

 - It exposes resource attacks.  Currently, privileged users can load programs
   that use more resources than unprivileged users can load.

 - It exposes pointer-to-integer conversions.  This requires global
   capabilities.

 - The program could contain speculation attack gadgets.

 - Loading a program is a prerequisite to attaching the program.

I propose the following:

Flag functions that require privilege as such.  Loading a program that calls
such a function will require a global capability.  The privileged functions are
mainly used for tracing, I think, and kernel tracing should require global
capabilities.

Loading a program that uses privileged verifier features (function calls or
pointer-to-integer-conversions) will continue to require privileges.

Loading a function that uses excessive resources can continue to require
global capabilities or it could use a new set of cgroup settings that
adjust the bpf complexity limits.

Loading a function that bypasses the various speculation attack hardening
features (e.g. constant blinding) requires global capabilities.

Other than this, bpf program types can have a new flag set to allow
them to be loaded without any privileges.  Some bpf program types
may need additional care, e.g. perf bpf events.  They can be attached
without privilege even in current kernels, and this might need to change.

(optional) Add an API to load a program where the program source comes from a
file specified by id instead of in memory.  This would allow LSMs to require
that bpf() programs be appropriately labeled.  If LSMs require use of this
API, it will make it much harder to exploit the verifier or speculation bugs.

As a possible future extension, a way to selectively grant the ability to
use specific program types without privilege could be useful.  This
could be done with a cgroup option, for example.

= Cgroup attach =

Cgroups have their own hierarchy that does not necessarily follow the
namespace hierarchy.  Unless cgroups integrate with namespaces in ways
that they currently don't, namespace capabilites cannot be used to grant
permission to operate on cgroups.

I propose that attaching and detaching bpf programs to cgroups use a
permission model similar to the model for changing non-bpf cgroup
settings.  In particular, each bpf_attach_type will get a new file in a
cgroup directory.  So there will be
/sys/fs/cgroup/cgroup_name/bpf.inet_ingress, bpf.inet_egress, etc.

A new API will be added to bpf() to attach and detach programs.  The new
API will take an fd to the bpf.attach_type file instead of to the cgroup
directory.  It will require FMODE_WRITE.  This API will *not* require
any capability.

To prevent anyone with a delegated cgroup from automatically being
able to use all bpf program types, the new bpf.attach_type files
will be opt-in as part of the hierarchy.  This could be done by writing
"+bpf.*" or "+bpf.inet_ingress" to cgroup.subtree_control to make
all the bpf.attach_type files or just bpf.inet_ingress available
in descendents of the cgroup in question.  This could alternatively
be a new bpf.subtree_control file if that seems better.

The result of these changes will be that root can use the old
attach API or the new attach API.  Unprivileged programs cannot
use the old attach API.  Unprivileged programs can use the new
attach API if they are explicitly granted permission by all their
ancestor cgroup managers.


= Additional mitigations =

Optional: there may be cases where a user can load a bpf program
but can't attach or otherwise execute it.  Nonetheless, it's plausible
that such a program could be speculatively executed.  The kernel could
mitigate this by only marking a JITted bpf program executable when it
is first attached or test-run.
