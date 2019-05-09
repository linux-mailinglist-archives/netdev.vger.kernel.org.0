Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918671890C
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfEILdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:33:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58861 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfEILdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 07:33:16 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hOhIO-0000V0-Kh; Thu, 09 May 2019 07:33:11 -0400
Date:   Thu, 9 May 2019 07:32:35 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
Message-ID: <20190509113235.GA12387@hmswarspite.think-freely.org>
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 02:28:00PM +0800, Xin Long wrote:
> SCTP_CMD_GEN_INIT_ACK was introduced since very beginning, but never
> got used. So remove it.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/command.h |  1 -
>  net/sctp/sm_sideeffect.c   | 11 -----------
>  2 files changed, 12 deletions(-)
> 
> diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
> index 6d5beac..b4e8706 100644
> --- a/include/net/sctp/command.h
> +++ b/include/net/sctp/command.h
> @@ -48,7 +48,6 @@ enum sctp_verb {
>  	SCTP_CMD_REPORT_TSN,	/* Record the arrival of a TSN.  */
>  	SCTP_CMD_GEN_SACK,	/* Send a Selective ACK (maybe).  */
>  	SCTP_CMD_PROCESS_SACK,	/* Process an inbound SACK.  */
> -	SCTP_CMD_GEN_INIT_ACK,	/* Generate an INIT ACK chunk.  */
>  	SCTP_CMD_PEER_INIT,	/* Process a INIT from the peer.  */
>  	SCTP_CMD_GEN_COOKIE_ECHO, /* Generate a COOKIE ECHO chunk. */
>  	SCTP_CMD_CHUNK_ULP,	/* Send a chunk to the sockets layer.  */
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 4aa0358..233ee80 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -1364,17 +1364,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
>  						      cmd->obj.chunk);
>  			break;
>  
> -		case SCTP_CMD_GEN_INIT_ACK:
> -			/* Generate an INIT ACK chunk.  */
> -			new_obj = sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
> -						     0);
> -			if (!new_obj)
> -				goto nomem;
> -
> -			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> -					SCTP_CHUNK(new_obj));
> -			break;
> -
>  		case SCTP_CMD_PEER_INIT:
>  			/* Process a unified INIT from the peer.
>  			 * Note: Only used during INIT-ACK processing.  If
> -- 
> 2.1.0
> 
> 

This is definately a valid cleanup, but I wonder if it wouldn't be better to,
instead of removing it, to use it.  We have 2 locations where we actually call
sctp_make_init_ack, and then have to check the return code and abort the
operation if we get a NULL return.  Would it be a better solution (in the sense
of keeping our control flow in line with how the rest of the state machine is
supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
the state machine queue in the locations where we otherwise would call
sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?

Neil

