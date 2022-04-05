Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603F24F437F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378140AbiDEUET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573700AbiDETnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D467613D62
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 12:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63010B81F74
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 19:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85388C385A1;
        Tue,  5 Apr 2022 19:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649187664;
        bh=zt1yl89P3VmzN3IQZ9ulH4CA+5tngXhm3zVlUS2JwOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jzg9nqkFHgy0KXU27H/A/h8c8woGOT4/YSoZQWX5fdfeu0CAoGPdGow7mqsozskn4
         VSQpy9JnmFNXGy8kkFcJXi+zzayHGEAI0Tc9xFJUqYkTejMRQL7xqOLwGEoblzxUSl
         IYNVQt6xQermrEnvV2MvVFAu15fehZ9gw4Lcl4NwUi0xSDBW1XLfzzdQkLrmE7Od2B
         RxE2wGhr/RXoclHwNvPK0UGcz2CSe5GDo+9xvbHH6RCMZ9Ftb/f/GCbIvU5UVUmGlx
         xWAeZkYH/NinwqtToSpuWkAu1xs8iRaP5bwk0pVynSWJt3m3sBzY8e2hVtzWyRBEit
         iSEbnIqdHfqpQ==
Date:   Tue, 5 Apr 2022 12:41:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v2] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <20220405124103.1f25e5b5@kernel.org>
In-Reply-To: <20220405001500.1485242-1-iwienand@redhat.com>
References: <20220405001500.1485242-1-iwienand@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Apr 2022 10:15:00 +1000 Ian Wienand wrote:
> As noted in the original commit 685343fc3ba6 ("net: add
> name_assign_type netdev attribute")
> 
>   ... when the kernel has given the interface a name using global
>   device enumeration based on order of discovery (ethX, wlanY, etc)
>   ... are labelled NET_NAME_ENUM.
> 
> That describes this case, so set the default for the devices here to
> NET_NAME_ENUM to better help userspace tools to know if they might
> like to rename them.

Adding Tom and David to CC, please make sure you CC people whose
commits you're mentioning. They may know something.

> This is inspired by inconsistent interface renaming between both
> distributions and within different releases of distributions;

This worries me. Why is UNKNOWN and ENUM treated differently?
Can you point me to the code which pays attention to the assign type?

> particularly with Xen's xen-netfront driver which gets it's device
> from here and is not renamed under CentOS 8, but is under CentOS 9.
> Of course it is ultimately up to userspace (systemd/udev) what happens
> to interfaces marked with with this flag, but providing the naming
> info brings it inline with other common interfaces such as virtio, and
> should ensure better general consistency of renaming behaviour into
> the future.

Can you spell out how netfront gets a different type to virtio?
I see alloc_etherdev_mq() in both cases.

> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index ebcc812735a4..62b89d6f54fd 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -391,7 +391,7 @@ EXPORT_SYMBOL(ether_setup);
>  struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
>  				      unsigned int rxqs)
>  {
> -	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
> +	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_ENUM,
>  				ether_setup, txqs, rxqs);
>  }
>  EXPORT_SYMBOL(alloc_etherdev_mqs);

