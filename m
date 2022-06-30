Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3800A5621AE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiF3SEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiF3SEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820DF335;
        Thu, 30 Jun 2022 11:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EFE7621F2;
        Thu, 30 Jun 2022 18:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165BCC341D0;
        Thu, 30 Jun 2022 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656612284;
        bh=f950jtpimm6llvBIVU22LnbDKwH1d1N8MqSNkBHYZog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bvZGTJ21brBE65/CdoDMgVQUHxos2ISOvsaLAT4gk24ijr6i3AfUcPwf0gQ5zYR2r
         KiLcQdtxhso60Cz9T6hGjG0AfWChxEvv59i+CqesySskmoWXXh4d4P/J/rAXp3177t
         lI+nCAfIMgYBJkg4kiBqdPKGVNOEs3TqKJk45IFZ9UKtALOqM91HN0fWWJDEE1n4NQ
         2grvNE7v/PB6ehRKw12v3llPdzZ94VLewhKA6m5iwE9cj8O/mWCf7fWSvqk6gg6tut
         tl/dhyi7LtTXrxzxEtKYE3ORDIqo+S1AAeOIeb+/h9C3+HMgksFOOwrSRmmxHKi78B
         lsc8RFJtHf04w==
Date:   Thu, 30 Jun 2022 11:04:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "U'ren, Aaron" <Aaron.U'ren@sony.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between
 5.10 and 5.15
Message-ID: <20220630110443.100f8aa9@kernel.org>
In-Reply-To: <DM6PR13MB309846DD4673636DF440000EC8BA9@DM6PR13MB3098.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
        <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
        <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
        <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
        <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
        <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com>
        <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
        <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
        <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info>
        <DM6PR13MB309846DD4673636DF440000EC8BA9@DM6PR13MB3098.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.6 required=5.0 tests=APOSTROPHE_TOCC,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sounds like you're pretty close to figuring this out! Can you check=20
if the user space is intentionally setting IPSET_ATTR_INITVAL?
Either that or IPSET_ATTR_GC was not as "unused" as initially thought.

