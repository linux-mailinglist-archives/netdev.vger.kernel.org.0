Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757F7203BB5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgFVQAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729295AbgFVQAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:00:06 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7D0C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:00:05 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id e15so231546vsc.7
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CCl2UCA4UwdBHm1DKm7LjzXwWLZ58zQxP34vY/zNJa0=;
        b=TnDH1ETTeg+hMM8CnRHsfjUAD7sLXQVzAkahOitHYUpcTCHnIlBban0GcFqf4SS22x
         1yrWTiC7wI8KRm0CCaDcWLMB1ystwiU99+m7KEC2yTK8Jxdsjlrzdoww/0z4VFYdN9Kk
         eUg8meddmuZUbw3QxUcxmOK+JAfpgMgdeiTWCQ9IQg572IHFASLt8c5IKYwB9N5sSoNp
         eGFzYWJ5Rqp3i2dFh3zlM5g9EkKlwNEpPxq7VIh9um3dt/WuLQEnG5wLtK9cH9QPbxpi
         rWk7d3subUyEf4sEWed+Hhw9rxAXz8JLnPbpsRlH9vsmZNp3Kfk1W29YZ1MUJYbeu1oo
         YOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CCl2UCA4UwdBHm1DKm7LjzXwWLZ58zQxP34vY/zNJa0=;
        b=pjz3HFT0RtP+/TCwdCfNc9shRFTVgwH+v0zZYouCBLD11LcS+jc3XsB+PdQGgtQ6Kw
         EXSO5FPmiv54TvuM8vFxUlZ3/tMqdi6N4vgm8wdXfTNFBXAY6sJro2tySNsvUlTI0yn4
         GodfTOtXbakkB6fke1ljivBKOXWSiP1x88C4zM4pF7vIZ+jyAhjUBIEpGUE6mSyRW3d+
         660VWcHBaotT1IZVSJyY/jtP7gsUjxduPRmzkaLliKaS4IUNQZo/Cf5ZK+gOHEllANsa
         wriDPy9O2pu6rT8Y8odQarbWOcnAbmgQLLkMG4AqGNrupcwtiG8a3CwiWQvFE4Zvwohb
         k34A==
X-Gm-Message-State: AOAM530yxgHtT9D+Xmk0ki53OsnNL+ubLTvOj0nBdIxhBgR67QRC3sle
        ftFELf7l+FtU+/15HJop4N7Hd81LqwMEmTcHFR7RNw==
X-Google-Smtp-Source: ABdhPJyJnqJZu9qNx60vlaciFWWKuWu4Nu1EwKbrU/Ll9whoE+i0M5/Xk4NVdLu2FshPrpIK+HhX+YLt2b5J8Tb3G8o=
X-Received: by 2002:a67:684f:: with SMTP id d76mr16579934vsc.66.1592841602368;
 Mon, 22 Jun 2020 09:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <74266291a0aba929919f71ff3dbd1c36392bb4c4.1592567032.git.lorenzo@kernel.org>
 <CAOrHB_B2GO51hRy_kj3kdJKrFURFbKubhGvanLKCRHDc9DKeyg@mail.gmail.com> <20200622120252.GC14425@localhost.localdomain>
In-Reply-To: <20200622120252.GC14425@localhost.localdomain>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Mon, 22 Jun 2020 08:59:51 -0700
Message-ID: <CAOrHB_Dam4u4_AMyj2kbXc48pjP5ePDgMqy0Ghj5kUbS+OrGXw@mail.gmail.com>
Subject: Re: [PATCH net] openvswitch: take into account de-fragmentation in execute_check_pkt_len
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Numan Siddique <nusiddiq@redhat.com>,
        Greg Rose <gvrose8192@gmail.com>, lorenzo.bianconi@redhat.com,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:02 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Fri, Jun 19, 2020 at 4:48 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > ovs connection tracking module performs de-fragmentation on incoming
> > > fragmented traffic. Take info account if traffic has been de-fragmented
> > > in execute_check_pkt_len action otherwise we will perform the wrong
> > > nested action considering the original packet size. This issue typically
> > > occurs if ovs-vswitchd adds a rule in the pipeline that requires connection
> > > tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.
> > >
> > > Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  net/openvswitch/actions.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > index fc0efd8833c8..9f4dd64e53bb 100644
> > > --- a/net/openvswitch/actions.c
> > > +++ b/net/openvswitch/actions.c
> > > @@ -1169,9 +1169,10 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
> > >                                  struct sw_flow_key *key,
> > >                                  const struct nlattr *attr, bool last)
> > >  {
> > > +       struct ovs_skb_cb *ovs_cb = OVS_CB(skb);
> > >         const struct nlattr *actions, *cpl_arg;
> > >         const struct check_pkt_len_arg *arg;
> > > -       int rem = nla_len(attr);
> > > +       int len, rem = nla_len(attr);
> > >         bool clone_flow_key;
> > >
> > >         /* The first netlink attribute in 'attr' is always
> > > @@ -1180,7 +1181,8 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
> > >         cpl_arg = nla_data(attr);
> > >         arg = nla_data(cpl_arg);
> > >
> > > -       if (skb->len <= arg->pkt_len) {
> > > +       len = ovs_cb->mru ? ovs_cb->mru : skb->len;
> > > +       if (len <= arg->pkt_len) {
> >
> > We could also check for the segmented packet and use  segment length
> > for this check.
>
> Hi Pravin,
>
> thx for review.
> By 'segmented packet' and 'segment length', do you mean 'fragment' and
> 'fragment length'?

I am actually talking about GSO packets.

Thanks.

> If so I guess we can't retrieve the original fragment length if we exec
> OVS_ACTION_ATTR_CT before OVS_ACTION_ATTR_CHECK_PKT_LEN (e.g if we have a
> stateful ACL in the ingress pipeline) since handle_fragments() will reconstruct
> the whole IP datagram and it will store frag_max_size in OVS_CB(skb)->mru.
> Am I missing something?
>
> Regards,
> Lorenzo
>
