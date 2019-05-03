Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33AA12568
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 02:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfECAXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 20:23:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:11625 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfECAXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 20:23:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 17:23:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,423,1549958400"; 
   d="scan'208";a="140837010"
Received: from samudral-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga006.jf.intel.com with ESMTP; 02 May 2019 17:23:18 -0700
Subject: Re: [RFC bpf-next 5/7] net: add busy-poll support for XDP sockets
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        kevin.laatz@intel.com
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <1556786363-28743-6-git-send-email-magnus.karlsson@intel.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <fa956c59-0715-c9ea-ec50-2b1bee210567@intel.com>
Date:   Thu, 2 May 2019 17:23:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556786363-28743-6-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/2019 1:39 AM, Magnus Karlsson wrote:
> This patch adds busy-poll support for XDP sockets (AF_XDP). With
> busy-poll, the driver is executed in process context by calling the
> poll() syscall. The main advantage with this is that all processing
> occurs on a single core. This eliminates the core-to-core cache
> transfers that occur between the application and the softirqd
> processing on another core, that occurs without busy-poll. From a
> systems point of view, it also provides an advatage that we do not
> have to provision extra cores in the system to handle
> ksoftirqd/softirq processing, as all processing is done on the single
> core that executes the application. The drawback of busy-poll is that
> max throughput seen from a single application will be lower (due to
> the syscall), but on a per core basis it will often be higher as the
> normal mode runs on two cores and busy-poll on a single one.
> 
> The semantics of busy-poll from the application point of view are the
> following:
> 
> * The application is required to call poll() to drive rx and tx
>    processing. There is no guarantee that softirq and interrupts will
>    do this for you.
> 
> * It should be enabled on a per socket basis. No global enablement, i.e.
>    the XDP socket busy-poll will not care about the current
>    /proc/sys/net/core/busy_poll and busy_read global enablement
>    mechanisms.
> 
> * The batch size (how many packets that are processed every time the
>    napi function in the driver is called, i.e. the weight parameter)
>    should be configurable. Currently, the busy-poll size of AF_INET
>    sockets is set to 8, but for AF_XDP sockets this is too small as the
>    amount of processing per packet is much smaller with AF_XDP. This
>    should be configurable on a per socket basis.
> 
> * If you put multiple AF_XDP busy-poll enabled sockets into a poll()
>    call the napi contexts of all of them should be executed. This is in
>    contrast to the AF_INET busy-poll that quits after the fist one that
>    finds any packets. We need all napi contexts to be executed due to
>    the first requirement in this list. The behaviour we want is much more
>    like regular sockets in that all of them are checked in the poll
>    call.
> 
> * Should be possible to mix AF_XDP busy-poll sockets with any other
>    sockets including busy-poll AF_INET ones in a single poll() call
>    without any change to semantics or the behaviour of any of those
>    socket types.
> 
> * As suggested by Maxim Mikityanskiy, poll() will in the busy-poll
>    mode return POLLERR if the fill ring is empty or the completion
>    queue is full.
> 
> Busy-poll support is enabled by calling a new setsockopt called
> XDP_BUSY_POLL_BATCH_SIZE that takes batch size as an argument. A value
> between 1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it off and
> any other value will return an error.
> 
> A typical packet processing rxdrop loop with busy-poll will look something
> like this:
> 
> for (i = 0; i < num_socks; i++) {
>      fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
>      fds[i].events = POLLIN;
> }
> 
> for (;;) {
>      ret = poll(fds, num_socks, 0);
>      if (ret <= 0)
>              continue;
> 
>      for (i = 0; i < num_socks; i++)
>          rx_drop(xsks[i], fds); /* The actual application */
> }
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/net/xdp_sock.h |   3 ++
>   net/xdp/Kconfig        |   1 +
>   net/xdp/xsk.c          | 122 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   net/xdp/xsk_queue.h    |  18 ++++++--
>   4 files changed, 138 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index d074b6d..2e956b37 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -57,7 +57,10 @@ struct xdp_sock {
>   	struct net_device *dev;
>   	struct xdp_umem *umem;
>   	struct list_head flush_node;
> +	unsigned int napi_id_rx;
> +	unsigned int napi_id_tx;
>   	u16 queue_id;
> +	u16 bp_batch_size;
>   	struct xsk_queue *tx ____cacheline_aligned_in_smp;
>   	struct list_head list;
>   	bool zc;
> diff --git a/net/xdp/Kconfig b/net/xdp/Kconfig
> index 0255b33..219baaa 100644
> --- a/net/xdp/Kconfig
> +++ b/net/xdp/Kconfig
> @@ -1,6 +1,7 @@
>   config XDP_SOCKETS
>   	bool "XDP sockets"
>   	depends on BPF_SYSCALL
> +	select NET_RX_BUSY_POLL
>   	default n
>   	help
>   	  XDP sockets allows a channel between XDP programs and
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e886..bd3d0fe 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -22,6 +22,7 @@
>   #include <linux/net.h>
>   #include <linux/netdevice.h>
>   #include <linux/rculist.h>
> +#include <net/busy_poll.h>
>   #include <net/xdp_sock.h>
>   #include <net/xdp.h>
>   
> @@ -302,16 +303,107 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
>   }
>   
> +static unsigned int xsk_check_rx_poll_err(struct xdp_sock *xs)
> +{
> +	return xskq_consumer_empty(xs->umem->fq) ? POLLERR : 0;
> +}
> +
> +static unsigned int xsk_check_tx_poll_err(struct xdp_sock *xs)
> +{
> +	return xskq_producer_full(xs->umem->cq) ? POLLERR : 0;
> +}
> +
> +static bool xsk_busy_loop_end(void *p, unsigned long start_time)
> +{
> +	return true;

This function should be updated to return TRUE on busy poll timeout OR 
it should check for xskq_full_desc on TX and xskq_empty_desc on RX

> +}
> +
