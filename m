Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7A5777F4
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiGQTXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiGQTX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:23:29 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C59CA446;
        Sun, 17 Jul 2022 12:23:29 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10c0430e27dso19087091fac.4;
        Sun, 17 Jul 2022 12:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1mjGqetET/mkjAgPnd3d/Sgftw1p+N+UXVDuByzJX78=;
        b=dw2I5vA4fF1SIFGAxZ5z4EYd6Mq7k1FXjHM9mmCIW7UpxVSUnVkgJCNrBeXpBDrWR1
         zXMt669HOD6/9aZe01CUD5OT3eMbhOYMAyd6OEJ+NnuJAxealv7KoXDGKFtul768PJRC
         66SqQIXNAJwVx94CHHFkqrbklHNaN82sBxB8JBU6VSQP0qlevALVM4qF8Ub/hZarm1RK
         LLwlgYr50udTDi+XJLlJ2aRSXPclXhT2NgtHyEIZtElkUFQU/AjQbYIM3PrVBgN/c1Jq
         kLkYTjnZ7WMomDi1gYkTc2qpH4FYldo9W0YEKWYbK+rEX9bC38o/rIB09nqyDbTJaTNu
         1jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1mjGqetET/mkjAgPnd3d/Sgftw1p+N+UXVDuByzJX78=;
        b=N7Ie7eOzJiViTQSk8+QQDRsfRMtmk0ZyJ0CZwuX6+POBn/YcWCiqgdYlcxTnk+au+L
         GvIzNcZKGKyMUqHGcZ0bmdVosG67XK8mGhZzRE/xFJuHp/oHTP2/IKBRhyaSDtLbgvm7
         Mq4YKTF5B8H0Uv37z5bqMBxEwK5acWR0rKNqQzN81V1wn64KUtNNp1kZgIgJ3JxKt4Hd
         if3A25l7yF/I2dvqSoePDllU5rah0TRvHjglLtrzrY7wB4clSKgtm0B4oR++OWk4mqJe
         WqA3nwXBEPdVpm+ui0lkYliUIw2YvVj5i4AxwgTS/6aW9DtCyZQhtuhBjKiTiwe9+weh
         OKsQ==
X-Gm-Message-State: AJIora9j1MHB2G6k5La+mCT1MrAeoGk2mxFdoNtZ/9AvdJTCLd/1PWFD
        JX7V/CffVU2fTEkwpIF9PXcmv71yebiqaA==
X-Google-Smtp-Source: AGRyM1sIaPY6YfqG0B8SS7WSvfQefoXsMIvYdaNCWNJTLxyE29A3WNWgfSoSNs74292r9pdIxz+7XQ==
X-Received: by 2002:a05:6808:201c:b0:335:8112:dd85 with SMTP id q28-20020a056808201c00b003358112dd85mr11342056oiw.150.1658085808357;
        Sun, 17 Jul 2022 12:23:28 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:3835:48ec:66bb:33a6])
        by smtp.gmail.com with ESMTPSA id d7-20020a9d5e07000000b0061c862ac067sm2719481oti.62.2022.07.17.12.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 12:23:27 -0700 (PDT)
Date:   Sun, 17 Jul 2022 12:23:26 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
Message-ID: <YtRhrvt6wUPWTvWU@pop-os.localdomain>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
 <YtRSOaCtujBfzHUS@pop-os.localdomain>
 <CAP01T77ov2ARuR+on+D-8cgYSsndF9JKTuYMT9dc1Qu8wuG5sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP01T77ov2ARuR+on+D-8cgYSsndF9JKTuYMT9dc1Qu8wuG5sQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 08:41:10PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Sun, 17 Jul 2022 at 20:17, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Jul 13, 2022 at 11:52:07PM +0200, Toke Høiland-Jørgensen wrote:
