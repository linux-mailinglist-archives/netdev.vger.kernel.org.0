Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66229670B49
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjAQWJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjAQWII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:08:08 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A373A861
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:33:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k13so2157972plg.0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mlmrr+LmPgwagRvDw6ZkuRXoRGz9oMUsyD3oXbejChs=;
        b=MRJjKilPfgr+ZPCumKxddcm7V4VVsiT6mpCnCuE8nb3e77vnYMwr9KdrpI+NQ8fpUo
         TmxpbXCur92dnSiGnfayjrL/bbf/Dc5EQXEl7fhe27DtOrtS+1abOe6VzsYw3ukTjH1b
         8vFdik/6Aa1zPat9RAKlH/zQ0twaRskKejqq6M2Fy9TF9a1CaETxYppOeCiYwfHxeUH3
         lNzPjrwu6gjPgpUQ/sSZDDKVk6s2OKHzdOEVslwYLQ73GUmH26Lq4LBCfVsEm7oJCpBY
         7fBGQEjNx8QgLJeWoQYbfBixOobxfseV6VmMRuFn7x17mhfhBl2BL3zNttyU28wj+3Ik
         wm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mlmrr+LmPgwagRvDw6ZkuRXoRGz9oMUsyD3oXbejChs=;
        b=ouJp0hfrIJ8iBwVBJ0HNu23N6zhU6gaD66DosxSLnyfgo2N8rB1f2sZ7adTxwfanDj
         bGbavJhMykUDwDfmMH+rjy60PjIRzq3PAWEZGiCxq9QL+eXLr702xLjy8400YvGu9yGB
         lFoEBonP8grSdrE/7FyGasCHeP7ocnUZUnd6tVJPCxHKMiBGY1PCqFG7x/PTCJOWpvxt
         CLNu6aEaRUlsh2roFdIP6a52g2lYN7UnFbwUEdgyxyY3rlXRJZmLQ1kPw3Qoi/Va+nT7
         zdsvlwsWV1JHOX51w/k4K/DxSCKs9/wMg54GGzFrrHVQOKBwBmFTI/hbqFnIS0ywpliG
         tdVA==
X-Gm-Message-State: AFqh2kp7KXVWzy5PNU2d5PwKb+HUy5tX+DJ7Ukj0YCkTtyi3tWBey6N+
        GeJOr1QprVk1OKUluY4gwxMF1BJQnTcviw1/qy1Sow==
X-Google-Smtp-Source: AMrXdXssDknjwW3ny/3IGkPjagEOf8+iy4LKiD9WQEExaRvgg4DU7xHizVGuIhVNaY0ggX/nRj2yT7xUafHNfzjZUvg=
X-Received: by 2002:a17:902:b181:b0:193:20ba:e04d with SMTP id
 s1-20020a170902b18100b0019320bae04dmr346111plr.93.1673987594634; Tue, 17 Jan
 2023 12:33:14 -0800 (PST)
MIME-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com> <20230112003230.3779451-11-sdf@google.com>
 <a5ce7ac4-7901-6146-2c2a-5b4958c14e11@redhat.com>
In-Reply-To: <a5ce7ac4-7901-6146-2c2a-5b4958c14e11@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 17 Jan 2023 12:33:02 -0800
Message-ID: <CAKH8qBszqz7Qi=E0=gsF0KDHqw4+QEWYyQvqRyS2_E_UsjNKvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 10/17] veth: Support RX XDP metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 8:21 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 12/01/2023 01.32, Stanislav Fomichev wrote:
> > The goal is to enable end-to-end testing of the metadata for AF_XDP.
>
> For me the goal with veth goes beyond *testing*.
>
> This patch ignores the xdp_frame case.  I'm not blocking this patch, but
> I'm saying we need to make sure there is a way forward for accessing
> XDP-hints when handling redirected xdp_frame's.

Sure, let's work towards getting that other part addressed!

