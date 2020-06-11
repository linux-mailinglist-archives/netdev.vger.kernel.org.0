Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006A11F6D78
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 20:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgFKS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 14:27:52 -0400
Received: from ja.ssi.bg ([178.16.129.10]:47994 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726673AbgFKS1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 14:27:52 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 05BIRIRE005406;
        Thu, 11 Jun 2020 21:27:20 +0300
Date:   Thu, 11 Jun 2020 21:27:18 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     YangYuxi <yx.atom1@gmail.com>
cc:     wensong@linux-vs.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: avoid drop first packet to reuse conntrack
In-Reply-To: <20200611092849.GA13977@VM_111_229_centos>
Message-ID: <alpine.LFD.2.22.394.2006112034170.3254@ja.home.ssi.bg>
References: <20200611092849.GA13977@VM_111_229_centos>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-410261613-1591900041=:3254"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-410261613-1591900041=:3254
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Thu, 11 Jun 2020, YangYuxi wrote:

> Since commit f719e3754ee ("ipvs: drop first packet
> to redirect conntrack"), when a new TCP connection
> meet the conditions that need reschedule, the first
> syn packet is dropped, this cause one second latency
> for the new connection, more discussion about this
> problem can easy seach from google, such as:
> 
> 1)One second connection delay in masque
> https://marc.info/?t=151683118100004&r=1&w=2
> 
> 2)IPVS low throughput #70747
> https://github.com/kubernetes/kubernetes/issues/70747
> 
> 3)Apache Bench can fill up ipvs service proxy in seconds #544
> https://github.com/cloudnativelabs/kube-router/issues/544
> 
> 4)Additional 1s latency in `host -> service IP -> pod`
> https://github.com/kubernetes/kubernetes/issues/90854

	Such delays occur only on collision, say some
client IP creates many connections that lead to
reusing same client port...

> The root cause is when the old session is expired, the
> conntrack related to the session is dropped by
> ip_vs_conn_drop_conntrack. The code is as follows:
> ```
> static void ip_vs_conn_expire(struct timer_list *t)
> {
> ...
> 
>                 if ((cp->flags & IP_VS_CONN_F_NFCT) &&
>                     !(cp->flags & IP_VS_CONN_F_ONE_PACKET)) {
>                         /* Do not access conntracks during subsys cleanup
>                          * because nf_conntrack_find_get can not be used after
>                          * conntrack cleanup for the net.
>                          */
>                         smp_rmb();
>                         if (ipvs->enable)
>                                 ip_vs_conn_drop_conntrack(cp);
>                 }
> ...
> }
> ```
> As the code show, only if the condition  (cp->flags & IP_VS_CONN_F_NFCT)
> is true, ip_vs_conn_drop_conntrack will be called.
> So we solve this bug by following steps:

	Not exactly a bug, we do the delay intentionally.

> 1) erase the IP_VS_CONN_F_NFCT flag (it is safely because no packets will
>    use the old session)
> 2) call ip_vs_conn_expire_now to release the old session, then the related
>    conntrack will not be dropped

	The IPVS connection table allows the newly created
connection to have priority when next packets lookup for
connection. That is why we delay only when conntracks are
used. When they are not used, we can create IPVS connection
to different real server by creating collision in original
direction in the IPVS table. When reply packet is received
it will find its connection.

	IPVS does not create duplicate conntracks. When
packet is received it will hit existing conntrack or
new conntrack will be created. This is what happens in
Netfilter in original direction. Note that active FTP
can create connection also for packet from real server.

	IPVS simply alters the reply tuple while processing
this first packet and only when conntrack is not confirmed
yet, because that is the only possible time to insert the
both tuples into netfilter hash table:

CIP->VIP(orig),VIP->CIP(reply) becomes CIP->VIP,RIP->CIP
CIP: Client IP, VIP: Virtual IP, RIP: Real Server IP

	After the new reply tuple is determined, it can not
be changed after the first packet. That is why we have to
drop the old conntrack. Then, reply direction will match
packets from the correct real server.

> 3) then ipvs unnecessary to drop the first syn packet,
>    it just continue to pass the syn packet to the next process,
>    create a new ipvs session, and the new session will related to
>    the old conntrack(which is reopened by conntrack as a new one),
>    the next whole things is just as normal as that the old session
>    isn't used to exist.

	If we leave the old conntrack, say with reply
tuple RIP1->CIP but the IPVS scheduling selects different
RIP2 for the new IPVS connection which uses the old
conntrack due to the equal original tuple, we create
inconsistency.

	We can not be sure if admins use connmarks,
state matching (-m state), passive FTP (which requires
conntracks in IPVS), so we can not just go and use
the old conntrack which points to wrong real server.

	How exactly are relayed the reply packets from
real servers in your tests? Do you have NF SNAT rules to
translate the source addresses? Also, it will be good
to know what is the effect on the passive FTP.

> This patch has been verified on our thousands of kubernets node servers on Tencent Inc.
> Signed-off-by: YangYuxi <yx.atom1@gmail.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index aa6a603a2425..2f750145172f 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2086,11 +2086,11 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  		}
>  
>  		if (resched) {
> +			if (uses_ct)
> +				cp->flags &= ~IP_VS_CONN_F_NFCT;
>  			if (!atomic_read(&cp->n_control))
>  				ip_vs_conn_expire_now(cp);
>  			__ip_vs_conn_put(cp);
> -			if (uses_ct)
> -				return NF_DROP;
>  			cp = NULL;
>  		}
>  	}
> -- 

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-410261613-1591900041=:3254--
