Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868743FD0C7
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbhIABhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:37:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241559AbhIABhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:37:09 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1811WVXV036389
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:36:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=5M9p6Q3ydo9mc/Uxsq4G6vZX2xxtbaY0JA+43t2Z/9I=;
 b=kNbJAqtUFb1Af7w+qjWTNMXw0r/MEcHvdAsnFKrZAKTQ3wRNvsZ/MdQ8R6GCtPj2vv2P
 6RoS9rzIa1BYGL1h5ISTddbyeh7aCH1awGFzJN5e8u0PpWpMmsMNBW2DxzIcdTM1ro9X
 wkiy4XTL1TNY7G3LHyMGw7UsM9Xn1R6a+W5qMXRKEL2s8wg9/OLIHZpwXSgbh/tQtPWK
 +JHngViJQOCM9K+g62fMg1cahCJrkFtec0wBni4jE5AD7VJJJCGLMezQdWQ9shPXt6UX
 GWeJbJK2UGgUnSTbzx8vghlGlUOQtLunNpc7hrPQaNaYPCZwIyWtn3x6LRwEOhruUJO3 cQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asywkr30c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:36:13 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811Rmw7017577
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:36:12 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3astd106fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:36:12 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811aBIQ39059724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:36:11 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8496CAE05F;
        Wed,  1 Sep 2021 01:36:11 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 303A0AE064;
        Wed,  1 Sep 2021 01:36:11 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:36:11 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:36:10 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 9/9] ibmvnic: Reuse tx pools when possible
