Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71EE83AC7
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHFVGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:06:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfHFVGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:06:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 146A61265AA8B;
        Tue,  6 Aug 2019 14:06:50 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:06:49 -0700 (PDT)
Message-Id: <20190806.140649.288630570722100962.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net 0/2] Fix batched event generation for vlan action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
References: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:06:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Fri,  2 Aug 2019 15:16:45 -0400

> When adding or deleting a batch of entries, the kernel sends up to
> TCA_ACT_MAX_PRIO (defined to 32 in kernel) entries in an event to user
> space. However it does not consider that the action sizes may vary and
> require different skb sizes.
> 
> For example, consider the following script adding 32 entries with all
> supported vlan parameters (in order to maximize netlink messages size):
> 
> % cat tc-batch.sh
> TC="sudo /mnt/iproute2.git/tc/tc"
> 
> $TC actions flush action vlan
> for i in `seq 1 $1`;
> do
>    cmd="action vlan push protocol 802.1q id 4094 priority 7 pipe \
>                index $i cookie aabbccddeeff112233445566778800a1 "
>    args=$args$cmd
> done
> $TC actions add $args
> %
> % ./tc-batch.sh 32
> Error: Failed to fill netlink attributes while adding TC action.
> We have an error talking to the kernel
> %
> 
> patch 1 adds callback in tc_action_ops of vlan action, which calculates
> the action size, and passes size to tcf_add_notify()/tcf_del_notify().
> 
> patch 2 updates the TDC test suite with relevant vlan test cases.

Series applied and patch #1 queued up for -stable.
