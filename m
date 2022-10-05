Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A425F4CE2
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJEAEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJEAEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:04:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110866E88B;
        Tue,  4 Oct 2022 17:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70F2ACE1187;
        Wed,  5 Oct 2022 00:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761AEC433C1;
        Wed,  5 Oct 2022 00:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664928241;
        bh=manF1drT7t8VNqMZaxko4/Wv1+ezjZAo1FANb2LeBo4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R7U+rpdlw0XF48iK14ns5ywPUQidHxWqxg/dvUqtp4QNalw9DOZc7s+3AhksHEqOt
         aQXTQusE2/xr716FwhcjSCx2MktqdXz7eHI1TvkRwnxymMxrnAwU4hvorEEWRQ7FW/
         wIRY9stsn89UAmsbvrsMS0kiiSbsJ8SZ5An+PcTlJt4pGVi4fx3Y6ZKiV+Mq2Hk4Gb
         nMCMNdbluzEIneU+7HAu1V8Lfyk5oip0aCPLRZwcP0ShWKChsUTqeANZdL4SnfDMVH
         BseormNFJqc+yt/Mf7F+BGOfh2TehJ/YkLnIkKdm/Es23aIQ//oFKx2uAYtJ8N9h75
         RI0Xop6afxGIg==
Date:   Tue, 4 Oct 2022 17:04:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        linux-hardening@vger.kernel.org
Subject: Re: [syzbot] upstream boot error: WARNING in netlink_ack
Message-ID: <20221004170400.52c97523@kernel.org>
In-Reply-To: <202210041600.7C90DF917@keescook>
References: <000000000000a793cc05ea313b87@google.com>
        <CACT4Y+a8b-knajrXWs8OnF1ijCansRxEicU=YJz6PRk-JuSKvg@mail.gmail.com>
        <F58E0701-8F53-46FE-8324-4DEA7A806C20@chromium.org>
        <20221004104253.29c1f3c7@kernel.org>
        <202210041600.7C90DF917@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Oct 2022 16:40:32 -0700 Kees Cook wrote:
> On Tue, Oct 04, 2022 at 10:42:53AM -0700, Jakub Kicinski wrote:
> > This has been weighing on my conscience a little, I don't like how we
> > still depend on putting one length in the skb and then using a
> > different one for the actual memcpy(). How would you feel about this
> > patch on top (untested): =20
>=20
> tl;dr: yes, I like it. Please add a nlmsg_contents member. :)

Can do, but you'll need to tell me how..

	__DECLARE_FLEX_ARRAY(char, nlmsg_contents)

?

> > +				 u32 size)
> > +{
> > +	if (unlikely(skb_tailroom(skb) < NLMSG_ALIGN(size)))
> > +		return NULL;
> > +
> > +	if (!__builtin_constant_p(size) || NLMSG_ALIGN(size) - size !=3D 0) =
=20
>=20
> why does a fixed size mean no memset?

Copy and paste, it seems to originate from:

0c19b0adb8dd ("netlink: avoid memset of 0 bytes sparse warning")

Any idea why sparse would not like empty memsets?

> >  	rep =3D nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
> > -			NLMSG_ERROR, payload, flags);
> > +			NLMSG_ERROR, sizeof(*errmsg), flags);
> > +	if (!rep)
> > +		goto err_bad_put;
> >  	errmsg =3D nlmsg_data(rep);
> >  	errmsg->error =3D err;
> > -	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
> > -					 ? nlh->nlmsg_len : sizeof(*nlh),
> > -		      /* Bounds checked by the skb layer. */);
> > +	memcpy(&errmsg->msg, nlh, sizeof(*nlh));
> > +
> > +	if (!(flags & NLM_F_CAPPED)) { =20
>=20
> Should it test this flag, or test if the sizes show the need for "extra"
> payload length?
>=20
> I always found the progression of sizes here to be confusing. "payload"
> starts as sizeof(*errmsg), and gets nlmsg_len(nlh) added but only when if
> "(err && !(nlk->flags & NETLINK_F_CAP_ACK)" was true.

struct nlmsgerr is one of the least badly documented structs we have in
netlink so let me start with a copy & paste:

struct nlmsgerr {
	int		error;
	struct nlmsghdr msg;
	/*
	 * followed by the message contents unless NETLINK_CAP_ACK was set
	 * or the ACK indicates success (error =3D=3D 0)
	 * message length is aligned with NLMSG_ALIGN()
	 */
	/*
	 * followed by TLVs defined in enum nlmsgerr_attrs
	 * if NETLINK_EXT_ACK was set
	 */
};

*Why* that's the behavior - =F0=9F=A4=B7

> Why is nlmsg_len(nlh) _wrong_ if the rest of its contents are
> correct?=20

This is an ack message, to be clear, doesn't mean anything was wrong.
It just carries errno.

> If this was "0" in the other state, the logic would just be:
>=20
> 	nlh_bytes =3D nlmsg_len(nlh);
> 	total  =3D sizeof(*errmsg);
> 	total +=3D nlh_bytes;
> 	total +=3D tlvlen;
>=20
> and:
>=20
> 	nlmsg_new(total, ...);
> 	... nlmsg_put(..., sizeof(*errmsg), ...);
> 	...
> 	errmsg->error =3D err;
> 	errmsg->nlh =3D *nlh;
> 	if (nlh_bytes) {
> 		data =3D nlmsg_append(..., nlh_bytes), ...);
> 		...
> 		memcpy(data, nlh->nlmsg_contents, nlh_bytes);
> 	}
>=20
> > +		size_t data_len =3D nlh->nlmsg_len - sizeof(*nlh); =20
>=20
> I think data_len here is also "payload - sizeof(*errmsg)"? So if it's
> >0, we need to append the nlh contents.

I was trying to avoid using payload in case it has overflown :S

> > +		void *data;
> > +
> > +		data =3D nlmsg_append(skb, rep, data_len);
> > +		if (!data)
> > +			goto err_bad_put;
> > +
> > +		/* the nlh + 1 is probably going to make you
> > unhappy? */ =20
>=20
> Right, the compiler may think it is an object no larger than
> sizeof(*nlh). My earliest attempt at changes here introduced a
> flex-array for the contents, and split the memcpy:
> https://lore.kernel.org/lkml/d7251d92-150b-5346-6237-52afc154bb00@rasmusv=
illemoes.dk/
> which is basically the solution you have here, except it wasn't having
> the nlmsg_*-helpers do the bounds checking.
>=20
> > +		memcpy(data, nlh + 1, data_len); =20
>=20
> So with the struct nlmsghdr::nlmsg_contents member, this becomes:
>=20
> 		memcpy(data, nlh->nlmsg_contents, data_len);
>=20
