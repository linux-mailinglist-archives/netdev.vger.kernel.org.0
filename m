Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C605A2B2E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344656AbiHZP1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344434AbiHZP0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:26:47 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7369C121E;
        Fri, 26 Aug 2022 08:23:21 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id C68EB77A; Fri, 26 Aug 2022 10:23:19 -0500 (CDT)
Date:   Fri, 26 Aug 2022 10:23:19 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        tixxdz@gmail.com
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
Message-ID: <20220826152319.GA12466@mail.hallyn.com>
References: <871qte8wy3.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
 <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com>
 <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yigp4tp.fsf@email.froward.int.ebiederm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 01:15:46PM -0500, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
> 
> > On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> >>  I am hoping we can come up with
> >> "something better" to address people's needs, make everyone happy, and
> >> bring forth world peace.  Which would stack just fine with what's here
> >> for defense in depth.
> >>
> >> You may well not be interested in further work, and that's fine.  I need
> >> to set aside a few days to think on this.
> >
> > I'm happy to continue the discussion as long as it's constructive; I
> > think we all are.  My gut feeling is that Frederick's approach falls
> > closest to the sweet spot of "workable without being overly offensive"
> > (*cough*), but if you've got an additional approach in mind, or an
> > alternative approach that solves the same use case problems, I think
> > we'd all love to hear about it.
> 
> I would love to actually hear the problems people are trying to solve so
> that we can have a sensible conversation about the trade offs.
> 
> As best I can tell without more information people want to use
> the creation of a user namespace as a signal that the code is
> attempting an exploit.

I don't think that's it at all.  I think the problem is that it seems
you can pretty reliably get a root shell at some point in the future
by creating a user namespace, leaving it open for a bit, and waiting
for a new announcement of the latest netfilter or whatever exploit
that requires root in a user namespace.  Then go back to your userns
shell and run the exploit.

So i was hoping we could do something more targeted.  Be it splitting
off the ability to run code under capable_ns code from uid mapping (to
an extent), or maybe some limited-livepatch type of thing where
certain parts of code become inaccessible to code in a non-init userns
after some sysctl has been toggled, or something cooloer that I've
failed to think of.

-serge
