Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86DF5396D4
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346781AbiEaTSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243775AbiEaTSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:18:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9633DDF3
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D217661202
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDB6C385A9;
        Tue, 31 May 2022 19:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654024711;
        bh=GJOxjgV7jiQiwZc5vnT9ekJUqWU5GXAzb+gVqQPE19M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ghR8Mt5Ssk5QL6vJDXTBbwB/eMwidErFvQNzjzvPQ6o755GVXw/R79PFukx/aSYXJ
         G+eR6vSq0tVfdVFJc72cToQF5aYALVBiKmGp4MFvPlAfyzvDtnOyEeExFfoOEY7LrY
         kRjlsBtQZUa0SUHawlwk2EwIZY4RTc2V64+ia98BO5AVZ/mXOhAT/lYjlLzXxSv0Wg
         nHmdw1f9R0/howGUotzJ0uDAMMppUF7YbhcClbS8qYL8fH8JuYZ6eaDj0M+CMDEHqo
         7Bc83WN6+bdkBu0OxlOfUcRCX/4+77uwP4gdJsNudEz/MUmijQIi6uEGXAZ5Oj9vaE
         WmCK4Q5n9o+Ew==
Date:   Tue, 31 May 2022 12:18:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Message-ID: <20220531121829.01d02463@kernel.org>
In-Reply-To: <20220530111745.7679b8c4@kernel.org>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
        <20220530111745.7679b8c4@kernel.org>
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

On Mon, 30 May 2022 11:17:45 -0700 Jakub Kicinski wrote:
> Also please send a patch to Documentation/, I forgot about that.

Actually let me take care of that on my own, I have some optimizations
to add, saves me a rebase ;)

Does this sound good?


Optional optimizations
----------------------

There are certain condition-specific optimizations the TLS ULP can make,
if requested. Those optimizations are either not universally beneficial
or may impact correctness, hence they require an opt-in.
All options are set per-socket using setsockopt(), and their
state can be checked using getsockopt() and via socket diag (``ss``).

TLS_INFO_ZC_SENDFILE
~~~~~~~~~~~~~~~~~~~~

For device offload only. Allow sendfile() data to be transmitted directly
to the NIC without making an in-kernel copy. This allows true zero-copy
behavior when device offload is enabled.

The application must make sure that the data is not modified between being
submitted and transmission completing. In other words this is mostly
applicable if the data sent on a socket via sendfile() is read-only.

Modifying the data may result in different versions of the data being used
for the original TCP transmission and TCP retransmissions. To the receiver
this will look like TLS records had been tampered with and will result
in record authentication failures.
