Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CC968BA92
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBFKmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBFKmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:42:18 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529485FFE
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:42:11 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ml19so33040782ejb.0
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 02:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=CDZSsojkle05IADIgEpgIZPyFboQRLYqYj0aOWcp2yg=;
        b=f4eEh9y/Vn4Uhn6+195qV2uhyA5SE53iUQZAUh6l1ltf45QaF5N6biM6KfU4Ndqf5T
         y4/YJF9HNEZxmcIQ5SeoXxP/rMlt2XQS2l7K9KWYxcv0b2rjy4B6+b4wJLoQ3yQNWIos
         x6nH3W9+AH3+shxMivZzD8pLQxZPuMX8Y84Jk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDZSsojkle05IADIgEpgIZPyFboQRLYqYj0aOWcp2yg=;
        b=7ReYYssQV0gjD3vonilx/qE1Zkz8UEvJah9TpYQDGjh6pUQ5PqB/z/k9shJPduXkJ+
         uHBYqQp7N2b9E4oGvr6wajYi6FKPHOgm7rQe2G9L5H8wRrvuredJIrMEGlfRDLlwPbA/
         wOhNS9dWnjxQrbxeOtDp0gHmWzwS5uu6dWh9B6zACGd7VfCVMF29fyKsgve6qPY48GVo
         RL4Xyj3bNfmRWSOO1dEwfa1orQ8M4PsFR3MPfuAVuY8zVf58eDJ/qXHfVeqhzkpWPP/k
         ISLXtGTxRrosL6+TQ+ZUtcH4h7usZMVXJ13li8UNg41rtSX5dLivLy24uWJG+DErQr/F
         dz6w==
X-Gm-Message-State: AO0yUKX6LPO1beJAJhqUCOEgCzonmh4o17av9UG4HP5jsgVdl7x8Hdma
        1PrPAWXICSOuFsAKlbgV3le38A==
X-Google-Smtp-Source: AK7set+V+SwiFalwLuZERnEDbCjPH3i0aLRdwjFJa9hHIFQoe+FJa/WRzXRyvswuqs09gn5TnWtc6w==
X-Received: by 2002:a17:906:3ad8:b0:864:8c78:e7ff with SMTP id z24-20020a1709063ad800b008648c78e7ffmr18368977ejd.23.1675680129919;
        Mon, 06 Feb 2023 02:42:09 -0800 (PST)
Received: from cloudflare.com (79.191.53.204.ipv4.supernova.orange.pl. [79.191.53.204])
        by smtp.gmail.com with ESMTPSA id b14-20020a1709063f8e00b0088dc98e4510sm5305129ejj.112.2023.02.06.02.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 02:42:09 -0800 (PST)
References: <20230131174601.203127-1-jakub@cloudflare.com>
 <CANn89iL2PCnC=6dOrozW0309W==tWcKpj2iwZgZAD_s0amvzLA@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com
Subject: Re: [PATCH net] udp: Pass 2 bytes of data with UDP_GRO cmsg to
 user-space
Date:   Mon, 06 Feb 2023 11:41:56 +0100
In-reply-to: <CANn89iL2PCnC=6dOrozW0309W==tWcKpj2iwZgZAD_s0amvzLA@mail.gmail.com>
Message-ID: <87r0v3jcsf.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 06:57 PM +01, Eric Dumazet wrote:
> On Tue, Jan 31, 2023 at 6:46 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> While UDP_GRO cmsg interface lacks documentation, the selftests added in
>> commit 3327a9c46352 ("selftests: add functionals test for UDP GRO") suggest
>> that the user-space should allocate CMSG_SPACE for an u16 value and
>> interpret the returned bytes as such:
>>
>> static int recv_msg(int fd, char *buf, int len, int *gso_size)
>> {
>>         char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
>>         ...
>>                         if (cmsg->cmsg_level == SOL_UDP
>>                             && cmsg->cmsg_type == UDP_GRO) {
>>                                 gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
>>                                 *gso_size = *gsosizeptr;
>>                                 break;
>>                         }
>>         ...
>> }
>>
>> Today user-space will receive 4 bytes of data with an UDP_GRO cmsg, because
>> the kernel packs an int into the cmsg data, as we can confirm with strace:
>>
>>   recvmsg(8, {msg_name=...,
>>               msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
>>               msg_iovlen=1,
>>               msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
>>                             cmsg_level=SOL_UDP,
>>                             cmsg_type=0x68}],    <-- UDP_GRO
>>                             msg_controllen=24,
>>                             msg_flags=0}, 0) = 11200
>>
>> This means that either UDP_GRO selftests are broken on big endian, or this
>> is a programming error. Assume the latter and pass only the needed 2 bytes
>> of data with the cmsg.
>>
>> Fixing it like that has an added advantage that the cmsg becomes compatible
>> with what is expected by UDP_SEGMENT cmsg. It becomes possible to reuse the
>> cmsg when GSO packets are received on one socket and sent out of another.
>>
>> Fixes: bcd1665e3569 ("udp: add support for UDP_GRO cmsg")
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  include/linux/udp.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/udp.h b/include/linux/udp.h
>> index a2892e151644..44bb8d699248 100644
>> --- a/include/linux/udp.h
>> +++ b/include/linux/udp.h
>> @@ -125,7 +125,7 @@ static inline bool udp_get_no_check6_rx(struct sock *sk)
>>  static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
>>                                  struct sk_buff *skb)
>>  {
>> -       int gso_size;
>> +       __u16 gso_size;
>>
>>         if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
>>                 gso_size = skb_shinfo(skb)->gso_size;
>> --
>> 2.39.1
>>
>
> This would break some applications.
>
> I think the test can be fixed instead, this seems less risky.

Thanks for guidance. Will fix the test.
