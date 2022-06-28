Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26055EB01
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiF1R1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiF1R1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F263A1B3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7C7618E2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 17:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E37C3411D;
        Tue, 28 Jun 2022 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656437228;
        bh=u8b/gv47M4ZLvz9Cp8XpruZnsL3G6z7bpTKJIAUGxiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=etrVb1Y1n90E3SS905jqwgvh10BGZHybipn+SqYez1MSm68THc1umxn7yi+4f2R69
         Ah5/nATouQUFbvy74A45EPob/4BpaYs9MV2DR3ffwbE/AqwJ2/O86XpsKgnVRa1Edp
         vcVZLyMjA2EvrgVNA9/0AseaUNwzAqTgiCtIVG58GDjFOZMwfatHDVuAYh+KTuHyeb
         8xk+VSaN0Yq45qWTYdcvZ5NYEberFNLn2C30pIIai9+tTUrsnYgXaWfsDQ62HUB7UZ
         pjElxgK8VuSHkDAyauPUZqLSKCM0dWIYLxXvJWTMVSQBpPp9lmNIFqgrbmmDD8V99t
         /pbPcv8s+CNHg==
Date:   Tue, 28 Jun 2022 10:27:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Piotr Skajewski <piotrx.skajewski@intel.com>,
        netdev@vger.kernel.org,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when
 setting sriov_numvfs to zero
Message-ID: <20220628102707.436e7253@kernel.org>
In-Reply-To: <20220628165346.484849-1-anthony.l.nguyen@intel.com>
References: <20220628165346.484849-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 09:53:46 -0700 Tony Nguyen wrote:
> +	spin_lock_irqsave(&adapter->vfs_lock, flags);
> +
>  	/* set num VFs to 0 to prevent access to vfinfo */
>  	adapter->num_vfs = 0;
>  
> @@ -228,6 +231,8 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
>  	kfree(adapter->mv_list);
>  	adapter->mv_list = NULL;
>  
> +	spin_unlock_irqrestore(&adapter->vfs_lock, flags);

There's a pci_dev_put() in there, are you sure it won't sleep?
