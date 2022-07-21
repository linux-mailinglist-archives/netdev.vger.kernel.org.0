Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BEB57C58F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiGUHxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiGUHxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090207CB6E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:53:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85E7461E41
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6DAC3411E;
        Thu, 21 Jul 2022 07:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658390012;
        bh=PGjB/1yLagvsn32vpvoGPgBrKKTZz+Oc/GqSgf1V5eA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QsrTE1ta169vx7w3kVsvrWdbAklBuGIadbgFsqqBxMA9M+xpOT0BrCEicfbCbKa2A
         yVI+/ZuMI/2+ej+JQh+xY0TCOgesoFwSCl9osYFBOIIYeMLd6IAlT8IMWtjCn0a89z
         EPWtMGyoo1enb/M+n1J2GLbbB1L4S6mOSMjk6q0BYcpSYqE8YykIQfgBJxWYpIGX0w
         mahnj5Lj1yhLHDW46RXl88sX3vPjCiafgtMGNiZffNpSPZbBYwSAb4KNycPvTxCwN9
         tbmTaEKU8hUaakWwbVckeCQypqAfmy6PJ37ObfZckxk8RM9jJ1ki0jiXYCxtvRWCUF
         +VY1f1tZi9qLg==
Date:   Thu, 21 Jul 2022 10:53:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH 2/2] ice: support dry run of a flash update to
 validate firmware file
Message-ID: <YtkF+NAV68/AVoHh@unreal>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720183433.2070122-3-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 11:34:33AM -0700, Jacob Keller wrote:
> Now that devlink core flash update can handle dry run requests, update
> the ice driver to allow validating a PLDM file in dry_run mode.
> 
> First, add a new dry_run field to the pldmfw context structure. This
> indicates that the PLDM firmware file library should only validate the
> file and verify that it has a matching record. Update the pldmfw
> documentation to indicate this "dry run" mode.
> 
> In the ice driver, let the stack know that we support the dry run
> attribute for flash update by setting the appropriate bit in the
> .supported_flash_update_params field.
> 
> If the dry run is requested, notify the PLDM firmware library by setting
> the context bit appropriately. Don't cancel a pending update during
> a dry run.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  Documentation/driver-api/pldmfw/index.rst      | 10 ++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
>  drivers/net/ethernet/intel/ice/ice_fw_update.c | 14 ++++++++++----
>  include/linux/pldmfw.h                         |  5 +++++
>  lib/pldmfw/pldmfw.c                            | 12 ++++++++++++
>  5 files changed, 39 insertions(+), 5 deletions(-)

<...>

>  struct pldmfw {
>  	const struct pldmfw_ops *ops;
>  	struct device *dev;
> +	bool dry_run;
>  };

Just a nitpick, it is better to write "u8 dry_run : 1;" and not bool.

Thanks
