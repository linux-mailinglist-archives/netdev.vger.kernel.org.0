Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA38520A71C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405326AbgFYUyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405184AbgFYUyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:54:09 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE16C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:54:09 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g20so5081055edm.4
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rZboqY0t0M613974hKyOamQI7YWZD/k8QSz+Gwh/7gg=;
        b=PanO/ZoCWvuthvNKXWZgoWS0EiRTSiKy6GnQW3xKYxxxcYNX+PHhr7WFBCo69YljI2
         ptttBS8HkmA9UjXwaDMLblB6dlvHulFLP9NFpm3n8NYYgjAy77KQPDBilPNQYNVvvLxj
         hNgWrdLGeY6/STdb999ftKJLCuZu1PZ/1MdCrzfVTBC3Izvmn/rBdqH1CvrEEOwEQe2F
         J6B0j4LFvlzI0SLD+k3Pn4bh2dcju8aa+1E+wyxLo7vbwUjbhusZXfjYCLEEkhsc9oCm
         MhHlKLAABILDVZkWELJsIP6JX8f6EuOxF0hfuGnjkeKZ2a4re2FXUC6dueI+h52JO+Pw
         KM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rZboqY0t0M613974hKyOamQI7YWZD/k8QSz+Gwh/7gg=;
        b=QL3bNMpuyTiCi7TUoClfPSsn5/EPVppHQPq+DSdP6Jgn7wBZt1kv57Zxzx2VHq6A2C
         uB+V+ZmNi9aePVsbgBde4xHVXHWnUK4LTMxnEawImDsixSK2JnQkgMXU7BHoghQb+C1C
         j8DspuCzrp5bI1bRMFExPtN84h94UiCxnUrUKcEPqqJdWzM5NuQ358k9pB3Wbf04HcsB
         AM2B3L4pSNC1t5IOuCKFSeVjpiJH6fL3MEVb8sEfCU6WqZcYwNmhLDTUh1+SvuhsHst/
         IeDqhTkPEVP1l/ykywZgRcPYrrNKOElZj6YniZA9VNkoP5R8uZGD0i7ShaXKN6GGQ+MJ
         UGgQ==
X-Gm-Message-State: AOAM531rj55m6EeeukD5pQmAH7wxuQLGnQKRtw1nVsEUvqZ4FmzvE8SJ
        /g0nzlrYam/xtjH8SIOfq0S7WQ+mVsIuXG/RTmy1QA==
X-Google-Smtp-Source: ABdhPJxtv2FG7JRbTOSnUnGeHfp/F896uGGwKFYwOCledGFXmAgkR7tsviA8cq6nE3AjJo2ibXN0JulQ5o86SJfDi8k=
X-Received: by 2002:a50:d513:: with SMTP id u19mr53403edi.241.1593118447941;
 Thu, 25 Jun 2020 13:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be>
 <20200624192310.16923-2-justin.iurman@uliege.be> <CALx6S34K5+GabNAs9GtutpPNxR+fAdibDTFphT_LUOJ1mAzfOQ@mail.gmail.com>
 <517934373.36575257.1593107228168.JavaMail.zimbra@uliege.be>
