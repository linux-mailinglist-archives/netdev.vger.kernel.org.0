Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A28B471776
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 02:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhLLAsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 19:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhLLAsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 19:48:08 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541EEC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 16:48:08 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id d10so30035406ybe.3
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 16:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n16xBoWvAX9KIRlmXdieCZbcOaL7kNYqHvDhDSk8yZA=;
        b=GfyBqHaVwFYWx09uG01J1yoj9TSacprEoOiltresphBRERLQUdgzaw9GA9KD7nAVl5
         gXU5Ls2qKt/P33FQU2GStJn7ptiloPMbzMMwj81CfUfpUs1PkKdxnvwg7plVp8r9G64a
         /f5iecfCpEJfUKI39I3d+xGhasUK5313K9nkP899ZAXa6ySjjNUqCyv29qgHPLFEGpo+
         yod24JwJNuQCDNov8GG2uxRkMWZdmOmHX9LkR2XSUXGcXoygaJaz2UoX+IL/NdBKdlKC
         F+xCgOclFTUcZkx8yxuRCEmISi49L0u8wgDiuLyo9xh2WHWsHCuulNXFHNytS1dcXMVy
         cOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n16xBoWvAX9KIRlmXdieCZbcOaL7kNYqHvDhDSk8yZA=;
        b=rFF9KAWhRxwM+Mn0XdxGTlYn4a6jn30TDLSeUB8LpJfqv/HaN9Hwc+oRtN7r/Ipt9c
         cqWnyn74vEtU8La3/k/6L3LXjqc5HMrWYhYix0uM8Yh53keIYgcQHG9uBG5WIDv999hR
         SzbTKWoYhPzMZnhkOP0s09CnKz6G8vg9hKrlrDMDgiV26b8pqebb5swgmH8gmDZ+k0a/
         bjmjvM1EH8jdBSyKJtLytd9BM5Y829VokNiGDKgR5C40v2mRgWTdHW0PI09SzYHt5Dyp
         dPERL1twgeMvZ/U/hI/ikg5pLfxGja8cjA1jcjdKPeVUZZV3PXZMLZ5YSrbX1bixXEar
         JiEQ==
X-Gm-Message-State: AOAM531RL5zz9j+8iz9ZXNGyxB+6+gbSQTystoM/6AFAnPpeFVz6djns
        3PME5gkxJBaeFRHEiQ/l2E+TPNP6TOJ1Ef0uu04=
X-Google-Smtp-Source: ABdhPJz4+HkSmwbgY7V9M4h/StdnctOkzbRFDKom9lMjVlvE5g+3yToRIwS46D2RSInIjYTv1eEtREWLNyt6yEzlCUs=
X-Received: by 2002:a05:6902:70a:: with SMTP id k10mr3374643ybt.120.1639270087423;
 Sat, 11 Dec 2021 16:48:07 -0800 (PST)
MIME-Version: 1.0
References: <20211209075734.10199-1-paulb@nvidia.com> <20211209075734.10199-3-paulb@nvidia.com>
 <20211210205216.1ec35b39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210205216.1ec35b39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Dec 2021 16:47:56 -0800
Message-ID: <CAM_iQpWtwwj1pMWQbPTV6Rctd_0hcjeEyXywSj-h=94p3MZUiw@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net/sched: flow_dissector: Fix matching on
 zone id for invalid conns
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 8:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 9 Dec 2021 09:57:33 +0200 Paul Blakey wrote:
> > @@ -238,10 +239,12 @@ void
> >  skb_flow_dissect_ct(const struct sk_buff *skb,
> >                   struct flow_dissector *flow_dissector,
> >                   void *target_container, u16 *ctinfo_map,
> > -                 size_t mapsize, bool post_ct)
> > +                 size_t mapsize)
> >  {
> >  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> > +     bool post_ct = tc_skb_cb(skb)->post_ct;
> >       struct flow_dissector_key_ct *key;
> > +     u16 zone = tc_skb_cb(skb)->zone;
> >       enum ip_conntrack_info ctinfo;
> >       struct nf_conn_labels *cl;
> >       struct nf_conn *ct;
> > @@ -260,6 +263,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
> >       if (!ct) {
> >               key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
> >                               TCA_FLOWER_KEY_CT_FLAGS_INVALID;
> > +             key->ct_zone = zone;
> >               return;
> >       }
> >
>
> Why is flow dissector expecting skb cb to be TC now?
> Please keep the appropriate abstractions intact.

Probably because only fl_classify() calls it, but I agree with you
on this point, this function is supposed to be TC independent.

Thanks.
