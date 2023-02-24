Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A453E6A21DD
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBXS5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjBXS5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:57:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1256CF31;
        Fri, 24 Feb 2023 10:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D081B81CF5;
        Fri, 24 Feb 2023 18:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C30C4339B;
        Fri, 24 Feb 2023 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677265051;
        bh=dK9Z5SYBjNSnwDk+/qbX066wbEFoBwmsGsR3TnP0FIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LWbPOy6vaRVeCdbTJf2cJmkuuuRJVx0ApMBdAi19mH6bynShVqBaz+UvMNl7jwW3Y
         nqf/2qpnjCrtvuWexlxxpbJ4cAArt2e/3cQWuzeprOqFPkiJ1BJrCOJ6KjZfBXBL9z
         9/ntu4Z0bTQATYMcm14uNY9tXmU/arKsqtIwAMo5vyda1V4j2IM6vKRhnUegBb9QTj
         D3h6s3dgs8QFTJfDXrFGiAiAmYDheBbxjHLOtou+pSz9pAK0Fi4o8N6Fj6m6HtjVMC
         IB3MDcRa+3AOrJYXcVg3tkcU4gSmEMVZ5YezI6MlYO2tK0s4j9LAgwvir+5Is+ReNR
         q5xKAat+g3SbA==
Date:   Fri, 24 Feb 2023 10:57:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ilyal@mellanox.com,
        aviadye@mellanox.com, sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tls: fix possible info leak in
 tls_set_device_offload()
Message-ID: <20230224105729.5f420511@kernel.org>
In-Reply-To: <20230224102839.26538-1-hbh25y@gmail.com>
References: <20230224102839.26538-1-hbh25y@gmail.com>
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

On Fri, 24 Feb 2023 18:28:39 +0800 Hangyu Hua wrote:
> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
> before kmalloc cctx->iv. It is better to Set them to NULL to avoid any
> potential info leak.

Please show clear chain of events which can lead to a use-after-free 
or info leak. And if you can't please don't send the patch.
