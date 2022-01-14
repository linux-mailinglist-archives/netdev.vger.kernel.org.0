Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A348E199
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 01:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbiANAhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 19:37:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:28638 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238447AbiANAhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 19:37:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642120624; x=1673656624;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=WpqWIfjtUFSQVtFFBjHKmiadBFigY6i0v+ya3JWe/1c=;
  b=Uf/QUQ3j4gWESJ/qs7L09r8QHJHdsCh1mB85f9VqdTZKewaBn0bnx953
   B0Naw3mhaiQ/cjCnFm+isv5mWyaLJlVOCL5PsIbRGVm2NdzGmgH8jqbYV
   CpIwFAaHu4I7imj7zf7GjzrdjDUGajH+iQMnW5fn6vbBtyPha0F3+Yr+4
   +wPQBIWGy8ybz+XnO+/bnGo8lOU6iyOg//RTOhUjNWANv0L6vl4lQDU71
   8w6Pfh/boG5LbHSBdudFdSsshApBjVhWIXJbdspsbELCyRSS3rG1io5PR
   VZsQS1A3cBmWCQeVMznyLsu6pPATY2bAxF37YUQntvjx3c/WiyaQ9c6AA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="307493899"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="307493899"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 16:37:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="624138722"
Received: from lyang24-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.236.107])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 16:37:02 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     Andre Guedes <andre.guedes@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: Re: [PATCH net-next] igc: avoid kernel warning when changing RX
 ring parameters
In-Reply-To: <20220113160021.1027704-1-vinschen@redhat.com>
References: <20220113160021.1027704-1-vinschen@redhat.com>
Date:   Thu, 13 Jan 2022 16:37:01 -0800
Message-ID: <87sftr6tle.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corinna Vinschen <vinschen@redhat.com> writes:

> Calling ethtool changing the RX ring parameters like this:
>
>   $ ethtool -G eth0 rx 1024
>
> triggers the "Missing unregister, handled but fix driver" warning in
> xdp_rxq_info_reg().
>
> igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
> reset the xdp_rxq_info member before calling igc_setup_rx_resources().
> This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.
>
> This fix initializes the xdp_rxq_info member prior to calling
> igc_setup_rx_resources(), exactly like igb.
>
> Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ethtool.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> index 8cc077b712ad..93839106504d 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> @@ -671,6 +671,10 @@ igc_ethtool_set_ringparam(struct net_device *netdev,
>  			memcpy(&temp_ring[i], adapter->rx_ring[i],
>  			       sizeof(struct igc_ring));
>  
> +			/* Clear copied XDP RX-queue info */
> +			memset(&temp_ring[i].xdp_rxq, 0,
> +			       sizeof(temp_ring[i].xdp_rxq));
> +

Reaching "inside" xdp_rxq to reset it doesn't feel right in this
context, even if it's going to work fine (for now).

I think that the suggestion that Alexander gave in that other thread is
the best approach. And thanks for noticing that igb '_set_ringparam()'
has the same underlying problem and also needs to be fixed.


Cheers,
-- 
Vinicius
