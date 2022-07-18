Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945CB578D51
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiGRWHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGRWHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:07:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E6C3134D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40A29B817B5
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 22:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A2BC341C0;
        Mon, 18 Jul 2022 22:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658182050;
        bh=cJBq2CLOCZf6ZPNOrI3fpZC957JN4u/Y0nWG6bAZpyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ltplwBLtCSPn58u3kVu61fEJhO+QAhj74GkpOcjnykFT3Fqc0SCqoPW4lSgkMVlqX
         12cyWN2MX5uQut9xwbWP2Ybg9p0xGJ1UBOHb50Wa6VmtfEkh1PvFavP02Nge9EUmP4
         cCuVQE2MzB9gwUb82Zt/NFh05fZV3uWrt4LY+jvV4AxkMzF80/VXgmg1Z4Pm2bKWHI
         SlJLa5iK7uR3DVs1AGrEYhU+K29hTTPjvIog/KWmIpUG3GBQTaTDP26MnwJkVkUcF3
         pPfoS4pGj65ScututBnzvgWeMg5q5CTTF1R/O3J7jdsT5gJe/YMBr+6rc0aQKuxsdO
         iJgIwmUrP58tQ==
Date:   Mon, 18 Jul 2022 15:07:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrey Turkin <andrey.turkin@gmail.com>
Cc:     netdev@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH v2] vmxnet3: Implement ethtool's get_channels command
Message-ID: <20220718150727.17175e28@kernel.org>
In-Reply-To: <20220718045110.2633-1-andrey.turkin@gmail.com>
References: <20220718045110.2633-1-andrey.turkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 04:51:10 +0000 Andrey Turkin wrote:
> +	if (IS_ENABLED(CONFIG_PCI_MSI) && adapter->intr.type == VMXNET3_IT_MSIX) {
> +		if (adapter->share_intr == VMXNET3_INTR_BUDDYSHARE) {
> +			ec->combined_count = adapter->num_tx_queues;
> +			ec->rx_count = 0;
> +			ec->tx_count = 0;
> +		} else {
> +			ec->combined_count = 0;
> +			ec->rx_count = adapter->num_rx_queues;
> +			ec->tx_count =
> +				adapter->share_intr == VMXNET3_INTR_TXSHARE ?
> +					       1 : adapter->num_tx_queues;
> +		}
> +	} else {
> +		ec->rx_count = 0;
> +		ec->tx_count = 0;
> +		ec->combined_count = 1;

No need to set the unused counts to 0.
