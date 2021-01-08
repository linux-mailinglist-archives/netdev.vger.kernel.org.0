Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B1D2EEB30
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbhAHCK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:10:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:14295 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbhAHCK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:10:56 -0500
IronPort-SDR: UgUgcL2Do8tlDxWhsfeSSK3y120PeIPw1txt72cj29FNaRrJ2niXqGpYkMMtYCaXkluDNFjt4v
 Az4X2UsdMPPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="241601783"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="241601783"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 18:10:15 -0800
IronPort-SDR: N67v0aA70R1CbVpDWG5IJqyPmHZjZE5QRETh5lKYQSZmJ7UoltFbrPBaMZfCXgGJ+PAUuksAYf
 oC/nYXt/PvLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="398826424"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jan 2021 18:10:12 -0800
Date:   Fri, 8 Jan 2021 10:05:26 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     andrew@lunn.ch, arnd@arndb.de, lee.jones@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        matthew.gerlach@intel.com, russell.h.weight@intel.com,
        yilun.xu@intel.com
Subject: Re: [RESEND PATCH 2/2] misc: add support for retimers interfaces on
  Intel MAX 10 BMC
Message-ID: <20210108020526.GB13860@yilunxu-OptiPlex-7050>
References: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
 <1609999628-12748-3-git-send-email-yilun.xu@intel.com>
 <X/bTtBUevX5IBPUl@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/bTtBUevX5IBPUl@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:26:12AM +0100, Greg KH wrote:
> On Thu, Jan 07, 2021 at 02:07:08PM +0800, Xu Yilun wrote:
> > This driver supports the ethernet retimers (C827) for the Intel PAC
> > (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
> > 
> > C827 is an Intel(R) Ethernet serdes transceiver chip that supports
> > up to 100G transfer. On Intel PAC N3000 there are 2 C827 chips
> > managed by the Intel MAX 10 BMC firmware. They are configured in 4 ports
> > 10G/25G retimer mode. Host could query their link states and firmware
> > version information via retimer interfaces (Shared registers) on Intel
> > MAX 10 BMC. The driver creates sysfs interfaces for users to query these
> > information.
> 
> Networking people, please look at this sysfs file:
> 
> > +What:		/sys/bus/platform/devices/n3000bmc-retimer.*.auto/link_statusX
> > +Date:		Jan 2021
> > +KernelVersion:	5.12
> > +Contact:	Xu Yilun <yilun.xu@intel.com>
> > +Description:	Read only. Returns the status of each line side link. "1" for
> > +		link up, "0" for link down.
> > +		Format: "%u".
> 
> as I need your approval to add it because it is not the "normal" way for
> link status to be exported to userspace.
> 
> One code issue:
> 
> > +#define to_link_attr(dev_attr) \
> > +	container_of(dev_attr, struct link_attr, attr)
> > +
> > +static ssize_t
> > +link_status_show(struct device *dev, struct device_attribute *attr, char *buf)
> > +{
> > +	struct m10bmc_retimer *retimer = dev_get_drvdata(dev);
> > +	struct link_attr *lattr = to_link_attr(attr);
> > +	unsigned int val;
> > +	int ret;
> > +
> > +	ret = m10bmc_sys_read(retimer->m10bmc, M10BMC_PKVL_LSTATUS, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return sysfs_emit(buf, "%u\n",
> > +			  !!(val & BIT((retimer->id << 2) + lattr->index)));
> > +}
> > +
> > +#define link_status_attr(_index)				\
> > +	static struct link_attr link_attr_status##_index =	\
> > +		{ .attr = __ATTR(link_status##_index, 0444,	\
> > +				 link_status_show, NULL),	\
> > +		  .index = (_index) }
> 
> Why is this a "raw" attribute and not a device attribute?

It is actually a device_attribute. The device_attribute is embedded in
link_attr, like:

  struct link_attr {
	struct device_attribute attr;
	u32 index;
  };

An index for the link is appended along with the device_attribute, so we
could identify which link is being queried on link_status_show(). There
are 4 links and this is to avoid duplicated code like
link_status_1_show(), link_status_2_show() ...

> 
> Please just use a normal DEVICE_ATTR_RO() macro to make it simpler and

DEVICE_ATTR_RO() is to define a standalone device_attribute variable, but
here we are initializing a field in struct link_attr.

Thanks,
Yilun

> easier to understand over time, what you are doing here.  I can't
> determine what is happening with this code now...
> 
> thanks,
> 
> greg k-h
