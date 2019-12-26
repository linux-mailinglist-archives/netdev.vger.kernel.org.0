Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F612AEBA
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfLZVJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:09:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56734 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:09:09 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1ikaNS-00069z-7I; Thu, 26 Dec 2019 16:09:06 -0500
Date:   Thu, 26 Dec 2019 16:09:01 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net
Subject: Re: [PATCHv3 net-next] sctp: do trace_sctp_probe after SACK
 validation and check
Message-ID: <20191226210901.GA1891@hmswarspite.think-freely.org>
References: <20191225082725.1251-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225082725.1251-1-qdkevin.kou@gmail.com>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 08:27:25AM +0000, Kevin Kou wrote:
> The function sctp_sf_eat_sack_6_2 now performs the Verification
> Tag validation, Chunk length validation, Bogu check, and also
> the detection of out-of-order SACK based on the RFC2960
> Section 6.2 at the beginning, and finally performs the further
> processing of SACK. The trace_sctp_probe now triggered before
> the above necessary validation and check.
> 
> this patch is to do the trace_sctp_probe after the chunk sanity
> tests, but keep doing trace if the SACK received is out of order,
> for the out-of-order SACK is valuable to congestion control
> debugging.
> 
> v1->v2:
>  - keep doing SCTP trace if the SACK is out of order as Marcelo's
>    suggestion.
> v2->v3:
>  - regenerate the patch as v2 generated on top of v1, and add
>    'net-next' tag to the new one as Marcelo's comments.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 42558fa..748e3b1 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3281,8 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	struct sctp_sackhdr *sackh;
>  	__u32 ctsn;
>  
> -	trace_sctp_probe(ep, asoc, chunk);
> -
>  	if (!sctp_vtag_verify(chunk, asoc))
>  		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>  
> @@ -3299,6 +3297,15 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	chunk->subh.sack_hdr = sackh;
>  	ctsn = ntohl(sackh->cum_tsn_ack);
>  
> +	/* If Cumulative TSN Ack beyond the max tsn currently
> +	 * send, terminating the association and respond to the
> +	 * sender with an ABORT.
> +	 */
> +	if (TSN_lte(asoc->next_tsn, ctsn))
> +		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
> +
> +	trace_sctp_probe(ep, asoc, chunk);
> +
>  	/* i) If Cumulative TSN Ack is less than the Cumulative TSN
>  	 *     Ack Point, then drop the SACK.  Since Cumulative TSN
>  	 *     Ack is monotonically increasing, a SACK whose
> @@ -3312,13 +3319,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  		return SCTP_DISPOSITION_DISCARD;
>  	}
>  
> -	/* If Cumulative TSN Ack beyond the max tsn currently
> -	 * send, terminating the association and respond to the
> -	 * sender with an ABORT.
> -	 */
> -	if (!TSN_lt(ctsn, asoc->next_tsn))
> -		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
> -
>  	/* Return this SACK for further processing.  */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>  
> -- 
> 1.8.3.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
