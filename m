Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A612909DC
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409183AbgJPQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:42:43 -0400
Received: from mail.buslov.dev ([199.247.26.29]:35365 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409127AbgJPQmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 12:42:43 -0400
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id F3A0120CEC;
        Fri, 16 Oct 2020 19:42:40 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1602866561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mhbdyASxzl6gGnruFCtGYQGpX2eotGG7Tj8R7bAomlU=;
        b=J9pzIeRTTMJ89xjPYBzTujSNA47HUCmPQHQotNHh4HsK7nvzjLlHIPzQbUBr+Jh61pcDGy
        T0nFGIhZsK+QDurud84zof1CoFvZLZVkgrGWHHQYgi2eUm9snQBlvIU6HL8IYdn1jtmHk/
        2W91U2XWIZx8bNKuBiL4/IGSZu+udCIVGAW0EeEIVGo471hO7LOROKlYmsdUJVUQDikpEI
        TWtsTBwFFdixFa/rqYkSQVTDUfXF/lz8ue273TZK1p8FhjNjouqP2BhatZAZJQCuBSRuCK
        MN/cEuEzOW8YMKPNHD7Mg4YDk3ulqMqaAl5sfj4WFxzFzgm95hDF4QvuOpRsTg==
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-reply-to: <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
Date:   Fri, 16 Oct 2020 19:42:40 +0300
Message-ID: <87a6wm15rz.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 16 Oct 2020 at 19:07, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-16 10:42 a.m., Vlad Buslov wrote:
>> From: Vlad Buslov <vladbu@mellanox.com>
>>
>> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
>> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
>> user requested it with following example CLI (-br for 'brief'):
>>
>> $ tc -s -brief filter show dev ens1f0 ingress
>> filter protocol all pref 49151 flower chain 0
>> filter protocol all pref 49151 flower chain 0 handle 0x1
>>    not_in_hw
>>          action order 1:         Action statistics:
>>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>          backlog 0b 0p requeues 0
>>
>> filter protocol all pref 49152 flower chain 0
>> filter protocol all pref 49152 flower chain 0 handle 0x1
>>    not_in_hw
>>          action order 1:         Action statistics:
>>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>          backlog 0b 0p requeues 0
>>
>
> Should the action name at least show up?
>
>
> cheers,
> jamal

All action print callbacks have arg==NULL check and return at the
beginning. To print action type we need either to have dedicated
'brief_dump' callback instead of reusing print_aop() or extend/refactor
print_aop() implementation for all actions to always print the type
before checking the arg. What do you suggest?

