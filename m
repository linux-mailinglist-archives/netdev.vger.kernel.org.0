Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E3A45B705
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240805AbhKXJBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:01:03 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56642 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241004AbhKXJA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:00:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uy5uIRo_1637744267;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uy5uIRo_1637744267)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 16:57:47 +0800
Date:   Wed, 24 Nov 2021 16:57:46 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Message-ID: <YZ3+ihxIU5l8mvWY@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
 <d83109fe-ae25-def0-b28e-f8695d4535c7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d83109fe-ae25-def0-b28e-f8695d4535c7@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 10:26:21AM +0100, Karsten Graul wrote:
> On 16/11/2021 04:30, Tony Lu wrote:
> > diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> > index 0f9ffba07d26..04620b53b74a 100644
> > --- a/net/smc/smc_close.c
> > +++ b/net/smc/smc_close.c
> > @@ -228,6 +228,12 @@ int smc_close_active(struct smc_sock *smc)
> >  			/* send close request */
> >  			rc = smc_close_final(conn);
> >  			sk->sk_state = SMC_PEERCLOSEWAIT1;
> > +
> > +			/* actively shutdown clcsock before peer close it,
> > +			 * prevent peer from entering TIME_WAIT state.
> > +			 */
> > +			if (smc->clcsock && smc->clcsock->sk)
> > +				rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
> >  		} else {
> 
> While integrating this patch I stumbled over the overwritten rc, which was
> already set with the return value from smc_close_final().
> Is the rc from kernel_sock_shutdown() even important for the result of this 
> function? How to handle this in your opinion?

Hi Graul,

I have investigated the function smc_close_final() when return error:

1. return -EPIPE
  * conn->killed
  * !conn->lgr || (conn->lgr->is_smcd && conn->lgr->peer_shutdown)

2. return -ENOLINK
  * !smc_link_usable(link)
  * conn's link have changed during wr get free slot

3. return -EBUSY
  * smc_wr_tx_get_free_slot_index has no available slot

The return code -EBUSY is important for user-space to recall close()
again.

-ENOLINK and -EPIPE means there is no chance to tell peer to perform
close progress. The applications should known this. And the clcsock will
be released in the end.


And the caller of upper function smc_close_active():

1. __smc_release(), it doesn't handle rc and return it to user-space who
called close() directly.

2. smc_shutdown(), it return rc to caller, also with function
kernel_sock_shutdown().

IMHO, given that, it is better to not ignore smc_close_final(), and move 
kernel_sock_shutdown() to __smc_release(), because smc_shutdown() also
calls kernel_sock_shutdown() after smc_close_active() and
smc_close_shutdown_write(), then enters SMC_PEERCLOSEWAIT1. It's no need
to call it twice with SHUT_WR and SHUT_RDWR. 

Here is the complete code of __smc_release in af_smc.c


static int __smc_release(struct smc_sock *smc)
{
		struct sock *sk = &smc->sk;
		int rc = 0, rc1 = 0;

		if (!smc->use_fallback) {
				rc = smc_close_active(smc);

			    /* make sure don't call kernel_sock_shutdown() twice
				 * after called smc_shutdown with SHUT_WR or SHUT_RDWR,
				 * which will perform TCP closing progress.
				 */
				if (smc->clcsock && (!sk->sk_shutdown || 
				    (sk->sk_shutdown & RCV_SHUTDOWN)) &&
				    sk->sk_state == SMC_PEERCLOSEWAIT1) {
					rc1 = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
					rc = rc ? rc : rc1;
				}

				sock_set_flag(sk, SOCK_DEAD);
				sk->sk_shutdown |= SHUTDOWN_MASK;
		} else {

// code ignored


Thanks for pointing it out, it would be more complete of this patch.

Tony Lu
