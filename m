Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C64859236B
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240891AbiHNQVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 12:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbiHNQUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 12:20:45 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455D7F35;
        Sun, 14 Aug 2022 09:09:29 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id A8678F8A; Sun, 14 Aug 2022 10:55:08 -0500 (CDT)
Date:   Sun, 14 Aug 2022 10:55:08 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
Message-ID: <20220814155508.GA7991@mail.hallyn.com>
References: <20220801180146.1157914-1-fred@cloudflare.com>
 <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 03:16:16PM -0400, Paul Moore wrote:
> On Mon, Aug 8, 2022 at 2:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Paul Moore <paul@paul-moore.com> writes:
> > > On Mon, Aug 1, 2022 at 10:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > >> Frederick Lawler <fred@cloudflare.com> writes:
> > >>
> > >> > While creating a LSM BPF MAC policy to block user namespace creation, we
> > >> > used the LSM cred_prepare hook because that is the closest hook to prevent
> > >> > a call to create_user_ns().
> > >>
> > >> Re-nack for all of the same reasons.
> > >> AKA This can only break the users of the user namespace.
> > >>
> > >> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > >>
> > >> You aren't fixing what your problem you are papering over it by denying
> > >> access to the user namespace.
> > >>
> > >> Nack Nack Nack.
> > >>
> > >> Stop.
> > >>
> > >> Go back to the drawing board.
> > >>
> > >> Do not pass go.
> > >>
> > >> Do not collect $200.
> > >
> > > If you want us to take your comments seriously Eric, you need to
> > > provide the list with some constructive feedback that would allow
> > > Frederick to move forward with a solution to the use case that has
> > > been proposed.  You response above may be many things, but it is
> > > certainly not that.
> >
> > I did provide constructive feedback.  My feedback to his problem
> > was to address the real problem of bugs in the kernel.
> 
> We've heard from several people who have use cases which require
> adding LSM-level access controls and observability to user namespace
> creation.  This is the problem we are trying to solve here; if you do
> not like the approach proposed in this patchset please suggest another
> implementation that allows LSMs visibility into user namespace
> creation.

Regarding the observability - can someone concisely lay out why just
auditing userns creation would not suffice?  Userspace could decide
what to report based on whether the creating user_ns == /proc/1/ns/user...

Regarding limiting the tweaking of otherwise-privileged code by
unprivileged users, i wonder whether we could instead add smarts to
ns_capable().  Point being, uid mapping would still work, but we'd
break the "privileged against resources you own" part of user
namespaces.  I would want it to default to allow, but then when a
0-day is found which requires reaching ns_capable() code, admins 
could easily prevent exploitation until reboot from a fixed kernel.
