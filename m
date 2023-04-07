Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879EF6DA7D1
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbjDGCqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239956AbjDGCqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0F586B9;
        Thu,  6 Apr 2023 19:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AF74649C7;
        Fri,  7 Apr 2023 02:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D3BC433EF;
        Fri,  7 Apr 2023 02:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680835599;
        bh=z5raEhmwE/FPqsbIHeHBjLdFu5XYEI5PD+vRQ68Ne5o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MfOo5PBrJYHuTa/yG7BB0n1I3I9sUOu9Y6dWTjcbxtOZtXsNAXjpG74O5NrjaA+1/
         Iih0i1zeEK1PLmsUS70CkXSeww/TGnH2MovprKGwb34L9nYc3ud+xHHFVpTsePdh9p
         QYd5n+cEpHyWH6/YgCSI+6AhJiYNxOa+Kjjbl7mMgBset7cwzOH4ttHzb7D7eySjh3
         lKGc0KvKf+oiaT9kTGd/6qyMQUYhp+QXRYUjDYndZFwfbUioa9oJM+3/y2fKE0DAu4
         gRZ6Mifp3mWco0V5QN37mVrqYwBOxhr/zlcneXraaHKKZtN+VPoo5G8MvoDDEPHcA1
         nntgo5i4qxqnA==
Message-ID: <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
Date:   Thu, 6 Apr 2023 20:46:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Willem de Bruijn <willemb@google.com>,
        Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
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

On 4/6/23 12:16 PM, Willem de Bruijn wrote:
> On Thu, Apr 6, 2023 at 11:59 AM Breno Leitao <leitao@debian.org> wrote:
>>
>> On Thu, Apr 06, 2023 at 11:34:28AM -0400, Willem de Bruijn wrote:
>>> On Thu, Apr 6, 2023 at 10:45 AM Breno Leitao <leitao@debian.org> wrote:
>>>>
>>>> From: Breno Leitao <leit@fb.com>
>>>>
>>>> This patchset creates the initial plumbing for a io_uring command for
>>>> sockets.
>>>>
>>>> For now, create two uring commands for sockets, SOCKET_URING_OP_SIOCOUTQ
>>>> and SOCKET_URING_OP_SIOCINQ. They are similar to ioctl operations
>>>> SIOCOUTQ and SIOCINQ. In fact, the code on the protocol side itself is
>>>> heavily based on the ioctl operations.
>>>
>>> This duplicates all the existing ioctl logic of each protocol.
>>>
>>> Can this just call the existing proto_ops.ioctl internally and translate from/to
>>> io_uring format as needed?
>>
>> This is doable, and we have two options in this case:
>>
>> 1) Create a ioctl core function that does not call `put_user()`, and
>> call it from both the `udp_ioctl` and `udp_uring_cmd`, doing the proper
>> translations. Something as:
>>
>>         int udp_ioctl_core(struct sock *sk, int cmd, unsigned long arg)
>>         {
>>                 int amount;
>>                 switch (cmd) {
>>                 case SIOCOUTQ: {
>>                         amount = sk_wmem_alloc_get(sk);
>>                         break;
>>                 }
>>                 case SIOCINQ: {
>>                         amount = max_t(int, 0, first_packet_length(sk));
>>                         break;
>>                 }
>>                 default:
>>                         return -ENOIOCTLCMD;
>>                 }
>>                 return amount;
>>         }
>>
>>         int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>>         {
>>                 int amount = udp_ioctl_core(sk, cmd, arg);
>>
>>                 return put_user(amount, (int __user *)arg);
>>         }
>>         EXPORT_SYMBOL(udp_ioctl);
>>
>>
>> 2) Create a function for each "case entry". This seems a bit silly for
>> UDP, but it makes more sense for other protocols. The code will look
>> something like:
>>
>>          int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>>          {
>>                 switch (cmd) {
>>                 case SIOCOUTQ:
>>                 {
>>                         int amount = udp_ioctl_siocoutq();
>>                         return put_user(amount, (int __user *)arg);
>>                 }
>>                 ...
>>           }
>>
>> What is the best approach?
> 
> A, the issue is that sock->ops->ioctl directly call put_user.
> 
> I was thinking just having sock_uring_cmd call sock->ops->ioctl, like
> sock_do_ioctl.
> 
> But that would require those callbacks to return a negative error or
> positive integer, rather than calling put_user. And then move the
> put_user to sock_do_ioctl. Such a change is at least as much code
> change as your series. Though without the ending up with code
> duplication. It also works only if all ioctls only put_user of integer
> size. That's true for TCP, UDP and RAW, but not sure if true more
> broadly.
> 
> Another approach may be to pass another argument to the ioctl
> callbacks, whether to call put_user or return the integer and let the
> caller take care of the output to user. This could possibly be
> embedded in the a high-order bit of the cmd, so that it fails on ioctl
> callbacks that do not support this mode.
> 
> Of the two approaches you suggest, I find the first preferable.

The first approach sounds better to me and it would be good to avoid
io_uring details in the networking code (ie., cmd->sqe->cmd_op).
