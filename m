Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4366062A466
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKOVoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKOVoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:44:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02DAF71
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:44:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684E161A2B
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41BFC433D6;
        Tue, 15 Nov 2022 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668548655;
        bh=/HjHVvtx5jP1sbU5hk0a3b1A0atv3eB8k/eItv58qVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X3zZ8Rx+2VxS8EPp+4D4qIplm+eh7KAzii+kBbTbt0Gb2KkX+XN0ozX7nPij3yryB
         dmIbIszkBIDa2F2ocvTik9JBJ1kQ/N5vSC29VErVLmk2dDFV+nbb3TBYWrNUZg3vrb
         OhQwfPz99Os+8IICU/mKh96yNqbwbwLBlhvMCkFG0QtN/uKtJkp3vQFMznXZ1/G/VI
         9+mjIhZhVI3paW4voorXRfnNMuNPtUOovc2Vf7mhVSl8dk0oz+kluzEVfx3yRpWVIM
         FPVHxmc3BNEIx1km9diKBUGMw3Cd3aOIgURinsx3E+8QJoAEYjPG7IOv1UGPhxADZd
         opbSEjBUDt2qQ==
Date:   Tue, 15 Nov 2022 13:44:09 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, radhac@marvell.com, netdev@vger.kernel.org,
        yangyingliang@huawei.com
Subject: Re: [PATCH] octeontx2-af: Fix reference count issue in rvu_sdp_init()
Message-ID: <Y3QIKb3+VqqYecX9@x130.lan>
References: <20221114132823.22584-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221114132823.22584-1-wangxiongfeng2@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 21:28, Xiongfeng Wang wrote:
>pci_get_device() will decrease the reference count for the *from*
>parameter. So we don't need to call put_device() to decrease the
>reference. Let's remove the put_device() in the loop and only decrease
>the reference count of the returned 'pdev' for the last loop because it
>will not be passed to pci_get_device() as input parameter. Also add
>pci_dev_put() for the error path.
>
>Fixes: fe1939bb2340 ("octeontx2-af: Add SDP interface support")
>Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>---

Reviewed-by: Saeed Mahameed <saeed@kernel.org>


> drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
>index b04fb226f708..283d1c90e083 100644
>--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
>+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
>@@ -62,15 +62,19 @@ int rvu_sdp_init(struct rvu *rvu)
> 		pfvf->sdp_info = devm_kzalloc(rvu->dev,
> 					      sizeof(struct sdp_node_info),
> 					      GFP_KERNEL);
>-		if (!pfvf->sdp_info)
>+		if (!pfvf->sdp_info) {
>+			pci_dev_put(pdev);
> 			return -ENOMEM;
>+		}
>
> 		dev_info(rvu->dev, "SDP PF number:%d\n", sdp_pf_num[i]);
>
>-		put_device(&pdev->dev);
> 		i++;
> 	}
>
>+	if (pdev)
>+		pci_dev_put(pdev);
>+

you can drop the if(pdev), already checked inside pci_dev_put();

