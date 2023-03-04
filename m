Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D5B6AA738
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCDBTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCDBS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:18:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B716B319;
        Fri,  3 Mar 2023 17:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F436199D;
        Sat,  4 Mar 2023 01:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DC5C4339B;
        Sat,  4 Mar 2023 01:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677892678;
        bh=TgK03BBa9071HZ+uOJtyyMcIQtif2bOUcPZqbsFvIPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iHSr26BZKpO6D/NPtp9LYxywKu3wkCb7oKTp8/zxPQgb3c3yzRMC+brkPseXexjBC
         Kap5I+6I9zLymQC5xl9It2Amj5kClGpVWhdwrVgqZmdq5LU5i6GMhv54UxbX+DrBp8
         LQh5rFOU95AE6e/WIX1+nGLIodo754c9S7qGGWgo7Bf/vYt4ohIhEtoge6prYVbP2J
         8xj7A1yEVVpKJGQlKrps1tLyXkNAxh01r5Dxs4PB1bjQTQyUKPx9T89AIMnUT9DJE2
         r/2lTuBAs0ZHetZMGLKMSHCUZfM5GEfUYPCXE7E3vsFafrE4dOM4axS/Hd1cGZX/tD
         i8A1NuxKJ5pyA==
Date:   Fri, 3 Mar 2023 17:17:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Adrien Moulin <amoulin@corp.free.fr>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: TLS zerocopy sendfile offset causes data corruption
Message-ID: <20230303171756.38a8a43e@kernel.org>
In-Reply-To: <61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr>
References: <61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr>
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

On Fri, 3 Mar 2023 13:07:15 +0100 (CET) Adrien Moulin wrote:
> When doing a sendfile call on a TLS_TX_ZEROCOPY_RO-enabled socket with an offset that is neither zero nor 4k-aligned, and with a "count" bigger than a single TLS record, part of the data received will be corrupted.
> 
> I am seeing this on 5.19 and 6.2.1 (x86_64) with a ConnectX-6 Dx NIC, with TLS NIC offload including sendfile otherwise working perfectly when not using TLS_TX_ZEROCOPY_RO.
> I have a simple reproducer program available here https://gist.github.com/elyosh/922e6c15f8d4d7102c8ac9508b0cdc3b

Would you be able to test potential fixes? Unfortunately testing
requires access to the right HW :(

I think the offset needs to be incremented, so:

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..a7cc4f9faac2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,6 +508,8 @@ static int tls_push_data(struct sock *sk,
 			zc_pfrag.offset = iter_offset.offset;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
+
+			iter_offset.offset += copy;
 		} else if (copy) {
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
