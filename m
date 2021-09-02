Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1975C3FF1FC
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346381AbhIBRBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:01:36 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:22665 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242920AbhIBRBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:01:36 -0400
Received: (qmail 87515 invoked by uid 89); 2 Sep 2021 17:00:35 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 2 Sep 2021 17:00:35 -0000
Date:   Thu, 2 Sep 2021 10:00:34 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 09/11] ptp: ocp: Add debugfs entry for timecard
Message-ID: <20210902170034.424a5r5vmrdevoo7@bsd-mbp.dhcp.thefacebook.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
 <20210830235236.309993-10-jonathan.lemon@gmail.com>
 <20210901170641.0e9c9481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901170641.0e9c9481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 05:06:41PM -0700, Jakub Kicinski wrote:
> On Mon, 30 Aug 2021 16:52:34 -0700 Jonathan Lemon wrote:
> > Provide a view into the timecard internals for debugging.
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> > +#ifdef CONFIG_DEBUG_FS
> > +#define gpio_map(gpio, bit, pri, sec, def) ({			\
> > +	char *_ans;						\
> > +	if (gpio & (1 << bit))					\
> > +		_ans = pri;					\
> > +	else if (gpio & (1 << (bit + 16)))			\
> > +		_ans = sec;					\
> > +	else							\
> > +		_ans = def;					\
> > +	_ans;							\
> > +})
> > +
> > +#define gpio_multi_map(buf, gpio, bit, pri, sec, def) ({	\
> > +		char *_ans;					\
> > +		_ans = buf;					\
> > +		strcpy(buf, def);				\
> > +		if (gpio & (1 << (bit + 16)))			\
> > +			_ans += sprintf(_ans, "%s ", pri);	\
> > +		if (gpio & (1 << bit))				\
> > +			_ans += sprintf(_ans, "%s ", sec);	\
> > +})
> 
> These can't be static inlines?

Fixed - old habit of writing macros.


> > +static int
> > +ptp_ocp_summary_show(struct seq_file *s, void *data)
> > +{
> > +	struct device *dev = s->private;
> > +	struct ts_reg __iomem *ts_reg;
> > +	u32 sma_in, sma_out, val;
> > +	struct timespec64 ts;
> > +	struct ptp_ocp *bp;
> > +	char *buf, *src;
> > +	bool on;
> > +
> > +	buf = (char *)__get_free_page(GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	sma1_out_show(dev, NULL, buf);
> > +	seq_printf(s, "   sma1: out from %s", buf);
> > +
> > +	sma2_out_show(dev, NULL, buf);
> > +	seq_printf(s, "   sma2: out from %s", buf);
> > +
> > +	sma3_in_show(dev, NULL, buf);
> > +	seq_printf(s, "   sma3: input to %s", buf);
> > +
> > +	sma4_in_show(dev, NULL, buf);
> > +	seq_printf(s, "   sma4: input to %s", buf);
> 
> Why duplicate the data already available via sysfs?

It is convenient to have all the information on 
one page when trying to understand where the signals
are being steered.


[ snip ]

> Driver's are not supposed to depend on debugfs, you should be able to
> carry on and all debugfs functions you pass an error pointer as a
> parent will just return the same error right back.

Ack.

> This should not be necessary. Compiler should remove all those
> functions as dead code when debugfs is not compiled in.

Removed #ifdef - now the _summary function is left in 
and the compiler removes it in the dead code pass.
-- 
Jonathan
