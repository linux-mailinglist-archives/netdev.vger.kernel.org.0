Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FAA18CECF
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCTN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:27:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31846 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727133AbgCTN1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584710832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POqaw/FzEI0CTYjogTPDNEyESdDoII+GoAasJ6PFXJc=;
        b=AOugaLk+fvsm+Sh9/dYT7edGGoj/cEp/jrnYM09hLAKYKclgj2+lesXiWuFd38bIWmyN+N
        n3wrQ+HaKuddTlxbA7cEw1AzWWZiEwrWvyGID07ldVMF/bSdKeIuLLs76zDF5JPjRRzora
        RxA2EjtfJFTah2IA+lmds30J3AOz/kQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-wfUqiJITPG6-L5EefAJGvA-1; Fri, 20 Mar 2020 09:27:10 -0400
X-MC-Unique: wfUqiJITPG6-L5EefAJGvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2697477;
        Fri, 20 Mar 2020 13:27:07 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-190.rdu2.redhat.com [10.10.118.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3F4660BFB;
        Fri, 20 Mar 2020 13:27:03 +0000 (UTC)
Subject: Re: [PATCH v5 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
References: <20200318221457.1330-1-longman@redhat.com>
 <20200318221457.1330-3-longman@redhat.com>
 <20200319194650.GA24804@linux.intel.com>
 <f22757ad-4d6f-ffd2-eed5-6b9bd1621b10@redhat.com>
 <20200320020717.GC183331@linux.intel.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <7dbc524f-6c16-026a-a372-2e80b40eab30@redhat.com>
Date:   Fri, 20 Mar 2020 09:27:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320020717.GC183331@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 10:07 PM, Jarkko Sakkinen wrote:
> On Thu, Mar 19, 2020 at 08:07:55PM -0400, Waiman Long wrote:
>> On 3/19/20 3:46 PM, Jarkko Sakkinen wrote:
>>> On Wed, Mar 18, 2020 at 06:14:57PM -0400, Waiman Long wrote:
>>>> +			 * It is possible, though unlikely, that the key
>>>> +			 * changes in between the up_read->down_read period.
>>>> +			 * If the key becomes longer, we will have to
>>>> +			 * allocate a larger buffer and redo the key read
>>>> +			 * again.
>>>> +			 */
>>>> +			if (!tmpbuf || unlikely(ret > tmpbuflen)) {
>>> Shouldn't you check that tmpbuflen stays below buflen (why else
>>> you had made copy of buflen otherwise)?
>> The check above this thunk:
>>
>> if ((ret > 0) && (ret <= buflen)) {
>>
>> will make sure that ret will not be larger than buflen. So tmpbuflen
>> will never be bigger than buflen.
> Ah right, of course, thanks.
>
> What would go wrong if the condition was instead
> ((ret > 0) && (ret <= tmpbuflen))?

That if statement is a check to see if the actual key length is longer
than the user-supplied buffer (buflen). If that is the case, it will
just return the expected length without storing anything into the user
buffer. For the case that buflen >= ret > tmpbuflen, the revised check
above will incorrectly skip the storing step causing the caller to
incorrectly think the key is there in the buffer.

Maybe I should clarify that a bit more in the comment.

Cheers,
Longman

