Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C123E09DA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhHDVKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhHDVKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 17:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D0B761040;
        Wed,  4 Aug 2021 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628111398;
        bh=kyjjo4x+2rj4cpmw1MhsIVCuFJHXrKznAAMYYG0wah4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DuOoQpsjchvGC4EZ1N7wnoErYbFoUVYZNtoDNqIduM/pm73s/Z46YQ7zW7/pakX2X
         UM8j2JQj9r7sfmzjNJyEk+a/Is2ucGbClfLRk35mkd9M1qHAvjHlYzWdjws7Ezk08F
         P4TJMkWBam5IvwHKd/9WcdEn0w9rKwpLURv+Kf0eVw/r3bNcnQtibs+kpFJnjCPRKH
         yeQy+fZ3+h/gFgO3fWde8RLWklu7fAEVk8Uth3slPfS8oGgv0gHez2XrJOVgRu4F0u
         pcSDzgXOZlDdt+56eolm/TFVAe/6xbM484r39h6oeuL9PZN2Tbl2rS7qFH3A6uaM/n
         d+be8qwtMSzsA==
Date:   Wed, 4 Aug 2021 14:09:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210804140957.1fd894dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210804033327.345759-1-jonathan.lemon@gmail.com>
References: <20210804033327.345759-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Aug 2021 20:33:27 -0700 Jonathan Lemon wrote:
> +static const struct devlink_param ptp_ocp_devlink_params[] = {
> +};
> +
> +static void
> +ptp_ocp_devlink_set_params_init_values(struct devlink *devlink)
> +{
> +}

Why register empty set of params?

> +static int
> +ptp_ocp_devlink_register(struct devlink *devlink, struct device *dev)
> +{
> +	int err;
> +
> +	err = devlink_register(devlink, dev);
> +	if (err)
> +		return err;
> +
> +	err = devlink_params_register(devlink, ptp_ocp_devlink_params,
> +				      ARRAY_SIZE(ptp_ocp_devlink_params));
> +	ptp_ocp_devlink_set_params_init_values(devlink);
> +	if (err)
> +		goto out;
> +	devlink_params_publish(devlink);
> +
> +	return 0;
> +
> +out:
> +	devlink_unregister(devlink);
> +	return err;
> +}

> +static int
> +ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct ptp_ocp *bp = devlink_priv(devlink);
> +	char buf[32];
> +	int err;
> +
> +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
> +	if (err)
> +		return err;
> +
> +	if (bp->pending_image) {
> +		err = devlink_info_version_stored_put(req,
> +						      "timecard", "pending");

"pending" is not a version. It seems you're talking to the flash
directly, why not read the version?

> +	}
> +
> +	if (bp->image) {
> +		u32 ver = ioread32(&bp->image->version);
> +
> +		if (ver & 0xffff) {
> +			sprintf(buf, "%d", ver);
> +			err = devlink_info_version_running_put(req,
> +							       "timecard",
> +							       buf);
> +		} else {
> +			sprintf(buf, "%d", ver >> 16);
> +			err = devlink_info_version_running_put(req,
> +							       "golden flash",
> +							       buf);

What's the difference between "timecard" and "golden flash"?
Why call firmware for a timecard timecard? We don't call NIC
firmware "NIC".

Drivers using devlink should document what they implement and meaning
of various fields. Please see examples in
Documentation/networking/devlink/

> +		}
> +		if (err)
> +			return err;
> +	}

> +static int
> +ptp_ocp_health_diagnose(struct devlink_health_reporter *reporter,
> +			struct devlink_fmsg *fmsg,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct ptp_ocp *bp = devlink_health_reporter_priv(reporter);
> +	char buf[32];
> +	int err;
> +
> +	if (!bp->gps_lost)
> +		return 0;
> +
> +	sprintf(buf, "%ptT", &bp->gps_lost);
> +	err = devlink_fmsg_string_pair_put(fmsg, "Lost sync at", buf);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static void
> +ptp_ocp_health_update(struct ptp_ocp *bp)
> +{
> +	int state;
> +
> +	state = bp->gps_lost ? DEVLINK_HEALTH_REPORTER_STATE_ERROR
> +			     : DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
> +
> +	if (bp->gps_lost)
> +		devlink_health_report(bp->health, "No GPS signal", NULL);
> +
> +	devlink_health_reporter_state_update(bp->health, state);
> +}
> +
> +static const struct devlink_health_reporter_ops ptp_ocp_health_ops = {
> +	.name = "gps_sync",
> +	.diagnose = ptp_ocp_health_diagnose,
> +};
> +
> +static void
> +ptp_ocp_devlink_health_register(struct devlink *devlink)
> +{
> +	struct ptp_ocp *bp = devlink_priv(devlink);
> +	struct devlink_health_reporter *r;
> +
> +	r = devlink_health_reporter_create(devlink, &ptp_ocp_health_ops, 0, bp);
> +	if (IS_ERR(r))
> +		dev_err(&bp->pdev->dev, "Failed to create reporter, err %ld\n",
> +			PTR_ERR(r));
> +	bp->health = r;
> +}

What made you use devlink health here? Why not just print that "No GPS
signal" message to the logs? Devlink health is supposed to give us
meaningful context dumps and remediation, here neither is used.
