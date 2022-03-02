Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B554CAE92
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbiCBTXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbiCBTXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:23:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED0745054;
        Wed,  2 Mar 2022 11:22:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DCF3B821A3;
        Wed,  2 Mar 2022 19:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12911C004E1;
        Wed,  2 Mar 2022 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646248976;
        bh=QljIzW9++PpUcQnYcc8KXlsEqKlfxH2WaPKG//6egiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tlAPw6lWDcZ2jNLyAZrKmecShWpEr/g5ZIZNSnZGL1ALGeKTEIaoiiycogBNQm9Rq
         IcFzGc3PPii/IlqDhefvfcjhQvAElnj7iYLeTJPzJ84LiMZdXw4lSlYkKuP3nzC9pv
         f5+WOhtmTM0Z59Hh76H92N4N3xf18JGdeT+O9MUGIodvtpyT5p6tonTXIp5+ATC+3T
         Qs9LMryVpnYJmJdecF0kuecar83AnElBM/x883yodSM8ALsMgrQ9GeNGvFdKk4V7W1
         uPptJyW+SOV1BJeVJf+FUaq0yaBfXSADBPCpDdPIE6Zm9bXtaBzeW7X16jfPyJFxfg
         8oP3mvbWFNjzg==
Date:   Wed, 2 Mar 2022 11:22:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, edumazet@google.com
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Message-ID: <20220302112255.545618dd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <2071f8a0-148d-96fa-75b9-8277c2f87287@gmail.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-5-dongli.zhang@oracle.com>
        <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <2071f8a0-148d-96fa-75b9-8277c2f87287@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Mar 2022 20:29:37 -0700 David Ahern wrote:
> On 3/1/22 7:50 PM, Jakub Kicinski wrote:
> > On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:  
> >> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
> >> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */  
> > 
> > IDK if these are not too low level and therefore lacking meaning.
> > 
> > What are your thoughts David?  
> 
> I agree. Not every kfree_skb is worthy of a reason. "Internal
> housekeeping" errors are random and nothing a user / admin can do about
> drops.
> 
> IMHO, the value of the reason code is when it aligns with SNMP counters
> (original motivation for this direction) and relevant details like TCP
> or UDP checksum mismatch, packets for a socket that is not open, socket
> is full, ring buffer is full, packets for "other host", etc.

Agreed :(
