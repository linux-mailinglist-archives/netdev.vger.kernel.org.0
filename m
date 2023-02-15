Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30EF6982C5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjBOR6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBOR6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:58:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FD127996
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F95B82335
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEE9C433EF;
        Wed, 15 Feb 2023 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676483916;
        bh=oduLk3h8Wh/dXhyTtUWQhE4fDkrSmeqvM8HjN6oDuew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YwCnX/qYaDQ/mF5iH9df/t4ABw5noHpuc7VxgbamjcI4mQZ5vOLt+Tmu11SuJneqC
         4HazNO/xfnzwq+dZqxoapuSPvpzTJjnPeHs6/2oBRnXDdhZzQzz73Up2+u+V4cGY20
         jqQoPDqTAB618nGScwYHkPGGsmrqYXpJZXfQdPNF9rvMDmbRnWeqZJpo+seWnRhH8A
         6+HiwSodiB78STgdWbrPBBocTvW0Re4ZxGlAVkDoaCsxPsUut6Gpap97wdQhdjZSgr
         cWPz4ekDoDSbpFo20LcC6Iec+2Imadm8VZCkHPjc1KymMgxX35bYiib5Bf9Sl/qA61
         4RaAdKd51yjBw==
Date:   Wed, 15 Feb 2023 09:58:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com, fw@strlen.de
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
Message-ID: <20230215095834.42f5e227@kernel.org>
In-Reply-To: <c4cea30465ff621681090fff69d5ccc97f53e85a.camel@redhat.com>
References: <20230215034444.482178-1-kuba@kernel.org>
        <c4cea30465ff621681090fff69d5ccc97f53e85a.camel@redhat.com>
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

On Wed, 15 Feb 2023 09:53:54 +0100 Paolo Abeni wrote:
> Still, if you are willing to experiment more this idea, I think you
> could save the extra cacheline miss encoding the 'alloc_mode' into the
> lower bits of skb->extensions (alike what _skb_refdst is doing with the
> SKB_DST_NOREF flag).

I thought I'd start with a simpler approach where allocation type 
is stored in the object itself, to limit the negative reactions :P
We could indeed save a cache miss (I think it'd be actually one fewer
miss than the current implementation, because most cases must end 
up looking at the skb_ext, f.e. to read the refcount. The fact that
SHARD_NOREF implies refcnt == 1 can save us reading from skb_ext).
