Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EDE59A4CD
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354537AbiHSRAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354530AbiHSRAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:00:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBEF1322CB;
        Fri, 19 Aug 2022 09:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21AF7B8280D;
        Fri, 19 Aug 2022 16:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505CCC433C1;
        Fri, 19 Aug 2022 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660926030;
        bh=LgjTg9NeVNqDDOerGSwbxrMHZC+77VDZrItGQpOGABk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UZpjLlOkTIBylPI7XZmlcAaDE5Sq5BjD0RsRcNFK9vEVsNdc3H81NHPeKCX+X0+QU
         Q6mmx3FiYKt0FkkMDup/WfbY3f2s38ZWyUlhN/tl36HFBvL2Np6lEWrjbKEkBqdOqP
         d48VUX/6zmVI4qN6mVoAP8CJgkYphLICoyjoYGwgjTQY4Bqy7taOaoGLlykmt5FfPn
         R1chgx8fQyCwtErphhgljzm3V0BJD2d19IM5rvmW5dDdpGKQQgxXCTYwiI/TfQO4ZE
         Nss24sK3EX+bb9KBNGyt4sD1GOkaYrAE2TJyxVzG7KJFzBbXKa3/tzavM7XosXJaIp
         gm1UdldbDWmaA==
Date:   Fri, 19 Aug 2022 09:20:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        stephen@networkplumber.org, sdf@google.com, ecree.xilinx@gmail.com,
        benjamin.poirier@gmail.com, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org, jhs@mojatatu.com,
        tgraf@suug.ch, jacob.e.keller@intel.com, svinota.saveliev@gmail.com
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
Message-ID: <20220819092029.10316adb@kernel.org>
In-Reply-To: <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
References: <20220818023504.105565-1-kuba@kernel.org>
        <20220818023504.105565-2-kuba@kernel.org>
        <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 09:36:46 +0200 Johannes Berg wrote:
> On Wed, 2022-08-17 at 19:35 -0700, Jakub Kicinski wrote:
> > +To get information about the Generic Netlink family named for example
> > +``"test1"`` we need to send a message on the previously opened Generic=
 Netlink
> > +socket. The message should target the Generic Netlink Family (1), be a
> > +``do`` (2) call to ``CTRL_CMD_GETFAMILY`` (3). A ``dump`` version of t=
his
> > +call would make the kernel respond with information about *all* the fa=
milies
> > +it knows about. Last but not least the name of the family in question =
has
> > +to be specified (4) as an attribute with the appropriate type::
> > +
> > +  struct nlmsghdr:
> > +    __u32 nlmsg_len:	32
> > +    __u16 nlmsg_type:	GENL_ID_CTRL               // (1)
> > +    __u16 nlmsg_flags:	NLM_F_REQUEST | NLM_F_ACK  // (2)
> > +    __u32 nlmsg_seq:	1
> > +    __u32 nlmsg_pid:	0
> > +
> > +  struct genlmsghdr:
> > +    __u8 cmd:		CTRL_CMD_GETFAMILY         // (3)
> > +    __u8 version:	2 /* or 1, doesn't matter */
> > +    __u16 reserved:	0
> > +
> > +  struct nlattr:                                   // (4)
> > +    __u16 nla_len:	10
> > +    __u16 nla_type:	CTRL_ATTR_FAMILY_NAME
> > +    char data: 		test1\0
> > +
> > +  (padding:)
> > +    char data:		\0\0
> > +
> > +The length fields in Netlink (:c:member:`nlmsghdr.nlmsg_len`
> > +and :c:member:`nlattr.nla_len`) always *include* the header.
> > +Headers in netlink must be aligned to 4 bytes from the start of the me=
ssage, =20
>=20
> s/Headers/Attribute headers/ perhaps?

Theoretically I think we also align what I called "fixed metadata
headers", practically all of those are multiple of 4 :S

> > +hence the extra ``\0\0`` at the end of the message.
>=20
> And I think technically for the _last_ attribute it wouldn't be needed?

