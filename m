Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C27D50C123
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiDVVix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiDVViu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:38:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEC62C8C2C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:44:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FF41B8324F
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 20:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77543C385A4;
        Fri, 22 Apr 2022 20:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650659833;
        bh=x2hjpVNnxnh6dBDxe9dPKJ8Pr/ILIc46TtPLOJq2RnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JmLoiWnWmXiWqAxeQXI3qHAY1Py7zEmqIZ8bBxrKwZm5uEvfdGZMjjUXTy6kr9oXX
         5RlS7k7LRt9iOz+K6FMobs8pNnqY8h+Y5hntWANkaa7BbqkjymyxLhFiab5mZ76J0r
         fUmi4P71EuBBOcbs7TDCoRj5f4P4Q0RsQIHcRVXD9iORNS3Pcc5srlB64s6YPIzwZI
         cOtE+SJDAg11V+zjKuN1HMLKmhNxHXOkRPzBetdmTz6LO3OboONRdtVAsfglUU0yD5
         FL8Y4LxWz1HKpbGXNJGkZKXd7QgJah8gF0jhMe+DqDpnQiaRE6QZUZBjxoLW8LuM6X
         32YHiSdcsD4AA==
Date:   Fri, 22 Apr 2022 13:37:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v3] tcp: ensure to use the most recently sent skb
 when filling the rate sample
Message-ID: <20220422133712.17eebbcb@kernel.org>
In-Reply-To: <1650422081-22153-1-git-send-email-yangpc@wangsu.com>
References: <1650422081-22153-1-git-send-email-yangpc@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Apr 2022 10:34:41 +0800 Pengcheng Yang wrote:
> If an ACK (s)acks multiple skbs, we favor the information
> from the most recently sent skb by choosing the skb with
> the highest prior_delivered count. But in the interval
> between receiving ACKs, we send multiple skbs with the same
> prior_delivered, because the tp->delivered only changes
> when we receive an ACK.
> 
> We used RACK's solution, copying tcp_rack_sent_after() as
> tcp_skb_sent_after() helper to determine "which packet was
> sent last?". Later, we will use tcp_skb_sent_after() instead
> in RACK.
> 
> Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>

Somehow this patch got marked as archived in patchwork. Reviving it now.

Eric, Neal, ack?
