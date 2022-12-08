Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2A646708
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLHCet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLHCer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:34:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D8F93A52;
        Wed,  7 Dec 2022 18:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 576C4B821FF;
        Thu,  8 Dec 2022 02:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51241C433D7;
        Thu,  8 Dec 2022 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670466884;
        bh=RvsfLC8WqgtbeeVSmrxsvGGOXLI1778nLXkBGvQAYvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=elFqximTvljjIGzE9M0r4NCZQ2laKz5qzv89J0gAIeHSEPQSBryiDwAw85e/s+1jz
         63CICI5rEJEiNv0PXKDAoZXd6DWe3G7P83FvjLKCcGhUVjiGEsoqMyM/j0cnavEH7i
         P0GUNj2guTwNw5YZqxezHqqa6LKj+8l8JzKjrT2b1P30MywojkPK5+rf7zApxqPn/9
         YqQtLg5JznswXGYFSu2i5bNOkDKH8R+RX43Jq824jblu3wmoxUn8M3GuABrFPcGIFY
         pTZHfGQjkgr8OcLwNqR74ANhyLDB7+vooVne5jpBzrLs9A7MXtAoK3JryrYIq1q5l9
         9EcIqSbi9eoxQ==
Date:   Wed, 7 Dec 2022 18:34:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, martin.lau@linux.dev,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Rasesh Mody <rmody@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Richard Gobert <richardbgobert@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] skbuff: Introduce slab_build_skb()
Message-ID: <20221207183440.4c80918b@kernel.org>
In-Reply-To: <20221208000209.gonna.368-kees@kernel.org>
References: <20221208000209.gonna.368-kees@kernel.org>
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

On Wed,  7 Dec 2022 16:02:13 -0800 Kees Cook wrote:
> Is this what you had in mind for this kind of change?

nice, thanks a lot!

the only thing left to do is kdoc updates:
 - the existing kdocs should no longer mention frag_size == 0
 - kdoc on the slab_build_skb() should say:

  /* build_skb() variant which can operate on slab buffers.
   * Note that this should be used sparingly as slab buffers
   * cannot be combined efficiently by GRO!
   */

But this can all be done by us in a follow up, there's probably
more cleaning we can do in those kdocs.

> v2: introduce separate helper (kuba)
> v1: https://lore.kernel.org/netdev/20221206231659.never.929-kees@kernel.org/
