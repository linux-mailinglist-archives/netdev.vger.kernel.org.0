Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F3F60DDFA
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJZJYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiJZJYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81162674;
        Wed, 26 Oct 2022 02:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F76EB82148;
        Wed, 26 Oct 2022 09:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9F6C433C1;
        Wed, 26 Oct 2022 09:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666776263;
        bh=LthZ0epvOymObicZ1JxA6Jp1dilaQRE5uNxcfuD92+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hsCma2jg2IZl55ZG5c3nMPcWyEiP7Xt+zoYDI81Cerb+A33UnEgyua3GCX+ROO2/u
         dLpveATPfZC6paE1QkRXAuBWfP2y0jvJcxPWW8OUvNknzAwKeyltrqPiX90m4R3rgK
         vb5H2lBP3GQAkt/O4KBN4KlsCrE3o8UD6/h2TSexQPFeKXiIHS1+J6eQ/jvkn8H70S
         tLjCDq87Iihi8VcPeq5QDWG62JGJQmBz40W4e9EVtWpzSr/SyK3/C543yiNGagfrJB
         zYxHw/+v38aNxk6fmEcSksglFHb2t8CbMsNaUivOPypro9iwb3KIVEgOpCpe7YBq8N
         bLhrC1kmcrgvw==
Date:   Wed, 26 Oct 2022 12:24:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v2 2/6] RDMA/bnxt_re: Use auxiliary driver interface
Message-ID: <Y1j8wv9nn6MmdlcB@unreal>
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
 <20221025173110.33192-1-ajit.khaparde@broadcom.com>
 <20221025173110.33192-3-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025173110.33192-3-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 10:31:06AM -0700, Ajit Khaparde wrote:
> Use auxiliary driver interface for driver load, unload ROCE driver.
> The driver does not need to register the interface using the netdev
> notifier anymore. Removed the bnxt_re_dev_list which is not needed.
> Currently probe, remove and shutdown ops have been implemented for
> the auxiliary device.
> 
> Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
> Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
>  drivers/infiniband/hw/bnxt_re/main.c          | 387 +++++++-----------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  64 ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  67 ++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +
>  5 files changed, 214 insertions(+), 316 deletions(-)

<...>

> -static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
> +static struct bnxt_en_dev *bnxt_re_dev_probe(struct auxiliary_device *adev)
>  {
> -	struct bnxt_en_dev *en_dev;
> +	struct bnxt_aux_dev *aux_dev =
> +		container_of(adev, struct bnxt_aux_dev, aux_dev);
> +	struct bnxt_en_dev *en_dev = NULL;
>  	struct pci_dev *pdev;
>  
> -	en_dev = ((struct bnxt*)netdev_priv(netdev))->edev;
> -	if (IS_ERR(en_dev))
> -		return en_dev;
> +	if (aux_dev)
> +		en_dev = aux_dev->edev;
> +
> +	if (!en_dev)
> +		return NULL;

Thank you for working to convert this driver to auxiliary bus. I'm
confident that it will be ready soon.

In order to effectively review this series, you need to structure
patches in such way that you don't remove in patch X+1 code that you
added in patch X.

Also you should remove maze of redundant functions that do nothing, but
just call to another function with useless checks.

Auxiliary devices shouldn't be created if en_dev == NULL.

Thanks
