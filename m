Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269F0574017
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGMXib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiGMXia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:38:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF024C62C;
        Wed, 13 Jul 2022 16:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A20FCB8220B;
        Wed, 13 Jul 2022 23:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83A3C3411E;
        Wed, 13 Jul 2022 23:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657755506;
        bh=sGMnc7ZlfnsYBnaBql7SMpnhQXnrXLXhnd3x7TOfCGw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tybh7T9F/yucZzbqEG/YK8RSvc9LnMRr+IQ1Mh3ANPfvogKy0tr5uRabcvI7NTv9G
         ftk7gMBC3jdyZ5ENbP5J26o7EADL7EF3S0v7ctx3brNpX4KzjolpEApeuEoFdIExAk
         M04xHoaR7g5MyzIMQ40SJoI3O8JxgNefjUuFstt/SyGZBqYnomhtIe/ozI3u6H8lgg
         6tLFTfdzxAfhO0QEnxwIu6lfZfVkiHBB3kbtV4fYeuJzvb3drS1dSTwANWYnI2ddo+
         JY+f8QrzTle5y57cJkPQpkna0fMFL5vsZhTi05UkvLhVLyhfHTQXrtukOoGGMHjYge
         Njr2PX88kfGwQ==
Message-ID: <e28b6ac9-c191-c36c-3769-4a43d49a86c2@kernel.org>
Date:   Wed, 13 Jul 2022 16:38:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 11/27] tcp: support externally provided ubufs
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <7ee05f644e3b3626b693973738364bcb23cf905d.1657194434.git.asml.silence@gmail.com>
 <62e1daba-fb20-bf20-5c4d-c31770e5420e@kernel.org>
 <45cd36ee-ef99-fb67-df8d-218603facfd7@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <45cd36ee-ef99-fb67-df8d-218603facfd7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/22 7:03 AM, Pavel Begunkov wrote:
>>> @@ -1356,9 +1362,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct
>>> msghdr *msg, size_t size)
>>>                 copy = min_t(int, copy, pfrag->size - pfrag->offset);
>>>   -            if (tcp_downgrade_zcopy_pure(sk, skb))
>>> -                goto wait_for_space;
>>> -
>>> +            if (unlikely(skb_zcopy_pure(skb) ||
>>> skb_zcopy_managed(skb))) {
>>> +                if (tcp_downgrade_zcopy_pure(sk, skb))
>>> +                    goto wait_for_space;
>>> +                skb_zcopy_downgrade_managed(skb);
>>> +            }
>>>               copy = tcp_wmem_schedule(sk, copy);
>>>               if (!copy)
>>>                   goto wait_for_space;
>>
>> You dropped the msg->msg_ubuf checks on jump labels. Removing the one
>> you had at 'out_nopush' I agree with based on my tests (i.e, it is not
>> needed).
> 
> It was an optimisation, which I dropped for simplicity. Will be sending it
> and couple more afterwards.
> 
> 
>> The one at 'out_err' seems like it is needed - but it has been a few
>> weeks since I debugged that case. I believe the error path I was hitting
>> was sk_stream_wait_memory with MSG_DONTWAIT flag set meaning timeout is
>> 0 and it jumps there with EPIPE.
> 
> Currently, it's consistent with MSG_ZEROCOPY ubuf_info, we grab a ubuf_info
> reference at the beginning (msg_zerocopy_realloc() for MSG_ZEROCOPY and
> net_zcopy_get() for msg_ubuf), and then release it at the end
> with net_zcopy_put() or net_zcopy_put_abort().
> 

my fault; I somehow dropped a line in the port to the 5.13 kernel.


