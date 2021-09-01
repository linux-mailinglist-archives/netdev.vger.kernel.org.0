Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E73B3FD0C5
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbhIABgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:36:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241192AbhIABf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:35:59 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1811XehG109648
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=RfUZ5FB87PQySaK1ZlWJjmdxprZonbgwZOIlXvJOuTk=;
 b=UG9Kz0Yixfb/2rxnXt7+fO6TZ9MbnimGD8WM40B5ZoJc4RGCGIEZ8LeJtU76cyjt8t7F
 R2fyjj2t8UArS0ckAerT7DECnIGa8Ym/7BWjXc0S3tnRxDUWSwr+IapbhmyHhSudyf3m
 zxw3NZg8Usyhsxoq5h+VcgqXP7tgYS/ucMkBsQ6HrR39DalWMwqPnfSap1a5w5uCrjgM
 1BX6Wfsi8bmw/8xcfOxqBdWwMv6EmP+3Nhtwik04CPXf/Rc33bjoq/J50MwTsz85dkkX
 XqK8FvCqkdzpyashz3ousWrrfYdsWffU3KMt3DSqzH+BVUNd+IvP+D4G+8L7HhGO0gWG 0A== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3assas17v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:35:03 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811Sjfp000912
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:35:02 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3aqcscuchq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:35:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811Z1sd51708260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:35:01 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F22811206F;
        Wed,  1 Sep 2021 01:35:01 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD89011206B;
        Wed,  1 Sep 2021 01:35:00 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:35:00 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:35:00 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 8/9] ibmvnic: Reuse rx pools when possible
