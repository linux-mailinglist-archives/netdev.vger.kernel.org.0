Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB820AA9B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 05:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgFZDMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 23:12:09 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:44656 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728169AbgFZDMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 23:12:08 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2F2C918224D89;
        Fri, 26 Jun 2020 03:12:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2716:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3874:4225:4321:5007:6119:6742:7576:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12663:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14659:14721:14819:21080:21627:30054:30055:30064:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: flame27_2100af926e52
X-Filterd-Recvd-Size: 2409
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 03:12:04 +0000 (UTC)
Message-ID: <de66eb53b15376161bca59e13f147a5ee4f36c33.camel@perches.com>
Subject: Re: [net-next v3 12/15] iecm: Add singleq TX/RX
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
Date:   Thu, 25 Jun 2020 20:12:03 -0700
In-Reply-To: <20200626020737.775377-13-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-13-jeffrey.t.kirsher@intel.com>
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
> Implement legacy single queue model for TX/RX flows.
[]
> diff --git a/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
[]
> @@ -145,7 +508,63 @@ static void iecm_rx_singleq_csum(struct iecm_queue *rxq, struct sk_buff *skb,
>  				 struct iecm_singleq_base_rx_desc *rx_desc,
>  				 u8 ptype)
>  {
[]
> +	if (ipv4 && (rx_error & (BIT(IECM_RX_BASE_DESC_ERROR_IPE_S) |
> +				 BIT(IECM_RX_BASE_DESC_ERROR_EIPE_S))))
> +		goto checksum_fail;
> +	else if (ipv6 && (rx_status &
> +		 (BIT(IECM_RX_BASE_DESC_STATUS_IPV6EXADD_S))))
> +		goto checksum_fail;
> +
> +	/* check for L4 errors and handle packets that were not able to be
> +	 * checksummed due to arrival speed
> +	 */
> +	if (rx_error & BIT(IECM_RX_BASE_DESC_ERROR_L3L4E_S))
> +		goto checksum_fail;
[]
> +checksum_fail:
> +	dev_dbg(rxq->dev, "RX Checksum not available\n");

If there's an actual checksum arrival speed issue,
then likely this dbg output should be ratelimited too.


