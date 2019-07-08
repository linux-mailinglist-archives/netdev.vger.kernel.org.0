Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75B36212D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbfGHPKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:10:35 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:61371 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfGHPKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:10:35 -0400
Received: (qmail 17372 invoked by uid 89); 8 Jul 2019 15:10:33 -0000
Received: from unknown (HELO ?172.20.95.170?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4z) (POLARISLOCAL)  
  by smtp7.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 8 Jul 2019 15:10:33 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>, netdev@vger.kernel.org,
        "David Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] xdp: Add devmap_hash map type
Date:   Mon, 08 Jul 2019 08:10:28 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <53906C87-8AF9-4048-8CA0-AE38C023AEF7@flugsvamp.com>
In-Reply-To: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5 Jul 2019, at 10:56, Toke Høiland-Jørgensen wrote:

> This series adds a new map type, devmap_hash, that works like the 
> existing
> devmap type, but using a hash-based indexing scheme. This is useful 
> for the use
> case where a devmap is indexed by ifindex (for instance for use with 
> the routing
> table lookup helper). For this use case, the regular devmap needs to 
> be sized
> after the maximum ifindex number, not the number of devices in it. A 
> hash-based
> indexing scheme makes it possible to size the map after the number of 
> devices it
> should contain instead.

This device hash map is sized at NETDEV_HASHENTRIES == 2^8 == 256.  Is 
this actually
smaller than an array?  What ifindex values are you seeing?
-- 
Jonathan


>
> This was previously part of my patch series that also turned the 
> regular
> bpf_redirect() helper into a map-based one; for this series I just 
> pulled out
> the patches that introduced the new map type.
>
> Changelog:
>
> Changes to these patches since the previous series:
>
> - Rebase on top of the other devmap changes (makes this one simpler!)
> - Don't enforce key==val, but allow arbitrary indexes.
> - Rename the type to devmap_hash to reflect the fact that it's just a 
> hashmap now.
>
> ---
>
> Toke Høiland-Jørgensen (3):
>       include/bpf.h: Remove map_insert_ctx() stubs
>       xdp: Refactor devmap allocation code for reuse
>       xdp: Add devmap_hash map type for looking up devices by hashed 
> index
>
>
>  include/linux/bpf.h                     |   11 -
>  include/linux/bpf_types.h               |    1
>  include/trace/events/xdp.h              |    3
>  include/uapi/linux/bpf.h                |    7 -
>  kernel/bpf/devmap.c                     |  325 
> ++++++++++++++++++++++++++-----
>  kernel/bpf/verifier.c                   |    2
>  net/core/filter.c                       |    9 +
>  tools/bpf/bpftool/map.c                 |    1
>  tools/include/uapi/linux/bpf.h          |    7 -
>  tools/lib/bpf/libbpf_probes.c           |    1
>  tools/testing/selftests/bpf/test_maps.c |   16 ++
>  11 files changed, 316 insertions(+), 67 deletions(-)
