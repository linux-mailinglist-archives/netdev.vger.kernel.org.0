Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AF3FC3C7
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhHaHj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 03:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239830AbhHaHjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 03:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E09B560ED4;
        Tue, 31 Aug 2021 07:38:20 +0000 (UTC)
Date:   Tue, 31 Aug 2021 09:38:18 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     David Howells <dhowells@redhat.com>,
        syzbot <syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dvyukov@google.com, jmorris@namei.org,
        kafai@fb.com, kpsingh@google.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        viro@zeniv.linux.org.uk, yhs@fb.com
Subject: Re: [syzbot] general protection fault in legacy_parse_param
Message-ID: <20210831073818.oojyjqyiogel7hll@wittgenstein>
References: <0000000000004e5ec705c6318557@google.com>
 <0000000000008d2a0005ca951d94@google.com>
 <20210830122348.jffs5dmq6z25qzw5@wittgenstein>
 <61bf6b11-80f8-839e-4ae7-54c2c6021ed5@schaufler-ca.com>
 <89d0e012-4caf-4cda-3c4e-803a2c6ebc2b@schaufler-ca.com>
 <20210830165733.emqlg3orflaqqfio@wittgenstein>
 <3354839e-5e7a-08c7-277a-9bbebfbfc0bc@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3354839e-5e7a-08c7-277a-9bbebfbfc0bc@schaufler-ca.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:41:29AM -0700, Casey Schaufler wrote:
> On 8/30/2021 9:57 AM, Christian Brauner wrote:
> > On Mon, Aug 30, 2021 at 09:40:57AM -0700, Casey Schaufler wrote:
> >> On 8/30/2021 7:25 AM, Casey Schaufler wrote:
> >>> On 8/30/2021 5:23 AM, Christian Brauner wrote:
> >>>> On Fri, Aug 27, 2021 at 07:11:18PM -0700, syzbot wrote:
> >>>>> syzbot has bisected this issue to:
> >>>>>
> >>>>> commit 54261af473be4c5481f6196064445d2945f2bdab
> >>>>> Author: KP Singh <kpsingh@google.com>
> >>>>> Date:   Thu Apr 30 15:52:40 2020 +0000
> >>>>>
> >>>>>     security: Fix the default value of fs_context_parse_param hook
> >>>>>
> >>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160c5d75300000
> >>>>> start commit:   77dd11439b86 Merge tag 'drm-fixes-2021-08-27' of git://ano..
> >>>>> git tree:       upstream
> >>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=150c5d75300000
> >>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=110c5d75300000
> >>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
> >>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=d1e3b1d92d25abf97943
> >>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126d084d300000
> >>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16216eb1300000
> >>>>>
> >>>>> Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
> >>>>> Fixes: 54261af473be ("security: Fix the default value of fs_context_parse_param hook")
> >>>>>
> >>>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >>>> So ok, this seems somewhat clear now. When smack and 
> >>>> CONFIG_BPF_LSM=y
> >>>> is selected the bpf LSM will register NOP handlers including
> >>>>
> >>>> bpf_lsm_fs_context_fs_param()
> >>>>
> >>>> for the
> >>>>
> >>>> fs_context_fs_param
> >>>>
> >>>> LSM hook. The bpf LSM runs last, i.e. after smack according to:
> >>>>
> >>>> CONFIG_LSM="landlock,lockdown,yama,safesetid,integrity,tomoyo,smack,bpf"
> >>>>
> >>>> in the appended config. The smack hook runs and sets
> >>>>
> >>>> param->string = NULL
> >>>>
> >>>> then the bpf NOP handler runs returning -ENOPARM indicating to the vfs
> >>>> parameter parser that this is not a security module option so it should
> >>>> proceed processing the parameter subsequently causing the crash because
> >>>> param->string is not allowed to be NULL (Which the vfs parameter parser
> >>>> verifies early in fsconfig().).
> >>> The security_fs_context_parse_param() function is incorrectly
> >>> implemented using the call_int_hook() macro. It should return
> >>> zero if any of the modules return zero. It does not follow the
> >>> usual failure model of LSM hooks. It could be argued that the
> >>> code was fine before the addition of the BPF hook, but it was
> >>> going to fail as soon as any two security modules provided
> >>> mount options.
> >>>
> >>> Regardless, I will have a patch later today. Thank you for
> >>> tracking this down.
> >> Here's my proposed patch. I'll tidy it up with a proper
> >> commit message if it looks alright to y'all. I've tested
> >> with Smack and with and without BPF.
> > Looks good to me.
> > On question, in contrast to smack, selinux returns 1 instead of 0 on
> > success. So selinux would cause an early return preventing other hooks
> > from running. Just making sure that this is intentional.
> >
> > Iirc, this would mean that selinux causes fsconfig() to return a
> > positive value to userspace which I think is a bug; likely in selinux.
> > So I think selinux should either return 0 or the security hook itself
> > needs to overwrite a positive value with a sensible errno that can be
> > seen by userspace.
> 
> I think that I agree. The SELinux and Smack versions of the
> hook are almost identical except for setting rc to 1 in the
> SELinux case. And returning 1 makes no sense if you follow
> the callers back. David Howells wrote both the SELinux and
> Smack versions. David - why are they different? which is correct?

The documentation for fs_context_parse_param notes:

 * @fs_context_parse_param:
 *	Userspace provided a parameter to configure a superblock.  The LSM may
 *	reject it with an error and may use it for itself, in which case it
 *	should return 0; otherwise it should return -ENOPARAM to pass it on to
 *	the filesystem.
 *	@fc indicates the filesystem context.
 *	@param The parameter

So we should simply make selinux return 0 on top of your patch when it
has consumed the option.
