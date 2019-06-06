Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876E537C1D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbfFFST4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:19:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:19:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50D1914DE1037;
        Thu,  6 Jun 2019 11:19:55 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:19:54 -0700 (PDT)
Message-Id: <20190606.111954.2036000288766363267.davem@davemloft.net>
To:     fw@strlen.de
Cc:     john.hurley@netronome.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, oss-drivers@netronome.com
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
        <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:19:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 6 Jun 2019 14:58:18 +0200

>> @@ -827,6 +828,7 @@ struct sk_buff {
>>  	__u8			tc_at_ingress:1;
>>  	__u8			tc_redirected:1;
>>  	__u8			tc_from_ingress:1;
>> +	__u8			tc_hop_count:2;
> 
> I dislike this, why can't we just use a pcpu counter?

I understand that it's because the only precise context is per-SKB not
per-cpu doing packet processing.  This has been discussed before.
