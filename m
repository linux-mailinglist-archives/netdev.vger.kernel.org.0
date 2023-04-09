Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E36DBFB5
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDILyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 07:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDILyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 07:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466663594
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 04:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AAB560C04
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 11:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2781FC433EF;
        Sun,  9 Apr 2023 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681041258;
        bh=vzXjVd4ZeAY1JiQbMhJBn7+AKFeOUJ//UG7KwfJ1AGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6PBYKkWlmonrpBnoCmFskPRyR+zrUE8I4d5KiN5gJDuJvFA/JWGpamvZlg1sUQ71
         qG1oVnB5+MnrwJjkl08ZWTmz1i4M2FwRa2H9nSjXvezHUvmKp/GhORijyPtroSFp4W
         pOnRirNmKtnPYZfPbNL4Xb7gHDu08wGMTtPgSuvI0sVN3xuhoBLAuRAsdG6Xykquwv
         jTi8z/mKiowm6vADvrW2vkxROOLMOO1n4iFdx1JU1a61OAO18GxcTQyMJBiPYqW1te
         thezW8reFRu8yJkiuYne9RtiN/TObQJQwTD++JhnGTFD0C26MA0I6uZ0rBUM6Q3OxJ
         aXb9pR3+Kss5g==
Date:   Sun, 9 Apr 2023 14:54:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 04/14] pds_core: add devlink health facilities
Message-ID: <20230409115414.GC182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-5-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-5-shannon.nelson@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:33PM -0700, Shannon Nelson wrote:
> Add devlink health reporting on top of our fw watchdog.
> 
> Example:
>   # devlink health show pci/0000:2b:00.0 reporter fw
>   pci/0000:2b:00.0:
>     reporter fw
>       state healthy error 0 recover 0
>   # devlink health diagnose pci/0000:2b:00.0 reporter fw
>    Status: healthy State: 1 Generation: 0 Recoveries: 0
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../device_drivers/ethernet/amd/pds_core.rst  | 12 ++++++
>  drivers/net/ethernet/amd/pds_core/Makefile    |  1 +
>  drivers/net/ethernet/amd/pds_core/core.c      |  6 +++
>  drivers/net/ethernet/amd/pds_core/core.h      |  6 +++
>  drivers/net/ethernet/amd/pds_core/devlink.c   | 37 +++++++++++++++++++
>  drivers/net/ethernet/amd/pds_core/main.c      | 22 +++++++++++
>  6 files changed, 84 insertions(+)
>  create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c

<...>

> +int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
> +			      struct devlink_fmsg *fmsg,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct pdsc *pdsc = devlink_health_reporter_priv(reporter);
> +	int err = 0;
> +
> +	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state))

How is this check protected from race with your health workqueue added
in previous patch? 

> +		err = devlink_fmsg_string_pair_put(fmsg, "Status", "dead");
> +	else if (!pdsc_is_fw_good(pdsc))

Same question.

> +		err = devlink_fmsg_string_pair_put(fmsg, "Status", "unhealthy");
> +	else
> +		err = devlink_fmsg_string_pair_put(fmsg, "Status", "healthy");
> +	if (err)
> +		return err;

Thanks
