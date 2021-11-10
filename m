Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE57F44BA5D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 03:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhKJCh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 21:37:26 -0500
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:33990 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229717AbhKJChZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 21:37:25 -0500
Received: from omf07.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 0B5861010B123;
        Wed, 10 Nov 2021 02:34:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id ED630315D73;
        Wed, 10 Nov 2021 02:34:36 +0000 (UTC)
Message-ID: <e8fdc84080c5e87e31525f9f0f61ae629dbcb920.camel@perches.com>
Subject: Re: [PATCH] ptp: Replace snprintf in show functions with  sysfs_emit
From:   Joe Perches <joe@perches.com>
To:     cgel.zte@gmail.com, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Date:   Tue, 09 Nov 2021 18:34:35 -0800
In-Reply-To: <20211110022331.135418-1-yao.jing2@zte.com.cn>
References: <20211110022331.135418-1-yao.jing2@zte.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.85
X-Stat-Signature: 63cot9dgmdrumfjdkigs1o9gnk7rsbj7
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: ED630315D73
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/CGTg9XhoPM6P/omVcpJ9kFTceviZYND0=
X-HE-Tag: 1636511676-736958
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-10 at 02:23 +0000, cgel.zte@gmail.com wrote:
> From: Jing Yao <yao.jing2@zte.com.cn>
> 
> coccicheck complains about the use of snprintf() in sysfs show
> functions:
> WARNING use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
> sense.
[]
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
[]
> diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
[]
> @@ -86,7 +86,7 @@ static ssize_t extts_fifo_show(struct device *dev,
>  	if (!qcnt)
>  		goto out;
>  
> -	cnt = snprintf(page, PAGE_SIZE, "%u %lld %u\n",
> +	cnt = sysfs_emit(page, "%u %lld %u\n",
>  		       event.index, event.t.sec, event.t.nsec);
>  out:
>  	mutex_unlock(&ptp->tsevq_mux);
> @@ -387,7 +387,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
>  
>  	mutex_unlock(&ptp->pincfg_mux);
>  
> -	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
> +	return sysfs_emit(page, "%u %u\n", func, chan);
>  }
>  
>  static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,

If you are going to try to fix these, please do try to fix all of
the instances in the same file.

So here's a macro definition from that file used multiple times:

static ssize_t var##_show(struct device *dev,				\
			   struct device_attribute *attr, char *page)	\
{									\
	struct ptp_clock *ptp = dev_get_drvdata(dev);			\
	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->info->var);	\
}									\
static DEVICE_ATTR(name, 0444, var##_show, NULL);

and another function:

static ssize_t n_vclocks_show(struct device *dev,
			      struct device_attribute *attr, char *page)
{
	struct ptp_clock *ptp = dev_get_drvdata(dev);
	ssize_t size;

	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
		return -ERESTARTSYS;

	size = snprintf(page, PAGE_SIZE - 1, "%u\n", ptp->n_vclocks);

	mutex_unlock(&ptp->n_vclocks_mux);

	return size;
}

and yet another function:

static ssize_t max_vclocks_show(struct device *dev,
				struct device_attribute *attr, char *page)
{
	struct ptp_clock *ptp = dev_get_drvdata(dev);
	ssize_t size;

	size = snprintf(page, PAGE_SIZE - 1, "%u\n", ptp->max_vclocks);

	return size;
}

	

