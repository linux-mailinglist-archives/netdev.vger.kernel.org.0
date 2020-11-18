Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518C42B7326
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgKRAcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKRAcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:32:46 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9CD92067D;
        Wed, 18 Nov 2020 00:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605659565;
        bh=O+dUlNl3bmWfAxsEgXyHiuNMBnDv6mdTILfyBMvVAoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zwiEDk//OgB/AKfAgwZFVLZGZUf1KD+qmqVy4g/G0JR4QMFOiB1ohFnwpG0XTnewM
         Hp0ls4cpAusixlmDJuNq+dg8kNT8HtGJCAnmFmHjEhl2lc5oPQsEMSSm4eszoXEtQH
         kcXh86pPGwuG2xdQyrD2auHJggoqw+P7YAZqTia4=
Date:   Tue, 17 Nov 2020 16:32:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/tun: Call netdev notifiers
Message-ID: <20201117163245.4ff522ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201116104121.20884-1-ms@dev.tdt.de>
References: <20201116104121.20884-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 11:41:21 +0100 Martin Schiller wrote:
> Call netdev notifiers before and after changing the device type.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> ---
> 
> Change from v2:
> use subject_prefix 'net-next' to fix 'fixes_present' issue
> 
> Change from v1:
> fix 'subject_prefix' and 'checkpatch' warnings
> 
> ---
>  drivers/net/tun.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 3d45d56172cb..2d9a00f41023 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3071,9 +3071,13 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>  				   "Linktype set failed because interface is up\n");
>  			ret = -EBUSY;
>  		} else {
> +			call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
> +						 tun->dev);

This call may return an error (which has to be unpacked with
notifier_to_errno()).

>  			tun->dev->type = (int) arg;
>  			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
>  				   tun->dev->type);
> +			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
> +						 tun->dev);
>  			ret = 0;
>  		}
>  		break;

