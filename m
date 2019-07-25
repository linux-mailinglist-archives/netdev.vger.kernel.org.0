Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23ED374D3E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404109AbfGYLhl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 07:37:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404104AbfGYLhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 07:37:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC114308C38C;
        Thu, 25 Jul 2019 11:37:39 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C15460497;
        Thu, 25 Jul 2019 11:37:32 +0000 (UTC)
Date:   Thu, 25 Jul 2019 13:37:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v4 3/6] xdp: Add devmap_hash map type for
 looking up devices by hashed index
Message-ID: <20190725133730.3750c66c@carbon>
In-Reply-To: <87muh2z9os.fsf@toke.dk>
References: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
        <156379636866.12332.6546616116016146789.stgit@alrua-x1>
        <20190725100717.0c4e8265@carbon>
        <87muh2z9os.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 25 Jul 2019 11:37:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 12:32:19 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
> > On Mon, 22 Jul 2019 13:52:48 +0200
> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >  
> >> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
> >> +						    int idx)
> >> +{
> >> +	return &dtab->dev_index_head[idx & (NETDEV_HASHENTRIES - 1)];
> >> +}  
> >
> > It is good for performance that our "hash" function is simply an AND
> > operation on the idx.  We want to keep it this way.
> >
> > I don't like that you are using NETDEV_HASHENTRIES, because the BPF map
> > infrastructure already have a way to specify the map size (struct
> > bpf_map_def .max_entries).  BUT for performance reasons, to keep the
> > AND operation, we would need to round up the hash-array size to nearest
> > power of 2 (or reject if user didn't specify a power of 2, if we want
> > to "expose" this limit to users).  
> 
> But do we really want the number of hash buckets to be equal to the max
> number of entries? The values are not likely to be evenly distributed,
> so we'll end up with big buckets if the number is small, meaning we'll
> blow performance on walking long lists in each bucket.

The requested change makes it user-configurable, instead of fixed 256
entries.  I've seen production use-case with >5000 net_devices, thus
they need a knob to increase this (to avoid the list walking as you
mention).


> Also, if the size is dynamic the size needs to be loaded from memory
> instead of being a compile-time constant, which will presumably hurt
> performance (though not sure by how much)?

To counter this, the mask value which need to be loaded from memory,
needs to be placed next to some other struct member which is already in
use (at least on same cacheline, Intel have some 16 bytes access micro
optimizations, which I've never been able to measure, as its in 0.5
nanosec scale).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
