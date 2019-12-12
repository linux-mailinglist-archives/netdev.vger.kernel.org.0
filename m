Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251AC11D44C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfLLRn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:43:29 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46508 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbfLLRn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:43:28 -0500
Received: by mail-yb1-f195.google.com with SMTP id v15so730024ybp.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 09:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EdqCF5tvwgVMUKXo5Gg9MZzmPyDl35poDR7wJSfMlzM=;
        b=LLcJACZkeT7VlpN/7DZDcSAE6sghzdqmAkslR7S7RnFKp44sjfonW9yy+gDe23yant
         QvMTOM7usCieW1ssJtP9p2R7HcfztV70xUrc5szz/uYOUOhPAMhsBf1A+bbzyCqJ0tY7
         AaofMcilgF1LX7kfAjbmpPBMyAC1PbQjBQZGAGbRbFeU2XF6zaPyBTHXSDeR7jXLSfgv
         FARxsrnNEkN1Aoqo05TqvGSqiCS6TLfVZJs3tfYyjhggCz0luFJutyrE8rsfUQ9XXIQ9
         bDvRydKyX2l8CAJoXvCSlo9tzbqm7FaW/BhrEBQB91U5GaVrfYZhEqDcmVQ4j4Nc+mGQ
         HOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EdqCF5tvwgVMUKXo5Gg9MZzmPyDl35poDR7wJSfMlzM=;
        b=R/nkKzRnMYnJlQ8Xm1Tf2t/sBPERDaMgQsE5y+qioalqAs2WGDBXFa4bO3JjpMd3Sp
         rJuDaFFGdDOqv54mXHzrh/MimvFZNVNdTMwTsWDQIW/4gvTR5meRATOf0SVT3OYHCNsb
         Ck6uFVEdIAFWhOONbzz5qzH5x4a6+VjwnPjYdkm/bLrvSqtJcti+HuZlOmI8uSHr/zfk
         Y0BELcGqG0hMjrgoRu6NtSo7did7htxIjNbyl3fZR0ymQaBFaz24Qa4ZkvaGxyalYYEe
         jczXH0IntZ9shS+y4vh3ytR/uLisOvkR+HvmkB8unm93VJxylUY5e6jxAU6qdnY99Dba
         3Zzw==
X-Gm-Message-State: APjAAAX52qxEsf5qYMijV4tiqjroDVi/4R6NWWeZeEsOimdsDv55s3jg
        pXLFcPwoKWWgcWjJnAowNqoVCNsgZmhalu8tatweaQ==
X-Google-Smtp-Source: APXvYqw1Ul0Fvx4Ka6m/sYUEBGT6sEv1LDItDmizwU4MLBmzin7Y7OdO4TP7SdRVVjAvNZIx9hhAAsJrp4dSOEHl3E4=
X-Received: by 2002:a25:60c6:: with SMTP id u189mr5451702ybb.173.1576172607164;
 Thu, 12 Dec 2019 09:43:27 -0800 (PST)
MIME-Version: 1.0
References: <20191211170943.134769-1-edumazet@google.com> <20191212173156.GA21497@unicorn.suse.cz>
In-Reply-To: <20191212173156.GA21497@unicorn.suse.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 Dec 2019 09:43:15 -0800
Message-ID: <CANn89i+16zwKepVcHX8a0pz6GrxS+B9y6RiYHL0M-Sn_+Gv1zg@mail.gmail.com>
Subject: Re: [PATCH net] tcp/dccp: fix possible race __inet_lookup_established()
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Firo Yang <firo.yang@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 9:32 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Wed, Dec 11, 2019 at 09:09:43AM -0800, Eric Dumazet wrote:
> > Michal Kubecek and Firo Yang did a very nice analysis of crashes
> > happening in __inet_lookup_established().
> >
> > Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
> > (via a close()/socket()/listen() cycle) without a RCU grace period,
> > I should not have changed listeners linkage in their hash table.
> >
> > They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
> > so that a lookup can detect a socket in a hash list was moved in
> > another one.
> >
> > Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
> > merge conflict for v4/v6 ordering fix"), we have to add
> > hlist_nulls_add_tail_rcu() helper.
> >
> > Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Michal Kubecek <mkubecek@suse.cz>
> > Reported-by: Firo Yang <firo.yang@suse.com>
> > Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/
> > ---
> >  include/linux/rculist_nulls.h | 37 +++++++++++++++++++++++++++++++++++
> >  include/net/inet_hashtables.h | 11 +++++++++--
> >  include/net/sock.h            |  5 +++++
> >  net/ipv4/inet_diag.c          |  3 ++-
> >  net/ipv4/inet_hashtables.c    | 16 +++++++--------
> >  net/ipv4/tcp_ipv4.c           |  7 ++++---
> >  6 files changed, 65 insertions(+), 14 deletions(-)
> >
> [...]
> > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > index af2b4c065a042e36135fe6fdcee9833b6b353364..29ef5b7f4005a8e67fd358c136ee6532974efcab 100644
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -105,11 +105,18 @@ struct inet_bind_hashbucket {
> >
> >  /*
> >   * Sockets can be hashed in established or listening table
> > - */
> > + * We must use different 'nulls' end-of-chain value for listening
> > + * hash table, or we might find a socket that was closed and
> > + * reallocated/inserted into established hash table
> > +  */
>
> Just a nitpick: I don't think this comment is still valid because
> listening sockets now have RCU protection so that listening socket
> cannot be freed and reallocated without RCU grace period. (But we still
> need disjoint ranges to handle the reallocation in the opposite
> direction.)

Hi Michal

I am not a native English speaker, but I was trying to say :

A lookup in established sockets might go through a socket that
was in this bucket but has been closed, reallocated and became a listener.

Maybe the comment needs to be refined, but I am not sure how, considering
that most people reading it will not understand it anyway, given the
complexity of the nulls stuff.

>
> Other than that, the patch looks good (and better than my
> work-in-progress patch which I didn't manage to test properly).
>
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
>
> > +#define LISTENING_NULLS_BASE (1U << 29)
> >  struct inet_listen_hashbucket {
> >       spinlock_t              lock;
> >       unsigned int            count;
> > -     struct hlist_head       head;
> > +     union {
> > +             struct hlist_head       head;
> > +             struct hlist_nulls_head nulls_head;
> > +     };
> >  };
