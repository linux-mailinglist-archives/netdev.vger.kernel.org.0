Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B812620AA8F
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 04:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgFZC5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 22:57:36 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:54208 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728169AbgFZC5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 22:57:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 047B1181D337B;
        Fri, 26 Jun 2020 02:57:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:305:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:4118:4250:4321:4605:5007:6119:6742:7576:7903:8603:10004:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12663:12740:12760:12895:13439:14096:14097:14659:21060:21080:21324:21433:21627:21660:21990:30012:30034:30045:30046:30054:30055:30064:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: roof83_5f1467e26e52
X-Filterd-Recvd-Size: 7032
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 02:57:32 +0000 (UTC)
Message-ID: <b2305a5aaefdd64630a6b99c7b46397ccb029fd9.camel@perches.com>
Subject: Re: [net-next v3 06/15] iecm: Implement mailbox functionality
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Thu, 25 Jun 2020 19:57:31 -0700
In-Reply-To: <20200626020737.775377-7-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-7-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
> 
> Implement mailbox setup, take down, and commands.
[]
> diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq.c b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
[]
> @@ -73,7 +142,74 @@ enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
>  			       struct iecm_ctlq_create_info *qinfo,
>  			       struct iecm_ctlq_info **cq)

Multiple functions using **cp and *cp can be error prone.

