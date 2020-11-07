Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BAA2AA73E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgKGRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgKGRgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:36:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8362F20878;
        Sat,  7 Nov 2020 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604770609;
        bh=874pholEmXT2touwGXcTDWWif65SywS94Aw8a8cb5u4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V5ORt+wnKnfRW+jbwFFDoYHYnC2m8Q8q2HJrJ0g/jkl1H1RDDGKAF8mU6MMLJa0xk
         9MYIFtVLQHACJzw4DtTQmlrlCocjFuLb0tHUyXKWz+r70U3y7+yTDYzsHiZ16dhEiP
         n0R1msx+B+grW/KAJ8BADfEttC4Ku6o2FdT6c6RM=
Date:   Sat, 7 Nov 2020 09:36:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Samuel Zou <zou_wei@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V2] [PATCH] net/ethernet: update ret when ptp_clock is ERROR
Message-ID: <20201107093647.3a143f67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107145816.GB9653@hoboy.vegasvil.org>
References: <1604720323-3586-1-git-send-email-wangqing@vivo.com>
        <20201107145816.GB9653@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Nov 2020 06:58:16 -0800 Richard Cochran wrote:
> On Sat, Nov 07, 2020 at 11:38:38AM +0800, Wang Qing wrote:
> > We always have to update the value of ret, otherwise the error value
> >  may be the previous one. And ptp_clock_register() never return NULL
> >  when PTP_1588_CLOCK enable, so we use IS_ERR here.
> > 
> > Signed-off-by: Wang Qing <wangqing@vivo.com>

Wang Qing please send a v3. Please add an appropriate Fixes tag, since
this is a fix, and put [PATCH net] in the subject instead of just
[PATCH] to clarify that you expect the patch to be applied to the
net tree.

> > diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> > index 75056c1..ec8e56d
> > --- a/drivers/net/ethernet/ti/am65-cpts.c
> > +++ b/drivers/net/ethernet/ti/am65-cpts.c
> > @@ -998,11 +998,10 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
> >  	am65_cpts_settime(cpts, ktime_to_ns(ktime_get_real()));
> >  
> >  	cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);
> > -	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {  
> 
> This test was correct.
> 
> > +	if (IS_ERR(cpts->ptp_clock)) {  
> 
> This one is wrong.

Please fix this as Richard requests.

> >  		dev_err(dev, "Failed to register ptp clk %ld\n",
> >  			PTR_ERR(cpts->ptp_clock));
> > -		if (!cpts->ptp_clock)
> > -			ret = -ENODEV;
> > +		ret = PTR_ERR(cpts->ptp_clock);

But keep this part as is, because your code from v1 looks like it
wouldn't even build.

Thank you!

> >  		goto refclk_disable;
> >  	}
> >  	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
> > -- 
> > 2.7.4
> >   

