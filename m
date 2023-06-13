Return-Path: <netdev+bounces-10308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7CD72DC15
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8553E2811C5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20527495;
	Tue, 13 Jun 2023 08:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60B9567E
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:11:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773AD10D8
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:11:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 10DCB1FD78;
	Tue, 13 Jun 2023 08:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686643866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEeqTwNzeUy3t5ntNL+0pskfKElCphvbrZ3/VYlHntM=;
	b=Xt5ztVkwhWMejWLk8U/aueZzDx/KjtXB2jSwR/0UG7RZCQ7pZmHl07dLKE9CY7DxsWylL/
	icQSCSg9Mtkc8OLl2aU4hwHBNGJzmk4wDGBzCtHDuYCXfhBxK/dB8IxfPfmMOMyLw4G4yT
	khyAYJOm5qX/W0EEku+amUpP8usIqwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686643866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEeqTwNzeUy3t5ntNL+0pskfKElCphvbrZ3/VYlHntM=;
	b=a2HitXy1yN0lU385W1RwWyK4Tiyjh15mBzR5D/t4fb2pYa9chqd+EwUq/u/6U/3/KclTdS
	x5ElHnk/AXPveVDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F149F13483;
	Tue, 13 Jun 2023 08:11:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id y3XiOZkkiGSXKgAAMHmgww
	(envelope-from <hare@suse.de>); Tue, 13 Jun 2023 08:11:05 +0000
Message-ID: <acdb1a68-3180-0099-8520-24feb9a71efa@suse.de>
Date: Tue, 13 Jun 2023 10:11:01 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/4] net/tls: handle MSG_EOR for tls_device TX flow
To: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20230612143833.70805-1-hare@suse.de>
 <20230612143833.70805-3-hare@suse.de>
 <f560c8fa-d6a1-7bd2-3fd7-728f90207322@grimberg.me>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <f560c8fa-d6a1-7bd2-3fd7-728f90207322@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/13/23 09:58, Sagi Grimberg wrote:
> 
> 
> On 6/12/23 17:38, Hannes Reinecke wrote:
>> tls_push_data() MSG_MORE / MSG_SENDPAGE_NOTLAST, but bails
>> out on MSG_EOR.
>> But seeing that MSG_EOR is basically the opposite of
>> MSG_MORE / MSG_SENDPAGE_NOTLAST this patch adds handling
>> MSG_EOR by treating it as the absence of MSG_MORE.
>> Consequently we should return an error when both are set.
>>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   net/tls/tls_device.c | 24 ++++++++++++++++++++----
>>   1 file changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>> index a7cc4f9faac2..0024febd40de 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -448,10 +448,6 @@ static int tls_push_data(struct sock *sk,
>>       int copy, rc = 0;
>>       long timeo;
>> -    if (flags &
>> -        ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | 
>> MSG_SENDPAGE_NOTLAST))
>> -        return -EOPNOTSUPP;
>> -
>>       if (unlikely(sk->sk_err))
>>           return -sk->sk_err;
>> @@ -529,6 +525,10 @@ static int tls_push_data(struct sock *sk,
>>                   more = true;
>>                   break;
>>               }
>> +            if (flags & MSG_EOR) {
>> +                more = false;
>> +                break;
>> +            }
>>               done = true;
>>           }
>> @@ -573,6 +573,14 @@ int tls_device_sendmsg(struct sock *sk, struct 
>> msghdr *msg, size_t size)
>>       union tls_iter_offset iter;
>>       int rc;
>> +    if (msg->msg_flags &
>> +        ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_EOR))
>> +        return -EOPNOTSUPP;
>> +
>> +    if ((msg->msg_flags & MSG_MORE) &&
>> +        (msg->msg_flags & MSG_EOR))
>> +        return -EOPNOTSUPP;
> 
> EINVAL is more appropriate I think...
> 
Guess what, that's what I did initially.
But then when returning EINVAL we would arguably introduce a regression
(as suddenly we'll be returning a different error code as previously).
So with this patch we're backwards compatible.

But that's really a quesion for Jakub: what's more appropriate here?
Return a new error code (which describes the situation better) or stick
with the original one (and retain compability)?

Cheers,

Hannes