In-Reply-To: <517934373.36575257.1593107228168.JavaMail.zimbra@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 25 Jun 2020 13:53:57 -0700
Message-ID: <CALx6S34-2TNpWhNOwGfe1xwAJhCZr+xsh7WV2eVN6Yv2qshYrA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] ipv6: eh: Introduce removable TLVs
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 10:47 AM Justin Iurman <justin.iurman@uliege.be> wr=
ote:
>
> Hi Tom,
>
> >> Add the possibility to remove one or more consecutive TLVs without
> >> messing up the alignment of others. For now, only IOAM requires this
> >> behavior.
> >>
> > Hi Justin,
> >
> > Can you explain the motivation for this? Per RFC8200, extension
> > headers in flight are not to be added, removed, or modified outside of
> > the standard rules for processing modifiable HBH and DO TLVs., that
> > would include adding and removing TLVs in EH. One obvious problem this
>
> As you already know from our last meeting, IOAM may be configured on a no=
de such that a specific IOAM namespace should be removed. Therefore, this p=
atch provides support for the deletion of a TLV (or consecutive TLVs), with=
out removing the entire EH (if it's empty, there will be padding). Note tha=
t there is a similar "problem" with the Incremental Trace where you'd need =
to expand the Hop-by-Hop (not included in this patchset). I agree that RFC =
8200 is against modification of in-flight EHs, but there are several reason=
s that, I believe, mitigates this statement.
>
> Let's keep in mind that IOAM purpose is "private" (=3D IOAM domain), ie n=
ot widely deployed on the Internet. We can distinguish two big scenarios: (=
i) in-transit traffic where it is encapsulated (IPv6-in-IPv6) and (ii) traf=
fic inside the domain, ie from an IOAM node inside the domain to another on=
e (no need for encapsulation). In both cases, we kind of own the traffic: (=
i) encapsulation, so we modify "our" header and (ii) we already own the tra=
ffic.
>
> And if someone is still angry about this, well, the good news is that suc=
h modification can be avoided most of the time. Indeed, operators are advis=
ed to remove an IOAM namespace only on egress nodes. This way, the destinat=
ion (either the tunnel destination or the real destination, depending on th=
e scenario) will receive EHs and take care of them without the need to remo=
ve anything. But, again, operators can do what they want and I'd tend to ad=
here to David's philosophy [1] and give them the possibility to choose what=
 to do.
>

Justin,

6man WG has had a _long_ and sometimes bitter discussion around this
particularly with regards to insertion of SRH. The current consensus
of IETF is that it is a violation of RFC8200.  We've heard all the
arguments that it's only for limited domains and narrow use cases,
nevertheless there are several problems that the header
insertion/deletion advocates never answered-- it breaks AH, it breaks
PMTU discovery, it breaks ICMP. There is also a risk that a
non-standard modification could cause a packet to be dropped
downstream from the node that modifies it. There is no attribution on
who created the problem, and hence this can lead to systematic
blackholes which are the most miserable sort of problem to debug.
Fundamentally, it is not robust per Postel's law (I actually wrote a
draft to try to make it robust in draft-herbert-6man-eh-attrib-00 if
you're interested).

IMO, we shouldn't be using Linux as a backdoor to implement protocol
that IETF is saying isn't robust. Can you point out in the IOAM drafts
where this requirement is specified, then I can take it up in IOAM WG
or 6man if needed...

Tom

> > creates is that it breaks AH if the TLVs are removed in HBH before AH
> > is processed (AH is processed after HBH).
>
> Correct. But I don't think it should prevent us from having IOAM in the k=
ernel. Again, operators could simply apply IOAM on a subset of the traffic =
that does not include AHs, for example.
>
> Justin
>
>   [1] https://www.mail-archive.com/netdev@vger.kernel.org/msg136797.html
>
> > Tom
> >> By default, an 8-octet boundary is automatically assumed. This is the
> >> price to pay (at most a useless 4-octet padding) to make sure everythi=
ng
> >> is still aligned after the removal.
> >>
> >> Proof: let's assume for instance the following alignments 2n, 4n and 8=
n
> >> respectively for options X, Y and Z, inside a Hop-by-Hop extension
> >> header.
> >>
> >> Example 1:
> >>
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       X       |       X       |    Padding    |    Padding    |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |                                                               |
> >> ~                Option to be removed (8 octets)                ~
> >> |                                                               |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Y       |       Y       |       Y       |       Y       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |    Padding    |    Padding    |    Padding    |    Padding    |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>
> >> Result 1: assuming a 4-octet boundary would work, as well as an 8-octe=
t
> >> boundary (same result in both cases).
> >>
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       X       |       X       |    Padding    |    Padding    |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Y       |       Y       |       Y       |       Y       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |    Padding    |    Padding    |    Padding    |    Padding    |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>
> >> Example 2:
> >>
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       X       |       X       |    Padding    |    Padding    |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |                Option to be removed (4 octets)                |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Y       |       Y       |       Y       |       Y       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>
> >> Result 2: assuming a 4-octet boundary WOULD NOT WORK. Indeed, option Z
> >> would not be 8n-aligned and the Hop-by-Hop size would not be a multipl=
e
> >> of 8 anymore.
> >>
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       X       |       X       |    Padding    |    Padding    |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Y       |       Y       |       Y       |       Y       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >> |       Z       |       Z       |       Z       |       Z       |
> >> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>
> >> Therefore, the largest (8-octet) boundary is assumed by default and fo=
r
> >> all, which means that blocks are only moved in multiples of 8. This
> >> assertion guarantees good alignment.
> >>
> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >> ---
> >>  net/ipv6/exthdrs.c | 134 ++++++++++++++++++++++++++++++++++++--------=
-
> >>  1 file changed, 108 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> >> index e9b366994475..f27ab3bf2e0c 100644
> >> --- a/net/ipv6/exthdrs.c
> >> +++ b/net/ipv6/exthdrs.c
> >> @@ -52,17 +52,27 @@
> >>
> >>  #include <linux/uaccess.h>
> >>
> >> -/*
> >> - *     Parsing tlv encoded headers.
> >> +/* States for TLV parsing functions. */
> >> +
> >> +enum {
> >> +       TLV_ACCEPT,
> >> +       TLV_REJECT,
> >> +       TLV_REMOVE,
> >> +       __TLV_MAX
> >> +};
> >> +
> >> +/* Parsing TLV encoded headers.
> >>   *
> >> - *     Parsing function "func" returns true, if parsing succeed
> >> - *     and false, if it failed.
> >> - *     It MUST NOT touch skb->h.
> >> + * Parsing function "func" returns either:
> >> + *  - TLV_ACCEPT if parsing succeeds
> >> + *  - TLV_REJECT if parsing fails
> >> + *  - TLV_REMOVE if TLV must be removed
> >> + * It MUST NOT touch skb->h.
> >>   */
> >>
> >>  struct tlvtype_proc {
> >>         int     type;
> >> -       bool    (*func)(struct sk_buff *skb, int offset);
> >> +       int     (*func)(struct sk_buff *skb, int offset);
> >>  };
> >>
> >>  /*********************
> >> @@ -109,19 +119,67 @@ static bool ip6_tlvopt_unknown(struct sk_buff *s=
kb, int
> >> optoff,
> >>         return false;
> >>  }
> >>
> >> +/* Remove one or several consecutive TLVs and recompute offsets, leng=
ths */
> >> +
> >> +static int remove_tlv(int start, int end, struct sk_buff *skb)
> >> +{
> >> +       int len =3D end - start;
> >> +       int padlen =3D len % 8;
> >> +       unsigned char *h;
> >> +       int rlen, off;
> >> +       u16 pl_len;
> >> +
> >> +       rlen =3D len - padlen;
> >> +       if (rlen) {
> >> +               skb_pull(skb, rlen);
> >> +               memmove(skb_network_header(skb) + rlen, skb_network_he=
ader(skb),
> >> +                       start);
> >> +               skb_postpull_rcsum(skb, skb_network_header(skb), rlen)=
;
> >> +
> >> +               skb_reset_network_header(skb);
> >> +               skb_set_transport_header(skb, sizeof(struct ipv6hdr));
> >> +
> >> +               pl_len =3D be16_to_cpu(ipv6_hdr(skb)->payload_len) - r=
len;
> >> +               ipv6_hdr(skb)->payload_len =3D cpu_to_be16(pl_len);
> >> +
> >> +               skb_transport_header(skb)[1] -=3D rlen >> 3;
> >> +               end -=3D rlen;
> >> +       }
> >> +
> >> +       if (padlen) {
> >> +               off =3D end - padlen;
> >> +               h =3D skb_network_header(skb);
> >> +
> >> +               if (padlen =3D=3D 1) {
> >> +                       h[off] =3D IPV6_TLV_PAD1;
> >> +               } else {
> >> +                       padlen -=3D 2;
> >> +
> >> +                       h[off] =3D IPV6_TLV_PADN;
> >> +                       h[off + 1] =3D padlen;
> >> +                       memset(&h[off + 2], 0, padlen);
> >> +               }
> >> +       }
> >> +
> >> +       return end;
> >> +}
> >> +
> >>  /* Parse tlv encoded option header (hop-by-hop or destination) */
> >>
> >>  static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >>                           struct sk_buff *skb,
> >> -                         int max_count)
> >> +                         int max_count,
> >> +                         bool removable)
> >>  {
> >>         int len =3D (skb_transport_header(skb)[1] + 1) << 3;
> >> -       const unsigned char *nh =3D skb_network_header(skb);
> >> +       unsigned char *nh =3D skb_network_header(skb);
> >>         int off =3D skb_network_header_len(skb);
> >>         const struct tlvtype_proc *curr;
> >>         bool disallow_unknowns =3D false;
> >> +       int off_remove =3D 0;
> >>         int tlv_count =3D 0;
> >>         int padlen =3D 0;
> >> +       int ret;
> >>
> >>         if (unlikely(max_count < 0)) {
> >>                 disallow_unknowns =3D true;
> >> @@ -173,12 +231,14 @@ static bool ip6_parse_tlv(const struct tlvtype_p=
roc
> >> *procs,
> >>                         if (tlv_count > max_count)
> >>                                 goto bad;
> >>
> >> +                       ret =3D -1;
> >>                         for (curr =3D procs; curr->type >=3D 0; curr++=
) {
> >>                                 if (curr->type =3D=3D nh[off]) {
> >>                                         /* type specific length/alignm=
ent
> >>                                            checks will be performed in=
 the
> >>                                            func(). */
> >> -                                       if (curr->func(skb, off) =3D=
=3D false)
> >> +                                       ret =3D curr->func(skb, off);
> >> +                                       if (ret =3D=3D TLV_REJECT)
> >>                                                 return false;
> >>                                         break;
> >>                                 }
> >> @@ -187,6 +247,17 @@ static bool ip6_parse_tlv(const struct tlvtype_pr=
oc *procs,
> >>                             !ip6_tlvopt_unknown(skb, off, disallow_unk=
nowns))
> >>                                 return false;
> >>
> >> +                       if (removable) {
> >> +                               if (ret =3D=3D TLV_REMOVE) {
> >> +                                       if (!off_remove)
> >> +                                               off_remove =3D off - p=
adlen;
> >> +                               } else if (off_remove) {
> >> +                                       off =3D remove_tlv(off_remove,=
 off, skb);
> >> +                                       nh =3D skb_network_header(skb)=
;
> >> +                                       off_remove =3D 0;
> >> +                               }
> >> +                       }
> >> +
> >>                         padlen =3D 0;
> >>                         break;
> >>                 }
> >> @@ -194,8 +265,13 @@ static bool ip6_parse_tlv(const struct tlvtype_pr=
oc *procs,
> >>                 len -=3D optlen;
> >>         }
> >>
> >> -       if (len =3D=3D 0)
> >> +       if (len =3D=3D 0) {
> >> +               /* Don't forget last TLV if it must be removed */
> >> +               if (off_remove)
> >> +                       remove_tlv(off_remove, off, skb);
> >> +
> >>                 return true;
> >> +       }
> >>  bad:
> >>         kfree_skb(skb);
> >>         return false;
> >> @@ -206,7 +282,7 @@ static bool ip6_parse_tlv(const struct tlvtype_pro=
c *procs,
> >>   *****************************/
> >>
> >>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> >> -static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >> +static int ipv6_dest_hao(struct sk_buff *skb, int optoff)
> >>  {
> >>         struct ipv6_destopt_hao *hao;
> >>         struct inet6_skb_parm *opt =3D IP6CB(skb);
> >> @@ -257,11 +333,11 @@ static bool ipv6_dest_hao(struct sk_buff *skb, i=
nt optoff)
> >>         if (skb->tstamp =3D=3D 0)
> >>                 __net_timestamp(skb);
> >>
> >> -       return true;
> >> +       return TLV_ACCEPT;
> >>
> >>   discard:
> >>         kfree_skb(skb);
> >> -       return false;
> >> +       return TLV_REJECT;
> >>  }
> >>  #endif
> >>
> >> @@ -306,7 +382,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
> >>  #endif
> >>
> >>         if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
> >> -                         init_net.ipv6.sysctl.max_dst_opts_cnt)) {
> >> +                         init_net.ipv6.sysctl.max_dst_opts_cnt,
> >> +                         false)) {
> >>                 skb->transport_header +=3D extlen;
> >>                 opt =3D IP6CB(skb);
> >>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> >> @@ -918,24 +995,24 @@ static inline struct net *ipv6_skb_net(struct sk=
_buff
> >> *skb)
> >>
> >>  /* Router Alert as of RFC 2711 */
> >>
> >> -static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >> +static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >>  {
> >>         const unsigned char *nh =3D skb_network_header(skb);
> >>
> >>         if (nh[optoff + 1] =3D=3D 2) {
> >>                 IP6CB(skb)->flags |=3D IP6SKB_ROUTERALERT;
> >>                 memcpy(&IP6CB(skb)->ra, nh + optoff + 2, sizeof(IP6CB(=
skb)->ra));
> >> -               return true;
> >> +               return TLV_ACCEPT;
> >>         }
> >>         net_dbg_ratelimited("ipv6_hop_ra: wrong RA length %d\n",
> >>                             nh[optoff + 1]);
> >>         kfree_skb(skb);
> >> -       return false;
> >> +       return TLV_REJECT;
> >>  }
> >>
> >>  /* Jumbo payload */
> >>
> >> -static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >> +static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >>  {
> >>         const unsigned char *nh =3D skb_network_header(skb);
> >>         struct inet6_dev *idev =3D __in6_dev_get_safely(skb->dev);
> >> @@ -953,12 +1030,12 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb,=
 int
> >> optoff)
> >>         if (pkt_len <=3D IPV6_MAXPLEN) {
> >>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> >>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
> >> -               return false;
> >> +               return TLV_REJECT;
> >>         }
> >>         if (ipv6_hdr(skb)->payload_len) {
> >>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> >>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
> >> -               return false;
> >> +               return TLV_REJECT;
> >>         }
> >>
> >>         if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
> >> @@ -970,16 +1047,16 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb,=
 int
> >> optoff)
> >>                 goto drop;
> >>
> >>         IP6CB(skb)->flags |=3D IP6SKB_JUMBOGRAM;
> >> -       return true;
> >> +       return TLV_ACCEPT;
> >>
> >>  drop:
> >>         kfree_skb(skb);
> >> -       return false;
> >> +       return TLV_REJECT;
> >>  }
> >>
> >>  /* CALIPSO RFC 5570 */
> >>
> >> -static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> >> +static int ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> >>  {
> >>         const unsigned char *nh =3D skb_network_header(skb);
> >>
> >> @@ -992,11 +1069,11 @@ static bool ipv6_hop_calipso(struct sk_buff *sk=
b, int
> >> optoff)
> >>         if (!calipso_validate(skb, nh + optoff))
> >>                 goto drop;
> >>
> >> -       return true;
> >> +       return TLV_ACCEPT;
> >>
> >>  drop:
> >>         kfree_skb(skb);
> >> -       return false;
> >> +       return TLV_REJECT;
> >>  }
> >>
> >>  static const struct tlvtype_proc tlvprochopopt_lst[] =3D {
> >> @@ -1041,7 +1118,12 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
> >>
> >>         opt->flags |=3D IP6SKB_HOPBYHOP;
> >>         if (ip6_parse_tlv(tlvprochopopt_lst, skb,
> >> -                         init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
> >> +                         init_net.ipv6.sysctl.max_hbh_opts_cnt,
> >> +                         true)) {
> >> +               /* we need to refresh the length in case
> >> +                * at least one TLV was removed
> >> +                */
> >> +               extlen =3D (skb_transport_header(skb)[1] + 1) << 3;
> >>                 skb->transport_header +=3D extlen;
> >>                 opt =3D IP6CB(skb);
> >>                 opt->nhoff =3D sizeof(struct ipv6hdr);
> >> --
> >> 2.17.1
