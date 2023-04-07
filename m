Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B646DA793
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbjDGCNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbjDGCNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:13:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C5F10C1;
        Thu,  6 Apr 2023 19:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE70562B68;
        Fri,  7 Apr 2023 02:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C934C433EF;
        Fri,  7 Apr 2023 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680833630;
        bh=FnCx5kBmg3BOil0cdazETi3OKImtCqFOSaJY70j7QqM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VkjV5PM8ekxVErbI2M8WiVvDkAWYuLZY0kkJBlSdwZMkC3ceRsynl5QOF60uTnmGp
         7UDEqx8jr/vM6fzi+JP6Kn0U10D3Ae1ov18aicQg0rYYQby3uMKr9rId6fsnUfSdlR
         rFgizS6FxqvfYICQrAkE+kBTtRLUI1yPDUAB/6AUo3/9lmtNI7YDtaGzIUAbRUHpk0
         a/0AQeFbUMF/k8KcAfY1ZBbytdfviIZMYIVybyQT5Fq3m2Z4AIeQajhZ7DLJdfMbH/
         f/JtSYeVaLMpg7v2tXhVg9YYqg8RcYXv6dST04/4vdEhCQpg7LgcPdyG7tJpD6K6gz
         tbWGaMVgDYXJA==
Message-ID: <3a109738-f666-20e5-a135-b466c5546c29@kernel.org>
Date:   Thu, 6 Apr 2023 20:13:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v5 05/19] tcp: Support MSG_SPLICE_PAGES
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20230406094245.3633290-1-dhowells@redhat.com>
 <20230406094245.3633290-6-dhowells@redhat.com>
 <CAF=yD-+QCYsjuRvzTOjhn=sKCWwOd5ZWxG6VS-xkYEoxzGkUkA@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAF=yD-+QCYsjuRvzTOjhn=sKCWwOd5ZWxG6VS-xkYEoxzGkUkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/23 7:56 PM, Willem de Bruijn wrote:
> On Thu, Apr 6, 2023 at 5:43 AM David Howells <dhowells@redhat.com> wrote:
>>
>> Make TCP's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
>> spliced from the source iterator.
>>
>> This allows ->sendpage() to be replaced by something that can handle
>> multiple multipage folios in a single transaction.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> cc: Eric Dumazet <edumazet@google.com>
>> cc: "David S. Miller" <davem@davemloft.net>
>> cc: David Ahern <dsahern@kernel.org>
>> cc: Jakub Kicinski <kuba@kernel.org>
>> cc: Paolo Abeni <pabeni@redhat.com>
>> cc: Jens Axboe <axboe@kernel.dk>
>> cc: Matthew Wilcox <willy@infradead.org>
>> cc: netdev@vger.kernel.org
>> ---
>>  net/ipv4/tcp.c | 67 ++++++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 60 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index fd68d49490f2..510bacc7ce7b 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -1221,7 +1221,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>         int flags, err, copied = 0;
>>         int mss_now = 0, size_goal, copied_syn = 0;
>>         int process_backlog = 0;
>> -       bool zc = false;
>> +       int zc = 0;
>>         long timeo;
>>
>>         flags = msg->msg_flags;
>> @@ -1232,17 +1232,22 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>                 if (msg->msg_ubuf) {
>>                         uarg = msg->msg_ubuf;
>>                         net_zcopy_get(uarg);
>> -                       zc = sk->sk_route_caps & NETIF_F_SG;
>> +                       if (sk->sk_route_caps & NETIF_F_SG)
>> +                               zc = 1;
>>                 } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>>                         uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>>                         if (!uarg) {
>>                                 err = -ENOBUFS;
>>                                 goto out_err;
>>                         }
>> -                       zc = sk->sk_route_caps & NETIF_F_SG;
>> -                       if (!zc)
>> +                       if (sk->sk_route_caps & NETIF_F_SG)
>> +                               zc = 1;
>> +                       else
>>                                 uarg_to_msgzc(uarg)->zerocopy = 0;
>>                 }
>> +       } else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
>> +               if (sk->sk_route_caps & NETIF_F_SG)
>> +                       zc = 2;
>>         }
>>
>>         if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
>> @@ -1305,7 +1310,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>                 goto do_error;
>>
>>         while (msg_data_left(msg)) {
>> -               int copy = 0;
>> +               ssize_t copy = 0;
>>
>>                 skb = tcp_write_queue_tail(sk);
>>                 if (skb)
>> @@ -1346,7 +1351,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>                 if (copy > msg_data_left(msg))
>>                         copy = msg_data_left(msg);
>>
>> -               if (!zc) {
>> +               if (zc == 0) {
>>                         bool merge = true;
>>                         int i = skb_shinfo(skb)->nr_frags;
>>                         struct page_frag *pfrag = sk_page_frag(sk);
>> @@ -1391,7 +1396,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>                                 page_ref_inc(pfrag->page);
>>                         }
>>                         pfrag->offset += copy;
>> -               } else {
>> +               } else if (zc == 1)  {
> 
> Instead of 1 and 2, MSG_ZEROCOPY and MSG_SPLICE_PAGES make the code
> more self-documenting.
> 
>>                         /* First append to a fragless skb builds initial
>>                          * pure zerocopy skb
>>                          */
>> @@ -1412,6 +1417,54 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>                         if (err < 0)
>>                                 goto do_error;
>>                         copy = err;
>> +               } else if (zc == 2) {
>> +                       /* Splice in data. */
>> +                       struct page *page = NULL, **pages = &page;
>> +                       size_t off = 0, part;
>> +                       bool can_coalesce;
>> +                       int i = skb_shinfo(skb)->nr_frags;
>> +
>> +                       copy = iov_iter_extract_pages(&msg->msg_iter, &pages,
>> +                                                     copy, 1, 0, &off);
>> +                       if (copy <= 0) {
>> +                               err = copy ?: -EIO;
>> +                               goto do_error;
>> +                       }
>> +
>> +                       can_coalesce = skb_can_coalesce(skb, i, page, off);
>> +                       if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
>> +                               tcp_mark_push(tp, skb);
>> +                               iov_iter_revert(&msg->msg_iter, copy);
>> +                               goto new_segment;
>> +                       }
>> +                       if (tcp_downgrade_zcopy_pure(sk, skb)) {
>> +                               iov_iter_revert(&msg->msg_iter, copy);
>> +                               goto wait_for_space;
>> +                       }
>> +
>> +                       part = tcp_wmem_schedule(sk, copy);
>> +                       iov_iter_revert(&msg->msg_iter, copy - part);
>> +                       if (!part)
>> +                               goto wait_for_space;
>> +                       copy = part;
>> +
>> +                       if (can_coalesce) {
>> +                               skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
>> +                       } else {
>> +                               get_page(page);
>> +                               skb_fill_page_desc_noacc(skb, i, page, off, copy);
>> +                       }
>> +                       page = NULL;
>> +
>> +                       if (!(flags & MSG_NO_SHARED_FRAGS))
>> +                               skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
>> +
>> +                       skb->len += copy;
>> +                       skb->data_len += copy;
>> +                       skb->truesize += copy;
>> +                       sk_wmem_queued_add(sk, copy);
>> +                       sk_mem_charge(sk, copy);
>> +
> 
> Similar to udp, perhaps in a helper?

tcp_sendmsg_locked is already more than 250 lines long and this 47 lines
is compounding it. I was staring at this code 2 weeks ago wondering if
it can be split or refactored to reduce the complexity.
