Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B616861D0
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBAIiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjBAIix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:38:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC4D5C0EB;
        Wed,  1 Feb 2023 00:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1629B82127;
        Wed,  1 Feb 2023 08:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17A3C433D2;
        Wed,  1 Feb 2023 08:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675240729;
        bh=qHvRar/9hI/0+KcG9vQ/YqqemNly42I2Nf9vAPNClvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtKlmNk+3K/bkQLnx92vIgjcVd009wqQF9HGJBGE2LHl8GUVzlRdCaSiUZPk+IKqY
         ogMIRme2+jeRH+XMlexQh0vrTOfYpEYW94zNxAVmcU9xAwvpMQl4nYXXI1MkQ9F+2d
         r81eux8AGLTM+YOcYhMp6T71as+UtlsFJo64IhJAE5fs7xu+xZq6kmL0M6p7kO12SX
         cZGhY5kI3u6pXq1nkgGusla75uQ/QJ6Rpok+0p2IDdWpTVom/Ve3BUzSUfFVB/jTqs
         C6cKLRSMTDNiojxLmaG2SnvhMgIQLUWvLGtW6kTH8bwqk4M5yi2FpOFaoHRjZ+HXfV
         Qivkiw6E8XYWA==
Date:   Wed, 1 Feb 2023 10:38:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v9 0/8] Add Auxiliary driver support
Message-ID: <Y9olFRJCY980EuRX@unreal>
References: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
 <20230131211228.78dae343@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131211228.78dae343@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 09:12:28PM -0800, Jakub Kicinski wrote:
> On Mon, 30 Jan 2023 21:25:49 -0800 Ajit Khaparde wrote:
> > Add auxiliary device driver for Broadcom devices.
> > The bnxt_en driver will register and initialize an aux device
> > if RDMA is enabled in the underlying device.
> > The bnxt_re driver will then probe and initialize the
> > RoCE interfaces with the infiniband stack.
> > 
> > We got rid of the bnxt_en_ops which the bnxt_re driver used to
> > communicate with bnxt_en.
> > Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> > In most of the cases we used the functions and entry points provided
> > by the auxiliary bus driver framework.
> > And now these are the minimal functions needed to support the functionality.
> > 
> > We will try to work on getting rid of the remaining if we find any
> > other viable option in future.
> 
> Better :)
> 
> Leon, looks good to you as well?

Good enough, we beat this horse to death already.

BTW, it still has useless NULL assignments and variable initializations.

+       aux_priv->edev->en_ops = NULL;
+       kfree(aux_priv->edev);

Thanks

> 
> Note to DaveM/self - this needs to be pulled rather than applied:
> 
> > The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2
> >  Merge branch 'devlink-next'
> > and are available in the git repository at:
> >  https://github.com/ajitkhaparde1/net-next/tree/aux-bus-v9
