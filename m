Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E82748C8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 10:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbfGYIH1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 04:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388497AbfGYIH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 04:07:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1954C057F31;
        Thu, 25 Jul 2019 08:07:26 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98DD7600C4;
        Thu, 25 Jul 2019 08:07:19 +0000 (UTC)
Date:   Thu, 25 Jul 2019 10:07:17 +0200
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
Message-ID: <20190725100717.0c4e8265@carbon>
In-Reply-To: <156379636866.12332.6546616116016146789.stgit@alrua-x1>
References: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
        <156379636866.12332.6546616116016146789.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 25 Jul 2019 08:07:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jul 2019 13:52:48 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
> +						    int idx)
> +{
> +	return &dtab->dev_index_head[idx & (NETDEV_HASHENTRIES - 1)];
> +}

It is good for performance that our "hash" function is simply an AND
operation on the idx.  We want to keep it this way.

I don't like that you are using NETDEV_HASHENTRIES, because the BPF map
infrastructure already have a way to specify the map size (struct
bpf_map_def .max_entries).  BUT for performance reasons, to keep the
AND operation, we would need to round up the hash-array size to nearest
power of 2 (or reject if user didn't specify a power of 2, if we want
to "expose" this limit to users).

> +struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
> +{
> +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> +	struct hlist_head *head = dev_map_index_hash(dtab, key);
> +	struct bpf_dtab_netdev *dev;
> +
> +	hlist_for_each_entry_rcu(dev, head, index_hlist)
> +		if (dev->idx == key)
> +			return dev;
> +
> +	return NULL;
> +}

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
