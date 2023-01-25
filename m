Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9809467A899
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjAYCLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:11:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9E9474C5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B2BAB816C6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9315C433EF;
        Wed, 25 Jan 2023 02:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674612661;
        bh=ahZj9Fwl+HqpAsc75mz0RZH/TquZlD8ZCutRGY/O5AA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pRmxHoKfsBAMBNaZWaTx2cqQ2StOMv0zrFKlZ8S6XdAek55gG2igM6mAXWxHJsRCJ
         M6OaC0X2NedvdOt/uwApS6Cy7pmLswtK4KFo1pp8Ll6zrb8F9QPseTkPEinco/GrHj
         F/1xmpsc8KCgFvWTqJVHg65kdZohjZnyRn49amBLzJWDFqg4Xvru3nB89fs620I6qf
         SLmh5QgIPRJ/zqQosd3f7IcU5QjxxxTU1GNAOEb2wfocWj9hPYFqLD3KggUNkLjwcc
         daiCR+tVpgWk0AxwKQOjjgZVV0yGFeqmzT+tXs6KBpRc2m2lJAIK2XKiQVAaKYGp41
         JLhJLA/i57OYw==
Date:   Tue, 24 Jan 2023 18:11:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next RFC] net: introduce skb_poison_list and use in
 kfree_skb_list
Message-ID: <20230124181100.6aa0c669@kernel.org>
In-Reply-To: <167421519986.1321434.5887198904455029318.stgit@firesoul>
References: <167421519986.1321434.5887198904455029318.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 12:46:39 +0100 Jesper Dangaard Brouer wrote:
> First user of skb_poison_list is in kfree_skb_list_reason, to catch bugs
> earlier like introduced in commit eedade12f4cb ("net: kfree_skb_list use
> kmem_cache_free_bulk").
> 
> In case of a bug like mentioned commit we would have seen OOPS with:
>  general protection fault, probably for non-canonical address 0xdead0000000000b1
> And content of one the registers e.g. R13: dead000000000041
> 
> In this case skb->len is at offset 112 bytes (0x70) why fault happens at
>  0x41+0x70 = 0xB1

I like the idea, FWIW. I was gonna apply the RFC but looks like there
was a dependency on the fix, so better if you repost and bot gets to
chew on it.
