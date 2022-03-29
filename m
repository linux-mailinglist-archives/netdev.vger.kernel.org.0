Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7113C4EB6A2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbiC2XWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiC2XWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:22:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4D9184B43
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1686D60F6C
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 23:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022F4C2BBE4;
        Tue, 29 Mar 2022 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648596059;
        bh=dRpv4JSJhXcRNwZGjudpCRFsL8zvWKG+XUloXd/MEPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WyY2fzgG89NezJh9BvprlTGGVwJ6cINIcMqtSRcI7Sbn5Ecyer/M8uiYo2x8IELRw
         xi4RBFYBK9M/rODin0X0e6BemoQJmrmqpgbMdSsT/lnPSxmEPi/Kdy8SgE6ImHZcZB
         bpEVwOo0RgO9T6DRGVb+lEfSbZsBFmcLLG4e/RIUrOBYI3uRHWbsFFHtfXKwjNb5c8
         AsFyJk3yP3wKk1nXOXwdxxHVQZ+5FNZfmwnBdzzY4+HFNNDkXD98R7XUh/wZ1G4UGo
         tZxXhhXdHdu8ccx2ceqpyaS4uxnAUQXvc/G1P9G9rxKYHZCXH3mAH+aHSKqRmVn/Pg
         yLpbuc6DxMVfw==
Date:   Tue, 29 Mar 2022 16:20:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RFCv3 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
Message-ID: <20220329162057.7bba69cd@kernel.org>
In-Reply-To: <20220329091913.17869-2-wangjie125@huawei.com>
References: <20220329091913.17869-1-wangjie125@huawei.com>
        <20220329091913.17869-2-wangjie125@huawei.com>
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

On Tue, 29 Mar 2022 17:19:12 +0800 Jie Wang wrote:
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 24d9be69065d..424159027309 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -862,6 +862,7 @@ Kernel response contents:
>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>    ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
> +  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>    ====================================  ======  ===========================
>  
>  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
> @@ -887,6 +888,7 @@ Request contents:
>    ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
> +  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>    ====================================  ======  ===========================
>  
>  Kernel checks that requested ring sizes do not exceed limits reported by

You need to also describe what it does. Do you have a user manual 
or some form of feature documentation that could be used as a starting
point. We're happy to help with the wording and grammar but you need 
to give us a description of the feature so we're not guessing.
