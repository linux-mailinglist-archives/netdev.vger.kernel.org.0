Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6C2EEDF9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhAHHrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbhAHHrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 02:47:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 890D2233EE;
        Fri,  8 Jan 2021 07:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610092026;
        bh=aht0WdMXCPlAoFq0DlnM+/6kealmxDfX0uEiia9bmxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vWX6roBwrJrKKoRl6iEtW14ixgMgYXomRcg1ExcRPNyoKh4jaMUzdTmnVkv3twW4R
         K4tZI0562rr6LGrnJsDAbETE6A3KH/48g+5EQE5YIbtnFSlc2SKf0h23QN9lr9REIj
         ufYwT6idwpnSKYBaT4VySvKkVo8f05E3UOJPueCc=
Date:   Fri, 8 Jan 2021 08:47:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     andrew@lunn.ch, arnd@arndb.de, lee.jones@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        matthew.gerlach@intel.com, russell.h.weight@intel.com
Subject: Re: [RESEND PATCH 2/2] misc: add support for retimers interfaces on
 Intel MAX 10 BMC
Message-ID: <X/gN9godW5uiBtB7@kroah.com>
References: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
 <1609999628-12748-3-git-send-email-yilun.xu@intel.com>
 <X/bTtBUevX5IBPUl@kroah.com>
 <20210108020526.GB13860@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108020526.GB13860@yilunxu-OptiPlex-7050>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 10:05:26AM +0800, Xu Yilun wrote:
> On Thu, Jan 07, 2021 at 10:26:12AM +0100, Greg KH wrote:
> > On Thu, Jan 07, 2021 at 02:07:08PM +0800, Xu Yilun wrote:
> > > This driver supports the ethernet retimers (C827) for the Intel PAC
> > > (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
> > > 
> > > C827 is an Intel(R) Ethernet serdes transceiver chip that supports
> > > up to 100G transfer. On Intel PAC N3000 there are 2 C827 chips
> > > managed by the Intel MAX 10 BMC firmware. They are configured in 4 ports
> > > 10G/25G retimer mode. Host could query their link states and firmware
> > > version information via retimer interfaces (Shared registers) on Intel
> > > MAX 10 BMC. The driver creates sysfs interfaces for users to query these
> > > information.
> > 
> > Networking people, please look at this sysfs file:
> > 
> > > +What:		/sys/bus/platform/devices/n3000bmc-retimer.*.auto/link_statusX
> > > +Date:		Jan 2021
> > > +KernelVersion:	5.12
> > > +Contact:	Xu Yilun <yilun.xu@intel.com>
> > > +Description:	Read only. Returns the status of each line side link. "1" for
> > > +		link up, "0" for link down.
> > > +		Format: "%u".
> > 
> > as I need your approval to add it because it is not the "normal" way for
> > link status to be exported to userspace.
> > 
> > One code issue:
> > 
> > > +#define to_link_attr(dev_attr) \
> > > +	container_of(dev_attr, struct link_attr, attr)
> > > +
> > > +static ssize_t
> > > +link_status_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct m10bmc_retimer *retimer = dev_get_drvdata(dev);
> > > +	struct link_attr *lattr = to_link_attr(attr);
> > > +	unsigned int val;
> > > +	int ret;
> > > +
> > > +	ret = m10bmc_sys_read(retimer->m10bmc, M10BMC_PKVL_LSTATUS, &val);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return sysfs_emit(buf, "%u\n",
> > > +			  !!(val & BIT((retimer->id << 2) + lattr->index)));
> > > +}
> > > +
> > > +#define link_status_attr(_index)				\
> > > +	static struct link_attr link_attr_status##_index =	\
> > > +		{ .attr = __ATTR(link_status##_index, 0444,	\
> > > +				 link_status_show, NULL),	\
> > > +		  .index = (_index) }
> > 
> > Why is this a "raw" attribute and not a device attribute?
> 
> It is actually a device_attribute. The device_attribute is embedded in
> link_attr, like:
> 
>   struct link_attr {
> 	struct device_attribute attr;
> 	u32 index;
>   };
> 
> An index for the link is appended along with the device_attribute, so we
> could identify which link is being queried on link_status_show(). There
> are 4 links and this is to avoid duplicated code like
> link_status_1_show(), link_status_2_show() ...

Duplicated code is better to read than complex code :)

> > Please just use a normal DEVICE_ATTR_RO() macro to make it simpler and
> 
> DEVICE_ATTR_RO() is to define a standalone device_attribute variable, but
> here we are initializing a field in struct link_attr.

Then use the correct initialization macro that is given to you for that,
do not roll your own.

greg k-h
