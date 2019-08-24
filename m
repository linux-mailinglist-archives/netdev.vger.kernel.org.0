Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4165E9C09C
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfHXVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:51:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfHXVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 17:51:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57E9B15254B5B;
        Sat, 24 Aug 2019 14:51:02 -0700 (PDT)
Date:   Sat, 24 Aug 2019 14:51:01 -0700 (PDT)
Message-Id: <20190824.145101.762776744197266351.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com, wenxu@ucloud.cn,
        ast@fb.com, eric.dumazet@gmail.com, ja@ssi.bg
Subject: Re: [PATCHv4 0/2] fix dev null pointer dereference when send
 packets larger than mtu in collect_md mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822141949.29561-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
        <20190822141949.29561-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 14:51:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu, 22 Aug 2019 22:19:47 +0800

> When we send a packet larger than PMTU, we need to reply with
> icmp_send(ICMP_FRAG_NEEDED) or icmpv6_send(ICMPV6_PKT_TOOBIG).
> 
> But with collect_md mode, kernel will crash while accessing the dst dev
> as __metadata_dst_init() init dst->dev to NULL by default. Here is what
> the code path looks like, for GRE:
 ...
> We could not fix it in __metadata_dst_init() as there is no dev supplied.
> Look in to the __icmp_send()/decode_session{4,6} code we could find the dst
> dev is actually not needed. In __icmp_send(), we could get the net by skb->dev.
> For decode_session{4,6}, as it was called by xfrm_decode_session_reverse()
> in this scenario, the oif is not used by
> fl4->flowi4_oif = reverse ? skb->skb_iif : oif;
> 
> The reproducer is easy:
 ...

Series applied, and queued up for -stable, thanks!
