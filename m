Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE0F30F6A8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbhBDPoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:44:32 -0500
Received: from www62.your-server.de ([213.133.104.62]:59092 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbhBDPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:44:03 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l7gml-000BBP-5T; Thu, 04 Feb 2021 16:43:11 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l7gmk-000NpS-Tq; Thu, 04 Feb 2021 16:43:10 +0100
Subject: Re: [PATCH v3 bpf-next] net: veth: alloc skb in bulk for ndo_xdp_xmit
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
References: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
 <e2ae0d97-376a-07db-94fb-14f1220acca5@iogearbox.net>
 <20210204100556.59459549@carbon.lan>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <65a218bc-3ebf-001e-174d-b67817c83b45@iogearbox.net>
Date:   Thu, 4 Feb 2021 16:43:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210204100556.59459549@carbon.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26070/Thu Feb  4 13:22:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/21 10:05 AM, Jesper Dangaard Brouer wrote:
[...]
> It was Andrew (AKPM) that wanted the API to either return the requested
> number of objects or fail. I respected the MM-maintainers request at
> that point, even-though I wanted the other API as there is a small
> performance advantage (not crossing page boundary in SLUB).
> 
> At that time we discussed it on MM-list, and I see his/the point:
> If API can allocate less objs than requested, then think about how this
> complicated the surrounding code. E.g. in this specific code we already
> have VETH_XDP_BATCH(16) xdp_frame objects, which we need to get 16 SKB
> objects for.  What should the code do if it cannot get 16 SKBs(?).

Right, I mentioned the error handling complications above wrt < n_skb case. I think iff this
ever gets implemented and there's a need, it would probably be best to add a new flag like
__GFP_BULK_BEST_EFFORT to indicate that it would be okay to return x elements with x being
in (0, size], so that only those callers need to deal with this, and all others can expect
[as today] that != 0 means all #size elements were bulk alloc'ed.

Thanks,
Daniel
