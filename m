Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5BAD02DA
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbfJHV3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:29:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:48444 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730523AbfJHV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:29:47 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iHx3B-0001pI-E2; Tue, 08 Oct 2019 23:29:45 +0200
Date:   Tue, 8 Oct 2019 23:29:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as
 scalars
Message-ID: <20191008212945.GG27307@pc-66.home>
References: <20191008194548.2344473-1-andriin@fb.com>
 <20191008194548.2344473-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008194548.2344473-2-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25596/Tue Oct  8 10:33:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 12:45:47PM -0700, Andrii Nakryiko wrote:
> Maps that are read-only both from BPF program side and user space side
> have their contents constant, so verifier can track referenced values
> precisely and use that knowledge for dead code elimination, branch
> pruning, etc. This patch teaches BPF verifier how to do this.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/verifier.c | 58 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ffc3e53f5300..1e4e4bd64ca5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2739,6 +2739,42 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
>  	reg->smax_value = reg->umax_value;
>  }
>  
> +static bool bpf_map_is_rdonly(const struct bpf_map *map)
> +{
> +	return (map->map_flags & BPF_F_RDONLY_PROG) &&
> +	       ((map->map_flags & BPF_F_RDONLY) || map->frozen);

This is definitely buggy. Testing for 'map->map_flags & BPF_F_RDONLY'
to assume it's RO from user space side is not correct as it's just
related to the current fd, but not the map itself. So the second part
definitely /must/ only be: && map->frozen

Thanks,
Daniel
