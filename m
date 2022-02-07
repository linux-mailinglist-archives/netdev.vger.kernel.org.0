Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224A94AB888
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358379AbiBGKNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237653AbiBGKDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:03:17 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17B9C043181;
        Mon,  7 Feb 2022 02:03:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V3p8PEf_1644228192;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3p8PEf_1644228192)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Feb 2022 18:03:12 +0800
Date:   Mon, 7 Feb 2022 18:03:11 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Stefan Raspl <raspl@linux.ibm.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net/smc: Send directly when TCP_CORK is
 cleared
Message-ID: <YgDuX/TW0AKrbnpe@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-2-tonylu@linux.alibaba.com>
 <74aaa8ce-81a4-b048-cee2-b137279d13d5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74aaa8ce-81a4-b048-cee2-b137279d13d5@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 08:13:53PM +0100, Stefan Raspl wrote:
> On 1/30/22 19:02, Tony Lu wrote:
> > According to the man page of TCP_CORK [1], if set, don't send out
> > partial frames. All queued partial frames are sent when option is
> > cleared again.
> > 
> > When applications call setsockopt to disable TCP_CORK, this call is
> > protected by lock_sock(), and tries to mod_delayed_work() to 0, in order
> > to send pending data right now. However, the delayed work smc_tx_work is
> > also protected by lock_sock(). There introduces lock contention for
> > sending data.
> > 
> > To fix it, send pending data directly which acts like TCP, without
> > lock_sock() protected in the context of setsockopt (already lock_sock()ed),
> > and cancel unnecessary dealyed work, which is protected by lock.
> > 
> > [1] https://linux.die.net/man/7/tcp
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > ---
> >   net/smc/af_smc.c |  4 ++--
> >   net/smc/smc_tx.c | 25 +++++++++++++++----------
> >   net/smc/smc_tx.h |  1 +
> >   3 files changed, 18 insertions(+), 12 deletions(-)
> > 
> > diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> > index ffab9cee747d..ef021ec6b361 100644
> > --- a/net/smc/af_smc.c
> > +++ b/net/smc/af_smc.c
> > @@ -2600,8 +2600,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
> >   		    sk->sk_state != SMC_CLOSED) {
> >   			if (!val) {
> >   				SMC_STAT_INC(smc, cork_cnt);
> > -				mod_delayed_work(smc->conn.lgr->tx_wq,
> > -						 &smc->conn.tx_work, 0);
> > +				smc_tx_pending(&smc->conn);
> > +				cancel_delayed_work(&smc->conn.tx_work);
> >   			}
> >   		}
> >   		break;
> > diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> > index be241d53020f..7b0b6e24582f 100644
> > --- a/net/smc/smc_tx.c
> > +++ b/net/smc/smc_tx.c
> > @@ -597,27 +597,32 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
> >   	return rc;
> >   }
> > -/* Wakeup sndbuf consumers from process context
> > - * since there is more data to transmit
> > - */
> > -void smc_tx_work(struct work_struct *work)
> > +void smc_tx_pending(struct smc_connection *conn)
> 
> Could you add a comment that we're expecting lock_sock() to be held when
> calling this function?

I will add it in the next separated patch.

Thank you,
Tony Lu
