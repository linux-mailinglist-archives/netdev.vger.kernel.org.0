Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4F190433
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgCXEMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgCXEMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:12:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F175C20719;
        Tue, 24 Mar 2020 04:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585023143;
        bh=kKkWIuH6N9OHT+NbZu9lOQE+C3S+cHNIU4BRDaGah2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qbgcI1btVjFKerNNtpc+id0CMfBLs5aQY3j90rlX7J7kgACEoCMF9hG6sXdzgQNuB
         vlOIWfUCz+v/iJQlTabyOipDtVDvI+WlfsSAW7KL/hwwRK0qcGWj0iKrJX4gMZpjIr
         DayDVB8SUJ+qQ2y95E9bUEmJTHMZe3Xqvb2H9bc8=
Date:   Mon, 23 Mar 2020 21:12:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>, jesse.brandeburg@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        eugenem@fb.com, jacob.e.keller@intel.com, jiri@resnulli.us,
        michael.chan@broadcom.com, snelson@pensando.io
Subject: Re: [PATCH net-next] devlink: expand the devlink-info documentation
Message-ID: <20200323211221.018e6541@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <39a4640b-7a96-fb84-c5f9-5c3e088ba958@infradead.org>
References: <20200324005024.67605-1-kuba@kernel.org>
        <39a4640b-7a96-fb84-c5f9-5c3e088ba958@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 18:38:57 -0700 Randy Dunlap wrote:
> Hi-
> Here are a few small changes for you to consider:

Thanks a lot for the corrections!

> On 3/23/20 5:50 PM, Jakub Kicinski wrote:
> > diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
> > new file mode 100644
> > index 000000000000..46cea870117d
> > --- /dev/null
> > +++ b/Documentation/networking/devlink/devlink-flash.rst
> > @@ -0,0 +1,88 @@
> > +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +
> > +.. _devlink_flash:
> > +
> > +=============
> > +Devlink Flash
> > +=============
> > +
> > +The ``devlink-flash`` allows updating device firmware. It replaces the  
> 
>    The ``devlink-flash`` {option, mechanism, command, utility, something} allows

API

> > +devlink parameter can be used to control this behavior
> > +(:ref:`Documentation/networking/devlink/devlink-params.rst <devlink_params_generic>`).
> > +
> > +On-disk firmware files are usually stored in ``/lib/firmware/``.
> > +
> > +Firmware Version Management
> > +===========================
> > +
> > +Drivers are expected to implement ``devlink-flash`` and ``devlink-info``
> > +functionality, which together allow for implementing vendor-independent
> > +automated firmware update facilities.
> > +
> > +``devlink-info`` exposes the ``driver`` name and three version groups
> > +(``fixed``, ``running``, ``stored``).
> > +
> > +``driver`` and ``fixed`` group identify the specific device design,  
> 
>    The ``driver`` and ``fixed`` groups

The ``driver`` attribute and ``fixed`` group

(Only ``fixed`` is a group, driver is a single attr.)

> > +e.g. for looking up applicable firmware updates. This is why ``serial_number``
> > +is not part of the ``fixed`` versions (even though it is fixed) - ``fixed``
> > +versions should identify the design, not a single device.
> > +
> > +``running`` and ``stored`` firmware versions identify the firmware running
> > +on the device, and firmware which will be activated after reboot or device
> > +reset.
> > +
> > +The firmware update agent is supposed to be able to follow this simple
> > +algorithm to update firmware contents, regardless of the device vendor:
> > +
> > +.. code-block:: sh
> > +
> > +  # Get unique HW design identifier
> > +  $hw_id = devlink-dev-info['fixed']
> > +
> > +  # Find out which FW flash we want to use for this NIC
> > +  $want_flash_vers = some-db-backed.lookup($hw_id, 'flash')
> > +
> > +  # Update flash if necessary
> > +  if $want_flash_vers != devlink-dev-info['stored']:
> > +      $file = some-db-backed.download($hw_id, 'flash')
> > +      devlink-dev-flash($file)
> > +
> > +  # Find out the expected overall firmware versions
> > +  $want_fw_vers = some-db-backed.lookup($hw_id, 'all')
> > +
> > +  # Update on-disk file if necessary
> > +  if $want_fw_vers != devlink-dev-info['running']:
> > +      $file = some-db-backed.download($hw_id, 'disk')
> > +      write($file, '/lib/firmware/')
> > +
> > +  # Reboot if necessary
> > +  if $want_fw_vers != devlink-dev-info['running']:
> > +     reboot()  
> 
> or device reset?  or is that expected/given already?

We don't have an API to tell use which one is necessary, let me do:

  # Try device reset, if available
  if $want_fw_vers != devlink-dev-info['running']:
     devlink-reset()
     
  # Reboot, if reset wasn't enough
  if $want_fw_vers != devlink-dev-info['running']:
     reboot()
          
> > +       such as serial numbers. See
> > +       :ref:`Documentation/networking/devlink/devlink-flash.rst <devlink_flash>`
> > +       to understand why.
> > +
> >     * - ``running``
> > -     - Represents the version of the currently running component. For
> > -       example the running version of firmware. These versions generally
> > -       only update after a reboot.  
> 
> not reset?
>
> > +     - Group for information about currently running software/firmware.
> > +       These versions often only update after a reboot, sometimes device reset.  
> 
> oh. ok.

Yup, some of the FW controls PCI interfaces etc. which is pretty hard
to update without upsetting the host.

All other suggestions applied, thanks!
