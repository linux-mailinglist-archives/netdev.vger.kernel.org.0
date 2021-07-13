Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD63C7278
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhGMOnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhGMOnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:43:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD076C0613DD;
        Tue, 13 Jul 2021 07:40:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hc15so3384931ejc.4;
        Tue, 13 Jul 2021 07:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Go+slvtxWKdfE07JhWqm6afFVlakzlCghY+rCteiXNk=;
        b=RLmbrCxqrYioWCRlKRjyX8rC/XXm/wSoiyzmlI3C5kp8hqumfpH0t7HU70vxm3MMbc
         bYVIguzS7/JmF5KZJU49LL/wegnfQGjHp6zZjf7p5MjInF6f2WdBsIWESmZy9YwCf8g/
         iLcYF9hOCfNMU79dKeThMMT33YsictvuDEFyMk/szyBn0hFRpcJ5GIKkDQck3XiNkPu2
         GLfDYHJVFsm90lg+a4ihS5muzm+SueOb7NKmQqfjzsnWdbuDm3NTTrcKukQ2o9eDb8lq
         4h/sadjHuPtSxWqo2pFXk7RaD+oWQZV4sdVUdfBLCPqnNUT19Lz4ZJdvCL2grZMnb29O
         dIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Go+slvtxWKdfE07JhWqm6afFVlakzlCghY+rCteiXNk=;
        b=aVuPtbp6iK2dYYQ7vaEN/ygukWD8sIUBdz6P8HwoNzplxaCXCIhIGF5OkduwqnSdkN
         MiFzbthq0LLsjhalLwU8yoSDo+LWqOIbHkq4emVrNvGvWdSxjZArFs1F28kx8mCzTl7N
         om0JTIbKorw/g8wqx/0eCepIBcfiH8cVuBVpEvyW4pdnrPbJoolSzj5pdJO1HNpiw9IF
         UbmcqFShKI3Y+N6ih9o3AcPG2tUnvRBWGMBP2CsbApfx4kCwgHFIFHGCD5xPTAM0BQ7D
         Q3hvwzM556HOMDfuERWwQxknT6HL6/Fs81nrIvTMPNMCdWBxum9dcRQ8veAUQ52UX4oK
         9g0Q==
X-Gm-Message-State: AOAM5331/uUaGCpv1/QwN3t5VBqEVB2G29sKHJFxOES/sRjrNsOaPp39
        Mn2NyrPz7ZenrKDRTPgrneJYKKwfQOdjFCinKQg=
X-Google-Smtp-Source: ABdhPJwwCtmbCXpHbRujh0bTJ/EL89rPzsgTyP80upk+Ti2zLojUqE8up27+RnQ8TU/xPEuBCAg+wytSmsuPai3ObXY=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr6035482ejc.160.1626187250185;
 Tue, 13 Jul 2021 07:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210713130344.473646-1-mudongliangabcd@gmail.com> <20210713132059.GB11179@breakpoint.cc>
In-Reply-To: <20210713132059.GB11179@breakpoint.cc>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 13 Jul 2021 22:40:23 +0800
Message-ID: <CAD-N9QV7pt3PCzUK2r03aB_URU5Auu+quC+DJpc=46hjkceBNg@mail.gmail.com>
Subject: Re: [PATCH v2] audit: fix memory leak in nf_tables_commit
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 9:21 PM Florian Westphal <fw@strlen.de> wrote:
>
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
> > free the adp variable.
> >
> > Fix this by freeing the linked list with head adl.
> >
> > backtrace:
> >   kmalloc include/linux/slab.h:591 [inline]
> >   kzalloc include/linux/slab.h:721 [inline]
> >   nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
> >   nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
> >   nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
> >   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
> >   nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
> >   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> >   netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
> >   netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
> >   sock_sendmsg_nosec net/socket.c:702 [inline]
> >   sock_sendmsg+0x56/0x80 net/socket.c:722
> >
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> > v1->v2: fix the compile issue
> >  net/netfilter/nf_tables_api.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 390d4466567f..7f45b291be13 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -8444,6 +8444,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
> >       return 0;
> >  }
> >
> > +static void nf_tables_commit_free(struct list_head *adl)
>
> nf_tables_commit_audit_free?

What do you mean? Modify the name of newly added function to
nf_tables_commit_audit_free?

>
> Aside from that, there should be a followup patch (for nf-next),
> adding empty inline functions in case of CONFIG_AUDITSYSCALL=n.

I see. I prefer to send them (two implementations of the newly added
function) in version v2.

>
> Right now it does pointless aggregation for the AUDIT=n case.
