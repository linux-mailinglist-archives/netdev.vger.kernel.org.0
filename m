Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C55C3691BC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbhDWMHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:07:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:9565 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhDWMHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:07:15 -0400
IronPort-SDR: Wl0CYK8WwsJm0SJYUD2g79ZiCfcLIK0de42BMSAEmYagqfSyE3A7uoGt9Uan8kqYl3OBDZhV4y
 q7Dnix2pXl0A==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="216741479"
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="216741479"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 05:06:39 -0700
IronPort-SDR: jHLdHp/7cZWAzZ1xBF+5GdsV/b6RbTdlmh/DqV+zeClSdXidxRdGp++38iezLl8Zeplu2s/KMb
 CZ2Wso0VxfkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="464302721"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 23 Apr 2021 05:06:35 -0700
Date:   Fri, 23 Apr 2021 13:51:50 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v3] igb: Fix XDP with PTP enabled
Message-ID: <20210423115150.GB64904@ranger.igk.intel.com>
References: <20210422052617.17267-1-kurt@linutronix.de>
 <20210422101129.GB44289@ranger.igk.intel.com>
 <878s59qz1b.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s59qz1b.fsf@kurt>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 08:45:52AM +0200, Kurt Kanzenbach wrote:
> On Thu Apr 22 2021, Maciej Fijalkowski wrote:
> > On Thu, Apr 22, 2021 at 07:26:17AM +0200, Kurt Kanzenbach wrote:
> >> +		/* pull rx packet timestamp if available and valid */
> >> +		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> >> +			timestamp = igb_ptp_rx_pktstamp(rx_ring->q_vector,
> >> +							pktbuf);
> >> +
> >> +			if (timestamp) {
> >> +				pkt_offset += IGB_TS_HDR_LEN;
> >> +				size -= IGB_TS_HDR_LEN;
> >> +			}
> >> +		}
> >
> > Small nit: since this is a hot path, maybe we could omit the additional
> > branch that you're introducing above and make igb_ptp_rx_pktstamp() to
> > return either 0 for error cases and IGB_TS_HDR_LEN if timestamp was fine?
> > timestamp itself would be passed as an arg.
> >
> > So:
> > 		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> > 			ts_offset = igb_ptp_rx_pktstamp(rx_ring->q_vector,
> > 							pktbuf, &timestamp);
> > 			pkt_offset += ts_offset;
> > 			size -= ts_offset;
> > 		}
> >
> > Thoughts? I feel like if we see that desc has timestamp enabled then let's
> > optimize it for successful case.
> 
> Yes, this should work as well. Actually I didn't like the if statement
> either. Only one comment: It's not an offset but rather the timestamp
> header length. I'd call it 'ts_len'.

Right, sorry.

> 
> >
> >>  
> >>  		/* retrieve a buffer from the ring */
> >>  		if (!skb) {
> >> -			unsigned int offset = igb_rx_offset(rx_ring);
> >> -			unsigned char *hard_start;
> >> +			unsigned char *hard_start = pktbuf - igb_rx_offset(rx_ring);
> >> +			unsigned int offset = pkt_offset + igb_rx_offset(rx_ring);
> >
> > Probably we could do something similar in flavour of:
> > https://lore.kernel.org/bpf/20210118151318.12324-10-maciej.fijalkowski@intel.com/
> >
> > which broke XDP_REDIRECT and got fixed in:
> > https://lore.kernel.org/bpf/20210303153928.11764-2-maciej.fijalkowski@intel.com/
> >
> > You get the idea.
> 
> Yes, I do. However, I think such a change doesn't belong in this patch,
> which is a bugfix for XDP. It looks like an optimization. Should I split
> it into two patches and rather target net-next instead of net?

This was just a heads up from my side as it caught my eye. For sure it's
out of the scope of that patch, but would be good to have a follow up on
that.

> 
> Thanks for your review.
> 
> Thanks,
> Kurt


