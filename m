Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4262558CE10
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243591AbiHHSzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiHHSzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:55:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E432F4C;
        Mon,  8 Aug 2022 11:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41CFCB8105A;
        Mon,  8 Aug 2022 18:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F522C433C1;
        Mon,  8 Aug 2022 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659984913;
        bh=yff99Hl54xIWNYpq9yhdMz/cTBVGMhnzM72x5OvdS2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lr2xrUztTk+UvlbkoQ8xdaOGPFwA6cmGaHiN802TxIQMgz4mp2+NoAxcYtIuoMPxm
         hZl4hn/lJbeUllnA30x+R8VUtG2ZQWNnC42uMY5HVBg378RuBJCs62pl86bwFAlxxJ
         p3+/ow+1G4fVi6aDGqW8Ls9gEP/nb3AR3AEEhjKb+Qasha5QvWXiZ3lIrMDLXhXaJH
         yiIhBymtEh3dH6djipRGVTNSiP38tidhKPqRewg/1CT4v3H4Dm1Rf+t657vMSMkQkv
         D8NwyWgU9ZWsnVTUWcnEmhXDi3cbaDp+13VDjgXbPAkQn6DymqvWDK6XHY6TZxxuZP
         YDmqQlgsWN82g==
Date:   Mon, 8 Aug 2022 11:55:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v0] idb: Add rtnl_lock to avoid data race
Message-ID: <20220808115511.5b574db2@kernel.org>
In-Reply-To: <20220808081050.25229-1-linma@zju.edu.cn>
References: <20220808081050.25229-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Aug 2022 16:10:50 +0800 Lin Ma wrote:
> The commit c23d92b80e0b ("igb: Teardown SR-IOV before
> unregister_netdev()") places the unregister_netdev() call after the
> igb_disable_sriov() call to avoid functionality issue.
> 
> However, it introduces several race conditions when detaching a device.
> For example, when .remove() is called, the below interleaving leads to
> use-after-free.
> 
>  (FREE from device detaching)      |   (USE from netdev core)
> igb_remove                         |  igb_ndo_get_vf_config
>  igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
>   kfree(adapter->vf_data)          |
>   adapter->vfs_allocated_count = 0 |
>                                    |    memcpy(... adapter->vf_data[vf]
> 
> In short, there are data races between read and write of
> adapter->vfs_allocated_count. To fix this, we can add a new lock to
> protect members in adapter object. However, we cau use the existing
> rtnl_lock just as other drivers do. (See how dpaa2_eth_disconnect_mac is
> protected in dpaa2_eth_remove function). This patch adopts similar
> fixes.
> 
> Fixes: c23d92b80e0b ("igb: Teardown SR-IOV before unregister_netdev()")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index d8b836a85cc3..e86ea4de05f8 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3814,7 +3814,9 @@ static void igb_remove(struct pci_dev *pdev)
>  	igb_release_hw_control(adapter);
>  
>  #ifdef CONFIG_PCI_IOV
> +	rtnl_lock();
>  	igb_disable_sriov(pdev);
> +	rtnl_unlock();
>  #endif
>  
>  	unregister_netdev(netdev);

What about the disable path coming from sysfs? This looks incomplete to
me. Perhaps take a look at commit 1e53834ce541 ("ixgbe: Add locking to
prevent panic when setting sriov_numvfs to zero") for some inspiration.
