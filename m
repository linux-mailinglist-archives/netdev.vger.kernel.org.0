Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEFF6D3320
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDAS1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDAS1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:27:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34651B34F
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2564B80B24
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 18:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978A9C433EF;
        Sat,  1 Apr 2023 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680373626;
        bh=Wv3R/BK8n1ytV+sZEFzM42pucTZj5nYhifZYNvC4lWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOGmk9kA7BVUG+p8tZyCIlwlMttt5vYAIypV2l6PrYJxFoZKOirsNpet3VDl/J46P
         WGGzULpUf+f5pl9Kd7kJwxFZoTFi9/1Syo2A0eNrFNqKxJEd5q7TwTX8Vii2EbLsww
         QXmwLgsYxTGz+kQScx9oLoQaPqiDZwUw533wtYEzHC+UN/VbJ5uEpwMnSoHhJlJlOd
         mayq2Lub0b0N5C2c7iV2J8Vd+IlIXnLt3c6USbjp16jgB7rp9MhmLOHoNrToSkglId
         LCEJCmzyJoFX2KBLiJkedkgFBukenEINtznaQWio/PPf1slPW3+uq49v+AitCUNKI3
         M6ZvSpd0xiI1A==
Date:   Sat, 1 Apr 2023 21:27:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Message-ID: <20230401182701.GA831478@unreal>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-11-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330234628.14627-11-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:46:24PM -0700, Shannon Nelson wrote:
> An auxiliary_bus device is created for each vDPA type VF at VF probe
> and destroyed at VF remove.  The VFs are always removed on PF remove, so
> there should be no issues with VFs trying to access missing PF structures.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>  drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
>  drivers/net/ethernet/amd/pds_core/core.h   |   6 +
>  drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
>  include/linux/pds/pds_auxbus.h             |  16 +++
>  include/linux/pds/pds_common.h             |   1 +
>  6 files changed, 200 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
>  create mode 100644 include/linux/pds/pds_auxbus.h

I feel that this auxbus usage is still not correct.

The idea of auxiliary devices is to partition physical device (for
example PCI device) to different sub-devices, where every sub-device
belongs to different sub-system. It is not intended to create per-VF
devices. 

In your case, you should create XXX vDPA auxiliary devices which are
connected in one-to-one scheme to their PCI VF counterpart.

Thanks
