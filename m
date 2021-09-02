Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5413FE645
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhIBAHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhIBAHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 20:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B205761074;
        Thu,  2 Sep 2021 00:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630541202;
        bh=k4kjH2Wl+ClBT0vRTDa9uxflr3PheMS37HOOqf8K0nI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RvrQ4K0Pc9iuhIAY+ote9SQBR+Dc9kvlp5DVcm4TKurXXF5ur8D9wwtjPdvx/xD0l
         K7+XnPAaX6eC5LUSGBMqxJdjuz2nAbT4/ZNxaAdbJmCg4kXC3/OYic9GgynLHli0wn
         b031DNuSIUQS4pEOo1MZza+LEz9hm7I6ssnr3WPMM19wFXpdw99c32DMx1vQFErGlp
         6lplh5oYcWEw3v1iHHpsZ4iW6B3q/6w6Xm1qiiFpu0UPtqAJPjlBoyec7WkfgoH1jr
         aqvlgV1pV9ti2bgbnMela1meofrJDJu3FuzA6dPIj0OQ4B3pZhAnqBFkReYEtr0j19
         j6pMYJwmS8NFQ==
Date:   Wed, 1 Sep 2021 17:06:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 09/11] ptp: ocp: Add debugfs entry for timecard
Message-ID: <20210901170641.0e9c9481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830235236.309993-10-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
        <20210830235236.309993-10-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 16:52:34 -0700 Jonathan Lemon wrote:
> Provide a view into the timecard internals for debugging.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

> +#ifdef CONFIG_DEBUG_FS
> +#define gpio_map(gpio, bit, pri, sec, def) ({			\
> +	char *_ans;						\
> +	if (gpio & (1 << bit))					\
> +		_ans = pri;					\
> +	else if (gpio & (1 << (bit + 16)))			\
> +		_ans = sec;					\
> +	else							\
> +		_ans = def;					\
> +	_ans;							\
> +})
> +
> +#define gpio_multi_map(buf, gpio, bit, pri, sec, def) ({	\
> +		char *_ans;					\
> +		_ans = buf;					\
> +		strcpy(buf, def);				\
> +		if (gpio & (1 << (bit + 16)))			\
> +			_ans += sprintf(_ans, "%s ", pri);	\
> +		if (gpio & (1 << bit))				\
> +			_ans += sprintf(_ans, "%s ", sec);	\
> +})

These can't be static inlines?

> +static int
> +ptp_ocp_summary_show(struct seq_file *s, void *data)
> +{
> +	struct device *dev = s->private;
> +	struct ts_reg __iomem *ts_reg;
> +	u32 sma_in, sma_out, val;
> +	struct timespec64 ts;
> +	struct ptp_ocp *bp;
> +	char *buf, *src;
> +	bool on;
> +
> +	buf = (char *)__get_free_page(GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	sma1_out_show(dev, NULL, buf);
> +	seq_printf(s, "   sma1: out from %s", buf);
> +
> +	sma2_out_show(dev, NULL, buf);
> +	seq_printf(s, "   sma2: out from %s", buf);
> +
> +	sma3_in_show(dev, NULL, buf);
> +	seq_printf(s, "   sma3: input to %s", buf);
> +
> +	sma4_in_show(dev, NULL, buf);
> +	seq_printf(s, "   sma4: input to %s", buf);

Why duplicate the data already available via sysfs?

> +static int
> +ptp_ocp_debugfs_add_device(struct ptp_ocp *bp)
> +{
> +	struct dentry *d;
> +
> +	d = debugfs_create_dir(dev_name(&bp->dev), ptp_ocp_debugfs_root);
> +	if (IS_ERR(d))
> +		return PTR_ERR(d);

Driver's are not supposed to depend on debugfs, you should be able to
carry on and all debugfs functions you pass an error pointer as a
parent will just return the same error right back.

> +	bp->debug_root = d;
> +
> +	d = debugfs_create_file("summary", 0444, bp->debug_root,
> +				&bp->dev, &ptp_ocp_summary_fops);
> +	if (IS_ERR(d))
> +		goto fail;
> +
> +	return 0;
> +
> +fail:
> +	debugfs_remove_recursive(bp->debug_root);
> +	bp->debug_root = NULL;
> +
> +	return PTR_ERR(d);
> +}
> +
> +static void
> +ptp_ocp_debugfs_remove_device(struct ptp_ocp *bp)
> +{
> +	debugfs_remove_recursive(bp->debug_root);
> +}
> +
> +static int
> +ptp_ocp_debugfs_init(void)
> +{
> +	struct dentry *d;
> +
> +	d = debugfs_create_dir("timecard", NULL);
> +	if (IS_ERR(d))
> +		return PTR_ERR(d);
> +
> +	ptp_ocp_debugfs_root = d;
> +
> +	return 0;
> +}
> +
> +static void
> +ptp_ocp_debugfs_fini(void)
> +{
> +	debugfs_remove_recursive(ptp_ocp_debugfs_root);
> +}
> +#else
> +#define ptp_ocp_debugfs_init()			0
> +#define ptp_ocp_debugfs_fini()
> +#define ptp_ocp_debugfs_add_device(bp)		0
> +#define ptp_ocp_debugfs_remove_device(bp)
> +#endif

This should not be necessary. Compiler should remove all those
functions as dead code when debugfs is not compiled in.

>  static void
>  ptp_ocp_dev_release(struct device *dev)
>  {
