Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06D85E6287
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIVMfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiIVMfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:35:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9C33343B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 05:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4036103A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9185AC433D6;
        Thu, 22 Sep 2022 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663850100;
        bh=RCho8NHeFy85b/l6zIypZJufIiArioxyCG12tYOLbFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a0r8g/LxtCXQ6VpWpMt6MaMPOFM4vKLcFkGcKEYl8c/iwigoeeaktlh+xoojgVn2q
         FuuGIwhIBuwlQcZWJnVrPEeq/sOfqmX0+0+rfzmUJ/RlHaVyX204jjDDINJna5o3zV
         +2Tyi+io+UpNyO0GCrpTUA+ILzuViInpXObttuAUAQjBpu1YTHpv/97LxoUohpUODz
         idluJ3QdVyRjN9Zo1SBzFGTyH9+TeOlDibyi2rHmJD9Da1iVRpfN7i57aViGTwfix2
         r631uLXnSVjya9xaAakCeQ0UxOj5INsdtKZi4M0eDb3UtWI8jS4vaqvbKwDTex41ca
         euZVUUX7azSlw==
Date:   Thu, 22 Sep 2022 05:34:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for
 big packets
Message-ID: <20220922053458.66f31136@kernel.org>
In-Reply-To: <20220922060753-mutt-send-email-mst@kernel.org>
References: <20220901021038.84751-1-gavinl@nvidia.com>
        <20220901021038.84751-3-gavinl@nvidia.com>
        <20220922052734-mutt-send-email-mst@kernel.org>
        <PH0PR12MB5481374E6A14EFC39533F9A8DC4E9@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220922060753-mutt-send-email-mst@kernel.org>
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

On Thu, 22 Sep 2022 06:14:59 -0400 Michael S. Tsirkin wrote:
> It's nitpicking to be frank. v6 arrived while I was traveling
> and I didn't notice it.  I see Jason acked that so I guess I will
> just apply as is.

Oh, you wanna take it? The split on who takes virtio_net is a touch
unclear but if it makes more sense here to go via virtio feel free to
slap my ack on the v6.
