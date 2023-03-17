Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302B16BE025
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCQEZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQEY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:24:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAEA2330C;
        Thu, 16 Mar 2023 21:24:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B87FB82427;
        Fri, 17 Mar 2023 04:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DE8C433EF;
        Fri, 17 Mar 2023 04:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679027088;
        bh=o+pPvZmLTTUnkEUT65ibeKDRJnFaZ+5SLIlSpL5yQiU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spq3mnP12g7jIfqbpxoACTAekIO1P0RhO8jrf/DRzeUs5BlIXDl8iasOnq5bhQl26
         mJc0LJo+uC7ijFJX3r0I6BwjksT5GC6Xs6jepDA46Gcx0Fij/aq3U5U6OnvBPHTup1
         K+EFAU+E2UWgmH2pAperJqXDDtMFkzsEUZkJ1QGdNa4YrPXdPiHHJicYktHTF56i8B
         hAWmC2R6dtJL/n0PVVcvpbqaPaB/4IKfqcNCkhLg78gooGNep7e8Y8cqRSLRxAgP2a
         5/G69jZzlLVJpEgxVd58vTcXV2p5Al+PL7tkRBLnipEwHNDZRfvkw7SG/hGtkflEJj
         KLX5wXlh9PIlw==
Date:   Thu, 16 Mar 2023 21:24:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-vf: Add missing free for alloc_percpu
Message-ID: <20230316212446.44c5a429@kernel.org>
In-Reply-To: <20230316023911.3615-1-jiasheng@iscas.ac.cn>
References: <20230316023911.3615-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 10:39:11 +0800 Jiasheng Jiang wrote:
> +	if (vf->hw.lmt_info)
> +		free_percpu(vf->hw.lmt_info);
>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
>  	otx2_detach_resources(&vf->mbox);
> @@ -762,6 +764,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
>  	otx2_shutdown_tc(vf);
>  	otx2vf_disable_mbox_intr(vf);
>  	otx2_detach_resources(&vf->mbox);
> +	if (vf->hw.lmt_info)
> +		free_percpu(vf->hw.lmt_info);

No need for the if () checks, free_percpu() seems to handle NULL just
fine.
