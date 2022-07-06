Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB85A569131
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 19:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiGFRzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 13:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiGFRzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 13:55:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D6A237DF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 10:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58AA7B81E81
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2771C3411C;
        Wed,  6 Jul 2022 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657130143;
        bh=W0yKRrhEm+qwQBpG6zxsb0RsoAJU+MlShsysYu3UZnA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=SOid+wXfGEJZ+klRR7mxOHkyeoLH+LusQ2PG/wbxEPz7EUObhJA5LmmSAqb+nFkuk
         WYUabkPimZOcH8wgsK460StQjI36o9k8vMVcn4mnr2qewc7UG1Pj8Wd38vSrsjo1S0
         ZauwUiZRU5eNoB52UCAQsaucf565i/2QPXsOzY+5L9dONuPdc9jeakW5ZqQm6XqjaK
         525iFPVJNPHUJFyEA7oH09wgz9dXkt7a9Aj10h0X8+Kub1a3w0FYRnHFDr7mSOYg2Z
         F2uRKsiF3H9CnDpzgY/GCGvys5RLuwGoi/pq3Bt5UbV6/+vmsWn2Zm5FeOxDjgKI+G
         VHKCw5JsRuWLA==
Message-ID: <af40f817-e005-b7ee-9c10-c513fa36ac04@kernel.org>
Date:   Wed, 6 Jul 2022 11:55:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org
References: <20220627085219.GA9597@debian>
 <7be18dc0-4d2c-283d-eedb-123ab99197d3@kernel.org>
 <77c9a31ba08bcc472617c08c0542cd82f7959a58.camel@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <77c9a31ba08bcc472617c08c0542cd82f7959a58.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 10:21 AM, Paolo Abeni wrote:
> On Wed, 2022-07-06 at 09:14 -0600, David Ahern wrote:
>> On 6/27/22 2:52 AM, Richard Gobert wrote:
>>> The IP_UNICAST_IF socket option is used to set the outgoing interface for
>>> outbound packets.
>>> The IP_UNICAST_IF socket option was added as it was needed by the Wine
>>> project, since no other existing option (SO_BINDTODEVICE socket option,
>>> IP_PKTINFO socket option or the bind function) provided the needed
>>> characteristics needed by the IP_UNICAST_IF socket option. [1]
>>> The IP_UNICAST_IF socket option works well for unconnected sockets, that
>>> is, the interface specified by the IP_UNICAST_IF socket option is taken
>>> into consideration in the route lookup process when a packet is being
>>> sent.
>>> However, for connected sockets, the outbound interface is chosen when
>>> connecting the socket, and in the route lookup process which is done when
>>> a packet is being sent, the interface specified by the IP_UNICAST_IF
>>> socket option is being ignored.
>>>
>>> This inconsistent behavior was reported and discussed in an issue opened
>>> on systemd's GitHub project [2]. Also, a bug report was submitted in the
>>> kernel's bugzilla [3].
>>>
>>> To understand the problem in more detail, we can look at what happens
>>> for UDP packets over IPv4 (The same analysis was done separately in
>>> the referenced systemd issue).
>>> When a UDP packet is sent the udp_sendmsg function gets called and the
>>> following happens:
>>>
>>> 1. The oif member of the struct ipcm_cookie ipc (which stores the output
>>> interface of the packet) is initialized by the ipcm_init_sk function to
>>> inet->sk.sk_bound_dev_if (the device set by the SO_BINDTODEVICE socket
>>> option).
>>>
>>> 2. If the IP_PKTINFO socket option was set, the oif member gets overridden
>>> by the call to the ip_cmsg_send function.
>>>
>>> 3. If no output interface was selected yet, the interface specified by the
>>> IP_UNICAST_IF socket option is used.
>>>
>>> 4. If the socket is connected and no destination address is specified in
>>> the send function, the struct ipcm_cookie ipc is not taken into
>>> consideration and the cached route, that was calculated in the connect
>>> function is being used.
>>>
>>> Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken into
>>> consideration.
>>>
>>> This patch corrects the behavior of the IP_UNICAST_IF socket option for
>>> connect()ed sockets by taking into consideration the IP_UNICAST_IF sockopt
>>> when connecting the socket.
>>>
>>> In order to avoid reconnecting the socket, this option is still ignored 
>>> when applied on an already connected socket until connect() is called
>>> again by the user.
>>>
>>> Change the __ip4_datagram_connect function, which is called during socket
>>> connection, to take into consideration the interface set by the
>>> IP_UNICAST_IF socket option, in a similar way to what is done in the
>>> udp_sendmsg function.
>>>
>>> [1] https://lore.kernel.org/netdev/1328685717.4736.4.camel@edumazet-laptop/T/
>>> [2] https://github.com/systemd/systemd/issues/11935#issuecomment-618691018
>>> [3] https://bugzilla.kernel.org/show_bug.cgi?id=210255
>>>
>>> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
>>> ---
>>>  net/ipv4/datagram.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>
>> Reviewed-by: David Ahern <dsahern@kernel.org>
>>
>> if the maintainers decide to pick it up.
> 
> I think your reasoning is correct, and I'm now ok with the patch. Jakub
> noted it does not apply cleanly, so a repost will be needed.
> Additionally it would be great to include some self-tests.

Agreed. nettest.c has '-S' option that sets IP_UNICAST_IF after the
socket() call and before connect() so it is already doing what is wanted
by this patch. Just need positive and negative test cases added to
tools/testing/selftests/net.


> 
> It looks like the feature (even the original one, I mean) is IPv4
> specific, don't you need an IPv6 counter-part?
> 
> Thanks!
> 
> Paolo
> 