> > > Stanislav Fomichev <sdf@google.com> writes:
> > >
> > > > On Wed, Jul 13, 2022 at 4:14 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > > >>
> > > >> Packet forwarding is an important use case for XDP, which offers
> > > >> significant performance improvements compared to forwarding using the
> > > >> regular networking stack. However, XDP currently offers no mechanism to
> > > >> delay, queue or schedule packets, which limits the practical uses for
> > > >> XDP-based forwarding to those where the capacity of input and output links
> > > >> always match each other (i.e., no rate transitions or many-to-one
> > > >> forwarding). It also prevents an XDP-based router from doing any kind of
> > > >> traffic shaping or reordering to enforce policy.
> > > >>
> > > >> This series represents a first RFC of our attempt to remedy this lack. The
> > > >> code in these patches is functional, but needs additional testing and
> > > >> polishing before being considered for merging. I'm posting it here as an
> > > >> RFC to get some early feedback on the API and overall design of the
> > > >> feature.
> > > >>
> > > >> DESIGN
> > > >>
> > > >> The design consists of three components: A new map type for storing XDP
> > > >> frames, a new 'dequeue' program type that will run in the TX softirq to
> > > >> provide the stack with packets to transmit, and a set of helpers to dequeue
> > > >> packets from the map, optionally drop them, and to schedule an interface
> > > >> for transmission.
> > > >>
> > > >> The new map type is modelled on the PIFO data structure proposed in the
> > > >> literature[0][1]. It represents a priority queue where packets can be
> > > >> enqueued in any priority, but is always dequeued from the head. From the
> > > >> XDP side, the map is simply used as a target for the bpf_redirect_map()
> > > >> helper, where the target index is the desired priority.
> > > >
> > > > I have the same question I asked on the series from Cong:
> > > > Any considerations for existing carousel/edt-like models?
> > >
> > > Well, the reason for the addition in patch 5 (continuously increasing
> > > priorities) is exactly to be able to implement EDT-like behaviour, where
> > > the priority is used as time units to clock out packets.
> >
> > Are you sure? I seriouly doubt your patch can do this at all...
> >
> > Since your patch relies on bpf_map_push_elem(), which has no room for
> > 'key' hence you reuse 'flags' but you also reserve 4 bits there... How
> > could tstamp be packed with 4 reserved bits??
> >
> > To answer Stanislav's question, this is how my code could handle EDT:
> >
> > // BPF_CALL_3(bpf_skb_map_push, struct bpf_map *, map, struct sk_buff *, skb, u64, key)
> > skb->tstamp = XXX;
> > bpf_skb_map_push(map, skb, skb->tstamp);
> 
> It is also possible here, if we could not push into the map with a
> certain key it wouldn't be a PIFO.
> Please look at patch 16/17 for an example (test_xdp_pifo.c), it's just
> that the interface is different (bpf_redirect_map),


Sorry for mentioning that I don't care about XDP case at all. Please let me
know how this works for eBPF Qdisc. This is what I found in 16/17:

+ ret = bpf_map_push_elem(&pifo_map, &val, flags);


> the key has been expanded to 64 bits to accommodate such use cases. It
> is also possible in a future version of the patch to amortize the cost
> of taking the lock for each enqueue by doing batching, similar to what
> cpumap/devmap implementations do.

How about the 4 reserved bits?

 ret = bpf_map_push_elem(&pifo_map, &val, flags);

which leads to:

+#define BPF_PIFO_PRIO_MASK	(~0ULL >> 4)
...
+static int pifo_map_push_elem(struct bpf_map *map, void *value, u64 flags)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	struct bpf_pifo_element *dst;
+	unsigned long irq_flags;
+	u64 prio;
+	int ret;
+
+	/* Check if any of the actual flag bits are set */
+	if (flags & ~BPF_PIFO_PRIO_MASK)
+		return -EINVAL;
+
+	prio = flags & BPF_PIFO_PRIO_MASK;


Please let me know how you calculate 64 bits while I only calculate 60
bits (for skb case, obviously)?

Wait for a second, as BPF_EXIST is already a bit, I think you have 59
bits here actually...

Thanks!
