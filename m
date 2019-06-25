Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC48F54D5A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfFYLSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:18:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49461 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbfFYLSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:18:23 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hfjSo-0007Pt-O1; Tue, 25 Jun 2019 07:18:20 -0400
Date:   Tue, 25 Jun 2019 07:18:09 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: change to hold sk after auth shkey is created
 successfully
Message-ID: <20190625111809.GB29902@hmswarspite.think-freely.org>
References: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:21:45AM +0800, Xin Long wrote:
> Now in sctp_endpoint_init(), it holds the sk then creates auth
> shkey. But when the creation fails, it doesn't release the sk,
> which causes a sk defcnf leak,
> 
> Here to fix it by only holding the sk when auth shkey is created
> successfully.
> 
> Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
> Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
> Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/endpointola.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index e358437..69cebb2 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -118,10 +118,6 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
>  	/* Initialize the bind addr area */
>  	sctp_bind_addr_init(&ep->base.bind_addr, 0);
>  
> -	/* Remember who we are attached to.  */
> -	ep->base.sk = sk;
> -	sock_hold(ep->base.sk);
> -
>  	/* Create the lists of associations.  */
>  	INIT_LIST_HEAD(&ep->asocs);
>  
> @@ -154,6 +150,10 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
>  	ep->prsctp_enable = net->sctp.prsctp_enable;
>  	ep->reconf_enable = net->sctp.reconf_enable;
>  
> +	/* Remember who we are attached to.  */
> +	ep->base.sk = sk;
> +	sock_hold(ep->base.sk);
> +
>  	return ep;
>  
>  nomem_shkey:
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@redhat.com>
