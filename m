Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90FB623888
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiKJBCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKJBCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:02:12 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B545FF6
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 17:02:12 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id d123so199093iof.7
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 17:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1CUpF8sPjSKa1qNYh255GV9ZgKn7MltcaT4JcHEFhGY=;
        b=MNdu2pMdm9Q/07uvCc/zUIAyVQxalRVb7Hlr94A0mceH+Li1TWOT/WBQNzhUBXY6CY
         s+KNuB9k1qAkQC6XzPqX2+NXByTm72czY3m2UbOt9yqRBmFCYC5Y1hbEMWbg+ZvttHZT
         jIPsSRcstPdI8PT0q1NSd4oK1ACUzG93mJ+qSVvSKpX37nonJE3EY7MIExhw9FqKDc+d
         +aXbpxtqVnpnDmQRN5W1wEMjDjJn69ttp35I1tTjcLo9G0lLmdgOhE0lXC7TJfu5HAK/
         AnDWp5DJzP76Y0pSK0ABJX1VU4Ie2IzW1n1PZkLJlmNRow+mKg1xjpDwV03HfnOrcTBp
         oy1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CUpF8sPjSKa1qNYh255GV9ZgKn7MltcaT4JcHEFhGY=;
        b=4SRRRWwkAcisV8UxbM7MdHYWBwQadvFGt6v4lOtyV/vmEW9UQ5sQpeAoB8exQLvOkj
         yOPbE/2ERbHhDUtP0SccExfflmVZXp4KDfw69WXXV5Ct6nWx8mmlUyrhhHYsyA2A3Q4D
         HdnR/hRXJ7Ss+WVfycY5UJ3xn+sV6OQ4hqiGO1LzEmJlzZgvR6uvMZSxHI8apOISNrcl
         a6E1jbDdRh+SayLYcYZUTr/g7rUh1jvwJsUaDqGz8y5GC148XgPCPWafpNH1GoZ5HI+g
         cV3V4wadtliibXm6TT9yqX/obIdhup6gS1caiaBQSTARXWGme17RBugeq/ICiCli0q8Y
         4ooA==
X-Gm-Message-State: ANoB5pkIfbIQk4ynpjzSQitdS+3U8zeEB4me6dmbp8Ebtn6XEaSmtS+A
        XdhjzT6gWvdmSod5Fk1ICvY84GYZM+1gafu44abySQ==
X-Google-Smtp-Source: AA0mqf5iU++nhS9XQpgQ+bbgvvR9S0yg/vQEYa81M7IXz1j3U6aRC34YmQ61ZR1XSRw9bTVDQWqMV96gLsvOhOr1jVw=
X-Received: by 2002:a02:ca49:0:b0:375:c385:d846 with SMTP id
 i9-20020a02ca49000000b00375c385d846mr1901422jal.84.1668042131419; Wed, 09 Nov
 2022 17:02:11 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-5-sdf@google.com>
 <636c4514917fa_13c168208d0@john.notmuch>
In-Reply-To: <636c4514917fa_13c168208d0@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 9 Nov 2022 17:02:00 -0800
Message-ID: <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for xdp
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 4:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > xskxceiver conveniently setups up veth pairs so it seems logical
> > to use veth as an example for some of the metadata handling.
> >
> > We timestamp skb right when we "receive" it, store its
> > pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
> > reach it from the BPF program.
> >
> > This largely follows the idea of "store some queue context in
> > the xdp_buff/xdp_frame so the metadata can be reached out
> > from the BPF program".
> >
>
> [...]
>
> >       orig_data = xdp->data;
> >       orig_data_end = xdp->data_end;
> > +     vxbuf.skb = skb;
> >
> >       act = bpf_prog_run_xdp(xdp_prog, xdp);
> >
> > @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> >                       struct sk_buff *skb = ptr;
> >
> >                       stats->xdp_bytes += skb->len;
> > +                     __net_timestamp(skb);
>
> Just getting to reviewing in depth a bit more. But we hit veth with lots of
> packets in some configurations I don't think we want to add a __net_timestamp
> here when vast majority of use cases will have no need for timestamp on veth
> device. I didn't do a benchmark but its not free.
>
> If there is a real use case for timestamping on veth we could do it through
> a XDP program directly? Basically fallback for devices without hw timestamps.
> Anyways I need the helper to support hardware without time stamping.
>
> Not sure if this was just part of the RFC to explore BPF programs or not.

Initially I've done it mostly so I can have selftests on top of veth
driver, but I'd still prefer to keep it to have working tests.
Any way I can make it configurable? Is there some ethtool "enable tx
timestamping" option I can reuse?

> >                       skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> >                       if (skb) {
> >                               if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
