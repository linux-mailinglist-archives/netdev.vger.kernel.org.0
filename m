Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D774426E5B0
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgIQTzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbgIQTza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 15:55:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2824D22211;
        Thu, 17 Sep 2020 19:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600372075;
        bh=O03REV1rgSCyCkwBoli9TKpOnMCWzisbfzrJ1U47t5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKPmnO6gxsufl63E17b6x7qhI95bQR+tR+/JiipOoPFfzl9dYt8fWc16B+Jjy8Cbm
         SFLv7ACXfBNNZgRVkGW6QmSySA1LHMswQMA5PuCxPmVo0GrpJNq/MwMD9cwDQ8iZ2D
         3Eb8tD7++yFzFle9QMVBOeZe53y/FMvMsn2AIyfo=
Date:   Thu, 17 Sep 2020 12:47:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 2/5] devlink: collect flash notify params
 into a struct
Message-ID: <20200917124753.7bc1d2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917030204.50098-3-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
        <20200917030204.50098-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Sep 2020 20:02:01 -0700 Shannon Nelson wrote:
> The dev flash status notify function parameter lists are getting
> rather long, so add a struct to be filled and passed rather than
> continuously changing the function signatures.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  include/net/devlink.h | 21 ++++++++++++
>  net/core/devlink.c    | 80 +++++++++++++++++++++++--------------------
>  2 files changed, 63 insertions(+), 38 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index f206accf80ad..9ab2014885cb 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -391,6 +391,27 @@ struct devlink_param_gset_ctx {
>  	enum devlink_param_cmode cmode;
>  };
>  
> +/**
> + * struct devlink_flash_notify - devlink dev flash notify data
> + * @cmd: devlink notify command code
> + * @status_msg: current status string
> + * @component: firmware component being updated
> + * @done: amount of work completed of total amount
> + * @total: amount of work expected to be done
> + * @timeout: expected max timeout in seconds
> + *
> + * These are values to be given to userland to be displayed in order
> + * to show current activity in a firmware update process.
> + */
> +struct devlink_flash_notify {
> +	enum devlink_command cmd;

I'd leave out cmd out of the params structure, otherwise I'll be
slightly awkward for drivers to fill in given the current helpers 
are per cmd.

> +	const char *status_msg;
> +	const char *component;
> +	unsigned long done;
> +	unsigned long total;
> +	unsigned long timeout;
> +};
