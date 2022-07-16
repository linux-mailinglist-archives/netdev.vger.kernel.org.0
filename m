Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF21C576B4C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 04:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiGPCXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 22:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiGPCXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 22:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE25033A30
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 19:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4137A620DB
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 02:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69653C3411E;
        Sat, 16 Jul 2022 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657938180;
        bh=Bf1N1EbVqwBoYK4zOBwfQvV4pUSJg8o1KlEW1wPbqWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTn8vgp49B8RRdRMRpJuOTVwvOPC6BfVHgnJHaCmoYKHLnYpLvtWykKHzg9qMuS0c
         KQ/2SVV/gATFj64mTfjLP17V8VCKKzDmK4sogoAf9ctdOOntUSFLmUhpWrjp8MtROr
         s9sKxF+5vEemvGnvZT0vYKbGPZek2OVA7VvV6IJRMkxggwqfaKkuVwsPYFLNNSFAhK
         eAVm24FEwCs2QkspSdVF8Q27xiML+FVu9cekiyOpI55MD4Id96RLxUHNmDX5HKEA3s
         SHfQuvQ2GGT6asQ6Oow1SXcS+cGz5LUVNtA0T8R1S8vpubSYy6xE8bNT+KnH4bu35f
         eLTROcreOwThw==
Date:   Fri, 15 Jul 2022 19:22:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ecree@xilinx.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 04/10] sfc: add skeleton ef100 VF representors
Message-ID: <20220715192259.7abc9c7f@kernel.org>
In-Reply-To: <c5a89a7a6221938695bbc35ea75945e761f4bb8c.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
        <c5a89a7a6221938695bbc35ea75945e761f4bb8c.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 13:33:26 +0100 ecree@xilinx.com wrote:
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 2228c88a7f31..80ee2c936f59 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1145,6 +1145,8 @@ struct efx_nic {
>  	unsigned vf_init_count;
>  	unsigned vi_scale;
>  #endif
> +	spinlock_t vf_reps_lock; /* Protects vf_reps list */
> +	struct list_head vf_reps; /* local VF reps */

missing kdoc.
