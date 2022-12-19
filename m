Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7448665152C
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiLSWCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiLSWCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:02:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DFD140BA
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2CEB81029
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00569C433D2;
        Mon, 19 Dec 2022 22:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671487331;
        bh=Hxgc80Sjvf2NHVSU5y8wLoO//uw6t0E6b9CzoISOAoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p9VXLFaDQxaVZhZVEdDKn5L5o+pzw2YOd/mXUmsdc8uWJbQwc66Fgw/DucdSytb0o
         IcnibGjBg2QP4lFvtwWO0FvIKYwXvKX6fglxUV0m+Q7XU7/tpjS/xqwIe0T2c4eBOH
         7vgUvmwvKb+nsrwxUvBfiQLzTki8Jf69pnbIoNoitSH4ihVx9Ab8Z/p51l2Qy7Pd73
         IKA8H7Y9cchZmJ7v/mTjIPSKenOhcFEYukt9diJg9kTU5WlXyJ5NuNehzJnBEadpi+
         k3uEQagLx1ABP1dm7tD1PpGnITF2tpqT1UrzMT13keAmQgqQ3bw93gDsxArJJdKstg
         qZAd40KAM0UmA==
Date:   Mon, 19 Dec 2022 14:02:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Message-ID: <20221219140210.241146ea@kernel.org>
In-Reply-To: <ac6f8ab5-3838-4686-fc20-b98b196f82c8@intel.com>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-6-kuba@kernel.org>
        <ac6f8ab5-3838-4686-fc20-b98b196f82c8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Dec 2022 09:56:26 -0800 Jacob Keller wrote:
> > -void devlink_register(struct devlink *devlink)
> > +int devl_register(struct devlink *devlink)
> >  {
> >  	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
> > -	/* Make sure that we are in .probe() routine */
> > +	devl_assert_locked(devlink);
> >  
> >  	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> >  	devlink_notify_register(devlink);
> > +
> > +	return 0;  
> 
> Any particular reason to change this to int when it doesn't have a
> failure case yet? Future patches I assume? You don't check the
> devl_register return value.

I was wondering if anyone would notice :)

Returning errors from the registration helper seems natural,
and if we don't have this ability it may impact our ability
to extend the core in the long run.
I was against making core functions void in the first place.
It's a good opportunity to change back.