True, it's not strictly necessary AFAIU. Should I mention it=20
or would that be over-complicating things?

I believe that kernel will accept both forms (without tripping=20
the trailing data warning), and both the kernel and mnl will pad=20
out the last attr.

> > +If the family is found kernel will reply with two messages, the respon=
se
> > +with all the information about the family::
> > +
> > +  /* Message #1 - reply */
> > +  struct nlmsghdr:
> > +    __u32 nlmsg_len:	136
> > +    __u16 nlmsg_type:	GENL_ID_CTRL
> > +    __u16 nlmsg_flags:	0
> > +    __u32 nlmsg_seq:	1    /* echoed from our request */
> > +    __u32 nlmsg_pid:	5831 /* The PID of our user space process */ =20
>=20
> s/PID/netlink port ID/
>=20
> It's actually whatever you choose, I think? Lots of libraries will
> choose (something based on) the process ID, but that's not really
> needed?
>=20
> (autobind is different maybe?)

I'll respond below.

> > +  /* Message #2 - the ACK */
> > +  struct nlmsghdr:
> > +    __u32 nlmsg_len:	36
> > +    __u16 nlmsg_type:	NLMSG_ERROR
> > +    __u16 nlmsg_flags:	NLM_F_CAPPED /* There won't be a payload */
> > +    __u32 nlmsg_seq:	1    /* echoed from our request */
> > +    __u32 nlmsg_pid:	5831 /* The PID of our user space process */ =20
>=20
> (same here of course)
>=20
> > +``NLMSGERR_ATTR_MSG`` carries a message in English describing
> > +the encountered problem. These messages are far more detailed
> > +than what can be expressed thru standard UNIX error codes. =20
>=20
> "through"?

How much do you care? Maybe Jon has guidelines?

I heard somewhere that some of English spelling was complicated=20
by the type-setters they imported from Belgium with the first
printing presses. Those dudes supposedly just picked the spelling
they felt was right.. based on how they'd spell it back home.
Ever since I heard that I felt much less guilty using shorter,
more logical spellings.

> > +Querying family information is useful in rare cases when user space ne=
eds =20
>=20
> debatable if that's "rare", but yeah, today it's not done much :)

Some of the text is written with the implicit goal of comforting=20
the newcomer ;)

> > +.. _nlmsg_pid:
> > +
> > +nlmsg_pid
> > +---------
> > +
> > +:c:member:`nlmsghdr.nlmsg_pid` is called PID because the protocol pred=
ates
> > +wide spread use of multi-threading and the initial recommendation was
> > +to use process ID in this field. Process IDs start from 1 hence the use
> > +of ``0`` to mean "allocate automatically".
> > +
> > +The field is still used today in rare cases when kernel needs to send
> > +a unicast notification. User space application can use bind() to assoc=
iate
> > +its socket with a specific PID (similarly to binding to a UDP port),
> > +it then communicates its PID to the kernel.
> > +The kernel can now reach the user space process.
> > +
> > +This sort of communication is utilized in UMH (user mode helper)-like
> > +scenarios when kernel needs to trigger user space logic or ask user
> > +space for a policy decision.
> > +
> > +Kernel will automatically fill the field with process ID when respondi=
ng
> > +to a request sent with the :c:member:`nlmsghdr.nlmsg_pid` value of ``0=
``. =20
>=20
> I think this could be written a bit better - we call this thing a "port
> ID" internally now, and yes, it might default to a process ID (more
> specifically task group ID) ... but it feels like this could explain
> bind vs. autobind etc. a bit more? And IMHO it should focus less on the
> process ID/PID than saying "port ID" with a (historical) default of
> using the PID/TGID.

I'll rewrite. The only use I'm aware of is OvS upcalls, are there more?

Practically speaking for a person trying to make a ethtool, FOU,
devlink etc. call to the kernel this is 100% irrelevant.

