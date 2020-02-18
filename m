Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C18162076
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgBRFdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:33:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgBRFdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:33:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93B9D15B46320;
        Mon, 17 Feb 2020 21:33:50 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:33:50 -0800 (PST)
Message-Id: <20200217.213350.1098567982796784517.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     jiri@resnulli.us, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        netdev@vger.kernel.org, soukjin.bae@samsung.com,
        edumazet@google.com
Subject: Re: [PATCH v3 net] net: sched: correct flower port blocking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581971889-5862-1-git-send-email-jbaron@akamai.com>
References: <20200216.191837.828352407289487240.davem@davemloft.net>
        <1581971889-5862-1-git-send-email-jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 21:33:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Mon, 17 Feb 2020 15:38:09 -0500

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

Applied and queued up for -stable, thanks Jason.
