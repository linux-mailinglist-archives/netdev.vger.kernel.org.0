Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE67218D26A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCTPJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:09:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47360 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgCTPJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584716982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5+aUM1Yn2Y/IYb21uZgrRPO9zmI5FLmUctu7OcB3Czc=;
        b=XiD+H/RXSTTxQTYwdKnrIo8aDRuPzqrQ1c+6jR9qNwCVhu2JuIO0XoqNm095CLdAuDekZp
        gebchWus8myKinQ6dSPcihZBO8jvgWRGG1+U41DqTSLb6PyH6O65sRm8OolMR6rJcPvicL
        fa7tFowa6mZ1KJLAJRfucs2E1H18jL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-t2-NJVv6NAmkytbnxuHV-w-1; Fri, 20 Mar 2020 11:09:39 -0400
X-MC-Unique: t2-NJVv6NAmkytbnxuHV-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 354B018AB2C4;
        Fri, 20 Mar 2020 15:09:36 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-190.rdu2.redhat.com [10.10.118.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACDE25C1B8;
        Fri, 20 Mar 2020 15:09:32 +0000 (UTC)
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
 <7dbc524f-6c16-026a-a372-2e80b40eab30@redhat.com>
 <20200320143547.GB3629@linux.intel.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <ab411cce-e8dd-c81c-fec4-b59624f66d76@redhat.com>
Date:   Fri, 20 Mar 2020 11:09:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320143547.GB3629@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 10:35 AM, Jarkko Sakkinen wrote:
> On Fri, Mar 20, 2020 at 09:27:03AM -0400, Waiman Long wrote:
>> On 3/19/20 10:07 PM, Jarkko Sakkinen wrote:
>>> On Thu, Mar 19, 2020 at 08:07:55PM -0400, Waiman Long wrote:
>>>> On 3/19/20 3:46 PM, Jarkko Sakkinen wrote:
>>>>> On Wed, Mar 18, 2020 at 06:14:57PM -0400, Waiman Long wrote:
>>>>>> +			 * It is possible, though unlikely, that the key
>>>>>> +			 * changes in between the up_read->down_read period.
>>>>>> +			 * If the key becomes longer, we will have to
>>>>>> +			 * allocate a larger buffer and redo the key read
>>>>>> +			 * again.
>>>>>> +			 */
>>>>>> +			if (!tmpbuf || unlikely(ret > tmpbuflen)) {
>>>>> Shouldn't you check that tmpbuflen stays below buflen (why else
>>>>> you had made copy of buflen otherwise)?
>>>> The check above this thunk:
>>>>
>>>> if ((ret > 0) && (ret <= buflen)) {
>>>>
>>>> will make sure that ret will not be larger than buflen. So tmpbuflen > >> will never be bigger than buflen.  > > Ah right, of course, thanks.
>>> What would go wrong if the condition was instead
>>> ((ret > 0) && (ret <= tmpbuflen))?
>> That if statement is a check to see if the actual key length is longer
>> than the user-supplied buffer (buflen). If that is the case, it will
>> just return the expected length without storing anything into the user
>> buffer. For the case that buflen >= ret > tmpbuflen, the revised check
>> above will incorrectly skip the storing step causing the caller to
>> incorrectly think the key is there in the buffer.
>>
>> Maybe I should clarify that a bit more in the comment.
> OK, right because it is possible in-between tmpbuflen could be
> larger. Got it.
>
> I think that longish key_data and key_data_len would be better
> names than tmpbuf and tpmbuflen.
>
> Also the comments are somewat overkill IMHO.
>
> I'd replace them along the lines of
>
> /* Cap the user supplied buffer length to PAGE_SIZE. */
>
> /* Key data can change as we don not hold key->sem. */

I am fine with the rename, will sent out a v6 soon.

Cheers,
Longman

