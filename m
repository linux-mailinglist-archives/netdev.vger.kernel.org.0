Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84073334BD
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhCJFMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:12:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:10066 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhCJFLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:11:48 -0500
IronPort-SDR: y7kkgR0tFfWm9Qoe3QgYbgIZCoa+BMSYL3gqjPKZlMeUe5mNvkpuYX/QOEE2XdkiVv30/AuMhU
 Cv4tbXMFuVYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="187752074"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="187752074"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 21:11:48 -0800
IronPort-SDR: S3rCbWxRTbmZxotpMQE1K+syqMEjTPDwHP43DNnqb6sHGHWkq8hFKdTo9jDvpebSODHyX82PeJ
 BPVKvp5cVcTA==
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="509539281"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.121.17])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 21:11:46 -0800
Date:   Tue, 9 Mar 2021 21:11:46 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, alice.michael@intel.com,
        alan.brady@intel.com
Subject: Re: [RFC net-next] iavf: refactor plan proposal
Message-ID: <20210309211146.00002f2d@intel.com>
In-Reply-To: <YEcRHkhJIkZnTgza@unreal>
References: <20210308162858.00004535@intel.com>
        <YEcRHkhJIkZnTgza@unreal>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky wrote:

> > 3) Plan is to make the "new" iavf driver the default iavf once
> >    extensive regression testing can be completed.
> > 	a. Current proposal is to make CONFIG_IAVF have a sub-option
> > 	   CONFIG_IAVF_V2 that lets the user adopt the new code,
> > 	   without changing the config for existing users or breaking
> > 	   them.
> 
> I don't think that .config options are considered ABIs, so it is unclear
> what do you mean by saying "disrupting current users". Instead of the
> complication wrote above, do like any other driver does: perform your
> testing, submit the code and switch to the new code at the same time.

Because this VF driver runs on multiple hardware PFs (they all expose
the same VF device ID) the testing matrix is quite huge and will take
us a while to get through it. We aim to avoid making users's life hard
by having CONFIG_IAVF=m become a surprise new code base behind the back
of the user.

I've always thought that the .config options *are* a sort of ABI,
because when you do "make oldconfig" it tries to pick up your previous
configuration and if, for instance, a driver changes it's Kconfig name,
it will not pick up the old value of the old driver Kconfig name for
the new build, and with either default or ask the user. The way we're
proposing I think will allow the old driver to stay default until the
user answers Y to the "new option" for the new, iecm based code.

> > [1]
> > https://lore.kernel.org/netdev/20200824173306.3178343-1-anthony.l.nguyen@intel.com/
> 
> Please don't introduce module parameters in new code.

Thanks, we certainly won't. :-)
I'm not sure why you commented about module parameters, but the above
link is to the previous submission for a new driver that uses some
common code as a module (iecm) for a new device driver (idpf) we had
sent. The point of this email was to solicit feedback and give notice
about doing a complicated refactor/replace where we end up re-using
iecm for the new version of the iavf code, with the intent to be up
front and working with the community throughout the process. Because of
the complexity, we want do the right thing the first time so we can to
avoid a restart/redesign.

Thanks,
 Jesse
