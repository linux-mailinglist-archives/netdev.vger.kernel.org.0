Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25136D70A3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbjDDXZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbjDDXZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3924CF2
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60376389E
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5988C433D2;
        Tue,  4 Apr 2023 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680650753;
        bh=7gxOSFPQ750l5H5+2DefYCQTO/YbCx5VV1TnFM0iiF4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gIaoNu4pUeVTvfzSKgBa+F9YweqyNIl8CG7et6Tf52fkot/40J0S0HFbgbBunyXnE
         BpKBp8a4ZvBOtrPYRiVeNSfO5GO7Ae6Q0zb6IPgNzL/ZuGVs8lkxNuxfE39dUyxsVe
         qM5Q8fWrl6qavf/ScDgrfgW1HRs1A2XAGunQgv9ScDvbzHHjod1NyK2iIAy2SXYLdh
         Ci3b9qOhpqMkeKND2aww0tjHwzCU91kI5yH0yTGv8i4qLdYEGqddP+kKLK5fhltp2J
         K2+koeXxyQjB3pwbbUNcozOFjVYnLCT6y0NgkKP68EgDLHYoEbS2BdvNCepVZ6Ah1I
         EQwsbTnp/9K/Q==
Date:   Tue, 4 Apr 2023 16:25:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Max Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <20230404162551.1d45d031@kernel.org>
In-Reply-To: <20230404123015.wzv5l5owgkppoarr@skbuf>
References: <20230402142435.47105-1-glipus@gmail.com>
        <20230403122622.ixpiy2o7irxb3xpp@skbuf>
        <20230402142435.47105-1-glipus@gmail.com>
        <20230403122622.ixpiy2o7irxb3xpp@skbuf>
        <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
        <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
        <20230404123015.wzv5l5owgkppoarr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 15:30:15 +0300 Vladimir Oltean wrote:
> On Mon, Apr 03, 2023 at 09:42:09AM -0600, Max Georgiev wrote:
> > The conversions are going to be easy (that was the point of adding these NDO
> > functions). But there is still a problem of validating these
> > conversions with testing.
> > Unfortunately I don't have an e1000 card available to validate this conversion.
> > I'll let you and Jakub decide what will be the best strategy here.  
> 
> If you can convert one of the drivers under drivers/net/ethernet/freescale/
> with the exception of fec_main.c, or net/dsa/ + drivers/net/dsa/sja1105/
> or drivers/net/dsa/mv88e6xxx/, then I can help with testing.
> 
> By the way, after inspecting the kernel code a bit more, it also looks
> like we need to convert vlan_dev_ioctl() and bond_eth_ioctl() to
> something compatible with lower interfaces using the new and the old
> API, before converting any driver. Otherwise we'll need to do that later
> anyway, when regression reports start coming in. So these 2 are
> non-optional whatever you do.

Alternatively we could have them call back to the core helper
to descend to a lower device. Stuff ifr into struct
kernel_hwtstamp_config for now in case lower is not converted.
