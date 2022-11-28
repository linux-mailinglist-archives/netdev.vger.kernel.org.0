Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2A663A579
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiK1JzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiK1Jy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:54:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BCA193F9;
        Mon, 28 Nov 2022 01:54:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90CCA61086;
        Mon, 28 Nov 2022 09:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE6AC433D6;
        Mon, 28 Nov 2022 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669629295;
        bh=AkgsU+jWeb+x+zRd8foXVBWbd6UpV4fzz2CIoI7J5jU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O6g3FJTSTpgl43Hy6wfLiqbzmO2Z5Gj9HUXhx6969Qa0fyt04ulnVuAALsLhtVErn
         PbINisb2kBSkbEQ8NVVXvKGcOqWA49FtJ+u3UmjWTrn6mQI7bV2F5FgVvKB9OhZGQG
         exxddOE4No31bEHeH1x5VSCcmkJH/9PdncW0jFuz15ihMI2CRgJOpZL3Y36HAs5FlT
         flXjW5obKOa0RtyFGPXd2POJKldDGqbCtnYt3lFClp8MuTFM76mX1ma8RN1ytJTNIl
         +YZXWCveU/Y3UtCfoZ6OOWsXOJbkUhOU6kUMuQsbSyoBnzh/6m+assv6QyW6rRKBli
         K7qJqQghOA5Vw==
Date:   Mon, 28 Nov 2022 11:54:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] bnxt: Use generic HBH removal helper in tx
 path
Message-ID: <Y4SFaovDiiKp1Bw/@unreal>
References: <20221123164159.485728-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123164159.485728-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:41:59PM +0100, Alexander Lobakin wrote:
> From: Coco Li <lixiaoyan@google.com>
> Date: Tue, 22 Nov 2022 15:27:40 -0800
> 
> > Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
> > for IPv6 traffic. See patch series:
> > 'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
> > 
> > This reduces the number of packets traversing the networking stack and
> > should usually improves performance. However, it also inserts a
> > temporary Hop-by-hop IPv6 extension header.
> > 
> > Using the HBH header removal method in the previous path, the extra header
> > be removed in bnxt drivers to allow it to send big TCP packets (bigger
> > TSO packets) as well.
> > 
> > If bnxt folks could help with testing this patch on the driver (as I
> > don't have access to one) that would be wonderful. Thank you!
> > 
> > Tested:
> > Compiled locally
> 
> Please mark "potential" patches with 'RFC'. Then, if/when you get a
> 'Tested-by:', you can spin a "true" v1.

We are getting ton of patches which are "compiled-only".
I won't be such strict with them as long as they stated clearly about it.

Thanks