> I have two use-cases we should cover (as future work).
>
> (#1) We have customers that want to redirect from physical NIC hardware
> into containers, and then have the veth XDP-prog (selectively) redirect
> into an AF_XDP socket (when matching fastpath packets).  Here they
> (minimum) want access to the XDP hint info on HW checksum.
>
> (#2) Both veth and cpumap can create SKBs based on xdp_frame's.  Here it
> is essential to get HW checksum and HW hash when creating these SKBs
> (else netstack have to do expensive csum calc and parsing in
> flow-dissector).

From my PoW, I'd probably have to look into the TX side first (tx
timestamp) before looking into xdp->skb path. So if somebody on your
side has cycles, feel free to drive this effort. I'm happy to provide
reviews/comments/etc. I think we've discussed in the past that this
will most likely look like another set of "export" kfuncs?

We can start with extending new
Documentation/networking/xdp-rx-metadata.rst with a high-level design.

> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
> >   1 file changed, 31 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 70f50602287a..ba3e05832843 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -118,6 +118,7 @@ static struct {
> >
> >   struct veth_xdp_buff {
> >       struct xdp_buff xdp;
> > +     struct sk_buff *skb;
> >   };
> >
> >   static int veth_get_link_ksettings(struct net_device *dev,
> > @@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
> >
> >               xdp_convert_frame_to_buff(frame, xdp);
> >               xdp->rxq = &rq->xdp_rxq;
> > +             vxbuf.skb = NULL;
> >
> >               act = bpf_prog_run_xdp(xdp_prog, xdp);
> >
> > @@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> >       __skb_push(skb, skb->data - skb_mac_header(skb));
> >       if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
> >               goto drop;
> > +     vxbuf.skb = skb;
> >
> >       orig_data = xdp->data;
> >       orig_data_end = xdp->data_end;
> > @@ -1602,6 +1605,28 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> >       }
> >   }
> >
> > +static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> > +{
> > +     struct veth_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     if (!_ctx->skb)
> > +             return -EOPNOTSUPP;
> > +
> > +     *timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
>
> The SKB stores this skb_hwtstamps() in skb_shared_info memory area.
> This memory area is actually also available to xdp_frames.  Thus, we
> could store the HW rx_timestamp in same location for redirected
> xdp_frames.  This could make code path sharing possible between SKB vs
> xdp_frame in veth.
>
> This would also make it fast to "transfer" HW rx_timestamp when creating
> an SKB from an xdp_frame, as data is already written in the correct place.
>
> Performance wise the down-side is that skb_shared_info memory area is in
> a separate cacheline.  Thus, when no HW rx_timestamp is available, then
> it is very expensive for a veth XDP bpf-prog to access this, just to get
> a zero back.  Having an xdp_frame->flags bit that knows if HW
> rx_timestamp have been stored, can mitigate this.

That's one way to do it; although I'm not sure about the cases which
don't use xdp_frame and use stack-allocated xdp_buff.

> > +     return 0;
> > +}
> > +
> > +static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
> > +{
> > +     struct veth_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     if (!_ctx->skb)
> > +             return -EOPNOTSUPP;
>
> For xdp_frame case, I'm considering simply storing the u32 RX-hash in
> struct xdp_frame.  This makes it easy to extract for xdp_frame to SKB
> create use-case.
>
> As have been mentioned before, the SKB also requires knowing the RSS
> hash-type.  This HW hash-type actually contains a lot of information,
> that today is lost when reduced to the SKB hash-type.  Due to
> standardization from Microsoft, most HW provide info on (L3) IPv4 or
> IPv6, and on (L4) TCP or UDP (and often SCTP).  Often hardware
> descriptor also provide info on the header length.  Future work in this
> area is exciting as we can speedup parsing of packets in XDP, if we can
> get are more detailed HW info on hash "packet-type".

Something like the version we've discussed a while back [0]?
Seems workable overall if we remove it from the UAPI? (not everyone
was happy about UAPI parts IIRC)

0: https://lore.kernel.org/bpf/20221115030210.3159213-7-sdf@google.com/


> > +
> > +     *hash = skb_get_hash(_ctx->skb); > +    return 0;
> > +}
> > +
>
> --Jesper
>
