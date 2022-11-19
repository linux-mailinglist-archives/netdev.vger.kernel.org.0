Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049F7630ADB
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiKSCvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbiKSCv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:51:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562985ADFC;
        Fri, 18 Nov 2022 18:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD2C86279E;
        Sat, 19 Nov 2022 02:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDDAC433D6;
        Sat, 19 Nov 2022 02:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668825829;
        bh=pFFvDv4wqLUYRrey8WjIi7WGeHF0FB9MVWPBvoi/HbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VKhthox5wT/m6NzIhFcLGCvCb/FlDLEl0lt9beq0COsXR8Pf8x0StWGaNfrvUJCGN
         jI8znAZi1Kq+PeBjTe3Lx7Ewxqp36FORcL+aLCeg+fTDZpeRa9AWiFI3LX1uspIY92
         xTi/LM58b0ltkdpvfZyZbR9GZAJO0Z9SU5fd+qGZE/R14jT+UWUq6bUhLHe5jYZ5Us
         A6weO0rFQqOlkNe5egqJjTeNdf4mYalFp+gbuOnNmgdQDnHg6VoqMoUrPFFtaRs6Kp
         40o39h6iWCkdGQdrjoFmEnU4nwdrVuKfTeXbaM/H4QRrMmRBO7pavj0I0gDEkO7Jta
         ACr+UVsmjVs2w==
Date:   Fri, 18 Nov 2022 18:43:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lu Jialin <lujialin4@huawei.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "Ilya Lesokhin" <ilyal@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/tls: Fix possible UAF in tls_set_device_offload
Message-ID: <20221118184347.4c2bc663@kernel.org>
In-Reply-To: <20221117104132.119843-1-lujialin4@huawei.com>
References: <20221117104132.119843-1-lujialin4@huawei.com>
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

On Thu, 17 Nov 2022 18:41:32 +0800 Lu Jialin wrote:
> In tls_set_device_offload(), the error path "goto release_lock" will
> not remove start_marker_record->list from offload_ctx->records_list,
> but start_marker_record will be freed, then list traversal may cause UAF.

Nope, the two object which are linked together are freed one 
after another.
