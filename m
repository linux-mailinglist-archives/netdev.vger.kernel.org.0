Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7595455C689
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbiF0MLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiF0MLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E1ED12D;
        Mon, 27 Jun 2022 05:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACBFBB8117E;
        Mon, 27 Jun 2022 12:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8BBC3411D;
        Mon, 27 Jun 2022 12:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656331905;
        bh=lN/r9d/SD827cGR9LTMT8U4qhtJ7GeJIvd2S8K1gKh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O9Y/7rkpxtUWfwtqptPABSQ9MnmZeKcFhIuUgd2g4TKqOJymCv21FzM5W+volxX27
         HLwF+PZCGgJa9ksN1ket46bu+BI++Zkr8ztJdXYNyyIbZNIS6ESMy0BfQEEDdvF/G3
         1AMPQciYcwRgzO2/n1elJxkIKKJWRgV5vk7imUWzY7iaWzsYqEuhcGz9J3z3tJM0C4
         9CFJX8nObRhR2WqaDSAOkWF0U1ZYGg79MTfDjW3mZfhhYxQ8j27LuAjjTjbnqoka/v
         6bj5vMUQYWiiVN9eUWNkb3eAdk/ShR48YFdv3wSIV8vhjnfgqOPFQqCCvPBTguIRr3
         gRDgD7s3x/aHA==
Date:   Mon, 27 Jun 2022 14:11:37 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Message-ID: <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
> On Wed, Jun 22, 2022 at 10:24 AM Frederick Lawler <fred@cloudflare.com> wrote:
> > On 6/21/22 7:19 PM, Casey Schaufler wrote:
> > > On 6/21/2022 4:39 PM, Frederick Lawler wrote:
> > >> While creating a LSM BPF MAC policy to block user namespace creation, we
> > >> used the LSM cred_prepare hook because that is the closest hook to
> > >> prevent
> > >> a call to create_user_ns().
> > >>
> > >> The calls look something like this:
> > >>
> > >>      cred = prepare_creds()
> > >>          security_prepare_creds()
> > >>              call_int_hook(cred_prepare, ...
> > >>      if (cred)
> > >>          create_user_ns(cred)
> > >>
> > >> We noticed that error codes were not propagated from this hook and
> > >> introduced a patch [1] to propagate those errors.
> > >>
> > >> The discussion notes that security_prepare_creds()
> > >> is not appropriate for MAC policies, and instead the hook is
> > >> meant for LSM authors to prepare credentials for mutation. [2]
> > >>
> > >> Ultimately, we concluded that a better course of action is to introduce
> > >> a new security hook for LSM authors. [3]
> > >>
> > >> This patch set first introduces a new security_create_user_ns() function
> > >> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
> > >
> > > Why restrict this hook to user namespaces? It seems that an LSM that
> > > chooses to preform controls on user namespaces may want to do so for
> > > network namespaces as well.
> >
> > IIRC, CLONE_NEWUSER is the only namespace flag that does not require
> > CAP_SYS_ADMIN. There is a security use case to prevent this namespace
> > from being created within an unprivileged environment. I'm not opposed
> > to a more generic hook, but I don't currently have a use case to block
> > any others. We can also say the same is true for the other namespaces:
> > add this generic security function to these too.
> >
> > I'm curious what others think about this too.
> 
> While user namespaces are obviously one of the more significant
> namespaces from a security perspective, I do think it seems reasonable
> that the LSMs could benefit from additional namespace creation hooks.
> However, I don't think we need to do all of them at once, starting
> with a userns hook seems okay to me.
> 
> I also think that using the same LSM hook as an access control point
> for all of the different namespaces would be a mistake.  At the very

Agreed.

> least we would need to pass a flag or some form of context to the hook
> to indicate which new namespace(s) are being requested and I fear that
> is a problem waiting to happen.  That isn't to say someone couldn't
> mistakenly call the security_create_user_ns(...) from the mount
> namespace code, but I suspect that is much easier to identify as wrong
> than the equivalent security_create_ns(USER, ...).

Yeah, I think that's a pretty unlikely scenario.

> 
> We also should acknowledge that while in most cases the current task's
> credentials are probably sufficient to make any LSM access control
> decisions around namespace creation, it's possible that for some
> namespaces we would need to pass additional, namespace specific info
> to the LSM.  With a shared LSM hook this could become rather awkward.

Agreed.

> 
> > > Also, the hook seems backwards. You should
> > > decide if the creation of the namespace is allowed before you create it.
> > > Passing the new namespace to a function that checks to see creating a
> > > namespace is allowed doesn't make a lot off sense.
> >
> > I think having more context to a security hook is a good thing.
> 
> This is one of the reasons why I usually like to see at least one LSM
> implementation to go along with every new/modified hook.  The
> implementation forces you to think about what information is necessary
> to perform a basic access control decision; sometimes it isn't always
> obvious until you have to write the access control :)

I spoke to Frederick at length during LSS and as I've been given to
understand there's a eBPF program that would immediately use this new
hook. Now I don't want to get into the whole "Is the eBPF LSM hook
infrastructure an LSM" but I think we can let this count as a legitimate
first user of this hook/code.

> 
> [aside: If you would like to explore the SELinux implementation let me
> know, I'm happy to work with you on this.  I suspect Casey and the
> other LSM maintainers would also be willing to do the same for their
> LSMs.]
> 
> In this particular case I think the calling task's credentials are
> generally all that is needed.  You mention that the newly created

Agreed.

> namespace would be helpful, so I'll ask: what info in the new ns do
> you believe would be helpful in making an access decision about its
> creation?
> 
> Once we've sorted that we can make a better decision about the hook
> placement, but right now my gut feeling is that we only need to pass
> the task's creds, and I think placing the hook right after the UID/GID
> mapping check (before the new ns allocation) would be the best spot.

When I toyed with this I placed it directly into create_user_ns() and
only relied on the calling task's cred. I just created an eBPF program
that verifies the caller is capable(CAP_SYS_ADMIN). Since both the
chrooted and mapping check return EPERM it doesn't really matter that
much where exactly. Conceptually it makes more sense to me to place it
after the mapping check because then all the preliminaries are done.

Christian
