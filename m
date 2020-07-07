Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAF921750F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgGGRYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:24:10 -0400
Received: from mail.katalix.com ([3.9.82.81]:42788 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGRYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:24:10 -0400
Received: from localhost (unknown [IPv6:2a02:8010:6359:1:21b:21ff:fe6a:7e96])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 7ADBB9533B;
        Tue,  7 Jul 2020 18:24:08 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1594142648; bh=mum5NEgr7Jh0rNReTQ/gld1vNq8eAdiu0R9j/8eGwmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wolJgzpW2VcxoPOJWjkScj0RWhSGt6lY2E5bOWS59gPbzAbUI0eV9ixYBTZc7MDWb
         9gl3Y9zMXMCV9LzwR1sVWv2M5YkSkcIERfHlr52pJRpzA8Q1kEA5UkVAYe/aG/fa9W
         4zs8DYNNomMYykK03bmgWAP5dt5BM9TOUTp8IWa11qAmiHwj7aXEngn4DbTGs/pB6X
         x+h0njsUBALKbBSLRZylf8m9jYBZr6e5QEAhKdhVkjr/G2kNA4Zw0lGKMpET7OXY3Q
         2jCuphB6ciIL3R1x+v0hCdp0eHN40rb04i/swuAGs9/ZsHLIzD3R5hmEl+1v4mFi5Z
         SPqgpsVpaHJsA==
Date:   Tue, 7 Jul 2020 18:24:08 +0100
From:   James Chapman <jchapman@katalix.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net] l2tp: remove skb_dst_set() from l2tp_xmit_skb()
Message-ID: <20200707172408.GA22308@katalix.com>
References: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On  Tue, Jul 07, 2020 at 02:02:32 +0800, Xin Long wrote:
> In the tx path of l2tp, l2tp_xmit_skb() calls skb_dst_set() to set
> skb's dst. However, it will eventually call inet6_csk_xmit() or
> ip_queue_xmit() where skb's dst will be overwritten by:
> 
>    skb_dst_set_noref(skb, dst);
> 
> without releasing the old dst in skb. Then it causes dst/dev refcnt leak:
> 
>   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> 
> This can be reproduced by simply running:
> 
>   # modprobe l2tp_eth && modprobe l2tp_ip
>   # sh ./tools/testing/selftests/net/l2tp.sh
> 
> So before going to inet6_csk_xmit() or ip_queue_xmit(), skb's dst
> should be dropped. This patch is to fix it by removing skb_dst_set()
> from l2tp_xmit_skb() and moving skb_dst_drop() into l2tp_xmit_core().
> 
> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/l2tp/l2tp_core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index fcb53ed..df133c24 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1028,6 +1028,7 @@ static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
>  
>  	/* Queue the packet to IP for output */
>  	skb->ignore_df = 1;
> +	skb_dst_drop(skb);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	if (l2tp_sk_is_v6(tunnel->sock))
>  		error = inet6_csk_xmit(tunnel->sock, skb, NULL);
> @@ -1099,10 +1100,6 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
>  		goto out_unlock;
>  	}
>  
> -	/* Get routing info from the tunnel socket */
> -	skb_dst_drop(skb);
> -	skb_dst_set(skb, sk_dst_check(sk, 0));
> -
>  	inet = inet_sk(sk);
>  	fl = &inet->cork.fl;
>  	switch (tunnel->encap) {
> -- 
> 2.1.0
> 

This patch doesn't seem right.

For ipv4, the skb dst is used by skb_rtable. In ip_queue_xmit, if
skb_rtable returns a route, it follows the packet_routed label and
skb_dst_set_noref isn't done. Your patch is forcing every ipv4 l2tp
packet to be routed, which isn't what we want.

I ran l2tp.sh and found that the issue happens only for l2tp tests
that use IPv6 IPSec in a routed topology.

Perhaps the real problem is that l2tp shouldn't be using
inet6_csk_xmit and should instead use ip6_xmit?

Please hold off on applying this patch while I look into it.
