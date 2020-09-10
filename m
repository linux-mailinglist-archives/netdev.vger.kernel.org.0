Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA532652C1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgIJVXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgIJVX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:23:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF4D221E3;
        Thu, 10 Sep 2020 21:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599773006;
        bh=iaV5+nC9PNJOCDC5Q1tTEE3Ml8wCbYPBqNFH3p7Iua8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eqeWX+M4hSLXL3gkGUMoR3D4n/KNDJRStKyULG2B+s7Dq6EPSR4GTrvUp01daI4vX
         LLEIvGVsQPna0izo2F7NKWOY1JQ2ZDUdQPszDUvrQ1NDR5kVpneFr8E+RhylRJ/Aaz
         G0mqEr5VtygCa/YZBzsbnlSmGBBgHYdfqv6KJfPg=
Date:   Thu, 10 Sep 2020 14:23:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v4 2/5] devlink: convert flash_update to use params
 structure
Message-ID: <20200910142324.1932401d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f8c32083-da74-b7cc-e6a0-6b819533897c@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
        <20200909222653.32994-3-jacob.e.keller@intel.com>
        <20200909175545.3ea38a80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f8c32083-da74-b7cc-e6a0-6b819533897c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 13:59:07 -0700 Jacob Keller wrote:
> On 9/9/2020 5:55 PM, Jakub Kicinski wrote:
> > On Wed,  9 Sep 2020 15:26:50 -0700 Jacob Keller wrote:  
> >> The devlink core recently gained support for checking whether the driver
> >> supports a flash_update parameter, via `supported_flash_update_params`.
> >> However, parameters are specified as function arguments. Adding a new
> >> parameter still requires modifying the signature of the .flash_update
> >> callback in all drivers.
> >>
> >> Convert the .flash_update function to take a new `struct
> >> devlink_flash_update_params` instead. By using this structure, and the
> >> `supported_flash_update_params` bit field, a new parameter to
> >> flash_update can be added without requiring modification to existing
> >> drivers.
> >>
> >> As before, all parameters except file_name will require driver opt-in.
> >> Because file_name is a necessary field to for the flash_update to make
> >> sense, no "SUPPORTED" bitflag is provided and it is always considered
> >> valid. All future additional parameters will require a new bit in the
> >> supported_flash_update_params bitfield.  
> > 
> > I keep thinking we should also make the core do the
> > request_firmware_direct(). What else is the driver gonna do with the file name..
> > 
> > But I don't want to drag your series out so:
> > 
> > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> Hmm. What does _direct do? I guess it means it won't fall back to the
> userspace helper if it can't find the firmware? It looks like MLX
> drivers use it, but others seem to just stick to regular request_firmware.

FWIW _direct() is pretty much meaningless today, I think the kernel
support for non-direct is mostly dropped. Systemd doesn't support it
either.

> This seems like an improvement that we can handle in a follow up series
> either way. Thanks for the review!

Agreed. Too many pending patches for this area already :S
