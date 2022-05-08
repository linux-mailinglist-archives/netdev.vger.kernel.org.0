Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053251EBDD
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 06:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiEHE7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 00:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiEHE67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 00:58:59 -0400
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9122E0B8
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 21:55:10 -0700 (PDT)
Received: (qmail 55079 invoked by uid 89); 8 May 2022 04:55:09 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 8 May 2022 04:55:09 -0000
Date:   Sat, 7 May 2022 21:55:07 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net] ptp: ocp: have adjtime handle negative delta_ns
 correctly
Message-ID: <20220508045507.ut2t5n2yyxvpoe22@bsd-mbp>
References: <20220505234050.3378-1-jonathan.lemon@gmail.com>
 <a07b0326-19c7-5756-106c-28b52975871d@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a07b0326-19c7-5756-106c-28b52975871d@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 07, 2022 at 01:19:54AM +0100, Vadim Fedorenko wrote:
> On 06.05.2022 00:40, Jonathan Lemon wrote:
> > delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
> > as an u64.  Also, it turns out that timespec64_add_ns() only handles
> > positive values, so the math needs to be updated.
> > 
> > Fix by passing in the correct signed value, then adding to a
> > nanosecond version of the timespec.
> > 
> > Fixes: '90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")'
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >   drivers/ptp/ptp_ocp.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> > index dd45471f6780..65e592ec272e 100644
> > --- a/drivers/ptp/ptp_ocp.c
> > +++ b/drivers/ptp/ptp_ocp.c
> > @@ -841,16 +841,18 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
> >   }
> >   static void
> > -ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
> > +ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, s64 delta_ns)
> >   {
> >   	struct timespec64 ts;
> >   	unsigned long flags;
> >   	int err;
> > +	s64 ns;
> >   	spin_lock_irqsave(&bp->lock, flags);
> >   	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
> >   	if (likely(!err)) {
> > -		timespec64_add_ns(&ts, delta_ns);
> > +		ns = timespec64_to_ns(&ts) + delta_ns;
> > +		ts = ns_to_timespec64(ns);
> 
> Maybe use set_normalized_timespec64 instead of this ugly transformations and
> additional variable?

I don't see how that would work - set_normalized_timespec64 just sets
the ts from a <sec>.<nsec> value.  In this case, delta_ns need to be
added in to the ts value, but timespec64_add_ns() doeesn't handle
negative values, hence the conversion / add / reconversion.
-- 
Jonathan
