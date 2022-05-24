Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BA0532465
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbiEXHt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiEXHty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:49:54 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04184994CF;
        Tue, 24 May 2022 00:49:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VEH4lSL_1653378587;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VEH4lSL_1653378587)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 May 2022 15:49:48 +0800
Date:   Tue, 24 May 2022 15:49:46 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next] net/smc:introduce 1RTT to SMC
Message-ID: <YoyOGlG2kVe4VA4m@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 02:52:07PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Hi Karsten,
> 
> We are promoting SMC-R to the field of cloud computing, dues to the
> particularity of business on the cloud, the scale and the types of
> customer applications are unpredictable. As a participant of SMC-R, we
> also hope that SMC-R can cover more application scenarios. Therefore,
> many connection problems are exposed during this time. There are two
> main issue, one is that the establishment of a single connection takes
> longer than that of the TCP, another is that the degree of concurrency
> is low under multi-connection processing. This patch set is mainly
> optimized for the first issue, and the follow-up of the second issue
> will be synchronized in the future.
> 
> In terms of communication process, under current implement, a TCP
> three-way handshake only needs 1-RTT time, while SMC-R currently
> requires 4-RTT times, including 2-RTT over IP(TCP handshake, SMC
> proposal & accept ) and 2-RTT over IB ( two times RKEY exchange), which
> is most influential factor affecting connection established time at the
> moment.
> 
> We have noticed that single network interface card is mainstream on the
> cloud, dues to the advantages of cloud deployment costs and the cloud's
> own disaster recovery support. On the other hand, the emergence of RoCE
> LAG technology makes us no longer need to deal with multiple RDMA
> network interface cards by ourselves,  just like NIC bonding does. In
> Alibaba, Roce LAG is widely used for RDMA.

I think this is an interesting topic whether we need SMC-level link
redundancy. I agreed with that RoCE LAG and RDMA in cloud vendors handle
redundancy and failover in the lower layer, and do it transparently for
SMC.

So let's move on, if a RDMA device has redundancy ability, we could make
SMC simpler by give an option for user-space or based on the device
capability (if we have this flag). This allows under layer to ensure the
reliability of link group.

As RFC 7609 mentioned, we should do some extra work for reliability to
add link. It should be an optional work if the device have capability
for redundancy, and make link group simpler and faster (for the
so-called SMC-2RTT in this RFC).

I also notice that RFC 7609 is released on August 2015, which is earlier
than RoCE LAG. RoCE LAG is provided after ConnectX-3/ConnectX-3 Pro in
kernel 4.0, and is available in 2017. And cloud vendors' RDMA adapters,
such as Alibaba Elastic RDMA adapter in [1].

Given that, I propose whether the second link can be used as an option
in newly created link group. Also, if it is possible, RFC 7609 can be
updated or extend it for this nowadays case.

Looking forward for your message, Karsten, D. Wythe and folks.

[1] https://lore.kernel.org/linux-rdma/20220523075528.35017-1-chengyou@linux.alibaba.com/

Thanks,
Tony Lu
 
