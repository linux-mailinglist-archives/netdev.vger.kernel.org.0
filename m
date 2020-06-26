Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197E320AA93
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 05:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgFZDGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 23:06:16 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:60998 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728169AbgFZDGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 23:06:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 11BF6180A7FEB;
        Fri, 26 Jun 2020 03:06:15 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2902:2914:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3871:3872:3874:4321:4384:4605:5007:6742:7576:7904:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12295:12296:12297:12438:12663:12740:12760:12895:13095:13439:13868:14181:14659:14721:21080:21433:21627:21939:21990:30045:30054:30055:30064:30083:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: stove85_45056a926e52
X-Filterd-Recvd-Size: 4108
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 03:06:12 +0000 (UTC)
Message-ID: <de3e14d355f42ed2322483bc1a3448ace46fd6fb.camel@perches.com>
Subject: Re: [net-next v3 07/15] iecm: Implement virtchnl commands
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
Date:   Thu, 25 Jun 2020 20:06:11 -0700
In-Reply-To: <20200626020737.775377-8-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-8-jeffrey.t.kirsher@intel.com>
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
> Implement various virtchnl commands that enable
> communication with hardware.
[]
> diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
[]
> @@ -751,7 +1422,44 @@ iecm_send_add_queues_msg(struct iecm_vport *vport, u16 num_tx_q,
>  enum iecm_status
>  iecm_send_get_stats_msg(struct iecm_vport *vport)
>  {
> -	/* stub */
> +	struct iecm_adapter *adapter = vport->adapter;
> +	struct virtchnl_queue_select vqs;
> +	enum iecm_status err;
> +
> +	/* Don't send get_stats message if one is pending or the
> +	 * link is down
> +	 */
> +	if (test_bit(IECM_VC_GET_STATS, adapter->vc_state) ||
> +	    adapter->state <= __IECM_DOWN)
> +		return 0;
> +
> +	vqs.vsi_id = vport->vport_id;
> +
> +	err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_GET_STATS,
> +			       sizeof(vqs), (u8 *)&vqs);

rather clearer to just test and return err

	if (err)
		return err;
> +
> +	if (!err)
> +		err = iecm_wait_for_event(adapter, IECM_VC_GET_STATS,
> +					  IECM_VC_GET_STATS_ERR);

unindent and add

	if (err)
		return err;

so all the below is also unindented.
It might also be clearer to use another temporary
for vport->netstats

> +
> +	if (!err) {
> +		struct virtchnl_eth_stats *stats =
> +			(struct virtchnl_eth_stats *)adapter->vc_msg;
> +		vport->netstats.rx_packets = stats->rx_unicast +
> +						 stats->rx_multicast +
> +						 stats->rx_broadcast;
> +		vport->netstats.tx_packets = stats->tx_unicast +
> +						 stats->tx_multicast +
> +						 stats->tx_broadcast;
> +		vport->netstats.rx_bytes = stats->rx_bytes;
> +		vport->netstats.tx_bytes = stats->tx_bytes;
> +		vport->netstats.tx_errors = stats->tx_errors;
> +		vport->netstats.rx_dropped = stats->rx_discards;
> +		vport->netstats.tx_dropped = stats->tx_discards;
> +		mutex_unlock(&adapter->vc_msg_lock);
> +	}
> +
> +	return err;
>  }

[] 

> @@ -801,7 +1670,24 @@ iecm_send_get_set_rss_key_msg(struct iecm_vport *vport, bool get)
>   */
>  enum iecm_status iecm_send_get_rx_ptype_msg(struct iecm_vport *vport)
>  {
> -	/* stub */
> +	struct iecm_rx_ptype_decoded *rx_ptype_lkup = vport->rx_ptype_lkup;
> +	int ptype_list[IECM_RX_SUPP_PTYPE] = { 0, 1, 11, 12, 22, 23, 24, 25, 26,
> +					      27, 28, 88, 89, 90, 91, 92, 93,
> +					      94 };

static const?

> +	enum iecm_status err = 0;
> +	int i;
> +
> +	for (i = 0; i < IECM_RX_MAX_PTYPE; i++)
> +		rx_ptype_lkup[i] = iecm_rx_ptype_lkup[0];
> +
> +	for (i = 0; i < IECM_RX_SUPP_PTYPE; i++) {
> +		int j = ptype_list[i];
> +
> +		rx_ptype_lkup[j] = iecm_rx_ptype_lkup[i];
> +		rx_ptype_lkup[j].ptype = ptype_list[i];
> +	};
> +
> +	return err;
>  }


