Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F723F79E8
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 18:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKKR1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 12:27:41 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:58360 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbfKKR1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 12:27:41 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DC0B8B0008A;
        Mon, 11 Nov 2019 17:27:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 Nov
 2019 17:27:27 +0000
Subject: Re: [PATCH net-next] sfc: trace_xdp_exception on XDP failure
To:     Arthur Fabre <afabre@cloudflare.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Charles McLachlan <cmclachlan@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@cloudflare.com>
References: <20191111105100.2992-1-afabre@cloudflare.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f58a73a8-631c-a9a1-25e9-a5f0050df13c@solarflare.com>
Date:   Mon, 11 Nov 2019 17:27:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191111105100.2992-1-afabre@cloudflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25036.003
X-TM-AS-Result: No-7.175200-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfvmLzc6AOD8DfHkpkyUphL9SWg+u4ir2NNpsnGGIgWMmSUL
        izGxgJgi+H4tK0sV2EtUAnueMw/a9euaYjNeOEHsqJSK+HSPY+/pVMb1xnESMnAal2A1DQmsQBz
        oPKhLasiPqQJ9fQR1zpr+6Jck4vR+6TPkXiXihOxlpwNsTvdlKcnlJe2gk8vI70ULJJwFphq1+n
        G7i/dTSMJC+5wMCAzA8jmq5sblSfspcZda/ugaiDIjK23O9D33pYXNuN0M8fWbKItl61J/ybLn+
        0Vm71Lcq7rFUcuGp/FYF3qW3Je6+1bKeGUuG083K8K/ti9LWY8zh7I+j8P/L1PU1UrIcTXNdUAb
        1Hr6S1WhpGqql+a+bKThECqfMJ/0JHToZHi98h/DrEyY2r0nyvAdfn5DyOPDXC6uJnc/p0Ssglk
        ltB8xdGpozkualSTDO6clcnPxfVB+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.175200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25036.003
X-MDID: 1573493260-AAd6ax2fLRdn
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2019 10:51, Arthur Fabre wrote:
> The sfc driver can drop packets processed with XDP, notably when running
> out of buffer space on XDP_TX, or returning an unknown XDP action.
> This increments the rx_xdp_bad_drops ethtool counter.
>
> Call trace_xdp_exception everywhere rx_xdp_bad_drops is incremented to
> easily monitor this from userspace.
>
> This mirrors the behavior of other drivers.
>
> Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
> ---
>  drivers/net/ethernet/sfc/rx.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
> index a7d9841105d8..5bfe1f6112a1 100644
> --- a/drivers/net/ethernet/sfc/rx.c
> +++ b/drivers/net/ethernet/sfc/rx.c
> @@ -678,6 +678,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>  				  "XDP is not possible with multiple receive fragments (%d)\n",
>  				  channel->rx_pkt_n_frags);
>  		channel->n_rx_xdp_bad_drops++;
> +		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
>  		return false;
>  	}
AIUI trace_xdp_exception() is improper here as we have not run
 the XDP program (and xdp_act is thus uninitialised).

The other three, below, appear to be correct.
-Ed

>  
> @@ -724,6 +725,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>  				netif_err(efx, rx_err, efx->net_dev,
>  					  "XDP TX failed (%d)\n", err);
>  			channel->n_rx_xdp_bad_drops++;
> +			trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
>  		} else {
>  			channel->n_rx_xdp_tx++;
>  		}
> @@ -737,6 +739,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>  				netif_err(efx, rx_err, efx->net_dev,
>  					  "XDP redirect failed (%d)\n", err);
>  			channel->n_rx_xdp_bad_drops++;
> +			trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
>  		} else {
>  			channel->n_rx_xdp_redirect++;
>  		}
> @@ -746,6 +749,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>  		bpf_warn_invalid_xdp_action(xdp_act);
>  		efx_free_rx_buffers(rx_queue, rx_buf, 1);
>  		channel->n_rx_xdp_bad_drops++;
> +		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
>  		break;
>  
>  	case XDP_ABORTED:

