Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853F32D0908
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 02:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgLGB43 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 6 Dec 2020 20:56:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:23948 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgLGB42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 20:56:28 -0500
IronPort-SDR: 3R1E2/jVG2aiPjM6THEXssd52ayDXnQncLpkhNFYgtG0HbiuL9f7jKo+lbUPVa/GDmyvrlssOj
 0D+f1EEWhnmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="171059316"
X-IronPort-AV: E=Sophos;i="5.78,398,1599548400"; 
   d="scan'208";a="171059316"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 17:55:48 -0800
IronPort-SDR: a6Z98o16Q9vmI4WSuvjgJSCGCKKknLx3GQyOhR31BV7HM4n3JfvUWy7gNt215H8JW1ppw27thX
 VmVN5j2Wt5CA==
X-IronPort-AV: E=Sophos;i="5.78,398,1599548400"; 
   d="scan'208";a="362918747"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.16.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 17:55:48 -0800
Date:   Sun, 6 Dec 2020 17:55:47 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ice: fix array overflow on receiving too many
 fragments for a packet
Message-ID: <20201206175547.00005aa9@intel.com>
In-Reply-To: <20201207011415.463-1-ruc_zhangxiaohui@163.com>
References: <20201207011415.463-1-ruc_zhangxiaohui@163.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaohui Zhang wrote:

> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> 
> If the hardware receives an oversized packet with too many rx fragments,
> skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
> This becomes especially visible if it corrupts the freelist pointer of
> a slab page.

As I replied to the ionic patch, please justify this with how you found
it and how you reproduced a problem. Resend the patches as a series so
we can discuss them as one change.

> 
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index eae75260f..f0f034fa5 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -823,8 +823,12 @@ ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
>  
>  	if (!size)
>  		return;
> -	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
> +	struct skb_shared_info *shinfo = skb_shinfo(skb);
> +
> +	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
> +		skb_add_rx_frag(skb, shinfo, rx_buf->page,
>  			rx_buf->page_offset, size, truesize);
> +	}

The driver is using 2kB receive buffers, and can chain them together up
to a max receive size of 9126 bytes (or so), so how can we receive more
than 18 fragments? Please explain your logic

>  
>  	/* page is being used so we must update the page offset */
>  	ice_rx_buf_adjust_pg_offset(rx_buf, truesize);

Your patch doesn't compile. You must compile test and explain your
patches better.

  CC [M]  drivers/net/ethernet/intel/ice//ice_main.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_controlq.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_common.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_nvm.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_switch.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_sched.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_base.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_lib.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_txrx_lib.o
  CC [M]  drivers/net/ethernet/intel/ice//ice_txrx.o
drivers/net/ethernet/intel/ice//ice_txrx.c: In function ‘ice_add_rx_frag’:
drivers/net/ethernet/intel/ice//ice_txrx.c:829:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
  829 |  struct skb_shared_info *shinfo = skb_shinfo(skb);
      |  ^~~~~~
drivers/net/ethernet/intel/ice//ice_txrx.c:832:24: warning: passing argument 2 of ‘skb_add_rx_frag’ makes integer from pointer without a cast [-Wint-conversion]
  832 |   skb_add_rx_frag(skb, shinfo, rx_buf->page,
      |                        ^~~~~~
      |                        |
      |                        struct skb_shared_info *
In file included from ./include/linux/if_ether.h:19,
                 from ./include/uapi/linux/ethtool.h:19,
                 from ./include/linux/ethtool.h:18,
                 from ./include/linux/netdevice.h:37,
                 from ./include/trace/events/xdp.h:8,
                 from ./include/linux/bpf_trace.h:5,
                 from drivers/net/ethernet/intel/ice//ice_txrx.c:8:
./include/linux/skbuff.h:2182:47: note: expected ‘int’ but argument is of type ‘struct skb_shared_info *’
 2182 | void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
      |                                           ~~~~^
