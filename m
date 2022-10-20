Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8DD60549C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJTA4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJTA4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AEB160221;
        Wed, 19 Oct 2022 17:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 981106190F;
        Thu, 20 Oct 2022 00:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99969C433C1;
        Thu, 20 Oct 2022 00:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666227360;
        bh=2RJYQ8e9m+rLoTQGEA0xbregMWe5Mn5O6syDO6EAIH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=USgRZOGSWTVA6vmBlhwMsz6eAyCSGgmAyI7Gq81PC5Jzdnbk8p2TNaysknUEqvL+Y
         GhWc48kZIzp8iMGe0+gYy841/1vua2x70d6GXBvBpumRt5v/BNiqjyXsolYTszthtl
         8PSOilf24u8tEGjQSRw+Cpj8pE0+I3XDTNY1PW0/gO45USZ0u9twM/yjN/70K1Tmhh
         EFlAO5wxq2twciSdF/DkqxsurFEEyLQ0oWsV/zTIk/PHl/Juf8vY0bFEypxFMqYYHK
         OvdrCYZXb1WRD7waQjTYrc7OaN2FHkF5F9ejF1uaXx4gK6R0b8h24N9u7/2SWjbQJn
         3BMZukr3zwO7A==
Date:   Wed, 19 Oct 2022 17:55:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: usb: qmi_wwan implement tx packets
 aggregation
Message-ID: <20221019175558.0683711d@kernel.org>
In-Reply-To: <Y1AcU0CH/j69uvwx@kroah.com>
References: <20221019132503.6783-1-dnlplm@gmail.com>
        <87lepbsvls.fsf@miraculix.mork.no>
        <Y1AcU0CH/j69uvwx@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 17:48:35 +0200 Greg KH wrote:
> > It's not just that it's not the preferred way.. I believe I promised
> > that we wouldn't add anything more to this interface.  And then I broke
> > that promise, promising that it would never happen again.  So much for
> > my integrity.
> > 
> > This all looks very nice to me, and the results are great, and it's just
> > another knob...
> >   
> 
> Please no more sysfs files for stuff like this.  This turns into
> vendor-specific random files that no one knows how to change over time
> with no way to know what userspace tools are accessing them, or if even
> anyone is using them at all.
> 
> Shouldn't there be standard ethtool apis for this?

Not yet, but there should. We can add the new params to 
struct kernel_ethtool_coalesce, and plumb them thru ethtool netlink.
No major surgery required. Feel free to ask for more guidance if the
netlink-y stuff is confusing.
