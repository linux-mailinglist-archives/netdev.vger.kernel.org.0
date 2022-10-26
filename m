Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487CF60D972
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiJZC5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiJZC5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62E69C2F3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 19:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 587BDB82012
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 02:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFB1C433C1;
        Wed, 26 Oct 2022 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753022;
        bh=geSRFVdmbYX1vkYSajd7TlNwWQW9Gh13IJFdBuNNH/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s0+9XQ+c82iGkaM7my7qQgmME1RKoYjVjNr5VVrTeRHA+Q+W0cz40su7QBhSOt96Q
         aqkB/c1Stp6t4JS6KhUsrwbF1OpUhOp2yUdAg0q7KAZopOijgkUaYKCnvTnQvSwZpt
         mOLYHr9N0O2GjdvsJb/oJChKqqM3LlvmnRezgEowKH51IgmwDWlWGpUkeKqmKMmNr1
         XFw63ZHpYPMsRdXppSeraXLVM6H2jEaYOeqFheaqHGBDQwJSK+KrPfnvXTlGHtVHdG
         5aPXthqZoWQ8lWIfT7l8b9CzXjRgCwpVcA1IwjRbIu1BDF3iigtsSwOdO1Q7hrLrSE
         mhe33CWsLG+/A==
Date:   Tue, 25 Oct 2022 19:57:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] bond: Disable TLS features indication
Message-ID: <20221025195700.43926ad9@kernel.org>
In-Reply-To: <20221025105300.4718-1-tariqt@nvidia.com>
References: <20221025105300.4718-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 13:53:00 +0300 Tariq Toukan wrote:
> Bond agnostically interacts with TLS device-offload requests via the
> .ndo_sk_get_lower_dev operation. Return value is true iff bond
> guarantees fixed mapping between the TLS connection and a lower netdev.
> 
> Due to this nature, the bond TLS device offload features are not
> explicitly controllable in the bond layer. As of today, these are
> read-only values based on the evaluation of bond_sk_check().  However,
> this indication might be incorrect and misleading, when the feature bits
> are "fixed" by some dependency features.  For example,
> NETIF_F_HW_TLS_TX/RX are forcefully cleared in case the corresponding
> checksum offload is disabled. But in fact the bond ability to still
> offload TLS connections to the lower device is not hurt.
> 
> This means that these bits can not be trusted, and hence better become
> unused.
> 
> This patch revives some old discussion [1] and proposes a much simpler
> solution: Clear the bond's TLS features bits. Everyone should stop
> reading them.

Acked-by: Jakub Kicinski <kuba@kernel.org>
