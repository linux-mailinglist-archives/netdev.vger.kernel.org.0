Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3B579090
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbfG2QQW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jul 2019 12:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfG2QQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:16:22 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF7A2308AA11;
        Mon, 29 Jul 2019 16:16:21 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46ED96013A;
        Mon, 29 Jul 2019 16:16:13 +0000 (UTC)
Date:   Mon, 29 Jul 2019 18:16:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v5 3/6] xdp: Add devmap_hash map type for
 looking up devices by hashed index
Message-ID: <20190729181612.7bdbe16a@carbon>
In-Reply-To: <156415721483.13581.2247227362994997536.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
        <156415721483.13581.2247227362994997536.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 29 Jul 2019 16:16:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 18:06:55 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> A common pattern when using xdp_redirect_map() is to create a device map
> where the lookup key is simply ifindex. Because device maps are arrays,
> this leaves holes in the map, and the map has to be sized to fit the
> largest ifindex, regardless of how many devices actually are actually
> needed in the map.
> 
> This patch adds a second type of device map where the key is looked up
> using a hashmap, instead of being used as an array index. This allows maps
> to be densely packed, so they can be smaller.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

[...]
> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
> +						    int idx)
> +{
> +	return &dtab->dev_index_head[idx & (dtab->n_buckets - 1)];
> +}

I was about to complain about, that you are not using a pre-calculated
MASK value, instead of doing the -1 operation each time.  But I looked
at the ASM code, and the LEA operation used does the -1 operation in
the same instruction, so I guess this makes no performance difference.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
