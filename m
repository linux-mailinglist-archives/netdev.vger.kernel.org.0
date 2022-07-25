Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D7F57FED1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbiGYMPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiGYMP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:15:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C2BE09B;
        Mon, 25 Jul 2022 05:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BDA5B80E2F;
        Mon, 25 Jul 2022 12:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967BCC341C8;
        Mon, 25 Jul 2022 12:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658751324;
        bh=FvNn5Wce0AWTev0hZCT01pnzSaPTUW7MLLFA974TLRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dm5dHN04GQnTjY/dPJUnAJWvixqcxNm9fAwN5pwepLuwgPWGx/mOMN9oOlNZnvTSr
         dZXoGAOcPhCgbdOkckKCrEt93pEpiQfhOiN64pLRo2Mj/QuW0RTLfcJ9qVh7Dukqf0
         Rmv3M4+kueBkKHo692YXwfP2xoQohWIdFkrmPer1qnK5vxrtcm8w1akDsk/pJ3qDMj
         XK/n6240LZDxKzHlaKxtqdvBiy22nnnznNcL/G7o8RcfyJ3Mbcx8H8r7wawYPhNln7
         sRwogw1HtkXizfvlzX/NrfBiEZwxCr+inFJm94TE3jT5JzxKFZMY5OIfgjDI230bjk
         rOSar3QWV2DDA==
Date:   Mon, 25 Jul 2022 15:15:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        selvin.xavier@broadcom.com, linux-rdma@vger.kernel.org,
        andrew.gospodarek@broadcom.com
Subject: Re: [PATCH 2/2] RDMA/bnxt_re: Use auxiliary driver interface
Message-ID: <Yt6JV0Vs7nSnI8KB@unreal>
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
 <20220724231458.93830-3-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724231458.93830-3-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 04:14:58PM -0700, Ajit Khaparde wrote:
> Use auxiliary driver interface for driver load, unload ROCE driver.
> The driver does not need to register the interface using the netdev
> notifier anymore. Removed the bnxt_re_dev_list which is not needed.
> Currently probe, remove and shutdown ops have been implemented for
> the auxiliary device.
> 
> BUG: DCSG01157556
> Change-Id: Ice54f076c1c4fc26d4ee7e77a5dcd1ca21cf4cd0

Please remove the lines above.

> Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
>  drivers/infiniband/hw/bnxt_re/main.c          | 405 +++++++-----------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  64 ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  65 +++
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +
>  5 files changed, 232 insertions(+), 314 deletions(-)

<...>

> +static DEFINE_IDA(bnxt_aux_dev_ids);
> +
>  static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
>  			     struct bnxt_ulp_ops *ulp_ops, void *handle)

I would expect that almost all code in bnxt_ulp.c will go after this change.

Thanks
