Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA782ECB35
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 08:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbhAGHxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 02:53:40 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54566 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbhAGHxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 02:53:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C64E320573;
        Thu,  7 Jan 2021 08:52:56 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0StHjRa6RPI0; Thu,  7 Jan 2021 08:52:56 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 531E620571;
        Thu,  7 Jan 2021 08:52:56 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 7 Jan 2021 08:52:51 +0100
Received: from cell (10.182.7.209) by mbx-essen-02.secunet.de (10.53.40.198)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 7 Jan 2021
 08:52:50 +0100
Received: (nullmailer pid 16045 invoked by uid 1000);
        Thu, 07 Jan 2021 07:52:50 -0000
Date:   Thu, 7 Jan 2021 08:52:50 +0100
From:   Christian Perle <christian.perle@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <steffen.klassert@secunet.com>,
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net 3/3] net: ip: always refragment ip defragmented
 packets
Message-ID: <20210107075250.GA16010@cell>
Reply-To: <christian.perle@secunet.com>
References: <20210105121208.GA11593@cell>
 <20210105231523.622-1-fw@strlen.de>
 <20210105231523.622-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210105231523.622-4-fw@strlen.de>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Florian,

On Wed, Jan 06, 2021 at 00:15:23 +0100, Florian Westphal wrote:

> Force refragmentation as per original sizes unconditionally so ip tunnel
> will encapsulate the fragments instead.
[...]
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 89fff5f59eea..2ed0b01f72f0 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -302,7 +302,7 @@ static int __ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *
>  	if (skb_is_gso(skb))
>  		return ip_finish_output_gso(net, sk, skb, mtu);
>  
> -	if (skb->len > mtu || (IPCB(skb)->flags & IPSKB_FRAG_PMTU))
> +	if (skb->len > mtu || IPCB(skb)->frag_max_size)
>  		return ip_fragment(net, sk, skb, mtu, ip_finish_output2);
>  
>  	return ip_finish_output2(net, sk, skb);
> -- 
> 2.26.2

Did some tests yesterday and I can confirm that this patch fixes the
problem for both IPIP tunnel and XFRM tunnel interfaces.

Thanks for the fix!
  Christian Perle
-- 
Christian Perle
Senior Berater / Senior Consultant
Netzwerk- und Client-Sicherheit / Network & Client Security
Öffentliche Auftraggeber / Public Authorities
secunet Security Networks AG

Tel.: +49 201 54 54-3533, Fax: +49 201 54 54-1323
E-Mail: christian.perle@secunet.com
Ammonstraße 74, 01067 Dresden, Deutschland
www.secunet.com

secunet Security Networks AG
Sitz: Kurfürstenstraße 58, 45138 Essen, Deutschland
Amtsgericht Essen HRB 13615
Vorstand: Axel Deininger (Vors.), Torsten Henn, Dr. Kai Martius, Thomas Pleines
Aufsichtsratsvorsitzender: Ralf Wintergerst
