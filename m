Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6126F2ECCAC
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbhAGJZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbhAGJZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 04:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9798323333;
        Thu,  7 Jan 2021 09:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610011492;
        bh=fxwmuL/Qs6SNY83+/gRu2pNV3MxZ86kZSjNwXWJ74FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G3Yg1ETV4XfGyMZzQyLllMyfHX/3AoVFknDJvN9dJlWXdVfcE+EjYxxm7d5VmytOc
         EKlMxR81ioNfI5AOdItG6iKNmzU/Z6Hm5N0OkMr59FKYaiWzECOmXhgCqUKRXk2gD4
         QSwxGuaAfykbTTwut+i4zEvYTeZ1Lm2JFZ9dXjc0=
Date:   Thu, 7 Jan 2021 10:26:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     andrew@lunn.ch, arnd@arndb.de, lee.jones@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        matthew.gerlach@intel.com, russell.h.weight@intel.com
Subject: Re: [RESEND PATCH 2/2] misc: add support for retimers interfaces on
 Intel MAX 10 BMC
Message-ID: <X/bTtBUevX5IBPUl@kroah.com>
References: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
 <1609999628-12748-3-git-send-email-yilun.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609999628-12748-3-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 02:07:08PM +0800, Xu Yilun wrote:
> This driver supports the ethernet retimers (C827) for the Intel PAC
> (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
> 
> C827 is an Intel(R) Ethernet serdes transceiver chip that supports
> up to 100G transfer. On Intel PAC N3000 there are 2 C827 chips
> managed by the Intel MAX 10 BMC firmware. They are configured in 4 ports
> 10G/25G retimer mode. Host could query their link states and firmware
> version information via retimer interfaces (Shared registers) on Intel
> MAX 10 BMC. The driver creates sysfs interfaces for users to query these
> information.

Networking people, please look at this sysfs file:

> +What:		/sys/bus/platform/devices/n3000bmc-retimer.*.auto/link_statusX
> +Date:		Jan 2021
> +KernelVersion:	5.12
> +Contact:	Xu Yilun <yilun.xu@intel.com>
> +Description:	Read only. Returns the status of each line side link. "1" for
> +		link up, "0" for link down.
> +		Format: "%u".

as I need your approval to add it because it is not the "normal" way for
link status to be exported to userspace.

One code issue:

> +#define to_link_attr(dev_attr) \
> +	container_of(dev_attr, struct link_attr, attr)
> +
> +static ssize_t
> +link_status_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct m10bmc_retimer *retimer = dev_get_drvdata(dev);
> +	struct link_attr *lattr = to_link_attr(attr);
> +	unsigned int val;
> +	int ret;
> +
> +	ret = m10bmc_sys_read(retimer->m10bmc, M10BMC_PKVL_LSTATUS, &val);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%u\n",
> +			  !!(val & BIT((retimer->id << 2) + lattr->index)));
> +}
> +
> +#define link_status_attr(_index)				\
> +	static struct link_attr link_attr_status##_index =	\
> +		{ .attr = __ATTR(link_status##_index, 0444,	\
> +				 link_status_show, NULL),	\
> +		  .index = (_index) }

Why is this a "raw" attribute and not a device attribute?

Please just use a normal DEVICE_ATTR_RO() macro to make it simpler and
easier to understand over time, what you are doing here.  I can't
determine what is happening with this code now...

thanks,

greg k-h
