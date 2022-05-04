Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC15F51A474
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352752AbiEDPxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbiEDPxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:53:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223A740E55;
        Wed,  4 May 2022 08:50:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 882461F38D;
        Wed,  4 May 2022 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651679400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pzZYtAWqOK0x1bSyjKyxPqiIg9Fcdav21K/7m+CpVfI=;
        b=nbktz7u6eEaio1WfVT0QxWoaaEy+CZrGEGVR4d92gPZQIffDVi7oRxfPHukHGEfd1LTqsa
        gKHZBdiINI8+YI8Wb0+dYMc3NG/ugKVPfWZLqdTEHqVWtojPnc+zujn4TIFwcEtdn+K7e8
        ZObvRRMNDYaTLvnodYDN66RRhon/cNY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651679400;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pzZYtAWqOK0x1bSyjKyxPqiIg9Fcdav21K/7m+CpVfI=;
        b=txd/qOvmCUnW5d1S8GXNeHvBc6OD0LaoLQiFXYUco0/UgoF5iwrWeH7kyxXV+u9btcig+i
        X5vmWtZZuPxuDgDw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3673E2C141;
        Wed,  4 May 2022 15:49:59 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id D2BFAA061E; Wed,  4 May 2022 17:49:58 +0200 (CEST)
Date:   Wed, 4 May 2022 17:49:58 +0200
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Guowei Du <duguoweisz@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>, anton@enomsg.org,
        ccross@android.com, tony.luck@intel.com, selinux@vger.kernel.org,
        duguowei <duguowei@xiaomi.com>
Subject: Re: [PATCH] fsnotify: add generic perm check for unlink/rmdir
Message-ID: <20220504154958.cnagolihr65vkmjf@quack3.lan>
References: <20220503183750.1977-1-duguoweisz@gmail.com>
 <20220503194943.6bcmsxjvinfjrqxa@quack3.lan>
 <CAOQ4uxguXW05_YSpgT=kGgxztQYqhJ3x4MFsz9ZTO0crc9=4tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxguXW05_YSpgT=kGgxztQYqhJ3x4MFsz9ZTO0crc9=4tA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 04-05-22 17:12:16, Amir Goldstein wrote:
> On Tue, May 3, 2022 at 10:49 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 04-05-22 02:37:50, Guowei Du wrote:
> > > From: duguowei <duguowei@xiaomi.com>
> > >
> > > For now, there have been open/access/open_exec perms for file operation,
> > > so we add new perms check with unlink/rmdir syscall. if one app deletes
> > > any file/dir within pubic area, fsnotify can sends fsnotify_event to
> > > listener to deny that, even if the app have right dac/mac permissions.
> > >
> > > Signed-off-by: duguowei <duguowei@xiaomi.com>
> >
> > Before we go into technical details of implementation can you tell me more
> > details about the usecase? Why do you need to check specifically for unlink
> > / delete?
> >
> > Also on the design side of things: Do you realize these permission events
> > will not be usable together with other permission events like
> > FAN_OPEN_PERM? Because these require notification group returning file
> > descriptors while your events will return file handles... I guess we should
> > somehow fix that.
> >
> 
> IMO, regardless of file descriptions vs. file handles, blocking events have
> no business with async events in the same group at all.
> What is the use case for that?
> Sure, we have the legacy permission event, but if we do add new blocking
> events to UAPI, IMO they should be added to a group that was initialized with a
> different class to indicate "blocking events only".
> 
> And if we do that, we will not need to pollute the event mask namespace
> for every permission event.

That's an interesting idea. I agree mixing of permission and normal events
is not very useful and separating event mask for permission and other
events looks like a compelling reason to really forbid that :). It's a pity
nobody had this idea when proposing fanotify permission events.

> When users request to get FAN_UNLINK/FAN_RMDIR events in a
> FAN_CLASS_PERMISSION group, internally, that only captures
> events reported from fsnotify_perm()/fsnotify_path_perm().
> 
> FYI, I do intend to try and upload "pre-modify events" [1].
> I had no intention to expose those in fanotify and my implementation
> does not have the granularity of UNLINK/RMDIR, but we do need
> to think about not duplicating too much code with those overlapping
> features.

Definitely.

								Honza

> [1] https://github.com/amir73il/linux/commits/fsnotify_pre_modify
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
