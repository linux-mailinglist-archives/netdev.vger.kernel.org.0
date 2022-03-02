Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674A44C9AA4
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiCBBmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiCBBmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:42:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE05A1444;
        Tue,  1 Mar 2022 17:41:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B64ACE2080;
        Wed,  2 Mar 2022 01:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46113C340EE;
        Wed,  2 Mar 2022 01:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646185282;
        bh=0uq04TIw16sFFqGnO4Xc0RqH2SMYpo02cxq8yHyjHEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hax7RNqq32w5+aztR8fik2izzY7o6yMJBICL+Hw+7S3XxcFZPbW8h479Ail8YBEPo
         OBJCtcP8wws2LlCFR7YJYFTcL1Sw6ZkO8v7coQa7SJzI4K73RNUpq9D12QDK3w8fXr
         KNwVFViHBPHzCz57vfgbWJblHJmsyJ2q14ETGPDnoROyXUy2qU3KISeYUjkj4LzGKh
         bdXfQlpQI9Smw84WOhmuydRDEx6d7l+T4rlTw5N7Hxpe/LevZGRFQNeYY2zo1OpFKe
         mntL8dvQmzjvDXsTdNp64cApey5uR1kkilspz0SoLAiMPy4OpjlHBcXv43dzDzmHoN
         N1aT5LkUa9n9g==
Date:   Tue, 1 Mar 2022 17:41:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yeqi Fu <fufuyqqqqqq@gmail.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>
Subject: Re: [PATCH v1] dpaa2-switch: fix memory leak of
 dpaa2_switch_acl_entry_add
Message-ID: <20220301174120.0722aed4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301141544.13411-1-fufuyqqqqqq@gmail.com>
References: <a87a691a-62c2-5b42-3be8-ee1161281ad8@suse.de>
        <20220301141544.13411-1-fufuyqqqqqq@gmail.com>
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

On Tue,  1 Mar 2022 22:15:44 +0800 Yeqi Fu wrote:
> @@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>  			 DMA_TO_DEVICE);
>  	if (err) {
>  		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
> +		kfree(cmd_buff);
>  		return err;
>  	}

With more context:

                return -EFAULT;
        }
 
        err = dpsw_acl_add_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
                                 filter_block->acl_id, acl_entry_cfg);
 
        dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
                         DMA_TO_DEVICE);
        if (err) {
                dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+               kfree(cmd_buff);
                return err;
        }
 
        kfree(cmd_buff);
 
        return 0;
 }

Here we see unmap is "pulled up" above the error check, same thing can
be done with the kfree(). Otherwise it looks slightly weird - the
buffer unmap and kfree are conceptually part of releasing the buffer,
yet they are split across the paths.
