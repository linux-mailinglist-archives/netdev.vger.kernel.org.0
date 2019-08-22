Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA19198D04
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfHVIIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:08:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:45826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbfHVIIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 04:08:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BDBFAF18;
        Thu, 22 Aug 2019 08:08:17 +0000 (UTC)
Message-ID: <1566461295.8347.19.camel@suse.com>
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
From:   Oliver Neukum <oneukum@suse.com>
To:     Charles.Hyde@dellteam.com, gregkh@linuxfoundation.org
Cc:     Mario.Limonciello@dell.com, nic_swsd@realtek.com,
        linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 22 Aug 2019 10:08:15 +0200
In-Reply-To: <1566430506442.20925@Dellteam.com>
References: <1566339522507.45056@Dellteam.com>
        ,<20190820222602.GC8120@kroah.com> <1566430506442.20925@Dellteam.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 21.08.2019, 23:35 +0000 schrieb
Charles.Hyde@dellteam.com:
> <snipped>
> > 
> > This is a VERY cdc-net-specific function.  It is not a "generic" USB
> > function at all.  Why does it belong in the USB core?  Shouldn't it live
> > in the code that handles the other cdc-net-specific logic?
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Thank you for this feedback, Greg.  I was not sure about adding this to message.c, because of the USB_CDC_GET_NET_ADDRESS.  I had found references to SET_ADDRESS in the USB protocol at https://wiki.osdev.org/Universal_Serial_Bus#USB_Protocol.  If one wanted a generic USB function for SET_ADDRESS, to be used for both sending a MAC address and receiving one, how would you suggest this be implemented?  This is a legit question because I am curious.

Your implementation was, except for missing error handling, usable.
The problem is where you put it. CDC messages exist only for CDC
devices. Now it is true that there is no generic CDC driver.
Creating a module just for that would cost more memory than it saves
in most cases.
But MACs are confined to network devices. Hence the functionality
can be put into usbnet. It should not be put into any individual
driver, so that every network driver can use it without duplication.

> Your feedback led to moving the functionality into cdc_ncm.c for today's testing, and removing all changes from messages.c, usb.h, usbnet.c, and usbnet.h.  This may be where I end up long term, but I would like to learn if there is a possible solution that could live in message.c and be callable from other USB-to-Ethernet aware drivers.

All those drivers use usbnet. Hence there it should be.

	Regards
		Oliver

