Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9AA25E9E1
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 21:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgIETwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 15:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbgIETwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 15:52:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BC8B20709;
        Sat,  5 Sep 2020 19:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599335536;
        bh=Q9QKlKAy5WDG4bjR6XhzeAl485lEc9UgNo1yAaPcb8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UUPRAfmgPw8o1zHUb8BvKU56bF9GZEMDJQmf01V3agzuRqQfP/GVPwLj5boW7kAp+
         XFskqii7hbRb9fiLb4oaoYjb9AK5TFD6I8pVL5JitNA/C1ifYBEc+8mUDCYr0y6rel
         ModWb5ToHX1pstK2isMBKpf03B56J8EakaXpc9Ig=
Date:   Sat, 5 Sep 2020 12:52:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200905125214.7a13b32b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904000534.58052-3-snelson@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
        <20200904000534.58052-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 17:05:34 -0700 Shannon Nelson wrote:
> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 0, fw->size);
> +	offset = 0;
> +	next_interval = fw->size / IONIC_FW_INTERVAL_FRACTION;
> +	while (offset < fw->size) {
> +		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		memcpy_toio(&idev->dev_cmd_regs->data, fw->data + offset, copy_sz);
> +		ionic_dev_cmd_firmware_download(idev,
> +						offsetof(union ionic_dev_cmd_regs, data),
> +						offset, copy_sz);
> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err) {
> +			netdev_err(netdev,
> +				   "download failed offset 0x%x addr 0x%lx len 0x%x\n",
> +				   offset, offsetof(union ionic_dev_cmd_regs, data),
> +				   copy_sz);
> +			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
> +			goto err_out;
> +		}
> +		offset += copy_sz;
> +
> +		if (offset > next_interval) {
> +			devlink_flash_update_status_notify(dl, "Downloading",
> +							   NULL, offset, fw->size);
> +			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
> +		}
> +	}
> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 1, 1);

This is quite awkward. You send a notification with a different size,
and potentially an unnecessary one if last iteration of the loop
triggered offset > next_interval.

Please just add || offset == fw->size to the condition at the end of
the loop and it will always trigger, with the correct length.
