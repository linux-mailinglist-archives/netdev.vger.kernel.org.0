Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1A94B2119
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiBKJKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:10:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348405AbiBKJKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:10:07 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B78B53;
        Fri, 11 Feb 2022 01:10:05 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V48M09O_1644570602;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V48M09O_1644570602)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 17:10:03 +0800
Date:   Fri, 11 Feb 2022 17:10:02 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Stefan Raspl <raspl@linux.ibm.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net/smc: Remove corked dealyed work
Message-ID: <YgYn6jA0i3pFXoCS@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-3-tonylu@linux.alibaba.com>
 <becbfd54-5a42-9867-f3ac-b347b561985f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <becbfd54-5a42-9867-f3ac-b347b561985f@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 08:40:47PM +0100, Stefan Raspl wrote:
> On 1/30/22 19:02, Tony Lu wrote:
> > Based on the manual of TCP_CORK [1] and MSG_MORE [2], these two options
> > have the same effect. Applications can set these options and informs the
> > kernel to pend the data, and send them out only when the socket or
> > syscall does not specify this flag. In other words, there's no need to
> > send data out by a delayed work, which will queue a lot of work.
> > 
> > This removes corked delayed work with SMC_TX_CORK_DELAY (250ms), and the
> > applications control how/when to send them out. It improves the
> > performance for sendfile and throughput, and remove unnecessary race of
> > lock_sock(). This also unlocks the limitation of sndbuf, and try to fill
> > it up before sending.
> > 
> > [1] https://linux.die.net/man/7/tcp
> > [2] https://man7.org/linux/man-pages/man2/send.2.html
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > ---
> >   net/smc/smc_tx.c | 15 ++++++---------
> >   1 file changed, 6 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> > index 7b0b6e24582f..9cec62cae7cb 100644
> > --- a/net/smc/smc_tx.c
> > +++ b/net/smc/smc_tx.c
> > @@ -31,7 +31,6 @@
> >   #include "smc_tracepoint.h"
> >   #define SMC_TX_WORK_DELAY	0
> > -#define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
> >   /***************************** sndbuf producer *******************************/
> > @@ -237,15 +236,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
> >   		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
> >   			conn->urg_tx_pend = true;
> >   		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
> > -		    (atomic_read(&conn->sndbuf_space) >
> > -						(conn->sndbuf_desc->len >> 1)))
> > -			/* for a corked socket defer the RDMA writes if there
> > -			 * is still sufficient sndbuf_space available
> > +		    (atomic_read(&conn->sndbuf_space)))
> > +			/* for a corked socket defer the RDMA writes if
> > +			 * sndbuf_space is still available. The applications
> > +			 * should known how/when to uncork it.
> >   			 */
> > -			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
> > -					   SMC_TX_CORK_DELAY);
> > -		else
> > -			smc_tx_sndbuf_nonempty(conn);
> > +			continue;
> 
> In case we just corked the final bytes in this call, wouldn't this
> 'continue' prevent us from accounting the Bytes that we just staged to be
> sent out later in the trace_smc_tx_sendmsg() call below?
> 
> > +		smc_tx_sndbuf_nonempty(conn);
> >   		trace_smc_tx_sendmsg(smc, copylen);
> 

If the application send out the final bytes in this call, the
application should also clear MSG_MORE or TCP_CORK flag, this action is
required based on the manuals [1] and [2]. So it is safe to cork the data
if flag is setted, and continue to the next loop until application
clears the flag.

[1] https://linux.die.net/man/7/tcp
[2] https://man7.org/linux/man-pages/man2/send.2.html

Thank you,
Tony Lu
