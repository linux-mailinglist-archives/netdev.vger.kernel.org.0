Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2E1FA551
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgFPBA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgFPBA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:00:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815ABC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:00:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93345121995A3;
        Mon, 15 Jun 2020 18:00:25 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:00:22 -0700 (PDT)
Message-Id: <20200615.180022.2063479179425015644.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     dcaratti@redhat.com, Po.Liu@nxp.com, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of
 the periodic timer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
References: <cover.1592247564.git.dcaratti@redhat.com>
        <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
        <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:00:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 16 Jun 2020 00:55:50 +0300

> On Mon, 15 Jun 2020 at 22:33, Davide Caratti <dcaratti@redhat.com> wrote:
>>
>> assigning a dummy value of 'clock_id' to avoid cancellation of the cycle
>> timer before its initialization was a temporary solution, and we still
>> need to handle the case where act_gate timer parameters are changed by
>> commands like the following one:
>>
>>  # tc action replace action gate <parameters>
>>
>> the fix consists in the following items:
>>
>> 1) remove the workaround assignment of 'clock_id', and init the list of
>>    entries before the first error path after IDR atomic check/allocation
>> 2) validate 'clock_id' earlier: there is no need to do IDR atomic
>>    check/allocation if we know that 'clock_id' is a bad value
>> 3) use a dedicated function, 'gate_setup_timer()', to ensure that the
>>    timer is cancelled and re-initialized on action overwrite, and also
>>    ensure we initialize the timer in the error path of tcf_gate_init()
>>
>> v2: avoid 'goto' in gate_setup_timer (thanks to Cong Wang)
>>
> 
> The change log is put under the 3 '---' characters for a reason: it is
> relevant only to reviewers, and git automatically trims it when
> applying the patch. The way it is now, the commit message would
> contain this line about "v2 ...".

I completely disagree and I ask submitters of networking changes to keep
the changelog in the commit message.

Later people will look at this commit and ask "why didn't they do X
or Y" and if the changelog shows that the submitter was asked not to
do X or Y that is useful information.
