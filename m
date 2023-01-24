Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA376790FF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAXGdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAXGdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:33:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35515270E;
        Mon, 23 Jan 2023 22:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7DE5B81074;
        Tue, 24 Jan 2023 06:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBACC433EF;
        Tue, 24 Jan 2023 06:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674541986;
        bh=ygLrA6ydiqKtELL1xqan+538SWtwF3JrMerwki8WNX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhS8inkWwLJfsw0ZFOpViv36UIMiTOHNus38MGc191GNgg4bwtF91Bh52cjni/4ga
         a+xgMCDZg/1iHYOueoiSFYScC00aAMc7ECneI45ag9HXXbo+Fbnk2529+vldSPHz+E
         c6CgYgGtZ/xteqdaNtzxTouorHE+Sr2ULxfYySzc8psqiLTEyIxr8sOjUG3cm021j8
         /uen2BfKLau21IRa2XMgTDSGxSrPEXwLctZqDoZqRfRSBMFHsyiy8bDCp6Ec7qjNGV
         xEFPrsz5KJ79AJ/n41yhIBbK/mn/F37fu5QTcq+FFk0R6jgPYZUSFj9kUuB1j5Gh+D
         radTDT9OgJrLQ==
Date:   Mon, 23 Jan 2023 22:33:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v8 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <20230123223305.30c586ee@kernel.org>
In-Reply-To: <20230120060535.83087-2-ajit.khaparde@broadcom.com>
References: <20230120060535.83087-1-ajit.khaparde@broadcom.com>
        <20230120060535.83087-2-ajit.khaparde@broadcom.com>
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

On Thu, 19 Jan 2023 22:05:28 -0800 Ajit Khaparde wrote:
> @@ -13212,6 +13214,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
>  	kfree(bp->rss_indir_tbl);
>  	bp->rss_indir_tbl = NULL;
>  	bnxt_free_port_stats(bp);
> +	bnxt_aux_priv_free(bp);
>  	free_netdev(dev);

You're still freeing the memory in which struct device sits regardless
of its reference count.

Greg, is it legal to call:
  
	auxiliary_device_delete(adev);  // AKA device_del(&auxdev->dev);
	auxiliary_device_uninit(adev);  // AKA put_device(&auxdev->dev);
	free(adev);			// frees struct device

? I tried to explain this three times, maybe there's some wait during
device_del() I'm not seeing which makes this safe :S
