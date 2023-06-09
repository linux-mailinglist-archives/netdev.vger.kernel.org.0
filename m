Return-Path: <netdev+bounces-9402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDC7728C71
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907BD281714
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA897E5;
	Fri,  9 Jun 2023 00:29:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594627E2;
	Fri,  9 Jun 2023 00:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877D3C433EF;
	Fri,  9 Jun 2023 00:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686270590;
	bh=wmxbHN8O68icKsXOGHDfgjKZLSkMHrOu9CpvTQZKtWE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=tn79s++SBXJTD2el/ugt2BTfnAzW6c4jcuDUF+cLYGtsWyKXx67nPtraHuFwoJblv
	 0+AcERL7YJ8ev4B3ikWqQuam5f0//4DoXPygETBP4IWOdZHuMqOE3v0icfrxeYkOiZ
	 5gVPP8C43dtC2NxzQVZSTHHJFa3dm1NFziYxOl5jZY7rTTXpPd9aNcY4e7V20mVFxL
	 gw4zh9QUh9nSbpwYgivWJ4ZTt0atyORLmvm6AVK8C1lq8q3pfAJMJfD32x3ncs9aOn
	 ndaHujvWxNu7LXJPNj0ZTAhcPuqU/CgwlQuMMRotpt3i6rY/TSbY8NSoxvAhQKgcgw
	 zHFAgvFwfTLgQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id F1898BBE171; Fri,  9 Jun 2023 02:29:47 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Stanislav Fomichev <sdf@google.com>, Andrii Nakryiko
 <andrii.nakryiko@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
 andrii@kernel.org, martin.lau@linux.dev, razor@blackwall.org,
 john.fastabend@gmail.com, kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io,
 davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query
 API for multi-progs
In-Reply-To: <ZIJe5Ml6ILFa6tKP@google.com>
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Fri, 09 Jun 2023 02:29:47 +0200
Message-ID: <87a5x91nr8.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Stanislav Fomichev <sdf@google.com> writes:

> On 06/08, Andrii Nakryiko wrote:
>> On Thu, Jun 8, 2023 at 2:52=E2=80=AFPM Stanislav Fomichev <sdf@google.co=
m> wrote:
>> >
>> > On 06/08, Andrii Nakryiko wrote:
>> > > On Thu, Jun 8, 2023 at 10:24=E2=80=AFAM Stanislav Fomichev <sdf@goog=
le.com> wrote:
>> > > >
>> > > > On 06/07, Daniel Borkmann wrote:
>> > > > > This adds a generic layer called bpf_mprog which can be reused b=
y different
>> > > > > attachment layers to enable multi-program attachment and depende=
ncy resolution.
>> > > > > In-kernel users of the bpf_mprog don't need to care about the de=
pendency
>> > > > > resolution internals, they can just consume it with few API call=
s.
>> > > > >
>> > > > > The initial idea of having a generic API sparked out of discussi=
on [0] from an
>> > > > > earlier revision of this work where tc's priority was reused and=
 exposed via
>> > > > > BPF uapi as a way to coordinate dependencies among tc BPF progra=
ms, similar
>> > > > > as-is for classic tc BPF. The feedback was that priority provide=
s a bad user
>> > > > > experience and is hard to use [1], e.g.:
>> > > > >
>> > > > >   I cannot help but feel that priority logic copy-paste from old=
 tc, netfilter
>> > > > >   and friends is done because "that's how things were done in th=
e past". [...]
>> > > > >   Priority gets exposed everywhere in uapi all the way to bpftoo=
l when it's
>> > > > >   right there for users to understand. And that's the main probl=
em with it.
>> > > > >
>> > > > >   The user don't want to and don't need to be aware of it, but u=
api forces them
>> > > > >   to pick the priority. [...] Your cover letter [0] example prov=
es that in
>> > > > >   real life different service pick the same priority. They simpl=
y don't know
>> > > > >   any better. Priority is an unnecessary magic that apps _have_ =
to pick, so
>> > > > >   they just copy-paste and everyone ends up using the same.
>> > > > >
>> > > > > The course of the discussion showed more and more the need for a=
 generic,
>> > > > > reusable API where the "same look and feel" can be applied for v=
arious other
>> > > > > program types beyond just tc BPF, for example XDP today does not=
 have multi-
