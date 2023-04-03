Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB576D5463
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjDCWDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjDCWDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:03:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E7213D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AAD361642
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3884C433D2;
        Mon,  3 Apr 2023 22:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680559394;
        bh=A9VNK2KWKYrWZ9bOCYpXdnsDU/t5Vin/30flyxybR/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S7nT8/Ougy3dXDkOG9QTHkXxh8vbE4RCXtVB4u4lm/zACjW4O8BoGwCDQnV3WhNIt
         xIrA5XyWy6QwbV/68xz/f8x1IUm+n9kqwXgj8vAU3+8ZvkCtynzkGOhEwybX4ggurK
         v1AAWgYHZNgWbpoQul9B7QC4GojQQB1ezDS2brGwcRPQbubQnAK1K5wQ545vxPPPc/
         sYRh2Eb4rDiUaxybyBs5V5MKW1hGxbNFwFK9GgISNOIPukA/z8kEV2MeaTh1vjN9Hp
         fc0P5T4qcr6XuvojDLH9AkFiA7mTz5+SsND6KwW/qWM/ww3AES2f1vE3/eAlflqkLo
         hvCOQRlh7Im6w==
Date:   Mon, 3 Apr 2023 15:03:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH net-next 5/6] net: ethtool: add a mutex protecting
 RSS contexts
Message-ID: <20230403150312.79174a7e@kernel.org>
In-Reply-To: <255a20efdbbaa1cd26f3ae1baf4a3379bf63aa5e.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <255a20efdbbaa1cd26f3ae1baf4a3379bf63aa5e.1680538846.git.ecree.xilinx@gmail.com>
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

On Mon, 3 Apr 2023 17:33:02 +0100 edward.cree@amd.com wrote:
>  	u32			rss_ctx_max_id;
>  	struct idr		rss_ctx;
> +	struct mutex		rss_lock;

Argh, the mutex doubles the size of the state, and most drivers don't
implement this feature.  My thinking was to add a "ethtool state"
pointer to net_device which will be allocated by ethtool on demand
and can hold all ethtool related state.

For psychological reasons primarily (IOW I feel like people shy away
from storing state in the core because it feels expensive to add stuff
to net_device while it would not seem expensive to add it to struct
ethtool_netdev_state).

Maybe we can do the on-demand allocation later - but could we at least
wrap the ethtool-related fields in a separate struct to hold them
together?
