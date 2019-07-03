Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85C05E6EF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfGCOj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:39:28 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44406 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCOj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:39:28 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1higPo-00008B-8I; Wed, 03 Jul 2019 10:39:26 -0400
Date:   Wed, 3 Jul 2019 10:38:52 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] sctp: count data bundling sack chunk for
 outctrlchunks
Message-ID: <20190703143852.GA20747@hmswarspite.think-freely.org>
References: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 06:20:20PM +0800, Xin Long wrote:
> Now all ctrl chunks are counted for asoc stats.octrlchunks and net
> SCTP_MIB_OUTCTRLCHUNKS either after queuing up or bundling, other
> than the chunk maked and bundled in sctp_packet_bundle_sack, which
> caused 'outctrlchunks' not consistent with 'inctrlchunks' in peer.
> 
> This issue exists since very beginning, here to fix it by increasing
> both net SCTP_MIB_OUTCTRLCHUNKS and asoc stats.octrlchunks when sack
> chunk is maked and bundled in sctp_packet_bundle_sack.
> 
> Reported-by: Ja Ram Jeon <jajeon@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/output.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index e0c2747..dbda7e7 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -282,6 +282,9 @@ static enum sctp_xmit sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  					sctp_chunk_free(sack);
>  					goto out;
>  				}
> +				SCTP_INC_STATS(sock_net(asoc->base.sk),
> +					       SCTP_MIB_OUTCTRLCHUNKS);
> +				asoc->stats.octrlchunks++;
>  				asoc->peer.sack_needed = 0;
>  				if (del_timer(timer))
>  					sctp_association_put(asoc);
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