> > +Strict checking
> > +---------------
> > +
> > +The ``NETLINK_GET_STRICT_CHK`` socket option enables strict input chec=
king
> > +in ``NETLINK_ROUTE``. It was needed because historically kernel did not
> > +validate the fields of structures it didn't process. This made it impo=
ssible
> > +to start using those fields later without risking regressions in appli=
cations
> > +which initialized them incorrectly or not at all.
> > +
> > +``NETLINK_GET_STRICT_CHK`` declares that the application is initializi=
ng
> > +all fields correctly. It also opts into validating that message does n=
ot
> > +contain trailing data and requests that kernel rejects attributes with
> > +type higher than largest attribute type known to the kernel.
> > +
> > +``NETLINK_GET_STRICT_CHK`` is not used outside of ``NETLINK_ROUTE``. =
=20
>=20
> However, there are also more generally strict checks in policy
> validation ... maybe a discussion of all that would be worthwhile?

Yeah :( It's too much to describe to a newcomer, I figured. I refer
those who care to the enum field in the next section. We'd need a full
table of families and attrs which start strict(er) validation.. bah. Too
much technical debt.

> > +Unknown attributes
> > +------------------
> > +
> > +Historically Netlink ignored all unknown attributes. The thinking was =
that
> > +it would free the application from having to probe what kernel support=
s.
> > +The application could make a request to change the state and check whi=
ch
> > +parts of the request "stuck".
> > +
> > +This is no longer the case for new Generic Netlink families and those =
opting
> > +in to strict checking. See enum netlink_validation for validation types
> > +performed. =20
>=20
> OK some of that is this, but some of it is also the strict length checks
> e.g. for Ethernet addresses.
>=20
> > +Fixed metadata and structures
> > +-----------------------------
> > +
> > +Classic Netlink made liberal use of fixed-format structures within
> > +the messages. Messages would commonly have a structure with
> > +a considerable number of fields after struct nlmsghdr. It was also
> > +common to put structures with multiple members inside attributes,
> > +without breaking each member into an attribute of its own. =20
>=20
> That reads very descriptive and historic without making a recommendation
> - I know it's in the section, but maybe do say something like "This is
> discouraged now and attributes should be used instead"?

Will do!

> Either way, thanks for doing this, it's a great overview!
>=20
> We might add:
>  - availability of attribute policy introspection
>    (you mention family introspection only I think)

I did mention it, my preference would be that more detail should be in
the genetlink documentation, rather than here.

>  - do we want to bring in the whole "per operation" vs. "per genetlink
>    family" attribute policy?

Nope :)

>    (I'm firmly on the "single policy for the whole family" side ...)

Well, it is causing us grief in devlink at least ;)
No strong preference.

>  - maybe not the appropriate place here, but maybe some best practices
>    for handling attributes, such as the multi-attribute array thing we
>    discussed in the other thread?

Right, this doc is meant for the user rather than kernel dev. I'm
planning to write a separate doc for the kernel dev.
=20
I started writing this one as guide for a person who would like to write
a YAML NL library for their fav user space language but has no prior
knowledge of netlink and does not know where to start.

>  - maybe more userspace recommendations such as using different sockets
>    for multicast listeners and requests, because otherwise it gets
>    tricky to wait for the ACK of a request since you have to handle
>    notifications that happen meanwhile?

Hm, good point. I should add a section on multicast and make it part=20
of that.

>  - maybe some mention of the fact that sometimes we now bind kernel
>    object or state lifetime to a socket, e.g. in wireless you can
>    connect and if your userspace crashes/closes the socket, the
>    connection is automatically torn down (because you can't handle the
>    things needed anymore)

=F0=9F=98=8D Can you point me to the code? (probably too advanced for this =
doc
but the idea seems super useful!)

>  - maybe something about message sizes? we've had lots of trouble with
>    that in nl80211, but tbh I'm not really sure what we should say about
>    it other than making sure you use large enough buffers ...

Yes :S What's the error reported when the buffer is too small?
recv() =3D -1, errno =3D EMSGSIZE? Does the message get discarded=20
or can it be re-read? I don't have practical experience with
that one.