Testing something like this could be a useful data point:

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/lin=
ux/netfilter/ipset/ip_set.h
index 6397d75899bc..7caf9b53d2a7 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -92,7 +92,7 @@ enum {
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX =3D 16,
 	/* Create-only specific attributes */
-	IPSET_ATTR_INITVAL,	/* was unused IPSET_ATTR_GC */
+	IPSET_ATTR_GC,
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
 	IPSET_ATTR_NETMASK,
@@ -104,6 +104,8 @@ enum {
 	IPSET_ATTR_REFERENCES,
 	IPSET_ATTR_MEMSIZE,
=20
+	IPSET_ATTR_INITVAL,
+
 	__IPSET_ATTR_CREATE_MAX,
 };
 #define IPSET_ATTR_CREATE_MAX	(__IPSET_ATTR_CREATE_MAX - 1)


On Thu, 30 Jun 2022 14:59:14 +0000 U'ren, Aaron wrote:
> Thorsten / Jozsef -
>=20
> Thanks for continuing to follow up! I'm sorry that this has moved so slow=
, it has taken us a bit to find the time to fully track this issue down, ho=
wever, I think that we have figured out enough to make some more forward pr=
ogress on this issue.
>=20
> Jozsef, thanks for your insight into what is happening between those syst=
em calls. In regards to your question about wait/wound mutex debugging poss=
ibly being enabled, I can tell you that we definitely don't have that enabl=
ed on any of our regular machines. While we were debugging we did turn on q=
uite a few debug options to help us try and track this issue down and it is=
 very possible that the strace that was taken that started off this email w=
as taken on a machine that did have that debug option enabled. Either way t=
hough, the root issue occurs on hosts that definitely do not have wait/woun=
d mutex debugging enabled.
>=20
> The good news is that we finally got one of our development environments =
into a state where we could reliably reproduce the performance issue across=
 reboots. This was a win because it meant that we were able to do a full bi=
sect of the kernel and were able to tell relatively quickly whether or not =
the issue was present in the test kernels.
>=20
> After bisecting for 3 days, I have been able to narrow it down to a singl=
e commit: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D3976ca101990ca11ddf51f38bec7b86c19d0ca6f (netfilter: ipset: =
Expose the initval hash parameter to userspace)
>=20
> I'm at a bit of a loss as to why this would cause such severe performance=
 regressions, but I've proved it out multiple times now. I've even checked =
out a fresh version of the 5.15 kernel that we've been deploying with just =
this single commit reverted and found that the performance problems are com=
pletely resolved.
>=20
> I'm hoping that maybe Jozsef will have some more insight into why this se=
emingly innocuous commit causes such larger performance issues for us? If y=
ou have any additional patches or other things that you would like us to te=
st I will try to leave our environment in its current state for the next co=
uple of days so that we can do so.
>=20
> -Aaron
>=20
> From: Thorsten Leemhuis <regressions@leemhuis.info>
> Date: Monday, June 20, 2022 at 2:16 AM
> To: U'ren, Aaron <Aaron.U'ren@sony.com>
> Cc: McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pablo@n=
etfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.kernel=
.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.rueg=
er@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>, =
regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian Westphal=
 <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef Ka=
dlecsik <kadlec@netfilter.org>
> Subject: Re: Intermittent performance regression related to ipset between=
 5.10 and 5.15
> On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> > On Mon, 30 May 2022, Thorsten Leemhuis wrote: =20
> >> On 04.05.22 21:37, U'ren, Aaron wrote: =20
>  [...] =20
> >=20
> > Every set lookups behind "iptables" needs two getsockopt() calls: you c=
an=20
> > see them in the strace logs. The first one check the internal protocol=
=20
> > number of ipset and the second one verifies/gets the processed set (it'=
s=20
> > an extension to iptables and therefore there's no internal state to sav=
e=20
> > the protocol version number). =20
>=20
> Hi Aaron! Did any of the suggestions from Jozsef help to track down the
> root case? I have this issue on the list of tracked regressions and
> wonder what the status is. Or can I mark this as resolved?
>=20
> Side note: this is not a "something breaks" regressions and it seems to
> progress slowly, so I'm putting it on the backburner:
>=20
> #regzbot backburner: performance regression where the culprit is hard to
> track down
>=20
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>=20
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
>=20
>  [...] =20
> >=20
> > In your strace log
> >=20
> > 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [=
8]) =3D 0 <0.000024>
> > 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE=
-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
> > 0.109456 close(4)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0 <0.000022>
> >=20
> > the only things which happen in the second sockopt function are to lock=
=20
> > the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare the=20
> > setname, save the result in the case of a match and unlock the mutex.=20
> > Nothing complicated, no deep, multi-level function calls. Just a few li=
ne=20
> > of codes which haven't changed.
> >=20
> > The only thing which can slow down the processing is the mutex handling=
.=20
> > Don't you have accidentally wait/wound mutex debugging enabled in the=20
> > kernel? If not, then bisecting the mutex related patches might help.
> >=20
> > You wrote that flushing tables or ipsets didn't seem to help. That=20
> > literally meant flushing i.e. the sets were emptied but not destroyed? =
Did=20
> > you try both destroying or flushing?
> >  =20
> >> Jozsef, I still have this issue on my list of tracked regressions and =
it
> >> looks like nothing happens since above mail (or did I miss it?). Could
> >> you maybe provide some guidance to Aaron to get us all closer to the
> >> root of the problem? =20
> >=20
> > I really hope it's an accidentally enabled debugging option in the kern=
el.=20
> > Otherwise bisecting could help to uncover the issue.
> >=20
> > Best regards,
> > Jozsef
> >  =20
> >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> >> reports and sometimes miss something important when writing mails like
> >> this. If that's the case here, don't hesitate to tell me in a public
> >> reply, it's in everyone's interest to set the public record straight.
