Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ADF294BD2
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 13:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439512AbgJULcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 07:32:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410706AbgJULcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 07:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603279972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4qa4Gs2TMUCM8ArM6KEs5M9/k6qdbwXygnEcb+hu4A=;
        b=BxYq/++vre8+3/tB3ii2Mj7OjG+/YSDSSPlR/T9ZyhYI4h/aHltM84V1xrEb/E2Pm+/OGM
        eZqCDtlNJTCfaoGskKfelKeBO2pL4/ya/L449REkH/1qzcMiCkQU4bDCn2JhraGenydEL+
        jS2eCurQ8A3jPHRqblSMDXYeB/+ra3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-MmQYUyUdMA625l6_u-0cUw-1; Wed, 21 Oct 2020 07:32:48 -0400
X-MC-Unique: MmQYUyUdMA625l6_u-0cUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A2F2186DD24;
        Wed, 21 Oct 2020 11:32:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF4DC5D9CA;
        Wed, 21 Oct 2020 11:32:39 +0000 (UTC)
Date:   Wed, 21 Oct 2020 13:32:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Eyal Birger <eyal.birger@gmail.com>, brouer@redhat.com
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next V3 3/6] bpf: add BPF-helper for MTU checking
Message-ID: <20201021133237.2885eab2@carbon>
In-Reply-To: <CANP3RGdq-irQ7w8=1xWNPh0Fn+72d9wrKR24vQJTFMa8w4+b6w@mail.gmail.com>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <160216615258.882446.12640007391672866038.stgit@firesoul>
        <CANP3RGdq-irQ7w8=1xWNPh0Fn+72d9wrKR24vQJTFMa8w4+b6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 16:29:46 -0700
Maciej =C5=BBenczykowski <maze@google.com> wrote:

> On Thu, Oct 8, 2020 at 7:09 AM Jesper Dangaard Brouer <brouer@redhat.com>=
 wrote:
> >
> > This BPF-helper bpf_mtu_check() works for both XDP and TC-BPF programs.=
 =20
>=20
> bpf_check_mtu() seems a better name.

Okay, we can rename it. I will go through the patch and change the name
of all the functions (so it resembles the helper name).


