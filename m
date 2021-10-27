Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1E43BF2A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 03:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhJ0BqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 21:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhJ0BqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 21:46:08 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5E7C061570;
        Tue, 26 Oct 2021 18:43:43 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id kd16so834640qvb.0;
        Tue, 26 Oct 2021 18:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LJqS8zky7pcMbUa92VXQE1e4F/KCHrhH+dmA5eIbDw=;
        b=Spt2jzK0txE6TKglycyhopMhk7/Qs8AejfSjBab5DxG7mnLhZ31UyxEXNvk1wFHraj
         kYzExGTJtV/vgKU1aNpPxrUHN8OGuFQ3rWPFz5lElDm8k3b0hd2m8/gN2hbyJfIdg9X1
         zP+DzjQyWYq8UMzx3cUMSvZKRH1Z/9M1nnlexaqWV2dXbzVAle53OvqskgnsF/cWsXJ0
         6+7SjorfK+9+u/0AJS/7op54mV0GVycWs8Iw3hkPDhjmpaqNA3EEblpIztvAQPOz58gZ
         r/EykbTqZqpq8cMY/JjsOPJpU6R8ywr/CaF8viTwjNdZ4JCeSwDqwcCoZZewmNjskGnf
         LaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LJqS8zky7pcMbUa92VXQE1e4F/KCHrhH+dmA5eIbDw=;
        b=ifLz8to5JZ7tCuduVCqRqe9UMTFm0TTW1Avlim9vzYiOiIDCnMzHqJ6BMdCEpy15BT
         T85sIXBt4V5tdWqY3zq0bvn32cc/6zz5zatfxj4xyqUe2i7PAVed4ORHl2EPSFItS6ds
         KAaNqvLBnPytBqUz9GIoNwFpoZQdiZXFH5kK0w4PhhdGVTqRF1ZkTrTA4C6Rigjue5/s
         w58g0BwSWV9pOS4+I75PPlCabWo/KT6jzbV0O/mQTbUr8NQZBNlX4aslqWeWNSw0mvM5
         HcUSbsiftb43Bjyn5r0PKDWwZ1Xvg9B+K2qP4r9dHi9S/9pKAcs/cFgbbvSA/jr9/5p+
         Q6dA==
X-Gm-Message-State: AOAM531UM//ahtMTe9qVzHcqq860Sy/D/UHHl4HTjXbmnJ0Pk1jzxxr8
        LkgD/ed3ICDrd2LasLR54qUulvplp6N4K/7X62NGs9T+pGUVq8kJ
X-Google-Smtp-Source: ABdhPJxmDg1USLsLZb2rgmX6eNh0CEG8+NnW52Q4brfVwVJz7fK/JAf60OYtssuk0++Jo3qg8OWPPWXB0Lb4Aws/ORA=
X-Received: by 2002:a05:6214:2308:: with SMTP id gc8mr26076038qvb.31.1635299022709;
 Tue, 26 Oct 2021 18:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211025115910.2595-1-xingwu.yang@gmail.com> <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg>
 <CA+7U5JsSuwqP7eHj1tMHfsb+EemwrhZEJ2b944LFWTroxAnQRQ@mail.gmail.com>
 <1190ef60-3ad9-119e-5336-1c62522aec81@ssi.bg> <CA+7U5JvvsNejgOifAwDdjddkLHUL30JPXSaDBTwysSL7dhphuA@mail.gmail.com>
In-Reply-To: <CA+7U5JvvsNejgOifAwDdjddkLHUL30JPXSaDBTwysSL7dhphuA@mail.gmail.com>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Wed, 27 Oct 2021 09:43:31 +0800
Message-ID: <CA+7U5Jta_g2vCXiwScVVwLZppWp51TDOB7LxUxeundkPxNZYnA@mail.gmail.com>
Subject: Re: [PATCH] ipvs: Fix reuse connection if RS weight is 0
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, fw@strlen.de,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, corbet@lwn.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julian

