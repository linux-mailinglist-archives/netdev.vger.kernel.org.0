Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C428642EFC
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfFLSja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:39:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:21282 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbfFLSja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 14:39:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 11:39:29 -0700
X-ExtLoop1: 1
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.153])
  by orsmga002.jf.intel.com with ESMTP; 12 Jun 2019 11:39:23 -0700
Subject: Re: [PATCH bpf-next] net: Don't uninstall an XDP program when none is
 installed
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190612161405.24064-1-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <fab294a1-ab48-cc48-8240-3ef4f1dcaf9f@intel.com>
Date:   Wed, 12 Jun 2019 20:39:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612161405.24064-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-12 18:14, Maxim Mikityanskiy wrote:
> dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
> XDP program. It means that the driver's ndo_bpf can be called with
> XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
> case happens if the user runs `ip link set eth0 xdp off` when there is
> no XDP program attached.
> 
> The drivers typically perform some heavy operations on XDP_SETUP_PROG,
> so they all have to handle this case internally to return early if it
> happens. This patch puts this check into the kernel code, so that all
> drivers will benefit from it.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
> Björn, please take a look at this, Saeed told me you were doing
> something related, but I couldn't find it. If this fix is already
> covered by your work, please tell about that.
>

Yeah, I'm trying make the query code more generic (pull common work out
from the drivers). However, my patch set is still not done (I'll try to
get a v4 out this week), but your improvement is!

I don't see why this should be held back because of my still not
finished work. I like this.

Acked-by: Björn Töpel <bjorn.topel@intel.com>


>   net/core/dev.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 66f7508825bd..68b3e3320ceb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8089,6 +8089,9 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>   			bpf_prog_put(prog);
>   			return -EINVAL;
>   		}
> +	} else {
> +		if (!__dev_xdp_query(dev, bpf_op, query))
> +			return 0;
>   	}
>   
>   	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
> 
