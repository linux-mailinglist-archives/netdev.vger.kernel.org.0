Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311F852D0C9
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbiESKqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236971AbiESKp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:45:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 135D71EEF3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652957156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8rut9GNc4WtSroF96b47WlHm5eXtcsOWXAAJ8NlKUQQ=;
        b=XqZ4f9atbHnM0QxEajBz3Z89SLEJ5Xj9IimL8L7a/KghTWZ3dUXzm3UwKtWb256zD7ojaG
        N1wzn7vBc+Y42J7XJsJv5ANUK++lSbtSqUuza8zCRk1d9Nr7pIb3O10k0YwzqD4t0J+H10
        8TUuGrciVKVdPC0H/vi/chBc+aDuiVw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-a_xxKRvIOTCj7nAMblTu8A-1; Thu, 19 May 2022 06:45:55 -0400
X-MC-Unique: a_xxKRvIOTCj7nAMblTu8A-1
Received: by mail-ej1-f69.google.com with SMTP id qb36-20020a1709077ea400b006f45e182187so2310619ejc.14
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8rut9GNc4WtSroF96b47WlHm5eXtcsOWXAAJ8NlKUQQ=;
        b=IOJYaK3ACeF0XMvZQY+178Tl9CmAcWzFPoob6XngDBJYKD78jkXSgW7K7rBHWxe+El
         6ZHngCmw9BqEzmFZ5mbQHmzrDT0L8q+JwBZf2T/mPmtDdpiRhCqPssidw3vpJ9mCZD26
         /JAbi/WaTz4s4i/9GzKylzC9OhkDxsu7i38Gxyy9uSru+4P5gJC5i9TySoXEXU8IRILM
         ojo/0JAEia9joE0PVy/N9dR2iFGamHEqVLl8xSzXUHCtBwSZFa2CO9hl6plj/A1tGQK0
         Kh9uAbAJzRT1lxepTHe859w8UnKRjQyoFuQ2ANc2c6HSqIZd9qPgEMZ3UQS5CsMZFsPp
         TXMw==
X-Gm-Message-State: AOAM530/hOMG/EsIGyy51EQta+us1P58pcr0qQbC6JU5PIVslHCj9eK5
        0IpG4yBBCUC/yqqjYmkpoCyW2iRMxdoOqft06Fha2XN6ckC7xZwaV6oYEKd5Y3RtHqPvDixWuzo
        VuZVVa1Qtddm1R8DH
X-Received: by 2002:a17:907:961e:b0:6f4:b201:6629 with SMTP id gb30-20020a170907961e00b006f4b2016629mr3745632ejc.152.1652957153394;
        Thu, 19 May 2022 03:45:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx52dO1ml/cCp+uLuLPFVwIUuT7zd2gIPRWnBOP1j1BK0pQWadGJYAMHEh2QAWSCJvZgUTRrA==
X-Received: by 2002:a17:907:961e:b0:6f4:b201:6629 with SMTP id gb30-20020a170907961e00b006f4b2016629mr3745561ejc.152.1652957152469;
        Thu, 19 May 2022 03:45:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j22-20020aa7ca56000000b0042acc78178bsm2623753edt.93.2022.05.19.03.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 03:45:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 47CED38EE17; Thu, 19 May 2022 12:45:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add
 a new ct entry
In-Reply-To: <20220518224330.omsokbbhqoe5mc3v@apollo.legion>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
 <87y1yy8t6j.fsf@toke.dk> <YoVgZ8OHlF/OpgHq@lore-desk>
 <CAADnVQ+6-cywf0StZ_K0nKSSdXJsZ4S_ZBhGZPHDmKtaL3k9-g@mail.gmail.com>
 <20220518224330.omsokbbhqoe5mc3v@apollo.legion>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 19 May 2022 12:45:51 +0200
