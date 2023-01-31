Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9007C6827ED
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjAaJCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjAaJB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014F474E0;
        Tue, 31 Jan 2023 00:58:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE08F6146C;
        Tue, 31 Jan 2023 08:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4D8C433EF;
        Tue, 31 Jan 2023 08:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675155448;
        bh=ISESLkl40Te6umM1VGiHLeoxC2NCXAUuGsERDg2T2Ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZdmeEcJGHXPpZkhbNBV0YJd6M2xFbOvCEdYFdOdqw8HCpra4ZxCEU3PvSkpmu9EF
         qDA/ZdELX1DaOp36+55eJukXKgCA72SJAjByYQzoKvggOPLDQVoAX6MhJ3YeYzHPyk
         VjyYZ1u6H2OW/wbcofU194G/2uIvzMN4vJxT6S6+Jr7P7AvDXhJuZhprfvrHDrH8cp
         nOeDz7IP0XKLGttwMGTuXiuKc2zrmgsy/wyODIyfTX6JnfXvEKLbqFOLssw8AB8ve0
         8pHmGr3FmM2Q6cgkQ5VFAuqW6CnUunG0EHnEhapCEciHMcOrXHsknTRXmQMz1ccCc8
         GgT2S8Iyqjtag==
Date:   Tue, 31 Jan 2023 10:57:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v2 1/3] serdev: Add method to assert break
Message-ID: <Y9jX81zJTM9xzDo2@unreal>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
 <20230130180504.2029440-2-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130180504.2029440-2-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:35:02PM +0530, Neeraj Sanjay Kale wrote:
> Adds serdev_device_break_ctl() and an implementation for ttyport.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
>  drivers/tty/serdev/core.c           | 11 +++++++++++
>  drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
>  include/linux/serdev.h              |  6 ++++++
>  3 files changed, 29 insertions(+)

<...>

> +{
> +	struct serport *serport = serdev_controller_get_drvdata(ctrl);
> +	struct tty_struct *tty = serport->tty;
> +
> +	if (!tty->ops->break_ctl)
> +		return -ENOTSUPP;

Documentation/dev-tools/checkpatch.rst
   429   **ENOTSUPP**
   430     ENOTSUPP is not a standard error code and should be avoided in new patches.
   431     EOPNOTSUPP should be used instead.
   432 
   433     See: https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/

Thanks
