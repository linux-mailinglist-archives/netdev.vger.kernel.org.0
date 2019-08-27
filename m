Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B4B9DB9E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 04:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfH0C0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 22:26:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33244 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbfH0C0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 22:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5SqGZBIwrmkmNStlykOjnufSYN0KRRY7xyvAzyxr6VI=; b=vyi3TFaI3gP8XCMYSs6AZJnCUO
        bQ8ZC0J7Fn1iMShM6+ooKWDhN6D1jPqOtwP31saLp7NT3tLU3WWAAlK+T6hYSb7fGW27ZBDHhj2vy
        Mi3ZaUFQB100K5p82MekTzVRJiho+1IOMJnkkOzSECU1CuC+skAXcS5sqSGeffwPV+lg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2RBk-0000NI-5b; Tue, 27 Aug 2019 04:26:28 +0200
Date:   Tue, 27 Aug 2019 04:26:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190827022628.GD13411@lunn.ch>
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826213339.56909-3-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 02:33:23PM -0700, Shannon Nelson wrote:
> +void ionic_debugfs_add_dev(struct ionic *ionic)
> +{
> +	struct dentry *dentry;
> +
> +	dentry = debugfs_create_dir(ionic_bus_info(ionic), ionic_dir);
> +	if (IS_ERR_OR_NULL(dentry))
> +		return;
> +
> +	ionic->dentry = dentry;
> +}

Hi Shannon

There was recently a big patchset from GregKH which removed all error
checking from drivers calling debugfs calls. I'm pretty sure you don't
need this check here.

> +#ifdef CONFIG_DEBUG_FS
> +
> +void ionic_debugfs_create(void);
> +void ionic_debugfs_destroy(void);
> +void ionic_debugfs_add_dev(struct ionic *ionic);
> +void ionic_debugfs_del_dev(struct ionic *ionic);
> +void ionic_debugfs_add_ident(struct ionic *ionic);
> +#else
> +static inline void ionic_debugfs_create(void) { }
> +static inline void ionic_debugfs_destroy(void) { }
> +static inline void ionic_debugfs_add_dev(struct ionic *ionic) { }
> +static inline void ionic_debugfs_del_dev(struct ionic *ionic) { }
> +static inline void ionic_debugfs_add_ident(struct ionic *ionic) { }
> +#endif

Is this really needed? I would expect there to be stubs for all the
debugfs calls if it is disabled.

> +/**
> + * union drv_identity - driver identity information
> + * @os_type:          OS type (see enum os_type)
> + * @os_dist:          OS distribution, numeric format
> + * @os_dist_str:      OS distribution, string format
> + * @kernel_ver:       Kernel version, numeric format
> + * @kernel_ver_str:   Kernel version, string format
> + * @driver_ver_str:   Driver version, string format
> + */
> +union ionic_drv_identity {
> +	struct {
> +		__le32 os_type;
> +		__le32 os_dist;
> +		char   os_dist_str[128];
> +		__le32 kernel_ver;
> +		char   kernel_ver_str[32];
> +		char   driver_ver_str[32];
> +	};
> +	__le32 words[512];
> +};

> +int ionic_identify(struct ionic *ionic)
> +{
> +	struct ionic_identity *ident = &ionic->ident;
> +	struct ionic_dev *idev = &ionic->idev;
> +	size_t sz;
> +	int err;
> +
> +	memset(ident, 0, sizeof(*ident));
> +
> +	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
> +	ident->drv.os_dist = 0;
> +	strncpy(ident->drv.os_dist_str, utsname()->release,
> +		sizeof(ident->drv.os_dist_str) - 1);
> +	ident->drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
> +	strncpy(ident->drv.kernel_ver_str, utsname()->version,
> +		sizeof(ident->drv.kernel_ver_str) - 1);
> +	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
> +		sizeof(ident->drv.driver_ver_str) - 1);
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +

I don't know about others, but from a privacy prospective, i'm not so
happy about this. This is a smart NIC. It could be reporting back to
Mothership pensando with this information?

I would be happier if there was a privacy statement, right here,
saying what this information is used for, and an agreement it is not
used for anything else. If that gets violated, you can then only blame
yourself when we ripe this out and hard code it to static values.

	 Andrew