Message-ID: <87czg994ww.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Thu, May 19, 2022 at 03:44:58AM IST, Alexei Starovoitov wrote:
>> On Wed, May 18, 2022 at 2:09 PM Lorenzo Bianconi
>> <lorenzo.bianconi@redhat.com> wrote:
>> >
>> > > Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> > >
>> > > > Introduce bpf_xdp_ct_add and bpf_skb_ct_add kfunc helpers in order to
>> > > > add a new entry to ct map from an ebpf program.
>> > > > Introduce bpf_nf_ct_tuple_parse utility routine.
>> > > >
>> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> > > > ---
>> > > >  net/netfilter/nf_conntrack_bpf.c | 212 +++++++++++++++++++++++++++----
>> > > >  1 file changed, 189 insertions(+), 23 deletions(-)
>> > > >
>> > > > diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
>> > > > index a9271418db88..3d31b602fdf1 100644
>> > > > --- a/net/netfilter/nf_conntrack_bpf.c
>> > > > +++ b/net/netfilter/nf_conntrack_bpf.c
>> > > > @@ -55,41 +55,114 @@ enum {
>> > > >     NF_BPF_CT_OPTS_SZ = 12,
>> > > >  };
>> > > >
>> > > > -static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>> > > > -                                     struct bpf_sock_tuple *bpf_tuple,
>> > > > -                                     u32 tuple_len, u8 protonum,
>> > > > -                                     s32 netns_id, u8 *dir)
>> > > > +static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
>> > > > +                            u32 tuple_len, u8 protonum, u8 dir,
>> > > > +                            struct nf_conntrack_tuple *tuple)
>> > > >  {
>> > > > -   struct nf_conntrack_tuple_hash *hash;
>> > > > -   struct nf_conntrack_tuple tuple;
>> > > > -   struct nf_conn *ct;
>> > > > +   union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
>> > > > +   union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
>> > > > +   union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
>> > > > +                                             : &tuple->src.u;
>> > > > +   union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
>> > > > +                                             : (void *)&tuple->dst.u;
>> > > >
>> > > >     if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
>> > > > -           return ERR_PTR(-EPROTO);
>> > > > -   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>> > > > -           return ERR_PTR(-EINVAL);
>> > > > +           return -EPROTO;
>> > > > +
>> > > > +   memset(tuple, 0, sizeof(*tuple));
>> > > >
>> > > > -   memset(&tuple, 0, sizeof(tuple));
>> > > >     switch (tuple_len) {
>> > > >     case sizeof(bpf_tuple->ipv4):
>> > > > -           tuple.src.l3num = AF_INET;
>> > > > -           tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
>> > > > -           tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
>> > > > -           tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
>> > > > -           tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
>> > > > +           tuple->src.l3num = AF_INET;
>> > > > +           src->ip = bpf_tuple->ipv4.saddr;
>> > > > +           sport->tcp.port = bpf_tuple->ipv4.sport;
>> > > > +           dst->ip = bpf_tuple->ipv4.daddr;
>> > > > +           dport->tcp.port = bpf_tuple->ipv4.dport;
>> > > >             break;
>> > > >     case sizeof(bpf_tuple->ipv6):
>> > > > -           tuple.src.l3num = AF_INET6;
>> > > > -           memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
>> > > > -           tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
>> > > > -           memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
>> > > > -           tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
>> > > > +           tuple->src.l3num = AF_INET6;
>> > > > +           memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
>> > > > +           sport->tcp.port = bpf_tuple->ipv6.sport;
>> > > > +           memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
>> > > > +           dport->tcp.port = bpf_tuple->ipv6.dport;
>> > > >             break;
>> > > >     default:
>> > > > -           return ERR_PTR(-EAFNOSUPPORT);
>> > > > +           return -EAFNOSUPPORT;
>> > > >     }
>> > > > +   tuple->dst.protonum = protonum;
>> > > > +   tuple->dst.dir = dir;
>> > > > +
>> > > > +   return 0;
>> > > > +}
>> > > >
>> > > > -   tuple.dst.protonum = protonum;
>> > > > +struct nf_conn *
>> > > > +__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>> > > > +                   u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
>> > > > +{
>> > > > +   struct nf_conntrack_tuple otuple, rtuple;
>> > > > +   struct nf_conn *ct;
>> > > > +   int err;
>> > > > +
>> > > > +   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>> > > > +           return ERR_PTR(-EINVAL);
>> > > > +
>> > > > +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
>> > > > +                               IP_CT_DIR_ORIGINAL, &otuple);
>> > > > +   if (err < 0)
>> > > > +           return ERR_PTR(err);
>> > > > +
>> > > > +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
>> > > > +                               IP_CT_DIR_REPLY, &rtuple);
>> > > > +   if (err < 0)
>> > > > +           return ERR_PTR(err);
>> > > > +
>> > > > +   if (netns_id >= 0) {
>> > > > +           net = get_net_ns_by_id(net, netns_id);
>> > > > +           if (unlikely(!net))
>> > > > +                   return ERR_PTR(-ENONET);
>> > > > +   }
>> > > > +
>> > > > +   ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
>> > > > +                           GFP_ATOMIC);
>> > > > +   if (IS_ERR(ct))
>> > > > +           goto out;
>> > > > +
>> > > > +   ct->timeout = timeout * HZ + jiffies;
>> > > > +   ct->status |= IPS_CONFIRMED;
>> > > > +
>> > > > +   memset(&ct->proto, 0, sizeof(ct->proto));
>> > > > +   if (protonum == IPPROTO_TCP)
>> > > > +           ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
>> > >
>> > > Hmm, isn't it a bit limiting to hard-code this to ESTABLISHED
>> > > connections? Presumably for TCP you'd want to use this when you see a
>> > > SYN and then rely on conntrack to help with the subsequent state
>> > > tracking for when the SYN-ACK comes back? What's the usecase for
>> > > creating an entry in ESTABLISHED state, exactly?
>> >
>> > I guess we can even add a parameter and pass the state from the caller.
>> > I was not sure if it is mandatory.
>>
>> It's probably cleaner and more flexible to split
>> _alloc and _insert into two kfuncs and let bpf
>> prog populate ct directly.
>
> Right, so we can just whitelist a few fields and allow assignments into those.
> One small problem is that we should probably only permit this for nf_conn
> PTR_TO_BTF_ID obtained from _alloc, and make it rdonly on _insert.
>
> We can do the rw->ro conversion by taking in ref from alloc, and releasing on
> _insert, then returning ref from _insert.

Sounds reasonable enough; I guess _insert would also need to
sanity-check some of the values to prevent injecting invalid state into
the conntrack table.

> For the other part, either return a different shadow PTR_TO_BTF_ID
> with only the fields that can be set, convert insns for it, and then
> on insert return the rdonly PTR_TO_BTF_ID of struct nf_conn, or
> otherwise store the source func in the per-register state and use that
> to deny BPF_WRITE for normal nf_conn. Thoughts?

Hmm, if they're different BTF IDs wouldn't the BPF program have to be
aware of this and use two different structs for the pointer storage?
That seems a bit awkward from an API PoV?

Also, what about updating? For this to be useful with TCP, you'd really
want to be able to update the CT state as the connection is going
through the handshake state transitions...

-Toke