> >
> > The API is designed to help the BPF-programmer, that want to do packet
> > context size changes, which involves other helpers. These other helpers
> > usually does a delta size adjustment. This helper also support a delta
> > size (len_diff), which allow BPF-programmer to reuse arguments needed by
> > these other helpers, and perform the MTU check prior to doing any actual
> > size adjustment of the packet context.
> >
> > V3: Take L2/ETH_HLEN header size into account and document it.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h       |   63 +++++++++++++++++++++
> >  net/core/filter.c              |  119 ++++++++++++++++++++++++++++++++=
++++++++
> >  tools/include/uapi/linux/bpf.h |   63 +++++++++++++++++++++
> >  3 files changed, 245 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4a46a1de6d16..1dcf5d8195f4 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3718,6 +3718,56 @@ union bpf_attr {
> >   *             never return NULL.
> >   *     Return
> >   *             A pointer pointing to the kernel percpu variable on thi=
s cpu.
> > + *
> > + * int bpf_mtu_check(void *ctx, u32 ifindex, u32 *mtu_result, s32 len_=
diff, u64 flags)
> > + *     Description
> > + *             Check ctx packet size against MTU of net device (based =
on
> > + *             *ifindex*).  This helper will likely be used in combina=
tion with
> > + *             helpers that adjust/change the packet size.  The argume=
nt
> > + *             *len_diff* can be used for querying with a planned size
> > + *             change. This allows to check MTU prior to changing pack=
et ctx.
> > + *
> > + *             The Linux kernel route table can configure MTUs on a mo=
re
> > + *             specific per route level, which is not provided by this=
 helper.
> > + *             For route level MTU checks use the **bpf_fib_lookup**\ =
()
> > + *             helper.
> > + *
> > + *             *ctx* is either **struct xdp_md** for XDP programs or
> > + *             **struct sk_buff** for tc cls_act programs.
> > + *
> > + *             The *flags* argument can be a combination of one or mor=
e of the
> > + *             following values:
> > + *
> > + *              **BPF_MTU_CHK_RELAX**
> > + *                     This flag relax or increase the MTU with room f=
or one
> > + *                     VLAN header (4 bytes) and take into account net=
 device
> > + *                     hard_header_len.  This relaxation is also used =
by the
> > + *                     kernels own forwarding MTU checks.
> > + *
> > + *             **BPF_MTU_CHK_GSO**
> > + *                     This flag will only works for *ctx* **struct sk=
_buff**.
> > + *                     If packet context contains extra packet segment=
 buffers
> > + *                     (often knows as frags), then those are also che=
cked
> > + *                     against the MTU size. =20
>=20
> naming is weird... what does GSO have to do with frags?
> Aren't these orthogonal things?

They are connected implementation wise. The name "frags" comes from the
implementation detail that GSO segments use "frags", but looking at
implementation details, it does seem like GSO segments actually use
member 'frag_list' (in struct skb_shared_info).  I actually hate the
name/term "frags" as it is very confusing to talk/write above, and
usually people talk past each-other (e.g. frags vs frag_list, and
general concepts packet fragments).

I think I will rename BPF_MTU_CHK_GSO to BPF_MTU_CHK_SEGMENTS.  I want
a more general flag name, as I also want Lorenzo to use this for
checking XDP multi-buffer segments.


> > + *
> > + *             The *mtu_result* pointer contains the MTU value of the =
net
> > + *             device including the L2 header size (usually 14 bytes E=
thernet
> > + *             header). The net device configured MTU is the L3 size, =
but as
> > + *             XDP and TX length operate at L2 this helper include L2 =
header
> > + *             size in reported MTU.
> > + *
> > + *     Return
> > + *             * 0 on success, and populate MTU value in *mtu_result* =
pointer.
> > + *
> > + *             * < 0 if any input argument is invalid (*mtu_result* no=
t updated) =20
>=20
> not -EINVAL?

Yes, also -EINVAL.

> > + *
> > + *             MTU violations return positive values, but also populat=
e MTU
> > + *             value in *mtu_result* pointer, as this can be needed for
> > + *             implemeting PMTU handing: =20
> implementing

Fixed

> > + *
> > + *             * **BPF_MTU_CHK_RET_FRAG_NEEDED**
> > + *             * **BPF_MTU_CHK_RET_GSO_TOOBIG**
> > + *
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -3875,6 +3925,7 @@ union bpf_attr {
> >         FN(redirect_neigh),             \
> >         FN(bpf_per_cpu_ptr),            \
> >         FN(bpf_this_cpu_ptr),           \
> > +       FN(mtu_check),                  \
> >         /* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> > @@ -4889,6 +4940,18 @@ struct bpf_fib_lookup {
> >         __u8    dmac[6];     /* ETH_ALEN */
> >  };
> >
> > +/* bpf_mtu_check flags*/
> > +enum  bpf_mtu_check_flags {
> > +       BPF_MTU_CHK_RELAX =3D (1U << 0),
> > +       BPF_MTU_CHK_GSO   =3D (1U << 1),
> > +};
> > +
> > +enum bpf_mtu_check_ret {
> > +       BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
> > +       BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd =
*/
> > +       BPF_MTU_CHK_RET_GSO_TOOBIG,   /* GSO re-segmentation needed to =
fwd */
> > +};
> > +
> >  enum bpf_task_fd_type {
> >         BPF_FD_TYPE_RAW_TRACEPOINT,     /* tp name */
> >         BPF_FD_TYPE_TRACEPOINT,         /* tp name */
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index da74d6ddc4d7..5986156e700e 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5513,6 +5513,121 @@ static const struct bpf_func_proto bpf_skb_fib_=
lookup_proto =3D {
> >         .arg4_type      =3D ARG_ANYTHING,
> >  };
> >
> > +static int bpf_mtu_lookup(struct net *netns, u32 ifindex, u64 flags) =
=20
>=20
> bpf_lookup_mtu() ???

Sure, I can rename this but this is a helper function (not exported).
=20
> > +{
> > +       struct net_device *dev;
> > +       int mtu;
> > +
> > +       dev =3D dev_get_by_index_rcu(netns, ifindex); =20
>=20
> my understanding is this is a bit of a perf hit, maybe ifindex 0 means
> use skb->dev ???

Might be a good idea.

> or have bpf_lookup_mtu(skb) function as well?

No, you can easily give parameters to bpf_check_mtu() that gives you a
lookup functionality, there is no need to create a second helper call.

>=20
> > +       if (!dev)
> > +               return -ENODEV;
> > +
> > +       /* XDP+TC len is L2: Add L2-header as dev MTU is L3 size */
> > +       mtu =3D dev->mtu + dev->hard_header_len;
> > +
> > +       /*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
> > +       if (flags & BPF_MTU_CHK_RELAX) =20
>=20
> could this check device vlan tx offload state instead?
>=20
> > +               mtu +=3D VLAN_HLEN;
> > +
> > +       return mtu;
> > +}
> > +
> > +static unsigned int __bpf_len_adjust_positive(unsigned int len, int le=
n_diff)
> > +{
> > +       int len_new =3D len + len_diff; /* notice len_diff can be negat=
ive */
> > +
> > +       if (len_new > 0)
> > +               return len_new;
> > +
> > +       return 0; =20
>=20
> not return len ?

I prefer returning 0 here, but return len would also be okay for the
boarderline case/error that I want to handle.

>=20
> oh I see the function doesn't do what the name implies...

Okay, suggestions for a better name?

> nor sure this func is helpful... why not simply
> int len_new =3D (int)len + (int)len_diff;=20

(you do write int len_new, but I assume we want unsigned int len_new)

I don't like this approach, as a shrink that cause negative value, will
be turned into a very large value, which will failed the MTU check.

I'm actually trying to anticipate/help the BPF-programmer.  I can easily
imagine a BPF-prog that pops a VXLAN header, so programmer always call
bpf_check_mtu with len_diff and drops packets that exceed MTU, but
small packet that goes negative suddenly gets dropped with your
approach.  Thus, we force BPF-prog to do more checks before using our
BPF-helper, which I would like to avoid.

> directly down below and check < 0 there?

Because I use this helper function in two functions below.


> >2GB skb->len is meaningless anyway =20
>=20
> > +}
> > +
> > +BPF_CALL_5(bpf_skb_mtu_check, struct sk_buff *, skb,
> > +          u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
> > +{
> > +       struct net *netns =3D dev_net(skb->dev);
> > +       int ret =3D BPF_MTU_CHK_RET_SUCCESS;
> > +       unsigned int len =3D skb->len;
> > +       int mtu;
> > +
> > +       if (flags & ~(BPF_MTU_CHK_RELAX | BPF_MTU_CHK_GSO))
> > +               return -EINVAL;
> > +
> > +       mtu =3D bpf_mtu_lookup(netns, ifindex, flags);
> > +       if (unlikely(mtu < 0))
> > +               return mtu; /* errno */
> > +
> > +       len =3D __bpf_len_adjust_positive(len, len_diff);
> > +       if (len > mtu) {
> > +               ret =3D BPF_MTU_CHK_RET_FRAG_NEEDED; =20
>=20
> Can't this fail if skb->len includes the entire packet, and yet gso is
> on, and packet is greater then mtu, yet gso size is smaller?
>
> Think 200 byte gso packet with 2 100 byte segs, and a 150 byte mtu.
> Does gso actually require frags?  [As you can tell I don't have a good
> handle on gso vs frags vs skb->len, maybe what I"m asking is bogus]

Oh oh, does skb->len include the size of GSO segments (the individual
packet segments)? ... argh yes is does!  So, this *is* a bug, I will
fix.  Thanks for spotting it!

Looking at the code it is clear and also make more sense that people
are complaining that as long as skb_is_gso(skb) it can bypass these MTU
checks.

I could calculate the "first"/"head" packet length via subtracting
skb->data_len (which should contain the len of fragments). Well, I'll
figure out how to solve it in the code.


>=20
> > +               goto out;
> > +       }
> > +
> > +       if (flags & BPF_MTU_CHK_GSO &&
> > +           skb_is_gso(skb) &&
> > +           skb_gso_validate_network_len(skb, mtu)) {
> > +               ret =3D BPF_MTU_CHK_RET_GSO_TOOBIG;
> > +               goto out;
> > +       }
> > +
> > +out:
> > +       if (mtu_result)
> > +               *mtu_result =3D mtu;
> > +
> > +       return ret;
> > +}
> > +
> > +BPF_CALL_5(bpf_xdp_mtu_check, struct xdp_buff *, xdp,
> > +          u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
> > +{
> > +       unsigned int len =3D xdp->data_end - xdp->data;
> > +       struct net_device *dev =3D xdp->rxq->dev;
> > +       struct net *netns =3D dev_net(dev);
> > +       int ret =3D BPF_MTU_CHK_RET_SUCCESS;
> > +       int mtu;
> > +
> > +       /* XDP variant doesn't support multi-buffer segment check (yet)=
 */
> > +       if (flags & ~BPF_MTU_CHK_RELAX)
> > +               return -EINVAL;
> > +
> > +       mtu =3D bpf_mtu_lookup(netns, ifindex, flags);
> > +       if (unlikely(mtu < 0))
> > +               return mtu; /* errno */
> > +
> > +       len =3D __bpf_len_adjust_positive(len, len_diff);
> > +       if (len > mtu) {
> > +               ret =3D BPF_MTU_CHK_RET_FRAG_NEEDED;
> > +               goto out;
> > +       }
> > +out:
> > +       if (mtu_result)
> > +               *mtu_result =3D mtu;
> > +
> > +       return ret;
> > +}

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

