Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932EA4818CE
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhL3DCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:02:30 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:57052 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234683AbhL3DC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:02:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0HsNuA_1640833346;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V0HsNuA_1640833346)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Dec 2021 11:02:27 +0800
Date:   Thu, 30 Dec 2021 11:02:26 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net 1/2] net/smc: don't send CDC/LLC message if link not
 ready
Message-ID: <20211230030226.GA55356@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
 <20211228090325.27263-2-dust.li@linux.alibaba.com>
 <2b3dd919-029c-cd44-b39c-5467bb723c0f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b3dd919-029c-cd44-b39c-5467bb723c0f@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 01:36:06PM +0100, Karsten Graul wrote:
>On 28/12/2021 10:03, Dust Li wrote:
>> We found smc_llc_send_link_delete_all() sometimes wait
>> for 2s timeout when testing with RDMA link up/down.
>> It is possible when a smc_link is in ACTIVATING state,
>> the underlaying QP is still in RESET or RTR state, which
>> cannot send any messages out.
>
>I see your point, but why do you needed to introduce a new wrapper instead of
>extending the existing smc_link_usable() wrapper?
>With that and without any comments the reader of the code does not know why there are
>2 different functions and what is the reason for having two of them.

Sorry for that, I should add some comments for those wrappers to
better explain that.

The reason we need two wrappers here is because the QP state for the
client side is not turned into RTS directly, but seperated into two
stages. In the middle on RTR to RTS, we still need smc_link_usable().

For example:
For the client side in first contact, the QP is still in RTR before it
receives the LLC_CONFIRM message. So for functions like smc_llc_wait()
or smc_llc_event_handler(), we can't use smc_link_sendable(), or we
can't even receive LLC_CONFIRM message anymore.

So the meaning for those 2 wrappers should be:
smc_link_usable():   the link is ready to receive RDMA messages
smc_link_sendable(): the link is ready to send RDMA messages

For those places that need to send any CDC or LLC message,
should go for smc_link_sendable(), otherwise, use smc_link_usable()
instead.

I saw David has already applied this to net, should I send another
patch to add some comments ?

