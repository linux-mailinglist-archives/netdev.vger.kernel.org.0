Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220936D8D5E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbjDFCTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDFCTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:19:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC36EAF;
        Wed,  5 Apr 2023 19:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D37D63E67;
        Thu,  6 Apr 2023 02:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9AAC433EF;
        Thu,  6 Apr 2023 02:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680747556;
        bh=1nRUB8kn7dBx6kv26QS2b/95TXcbg7BEirY4c1cIg3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FHXl4MeNWtrJ2T3BaSvNeP5v9JGOs+IKsSu76OBsT2BlVKTlVQqvgJ2Njtb/af/c7
         viqutAh6LkRabq39fLxnxrtpLwNhwiaVdDM9Q1XgySzykLZCCr+kPoeL8PnIrGsZn3
         WeOxlEGNkrqXjst3MC1CGB5AUkZW/4A9ZUidv8F3ueAlhrw7vwZ/qReYaGW9biXB0e
         wKBhzi8wXuutO7OGIOu4YmYMaNDiqBeQvSSTr6S4krMdPr+fJLK1sFyYrUl5POvYPa
         Bau71+iNh4jGA6TFOS4XqnFmFkdqrB+9GfTBs0hzXbAKgxd9dMwyS2+HQSCfDxrhcC
         2luPkqbAF7GBw==
Date:   Wed, 5 Apr 2023 19:19:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH net-next v4 00/20] splice, net: Replace sendpage with
 sendmsg(MSG_SPLICE_PAGES), part 1
Message-ID: <20230405191915.041c2834@kernel.org>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Apr 2023 17:53:19 +0100 David Howells wrote:
> Here's the first tranche of patches towards providing a MSG_SPLICE_PAGES
> internal sendmsg flag that is intended to replace the ->sendpage() op with
> calls to sendmsg().  MSG_SPLICE is a hint that tells the protocol that it
> should splice the pages supplied if it can and copy them if not.

Thanks for splitting off a smaller series!
My day is out of hours so just a trivial comment, in case kbuild bot
hasn't pinged you - this appears to break the build on the relatively
recently added page_frag_cache in google's vNIC (gve).
