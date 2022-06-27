Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782E655CE6C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiF0T2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240433AbiF0T2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:28:02 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E36D6582
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:27:55 -0700 (PDT)
Received: (qmail 48032 invoked by uid 89); 27 Jun 2022 19:27:54 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 27 Jun 2022 19:27:54 -0000
Date:   Mon, 27 Jun 2022 12:27:52 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@fb.com>,
        Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v1 3/3] ptp_ocp: implement DPLL ops
Message-ID: <20220627192752.ruo4n7imxqch75qg@bsd-mbp.dhcp.thefacebook.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-4-vfedorenko@novek.ru>
 <20220623182813.safjhwvu67i4vu3b@bsd-mbp.dhcp.thefacebook.com>
 <a978c45e-db51-a67c-9240-10eeeaa2db8d@novek.ru>
 <20220623233620.vq7oqzop6lg4nmlb@bsd-mbp.dhcp.thefacebook.com>
 <9d59df64-588c-ef03-e978-89d03d29e0e4@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d59df64-588c-ef03-e978-89d03d29e0e4@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 08:28:34PM +0100, Vadim Fedorenko wrote:
> On 24.06.2022 00:36, Jonathan Lemon wrote:
> > On Fri, Jun 24, 2022 at 12:11:43AM +0100, Vadim Fedorenko wrote:
> > > On 23.06.2022 19:28, Jonathan Lemon wrote:
> > > > On Thu, Jun 23, 2022 at 03:57:17AM +0300, Vadim Fedorenko wrote:
> > > > > From: Vadim Fedorenko <vadfed@fb.com>
> > > > > +static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
> > > > > +{
> > > > > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> > > > > +	int ret;
> > > > > +
> > > > > +	if (bp->sma[sma].mode != SMA_MODE_IN)
> > > > > +		return -1;
> > > > > +
> > > > > +	switch (ptp_ocp_sma_get(bp, sma)) {
> > > > > +	case 0:
> > > > > +		ret = DPLL_TYPE_EXT_10MHZ;
> > > > > +		break;
> > > > > +	case 1:
> > > > > +	case 2:
> > > > > +		ret = DPLL_TYPE_EXT_1PPS;
> > > > > +		break;
> > > > > +	default:
> > > > > +		ret = DPLL_TYPE_INT_OSCILLATOR;
> > > > > +	}
> > > > > +
> > > > > +	return ret;
> > > > > +}
> > > > 
> > > > These case statements switch on private bits.  This needs to match
> > > > on the selector name instead.
> > > > 
> > > 
> > > Not sure that string comparison is a good idea. Maybe it's better to extend
> > > struct ocp_selector with netlink type id and fill it according to hardware?
> > 
> > Sure, that could be an option.  But, as this is DPLL only, how does it
> > handle things when a pin is used for non-clock IO?  In the timecard,
> > for example, we have the frequency counters for input, and the frequency
> > generators/VCC/GND for output.
> > 
> > Actually our HW has a multi-level input, where the DPLL selects its
> > source from an internal mux - this isn't reflected here.  The external
> > pins feed into some complex HW logic, which performs its own priority
> > calculations before presenting the end result as an available selection
> > for the DPLL.
> 
> I don't really know how to deal with such configuration. For now I simply added
> CUSTOM type but I'm not sure how to deal it 'set' functions. Do you have any
> suggestions?

No suggestions other than the API should be able to handle things?

Also, should there be a notifier if the source changes?
-- 
Jonathan
