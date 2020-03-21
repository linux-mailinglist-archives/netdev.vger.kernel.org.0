Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3318DD8E
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 02:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgCUBv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 21:51:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25263 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbgCUBv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 21:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584755516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+Q36V4rd4UMSfz8nT4bEXIIO5pmKgsmOZOZyFzcAyI=;
        b=V2WzG4dhL2TXMK2dHYlSsgykLcy8C/HFucwPBf2PbhOiNNg2oxrUD/UC14aRGPj+J46yQI
        cKg6zQKn7SwJ5jhbneOFjyX3LxPCTzi/SNjavT8upNR8v+vWTmk/8Qykhiz/Pe5I0FDs90
        H4SsGmXjChY5g/bC5Fxlxlz1N1Gy2iY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-OdZ44-2iMHiH5OJz8hmoag-1; Fri, 20 Mar 2020 21:51:53 -0400
X-MC-Unique: OdZ44-2iMHiH5OJz8hmoag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5C0B13EA;
        Sat, 21 Mar 2020 01:51:50 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-190.rdu2.redhat.com [10.10.118.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16536912B5;
        Sat, 21 Mar 2020 01:51:46 +0000 (UTC)
Subject: Re: [PATCH v6 2/2] KEYS: Avoid false positive ENOMEM error on key
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
References: <20200320191903.19494-1-longman@redhat.com>
 <20200320191903.19494-3-longman@redhat.com>
 <20200320221918.GA5284@linux.intel.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <208854de-824e-5926-e02d-1f5678af3548@redhat.com>
Date:   Fri, 20 Mar 2020 21:51:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320221918.GA5284@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 6:19 PM, Jarkko Sakkinen wrote:
> On Fri, Mar 20, 2020 at 03:19:03PM -0400, Waiman Long wrote:
>> By allocating a kernel buffer with a user-supplied buffer length, it
>> is possible that a false positive ENOMEM error may be returned because
>> the user-supplied length is just too large even if the system do have
>> enough memory to hold the actual key data.
>>
>> Moreover, if the buffer length is larger than the maximum amount of
>> memory that can be returned by kmalloc() (2^(MAX_ORDER-1) number of
>> pages), a warning message will also be printed.
>>
>> To reduce this possibility, we set a threshold (page size) over which we
>> do check the actual key length first before allocating a buffer of the
>> right size to hold it. The threshold is arbitrary, it is just used to
>> trigger a buffer length check. It does not limit the actual key length
>> as long as there is enough memory to satisfy the memory request.
>>
>> To further avoid large buffer allocation failure due to page
>> fragmentation, kvmalloc() is used to allocate the buffer so that vmapped
>> pages can be used when there is not a large enough contiguous set of
>> pages available for allocation.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  security/keys/internal.h | 12 ++++++++++++
>>  security/keys/keyctl.c   | 39 +++++++++++++++++++++++++++++++--------
>>  2 files changed, 43 insertions(+), 8 deletions(-)
>>
>> diff --git a/security/keys/internal.h b/security/keys/internal.h
>> index ba3e2da14cef..6d0ca48ae9a5 100644
>> --- a/security/keys/internal.h
>> +++ b/security/keys/internal.h
>> @@ -16,6 +16,8 @@
>>  #include <linux/keyctl.h>
>>  #include <linux/refcount.h>
>>  #include <linux/compat.h>
>> +#include <linux/mm.h>
>> +#include <linux/vmalloc.h>
>>  
>>  struct iovec;
>>  
>> @@ -349,4 +351,14 @@ static inline void key_check(const struct key *key)
>>  
>>  #endif
>>  
>> +/*
>> + * Helper function to clear and free a kvmalloc'ed memory object.
>> + */
>> +static inline void __kvzfree(const void *addr, size_t len)
>> +{
>> +	if (addr) {
>> +		memset((void *)addr, 0, len);
>> +		kvfree(addr);
>> +	}
>> +}
>>  #endif /* _INTERNAL_H */
>> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
>> index 5a0794cb8815..ded69108db0d 100644
>> --- a/security/keys/keyctl.c
>> +++ b/security/keys/keyctl.c
>> @@ -339,7 +339,7 @@ long keyctl_update_key(key_serial_t id,
>>  	payload = NULL;
>>  	if (plen) {
>>  		ret = -ENOMEM;
>> -		payload = kmalloc(plen, GFP_KERNEL);
>> +		payload = kvmalloc(plen, GFP_KERNEL);
>>  		if (!payload)
>>  			goto error;
>>  
>> @@ -360,7 +360,7 @@ long keyctl_update_key(key_serial_t id,
>>  
>>  	key_ref_put(key_ref);
>>  error2:
>> -	kzfree(payload);
>> +	__kvzfree(payload, plen);
>>  error:
>>  	return ret;
>>  }
>> @@ -877,13 +877,23 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
>>  		 * transferring them to user buffer to avoid potential
>>  		 * deadlock involving page fault and mmap_sem.
>>  		 */
>> -		char *key_data = kmalloc(buflen, GFP_KERNEL);
>> +		char *key_data = NULL;
>> +		size_t key_data_len = buflen;
>>  
>> -		if (!key_data) {
>> -			ret = -ENOMEM;
>> -			goto error2;
>> +		/*
>> +		 * When the user-supplied key length is larger than
>> +		 * PAGE_SIZE, we get the actual key length first before
>> +		 * allocating a right-sized key data buffer.
>> +		 */
>> +		if (buflen <= PAGE_SIZE) {
>> +allocbuf:
> Would move this label before condition instead of jumping inside the
> nested block since it will always evaluate correctly.

Yes, you are right. That was not the case for initial version and I
didn't recheck it.


> To this version haven't really gotten why you don't use a legit loop
> construct but instead jump from one random nested location to another
> random nested location? This construct will be somewhat nasty to
> maintain. The construct is weird enough that you should have rather
> good explanation in the long description why such a mess.

I did that to avoid deep nesting. I can rewrite it to remove the the
goto statement.


>
>> +			key_data = kvmalloc(key_data_len, GFP_KERNEL);
>> +			if (!key_data) {
>> +				ret = -ENOMEM;
>> +				goto error2;
>> +			}
>>  		}
>> -		ret = __keyctl_read_key(key, key_data, buflen);
>> +		ret = __keyctl_read_key(key, key_data, key_data_len);
>>  
>>  		/*
>>  		 * Read methods will just return the required length
>> @@ -891,10 +901,23 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
>>  		 * enough.
>>  		 */
>>  		if (ret > 0 && ret <= buflen) {
>> +			/*
>> +			 * The key may change (unlikely) in between 2
>> +			 * consecutive __keyctl_read_key() calls. We will
>> +			 * need to allocate a larger buffer and redo the key
>> +			 * read when key_data_len < ret <= buflen.
>> +			 */
>> +			if (!key_data || unlikely(ret > key_data_len)) {
>> +				if (unlikely(key_data))
>> +					__kvzfree(key_data, key_data_len);
>> +				key_data_len = ret;
>> +				goto allocbuf;
>> +			}
>> +
>>  			if (copy_to_user(buffer, key_data, ret))
>>  				ret = -EFAULT;
>>  		}
>> -		kzfree(key_data);
>> +		__kvzfree(key_data, key_data_len);
>>  	}
>>  
>>  error2:
>> -- 
>> 2.18.1
>>
> Doesn't this go to infinite loop if actual key size is at least
> PAGE_SIZE + 1? Where is the guarantee that this cannot happen?

I think you may have the wrong impression that it caps the buffer length
to PAGE_SIZE. That is not true. key_data_len can be greater than
PAGE_SIZE. I run tests that include one that creates a big key of almost
1Mb. So for buflen <= PAGE_SIZE, key_data_len = buflen. For buflen >
PAGE_SIZE, key_data_len = the actual key length which can be >
PAGE_SIZE. This patch just tries to avoid allocating arbitrary large
buffer with a length much larger than the actual key length.

I will try to make the code easier to read.

Cheers,
Longman

