Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2231F17940A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgCDPto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:49:44 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:53675 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgCDPto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:49:44 -0500
Received: from [10.193.177.132] (lakshmi-pc.asicdesigners.com [10.193.177.132] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 024FnVXZ012622;
        Wed, 4 Mar 2020 07:49:31 -0800
Subject: Re: [PATCH net-next v3 1/6] cxgb4/chcr : Register to tls add and del
 callback
To:     Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-2-rohitm@chelsio.com>
 <57eb8055-a4ad-1afd-b4f4-07bbeaa2b6f6@mellanox.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <97ae4b0b-6ffb-9864-493b-159f581f7809@chelsio.com>
Date:   Wed, 4 Mar 2020 21:19:30 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <57eb8055-a4ad-1afd-b4f4-07bbeaa2b6f6@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,

On 01/03/20 2:06 PM, Boris Pismenny wrote:
> Hi Rohit,
>
> On 2/29/2020 3:24 AM, Rohit Maheshwari wrote:
>> A new macro is defined to enable ktls tx offload support on Chelsio
>> T6 adapter. And if this macro is enabled, cxgb4 will send mailbox to
>> enable or disable ktls settings on HW.
>> In chcr, enabled tx offload flag in netdev and registered tls_dev_add
>> and tls_dev_del.
>>
>> v1->v2:
>> - mark tcb state to close in tls_dev_del.
>> - u_ctx is now picked from adapter structure.
>> - clear atid in case of failure.
>> - corrected ULP_CRYPTO_KTLS_INLINE value.
>>
>> v2->v3:
>> - add empty line after variable declaration.
>> - local variable declaration in reverse christmas tree ordering.
>>
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>> ---
> ...
>> +
>> +/*
>> + * chcr_ktls_dev_add:  call back for tls_dev_add.
>> + * Create a tcb entry for TP. Also add l2t entry for the connection. And
>> + * generate keys & save those keys locally.
>> + * @netdev - net device.
>> + * @tls_cts - tls context.
>> + * @direction - TX/RX crypto direction
>> + * return: SUCCESS/FAILURE.
>> + */
>> +static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
>> +			     enum tls_offload_ctx_dir direction,
>> +			     struct tls_crypto_info *crypto_info,
>> +			     u32 start_offload_tcp_sn)
>> +{
>> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
>> +	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
>> +	struct chcr_ktls_info *tx_info;
>> +	struct dst_entry *dst;
>> +	struct adapter *adap;
>> +	struct port_info *pi;
>> +	struct neighbour *n;
>> +	u8 daaddr[16];
>> +	int ret = -1;
>> +
>> +	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
>> +
>> +	pi = netdev_priv(netdev);
>> +	adap = pi->adapter;
>> +	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
>> +		pr_err("not expecting for RX direction\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +	if (tx_ctx->chcr_info) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
>> +	if (!tx_info) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	spin_lock_init(&tx_info->lock);
>> +
>> +	/* clear connection state */
>> +	spin_lock(&tx_info->lock);
>> +	tx_info->connection_state = KTLS_CONN_CLOSED;
>> +	spin_unlock(&tx_info->lock);
>> +
>> +	tx_info->sk = sk;
>> +	/* initialize tid and atid to -1, 0 is a also a valid id. */
>> +	tx_info->tid = -1;
>> +	tx_info->atid = -1;
>> +
>> +	tx_info->adap = adap;
>> +	tx_info->netdev = netdev;
>> +	tx_info->tx_chan = pi->tx_chan;
>> +	tx_info->smt_idx = pi->smt_idx;
>> +	tx_info->port_id = pi->port_id;
>> +
>> +	tx_info->rx_qid = chcr_get_first_rx_qid(adap);
>> +	if (unlikely(tx_info->rx_qid < 0))
>> +		goto out2;
>> +
>> +	tx_info->prev_seq = start_offload_tcp_sn;
>> +	tx_info->tcp_start_seq_number = start_offload_tcp_sn;
>> +
>> +	/* get peer ip */
>> +	if (sk->sk_family == AF_INET ||
>> +	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
>> +	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
>> +		memcpy(daaddr, &sk->sk_daddr, 4);
>> +	} else {
>> +		goto out2;
>> +	}
>> +
>> +	/* get the l2t index */
>> +	dst = sk_dst_get(sk);
>> +	if (!dst) {
>> +		pr_err("DST entry not found\n");
>> +		goto out2;
>> +	}
>> +	n = dst_neigh_lookup(dst, daaddr);
>> +	if (!n || !n->dev) {
>> +		pr_err("neighbour not found\n");
>> +		dst_release(dst);
>> +		goto out2;
>> +	}
>> +	tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);
> I see that you make an effort to obtain the the L2 tunnel, but did you test it? I would expect that offload would fail for such a connection as the KTLS code would not find the lower device with the offload capability..
>
> If this doesn't work, better remove it, until the stack supports such functionality. Then, you wouldn't need to retrospectively obtain these parameters. Instead, you could just implement the proper flow by working with the L2 tunnel.
This is not l2 tunnel related. This is L2 table index used by HW to decide,
based on destination MAC, which physical port to be used to send a 
packet out.
>> +
>> +	neigh_release(n);
>> +	dst_release(dst);
>> +
>> +	if (!tx_info->l2te) {
>> +		pr_err("l2t entry not found\n");
>> +		goto out2;
>> +	}
>> +
>> +	tx_ctx->chcr_info = tx_info;
>> +
>> +	/* create a filter and call cxgb4_l2t_send to send the packet out, which
>> +	 * will take care of updating l2t entry in hw if not already done.
>> +	 */
>> +	ret = chcr_setup_connection(sk, tx_info);
>> +	if (ret)
>> +		goto out2;
>> +
>> +	return 0;
>> +out2:
>> +	kvfree(tx_info);
>> +out:
>> +	return ret;
>> +}
>> +
> ...
