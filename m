Return-Path: <netdev+bounces-8720-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D421725548
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC56A2811A2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09BF6AAA;
	Wed,  7 Jun 2023 07:19:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A3F63D7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:19:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC4391732;
	Wed,  7 Jun 2023 00:19:26 -0700 (PDT)
Received: from [10.156.157.27] (unknown [167.220.238.91])
	by linux.microsoft.com (Postfix) with ESMTPSA id 344CA20BE4AD;
	Wed,  7 Jun 2023 00:19:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 344CA20BE4AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1686122366;
	bh=hC04ECWbb5T3YWmxhrXYUuU9xPByhL7qzku92/Ib+7E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NnCdw/anKSUo1+TfPk0ja10z+B6ASJIuLyypJ3RbYoOdmmcWliNlfVYQHz0m+kOKx
	 xUVA/ciA/FkoVAggzQsXq6iw2aJJqRf/xY2T9XvQ2qIvVIG6cukfwA/hBHDcKJ0UUW
	 /hqewoB2AZskATaRovVmmHpc9dr5WSvJmAavjO0o=
Message-ID: <bb461c30-3eb0-74c0-d637-c4a3bdf84565@linux.microsoft.com>
Date: Wed, 7 Jun 2023 12:49:18 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3] hv_netvsc: Allocate rx indirection table size
 dynamically
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Michael Kelley <mikelley@microsoft.com>,
 "David S. Miller" <davem@davemloft.net>,
 Steen Hegelund <steen.hegelund@microchip.com>,
 Simon Horman <simon.horman@corigine.com>
References: <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
 <5fc413e5-77d2-814d-250a-7ddf8eb6d6ad@linux.microsoft.com>
 <20230529111733.GA21447@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Language: en-US
