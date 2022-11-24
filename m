Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C16370CA
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 04:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKXDGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 22:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiKXDGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 22:06:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87CCC9AAA;
        Wed, 23 Nov 2022 19:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97A83B8265E;
        Thu, 24 Nov 2022 03:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165C8C433C1;
        Thu, 24 Nov 2022 03:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669259210;
        bh=lccoEXftS+MhRN5YdTKO774+vLm0l8f8UNQdfunzQ8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NeNqZeCSGTNBt4tWbKHXjkvHTwKyf4A4PdT4Oe+DMPTdYlhWyRKFPr2yiNAUTl8N0
         PD6ePdtMbiL9Y5aWdTUgdPo0fn79xuCJTAvKUtl+xNKbAz+mniYAoop4N49A19Xsod
         q618iYzB+yqFiN6s+tncNmhY/0kQyemyARVEa1YoPHc+vNNFxo6PSn9l1Mk/g5xGZn
         EVSRXL4AADwus1aOa+sZxVHZcbJ4ZseAFUeXhgoe/bluB1SJiOlKs1Vqz5oB2bjJH/
         gfAsH+5ipXb3YzEBbwwO2t1EsapbBBPV04W2XgsBSKb6tRW3ocrx7FkdwfOOR4G8xH
         e+hBqq4dZcy3Q==
Date:   Wed, 23 Nov 2022 19:06:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate
 default information
Message-ID: <20221123190649.6c35b93d@kernel.org>
In-Reply-To: <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
        <20221122201246.0276680f@kernel.org>
        <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
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

On Wed, 23 Nov 2022 18:42:41 +0900 Vincent MAILHOL wrote:
> I see three solutions:
> 
> 1/ Do it in the core, clean up all drivers using
> devlink_info_driver_name_put() and make the function static (i.e.
> forbid the drivers to set the driver name themselves).
> N.B. This first solution does not work for
> devlink_info_serial_number_put() because the core will not always be
> able to provide a default value (e.g. my code only covers USB
> devices).
> 
> 2/ Keep track of which attribute is already set (as you suggested).
> 
> 3/ Do a function devlink_nl_info_fill_default() and let the drivers
> choose to either call that function or set the attributes themselves.
> 
> I would tend to go with a mix of 1/ and 2/.

I think 2/ is best because it will generalize to serial numbers while
1/ will likely not. 3/ is a smaller gain.

Jiri already plumbed thru the struct devlink_info_req which is on the
stack of the caller, per request, so we can add the bool / bitmap for
already reported items there quite easily.
