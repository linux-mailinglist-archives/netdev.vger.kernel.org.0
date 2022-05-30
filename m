Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F652538692
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiE3RHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 13:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiE3RHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 13:07:49 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CAA52E77
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 10:07:47 -0700 (PDT)
Received: (qmail 29942 invoked by uid 89); 30 May 2022 17:07:46 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 30 May 2022 17:07:46 -0000
Date:   Mon, 30 May 2022 10:07:44 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, kernel-team@fb.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220530170744.zs6urci5lcytl2j4@bsd-mbp.dhcp.thefacebook.com>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
 <20220529003447.GA32026@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220529003447.GA32026@hoboy.vegasvil.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 28, 2022 at 05:34:47PM -0700, Richard Cochran wrote:
> On Wed, May 18, 2022 at 03:39:35PM -0700, Jonathan Lemon wrote:
> 
> > +static int bcm_ptp_adjtime_locked(struct bcm_ptp_private *priv,
> > +				  s64 delta_ns)
> > +{
> > +	struct timespec64 ts;
> > +	int err;
> > +
> > +	err = bcm_ptp_gettime_locked(priv, &ts, NULL);
> > +	if (!err) {
> > +		set_normalized_timespec64(&ts, ts.tv_sec,
> > +					  ts.tv_nsec + delta_ns);
> 
> This also takes a LONG time when delta is large...

Didn't we just go through this?  What constitutes a "large" offset here?
The current version seems acceptable to me:

root@rpi:~/src/rpi # time phc_ctl /dev/ptp0 -- adj 86400
phc_ctl[766492.486]: adjusted clock by 86400.000000 seconds

real    0m0.009s
user    0m0.002s
sys 0m0.007s

root@rpi:~/src/rpi # time phc_ctl /dev/ptp0 -- adj -86400
phc_ctl[766494.647]: adjusted clock by -86400.000000 seconds

real    0m0.009s
user    0m0.009s
sys 0m0.000s

-- 
Jonathan
