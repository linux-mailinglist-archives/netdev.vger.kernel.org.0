Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EE44B4FB6
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 13:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352648AbiBNMKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 07:10:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352573AbiBNMK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 07:10:29 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240074925C;
        Mon, 14 Feb 2022 04:10:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4RzT.I_1644840618;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4RzT.I_1644840618)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 20:10:18 +0800
Date:   Mon, 14 Feb 2022 20:10:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Stefan Raspl <raspl@linux.ibm.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net/smc: Remove corked dealyed work
Message-ID: <YgpGqV11uW6RfSAt@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-3-tonylu@linux.alibaba.com>
 <becbfd54-5a42-9867-f3ac-b347b561985f@linux.ibm.com>
 <YgYn6jA0i3pFXoCS@TonyMac-Alibaba>
 <f4166712-9a1e-51a0-409d-b7df25a66c52@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4166712-9a1e-51a0-409d-b7df25a66c52@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 11:29:10AM +0100, Stefan Raspl wrote:
> On 2/11/22 10:10, Tony Lu wrote:
> > On Mon, Jan 31, 2022 at 08:40:47PM +0100, Stefan Raspl wrote:
> > > On 1/30/22 19:02, Tony Lu wrote:
> > > > Based on the manual of TCP_CORK [1] and MSG_MORE [2], these two options
> > > > have the same effect. Applications can set these options and informs the
> > > > kernel to pend the data, and send them out only when the socket or
> > > > syscall does not specify this flag. In other words, there's no need to
> > > > send data out by a delayed work, which will queue a lot of work.
> > > > 
> > > > This removes corked delayed work with SMC_TX_CORK_DELAY (250ms), and the
> > > > applications control how/when to send them out. It improves the
> > > > performance for sendfile and throughput, and remove unnecessary race of
> > > > lock_sock(). This also unlocks the limitation of sndbuf, and try to fill
> > > > it up before sending.
> > > > 
> > > > [1] https://linux.die.net/man/7/tcp
> > > > [2] https://man7.org/linux/man-pages/man2/send.2.html
> > > > 
> > > > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > > > ---
> > > >    net/smc/smc_tx.c | 15 ++++++---------
> > > >    1 file changed, 6 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> > > > index 7b0b6e24582f..9cec62cae7cb 100644
> > > > --- a/net/smc/smc_tx.c
> > > > +++ b/net/smc/smc_tx.c
> > > > @@ -31,7 +31,6 @@
> > > >    #include "smc_tracepoint.h"
> > > >    #define SMC_TX_WORK_DELAY	0
> > > > -#define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
> > > >    /***************************** sndbuf producer *******************************/
> > > > @@ -237,15 +236,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
> > > >    		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
> > > >    			conn->urg_tx_pend = true;
> > > >    		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
> > > > -		    (atomic_read(&conn->sndbuf_space) >
> > > > -						(conn->sndbuf_desc->len >> 1)))
> > > > -			/* for a corked socket defer the RDMA writes if there
> > > > -			 * is still sufficient sndbuf_space available
> > > > +		    (atomic_read(&conn->sndbuf_space)))
> > > > +			/* for a corked socket defer the RDMA writes if
> > > > +			 * sndbuf_space is still available. The applications
> > > > +			 * should known how/when to uncork it.
> > > >    			 */
> > > > -			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
> > > > -					   SMC_TX_CORK_DELAY);
> > > > -		else
> > > > -			smc_tx_sndbuf_nonempty(conn);
> > > > +			continue;
> > > 
> > > In case we just corked the final bytes in this call, wouldn't this
> > > 'continue' prevent us from accounting the Bytes that we just staged to be
> > > sent out later in the trace_smc_tx_sendmsg() call below?
> > > 
> > > > +		smc_tx_sndbuf_nonempty(conn);
> > > >    		trace_smc_tx_sendmsg(smc, copylen);
> > > 
> > 
> > If the application send out the final bytes in this call, the
> > application should also clear MSG_MORE or TCP_CORK flag, this action is
> > required based on the manuals [1] and [2]. So it is safe to cork the data
> > if flag is setted, and continue to the next loop until application
> > clears the flag.
> 
> Yes, I understand. But trace_smc_tx_sendmsg(smc, copylen) should be called
> for each portion of data that we transmit, i.e. each time we run through
> this loop. That is because parameter copylen is reset during each iteration.
> Now your patch adds a 'continue', which prevents that trace_smc_tc... call
> from being made. Which means the information that 'copylen' Bytes were
> transferred is lost forever, and the accounting of tx Bytes is off by
> 'copylen' Bytes, I believe!

This makes sense to me. It shouldn't be ignored if data was corked. I
will fix it in the next patch.

Thank you,
Tony Lu