In-Reply-To: <20210901000812.120968-9-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-9-sukadev@linux.ibm.com>
Message-ID: <065db146d9ddbd13db667355fd902e2e@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R_3AZUYeDnJS4BHUsFiXCJNV_YrDC-yW
X-Proofpoint-GUID: R_3AZUYeDnJS4BHUsFiXCJNV_YrDC-yW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2109010007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> Rather than releasing the rx pools on and reallocating them on every
> reset, reuse the rx pools unless the pool parameters (number of pools,
> size of each pool or size of each buffer in a pool) have changed.
> 
> If the pool parameters changed, then release the old pools (if any)
> and allocate new ones.
> 
> Specifically release rx pools, if:
> 	- adapter is removed,
> 	- pool parameters change during reset,
> 	- we encounter an error when opening the adapter in response
> 	  to a user request (in ibmvnic_open()).
> 
> and don't release them:
> 	- in __ibmvnic_close() or
> 	- on errors in __ibmvnic_open()
> 
> in the hope that we can reuse them on the next reset.
> 
> With these, reset_rx_pools() can be dropped because its optimzation is
> now included in init_rx_pools() itself.
> 
> cleanup_rx_pools() releases all the skbs associated with the pool and
> is called from ibmvnic_cleanup(), which is called on every reset. Since
> we want to reuse skbs across resets, move cleanup_rx_pools() out of
> ibmvnic_cleanup() and call it only when user closes the adapter.
> 
> Add two new adapter fields, ->prev_rx_buf_sz, ->prev_rx_pool_size to
> keep track of the previous values and use them to decide whether to
> reuse or realloc the pools.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 183 +++++++++++++++++++----------
>  drivers/net/ethernet/ibm/ibmvnic.h |   3 +
>  2 files changed, 122 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1bb5996c4313..ebd525b6fc87 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -368,20 +368,27 @@ static void replenish_rx_pool(struct
> ibmvnic_adapter *adapter,
>  	 * be 0.
>  	 */
>  	for (i = ind_bufp->index; i < count; ++i) {
> -		skb = netdev_alloc_skb(adapter->netdev, pool->buff_size);
> +		index = pool->free_map[pool->next_free];
> +
> +		/* We maybe reusing the skb from earlier resets. Allocate
> +		 * only if necessary. But since the LTB may have changed
> +		 * during reset (see init_rx_pools()), update LTB below
> +		 * even if reusing skb.
> +		 */
> +		skb = pool->rx_buff[index].skb;
>  		if (!skb) {
> -			dev_err(dev, "Couldn't replenish rx buff\n");
> -			adapter->replenish_no_mem++;
> -			break;
> +			skb = netdev_alloc_skb(adapter->netdev,
> +					       pool->buff_size);
> +			if (!skb) {
> +				dev_err(dev, "Couldn't replenish rx buff\n");
> +				adapter->replenish_no_mem++;
> +				break;
> +			}
>  		}
> 
> -		index = pool->free_map[pool->next_free];
>  		pool->free_map[pool->next_free] = IBMVNIC_INVALID_MAP;
>  		pool->next_free = (pool->next_free + 1) % pool->size;
> 
> -		if (pool->rx_buff[index].skb)
> -			dev_err(dev, "Inconsistent free_map!\n");
> -
>  		/* Copy the skb to the long term mapped DMA buffer */
>  		offset = index * pool->buff_size;
>  		dst = pool->long_term_buff.buff + offset;
> @@ -532,45 +539,6 @@ static int init_stats_token(struct
> ibmvnic_adapter *adapter)
>  	return 0;
>  }
> 
> -static int reset_rx_pools(struct ibmvnic_adapter *adapter)
> -{
> -	struct ibmvnic_rx_pool *rx_pool;
> -	u64 buff_size;
> -	int rx_scrqs;
> -	int i, j, rc;
> -
> -	if (!adapter->rx_pool)
> -		return -1;
> -
> -	buff_size = adapter->cur_rx_buf_sz;
> -	rx_scrqs = adapter->num_active_rx_pools;
> -	for (i = 0; i < rx_scrqs; i++) {
> -		rx_pool = &adapter->rx_pool[i];
> -
> -		netdev_dbg(adapter->netdev, "Re-setting rx_pool[%d]\n", i);
> -
> -		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> -		rc = alloc_long_term_buff(adapter,
> -					  &rx_pool->long_term_buff,
> -					  rx_pool->size * rx_pool->buff_size);
> -		if (rc)
> -			return rc;
> -
> -		for (j = 0; j < rx_pool->size; j++)
> -			rx_pool->free_map[j] = j;
> -
> -		memset(rx_pool->rx_buff, 0,
> -		       rx_pool->size * sizeof(struct ibmvnic_rx_buff));
> -
> -		atomic_set(&rx_pool->available, 0);
> -		rx_pool->next_alloc = 0;
> -		rx_pool->next_free = 0;
> -		rx_pool->active = 1;
> -	}
> -
> -	return 0;
> -}
> -
>  /**
>   * Release any rx_pools attached to @adapter.
>   * Safe to call this multiple times - even if no pools are attached.
> @@ -589,6 +557,7 @@ static void release_rx_pools(struct
> ibmvnic_adapter *adapter)
>  		netdev_dbg(adapter->netdev, "Releasing rx_pool[%d]\n", i);
> 
>  		kfree(rx_pool->free_map);
> +
>  		free_long_term_buff(adapter, &rx_pool->long_term_buff);
> 
>  		if (!rx_pool->rx_buff)
> @@ -607,8 +576,53 @@ static void release_rx_pools(struct
> ibmvnic_adapter *adapter)
>  	kfree(adapter->rx_pool);
>  	adapter->rx_pool = NULL;
>  	adapter->num_active_rx_pools = 0;
> +	adapter->prev_rx_pool_size = 0;
> +}
> +
> +/**
> + * Return true if we can reuse the existing rx pools.
> + * NOTE: This assumes that all pools have the same number of buffers
> + *       which is the case currently. If that changes, we must fix 
> this.
> + */
> +static bool reuse_rx_pools(struct ibmvnic_adapter *adapter)
> +{
> +	u64 old_num_pools, new_num_pools;
> +	u64 old_pool_size, new_pool_size;
> +	u64 old_buff_size, new_buff_size;
> +
> +	if (!adapter->rx_pool)
> +		return false;
> +
> +	old_num_pools = adapter->num_active_rx_pools;
> +	new_num_pools = adapter->req_rx_queues;
> +
> +	old_pool_size = adapter->prev_rx_pool_size;
> +	new_pool_size = adapter->req_rx_add_entries_per_subcrq;
> +
> +	old_buff_size = adapter->prev_rx_buf_sz;
> +	new_buff_size = adapter->cur_rx_buf_sz;
> +
> +	/* Require buff size to be exactly same for now */
> +	if (old_buff_size != new_buff_size)
> +		return false;
> +
> +	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
> +		return true;
> +
> +	if (old_num_pools < adapter->min_rx_queues ||
> +	    old_num_pools > adapter->max_rx_queues ||
> +	    old_pool_size < adapter->min_rx_add_entries_per_subcrq ||
> +	    old_pool_size > adapter->max_rx_add_entries_per_subcrq)
> +		return false;
> +
> +	return true;
>  }
> 
> +/**
> + * Initialize the set of receiver pools in the adapter. Reuse existing
> + * pools if possible. Otherwise allocate a new set of pools before
> + * initializing them.
> + */
>  static int init_rx_pools(struct net_device *netdev)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
> @@ -619,10 +633,18 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  	u64 buff_size;
>  	int i, j;
> 
> -	num_pools = adapter->num_active_rx_scrqs;
>  	pool_size = adapter->req_rx_add_entries_per_subcrq;
> +	num_pools = adapter->req_rx_queues;
>  	buff_size = adapter->cur_rx_buf_sz;
> 
> +	if (reuse_rx_pools(adapter)) {
> +		dev_dbg(dev, "Reusing rx pools\n");
> +		goto update_ltb;
> +	}
> +
> +	/* Allocate/populate the pools. */
> +	release_rx_pools(adapter);
> +
>  	adapter->rx_pool = kcalloc(num_pools,
>  				   sizeof(struct ibmvnic_rx_pool),
>  				   GFP_KERNEL);
> @@ -646,14 +668,12 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  		rx_pool->size = pool_size;
>  		rx_pool->index = i;
>  		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> -		rx_pool->active = 1;
> 
>  		rx_pool->free_map = kcalloc(rx_pool->size, sizeof(int),
>  					    GFP_KERNEL);
>  		if (!rx_pool->free_map) {
>  			dev_err(dev, "Couldn't alloc free_map %d\n", i);
> -			release_rx_pools(adapter);
> -			return -1;
> +			goto out_release;
>  		}
> 
>  		rx_pool->rx_buff = kcalloc(rx_pool->size,
> @@ -661,25 +681,58 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  					   GFP_KERNEL);
>  		if (!rx_pool->rx_buff) {
>  			dev_err(dev, "Couldn't alloc rx buffers\n");
> -			release_rx_pools(adapter);
> -			return -1;
> +			goto out_release;
>  		}
> +	}
> +
> +	adapter->prev_rx_pool_size = pool_size;
> +	adapter->prev_rx_buf_sz = adapter->cur_rx_buf_sz;
> +
> +update_ltb:
> +	for (i = 0; i < num_pools; i++) {
> +		rx_pool = &adapter->rx_pool[i];
> +		dev_dbg(dev, "Updating LTB for rx pool %d [%d, %d]\n",
> +			i, rx_pool->size, rx_pool->buff_size);
> 
>  		if (alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
> -					 rx_pool->size * rx_pool->buff_size)) {
> -			release_rx_pools(adapter);
> -			return -1;
> -		}
> +					 rx_pool->size * rx_pool->buff_size))
> +			goto out;
> +
> +		for (j = 0; j < rx_pool->size; ++j) {
> +			struct ibmvnic_rx_buff *rx_buff;
> 
> -		for (j = 0; j < rx_pool->size; ++j)
>  			rx_pool->free_map[j] = j;
> 
> +			/* NOTE: Don't clear rx_buff->skb here - will leak
> +			 * memory! replenish_rx_pool() will reuse skbs or
> +			 * allocate as necessary.
> +			 */
> +			rx_buff = &rx_pool->rx_buff[j];
> +			rx_buff->dma = 0;
> +			rx_buff->data = 0;
> +			rx_buff->size = 0;
> +			rx_buff->pool_index = 0;
> +		}
> +
> +		/* Mark pool "empty" so replenish_rx_pools() will
> +		 * update the LTB info for each buffer
> +		 */
>  		atomic_set(&rx_pool->available, 0);
>  		rx_pool->next_alloc = 0;
>  		rx_pool->next_free = 0;
> +		/* replenish_rx_pool() may have called deactivate_rx_pools()
> +		 * on failover. Ensure pool is active now.
> +		 */
> +		rx_pool->active = 1;
>  	}
> -
>  	return 0;
> +out_release:
> +	release_rx_pools(adapter);
> +out:
> +	/* We failed to allocate one or more LTBs or map them on the VIOS.
> +	 * Hold onto the pools and any LTBs that we did allocate/map.
> +	 */
> +	return -1;
>  }
> 
>  static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
> @@ -1053,7 +1106,6 @@ static void release_resources(struct
> ibmvnic_adapter *adapter)
>  	release_vpd_data(adapter);
> 
>  	release_tx_pools(adapter);
> -	release_rx_pools(adapter);
> 
>  	release_napi(adapter);
>  	release_login_buffer(adapter);
> @@ -1326,6 +1378,7 @@ static int ibmvnic_open(struct net_device 
> *netdev)
>  		if (rc) {
>  			netdev_err(netdev, "failed to initialize resources\n");
>  			release_resources(adapter);
> +			release_rx_pools(adapter);
>  			goto out;
>  		}
>  	}
> @@ -1455,7 +1508,6 @@ static void ibmvnic_cleanup(struct net_device 
> *netdev)
>  	ibmvnic_napi_disable(adapter);
>  	ibmvnic_disable_irqs(adapter);
> 
> -	clean_rx_pools(adapter);
>  	clean_tx_pools(adapter);
>  }
> 
> @@ -1490,6 +1542,7 @@ static int ibmvnic_close(struct net_device 
> *netdev)
> 
>  	rc = __ibmvnic_close(netdev);
>  	ibmvnic_cleanup(netdev);
> +	clean_rx_pools(adapter);
> 
>  	return rc;
>  }
> @@ -2218,7 +2271,6 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  		    !adapter->rx_pool ||
>  		    !adapter->tso_pool ||
>  		    !adapter->tx_pool) {
> -			release_rx_pools(adapter);
>  			release_tx_pools(adapter);
>  			release_napi(adapter);
>  			release_vpd_data(adapter);
> @@ -2235,9 +2287,10 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  				goto out;
>  			}
> 
> -			rc = reset_rx_pools(adapter);
> +			rc = init_rx_pools(netdev);
>  			if (rc) {
> -				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
> +				netdev_dbg(netdev,
> +					   "init rx pools failed (%d)\n",
>  					   rc);
>  				goto out;
>  			}
> @@ -5573,6 +5626,7 @@ static int ibmvnic_probe(struct vio_dev *dev,
> const struct vio_device_id *id)
>  	init_completion(&adapter->reset_done);
>  	init_completion(&adapter->stats_done);
>  	clear_bit(0, &adapter->resetting);
> +	adapter->prev_rx_buf_sz = 0;
> 
>  	init_success = false;
>  	do {
> @@ -5673,6 +5727,7 @@ static void ibmvnic_remove(struct vio_dev *dev)
>  	unregister_netdevice(netdev);
> 
>  	release_resources(adapter);
> +	release_rx_pools(adapter);
>  	release_sub_crqs(adapter, 1);
>  	release_crq_queue(adapter);
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index e97f1aa98c05..b73a1b812368 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -986,7 +986,10 @@ struct ibmvnic_adapter {
>  	u32 num_active_rx_napi;
>  	u32 num_active_tx_scrqs;
>  	u32 num_active_tx_pools;
> +
> +	u32 prev_rx_pool_size;
>  	u32 cur_rx_buf_sz;
> +	u32 prev_rx_buf_sz;
> 
>  	struct tasklet_struct tasklet;
>  	enum vnic_state state;
