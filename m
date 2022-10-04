Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699705F3A57
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJDAGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiJDAGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0433D15836
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 923076121B
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A34C433D6;
        Tue,  4 Oct 2022 00:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664842007;
        bh=JJHeQKMI1onEYIoVq8tl7CmQ7NYYuyoxzwCdkb3HsEc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihT1jcEfdFp5Gso+9DX9TWtmterlgrVh0nEnLSZSDLY3hvao10ADchRNadev9iIdT
         i7MYxkYr+nI/JuHRGPpTkMJogRIL8OBAQrR6Jve13f+uDDkKn2bqA2JiVLPkLL2Uch
         BgRxiWRWrdypxNZRle7R1OBRsRHl5oKBCuTLOcFG7o+PwM6n9CdT9ummfHj/WMZZu9
         hRXxOshWpqCZ7NeqcjjyEiTZhurZ1AF0PSUbfIeH1dDRWv0NtxLJqJ2GK9/avXtLvz
         5aWHFHYaas68u8E5vtZpKGJUQv8xkc+N1EOwIggOkkQu1hSWdvH3TQJbkOnrj5BZew
         FXiF6VMe3Xw8g==
Date:   Mon, 3 Oct 2022 17:06:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chunhao Lin <hau@realtek.com>
Cc:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>, <grundler@chromium.org>
Subject: Re: [PATCH net-next v2] r8169: fix rtl8125b dmar pte write access
 not set error
Message-ID: <20221003170645.687f33a7@kernel.org>
In-Reply-To: <20221003070333.29556-1-hau@realtek.com>
References: <20221003070333.29556-1-hau@realtek.com>
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

On Mon, 3 Oct 2022 15:03:33 +0800 Chunhao Lin wrote:
> When close device, rx will be enabled if wol is enabeld. When open device
> it will cause rx to dma to wrong address after pci_set_master().
> 
> In this patch, driver will disable tx/rx when close device. If wol is
> eanbled only enable rx filter and disable rxdv_gate to let hardware can
> receive packet to fifo but not to dma it.
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
> v1 -> v2: limit the call to rtl_disable_rxdvgate()

Ah, I didn't notice there was a v2, same comments as for v1:
looks like a fix..
