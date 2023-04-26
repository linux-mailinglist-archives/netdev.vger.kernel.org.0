Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1131D6EEE88
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbjDZGuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbjDZGuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8431721
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 23:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 191FD61CFE
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07DEC4339B;
        Wed, 26 Apr 2023 06:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682491822;
        bh=Z85x9q1ULGl/FiNP3k3i9JrYq0Y0IBknEX8N4549EZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NoA/GhAOVN/3dfeuqrixfkBLErEL5SRaRyqIaBZEzM5EJfXdEZPB5hVffUrFYZY7+
         24W5/Q3SAss15O5ZDq4G52QO7czEKNe7Of7+wL09N5dLZTsH4penrH8C7yAKiCJwLz
         F7z5geliOb3/NY3188I60lwF04SDyMjsu1Z4NqszWDfWedW5phLa4QSHfLzRlekaON
         wL/6s44uQp6FN+PqKJ28Dtti057Lp9aChKyxs9CST8GeDOyUrXD4B5vFuPMKlFG83p
         43wA2e5DLbM5SEt1BvzlSNnJ3iJcHpz2cxTneYiusYU6ZFSYweemfBm8nql+s20Qvh
         R9GML+wFoq5Nw==
Date:   Wed, 26 Apr 2023 09:50:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Ahmed Zaki <ahmed.zaki@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 3/3] iavf: send VLAN offloading caps once after VFR
Message-ID: <20230426065018.GG27649@unreal>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
 <20230425170127.2522312-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425170127.2522312-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:01:27AM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> When the user disables rxvlan offloading and then changes the number of
> channels, all VLAN ports are unable to receive traffic.
> 
> Changing the number of channels triggers a VFR reset. During re-init, when
> VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS is received, we do:
> 1 - set the IAVF_FLAG_SETUP_NETDEV_FEATURES flag
> 2 - call
>     iavf_set_vlan_offload_features(adapter, 0, netdev->features);
> 
> The second step sends to the PF the __default__ features, in this case
> aq_required |= IAVF_FLAG_AQ_ENABLE_CTAG_VLAN_STRIPPING
> 
> While the first step forces the watchdog task to call
> netdev_update_features() ->  iavf_set_features() ->
> iavf_set_vlan_offload_features(adapter, netdev->features, features).
> Since the user disabled the "rxvlan", this sets:
> aq_required |= IAVF_FLAG_AQ_DISABLE_CTAG_VLAN_STRIPPING
> 
> When we start processing the AQ commands, both flags are enabled. Since we
> process DISABLE_XTAG first then ENABLE_XTAG, this results in the PF
> enabling the rxvlan offload. This breaks all communications on the VLAN
> net devices.
> 
> Fix by removing the call to iavf_set_vlan_offload_features() (second
> step). Calling netdev_update_features() from watchdog task is enough for
> both init and reset paths.
> 
> Fixes: 7598f4b40bd6 ("iavf: Move netdev_update_features() into watchdog task")
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 5 -----
>  1 file changed, 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
