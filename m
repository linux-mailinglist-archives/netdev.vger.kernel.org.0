Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1994D701B
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 18:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiCLRUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 12:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCLRUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 12:20:38 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB11ADF48E;
        Sat, 12 Mar 2022 09:19:31 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nT5Og-00ALTz-6x; Sat, 12 Mar 2022 17:19:18 +0000
Date:   Sat, 12 Mar 2022 17:19:18 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: tcp.c: fix an assignment in an if condition
Message-ID: <YizWFod6LIhIWXmK@zeniv-ca.linux.org.uk>
References: <20220312162744.32318-1-alexander.vorwerk@stud.uni-goettingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312162744.32318-1-alexander.vorwerk@stud.uni-goettingen.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 05:27:44PM +0100, Alexander Vorwerk wrote:
> reported by checkpatch.pl

... nicely demonstrating why checkpatch.pl is a menace.

> Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
> ---
>  net/ipv4/tcp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 28ff2a820f7c..7fa6e7e6ea80 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -959,10 +959,10 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>  	struct sk_buff *skb = tcp_write_queue_tail(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	bool can_coalesce;
> -	int copy, i;
> +	int copy = size_goal - skb->len;
> +	int i;
>  
> -	if (!skb || (copy = size_goal - skb->len) <= 0 ||
> -	    !tcp_skb_can_collapse_to(skb)) {
> +	if (!skb || copy <= 0 || !tcp_skb_can_collapse_to(skb)) {

	What is going to happen when you variant runs into
skb == NULL?  And if for some reason that cannot happen, where
is the explanation of that reason?

	IOW, this patch ends up quietly introducing a bug, with
no better rationale than "checkpatch.pl pointed me to that line".

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
