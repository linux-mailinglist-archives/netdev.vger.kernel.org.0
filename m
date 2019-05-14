Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E891C11A
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfENDmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfENDmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 23:42:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D405D3092667;
        Tue, 14 May 2019 03:42:20 +0000 (UTC)
Received: from [10.72.12.59] (ovpn-12-59.pek2.redhat.com [10.72.12.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2679E608AB;
        Tue, 14 May 2019 03:42:12 +0000 (UTC)
Subject: Re: [PATCH net] vhost: don't use kmap() to log dirty pages
To:     David Miller <davem@davemloft.net>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        James.Bottomley@HansenPartnership.com, aarcange@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        dvhart@infradead.org
References: <1557725265-63525-1-git-send-email-jasowang@redhat.com>
 <20190513.094218.1962516460150696760.davem@davemloft.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c8369a44-f4e0-4132-b470-cca7a044bb02@redhat.com>
Date:   Tue, 14 May 2019 11:42:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513.094218.1962516460150696760.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 14 May 2019 03:42:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/14 上午12:42, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 13 May 2019 01:27:45 -0400
>
>> Vhost log dirty pages directly to a userspace bitmap through GUP and
>> kmap_atomic() since kernel doesn't have a set_bit_to_user()
>> helper. This will cause issues for the arch that has virtually tagged
>> caches. The way to fix is to keep using userspace virtual
>> address. Fortunately, futex has arch_futex_atomic_op_inuser() which
>> could be used for setting a bit to user.
>>
>> Note there're several cases that futex helper can fail e.g a page
>> fault or the arch that doesn't have the support. For those cases, a
>> simplified get_user()/put_user() pair protected by a global mutex is
>> provided as a fallback. The fallback may lead false positive that
>> userspace may see more dirty pages.
>>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Darren Hart <dvhart@infradead.org>
>> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> I want to see a review from Michael for this change before applying.


No problem, since kbuild spotted an issue. Let me post V2.

Thanks

