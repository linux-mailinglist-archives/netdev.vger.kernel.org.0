Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8588F4C9B34
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiCBC3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiCBC3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EF433E18;
        Tue,  1 Mar 2022 18:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D2C3B81EF4;
        Wed,  2 Mar 2022 02:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CD4C340EE;
        Wed,  2 Mar 2022 02:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646188136;
        bh=Q36YAMFcL/mOb6scMD0RD3DN4i6qk9jjnzdr1zDPzRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DWl/HnunxS3DGRwyZWzigozTf+h3JuumI3mk1bQqmql75+YXSJxG3a7K/KN8sW5+6
         WHyZML+5Z2OsOwqSZZ3rfND1EnjVpRizf7hVj6TduobZRdgVsQQog4jIGVzZvUZWND
         0xgGgHVQcDzpTehLvyem22Hv0+u+UXlAXS85hgX3VPH2D/xDZSU8TRB6MS38x4ckFp
         +pnUdgi0L+DYgpfTZQIzDQ9vL+YlAiyX4PI8yB1EqAcmhhutekle57OWp//nkUSIx/
         F6bQ5D76QRrtEPqXigwUcQaaLqM1ne41dnS/0mnfLqonGGXaBlI2yyghJP+wh8bhor
         2pcJSHDQ05CYg==
Date:   Tue, 1 Mar 2022 18:28:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     m.grzeschik@pengutronix.de, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: arcnet: com20020: Fix null-ptr-deref in
 com20020pci_probe()
Message-ID: <20220301182855.40d4282d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1646048653-8962-1-git-send-email-zheyuma97@gmail.com>
References: <1646048653-8962-1-git-send-email-zheyuma97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 11:44:13 +0000 Zheyu Ma wrote:
> During driver initialization, the pointer of card info, i.e. the
> variable 'ci' is required. However, the definition of
> 'com20020pci_id_table' reveals that this field is empty for some
> devices, which will cause null pointer dereference when initializing
> these devices.
> 
> The following log reveals it:
> 
> [    3.973806] KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> [    3.973819] RIP: 0010:com20020pci_probe+0x18d/0x13e0 [com20020_pci]
> [    3.975181] Call Trace:
> [    3.976208]  local_pci_probe+0x13f/0x210
> [    3.977248]  pci_device_probe+0x34c/0x6d0
> [    3.977255]  ? pci_uevent+0x470/0x470
> [    3.978265]  really_probe+0x24c/0x8d0
> [    3.978273]  __driver_probe_device+0x1b3/0x280
> [    3.979288]  driver_probe_device+0x50/0x370
> 
> Fix this by checking whether the 'ci' is a null pointer first.

Can we get a Fixes tag pointing to the commit where the problem was
introduced?
