Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1348C1BB2E3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgD1A04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgD1A04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 20:26:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44CDF2072A;
        Tue, 28 Apr 2020 00:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588033615;
        bh=Pb9bN8IqHpeq8oRza2R0WRGwiUzRay12eKKJA2qhwnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kKzU2bX3v6XUtMmQzNgOI5+BdWXj2G+9hnqs9JQUISBRGwvFpop23od8mqWgyeh68
         5v21SmwrVAf2T2wmkd+Fw1BGDnqPh4NdVI3LiQCD8MtxZz4IVlOB6rk3LPAbCCU0RF
         6uuxu3tB0pXdY7XQ2aDAWCQN+1dbOWE5sjevIq70=
Date:   Mon, 27 Apr 2020 17:26:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 00/11] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200427172653.483e032d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 11:37:07 -0700 Jacob Keller wrote:
> This series adds support for the DEVLINK_CMD_REGION_NEW operation, used to
> enable userspace requesting a snapshot of a region on demand.
> 
> This can be useful to enable adding regions for a driver for which there is
> no trigger to create snapshots. By making this a core part of devlink, there
> is no need for the drivers to use a separate channel such as debugfs.
> 
> The primary intent for this kind of region is to expose device information
> that might be useful for diagnostics and information gathering.
> 
> The first few patches refactor regions to support a new ops structure for
> extending the available operations that regions can perform. This includes
> converting the destructor into an op from a function argument.
> 
> Next, patches refactor the snapshot id allocation to use an xarray which
> tracks the number of current snapshots using a given id. This is done so
> that id lifetime can be determined, and ids can be released when no longer
> in use.
> 
> Without this change, snapshot ids remain used forever, until the snapshot_id
> count rolled over UINT_MAX.
> 
> Finally, code to enable the previously unused DEVLINK_CMD_REGION_NEW is
> added. This code enforces that the snapshot id is always provided, unlike
> previous revisions of this series.
> 
> Finally, a patch is added to enable using this new command via the .snapshot
> callback in both netdevsim and the ice driver.
> 
> For the ice driver, a new "nvm-flash" region is added, which will enable
> read access to the NVM flash contents. The intention for this is to allow
> diagnostics tools to gather information about the device. By using a
> snapshot and gathering the NVM contents all at once, the contents can be
> atomic.

Hi Jake,

does iproute2 needs some patches to make this work?

./devlink region new netdevsim/netdevsim1/dummy snapshot_id 1
Command "new" not found

