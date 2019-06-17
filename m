Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2A485B2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFQOjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:39:36 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:47089 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbfFQOjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:39:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D7CA88C5;
        Mon, 17 Jun 2019 10:39:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Jun 2019 10:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0lHMgq
        aeNtiU2u36JVrCBlKFBJ1DNkUjrm8h+JavxgM=; b=m5xVf6X5jpBWIxyj2Z1TOo
        HEUh0Y5yp6Ek7ZTiNrRRtEVjgmihV4m9iAF5ppb+g9WqBPNAoPOSnR0upF4upaaP
        4sq0uTVdur4AW5a3RpKwyDJLTu7YhFrUAqrveBc42q8n44W6LhVl241yRugmFqbM
        doK2qcMn5QL85o4W3pmxDavuWEHp7sW4PUQbnNxHUfiuzfWFlP8D8sl2eLQNn+Op
        uXVoo8CPMcN0m1uh5DbmL+ZhbP7paCnaPku6R37I54OiqAvXeCp9LC6wHFYVS7c4
        4kX/kQ3j0b81hENqg53Ddfzk1qKyuiQAQHNjCchDkrB6GjzqmHVVlsEDku9JoJnw
        ==
X-ME-Sender: <xms:JqYHXUI7u1W88F9YwKfj-Cn_h2d_ih3Y6y52sP65IMa3R9rpIvaJfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeijedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:JqYHXVajJxC08loTCF0HWeCbREFraScLKfOIxWkBR30rvWSM9jkQGQ>
    <xmx:JqYHXdLTrycQPZWAE0kO-kFC4xyNtrzashFM4VvioXmVBH2g_OvcXg>
    <xmx:JqYHXXntNJKDgTajn09wxQhykDTqP-sUH23NOUr_bgRBTC7i8ugP4A>
    <xmx:JqYHXVZ_Cgc-y7u3HLpZEOH2rFh2Mwp-Woo7NBvWjsqjb_K8tMDHLQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94A25380084;
        Mon, 17 Jun 2019 10:39:33 -0400 (EDT)
Date:   Mon, 17 Jun 2019 17:39:32 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH net-next v3] ipv4: Support multipath hashing on inner IP
 pkts for GRE tunnel
Message-ID: <20190617143932.GA9828@splinter>
References: <20190613183858.9892-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613183858.9892-1-ssuryaextr@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 02:38:58PM -0400, Stephen Suryaputra wrote:
> Multipath hash policy value of 0 isn't distributing since the outer IP
> dest and src aren't varied eventhough the inner ones are. Since the flow
> is on the inner ones in the case of tunneled traffic, hashing on them is
> desired.
> 
> This is done mainly for IP over GRE, hence only tested for that. But
> anything else supported by flow dissection should work.
> 
> v2: Use skb_flow_dissect_flow_keys() directly so that other tunneling
>     can be supported through flow dissection (per Nikolay Aleksandrov).
> v3: Remove accidental inclusion of ports in the hash keys and clarify
>     the documentation (Nikolay Alexandrov).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Hi,

Do you plan to add IPv6 support? Would be good to have the same features
in both stacks.

Also, we have tests for these sysctls under
tools/testing/selftests/net/forwarding/router_multipath.sh

Can you add a test for this change as well? You'll probably need to
create a new file given the topology created by router_multipath.sh does
not include tunnels.

Thanks
