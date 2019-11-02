Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C711BECC1F
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfKBAD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:03:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:58740 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKBAD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 20:03:26 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgt0-0003l2-1v; Sat, 02 Nov 2019 01:03:22 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgsz-0003Cl-Pu; Sat, 02 Nov 2019 01:03:21 +0100
Subject: Re: [PATCH bpf-next v5 0/3] xsk: XSKMAP performance improvements
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org,
        jakub.kicinski@netronome.com
Cc:     bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
References: <20191101110346.15004-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e01f2a9a-7a1b-c6f2-c504-265059fecfc5@iogearbox.net>
Date:   Sat, 2 Nov 2019 01:03:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191101110346.15004-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 12:03 PM, Björn Töpel wrote:
> This set consists of three patches from Maciej and myself which are
> optimizing the XSKMAP lookups.  In the first patch, the sockets are
> moved to be stored at the tail of the struct xsk_map. The second
> patch, Maciej implements map_gen_lookup() for XSKMAP. The third patch,
> introduced in this revision, moves various XSKMAP functions, to permit
> the compiler to do more aggressive inlining.
> 
> Based on the XDP program from tools/lib/bpf/xsk.c where
> bpf_map_lookup_elem() is explicitly called, this work yields a 5%
> improvement for xdpsock's rxdrop scenario. The last patch yields 2%
> improvement.
> 
> Jonathan's Acked-by: for patch 1 and 2 was carried on. Note that the
> overflow checks are done in the bpf_map_area_alloc() and
> bpf_map_charge_init() functions, which was fixed in commit
> ff1c08e1f74b ("bpf: Change size to u64 for bpf_map_{area_alloc,
> charge_init}()").
> 
> Cheers,
> Björn and Maciej
> 
> [1] https://patchwork.ozlabs.org/patch/1186170/
> 
> v1->v2: * Change size/cost to size_t and use {struct, array}_size
>            where appropriate. (Jakub)
> v2->v3: * Proper commit message for patch 2.
> v3->v4: * Change size_t to u64 to handle 32-bit overflows. (Jakub)
>          * Introduced patch 3.
> v4->v5: * Use BPF_SIZEOF size, instead of BPF_DW, for correct
>            pointer-sized loads. (Daniel)
> 
> Björn Töpel (2):
>    xsk: store struct xdp_sock as a flexible array member of the XSKMAP
>    xsk: restructure/inline XSKMAP lookup/redirect/flush
> 
> Maciej Fijalkowski (1):
>    bpf: implement map_gen_lookup() callback for XSKMAP
> 
>   include/linux/bpf.h    |  25 ---------
>   include/net/xdp_sock.h |  51 ++++++++++++++-----
>   kernel/bpf/xskmap.c    | 112 +++++++++++++----------------------------
>   net/xdp/xsk.c          |  33 +++++++++++-
>   4 files changed, 106 insertions(+), 115 deletions(-)
> 

Looks good, applied, thanks!