>  {
> -	/* stub */
> +	enum iecm_status status = 0;
> +	bool is_rxq = false;
> +
> +	if (!qinfo->len || !qinfo->buf_size ||
> +	    qinfo->len > IECM_CTLQ_MAX_RING_SIZE ||
> +	    qinfo->buf_size > IECM_CTLQ_MAX_BUF_LEN)
> +		return IECM_ERR_CFG;
> +
> +	*cq = kcalloc(1, sizeof(struct iecm_ctlq_info), GFP_KERNEL);
> +	if (!(*cq))
> +		return IECM_ERR_NO_MEMORY;

pity there is an iecm_status and not just a generic -ENOMEM.
Is there much value in the separate enum?

[]
@@ -152,7 +388,58 @@ enum iecm_status iecm_ctlq_clean_sq(struct iecm_ctlq_info *cq,
>  				    u16 *clean_count,
>  				    struct iecm_ctlq_msg *msg_status[])
>  {
> -	/* stub */
> +	enum iecm_status ret = 0;
> +	struct iecm_ctlq_desc *desc;
> +	u16 i = 0, num_to_clean;
> +	u16 ntc, desc_err;
> +
> +	if (!cq || !cq->ring_size)
> +		return IECM_ERR_CTLQ_EMPTY;
> +
> +	if (*clean_count == 0)
> +		return 0;
> +	else if (*clean_count > cq->ring_size)
> +		return IECM_ERR_PARAM;

unnecessary else

> +
> +	mutex_lock(&cq->cq_lock);
> +
> +	ntc = cq->next_to_clean;
> +
> +	num_to_clean = *clean_count;
> +
> +	for (i = 0; i < num_to_clean; i++) {
> +		/* Fetch next descriptor and check if marked as done */
> +		desc = IECM_CTLQ_DESC(cq, ntc);
> +		if (!(le16_to_cpu(desc->flags) & IECM_CTLQ_FLAG_DD))
> +			break;
> +
> +		desc_err = le16_to_cpu(desc->ret_val);
> +		if (desc_err) {
> +			/* strip off FW internal code */
> +			desc_err &= 0xff;
> +		}
> +
> +		msg_status[i] = cq->bi.tx_msg[ntc];
> +		msg_status[i]->status = desc_err;
> +
> +		cq->bi.tx_msg[ntc] = NULL;
> +
> +		/* Zero out any stale data */
> +		memset(desc, 0, sizeof(*desc));
> +
> +		ntc++;
> +		if (ntc == cq->ring_size)
> +			ntc = 0;
> +	}
> +
> +	cq->next_to_clean = ntc;
> +
> +	mutex_unlock(&cq->cq_lock);
> +
> +	/* Return number of descriptors actually cleaned */
> +	*clean_count = i;
> +
> +	return ret;
>  }
>  
>  /**
> @@ -175,7 +462,111 @@ enum iecm_status iecm_ctlq_post_rx_buffs(struct iecm_hw *hw,
>  					 u16 *buff_count,
>  					 struct iecm_dma_mem **buffs)
>  {
> -	/* stub */
> +	enum iecm_status status = 0;
> +	struct iecm_ctlq_desc *desc;
> +	u16 ntp = cq->next_to_post;
> +	bool buffs_avail = false;
> +	u16 tbp = ntp + 1;
> +	int i = 0;
> +
> +	if (*buff_count > cq->ring_size)
> +		return IECM_ERR_PARAM;
> +
> +	if (*buff_count > 0)
> +		buffs_avail = true;
> +
> +	mutex_lock(&cq->cq_lock);
> +
> +	if (tbp >= cq->ring_size)
> +		tbp = 0;
> +
> +	if (tbp == cq->next_to_clean)
> +		/* Nothing to do */
> +		goto post_buffs_out;
> +
> +	/* Post buffers for as many as provided or up until the last one used */
> +	while (ntp != cq->next_to_clean) {
> +		desc = IECM_CTLQ_DESC(cq, ntp);
> +
> +		if (!cq->bi.rx_buff[ntp]) {

		if (cq->bi.rx_buff[ntp])
			continue;

and unindent?

> +			if (!buffs_avail) {
> +				/* If the caller hasn't given us any buffers or
> +				 * there are none left, search the ring itself
> +				 * for an available buffer to move to this
> +				 * entry starting at the next entry in the ring
> +				 */
> +				tbp = ntp + 1;
> +
> +				/* Wrap ring if necessary */
> +				if (tbp >= cq->ring_size)
> +					tbp = 0;
> +
> +				while (tbp != cq->next_to_clean) {
> +					if (cq->bi.rx_buff[tbp]) {
> +						cq->bi.rx_buff[ntp] =
> +							cq->bi.rx_buff[tbp];
> +						cq->bi.rx_buff[tbp] = NULL;
> +
> +						/* Found a buffer, no need to
> +						 * search anymore
> +						 */
> +						break;
> +					}
> +
> +					/* Wrap ring if necessary */
> +					tbp++;
> +					if (tbp >= cq->ring_size)
> +						tbp = 0;
> +				}
> +
> +				if (tbp == cq->next_to_clean)
> +					goto post_buffs_out;
> +			} else {
> +				/* Give back pointer to DMA buffer */
> +				cq->bi.rx_buff[ntp] = buffs[i];
> +				i++;
> +
> +				if (i >= *buff_count)
> +					buffs_avail = false;
> +			}
> +		}
> +
> +		desc->flags =
> +			cpu_to_le16(IECM_CTLQ_FLAG_BUF | IECM_CTLQ_FLAG_RD);
> +
> +		/* Post buffers to descriptor */
> +		desc->datalen = cpu_to_le16(cq->bi.rx_buff[ntp]->size);
> +		desc->params.indirect.addr_high =
> +			cpu_to_le32(IECM_HI_DWORD(cq->bi.rx_buff[ntp]->pa));
> +		desc->params.indirect.addr_low =
> +			cpu_to_le32(IECM_LO_DWORD(cq->bi.rx_buff[ntp]->pa));
> +
> +		ntp++;
> +		if (ntp == cq->ring_size)
> +			ntp = 0;
> +	}

[] 

> @@ -186,7 +555,27 @@ iecm_wait_for_event(struct iecm_adapter *adapter,
>  		    enum iecm_vport_vc_state state,
>  		    enum iecm_vport_vc_state err_check)
>  {
> -	/* stub */
> +	enum iecm_status status;
> +	int event;
> +
> +	event = wait_event_timeout(adapter->vchnl_wq,
> +				   test_and_clear_bit(state, adapter->vc_state),
> +				   msecs_to_jiffies(500));
> +	if (event) {
> +		if (test_and_clear_bit(err_check, adapter->vc_state)) {
> +			dev_err(&adapter->pdev->dev,
> +				"VC response error %d", err_check);

missing format terminating newlines

> +			status = IECM_ERR_CFG;
> +		} else {
> +			status = 0;
> +		}
> +	} else {
> +		/* Timeout occurred */
> +		status = IECM_ERR_NOT_READY;
> +		dev_err(&adapter->pdev->dev, "VC timeout, state = %u", state);

here too


