Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B94245B44
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 06:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgHQEBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 00:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgHQEBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 00:01:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50293C061388;
        Sun, 16 Aug 2020 21:01:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 29AE7125007E2;
        Sun, 16 Aug 2020 20:44:18 -0700 (PDT)
Date:   Sun, 16 Aug 2020 21:01:01 -0700 (PDT)
Message-Id: <20200816.210101.1889351303629244050.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, martin.varghese@nokia.com, fw@strlen.de,
        pshelar@ovn.org, dcaratti@redhat.com, edumazet@google.com,
        steffen.klassert@secunet.com, pabeni@redhat.com,
        shmulik@metanetworks.com, kyk.segfault@gmail.com,
        sowmini.varadhan@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: handle the return value of pskb_carve_frag_list()
 correctly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c5b7896a7eb34d499979430156ea7e08@huawei.com>
References: <c5b7896a7eb34d499979430156ea7e08@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 20:44:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Mon, 17 Aug 2020 02:27:23 +0000

> David Miller <davem@davemloft.net> wrote:
>>> +	/* split line is in frag list */
>>> +	if (k == 0 && pskb_carve_frag_list(skb, shinfo, off - pos, gfp_mask)) {
>>> +		/* skb_frag_unref() is not needed here as shinfo->nr_frags = 0. */
>>> +		if (skb_has_frag_list(skb))
>>> +			kfree_skb_list(skb_shinfo(skb)->frag_list);
>>> +		kfree(data);
>>> +		return -ENOMEM;
>>
>>On error, the caller is going to kfree_skb(skb) which will take care of the frag list.
>>
> 
> I'am sorry for my careless. The caller will take care of the frag list and kfree(data) is enough here.
> Many thanks for review, will send v2 soon.

Actually, reading this again, what about the skb_clone_fraglist() done a few
lines up?  Who will release that reference to the fraglist items?

Maybe the kfree_skb_list() is necessary after all?
