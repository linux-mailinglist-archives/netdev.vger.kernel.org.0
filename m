Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA354FA25
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381162AbiFQPWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 11:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbiFQPWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 11:22:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE8A4BB8F
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 08:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 584F2B82ADD
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 15:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C27C3411B;
        Fri, 17 Jun 2022 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655479347;
        bh=rwdgpD2wyAQBd5cBsck13q8LGidrMGB0KZ/zA8dPYyE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YXOYjRAOjw82+QV5BGwhciU49P+ryhWSUE4mme1n+6P5ZF6re6ENt8lBFJy9YQ1gk
         mhNEQgkrnkBoLkD21QQezcyRLCOniwStG+GRgbYWJ7+TsXjSaQDIHdb39yzJ5UH2Q0
         vFrPFdNQFfKHIhgyMXQbBUj3sD0Ni25DP/c6rXP07grbK+xbt/QXCNEQJK6+POM3Jr
         eJ9rHrZDiL+247iRJ47DuYp1A+qMxT7MyY2lgnmEQ+YwT4fkyto+tw8RlRfMRxOh/y
         CkAWLWJnVpdAsVLHcCZ4LyMMHryMUb18V+aq8g6T/d/ymJIay5qQaYa2yWe91f/RNC
         H8v1eWTrLB+1w==
Date:   Fri, 17 Jun 2022 08:22:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ismael Luceno <iluceno@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220617082225.333c5223@kernel.org>
In-Reply-To: <9598e112-55b5-a8c0-8a52-0c0f3918e0cd@gmail.com>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
        <9598e112-55b5-a8c0-8a52-0c0f3918e0cd@gmail.com>
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

On Fri, 17 Jun 2022 08:55:53 -0600 David Ahern wrote:
> > No, I'm concerned that while in the dumping loop, the table might
> > change between iterations, and if this results in the loop not finding
> > more entries, because in most these functions there's no
> > consistency check after the loop, this will go undetected.  
> 
> Specific example? e.g., fib dump and address dumps have a generation id
> that gets recorded before the start of the dump and checked at the end
> of the dump.

FWIW what I think is strange is that we record the gen id before the
dump and then check if the recorded version was old. Like.. what's the
point of that? Nothing updates cb->seq while dumping AFAICS, so the
code is functionally equivalent to this right?

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 92b778e423df..0cd7482dc1f0 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2259,6 +2259,7 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
 		rcu_read_lock();
 		cb->seq = atomic_read(&net->ipv4.dev_addr_genid) ^
 			  net->dev_base_seq;
+		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
@@ -2276,7 +2277,6 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
 				rcu_read_unlock();
 				goto done;
 			}
-			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
 			idx++;
 		}


