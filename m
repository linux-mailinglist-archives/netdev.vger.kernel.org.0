Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F8C5750C5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiGNO1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240400AbiGNO1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:27:44 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5B95F126;
        Thu, 14 Jul 2022 07:27:42 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id E128966C; Thu, 14 Jul 2022 09:27:40 -0500 (CDT)
Date:   Thu, 14 Jul 2022 09:27:40 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
Message-ID: <20220714142740.GA10621@mail.hallyn.com>
References: <20220707223228.1940249-1-fred@cloudflare.com>
 <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
 <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
 <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 09:11:15AM -0700, Casey Schaufler wrote:
> On 7/8/2022 7:01 AM, Frederick Lawler wrote:
> > On 7/8/22 7:10 AM, Christian Göttsche wrote:
> >> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com>
> >> wrote:
> >>>
> >>> While creating a LSM BPF MAC policy to block user namespace
> >>> creation, we
> >>> used the LSM cred_prepare hook because that is the closest hook to
> >>> prevent
> >>> a call to create_user_ns().
> >>>
> >>> The calls look something like this:
> >>>
> >>>      cred = prepare_creds()
> >>>          security_prepare_creds()
> >>>              call_int_hook(cred_prepare, ...
> >>>      if (cred)
> >>>          create_user_ns(cred)
> >>>
> >>> We noticed that error codes were not propagated from this hook and
> >>> introduced a patch [1] to propagate those errors.
> >>>
> >>> The discussion notes that security_prepare_creds()
> >>> is not appropriate for MAC policies, and instead the hook is
> >>> meant for LSM authors to prepare credentials for mutation. [2]
> >>>
> >>> Ultimately, we concluded that a better course of action is to introduce
> >>> a new security hook for LSM authors. [3]
> >>>
> >>> This patch set first introduces a new security_create_user_ns()
> >>> function
> >>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
> >>
> >> Some thoughts:
> >>
> >> I.
> >>
> >> Why not make the hook more generic, e.g. support all other existing
> >> and potential future namespaces?
> >
> > The main issue with a generic hook is that different namespaces have
> > different calling contexts. We decided in a previous discussion to
> > opt-out of a generic hook for this reason. [1]
> >
> >> Also I think the naming scheme is <object>_<verb>.
> >
> > That's a good call out. I was originally hoping to keep the
> > security_*() match with the hook name matched with the caller function
> > to keep things all aligned. If no one objects to renaming the hook, I
> > can rename the hook for v3.
> >
> >>
> >>      LSM_HOOK(int, 0, namespace_create, const struct cred *cred,
> >> unsigned int flags)
> >>
> >> where flags is a bitmap of CLONE flags from include/uapi/linux/sched.h
> >> (like CLONE_NEWUSER).
> >>
> >> II.
> >>
> >> While adding policing for namespaces maybe also add a new hook for
> >> setns(2)
> >>
> >>      LSM_HOOK(int, 0, namespace_join, const struct cred *subj,  const
> >> struct cred *obj, unsigned int flags)
> >>
> >
> > IIUC, setns() will create a new namespace for the other namespaces
> > except for user namespace. If we add a security hook for the other
> > create_*_ns() functions, then we can catch setns() at that point.
> >
> >> III.
> >>
> >> Maybe even attach a security context to namespaces so they can be
> >> further governed?
> 
> That would likely add confusion to the existing security module namespace
> efforts. SELinux, Smack and AppArmor have all developed namespace models.
> That, or it could replace the various independent efforts with a single,

I feel like you're attaching more meaning to this than there needs to be.
I *think* he's just talking about a user_namespace->u_security void*.
So that for instance while deciding whether to allow some transition,
selinux could check whether the caller's user namespace was created by
a task in an selinux context authorized to create user namespaces.

The "user namespaces are DAC and orthogonal to MAC" is of course true
(where the LSM does not itself tie them together), except that we all
know that a process running as root in a user namespace gains access to
often-less-trustworthy code gated under CAP_SYS_ADMIN.

> unified security module namespace effort. There's more work to that than
> adding a context to a namespace. Treating namespaces as objects is almost,
> but not quite, solidifying containers as a kernel construct. We know we
> can't do that.

What we "can't do" (imo) is to create a "full container" construct which
ties together the various namespaces and other concepts in a restrictive
way.

> >> SELinux example:
> >>
> >>      type domainA_userns_t;
> >>      type_transition domainA_t domainA_t : namespace domainA_userns_t
> >> "user";
> >>      allow domainA_t domainA_userns_t:namespace create;
> >>
> >>      # domainB calling setns(2) with domainA as target
> >>      allow domainB_t domainA_userns_t:namespace join;
> 
> While I'm not an expert on SELinux policy, I'd bet a refreshing beverage
> that there's already a way to achieve this with existing constructs.
> Smack, which is subject+object MAC couldn't care less about the user
> namespace configuration. User namespaces are DAC constructs.
> 
> >>
> >
> > Links:
> > 1.
> > https://lore.kernel.org/all/CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com/
> >
> >>>
> >>> Links:
> >>> 1.
> >>> https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> >>>
> >>> 2.
> >>> https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> >>> 3.
> >>> https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
> >>>
> >>> Changes since v1:
> >>> - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
> >>> patch
> >>> - Add selinux: Implement create_user_ns hook patch
> >>> - Change function signature of security_create_user_ns() to only take
> >>>    struct cred
> >>> - Move security_create_user_ns() call after id mapping check in
> >>>    create_user_ns()
> >>> - Update documentation to reflect changes
> >>>
> >>> Frederick Lawler (4):
> >>>    security, lsm: Introduce security_create_user_ns()
> >>>    bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
> >>>    selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
> >>>    selinux: Implement create_user_ns hook
> >>>
> >>>   include/linux/lsm_hook_defs.h                 |  1 +
> >>>   include/linux/lsm_hooks.h                     |  4 +
> >>>   include/linux/security.h                      |  6 ++
> >>>   kernel/bpf/bpf_lsm.c                          |  1 +
> >>>   kernel/user_namespace.c                       |  5 ++
> >>>   security/security.c                           |  5 ++
> >>>   security/selinux/hooks.c                      |  9 ++
> >>>   security/selinux/include/classmap.h           |  2 +
> >>>   .../selftests/bpf/prog_tests/deny_namespace.c | 88
> >>> +++++++++++++++++++
> >>>   .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
> >>>   10 files changed, 160 insertions(+)
> >>>   create mode 100644
> >>> tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> >>>   create mode 100644
> >>> tools/testing/selftests/bpf/progs/test_deny_namespace.c
> >>>
> >>> -- 
> >>> 2.30.2
> >>>
> >
