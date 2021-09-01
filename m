Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CAC3FE62F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbhIAX5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 19:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhIAX5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 19:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F47261026;
        Wed,  1 Sep 2021 23:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630540603;
        bh=aaLgi0sEuIAlvtOwl3t+OVxyfbUzjCfeW7sv7I0NF/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=btTJBGngiF1tRaGOuAxydF+DTfs80CE8+ZF94Y2vD5lhcRxZVoCmScLlBU75RIGGb
         s6x3Rb48fKS0bev0zHXSi1TafvHyL4bL24ZGib5g+uws6zpWKXS5JJZIlgE8UJCICe
         KeasHNoBDG7OLNBHm7quVAgEDetpnVn4JzDyZGW77MsZ0cXXyTlHsFXBIie62mOktW
         JsY0eAdawFpjkXkwW6kfFyuNQW90RNYBfV4CekleRbCeXF42JV15wYT4KWhyhTHJyA
         jhCRQ+kDjrNCV0vn2gfhl1mK3L9Bgeo4IjMRMV0sHLyCkJ+W117dLCSH99Iq+uj7vY
         sDhKjnuVZ4pnw==
Date:   Wed, 1 Sep 2021 16:56:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 08/11] ptp: ocp: Add sysfs attribute
 utc_tai_offset
Message-ID: <20210901165642.3fab8ec2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830235236.309993-9-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
        <20210830235236.309993-9-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 16:52:33 -0700 Jonathan Lemon wrote:
> +static ssize_t
> +utc_tai_offset_show(struct device *dev,
> +		    struct device_attribute *attr, char *buf)
> +{
> +	struct ptp_ocp *bp = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%d\n", bp->utc_tai_offset);
> +}
> +
> +static ssize_t
> +utc_tai_offset_store(struct device *dev,
> +		     struct device_attribute *attr,
> +		     const char *buf, size_t count)
> +{
> +	struct ptp_ocp *bp = dev_get_drvdata(dev);
> +	unsigned long flags;
> +	int err;
> +	s32 val;
> +
> +	err = kstrtos32(buf, 0, &val);
> +	if (err)
> +		return err;
> +
> +	bp->utc_tai_offset = val;

This line should probably be under the lock.

> +	spin_lock_irqsave(&bp->lock, flags);
> +	iowrite32(val, &bp->irig_out->adj_sec);
> +	iowrite32(val, &bp->dcf_out->adj_sec);
> +	spin_unlock_irqrestore(&bp->lock, flags);
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(utc_tai_offset);