>> > > > > program support in kernel, but also there was interest around th=
is API for
>> > > > > improving management of cgroup program types. Such common multi-=
program
>> > > > > management concept is useful for BPF management daemons or user =
space BPF
>> > > > > applications coordinating about their attachments.
>> > > > >
>> > > > > Both from Cilium and Meta side [2], we've collected the followin=
g requirements
>> > > > > for a generic attach/detach/query API for multi-progs which has =
been implemented
>> > > > > as part of this work:
>> > > > >
>> > > > >   - Support prog-based attach/detach and link API
>> > > > >   - Dependency directives (can also be combined):
>> > > > >     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {p=
rog,link,none}
>> > > > >       - BPF_F_ID flag as {fd,id} toggle
>> > > > >       - BPF_F_LINK flag as {prog,link} toggle
>> > > > >       - If relative_{fd,id} is none, then BPF_F_BEFORE will just=
 prepend, and
>> > > > >         BPF_F_AFTER will just append for the case of attaching
>> > > > >       - Enforced only at attach time
>> > > > >     - BPF_F_{FIRST,LAST}
>> > > > >       - Enforced throughout the bpf_mprog state's lifetime
>> > > > >       - Admin override possible (e.g. link detach, prog-based BP=
F_F_REPLACE)
>> > > > >   - Internal revision counter and optionally being able to pass =
expected_revision
>> > > > >   - User space daemon can query current state with revision, and=
 pass it along
>> > > > >     for attachment to assert current state before doing updates
>> > > > >   - Query also gets extension for link_ids array and link_attach=
_flags:
>> > > > >     - prog_ids are always filled with program IDs
>> > > > >     - link_ids are filled with link IDs when link was used, othe=
rwise 0
>> > > > >     - {prog,link}_attach_flags for holding {prog,link}-specific =
flags
>> > > > >   - Must be easy to integrate/reuse for in-kernel users
>> > > > >
>> > > > > The uapi-side changes needed for supporting bpf_mprog are rather=
 minimal,
>> > > > > consisting of the additions of the attachment flags, revision co=
unter, and
>> > > > > expanding existing union with relative_{fd,id} member.
>> > > > >
>> > > > > The bpf_mprog framework consists of an bpf_mprog_entry object wh=
ich holds
>> > > > > an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp =
(control-path
>> > > > > structure). Both have been separated, so that fast-path gets eff=
icient packing
>> > > > > of bpf_prog pointers for maximum cache efficieny. Also, array ha=
s been chosen
>> > > > > instead of linked list or other structures to remove unnecessary=
 indirections
>> > > > > for a fast point-to-entry in tc for BPF. The bpf_mprog_entry com=
es as a pair
>> > > > > via bpf_mprog_bundle so that in case of updates the peer bpf_mpr=
og_entry
>> > > > > is populated and then just swapped which avoids additional alloc=
ations that
>> > > > > could otherwise fail, for example, in detach case. bpf_mprog_{fp=
,cp} arrays are
>> > > > > currently static, but they could be converted to dynamic allocat=
ion if necessary
>> > > > > at a point in future. Locking is deferred to the in-kernel user =
of bpf_mprog,
>> > > > > for example, in case of tcx which uses this API in the next patc=
h, it piggy-
>> > > > > backs on rtnl. The nitty-gritty details are in the bpf_mprog_{re=
place,head_tail,
>> > > > > add,del} implementation and an extensive test suite for checking=
 all aspects
>> > > > > of this API for prog-based attach/detach and link API as BPF sel=
ftests in
>> > > > > this series.
>> > > > >
>> > > > > Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF=
 management daemon.
