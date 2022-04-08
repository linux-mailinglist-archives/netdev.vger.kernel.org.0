Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6E4F9F63
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiDHV5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDHV5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:57:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE2238BF6;
        Fri,  8 Apr 2022 14:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79F7ECE2BE0;
        Fri,  8 Apr 2022 21:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F73CC385A1;
        Fri,  8 Apr 2022 21:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649454945;
        bh=25vW1EczToy4G4r4R/eA4RyVfrlTEyY2y4C5EOTRlZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TUSjt2Ebn5pR/zhdkpfF+t+eKiABz0vq+AmZWdWsQEHGvN/W/x5eu4vQmpIzrqFks
         pBsubIwvf/hW+mPV26XlTinTR7QR/xpjA+cEpHkuO72WZK230Xni/4TP2pgB6VPESP
         KgwXYpr+bUco+yOn3Z6uukac5Ad1xDI0ICLNFKccnfH1lTHTCC8/UCg4TtvPafv2lh
         jDfBYePRT+m2wTLCDXN68AxBcGEG4PhRHqj4A0V52xcHQAVwgrTvUlxAFlRF0yzRQE
         NSnyn/jPKUXPMvVoNz4ZSttjTMW6i11fdpe+S4PgnrnJtiD2rEFbqnJofYF4HABJJR
         1iCkgxezu5nSw==
Date:   Fri, 8 Apr 2022 14:55:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <wangjie125@huawei.com>
Subject: Re: [PATCH net-next 1/3] net: ethtool: extend ringparam set/get
 APIs for tx_push
Message-ID: <20220408145544.141c0799@kernel.org>
In-Reply-To: <20220408071245.40554-2-huangguangbin2@huawei.com>
References: <20220408071245.40554-1-huangguangbin2@huawei.com>
        <20220408071245.40554-2-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Apr 2022 15:12:43 +0800 Guangbin Huang wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently tx push is a standard driver feature which controls use of a fast
> path descriptor push. So this patch extends the ringparam APIs and data
> structures to support set/get tx push by ethtool -G/g.
> 
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

> +``ETHTOOL_A_RINGS_TX_PUSH`` flag is used to choose the ordinary path or the fast
> +path to send packets. In ordinary path, driver fills BDs to DDR memory and
> +notifies NIC hardware. In fast path, driver pushes BDs to the device memory
> +directly and thus reducing the sending latencies. Setting tx push attribute "on"
> +will enable tx push mode and send packets in fast path if packet size matches.
> +For those not supported hardwares, this attributes is "off" by default settings.

Since you need to respin to fix the kdoc warning - could you also add 
a mention that enabling this feature may increase CPU cost? Unless it's
not the case for your implementation, I thought it usually is..

>  RINGS_SET
>  =========
> @@ -887,6 +894,7 @@ Request contents:
>    ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
> +  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>    ====================================  ======  ===========================
>  
>  Kernel checks that requested ring sizes do not exceed limits reported by
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 4af58459a1e7..ede4f9154cd2 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -71,11 +71,13 @@ enum {
>   * struct kernel_ethtool_ringparam - RX/TX ring configuration
>   * @rx_buf_len: Current length of buffers on the rx ring.
>   * @tcp_data_split: Scatter packet headers and data to separate buffers
> + * @tx_push: The flag of tx push mode
>   * @cqe_size: Size of TX/RX completion queue event
>   */
>  struct kernel_ethtool_ringparam {
>  	u32	rx_buf_len;
>  	u8	tcp_data_split;
> +	u8	tx_push;
>  	u32	cqe_size;
>  };
>  
> @@ -87,6 +89,7 @@ struct kernel_ethtool_ringparam {
>  enum ethtool_supported_ring_param {
>  	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
>  	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
> +	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),

include/linux/ethtool.h:94: warning: Enum value 'ETHTOOL_RING_USE_TX_PUSH' not described in enum 'ethtool_supported_ring_param'

