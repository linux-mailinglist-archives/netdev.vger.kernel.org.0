Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB254C62F
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 12:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241047AbiFOKbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 06:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348390AbiFOKbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 06:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CF3522C1;
        Wed, 15 Jun 2022 03:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C2386124F;
        Wed, 15 Jun 2022 10:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573BAC34115;
        Wed, 15 Jun 2022 10:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655289040;
        bh=YafxQjI7ufgKbi/etVjbtyfiMqolpy9uY6amJmgj0/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJ8R0L3Z4Jmi1KlcuklT1wWOVBxnXRyLMSAm0VAIF4BW7eGhh8KQQBVeovw7amJcV
         VTY91dFe4RUXbAByaUghGetxipTYk7lXMAaZNn9r5zpUEiaffGRHXtHTcDT0ewykbm
         lp7wcl8Nh9YzrKgMga8EuiiA9tNraPvKFrsi2wd/4Zj2n9vUv3m1a02J2pEfWq5oR6
         OmspHS3307xy9oukdHKKAWkTuxsr5Jh4ZzKMrjUwwfJblDjFQU9dlYJDPWL/5hb1NJ
         fbm3aZNkiQe4NGdOl/RRiPPNcwSDPXPC8hGOS7T5zPjIa7Ot4UK1c9K5SjhClCe0m4
         Fm2YpZs6kb3aQ==
Date:   Wed, 15 Jun 2022 12:30:31 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Message-ID: <20220615103031.qkzae4xr34wysj4b@wittgenstein>
References: <20220608150942.776446-1-fred@cloudflare.com>
 <87tu8oze94.fsf@email.froward.int.ebiederm.org>
 <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com>
 <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
 <859cb593-9e96-5846-2191-6613677b07c5@cloudflare.com>
 <87o7yvxl4x.fsf@email.froward.int.ebiederm.org>
 <9ed91f15-420c-3db6-8b3b-85438b02bf97@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9ed91f15-420c-3db6-8b3b-85438b02bf97@cloudflare.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 01:59:08PM -0500, Frederick Lawler wrote:
> On 6/14/22 11:30 AM, Eric W. Biederman wrote:
> > Frederick Lawler <fred@cloudflare.com> writes:
> > 
> > > On 6/13/22 11:44 PM, Eric W. Biederman wrote:
> > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > > 
> > > > > Hi Eric,
> > > > > 
> > > > > On 6/13/22 12:04 PM, Eric W. Biederman wrote:
> > > > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > > > > 
> > > > > > > While experimenting with the security_prepare_creds() LSM hook, we
> > > > > > > noticed that our EPERM error code was not propagated up the callstack.
> > > > > > > Instead ENOMEM is always returned.  As a result, some tools may send a
> > > > > > > confusing error message to the user:
> > > > > > > 
> > > > > > > $ unshare -rU
> > > > > > > unshare: unshare failed: Cannot allocate memory
> > > > > > > 
> > > > > > > A user would think that the system didn't have enough memory, when
> > > > > > > instead the action was denied.
> > > > > > > 
> > > > > > > This problem occurs because prepare_creds() and prepare_kernel_cred()
> > > > > > > return NULL when security_prepare_creds() returns an error code. Later,
> > > > > > > functions calling prepare_creds() and prepare_kernel_cred() return
> > > > > > > ENOMEM because they assume that a NULL meant there was no memory
> > > > > > > allocated.
> > > > > > > 
> > > > > > > Fix this by propagating an error code from security_prepare_creds() up
> > > > > > > the callstack.
> > > > > > Why would it make sense for security_prepare_creds to return an error
> > > > > > code other than ENOMEM?
> > > > > >    > That seems a bit of a violation of what that function is supposed to do
> > > > > > 
> > > > > 
> > > > > The API allows LSM authors to decide what error code is returned from the
> > > > > cred_prepare hook. security_task_alloc() is a similar hook, and has its return
> > > > > code propagated.
> > > > It is not an api.  It is an implementation detail of the linux kernel.
> > > > It is a set of convenient functions that do a job.
> > > > The general rule is we don't support cases without an in-tree user.  I
> > > > don't see an in-tree user.
> > > > 
> > > > > I'm proposing we follow security_task_allocs() pattern, and add visibility for
> > > > > failure cases in prepare_creds().
> > > > I am asking why we would want to.  Especially as it is not an API, and I
> > > > don't see any good reason for anything but an -ENOMEM failure to be
> > > > supported.
> > > > 
> > > We're writing a LSM BPF policy, and not a new LSM. Our policy aims to solve
> > > unprivileged unshare, similar to Debian's patch [1]. We're in a position such
> > > that we can't use that patch because we can't block _all_ of our applications
> > > from performing an unshare. We prefer a granular approach. LSM BPF seems like a
> > > good choice.
> > 
> > I am quite puzzled why doesn't /proc/sys/user/max_user_namespaces work
> > for you?
> > 
> 
> We have the following requirements:
> 
> 1. Allow list criteria
> 2. root user must be able to create namespaces whenever
> 3. Everything else not in 1 & 2 must be denied
> 
> We use per task attributes to determine whether or not we allow/deny the
> current call to unshare().
> 
> /proc/sys/user/max_user_namespaces limits are a bit broad for this level of
> detail.
> 
> > > Because LSM BPF exposes these hooks, we should probably treat them as an
> > > API. From that perspective, userspace expects unshare to return a EPERM
> > > when the call is denied permissions.
> > 
> > The BPF code gets to be treated as a out of tree kernel module.
> > 
> > > > Without an in-tree user that cares it is probably better to go the
> > > > opposite direction and remove the possibility of return anything but
> > > > memory allocation failure.  That will make it clearer to implementors
> > > > that a general error code is not supported and this is not a location
> > > > to implement policy, this is only a hook to allocate state for the LSM.
> > > > 
> > > 
> > > That's a good point, and it's possible we're using the wrong hook for the
> > > policy. Do you know of other hooks we can look into?

Fwiw, from this commit it wasn't very clear what you wanted to achieve
with this. It might be worth considering adding a new security hook for
this. Within msft it recently came up SELinux might have an interest in
something like this as well.
