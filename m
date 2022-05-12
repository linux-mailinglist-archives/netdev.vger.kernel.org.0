Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C923C52585D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359509AbiELXfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357948AbiELXfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:35:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BE5285EFB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34BCDB80CD2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F51C385B8;
        Thu, 12 May 2022 23:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652398499;
        bh=EdWAWUtqEtTcxI862DK5Hs+afELmBAYtkaH/EPm0Hqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AmjuW34libr6vf4Oilst3IIIwZELwdFOxCKhVmDt0PZVFqWp2MkLL7SVrmElyeAqx
         0u+7COJtZJO91VFbkDUMnUsOx5iW/mAkVWLcRwqjno0SzddF+3QDj/IG8YGpjmiaEZ
         blvLEyOxxKezM5cN9WSDUi4JLQQcHtWRSyDczXKYKi1J7uWNGi/nI69Q5ccc2nSxuW
         pIyaPj5IBx7lYPQk5hruD74ei4eNu3OQPjYtbsITiyO4Lfxr+89bu98MVz2Efvlx9b
         Cq77H5Xk/uxzba7Jn6VnMPqOhqi1nUqO1XA4faSy+vuWinsvi101LwnJKJKV1RvKxT
         IEa4we0d/4ZIQ==
Date:   Thu, 12 May 2022 16:34:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] tls: Add opt-in zerocopy mode of sendfile()
Message-ID: <20220512163458.31ae2d13@kernel.org>
In-Reply-To: <20220511121525.624059-1-maximmi@nvidia.com>
References: <20220511121525.624059-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 15:15:25 +0300 Maxim Mikityanskiy wrote:
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
> 
> The new mode can only be enabled with the new socket option named
> TLS_TX_ZEROCOPY_SENDFILE on per-socket basis. It preserves backwards
> compatibility with existing applications that rely on the copying
> behavior.
> 
> The new mode is safe, meaning that unsolicited modifications of the file
> being sent can't break integrity of the kernel. The worst thing that can
> happen is sending a corrupted TLS record, which is in any case not
> forbidden when using regular TCP sockets.
> 
> Sockets other than TLS device offload are not affected by the new socket
> option.

What about the reporting via sock diag? Am I misremembering something? 
