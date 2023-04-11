Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7356DDF19
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjDKPLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjDKPKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:10:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662AC59ED;
        Tue, 11 Apr 2023 08:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010F062835;
        Tue, 11 Apr 2023 15:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7478C4339B;
        Tue, 11 Apr 2023 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681225834;
        bh=DJwe6UzJsaev9ajZujQ5NHkfDfsVI0n/WkKr9BI449U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DzE+Q4O7O00+JC7HVvTuKE+IE498IDbddKmq9X9Euwh1PTxJ7PhyxRkZblRxsU1fI
         GpEiJce7E4J1DQRSyckcpAErj9AxAKoGoCfGxxpvdQRLeiM64Vf0ZxmwIQLkZHQ6ZJ
         egPKxdTUZZgKlMr50LZFM3QUOugoZYHPqt7YJ+y+VuyNzPotdX4CYAbVwl+UKv6sjM
         JtNgX4swzADyQR7yARHl3sicy224kzDIqvhuvMwZwgGUaLEMAAI4WrmnLIAO4X04uy
         +3Tn3wftfpcyiBbQKj6Q6LSVDqO+DtZWCjuPOSY3F6GvyRXyHizLBH/dz7+vTsIkMc
         8pvziXG0GEUPg==
Message-ID: <ea36790d-b2fe-0b4d-1bfc-be7b20b1614b@kernel.org>
Date:   Tue, 11 Apr 2023 09:10:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 8:41 AM, Jens Axboe wrote:
> On 4/11/23 8:36?AM, David Ahern wrote:
>> On 4/11/23 6:00 AM, Breno Leitao wrote:
>>> I am not sure if avoiding io_uring details in network code is possible.
>>>
>>> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
>>> in the TCP case) could be somewhere else, such as in the io_uring/
>>> directory, but, I think it might be cleaner if these implementations are
>>> closer to function assignment (in the network subsystem).
>>>
>>> And this function (tcp_uring_cmd() for instance) is the one that I am
>>> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
>>> -> SIOCINQ.
>>>
>>> Please let me know if you have any other idea in mind.
>>
>> I am not convinced that this io_uring_cmd is needed. This is one
>> in-kernel subsystem calling into another, and there are APIs for that.
>> All of this set is ioctl based and as Willem noted a little refactoring
>> separates the get_user/put_user out so that in-kernel can call can be
>> made with existing ops.
> 
> How do you want to wire it up then? We can't use fops->unlocked_ioctl()
> obviously, and we already have ->uring_cmd() for this purpose.
> 
> I do think the right thing to do is have a common helper that returns
> whatever value you want (or sets it), and split the ioctl parts into a
> wrapper around that that simply copies in/out as needed. Then
> ->uring_cmd() could call that, or you could some exported function that
> does supports that.
> 
> This works for the basic cases, though I do suspect we'll want to go
> down the ->uring_cmd() at some point for more advanced cases or cases
> that cannot sanely be done in an ioctl fashion.
> 

My meta point is that there are uapis today to return this information
to applications (and I suspect this is just the start of more networking
changes - both data retrieval and adjusting settings). io_uring is
wanting to do this on behalf of the application without a syscall. That
makes io_uring yet another subsystem / component managing a socket. Any
change to the networking stack required by io_uring should be usable by
all other in-kernel socket owners or managers. ie., there is no reason
for io_uring specific code here.

