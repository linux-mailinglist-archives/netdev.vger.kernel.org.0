Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B61B3B47
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgDVJ03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:26:29 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43134 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgDVJ02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 05:26:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B74E6204B4;
        Wed, 22 Apr 2020 11:26:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W5YlNvvaGQiH; Wed, 22 Apr 2020 11:26:26 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 450222008D;
        Wed, 22 Apr 2020 11:26:26 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Apr 2020 11:26:26 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 22 Apr
 2020 11:26:25 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B9B8A3180096; Wed, 22 Apr 2020 11:26:25 +0200 (CEST)
Date:   Wed, 22 Apr 2020 11:26:25 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] xfrm: call xfrm_output_gso when inner_protocol is
 set in xfrm_output
Message-ID: <20200422092625.GX13121@gauss3.secunet.de>
References: <79c8488570575776c9e2f776e9f6000f591713b5.1587390669.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <79c8488570575776c9e2f776e9f6000f591713b5.1587390669.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 09:51:09PM +0800, Xin Long wrote:
> An use-after-free crash can be triggered when sending big packets over
> vxlan over esp with esp offload enabled:
> 
>   [] BUG: KASAN: use-after-free in ipv6_gso_pull_exthdrs.part.8+0x32c/0x4e0
>   [] Call Trace:
>   []  dump_stack+0x75/0xa0
>   []  kasan_report+0x37/0x50
>   []  ipv6_gso_pull_exthdrs.part.8+0x32c/0x4e0
>   []  ipv6_gso_segment+0x2c8/0x13c0
>   []  skb_mac_gso_segment+0x1cb/0x420
>   []  skb_udp_tunnel_segment+0x6b5/0x1c90
>   []  inet_gso_segment+0x440/0x1380
>   []  skb_mac_gso_segment+0x1cb/0x420
>   []  esp4_gso_segment+0xae8/0x1709 [esp4_offload]
>   []  inet_gso_segment+0x440/0x1380
>   []  skb_mac_gso_segment+0x1cb/0x420
>   []  __skb_gso_segment+0x2d7/0x5f0
>   []  validate_xmit_skb+0x527/0xb10
>   []  __dev_queue_xmit+0x10f8/0x2320 <---
>   []  ip_finish_output2+0xa2e/0x1b50
>   []  ip_output+0x1a8/0x2f0
>   []  xfrm_output_resume+0x110e/0x15f0
>   []  __xfrm4_output+0xe1/0x1b0
>   []  xfrm4_output+0xa0/0x200
>   []  iptunnel_xmit+0x5a7/0x920
>   []  vxlan_xmit_one+0x1658/0x37a0 [vxlan]
>   []  vxlan_xmit+0x5e4/0x3ec8 [vxlan]
>   []  dev_hard_start_xmit+0x125/0x540
>   []  __dev_queue_xmit+0x17bd/0x2320  <---
>   []  ip6_finish_output2+0xb20/0x1b80
>   []  ip6_output+0x1b3/0x390
>   []  ip6_xmit+0xb82/0x17e0
>   []  inet6_csk_xmit+0x225/0x3d0
>   []  __tcp_transmit_skb+0x1763/0x3520
>   []  tcp_write_xmit+0xd64/0x5fe0
>   []  __tcp_push_pending_frames+0x8c/0x320
>   []  tcp_sendmsg_locked+0x2245/0x3500
>   []  tcp_sendmsg+0x27/0x40
> 
> As on the tx path of vxlan over esp, skb->inner_network_header would be
> set on vxlan_xmit() and xfrm4_tunnel_encap_add(), and the later one can
> overwrite the former one. It causes skb_udp_tunnel_segment() to use a
> wrong skb->inner_network_header, then the issue occurs.
> 
> This patch is to fix it by calling xfrm_output_gso() instead when the
> inner_protocol is set, in which gso_segment of inner_protocol will be
> done first.
> 
> While at it, also improve some code around.
> 
> Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks a lot Xin!
