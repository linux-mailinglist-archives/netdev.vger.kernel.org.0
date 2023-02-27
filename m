Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B59B6A4A51
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjB0Svx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB0Svw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE04F2413A
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:51:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8965760EFE
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 18:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B515DC433EF;
        Mon, 27 Feb 2023 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677523911;
        bh=cGzX8tbepjoY6KqqzFyEWJ+ADZM3TqrHpgwtPlK9rlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXIhsvhIEu5N/FrPaRyRfRT0nzV9YD9ZMRQ47jLyOBUmqCd6v8SKk4H6R+pp7V8Oc
         hn764vyMcWmogX69rA1wZm829WZ9JtLr9avR/JIW2Y0iISvTUXe2lkxn103uaAUpQj
         Y3suuXZIpLnenEkVNO+mXPuujolbe2yV86Mvv13f/EuwHf+De6vR9u13EznmNitEh2
         BzkbUGug24Q0AoSoRE97ThXrQJ7CB6cCThZui2OXLW9Xn+2An2Li8uAa8qtbwIigIf
         G2Idnc/xtypucypK8P1ze8e2sQifBGS+7bMax6bHf9Wt7PF2pTw2VgfiE6LZqJlMQv
         bpSDWZY5Y6eVQ==
Date:   Mon, 27 Feb 2023 10:51:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     netdev@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: Re: [PATCH net] qede: avoid uninitialized entries in coal_entry
 array
Message-ID: <20230227105144.06f07b0d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20230224004145.91709-1-mschmidt@redhat.com>
References: <20230224004145.91709-1-mschmidt@redhat.com>
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

On Fri, 24 Feb 2023 01:41:45 +0100 Michal Schmidt wrote:
> Even after commit 908d4bb7c54c ("qede: fix interrupt coalescing
> configuration"), some entries of the coal_entry array may theoretically
> be used uninitialized:
> 
>  1. qede_alloc_fp_array() allocates QEDE_MAX_RSS_CNT entries for
>     coal_entry. The initial allocation uses kcalloc, so everything is
>     initialized.
>  2. The user sets a small number of queues (ethtool -L).
>     coal_entry is reallocated for the actual small number of queues.
>  3. The user sets a bigger number of queues.
>     coal_entry is reallocated bigger. The added entries are not
>     necessarily initialized.
> 
> In practice, the reallocations will actually keep using the originally
> allocated region of memory, but we should not rely on it.
> 
> The reallocation is unnecessary. coal_entry can always have
> QEDE_MAX_RSS_CNT entries.
> 
> Fixes: 908d4bb7c54c ("qede: fix interrupt coalescing configuration")
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Applied, thanks!