In-Reply-To: <20210901000812.120968-10-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-10-sukadev@linux.ibm.com>
Message-ID: <e2de1bc7305c74f8388a2f938a414a3a@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Ayvh7pSwXp3zm5HwdFrDv9l1v--2Inc
X-Proofpoint-ORIG-GUID: 1Ayvh7pSwXp3zm5HwdFrDv9l1v--2Inc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> Rather than releasing the tx pools on every close and reallocating
> them on open, reuse the tx pools unless the pool parameters (number
> of pools, size of each pool or size of each buffer in a pool) have
> changed.
> 
> If the pool parameters changed, then release the old pools (if
> any) and allocate new ones.
> 
> Specifically release tx pools, if:
> 	- adapter is removed,
> 	- pool parameters change during reset,
> 	- we encounter an error when opening the adapter in response
> 	  to a user request (in ibmvnic_open()).
> 
> and don't release them:
> 	- in __ibmvnic_close() or
> 	- on errors in __ibmvnic_open()
> 
> in the hope that we can reuse them during this or next reset.
> 
> With these changes reset_tx_pools() can be dropped because its
> optimization is now included in init_tx_pools() itself.
> 
> cleanup_tx_pools() releases all the skbs associated with the pool and
> is called from ibmvnic_cleanup(), which is called on every reset. Since
> we want to reuse skbs across resets, move cleanup_tx_pools() out of
> ibmvnic_cleanup() and call it only when user closes the adapter.
> 
> Add two new adapter fields, ->prev_mtu, ->prev_tx_pool_size to track 
> the
> previous values and use them to decide whether to reuse or realloc the
> pools.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 201 +++++++++++++++++++----------
>  drivers/net/ethernet/ibm/ibmvnic.h |   2 +
>  2 files changed, 133 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index ebd525b6fc87..8c422a717e88 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -735,53 +735,6 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  	return -1;
>  }
> 
> -static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
> -			     struct ibmvnic_tx_pool *tx_pool)
> -{
> -	struct ibmvnic_long_term_buff *ltb;
> -	int rc, i;
> -
> -	ltb = &tx_pool->long_term_buff;
> -
> -	rc = alloc_long_term_buff(adapter, ltb, ltb->size);
> -	if (rc)
> -		return rc;
> -
> -	memset(tx_pool->tx_buff, 0,
> -	       tx_pool->num_buffers *
> -	       sizeof(struct ibmvnic_tx_buff));
> -
> -	for (i = 0; i < tx_pool->num_buffers; i++)
> -		tx_pool->free_map[i] = i;
> -
> -	tx_pool->consumer_index = 0;
> -	tx_pool->producer_index = 0;
> -
> -	return 0;
> -}
> -
> -static int reset_tx_pools(struct ibmvnic_adapter *adapter)
> -{
> -	int tx_scrqs;
> -	int i, rc;
> -
> -	if (!adapter->tx_pool)
> -		return -1;
> -
> -	tx_scrqs = adapter->num_active_tx_pools;
> -	for (i = 0; i < tx_scrqs; i++) {
> -		ibmvnic_tx_scrq_clean_buffer(adapter, adapter->tx_scrq[i]);
> -		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
> -		if (rc)
> -			return rc;
> -		rc = reset_one_tx_pool(adapter, &adapter->tx_pool[i]);
> -		if (rc)
> -			return rc;
> -	}
> -
> -	return 0;
> -}
> -
>  static void release_vpd_data(struct ibmvnic_adapter *adapter)
>  {
>  	if (!adapter->vpd)
> @@ -825,13 +778,13 @@ static void release_tx_pools(struct
> ibmvnic_adapter *adapter)
>  	kfree(adapter->tso_pool);
>  	adapter->tso_pool = NULL;
>  	adapter->num_active_tx_pools = 0;
> +	adapter->prev_tx_pool_size = 0;
>  }
> 
>  static int init_one_tx_pool(struct net_device *netdev,
>  			    struct ibmvnic_tx_pool *tx_pool,
>  			    int pool_size, int buf_size)
>  {
> -	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>  	int i;
> 
>  	tx_pool->tx_buff = kcalloc(pool_size,
> @@ -840,13 +793,12 @@ static int init_one_tx_pool(struct net_device 
> *netdev,
>  	if (!tx_pool->tx_buff)
>  		return -1;
> 
> -	if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
> -				 pool_size * buf_size))
> -		return -1;
> -
>  	tx_pool->free_map = kcalloc(pool_size, sizeof(int), GFP_KERNEL);
> -	if (!tx_pool->free_map)
> +	if (!tx_pool->free_map) {
> +		kfree(tx_pool->tx_buff);
> +		tx_pool->tx_buff = NULL;
>  		return -1;
> +	}
> 
>  	for (i = 0; i < pool_size; i++)
>  		tx_pool->free_map[i] = i;
> @@ -859,6 +811,48 @@ static int init_one_tx_pool(struct net_device 
> *netdev,
>  	return 0;
>  }
> 
> +/**
> + * Return true if we can reuse the existing tx pools, false otherwise
> + * NOTE: This assumes that all pools have the same number of buffers
> + *       which is the case currently. If that changes, we must fix 
> this.
> + */
> +static bool reuse_tx_pools(struct ibmvnic_adapter *adapter)
> +{
> +	u64 old_num_pools, new_num_pools;
> +	u64 old_pool_size, new_pool_size;
> +	u64 old_mtu, new_mtu;
> +
> +	if (!adapter->tx_pool)
> +		return false;
> +
> +	old_num_pools = adapter->num_active_tx_pools;
> +	new_num_pools = adapter->num_active_tx_scrqs;
> +	old_pool_size = adapter->prev_tx_pool_size;
> +	new_pool_size = adapter->req_tx_entries_per_subcrq;
> +	old_mtu = adapter->prev_mtu;
> +	new_mtu = adapter->req_mtu;
> +
> +	/* Require MTU to be exactly same to reuse pools for now */
> +	if (old_mtu != new_mtu)
> +		return false;
> +
> +	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
> +		return true;
> +
> +	if (old_num_pools < adapter->min_tx_queues ||
> +	    old_num_pools > adapter->max_tx_queues ||
> +	    old_pool_size < adapter->min_tx_entries_per_subcrq ||
> +	    old_pool_size > adapter->max_tx_entries_per_subcrq)
> +		return false;
> +
> +	return true;
> +}
> +
> +/**
> + * Initialize the set of transmit pools in the adapter. Reuse existing
> + * pools if possible. Otherwise allocate a new set of pools before
> + * initializing them.
> + */
>  static int init_tx_pools(struct net_device *netdev)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
> @@ -866,7 +860,21 @@ static int init_tx_pools(struct net_device 
> *netdev)
>  	int num_pools;
>  	u64 pool_size;		/* # of buffers in pool */
>  	u64 buff_size;
> -	int i, rc;
> +	int i, j, rc;
> +
> +	num_pools = adapter->req_tx_queues;
> +
> +	/* We must notify the VIOS about the LTB on all resets - but we only
> +	 * need to alloc/populate pools if either the number of buffers or
> +	 * size of each buffer in the pool has changed.
> +	 */
> +	if (reuse_tx_pools(adapter)) {
> +		netdev_dbg(netdev, "Reusing tx pools\n");
> +		goto update_ltb;
> +	}
> +
> +	/* Allocate/populate the pools. */
> +	release_tx_pools(adapter);
> 
>  	pool_size = adapter->req_tx_entries_per_subcrq;
>  	num_pools = adapter->num_active_tx_scrqs;
> @@ -891,6 +899,7 @@ static int init_tx_pools(struct net_device *netdev)
>  	 * allocation, release_tx_pools() will know how many to look for.
>  	 */
>  	adapter->num_active_tx_pools = num_pools;
> +
>  	buff_size = adapter->req_mtu + VLAN_HLEN;
>  	buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> 
> @@ -900,21 +909,73 @@ static int init_tx_pools(struct net_device 
> *netdev)
> 
>  		rc = init_one_tx_pool(netdev, &adapter->tx_pool[i],
>  				      pool_size, buff_size);
> -		if (rc) {
> -			release_tx_pools(adapter);
> -			return rc;
> -		}
> +		if (rc)
> +			goto out_release;
> 
>  		rc = init_one_tx_pool(netdev, &adapter->tso_pool[i],
>  				      IBMVNIC_TSO_BUFS,
>  				      IBMVNIC_TSO_BUF_SZ);
> -		if (rc) {
> -			release_tx_pools(adapter);
> -			return rc;
> -		}
> +		if (rc)
> +			goto out_release;
> +	}
> +
> +	adapter->prev_tx_pool_size = pool_size;
> +	adapter->prev_mtu = adapter->req_mtu;
> +
> +update_ltb:
> +	/* NOTE: All tx_pools have the same number of buffers (which is
> +	 *       same as pool_size). All tso_pools have IBMVNIC_TSO_BUFS
> +	 *       buffers (see calls init_one_tx_pool() for these).
> +	 *       For consistency, we use tx_pool->num_buffers and
> +	 *       tso_pool->num_buffers below.
> +	 */
> +	rc = -1;
> +	for (i = 0; i < num_pools; i++) {
> +		struct ibmvnic_tx_pool *tso_pool;
> +		struct ibmvnic_tx_pool *tx_pool;
> +		u32 ltb_size;
> +
> +		tx_pool = &adapter->tx_pool[i];
> +		ltb_size = tx_pool->num_buffers * tx_pool->buf_size;
> +		if (alloc_long_term_buff(adapter, &tx_pool->long_term_buff,
> +					 ltb_size))
> +			goto out;
> +
> +		dev_dbg(dev, "Updated LTB for tx pool %d [%p, %d, %d]\n",
> +			i, tx_pool->long_term_buff.buff,
> +			tx_pool->num_buffers, tx_pool->buf_size);
> +
> +		tx_pool->consumer_index = 0;
> +		tx_pool->producer_index = 0;
> +
> +		for (j = 0; j < tx_pool->num_buffers; j++)
> +			tx_pool->free_map[j] = j;
> +
> +		tso_pool = &adapter->tso_pool[i];
> +		ltb_size = tso_pool->num_buffers * tso_pool->buf_size;
> +		if (alloc_long_term_buff(adapter, &tso_pool->long_term_buff,
> +					 ltb_size))
> +			goto out;
> +
> +		dev_dbg(dev, "Updated LTB for tso pool %d [%p, %d, %d]\n",
> +			i, tso_pool->long_term_buff.buff,
> +			tso_pool->num_buffers, tso_pool->buf_size);
> +
> +		tso_pool->consumer_index = 0;
> +		tso_pool->producer_index = 0;
> +
> +		for (j = 0; j < tso_pool->num_buffers; j++)
> +			tso_pool->free_map[j] = j;
>  	}
> 
>  	return 0;
> +out_release:
> +	release_tx_pools(adapter);
> +out:
> +	/* We failed to allocate one or more LTBs or map them on the VIOS.
> +	 * Hold onto the pools and any LTBs that we did allocate/map.
> +	 */
> +	return rc;
>  }
> 
>  static void ibmvnic_napi_enable(struct ibmvnic_adapter *adapter)
> @@ -1105,8 +1166,6 @@ static void release_resources(struct
> ibmvnic_adapter *adapter)
>  {
>  	release_vpd_data(adapter);
> 
> -	release_tx_pools(adapter);
> -
>  	release_napi(adapter);
>  	release_login_buffer(adapter);
>  	release_login_rsp_buffer(adapter);
> @@ -1379,6 +1438,7 @@ static int ibmvnic_open(struct net_device 
> *netdev)
>  			netdev_err(netdev, "failed to initialize resources\n");
>  			release_resources(adapter);
>  			release_rx_pools(adapter);
> +			release_tx_pools(adapter);
>  			goto out;
>  		}
>  	}
> @@ -1507,8 +1567,6 @@ static void ibmvnic_cleanup(struct net_device 
> *netdev)
> 
>  	ibmvnic_napi_disable(adapter);
>  	ibmvnic_disable_irqs(adapter);
> -
> -	clean_tx_pools(adapter);
>  }
> 
>  static int __ibmvnic_close(struct net_device *netdev)
> @@ -1543,6 +1601,7 @@ static int ibmvnic_close(struct net_device 
> *netdev)
>  	rc = __ibmvnic_close(netdev);
>  	ibmvnic_cleanup(netdev);
>  	clean_rx_pools(adapter);
> +	clean_tx_pools(adapter);
> 
>  	return rc;
>  }
> @@ -2119,9 +2178,9 @@ static const char *reset_reason_to_string(enum
> ibmvnic_reset_reason reason)
>  static int do_reset(struct ibmvnic_adapter *adapter,
>  		    struct ibmvnic_rwi *rwi, u32 reset_state)
>  {
> +	struct net_device *netdev = adapter->netdev;
>  	u64 old_num_rx_queues, old_num_tx_queues;
>  	u64 old_num_rx_slots, old_num_tx_slots;
> -	struct net_device *netdev = adapter->netdev;
>  	int rc;
> 
>  	netdev_dbg(adapter->netdev,
> @@ -2271,7 +2330,6 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  		    !adapter->rx_pool ||
>  		    !adapter->tso_pool ||
>  		    !adapter->tx_pool) {
> -			release_tx_pools(adapter);
>  			release_napi(adapter);
>  			release_vpd_data(adapter);
> 
> @@ -2280,9 +2338,10 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  				goto out;
> 
>  		} else {
> -			rc = reset_tx_pools(adapter);
> +			rc = init_tx_pools(netdev);
>  			if (rc) {
> -				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
> +				netdev_dbg(netdev,
> +					   "init tx pools failed (%d)\n",
>  					   rc);
>  				goto out;
>  			}
> @@ -5627,6 +5686,7 @@ static int ibmvnic_probe(struct vio_dev *dev,
> const struct vio_device_id *id)
>  	init_completion(&adapter->stats_done);
>  	clear_bit(0, &adapter->resetting);
>  	adapter->prev_rx_buf_sz = 0;
> +	adapter->prev_mtu = 0;
> 
>  	init_success = false;
>  	do {
> @@ -5728,6 +5788,7 @@ static void ibmvnic_remove(struct vio_dev *dev)
> 
>  	release_resources(adapter);
>  	release_rx_pools(adapter);
> +	release_tx_pools(adapter);
>  	release_sub_crqs(adapter, 1);
>  	release_crq_queue(adapter);
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index b73a1b812368..b8e42f67d897 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -967,6 +967,7 @@ struct ibmvnic_adapter {
>  	u64 min_mtu;
>  	u64 max_mtu;
>  	u64 req_mtu;
> +	u64 prev_mtu;
>  	u64 max_multicast_filters;
>  	u64 vlan_header_insertion;
>  	u64 rx_vlan_header_insertion;
> @@ -988,6 +989,7 @@ struct ibmvnic_adapter {
>  	u32 num_active_tx_pools;
> 
>  	u32 prev_rx_pool_size;
> +	u32 prev_tx_pool_size;
>  	u32 cur_rx_buf_sz;
>  	u32 prev_rx_buf_sz;