>> > > > >
>> > > > >   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@=
iogearbox.net/
>> > > > >   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=3D+DmjDR4gp5b=
OYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com
>> > > > >   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netde=
v_borkmann.pdf
>> > > > >
>> > > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> > > > > ---
>> > > > >  MAINTAINERS                    |   1 +
>> > > > >  include/linux/bpf_mprog.h      | 245 +++++++++++++++++
>> > > > >  include/uapi/linux/bpf.h       |  37 ++-
>> > > > >  kernel/bpf/Makefile            |   2 +-
>> > > > >  kernel/bpf/mprog.c             | 476 ++++++++++++++++++++++++++=
+++++++
>> > > > >  tools/include/uapi/linux/bpf.h |  37 ++-
>> > > > >  6 files changed, 781 insertions(+), 17 deletions(-)
>> > > > >  create mode 100644 include/linux/bpf_mprog.h
>> > > > >  create mode 100644 kernel/bpf/mprog.c
>> > > > >
>> > >
>> > > [...]
>> > >
>> > > > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi=
/linux/bpf.h
>> > > > > index a7b5e91dd768..207f8a37b327 100644
>> > > > > --- a/tools/include/uapi/linux/bpf.h
>> > > > > +++ b/tools/include/uapi/linux/bpf.h
>> > > > > @@ -1102,7 +1102,14 @@ enum bpf_link_type {
>> > > > >   */
>> > > > >  #define BPF_F_ALLOW_OVERRIDE (1U << 0)
>> > > > >  #define BPF_F_ALLOW_MULTI    (1U << 1)
>> > > > > +/* Generic attachment flags. */
>> > > > >  #define BPF_F_REPLACE                (1U << 2)
>> > > > > +#define BPF_F_BEFORE         (1U << 3)
>> > > > > +#define BPF_F_AFTER          (1U << 4)
>> > > >
>> > > > [..]
>> > > >
>> > > > > +#define BPF_F_FIRST          (1U << 5)
>> > > > > +#define BPF_F_LAST           (1U << 6)
>> > > >
>> > > > I'm still not sure whether the hard semantics of first/last is rea=
lly
>> > > > useful. My worry is that some prog will just use BPF_F_FIRST which
>> > > > would prevent the rest of the users.. (starting with only
>> > > > F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we real=
ly
>> > > > need first/laste).
>> > >
>> > > Without FIRST/LAST some scenarios cannot be guaranteed to be safely
>> > > implemented. E.g., if I have some hard audit requirements and I need
>> > > to guarantee that my program runs first and observes each event, I'll
>> > > enforce BPF_F_FIRST when attaching it. And if that attachment fails,
>> > > then server setup is broken and my application cannot function.
>> > >
>> > > In a setup where we expect multiple applications to co-exist, it
>> > > should be a rule that no one is using FIRST/LAST (unless it's
>> > > absolutely required). And if someone doesn't comply, then that's a b=
ug
>> > > and has to be reported to application owners.
>> > >
>> > > But it's not up to the kernel to enforce this cooperation by
>> > > disallowing FIRST/LAST semantics, because that semantics is critical
>> > > for some applications, IMO.
>> >
>> > Maybe that's something that should be done by some other mechanism?
>> > (and as a follow up, if needed) Something akin to what Toke
>> > mentioned with another program doing sorting or similar.
>>=20
>> The goal of this API is to avoid needing some extra special program to
>> do this sorting
>>=20
>> >
>> > Otherwise, those first/last are just plain simple old priority bands;
>> > only we have two now, not u16.
>>=20
>> I think it's different. FIRST/LAST has to be used judiciously, of
>> course, but when they are needed, they will have no alternative.
>>=20
>> Also, specifying FIRST + LAST is the way to say "I want my program to
>> be the only one attached". Should we encourage such use cases? No, of
>> course. But I think it's fair  for users to be able to express this.
>>=20
>> >
>> > I'm mostly coming from the observability point: imagine I have my fancy
>> > tc_ingress_tcpdump program that I want to attach as a first program to=
 debug
>> > some issue, but it won't work because there is already a 'first' progr=
am
>> > installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>=20
>> If your production setup requires that some important program has to
>> be FIRST, then yeah, your "let me debug something" program shouldn't
>> interfere with it (assuming that FIRST requirement is a real
>> requirement and not someone just thinking they need to be first; but
>> that's up to user space to decide). Maybe the solution for you in that
>> case would be freplace program installed on top of that stubborn FIRST
>> program? And if we are talking about local debugging and development,
>> then you are a sysadmin and you should be able to force-detach that
>> program that is getting in the way.
>
> I'm not really concerned about our production environment. It's pretty
> controlled and restricted and I'm pretty certain we can avoid doing
> something stupid. Probably the same for your env.
>
> I'm mostly fantasizing about upstream world where different users don't
> know about each other and start doing stupid things like F_FIRST where
> they don't really have to be first. It's that "used judiciously" part
> that I'm a bit skeptical about :-D
>
> Because even with this new ordering scheme, there still should be
> some entity to do relative ordering (systemd-style, maybe CNI?).
> And if it does the ordering, I don't really see why we need
> F_FIRST/F_LAST.

I can see I'm a bit late to the party, but FWIW I agree with this:
FIRST/LAST will definitely be abused if we add it. It also seems to me
to be policy in the kernel, which would be much better handled in
userspace like we do for so many other things. So we should rather
expose a hook to allow userspace to set the policy, as we've discussed
before; I definitely think we should add that at some point! Although
obviously it doesn't have to be part of this series...

-Toke