From: Praveen Kumar <kumarpraveen@linux.microsoft.com>
In-Reply-To: <20230529111733.GA21447@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/29/2023 4:47 PM, Shradha Gupta wrote:
> On Mon, May 29, 2023 at 03:09:49PM +0530, Praveen Kumar wrote:
>> On 5/26/2023 11:32 AM, Shradha Gupta wrote:
>>> Allocate the size of rx indirection table dynamically in netvsc
>>> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
>>> query instead of using a constant value of ITAB_NUM.
>>>
>>> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
>>> Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
>>> Testcases:
>>> 1. ethtool -x eth0 output
>>> 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic
>>> 3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-SRIOV
>>>
>>> ---
>>> Changes in v3:
>>>  * Changed the data type of rx_table_sz to u32
>>>  * Moved the rx indirection table free to rndis_filter_device_remove()
>>>  * Device add will fail with error if not enough memory is available
>>>  * Changed kzmalloc to kcalloc as suggested in checkpatch script
>>>  * Removed redundant log if memory allocation failed.
>>> ---
>>>  drivers/net/hyperv/hyperv_net.h   |  5 ++++-
>>>  drivers/net/hyperv/netvsc_drv.c   | 10 ++++++----
>>>  drivers/net/hyperv/rndis_filter.c | 27 +++++++++++++++++++++++----
>>>  3 files changed, 33 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
>>> index dd5919ec408b..c40868f287a9 100644
>>> --- a/drivers/net/hyperv/hyperv_net.h
>>> +++ b/drivers/net/hyperv/hyperv_net.h
>>> @@ -74,6 +74,7 @@ struct ndis_recv_scale_cap { /* NDIS_RECEIVE_SCALE_CAPABILITIES */
>>>  #define NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2   40
>>>  
>>>  #define ITAB_NUM 128
>>> +#define ITAB_NUM_MAX 256
>>>  
>>>  struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
>>>  	struct ndis_obj_header hdr;
>>> @@ -1034,7 +1035,9 @@ struct net_device_context {
>>>  
>>>  	u32 tx_table[VRSS_SEND_TAB_SIZE];
>>>  
>>> -	u16 rx_table[ITAB_NUM];
>>> +	u16 *rx_table;
>>> +
>>> +	u32 rx_table_sz;
>>>  
>>>  	/* Ethtool settings */
>>>  	u8 duplex;
>>> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
>>> index 0103ff914024..3ba3c8fb28a5 100644
>>> --- a/drivers/net/hyperv/netvsc_drv.c
>>> +++ b/drivers/net/hyperv/netvsc_drv.c
>>> @@ -1747,7 +1747,9 @@ static u32 netvsc_get_rxfh_key_size(struct net_device *dev)
>>>  
>>>  static u32 netvsc_rss_indir_size(struct net_device *dev)
>>>  {
>>> -	return ITAB_NUM;
>>> +	struct net_device_context *ndc = netdev_priv(dev);
>>> +
>>> +	return ndc->rx_table_sz;
>>>  }
>>>  
>>>  static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
>>> @@ -1766,7 +1768,7 @@ static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
>>>  
>>>  	rndis_dev = ndev->extension;
>>>  	if (indir) {
>>> -		for (i = 0; i < ITAB_NUM; i++)
>>> +		for (i = 0; i < ndc->rx_table_sz; i++)
>>>  			indir[i] = ndc->rx_table[i];
>>>  	}
>>>  
>>> @@ -1792,11 +1794,11 @@ static int netvsc_set_rxfh(struct net_device *dev, const u32 *indir,
>>>  
>>>  	rndis_dev = ndev->extension;
>>>  	if (indir) {
>>> -		for (i = 0; i < ITAB_NUM; i++)
>>> +		for (i = 0; i < ndc->rx_table_sz; i++)
>>>  			if (indir[i] >= ndev->num_chn)
>>>  				return -EINVAL;
>>>  
>>> -		for (i = 0; i < ITAB_NUM; i++)
>>> +		for (i = 0; i < ndc->rx_table_sz; i++)
>>>  			ndc->rx_table[i] = indir[i];
>>>  	}
>>>  
>>> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
>>> index eea777ec2541..dc7b9b326690 100644
>>> --- a/drivers/net/hyperv/rndis_filter.c
>>> +++ b/drivers/net/hyperv/rndis_filter.c
>>> @@ -21,6 +21,7 @@
>>>  #include <linux/rtnetlink.h>
>>>  #include <linux/ucs2_string.h>
>>>  #include <linux/string.h>
>>> +#include <linux/slab.h>
>>>  
>>>  #include "hyperv_net.h"
>>>  #include "netvsc_trace.h"
>>> @@ -927,7 +928,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
>>>  	struct rndis_set_request *set;
>>>  	struct rndis_set_complete *set_complete;
>>>  	u32 extlen = sizeof(struct ndis_recv_scale_param) +
>>> -		     4 * ITAB_NUM + NETVSC_HASH_KEYLEN;
>>> +		     4 * ndc->rx_table_sz + NETVSC_HASH_KEYLEN;
>>>  	struct ndis_recv_scale_param *rssp;
>>>  	u32 *itab;
>>>  	u8 *keyp;
>>> @@ -953,7 +954,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
>>>  	rssp->hashinfo = NDIS_HASH_FUNC_TOEPLITZ | NDIS_HASH_IPV4 |
>>>  			 NDIS_HASH_TCP_IPV4 | NDIS_HASH_IPV6 |
>>>  			 NDIS_HASH_TCP_IPV6;
>>> -	rssp->indirect_tabsize = 4*ITAB_NUM;
>>> +	rssp->indirect_tabsize = 4 * ndc->rx_table_sz;
>>>  	rssp->indirect_taboffset = sizeof(struct ndis_recv_scale_param);
>>>  	rssp->hashkey_size = NETVSC_HASH_KEYLEN;
>>>  	rssp->hashkey_offset = rssp->indirect_taboffset +
>>> @@ -961,7 +962,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
>>>  
>>>  	/* Set indirection table entries */
>>>  	itab = (u32 *)(rssp + 1);
>>> -	for (i = 0; i < ITAB_NUM; i++)
>>> +	for (i = 0; i < ndc->rx_table_sz; i++)
>>>  		itab[i] = ndc->rx_table[i];
>>>  
>>>  	/* Set hask key values */
>>> @@ -1548,6 +1549,17 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>>>  	if (ret || rsscap.num_recv_que < 2)
>>>  		goto out;
>>>  
>>> +	if (rsscap.num_indirect_tabent &&
>>> +	    rsscap.num_indirect_tabent <= ITAB_NUM_MAX)
>>> +		ndc->rx_table_sz = rsscap.num_indirect_tabent;
>>> +	else
>>> +		ndc->rx_table_sz = ITAB_NUM;
>>> +
>>> +	ndc->rx_table = kcalloc(ndc->rx_table_sz, sizeof(u16),
>>> +				GFP_KERNEL);
>>> +	if (!ndc->rx_table)
>>> +		goto err_dev_remv;
>>> +
>>>  	/* This guarantees that num_possible_rss_qs <= num_online_cpus */
>>>  	num_possible_rss_qs = min_t(u32, num_online_cpus(),
>>>  				    rsscap.num_recv_que);
>>> @@ -1558,7 +1570,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>>>  	net_device->num_chn = min(net_device->max_chn, device_info->num_chn);
>>>  
>>>  	if (!netif_is_rxfh_configured(net)) {
>>> -		for (i = 0; i < ITAB_NUM; i++)
>>> +		for (i = 0; i < ndc->rx_table_sz; i++)
>>>  			ndc->rx_table[i] = ethtool_rxfh_indir_default(
>>>  						i, net_device->num_chn);
>>>  	}
>>> @@ -1596,11 +1608,18 @@ void rndis_filter_device_remove(struct hv_device *dev,
>>>  				struct netvsc_device *net_dev)
>>>  {
>>>  	struct rndis_device *rndis_dev = net_dev->extension;
>>> +	struct net_device *net = hv_get_drvdata(dev);
>>> +	struct net_device_context *ndc = netdev_priv(net);
>>>  
>>>  	/* Halt and release the rndis device */
>>>  	rndis_filter_halt_device(net_dev, rndis_dev);
>>>  
>>>  	netvsc_device_remove(dev);
>>
>> Shouldn't the netvsc_device_remove be called post table cleanup ? or better, the cleanup should happen as part of netvsc_device_remove operation ? This looks a bug to me as with remove operation, we already cleaned up the device and the association between context and device is removed.
> 
> The netvsc_device_remove() function is responsible for cleaning up/removing the netvsc_device structures upon events like remove/suspend. The net_device and net_device_context structures(where the rx indirection table exists) remain untouched in netvsc_device_remove(). They(net_device, net_device_context) only get cleaned up in netvsc_remove(). So, the netvsc_device_remove() should not affect the cleanup for the rx indirection table, that we did.
> 

Thanks.

Reviewed-by: Praveen Kumar <kumarpraveen@linux.microsoft.com>