what we want is if RS weight is 0, then no new connections should be
served even if conn_reuse_mode is 0, just as commit dc7b3eb900aa
("ipvs: Fix reuse connection if real server is
dead") trying to do

Pls let me know if there are any other issues of concern

On Tue, Oct 26, 2021 at 2:13 PM yangxingwu <xingwu.yang@gmail.com> wrote:
>
> thanks Julian
>
> yes, I know that the one-second delay issue has been fixed by commit
> f0a5e4d7a594e0fe237d3dfafb069bb82f80f42f if we set conn_reuse_mode to
> 1
>
> BUT  it's still NOT what we expected with sysctl settings
> (conn_reuse_mode == 0 && expire_nodest_conn == 1).
>
> We run kubernetes in extremely diverse environments and this issue
> happens a lot.
>
> On Tue, Oct 26, 2021 at 1:44 PM Julian Anastasov <ja@ssi.bg> wrote:
> >
> >
> >         Hello,
> >
> > On Tue, 26 Oct 2021, yangxingwu wrote:
> >
> > > thanks julian
> > >
> > > What happens in this situation is that if we set the wait of the
> > > realserver to 0 and do NOT remove the weight zero realserver with
> > > sysctl settings (conn_reuse_mode == 0 && expire_nodest_conn == 1), and
> > > the client reuses its source ports, the kernel will constantly
> > > reuse connections and send the traffic to the weight 0 realserver.
> >
> >         Yes, this is expected when conn_reuse_mode=0.
> >
> > > you may check the details from
> > > https://github.com/kubernetes/kubernetes/issues/81775
> >
> >         What happens if you try conn_reuse_mode=1? The
> > one-second delay in previous kernels should be corrected with
> >
> > commit f0a5e4d7a594e0fe237d3dfafb069bb82f80f42f
> > Date:   Wed Jul 1 18:17:19 2020 +0300
> >
> >     ipvs: allow connection reuse for unconfirmed conntrack
> >
> > > On Tue, Oct 26, 2021 at 2:12 AM Julian Anastasov <ja@ssi.bg> wrote:
> > > >
> > > > On Mon, 25 Oct 2021, yangxingwu wrote:
> > > >
> > > > > Since commit dc7b3eb900aa ("ipvs: Fix reuse connection if real server is
> > > > > dead"), new connections to dead servers are redistributed immediately to
> > > > > new servers.
> > > > >
> > > > > Then commit d752c3645717 ("ipvs: allow rescheduling of new connections when
> > > > > port reuse is detected") disable expire_nodest_conn if conn_reuse_mode is
> > > > > 0. And new connection may be distributed to a real server with weight 0.
> > > >
> > > >         Your change does not look correct to me. At the time
> > > > expire_nodest_conn was created, it was not checked when
> > > > weight is 0. At different places different terms are used
> > > > but in short, we have two independent states for real server:
> > > >
> > > > - inhibited: weight=0 and no new connections should be served,
> > > >         packets for existing connections can be routed to server
> > > >         if it is still available and packets are not dropped
> > > >         by expire_nodest_conn.
> > > >         The new feature is that port reuse detection can
> > > >         redirect the new TCP connection into a new IPVS conn and
> > > >         to expire the existing cp/ct.
> > > >
> > > > - unavailable (!IP_VS_DEST_F_AVAILABLE): server is removed,
> > > >         can be temporary, drop traffic for existing connections
> > > >         but on expire_nodest_conn we can select different server
> > > >
> > > >         The new conn_reuse_mode flag allows port reuse to
> > > > be detected. Only then expire_nodest_conn has the
> > > > opportunity with commit dc7b3eb900aa to check weight=0
> > > > and to consider the old traffic as finished. If a new
> > > > server is selected, any retrans from previous connection
> > > > would be considered as part from the new connection. It
> > > > is a rapid way to switch server without checking with
> > > > is_new_conn_expected() because we can not have many
> > > > conns/conntracks to different servers.
> >
> > Regards
> >
> > --
> > Julian Anastasov <ja@ssi.bg>
