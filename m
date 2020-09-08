Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC0B2623BE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIHXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgIHXyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 19:54:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 555BA206A1;
        Tue,  8 Sep 2020 23:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599609275;
        bh=tJnTyQgikg4cDk4nM6e6lv3ZnMyPUSEZ7OoT2akTE9E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bzkkll0rapTAcPqm0jOj223uKUy5Z07td7y/vi0nz8ZCB05ldKZFaBn0wi+e/z8IT
         SC6mPUF/dru6eyTlFZ6hJu6K0FD+zF3wQLfGcqpqVkpyMv0ycmJiwCDw0skDU5XODG
         Z8UwtwZuCUGSVcy9Xn6wAujrQo1oSU9sGb06On0Q=
Date:   Tue, 8 Sep 2020 16:54:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908224812.63434-3-snelson@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 15:48:12 -0700 Shannon Nelson wrote:
> +	dl = priv_to_devlink(ionic);
> +	devlink_flash_update_status_notify(dl, label, NULL, 1, timeout);
> +	start_time = jiffies;
> +	end_time = start_time + (timeout * HZ);
> +	do {
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_go(&ionic->idev, &cmd);
> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +
> +		devlink_flash_update_status_notify(dl, label, NULL,
> +						   (jiffies - start_time) / HZ,
> +						   timeout);

That's not what I meant. I think we can plumb proper timeout parameter
through devlink all the way to user space.

> +	} while (time_before(jiffies, end_time) && (err == -EAGAIN || err == -ETIMEDOUT));
> +
> +	if (err == -EAGAIN || err == -ETIMEDOUT) {
> +		NL_SET_ERR_MSG_MOD(extack, "Firmware wait timed out");
> +		dev_err(ionic->dev, "DEV_CMD firmware wait %s timed out\n", label);
> +	} else if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Firmware wait failed");
> +	} else {
> +		devlink_flash_update_status_notify(dl, label, NULL, timeout, timeout);
> +	}


> +		if (offset > next_interval) {
> +			devlink_flash_update_status_notify(dl, "Downloading",
> +							   NULL, offset, fw->size);
> +			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
> +		}
> +	}
> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 1, 1);

This one wasn't updated.
