Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754A11FB191
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 15:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgFPNFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 09:05:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26115 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728561AbgFPNFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 09:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592312717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7nZX/JZoMn+I5qsocsgLqRgQUtpNpbf+EHIybmwJtOc=;
        b=Kb1ntucIH/6101JMcJj/Quohma8qEmcmMwFqnZXJaANFqcO993o0plTYecMTky9PEKK8E+
        FdsLdLUt8n/cP0JxjVNUiJKLD+G9+oc4hb+mic1vrT33io221HtRHjVQJVHfTNTWgh1fQf
        +D0yScY7r1lA5CagffHtuiymwFSRh80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-9xOyBG-QPzmPq6osX1JXvA-1; Tue, 16 Jun 2020 09:05:14 -0400
X-MC-Unique: 9xOyBG-QPzmPq6osX1JXvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 108C8107B7CB;
        Tue, 16 Jun 2020 13:05:07 +0000 (UTC)
Received: from llong.remote.csb (ovpn-114-156.rdu2.redhat.com [10.10.114.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3337D5D9E4;
        Tue, 16 Jun 2020 13:05:01 +0000 (UTC)
Subject: Re: [PATCH v4 1/3] mm/slab: Use memzero_explicit() in kzfree()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.cz>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
References: <20200616015718.7812-1-longman@redhat.com>
 <20200616015718.7812-2-longman@redhat.com>
 <20200616033035.GB902@sol.localdomain>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <56c2304c-73cc-8f48-d8d0-5dd6c39f33f3@redhat.com>
Date:   Tue, 16 Jun 2020 09:05:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200616033035.GB902@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 11:30 PM, Eric Biggers wrote:
> On Mon, Jun 15, 2020 at 09:57:16PM -0400, Waiman Long wrote:
>> The kzfree() function is normally used to clear some sensitive
>> information, like encryption keys, in the buffer before freeing it back
>> to the pool. Memset() is currently used for the buffer clearing. However,
>> it is entirely possible that the compiler may choose to optimize away the
>> memory clearing especially if LTO is being used. To make sure that this
>> optimization will not happen, memzero_explicit(), which is introduced
>> in v3.18, is now used in kzfree() to do the clearing.
>>
>> Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/slab_common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 9e72ba224175..37d48a56431d 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1726,7 +1726,7 @@ void kzfree(const void *p)
>>   	if (unlikely(ZERO_OR_NULL_PTR(mem)))
>>   		return;
>>   	ks = ksize(mem);
>> -	memset(mem, 0, ks);
>> +	memzero_explicit(mem, ks);
>>   	kfree(mem);
>>   }
>>   EXPORT_SYMBOL(kzfree);
> This is a good change, but the commit message isn't really accurate.  AFAIK, no
> one has found any case where this memset() gets optimized out.  And even with
> LTO, it would be virtually impossible due to all the synchronization and global
> data structures that kfree() uses.  (Remember that this isn't the C standard
> function "free()", so the compiler can't assign it any special meaning.)
> Not to mention that LTO support isn't actually upstream yet.
>
> I still agree with the change, but it might be helpful if the commit message
> were honest that this is really a hardening measure and about properly conveying
> the intent.  As-is this sounds like a critical fix, which might confuse people.

Yes, I agree that the commit log may look a bit scary. How about the 
following:

The kzfree() function is normally used to clear some sensitive
information, like encryption keys, in the buffer before freeing it back
to the pool. Memset() is currently used for buffer clearing. However
unlikely, there is still a non-zero probability that the compiler may
choose to optimize away the memory clearing especially if LTO is being
used in the future. To make sure that this optimization will never
happen, memzero_explicit(), which is introduced in v3.18, is now used
in kzfree() to future-proof it.

Cheers,
Longman

