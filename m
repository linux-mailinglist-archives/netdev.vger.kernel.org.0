Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2E03BE03F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 02:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGGA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 20:29:18 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:54232 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGA3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 20:29:18 -0400
Received: (qmail 95726 invoked by uid 89); 7 Jul 2021 00:26:32 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 7 Jul 2021 00:26:32 -0000
Date:   Tue, 6 Jul 2021 17:26:30 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Message-ID: <20210707002630.dllukvduy7tlsgtg@bsd-mbp.dhcp.thefacebook.com>
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
 <20210628233835.GB766@hoboy.vegasvil.org>
 <20210702003936.22m2rz7sajkwusaa@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702003936.22m2rz7sajkwusaa@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 03:39:36AM +0300, Vladimir Oltean wrote:
> On Mon, Jun 28, 2021 at 04:38:35PM -0700, Richard Cochran wrote:
> > On Mon, Jun 28, 2021 at 11:25:33AM -0700, Jonathan Lemon wrote:
> > > When creating a PTP device, the configuration block allows
> > > creation of an associated PPS device.  However, there isn't
> > > any way to associate the two devices after creation.
> > >
> > > Set the PPS cookie, so pps_lookup_dev(ptp) performs correctly.
> >
> > Setting lookup_cookie is harmless, AFAICT, but I wonder about the use
> > case.  The doc for pps_lookup_dev() says,
> 
> Harmless you say?
> 
> Let's look at the code in a larger context:
> 
>  struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
>  				     struct device *parent)
>  {
>  	struct ptp_clock *ptp;
>  
>  	...
>  	ptp = kzalloc(...);
>  	...
>  	ptp->info = info;
>  	...
>  
>  	if (ptp->info->do_aux_work) {
>  		...
> +		ptp->pps_source->lookup_cookie = ptp;
>  	}
>  
>  	/* Register a new PPS source. */
>  	if (info->pps) {
>  		struct pps_source_info pps;
>  		...
>  		ptp->pps_source = pps_register_source(&pps, PTP_PPS_DEFAULTS);
>  		...
>  	}
> 
> Notice anything out of the ordinary?
> Like perhaps the fact that ptp->pps_source is an arbitrary NULL pointer
> at the time the assignment to ->lookup_cookie is being made, because it
> is being created later?
> 
> How on earth is this patch supposed to work?

It was added to the wrong code block.  Checking my tree, I seem to have
it located twice - probably a bad patch that I didn't notice, and since
I don't have an do_aux_work, the first one didn't trigger.

Correction follows.
-- 
Jonathan
