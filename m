Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FC920DDB5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbgF2US1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:18:27 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22303 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732643AbgF2USZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 16:18:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593461904; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=jlncwWmSm0Y6z4mvjkYdRpi7j7MUq1ZA0ZcNu12eACM=;
 b=D4TzTG3CLFYNdpYrtuPHwmr0FWOeJm4sW3vult0IuXrLAl0N9tGMIArw2EfMcaRpo1eFlpt/
 GbBP7GfDgXfQHZ0VdtQD+N/gW6eReEteSs51NdbT58JV/NupAcTs7lYGDfxSfSN6J8GgPwov
 7FpiNDuXhCnc9xpSBIQP8M8xGO4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5efa4c80f3deea03f34fa309 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Jun 2020 20:18:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D09D1C433B7; Mon, 29 Jun 2020 20:18:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA4B8C433C6;
        Mon, 29 Jun 2020 20:18:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Jun 2020 14:18:06 -0600
From:   stranche@codeaurora.org
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net] genetlink: take netlink table lock when
 (un)registering
In-Reply-To: <CAM_iQpXXdpdKvVY4G=y8=R4TsYE0ovac=OCNfiaMmD=Rgn2utQ@mail.gmail.com>
References: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
 <CAM_iQpXXdpdKvVY4G=y8=R4TsYE0ovac=OCNfiaMmD=Rgn2utQ@mail.gmail.com>
Message-ID: <8eba464937d34d8330a82332ebd672eb@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-27 12:55, Cong Wang wrote:
> On Fri, Jun 26, 2020 at 5:32 PM Sean Tranchetti 
> <stranche@codeaurora.org> wrote:
>> 
>> A potential deadlock can occur during registering or unregistering a 
>> new
>> generic netlink family between the main nl_table_lock and the cb_lock 
>> where
>> each thread wants the lock held by the other, as demonstrated below.
>> 
>> 1) Thread 1 is performing a netlink_bind() operation on a socket. As 
>> part
>>    of this call, it will call netlink_lock_table(), incrementing the
>>    nl_table_users count to 1.
>> 2) Thread 2 is registering (or unregistering) a genl_family via the
>>    genl_(un)register_family() API. The cb_lock semaphore will be taken 
>> for
>>    writing.
>> 3) Thread 1 will call genl_bind() as part of the bind operation to 
>> handle
>>    subscribing to GENL multicast groups at the request of the user. It 
>> will
>>    attempt to take the cb_lock semaphore for reading, but it will fail 
>> and
>>    be scheduled away, waiting for Thread 2 to finish the write.
>> 4) Thread 2 will call netlink_table_grab() during the (un)registration
>>    call. However, as Thread 1 has incremented nl_table_users, it will 
>> not
>>    be able to proceed, and both threads will be stuck waiting for the
>>    other.
>> 
>> To avoid this scenario, the locks should be acquired in the same order 
>> by
>> both threads. Since both the register and unregister functions need to 
>> take
>> the nl_table_lock in their processing, it makes sense to explicitly 
>> acquire
>> them before they lock the genl_mutex and the cb_lock. In 
>> unregistering, no
>> other change is needed aside from this locking change.
> 
> Like the kernel test robot reported, you can not call genl_lock_all 
> while
> holding netlink_table_grab() which is effectively a write lock.
> 
> To me, it seems genl_bind() can be just removed as there is no one
> in-tree uses family->mcast_bind(). Can you test the attached patch?
> It seems sufficient to fix this deadlock.
> 
> Thanks.

Thanks Cong. Yes, removing the genl_bind()/genl_unbind() functions 
eliminates the
potential for this deadlock. Adding Johannes here to comment on removing 
these,
as the family->mcast_bind() capability added by commit c380d9a7afff
("genetlink: pass multicast bind/unbind to families") would be lost.
