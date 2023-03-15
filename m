Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74006BAB19
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjCOIuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjCOIt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278E219130
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A042B61C32
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F220C433EF;
        Wed, 15 Mar 2023 08:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870194;
        bh=1f1GF13OsVmdZUGrxe/AJVGbi2jqhZpmwGQq3XP7yhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V2/uowpd0Jop9QVG2Z7/noF9ECrjGBWQboOeeftIeWZhQl2D9R6naX3I/IiRoakZ+
         nUb4ac/QuvS34ZhrIDO8i2YNfu59K7RmX36tY2Z4naRdT0aK4+qdw2MwTlEI2/e6Y9
         TuCyKLHdlnSRuo1TUxW3MWEoNZ5rgPyq30fLzzSt2+QUVsPk2fHLXE5vkW9fw8PFjP
         jfgQrQiTqybbcnayhhhmnyXyUH33RzQ0fY8iFAPqmm9DNPDMz9aBwA1L4osq/QDmZz
         lmCh0tiSvrCNflfcR+e9gu8PQV2N6QB8x+pfS6ITmzpdPX5CYdpOKtaKRcueC5IDF6
         ldy1uU4VxXSRw==
Date:   Wed, 15 Mar 2023 10:49:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 1/3] iavf: fix inverted Rx hash condition leading to
 disabled hash
Message-ID: <20230315084949.GO36557@unreal>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
 <20230314174423.1048526-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314174423.1048526-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:44:21AM -0700, Tony Nguyen wrote:
> From: Alexander Lobakin <aleksander.lobakin@intel.com>
> 
> Condition, which checks whether the netdev has hashing enabled is
> inverted. Basically, the tagged commit effectively disabled passing flow
> hash from descriptor to skb, unless user *disables* it via Ethtool.
> Commit a876c3ba59a6 ("i40e/i40evf: properly report Rx packet hash")
> fixed this problem, but only for i40e.
> Invert the condition now in iavf and unblock passing hash to skbs again.
> 
> Fixes: 857942fd1aa1 ("i40e: Fix Rx hash reported to the stack by our driver")
> Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
