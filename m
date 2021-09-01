Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D75E3FD0C4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbhIABf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:35:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241559AbhIABfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:35:20 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1811WS6t066790
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=ijsfr/Mz/tA1vTe4qCHGWEbw5yYmmnNXQl02E+80E/Q=;
 b=E+ZjaFSqWkXohVpAL34jSKg+Gh1JSwEhI+sDs/OKVXLZfJwyIj2E4pvqtDbVtZZPLAE9
 RqZMqTlOzYEzMjPsPGMdRswhHOQFXc74mbzqpzvsEOVCAqW467ylsp7qURtOr2J9LS0/
 GM+k/c5ILj4ZRio1N/XZ3cPhR+SgqB3TgK441GOjf+Uu+SDpjOW/B54950V4kH/4zeLR
 B64Pj+krRG76Ivhc3gX5FyBMFuJ80dlOUVWvYG+mixzep/n3V76LZ0jeO/Kh36PbI7KK
 LFqplVKIHL6k4MSPV5jc1i8nJtipDS77SfAjdIurnLsWJUcEt//zQLneyfv/+1Bdb5zK pA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asy3t917y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:34:24 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811SeLX019741
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:34:23 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3aqcsd3m9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:34:23 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811YM9x12256214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:34:22 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5385EB204D;
        Wed,  1 Sep 2021 01:34:22 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B5EB2025;
        Wed,  1 Sep 2021 01:34:21 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:34:21 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:34:21 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 7/9] ibmvnic: Reuse LTB when possible
