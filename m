Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D3B163A6D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 03:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgBSCpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 21:45:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgBSCpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 21:45:55 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29CDF24654;
        Wed, 19 Feb 2020 02:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582080354;
        bh=YuFOH9l7fE85V0h10BlpWhvszecBUphygftNwh0F3WE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1HdauLxBMz1xljIuwtQXE2XA8Z3dfRpu2Td4AQTmTSA1L0QcWi83mulj3JPZHrZqZ
         +znYGi44pQo6p7RbU6+CkoFjk88ZwouEyBOpCvR5xevHfWnXv5zDOfbY3366cg8gmW
         pPDVLs0zctYfFnz9b9tuGCXXLuhJYTQhBiielF7g=
Date:   Tue, 18 Feb 2020 18:45:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [RFC PATCH v2 06/22] ice: add basic handler for devlink
 .info_get
Message-ID: <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200214232223.3442651-7-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
        <20200214232223.3442651-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 15:22:05 -0800 Jacob Keller wrote:
> The devlink .info_get callback allows the driver to report detailed
> version information. The following devlink versions are reported with
> this initial implementation:
> 
>  "fw.mgmt" -> The version of the firmware that controls PHY, link, etc
>  "fw.mgmt.api" -> API version of interface exposed over the AdminQ
>  "fw.mgmt.bundle" -> Unique identifier for the firmware bundle
>  "fw.undi.orom" -> Version of the Option ROM containing the UEFI driver
>  "nvm.psid" -> Version of the format for the NVM parameter set
>  "nvm.bundle" -> Unique identifier for the combined NVM image

I spent some time today trying to write up the design choices behind
the original implementation but I think I can't complete that unless 
I understand what the PSID thing really is.

So the original design is motivated by two things:
 - making FW versions understandable / per component (as opposed 
   to the crowded ethtool string)
 - making it possible to automate FW management in a fleet of machines
   across vendors.

The second one is more important.

The design was expecting the following:
 - HW design is uniquely identified by 'fixed' versions;
 - each HW design requires only one FW build (but FW build can cover
   multiple versions of HW);

This is why serial number is not part of the fixed versions, even
though it is fixed. Serial is different per board, users should be 
able to map HW design to the FW version they want to run.

Effectively FW update agent does this:

  # Get unique HW design identifier
  $hw_id = devlink-dev-info['fixed']

  # Find out which FW we want to use for this NIC
  $want_fw_id = some-db-backed.lookup($hw_id)

  # Update if necessary  
  if $want_fw_id != devlink-dev-info['stored']:
     # maybe download the file
     devlink-dev-flash()

  # Reboot if necessary
  if $want_fw_id != devlink-dev-info['running']
     reboot()


dev-info sets can obviously contain multiple values, but field by field
comparison for simple == and != should work just fine.

The complications which had arisen so far are two:
 - even though all components are versioned some customers expressed
   uneasiness of only identifying the components but not the entire
   "build". That's why we added the 'fw.bundle'. When multiple
   components are "bundled" together into a flashable firmware image
   that bundle itself gets and ID.
   I'd expect there to be a bundle for each set of components which are
   distributed as a FW image. IOW bundle ID per type of file that can
   be downloaded from the vendor support site. For max convenience I'd
   think there should be one file that contains all components so
   customers don't have to juggle files. That means overall fw.bundle
   that covers all.
   Note: that fw.bundle is only meaningful if _all_ components are
   unchanged from flash image, so the FW must do a self-check to
   validate any component covered by a bundle id is unchanged.

 - the PSID stuff was added, which IIUC is either (a) an identifier 
   for configuration parameters which are not visible via normal Linux
   tools, or (b) a way for an OEM to label a product.
   This changes where this thing should reside because we don't expect
   OEM to relabel the product/SKU (or do we?) and hence it's a fixed
   version.
   If it's an identifier for random parameters of the board (serdes
   params, temperature info, IDK) which is expected to maybe be updated
   or tuned it should be in running/stored.

   So any further info on what's an EETRACK in your case?

   For MLX there's bunch of documents which tell us how we can create 
   an ini file with parameters, but no info on what those parameters
   actually are. 

   Jiri would you be able to help? Please chime in..


Sorry for the painful review process, it's quite hard to review what
people are doing without knowing the back end. Hopefully above gives
you an idea of the intentions when this code was added :)

I see that the next patch adds a 'fixed' version, so if that's
sufficient to identify your board there isn't any blocker here.

What I'd still like to consider is:
 - if fw.mgmt.bundle needs to be a bundle if it doesn't bundle multiple
   things? If it's hard to inject the build ID into the fw.mgmt version
   that's fine.
 - fw.undi.orom - do we need to say orom? Is there anything else than
   orom for UNDI in the flash?
 - nvm.psid may perhaps be better as nvm.psid.api? Following your
   fw.mgmt.api?
 - nvm.bundle - eetrack sounds mode like a stream, so perhaps this is
   the PSID?

> With this, devlink can now report at least the same information as
> reported by the older ethtool interface. Each section of the
> "firmware-version" is also reported independently so that it is easier
> to understand the meaning.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
