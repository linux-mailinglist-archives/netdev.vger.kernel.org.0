Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5932452CB40
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiESEnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiESEnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F15C1145F
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BF94B8218E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E959CC385B8;
        Thu, 19 May 2022 04:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935393;
        bh=dr+FpV9e0O/X7zYyjkXjjT6L5J3NgcrQru19wLqNqJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k1iwbjjyn9k5Y3NIjeAO4bmzUec+IkZtVSeHTqZljbZmykw0q3Nq6D5/j6/4CtfCu
         EuOJkZg2E3gCWQMSmKyV0dKOlG7EUxGJ6ILoRroVzNe4xT9aZUlJyx9fA2Q4Nypfov
         0GYG/hj0EGqZEIMIE7pD1trhuYhCPVT3YALu3+tYFxD/1JRqGl8eXzp5mNNbYzAqtb
         Ztn2f42Jy8Hto00pI5Clpj6D9DVS7FcI1bkMlwuEJxP0LiNwC5Rs7qG+Pi6AR66/Fk
         R6+WrTS4+MV+KAx5jFecB7Y4i6IUDQtBDvQu/Epa9hs5YFZpuEhVhGN0G/vcNJTSYh
         jspq6mn6rXWpQ==
Date:   Wed, 18 May 2022 21:43:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3] tls: Add opt-in zerocopy mode of sendfile()
Message-ID: <20220518214311.45be0bd9@kernel.org>
In-Reply-To: <20220518092731.1243494-1-maximmi@nvidia.com>
References: <20220518092731.1243494-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 12:27:31 +0300 Maxim Mikityanskiy wrote:
> TLS device offload copies sendfile data to a bounce buffer before
> transmitting. It allows to maintain the valid MAC on TLS records when
> the file contents change and a part of TLS record has to be
> retransmitted on TCP level.
> 
> In many common use cases (like serving static files over HTTPS) the file
> contents are not changed on the fly. In many use cases breaking the
> connection is totally acceptable if the file is changed during
> transmission, because it would be received corrupted in any case.
> 
> This commit allows to optimize performance for such use cases to
> providing a new optional mode of TLS sendfile(), in which the extra copy
> is skipped. Removing this copy improves performance significantly, as
> TLS and TCP sendfile perform the same operations, and the only overhead
> is TLS header/trailer insertion.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
