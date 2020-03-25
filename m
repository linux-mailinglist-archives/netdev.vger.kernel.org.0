Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65C4191FC2
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgCYDbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgCYDbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 23:31:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE98320724;
        Wed, 25 Mar 2020 03:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585107071;
        bh=rOlKHbNH2NIOCD5rD5efm2BHNUx8T4kkNTCjUHISaA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VFEBvTF38dngbWKGfCmwPED5ssBMPfhRG/W2eyF6wtz+31RHwKZ+YjrNQUW42JtjZ
         O5kQ3zgsaN00eS06s1V+iFuwR/ESCBZ4P755Ni+mrDZvp7tglKDemsM2s9Y5/0qp7Y
         jqSGNZqS9oPGtFgscZujVRVfM9YDZteKXu1skpXA=
Date:   Tue, 24 Mar 2020 20:31:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/15] devlink: Add packet trap policers
 support
Message-ID: <20200324203109.71e1efc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324193250.1322038-2-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 21:32:36 +0200 Ido Schimmel wrote:
> +/**
> + * devlink_trap_policers_register - Register packet trap policers with devlink.
> + * @devlink: devlink.
> + * @policers: Packet trap policers.
> + * @policers_count: Count of provided packet trap policers.
> + *
> + * Return: Non-zero value on failure.
> + */
> +int
> +devlink_trap_policers_register(struct devlink *devlink,
> +			       const struct devlink_trap_policer *policers,
> +			       size_t policers_count)
> +{
> +	int i, err;
> +
> +	mutex_lock(&devlink->lock);
> +	for (i = 0; i < policers_count; i++) {
> +		const struct devlink_trap_policer *policer = &policers[i];
> +
> +		if (WARN_ON(policer->id == 0)) {
> +			err = -EINVAL;
> +			goto err_trap_policer_verify;
> +		}
> +
> +		err = devlink_trap_policer_register(devlink, policer);
> +		if (err)
> +			goto err_trap_policer_register;
> +	}
> +	mutex_unlock(&devlink->lock);
> +
> +	return 0;
> +
> +err_trap_policer_register:
> +err_trap_policer_verify:

nit: as you probably know the label names are not really in compliance
with:
https://www.kernel.org/doc/html/latest/process/coding-style.html#centralized-exiting-of-functions
;)

> +	for (i--; i >= 0; i--)
> +		devlink_trap_policer_unregister(devlink, &policers[i]);
> +	mutex_unlock(&devlink->lock);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
