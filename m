Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED6916087A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBQDIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:08:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:08:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53F111556049B;
        Sun, 16 Feb 2020 19:08:13 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:08:12 -0800 (PST)
Message-Id: <20200216.190812.1663746557417341122.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     jiri@resnulli.us, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        netdev@vger.kernel.org, soukjin.bae@samsung.com,
        edumazet@google.com
Subject: Re: [PATCH v2 net] net: sched: correct flower port blocking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581697224-20041-1-git-send-email-jbaron@akamai.com>
References: <CAM_iQpU_dbze9u2U+QjasAw6Rg3UPkax-rs=W1kwi3z4d5pwwg@mail.gmail.com>
        <1581697224-20041-1-git-send-email-jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:08:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Fri, 14 Feb 2020 11:20:24 -0500

> tc flower rules that are based on src or dst port blocking are sometimes
> ineffective due to uninitialized stack data. __skb_flow_dissect() extracts
> ports from the skb for tc flower to match against. However, the port
> dissection is not done when when the FLOW_DIS_IS_FRAGMENT bit is set in
> key_control->flags. All callers of __skb_flow_dissect(), zero-out the
> key_control field except for fl_classify() as used by the flower
> classifier. Thus, the FLOW_DIS_IS_FRAGMENT may be set on entry to
> __skb_flow_dissect(), since key_control is allocated on the stack
> and may not be initialized.
> 
> Since key_basic and key_control are present for all flow keys, let's
> make sure they are initialized.
> 
> Fixes: 62230715fd24 ("flow_dissector: do not dissect l4 ports for fragments")
> Co-developed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Jason Baron <jbaron@akamai.com>

Applied and queued up for -stable.