In-Reply-To: <20210901000812.120968-8-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-8-sukadev@linux.ibm.com>
Message-ID: <2352d03eea2267df1c95328caea214c1@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0ffgr_c037_K2BZySgHl_mlTMJLaZ0lY
X-Proofpoint-ORIG-GUID: 0ffgr_c037_K2BZySgHl_mlTMJLaZ0lY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> Reuse the long term buffer during a reset as long as its size has
> not changed. If the size has changed, free it and allocate a new
> one of the appropriate size.
> 
> When we do this, alloc_long_term_buff() and reset_long_term_buff()
> become identical. Drop reset_long_term_buff().
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 122 ++++++++++++++---------------
>  1 file changed, 59 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 30153a8bb5ec..1bb5996c4313 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -108,6 +108,8 @@ static int init_crq_queue(struct ibmvnic_adapter 
> *adapter);
>  static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
>  static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter 
> *adapter,
>  					 struct ibmvnic_sub_crq_queue *tx_scrq);
> +static void free_long_term_buff(struct ibmvnic_adapter *adapter,
> +				struct ibmvnic_long_term_buff *ltb);
> 
>  struct ibmvnic_stat {
>  	char name[ETH_GSTRING_LEN];
> @@ -214,23 +216,62 @@ static int ibmvnic_wait_for_completion(struct
> ibmvnic_adapter *adapter,
>  	return -ETIMEDOUT;
>  }
> 
> +/**
> + * Reuse long term buffer unless size has changed.
> + */
> +static bool reuse_ltb(struct ibmvnic_long_term_buff *ltb, int size)
> +{
> +	return (ltb->buff && ltb->size == size);
> +}
> +
> +/**
> + * Allocate a long term buffer of the specified size and notify VIOS.
> + *
> + * If the given @ltb already has the correct size, reuse it. Otherwise 
> if
> + * its non-NULL, free it. Then allocate a new one of the correct size.
> + * Notify the VIOS either way since we may now be working with a new 
> VIOS.
> + *
> + * Allocating larger chunks of memory during resets, specially LPM or 
> under
> + * low memory situations can cause resets to fail/timeout and for LPAR 
> to
> + * lose connectivity. So hold onto the LTB even if we fail to 
> communicate
> + * with the VIOS and reuse it on next open. Free LTB when adapter is 
> closed.
> + */
>  static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
>  				struct ibmvnic_long_term_buff *ltb, int size)
>  {
>  	struct device *dev = &adapter->vdev->dev;
>  	int rc;
> 
> -	ltb->size = size;
> -	ltb->buff = dma_alloc_coherent(dev, ltb->size, &ltb->addr,
> -				       GFP_KERNEL);
> +	if (!reuse_ltb(ltb, size)) {
> +		dev_dbg(dev,
> +			"LTB size changed from 0x%llx to 0x%x, reallocating\n",
> +			 ltb->size, size);
> +		free_long_term_buff(adapter, ltb);
> +	}
> 
> -	if (!ltb->buff) {
> -		dev_err(dev, "Couldn't alloc long term buffer\n");
> -		return -ENOMEM;
> +	if (ltb->buff) {
> +		dev_dbg(dev, "Reusing LTB [map %d, size 0x%llx]\n",
> +			ltb->map_id, ltb->size);
> +	} else {
> +		ltb->buff = dma_alloc_coherent(dev, size, &ltb->addr,
> +					       GFP_KERNEL);
> +		if (!ltb->buff) {
> +			dev_err(dev, "Couldn't alloc long term buffer\n");
> +			return -ENOMEM;
> +		}
> +		ltb->size = size;
> +
> +		ltb->map_id = find_first_zero_bit(adapter->map_ids,
> +						  MAX_MAP_ID);
> +		bitmap_set(adapter->map_ids, ltb->map_id, 1);
> +
> +		dev_dbg(dev,
> +			"Allocated new LTB [map %d, size 0x%llx]\n",
> +			 ltb->map_id, ltb->size);
>  	}
> -	ltb->map_id = find_first_zero_bit(adapter->map_ids,
> -					  MAX_MAP_ID);
> -	bitmap_set(adapter->map_ids, ltb->map_id, 1);
> +
> +	/* Ensure ltb is zeroed - specially when reusing it. */
> +	memset(ltb->buff, 0, ltb->size);
> 
>  	mutex_lock(&adapter->fw_lock);
>  	adapter->fw_done_rc = 0;
> @@ -257,10 +298,7 @@ static int alloc_long_term_buff(struct
> ibmvnic_adapter *adapter,
>  	}
>  	rc = 0;
>  out:
> -	if (rc) {
> -		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
> -		ltb->buff = NULL;
> -	}
> +	/* don't free LTB on communication error - see function header */
>  	mutex_unlock(&adapter->fw_lock);
>  	return rc;
>  }
> @@ -290,43 +328,6 @@ static void free_long_term_buff(struct
> ibmvnic_adapter *adapter,
>  	ltb->map_id = 0;
>  }
> 
> -static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
> -				struct ibmvnic_long_term_buff *ltb)
> -{
> -	struct device *dev = &adapter->vdev->dev;
> -	int rc;
> -
> -	memset(ltb->buff, 0, ltb->size);
> -
> -	mutex_lock(&adapter->fw_lock);
> -	adapter->fw_done_rc = 0;
> -
> -	reinit_completion(&adapter->fw_done);
> -	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
> -	if (rc) {
> -		mutex_unlock(&adapter->fw_lock);
> -		return rc;
> -	}
> -
> -	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
> -	if (rc) {
> -		dev_info(dev,
> -			 "Reset failed, long term map request timed out or aborted\n");
> -		mutex_unlock(&adapter->fw_lock);
> -		return rc;
> -	}
> -
> -	if (adapter->fw_done_rc) {
> -		dev_info(dev,
> -			 "Reset failed, attempting to free and reallocate buffer\n");
> -		free_long_term_buff(adapter, ltb);
> -		mutex_unlock(&adapter->fw_lock);
> -		return alloc_long_term_buff(adapter, ltb, ltb->size);
> -	}
> -	mutex_unlock(&adapter->fw_lock);
> -	return 0;
> -}
> -
>  static void deactivate_rx_pools(struct ibmvnic_adapter *adapter)
>  {
>  	int i;
> @@ -548,18 +549,10 @@ static int reset_rx_pools(struct ibmvnic_adapter 
> *adapter)
> 
>  		netdev_dbg(adapter->netdev, "Re-setting rx_pool[%d]\n", i);
> 
> -		if (rx_pool->buff_size != buff_size) {
> -			free_long_term_buff(adapter, &rx_pool->long_term_buff);
> -			rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> -			rc = alloc_long_term_buff(adapter,
> -						  &rx_pool->long_term_buff,
> -						  rx_pool->size *
> -						  rx_pool->buff_size);
> -		} else {
> -			rc = reset_long_term_buff(adapter,
> -						  &rx_pool->long_term_buff);
> -		}
> -
> +		rx_pool->buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> +		rc = alloc_long_term_buff(adapter,
> +					  &rx_pool->long_term_buff,
> +					  rx_pool->size * rx_pool->buff_size);
>  		if (rc)
>  			return rc;
> 
> @@ -692,9 +685,12 @@ static int init_rx_pools(struct net_device 
> *netdev)
>  static int reset_one_tx_pool(struct ibmvnic_adapter *adapter,
>  			     struct ibmvnic_tx_pool *tx_pool)
>  {
> +	struct ibmvnic_long_term_buff *ltb;
>  	int rc, i;
> 
> -	rc = reset_long_term_buff(adapter, &tx_pool->long_term_buff);
> +	ltb = &tx_pool->long_term_buff;
> +
> +	rc = alloc_long_term_buff(adapter, ltb, ltb->size);
>  	if (rc)
>  		return rc;
