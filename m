Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5A352B32
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 16:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhDBOC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 10:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDBOC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 10:02:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 693C261057;
        Fri,  2 Apr 2021 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617372174;
        bh=s3K4Wdxl6b65FG3Udt8GNekVFtUvsnmMqMflAqm5g7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pJA2uuHT69eee+pddHyNM1UuxGgq1lp1ToFfRh0pISLuoOCm28HRLy3otbwargDP5
         tkEVbP/iL37RCbIidXMURFALeycf6nMjvvxQoUmLuohyk46xrWg6KjywY/ti9+AfZ4
         jLobbHokKclYKwr8BBDaPUdEb/arB7kd2N5sWpwQ=
Date:   Fri, 2 Apr 2021 16:02:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH net-next v8 1/2] net: Add a WWAN subsystem
Message-ID: <YGckDNXbeRoOBQPW@kroah.com>
References: <1617372397-13988-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617372397-13988-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 04:06:36PM +0200, Loic Poulain wrote:
> This change introduces initial support for a WWAN framework. Given the
> complexity and heterogeneity of existing WWAN hardwares and interfaces,
> there is no strict definition of what a WWAN device is and how it should
> be represented. It's often a collection of multiple devices that perform
> the global WWAN feature (netdev, tty, chardev, etc).
> 
> One usual way to expose modem controls and configuration is via high
> level protocols such as the well known AT command protocol, MBIM or
> QMI. The USB modems started to expose that as character devices, and
> user daemons such as ModemManager learnt how to deal with them. This
> initial version adds the concept of WWAN port, which can be created
> by any driver to expose one of these protocols. The WWAN core takes
> care of the generic part, including character device management, and
> rely on port operations to received and submit protocol data.
> 
> Since the different components/devices do no necesserarly know about
> each others, and can be created/removed in different orders, the
> WWAN core ensures that all WAN ports that contribute to the 'whole'
> WWAN feature are grouped under the same virtual WWAN device, relying
> on the provided parent device (e.g. mhi controller, USB device). It's
> a 'trick' I copied from Johannes's earlier WWAN subsystem proposal.
> 
> This initial version is purposely minimalist, it's essentially moving
> the generic part of the previously proposed mhi_wwan_ctrl driver inside
> a common WWAN framework, but the implementation is open and flexible
> enough to allow extension for further drivers.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Always run checkpatch before sending stuff off :(

Anyway, one thing did stand out:

> --- /dev/null
> +++ b/include/linux/wwan.h
> @@ -0,0 +1,127 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> +
> +#ifndef __WWAN_H
> +#define __WWAN_H
> +
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/skbuff.h>
> +
> +/**
> + * enum wwan_port_type - WWAN port types
> + * @WWAN_PORT_AT: AT commands
> + * @WWAN_PORT_MBIM: Mobile Broadband Interface Model control
> + * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
> + * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
> + * @WWAN_PORT_FIREHOSE: XML based command protocol
> + * @WWAN_PORT_MAX
> + */
> +enum wwan_port_type {
> +	WWAN_PORT_AT,
> +	WWAN_PORT_MBIM,
> +	WWAN_PORT_QMI,
> +	WWAN_PORT_QCDM,
> +	WWAN_PORT_FIREHOSE,
> +	WWAN_PORT_MAX,
> +};
> +
> +/**
> + * struct wwan_port - The structure that defines a WWAN port
> + * @type: Port type
> + * @start_count: Port start counter
> + * @flags: Store port state and capabilities
> + * @ops: Pointer to WWAN port operations
> + * @ops_lock: Protect port ops
> + * @dev: Underlying device
> + * @rxq: Buffer inbound queue
> + * @waitqueue: The waitqueue for port fops (read/write/poll)
> + */
> +struct wwan_port {
> +	enum wwan_port_type type;
> +	unsigned int start_count;
> +	unsigned long flags;
> +	const struct wwan_port_ops *ops;
> +	struct mutex ops_lock;
> +	struct device dev;
> +	struct sk_buff_head rxq;
> +	wait_queue_head_t waitqueue;
> +};

No need to put the actual definition of struct wwan_port in this .h
file, keep it private in your .c file to keep wwan drivers from poking
around in it where they shouldn't be :)

thanks,

greg k-h
