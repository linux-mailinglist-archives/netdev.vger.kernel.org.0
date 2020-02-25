Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1748A16B891
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgBYEm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:42:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgBYEm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:42:59 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD3E224650;
        Tue, 25 Feb 2020 04:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582605779;
        bh=G4gCqd/vd+8JobpXcLmXv0QCPYwx24qwbbu/HEKeSOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eJXfVDBBXndhv/P+5POyhc9LnCFaPNnJWNxrrax8xjNYsrUW+06QNKix+gwpPYENf
         cA1C0FWa3Duim35OO1n0iGzdE2lwkYGbwe7mg6Tjdlq6u0NfkskyYdE5oVuxfBD60q
         2793WxrSRgracg6Z1sstjkIPh5iu0whLb7sjDoQQ=
Date:   Mon, 24 Feb 2020 20:42:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 09/10] netdevsim: add ACL trap reporting cookie
 as a metadata
Message-ID: <20200224204257.07c7456f@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200224210758.18481-10-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-10-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 22:07:57 +0100, Jiri Pirko wrote:
> +static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
> +					     const char __user *data,
> +					     size_t count, loff_t *ppos)
> +{
> +	struct nsim_dev *nsim_dev = file->private_data;
> +	struct flow_action_cookie *fa_cookie;
> +	size_t cookie_len = count / 2;
> +	ssize_t ret;
> +	char *buf;
> +
> +	if (*ppos != 0)
> +		return 0;

return 0? Should this not be an error?

> +	cookie_len = (count - 1) / 2;

why was cookie_len initialized when it was declared? 

> +	if ((count - 1) % 2)
> +		return -EINVAL;
> +	buf = kmalloc(count, GFP_KERNEL);

Strangely the malloc below has a NOWARN, but this one doesn't?

> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = simple_write_to_buffer(buf, count, ppos, data, count);
> +	if (ret < 0)
> +		goto err_write_to_buffer;
> +
> +	fa_cookie = kmalloc(sizeof(*fa_cookie) + cookie_len,
> +			    GFP_KERNEL | __GFP_NOWARN);
> +	if (!fa_cookie) {
> +		ret = -ENOMEM;
> +		goto err_alloc_cookie;
> +	}
> +
> +	fa_cookie->cookie_len = cookie_len;
> +	ret = hex2bin((u8 *) fa_cookie->cookie, buf, cookie_len);

this u8 cast won't be necessary if type of cookie changes :)

Also I feel like we could just hold onto the ASCII hex buf, 
and simplify the reading side. If the hex part is needed in 
the first place, hexdump and xxd exist..

> +	if (ret)
> +		goto err_hex2bin;
> +	kfree(buf);
> +
> +	spin_lock(&nsim_dev->fa_cookie_lock);
> +	kfree(nsim_dev->fa_cookie);
> +	nsim_dev->fa_cookie = fa_cookie;
> +	spin_unlock(&nsim_dev->fa_cookie_lock);
> +
> +	return count;
> +
> +err_hex2bin:
> +	kfree(fa_cookie);
> +err_alloc_cookie:
> +err_write_to_buffer:

Error labels should be named after what they undo, not after
destination. That makes both the source and target of the jump 
easy to review.

> +	kfree(buf);
> +	return ret;
> +}
