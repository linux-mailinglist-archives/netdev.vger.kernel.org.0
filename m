Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7409313547F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 09:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgAIIkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 03:40:13 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49762 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgAIIkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 03:40:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8CB982057B;
        Thu,  9 Jan 2020 09:40:11 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id m1kul0U9wsLv; Thu,  9 Jan 2020 09:40:10 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5BB2F20539;
        Thu,  9 Jan 2020 09:40:10 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 Jan 2020
 09:40:10 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 06E74318037D;
 Thu,  9 Jan 2020 09:40:10 +0100 (CET)
Date:   Thu, 9 Jan 2020 09:40:09 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec 2/2] xfrm interface: fix packet tx through
 bpf_redirect()
Message-ID: <20200109084009.GA8621@gauss3.secunet.de>
References: <20191231165654.19434-1-nicolas.dichtel@6wind.com>
 <20191231165654.19434-3-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191231165654.19434-3-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 31, 2019 at 05:56:54PM +0100, Nicolas Dichtel wrote:
> With an ebpf program that redirects packets through a xfrm interface,
> packets are dropped because no dst is attached to skb.
> 
> This could also be reproduced with an AF_PACKET socket, with the following
> python script (xfrm1 is a xfrm interface):
> 
>  import socket
>  send_s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, 0)
>  # scapy
>  # p = IP(src='10.100.0.2', dst='10.200.0.1')/ICMP(type='echo-request')
>  # raw(p)
>  req = b'E\x00\x00\x1c\x00\x01\x00\x00@\x01e\xb2\nd\x00\x02\n\xc8\x00\x01\x08\x00\xf7\xff\x00\x00\x00\x00'
>  send_s.sendto(req, ('xfrm1', 0x800, 0, 0))
> 
> It was also not possible to send an ip packet through an AF_PACKET socket
> because a LL header was expected. Let's remove those LL header constraints.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  net/xfrm/xfrm_interface.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index 7ac1542feaf8..55978a1501ec 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -343,6 +343,7 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct xfrm_if *xi = netdev_priv(dev);
>  	struct net_device_stats *stats = &xi->dev->stats;
> +	struct dst_entry *dst = skb_dst(skb);
>  	struct flowi fl;
>  	int ret;
>  
> @@ -352,10 +353,26 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
>  	case htons(ETH_P_IPV6):
>  		xfrm_decode_session(skb, &fl, AF_INET6);
>  		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
> +		if (!dst) {
> +			dst = ip6_route_output(dev_net(dev), NULL, &fl.u.ip6);
> +			if (dst->error) {
> +				dst_release(dst);
> +				goto tx_err;
> +			}
> +			skb_dst_set(skb, dst);
> +		}
>  		break;
>  	case htons(ETH_P_IP):
>  		xfrm_decode_session(skb, &fl, AF_INET);
>  		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
> +		if (!dst) {
> +			struct rtable *rt = __ip_route_output_key(dev_net(dev),
> +								  &fl.u.ip4);
> +
> +			if (IS_ERR(rt))
> +				goto tx_err;

With this change, the 'if (!dst)' in xfrmi_xmit2() is meaningless
and we don't handle this error as a link failure anymore.

Please make sure that the error path is not changed.
