Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192063092E3
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhA3JI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhA3JIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BD7864E0B;
        Sat, 30 Jan 2021 06:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611989048;
        bh=h3a5XHf6SXv8Y7XYccpcBRPS4MT74tUYZNdF8Z39wq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LuuTbv4bm7BG2uahPpTcjUMQtPZO5pAgc9ddsOsOXlGUlWUEYPhyCx9EOnbRwepiR
         WDwaF4zxxXElvuYqU/LBaL96Wlf+Tz+XHcHSXs/neU2KW6uXX5g6dbFH5JvCgvlr9K
         DZf5EzU4rQ/2b0l+C5Vbx37o1HC5Xf6OWl8ggy+VuG5p78OgQBMkdg+As0ZQqeY2FH
         Z3QeozUYH1LHowxvqt1W9dbHjneP54T0qjaaiphFQBk/iRs5R6/wjge6BDgKkGlqTp
         nwz+gRgBinshjoZkz1v5wU4N2XrKylZX0kMX77B1bPlBBoZxMl7xmlcTetpFpMMSy0
         9iDSy1LpIzTmA==
Date:   Fri, 29 Jan 2021 22:44:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 03/15] ice: read security revision to
 ice_nvm_info and ice_orom_info
Message-ID: <20210129224407.0529a802@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129004332.3004826-4-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 16:43:20 -0800 Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The main NVM module and the Option ROM module contain a security
> revision in their CSS header. This security revision is used to
> determine whether or not the signed module should be loaded at bootup.
> If the module security revision is lower than the associated minimum
> security revision, it will not be loaded.
> 
> The CSS header does not have a module id associated with it, and thus
> requires flat NVM reads in order to access it. To do this, take
> advantage of the cached bank information. Introduce a new
> "ice_read_flash_module" function that takes the module and bank to read.
> Implement both ice_read_active_nvm_module and
> ice_read_active_orom_module. These functions will use the cached values
> to determine the active bank and calculate the appropriate offset.
> 
> Using these new access functions, extract the security revision for both
> the main NVM bank and the Option ROM into the associated info structure.
> 
> Add the security revisions to the devlink info output. Report the main
> NVM bank security revision as "fw.mgmt.srev". Report the Option ROM
> security revision as "fw.undi.srev".
> 
> A future patch will add the associated minimum security revisions as
> devlink flash parameters.

This needs a wider discussion. Hopefully we can agree on a reasonably
uniform way of handling this across vendors. Having to fish out
_particular_ version keys out and then target _particular_ parameters
for each vendor is not great.

First off - is there a standard around the version management that we
can base the interface on? What about key management? There's gotta be
a way of revoking keys too, right?


I'd recommend separating the srev patches out of the series so the
other ones can land.
