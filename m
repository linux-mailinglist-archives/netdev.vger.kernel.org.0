Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40949627D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbiAUQAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:00:07 -0500
Received: from mga06.intel.com ([134.134.136.31]:29755 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351037AbiAUQAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 11:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642780803; x=1674316803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HE6c8IgFI+DlexaYcDl10ukjIkHRiNr/Z8cFLm+BUoo=;
  b=C2a6v+ikBHnJX3kMUMmqXKyKogqvMYeGx8xZospQOTJowODDUFesbxH+
   mR5T2YqyDxjeVKUlPSNEpCp43R8QCQEd8Vn7vbq+u4CuGEqT8WJRqbvcS
   sMDJMjDyTIjL+qCMKlRdtvdAEHmxtJPXvIrVyO9NS8FLC/o1BvTW1z6yv
   2H5iyZAkjuAFIdgJJYT+G+BzbY2a+oeul3iI6AK9qyXjn5+9U9QM0+21V
   Usfa+C7V3tG0rZx86TBMyqE1tifYZAV/SDUhcGFso1ZCBTs5lbTIIc1RL
   XQ1psMkD+ak5jsaegcVZxrtysozktCJmxW1kcRq3oUDem+ATaEesL+PaP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="306402869"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="306402869"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 08:00:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="533320909"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 21 Jan 2022 08:00:00 -0800
Date:   Fri, 21 Jan 2022 17:00:00 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests: xsk: fix rx_full stats test
Message-ID: <YerYgIFIqe8IM2YB@boxer>
References: <20220121123508.12759-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121123508.12759-1-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 01:35:08PM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix the rx_full stats test so that it correctly reports pass even when
> the fill ring is not full of buffers.
> 
> Fixes: 872a1184dbf2 ("selftests: xsk: Put the same buffer only once in the fill ring")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Fixes xdpxceiver hang on my side.

Tested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 0a5d23da486d..ffa5502ad95e 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -906,7 +906,10 @@ static bool rx_stats_are_valid(struct ifobject *ifobject)
>  			return true;
>  		case STAT_TEST_RX_FULL:
>  			xsk_stat = stats.rx_ring_full;
> -			expected_stat -= RX_FULL_RXQSIZE;
> +			if (ifobject->umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
> +				expected_stat = ifobject->umem->num_frames - RX_FULL_RXQSIZE;
> +			else
> +				expected_stat = XSK_RING_PROD__DEFAULT_NUM_DESCS - RX_FULL_RXQSIZE;
>  			break;
>  		case STAT_TEST_RX_FILL_EMPTY:
>  			xsk_stat = stats.rx_fill_ring_empty_descs;
> 
> base-commit: 820e6e227c4053b6b631ae65ef1f65d560cb392b
> -- 
> 2.34.1
> 
