Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3969197C2
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfEJEsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:48:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfEJEsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 00:48:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5604308339A;
        Fri, 10 May 2019 04:48:16 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CE635C296;
        Fri, 10 May 2019 04:48:10 +0000 (UTC)
Subject: Re: [RFC PATCH V2] vhost: don't use kmap() to log dirty pages
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
References: <1557406680-4087-1-git-send-email-jasowang@redhat.com>
 <20190509090433-mutt-send-email-mst@kernel.org>
 <d6d69a36-9a3a-2a21-924e-97fdcc6e6733@redhat.com>
Message-ID: <fa6444aa-9c46-22f0-204a-c7592dc5bd51@redhat.com>
Date:   Fri, 10 May 2019 12:48:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d6d69a36-9a3a-2a21-924e-97fdcc6e6733@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 10 May 2019 04:48:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/10 上午10:59, Jason Wang wrote:
>>>
>>>         r = get_user_pages_fast(log, 1, 1, &page);
>> OK so the trick is that page is pinned so you don't expect
>> arch_futex_atomic_op_inuser below to fail.  get_user_pages_fast
>> guarantees page is not going away but does it guarantee PTE won't be
>> invaidated or write protected?
>
>
> Good point, then I think we probably need to do manual fixup through 
> fixup_user_fault() if arch_futex_atomic_op_in_user() fail. 


This looks like a overkill, we don't need to atomic environment here 
actually. Instead, just keep pagefault enabled should work. So just 
introduce arch_futex_atomic_op_inuser_inatomic() variant with pagefault 
disabled there just for futex should be sufficient.

Thanks

