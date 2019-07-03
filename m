Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5285EDE5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGCUwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:52:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGCUwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:52:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0AC6144E3DE0;
        Wed,  3 Jul 2019 13:52:10 -0700 (PDT)
Date:   Wed, 03 Jul 2019 13:52:09 -0700 (PDT)
Message-Id: <20190703.135209.966870558930236834.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] net: use ICW for
 sk_proto->{send,recv}msg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAF=yD-+z8-rq5bcrm3NdMv4kHp1HvoucxVBG3kLHxV9NS35EBw@mail.gmail.com>
References: <cover.1562162469.git.pabeni@redhat.com>
        <CAF=yD-+z8-rq5bcrm3NdMv4kHp1HvoucxVBG3kLHxV9NS35EBw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 13:52:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 3 Jul 2019 10:45:13 -0400

> On Wed, Jul 3, 2019 at 10:07 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>
>> This series extends ICW usage to one of the few remaining spots in fast-path
>> still hitting per packet retpoline overhead, namely the sk_proto->{send,recv}msg
>> calls.
>>
>> The first 3 patches in this series refactor the existing code so that applying
>> the ICW macros is straight-forward: we demux inet_{recv,send}msg in ipv4 and
>> ipv6 variants so that each of them can easily select the appropriate TCP or UDP
>> direct call. While at it, a new helper is created to avoid excessive code
>> duplication, and the current ICWs for inet_{recv,send}msg are adjusted
>> accordingly.
>>
>> The last 2 patches really introduce the new ICW use-case, respectively for the
>> ipv6 and the ipv4 code path.
>>
>> This gives up to 5% performance improvement under UDP flood, and smaller but
>> measurable gains for TCP RR workloads.
>>
>> v1 -> v2:
>>  - drop inet6_{recv,send}msg declaration from header file,
>>    prefer ICW macro instead
>>  - avoid unneeded reclaration for udp_sendmsg, as suggested by Willem
>>
>> Paolo Abeni (5):
>>   inet: factor out inet_send_prepare()
>>   ipv6: provide and use ipv6 specific version for {recv,send}msg
>>   net: adjust socket level ICW to cope with ipv6 variant of
>>     {recv,send}msg
>>   ipv6: use indirect call wrappers for {tcp,udpv6}_{recv,send}msg()
>>   ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

Series applied, thanks.