> In that case, SMC-R have only one single link, if so, the RKEY LLC
> messages that to perform information exchange in all links are no longer
> needed, the SMC Proposal & accept has already complete the exchange of
> all information needed. So we think that we can remove the RKEY exchange
> in that case, which will save us 2-RTT over IB. We call it as SMC-R 2-RTT.
> 
> On the other hand, we can use TCP fast open, carry the SMC proposal data
> by TCP SYN message, reduce the time that the SMC waits for the TCP
> connection to be established. This will save us another 1-RTT over IP.
> 
> Based on the above two viewpoints, in this scenario, we can compress the
> communication process of SMC-R into 1-RTT over IP, so that we can
> theoretically obtain a time close to that of TCP connection
> establishment. We call it as SMC-R 1-RTT. Of course, the specific results
> will also be affected by the implementation.
> 
> In our test environment, we host two VMs on the same host for wrk/nginx
> tests, used a script similar to the following to performing test:
> 
> Client.sh
> 
> conn=$1
> thread=$2
> 
> wrk -H ¡®Connection: Close¡¯ -c ${conn} -t ${thread} -d 10
> 
> Server.sh
> 
> sysctl -w net.ipv4.tcp_fastopen=3
> smc_run nginx
> 
> Statistic shows that:
> 
> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
> |type|args  |   -c1 -t1     |   -c2 -t1     |   -c5 -t1      |  -c10 -t1    |   -c200 -t1    |  -c200 -t4    |  -c2000 -t8   |
> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
> |next-next  |   4188.5qps   |   5942.04qps  |   7621.81qps   |  7678.62qps  |   8204.94qps   |  8457.57qps   |  5687.60qps   |
> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
> |SMC-2RTT   |   4730.17qps  |   7394.85qps  |   11532.78qps  |  12016.22qps |   11520.81qps  |  11391.36qps  |  10364.41qps  |
> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
> |SMC-1RTT   |   5702.77qps  |   9645.18qps  |   11899.20qps  |  12005.16qps |   11536.67qps  |  11420.87qps  |  10392.4qps   |
> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+-
> |TCP        |   6415.74qps  |   11034.10qps |   16716.21qps  |  22217.06qps |   35926.74qps  |  117460.qps   |  120291.16qps |
> +-----------+---------------+---------------+----------------+--------------+----------------+---------------+---------------+
> 
> It can clearly be seen that:
> 
> 1. In step by step short-link scenarios ( -c1 -t1 ), SMC-R after
> optimization can reach 88% of TCP. There are still many implementation
> details that can be optimized, we hope to optimize the performance of
> SMC in this scenario to 90% of TCP.
> 
> 2. The problem is very serious in the scenario of multi-threading and
> multi-connection, the worst case is only 10% of TCP. Even though the
> SMC-1RTT has certain optimizations for this scenario, it is clear that
> the bottleneck is not here. We are doing some prototyping to solve this,
> we hope to reach 60% of TCP in multi-threading and multi-connection
> scenarios, and SMC-1RTT is the important prerequisite for upper limit of
> subsequent optimization.
> 
> In this patch set, we had only completed a simple prototype, only make
> sure SMC-1RTT can works.
> 
> Sincerely, we are looking forward for you comments, please
> let us know if you have any suggestions.
> 
> Thanks.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  net/smc/af_smc.c   | 72 ++++++++++++++++++++++++++++++++++++++++++------------
>  net/smc/smc.h      |  8 ++++++
>  net/smc/smc_clc.c  | 32 ++++++++++++++++++++----
>  net/smc/smc_core.c |  2 ++
>  net/smc/smc_pnet.c |  4 +--
>  net/smc/smc_pnet.h |  3 +++
>  6 files changed, 98 insertions(+), 23 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 1a556f4..bf646d1 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -492,7 +492,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
>  			     struct smc_buf_desc *rmb_desc)
>  {
>  	struct smc_link_group *lgr = link->lgr;
> -	int i, rc = 0;
> +	int i, lnk = 0, rc = 0;
>  
>  	rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
>  	if (rc)
> @@ -507,14 +507,20 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
>  		rc = smcr_link_reg_rmb(&lgr->lnk[i], rmb_desc);
>  		if (rc)
>  			goto out;
> +		/* available link count inc */
> +		lnk++;
>  	}
>  
> -	/* exchange confirm_rkey msg with peer */
> -	rc = smc_llc_do_confirm_rkey(link, rmb_desc);
> -	if (rc) {
> -		rc = -EFAULT;
> -		goto out;
> +	/* do not exchange confirm_rkey msg since there are only one link */
> +	if (lnk > 1) {
> +		/* exchange confirm_rkey msg with peer */
> +		rc = smc_llc_do_confirm_rkey(link, rmb_desc);
> +		if (rc) {
> +			rc = -EFAULT;
> +			goto out;
> +		}
>  	}
> +
>  	rmb_desc->is_conf_rkey = true;
>  out:
>  	mutex_unlock(&lgr->llc_conf_mutex);
> @@ -932,6 +938,31 @@ static int smc_find_rdma_device(struct smc_sock *smc, struct smc_init_info *ini)
>  	return 0;
>  }
>  
> +/* just prototype code
> + * since tcp connect has not happen, using route to perform smc_pnet_find_roce_by_pnetid
> + */
> +static int smc_find_rdma_device_with_dst(struct smc_sock *smc, struct smc_init_info *ini)
> +{
> +	struct sock *tsk = smc->clcsock->sk;
> +	struct rtable *rt;
> +
> +	rt = ip_route_output(sock_net(tsk), smc->remote_address.v4.sin_addr.s_addr,
> +			     0, 0, 0);
> +
> +	if (IS_ERR(rt))
> +		return -ECONNRESET;
> +
> +	smc_pnet_find_roce_by_pnetid(rt->dst.dev, ini);
> +	__builtin_prefetch(&ini->ib_dev->mac[ini->ib_port - 1]);
> +
> +	if (!ini->check_smcrv2 && !ini->ib_dev)
> +		return SMC_CLC_DECL_NOSMCRDEV;
> +	if (ini->check_smcrv2 && !ini->smcrv2.ib_dev_v2)
> +		return SMC_CLC_DECL_NOSMCRDEV;
> +
> +	return 0;
> +}
> +
>  /* check if there is an ISM device available for this connection. */
>  /* called for connect and listen */
>  static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
> @@ -1019,13 +1050,17 @@ static int smc_find_proposal_devices(struct smc_sock *smc,
>  
>  	/* check if there is an rdma device available */
>  	if (!(ini->smcr_version & SMC_V1) ||
> -	    smc_find_rdma_device(smc, ini))
> +	    smc_find_rdma_device_with_dst(smc, ini))
>  		ini->smcr_version &= ~SMC_V1;
>  	/* else RDMA is supported for this connection */
>  
>  	ini->smc_type_v1 = smc_indicated_type(ini->smcd_version & SMC_V1,
>  					      ini->smcr_version & SMC_V1);
>  
> +	/* just prototype, do this for simple */
> +	ini->smc_type_v2 = SMC_TYPE_N;
> +	return rc;
> +
>  	/* check if there is an ism v2 device available */
>  	if (!(ini->smcd_version & SMC_V2) ||
>  	    !smc_ism_is_v2_capable() ||
> @@ -1492,11 +1527,7 @@ static void smc_connect_work(struct work_struct *work)
>  		smc->sk.sk_err = smc->clcsock->sk->sk_err;
>  	} else if ((1 << smc->clcsock->sk->sk_state) &
>  					(TCPF_SYN_SENT | TCPF_SYN_RECV)) {
> -		rc = sk_stream_wait_connect(smc->clcsock->sk, &timeo);
> -		if ((rc == -EPIPE) &&
> -		    ((1 << smc->clcsock->sk->sk_state) &
> -					(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)))
> -			rc = 0;
> +		rc = 0;
>  	}
>  	release_sock(smc->clcsock->sk);
>  	lock_sock(&smc->sk);
> @@ -1580,9 +1611,10 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>  		rc = -EALREADY;
>  		goto out;
>  	}
> -	rc = kernel_connect(smc->clcsock, addr, alen, flags);
> -	if (rc && rc != -EINPROGRESS)
> -		goto out;
> +
> +	/* copy remote address backup */
> +	memcpy(&smc->remote_address.ss, addr, alen);
> +	rc = -EINPROGRESS;
>  
>  	if (smc->use_fallback) {
>  		sock->state = rc ? SS_CONNECTING : SS_CONNECTED;
> @@ -2452,9 +2484,17 @@ static int smc_listen(struct socket *sock, int backlog)
>  {
>  	struct sock *sk = sock->sk;
>  	struct smc_sock *smc;
> -	int rc;
> +	int rc, val;
>  
>  	smc = smc_sk(sk);
> +
> +	/* enable server clcsock tcp fastopen.
> +	 * just a proto type code, magic number 5 for no reason
> +	 */
> +	val = 5;
> +	smc->clcsock->ops->setsockopt(smc->clcsock, SOL_TCP,
> +				      TCP_FASTOPEN, KERNEL_SOCKPTR(&val), sizeof(val));
> +
>  	lock_sock(sk);
>  
>  	rc = -EINVAL;
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 5ed765e..ef18894 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -261,6 +261,14 @@ struct smc_sock {				/* smc sock container */
>  	int			fallback_rsn;	/* reason for fallback */
>  	u32			peer_diagnosis; /* decline reason from peer */
>  	atomic_t                queued_smc_hs;  /* queued smc handshakes */
> +
> +	union {
> +		struct sockaddr		addr;
> +		struct sockaddr_in	v4;
> +		struct sockaddr_in6	v6;
> +		struct sockaddr_storage ss;
> +	} remote_address;
> +
>  	struct inet_connection_sock_af_ops		af_ops;
>  	const struct inet_connection_sock_af_ops	*ori_af_ops;
>  						/* original af ops */
> diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
> index f9f3f59..f944c67 100644
> --- a/net/smc/smc_clc.c
> +++ b/net/smc/smc_clc.c
> @@ -20,6 +20,7 @@
>  #include <net/addrconf.h>
>  #include <net/sock.h>
>  #include <net/tcp.h>
> +#include <net/route.h>
>  
>  #include "smc.h"
>  #include "smc_core.h"
> @@ -486,8 +487,7 @@ static int smc_clc_prfx_set4_rcu(struct dst_entry *dst, __be32 ipv4,
>  		return -ENODEV;
>  
>  	in_dev_for_each_ifa_rcu(ifa, in_dev) {
> -		if (!inet_ifa_match(ipv4, ifa))
> -			continue;
> +		/* delete this for simple, just prototype code*/
>  		prop->prefix_len = inet_mask_len(ifa->ifa_mask);
>  		prop->outgoing_subnet = ifa->ifa_address & ifa->ifa_mask;
>  		/* prop->ipv6_prefixes_cnt = 0; already done by memset before */
> @@ -528,10 +528,10 @@ static int smc_clc_prfx_set6_rcu(struct dst_entry *dst,
>  
>  /* retrieve and set prefixes in CLC proposal msg */
>  static int smc_clc_prfx_set(struct socket *clcsock,
> +			    struct dst_entry *dst,
>  			    struct smc_clc_msg_proposal_prefix *prop,
>  			    struct smc_clc_ipv6_prefix *ipv6_prfx)
>  {
> -	struct dst_entry *dst = sk_dst_get(clcsock->sk);
>  	struct sockaddr_storage addrs;
>  	struct sockaddr_in6 *addr6;
>  	struct sockaddr_in *addr;
> @@ -802,7 +802,8 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version)
>  }
>  
>  /* send CLC PROPOSAL message across internal TCP socket */
> -int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
> +int smc_clc_send_proposal_with_nexthop(struct smc_sock *smc,
> +				       struct dst_entry *dst, struct smc_init_info *ini)
>  {
>  	struct smc_clc_smcd_v2_extension *smcd_v2_ext;
>  	struct smc_clc_msg_proposal_prefix *pclc_prfx;
> @@ -838,7 +839,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
>  
>  	/* retrieve ip prefixes for CLC proposal msg */
>  	if (ini->smc_type_v1 != SMC_TYPE_N) {
> -		rc = smc_clc_prfx_set(smc->clcsock, pclc_prfx, ipv6_prfx);
> +		rc = smc_clc_prfx_set(smc->clcsock, dst, pclc_prfx, ipv6_prfx);
>  		if (rc) {
>  			if (ini->smc_type_v2 == SMC_TYPE_N) {
>  				kfree(pclc);
> @@ -961,6 +962,11 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
>  	}
>  	vec[i].iov_base = trl;
>  	vec[i++].iov_len = sizeof(*trl);
> +
> +	msg.msg_flags	|= MSG_FASTOPEN;
> +	msg.msg_name	= &smc->remote_address.addr;
> +	msg.msg_namelen = sizeof(struct sockaddr_in);
> +
>  	/* due to the few bytes needed for clc-handshake this cannot block */
>  	len = kernel_sendmsg(smc->clcsock, &msg, vec, i, plen);
>  	if (len < 0) {
> @@ -975,6 +981,22 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
>  	return reason_code;
>  }
>  
> +int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
> +{
> +	struct sock *tsk = smc->clcsock->sk;
> +	struct rtable *rt;
> +	int rc;
> +
> +	rt = ip_route_output(sock_net(tsk), smc->remote_address.v4.sin_addr.s_addr,
> +			     0, 0, 0);
> +
> +	if (IS_ERR(rt))
> +		return -ECONNRESET;
> +
> +	rc = smc_clc_send_proposal_with_nexthop(smc, &rt->dst, ini);
> +	return rc;
> +}
> +
>  /* build and send CLC CONFIRM / ACCEPT message */
>  static int smc_clc_send_confirm_accept(struct smc_sock *smc,
>  				       struct smc_clc_msg_accept_confirm_v2 *clc_v2,
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index f40f6ed..ef5e5411 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1765,6 +1765,8 @@ int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
>  	int rc = 0;
>  
>  	ini->vlan_id = 0;
> +	/* just for simple , prototype code */
> +	return 0;
>  	if (!dst) {
>  		rc = -ENOTCONN;
>  		goto out;
> diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
> index 7055ed1..6aa3304 100644
> --- a/net/smc/smc_pnet.c
> +++ b/net/smc/smc_pnet.c
> @@ -1064,8 +1064,8 @@ static void smc_pnet_find_rdma_dev(struct net_device *netdev,
>   * If nothing found, check pnetid table.
>   * If nothing found, try to use handshake device
>   */
> -static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
> -					 struct smc_init_info *ini)
> +void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
> +				  struct smc_init_info *ini)
>  {
>  	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
>  	struct net *net;
> diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
> index 80a88ee..2ffaf22 100644
> --- a/net/smc/smc_pnet.h
> +++ b/net/smc/smc_pnet.h
> @@ -67,4 +67,7 @@ void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
>  			    struct smc_ib_device *known_dev);
>  bool smc_pnet_is_ndev_pnetid(struct net *net, u8 *pnetid);
>  bool smc_pnet_is_pnetid_set(u8 *pnetid);
> +
> +void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
> +				  struct smc_init_info *ini);
>  #endif
> -- 
> 1.8.3.1
