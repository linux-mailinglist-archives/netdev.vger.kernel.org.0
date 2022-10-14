Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68745FF246
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiJNQbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiJNQbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:31:18 -0400
Received: from mail.codeweavers.com (mail.codeweavers.com [65.103.31.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE201D2F68;
        Fri, 14 Oct 2022 09:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codeweavers.com; s=6377696661; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VSDYHnT32iCl0O9dttAG/XvqaQdcz9am927nG9WKioY=; b=idwzH+L9nJVkg+HSkFdaQq2Yup
        kFtSIdWj4n1vzFI+EkWoE7GLbdzvhpRXamlqtKzNwktLFkLjBTrsTx8W3Kvj9m9/8WRlrGQKgeRL2
        Q8iWKgFiJYo+xRoBdhzb7wo0N6MOehhUh9qKAK93q3bm1LI5VM2ktzvKoB+D5enz9X/4=;
Received: from cw141ip123.vpn.codeweavers.com ([10.69.141.123])
        by mail.codeweavers.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <pgofman@codeweavers.com>)
        id 1ojNac-00G8Mx-Om; Fri, 14 Oct 2022 11:31:15 -0500
Message-ID: <81b0e6c9-6c13-aecd-1e0e-6417eb89285f@codeweavers.com>
Date:   Fri, 14 Oct 2022 11:31:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com>
 <CANn89iLOdgExV3ydkg0r2iNwavSp5Zu9hskf34TTqmCZQCfUdA@mail.gmail.com>
 <5db967de-ea7e-9f35-cd74-d4cca2fcb9ee@codeweavers.com>
 <CANn89iJTNUCDLptS_rV4JUDcEH8JNXvOTx4xgzvaDHG6eodtXg@mail.gmail.com>
From:   Paul Gofman <pgofman@codeweavers.com>
In-Reply-To: <CANn89iJTNUCDLptS_rV4JUDcEH8JNXvOTx4xgzvaDHG6eodtXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

     that message was not mine.

     Speaking from the Wine side, we cannot workaround that with 
SO_REUSEADDR. First of all, it is under app control and we can't 
voluntary tweak app's socket settings. Then, app might be intentionally 
not using SO_REUSEADDR to prevent port reuse which of course may be 
harmful (more harmful than failure to restart for another minute). What 
is broken with the application which doesn't want to use SO_REUSEADDR 
and wants to disallow port reuse while it binds to it which reuse will 
surely break it?

     But my present question about the listening socket being not 
reusable while closed due to linked accepeted socket was not related to 
Wine at all. I am not sure how one can fix that in the application if 
they don't really want other applications or another copy of the same 
one to be able to reuse the port they currently bind to? I believe the 
issue with listen socket been not available happens rather often for 
native services and they all have to workaround that. While not related 
here, I also encountered some out-of-tree hacks to tweak the TIME_WAIT 
timeout to tackle this very problem for some cloud custom kernels.

     My question is if the behaviour of blocking listen socket port 
while the accepted port (which, as I understand, does not have any 
direct relation to listen port anymore from TCP standpoint) is still in 
TIME_ or other wait is stipulated by TCP requirements which I am 
missing? Or, if not, maybe that can be changed?

Thanks,
     Paul.


On 10/14/22 11:20, Eric Dumazet wrote:
> On Fri, Oct 14, 2022 at 8:52 AM Paul Gofman <pgofman@codeweavers.com> wrote:
>> Hello Eric,
>>
>> our problem is actually not with the accept socket / port for which
>> those timeouts apply, we don't care for that temporary port number. The
>> problem is that the listen port (to which apps bind explicitly) is also
>> busy until the accept socket waits through all the necessary timeouts
>> and is fully closed. From my reading of TCP specs I don't understand why
>> it should be this way. The TCP hazards stipulating those timeouts seem
>> to apply to accept (connection) socket / port only. Shouldn't listen
>> socket's port (the only one we care about) be available for bind
>> immediately after the app stops listening on it (either due to closing
>> the listen socket or process force kill), or maybe have some other
>> timeouts not related to connected accept socket / port hazards? Or am I
>> missing something why it should be the way it is done now?
>>
>
> To quote your initial message :
>
> <quote>
> We are able to avoid this error by adding SO_REUSEADDR attribute to the
> socket in a hack. But this hack cannot be added to the application
> process as we don't own it.
> </quote>
>
> Essentially you are complaining of the linux kernel being unable to
> run a buggy application.
>
> We are not going to change the linux kernel because you can not
> fix/recompile an application.
>
> Note that you could use LD_PRELOAD, or maybe eBPF to automatically
> turn SO_REUSEADDR before bind()
>
>
>> Thanks,
>>       Paul.
>>
>>
>> On 9/30/22 10:16, Eric Dumazet wrote:
>>> On Fri, Sep 30, 2022 at 6:24 AM Muhammad Usama Anjum
>>> <usama.anjum@collabora.com> wrote:
>>>> Hi Eric,
>>>>
>>>> RFC 1337 describes the TIME-WAIT Assassination Hazards in TCP. Because
>>>> of this hazard we have 60 seconds timeout in TIME_WAIT state if
>>>> connection isn't closed properly. From RFC 1337:
>>>>> The TIME-WAIT delay allows all old duplicate segments time
>>>> enough to die in the Internet before the connection is reopened.
>>>>
>>>> As on localhost there is virtually no delay. I think the TIME-WAIT delay
>>>> must be zero for localhost connections. I'm no expert here. On localhost
>>>> there is no delay. So why should we wait for 60 seconds to mitigate a
>>>> hazard which isn't there?
>>> Because we do not specialize TCP stack for loopback.
>>>
>>> It is easy to force delays even for loopback (tc qdisc add dev lo root
>>> netem ...)
>>>
>>> You can avoid TCP complexity (cpu costs) over loopback using AF_UNIX instead.
>>>
>>> TIME_WAIT sockets are optional.
>>> If you do not like them, simply set /proc/sys/net/ipv4/tcp_max_tw_buckets to 0 ?
>>>
>>>> Zapping the sockets in TIME_WAIT and FIN_WAIT_2 does removes them. But
>>>> zap is required from privileged (CAP_NET_ADMIN) process. We are having
>>>> hard time finding a privileged process to do this.
>>> Really, we are not going to add kludges in TCP stacks because of this reason.
>>>
>>>> Thanks,
>>>> Usama
>>>>
>>>>
>>>> On 5/24/22 1:18 PM, Muhammad Usama Anjum wrote:
>>>>> Hello,
>>>>>
>>>>> We have a set of processes which talk with each other through a local
>>>>> TCP socket. If the process(es) are killed (through SIGKILL) and
>>>>> restarted at once, the bind() fails with EADDRINUSE error. This error
>>>>> only appears if application is restarted at once without waiting for 60
>>>>> seconds or more. It seems that there is some timeout of 60 seconds for
>>>>> which the previous TCP connection remains alive waiting to get closed
>>>>> completely. In that duration if we try to connect again, we get the error.
>>>>>
>>>>> We are able to avoid this error by adding SO_REUSEADDR attribute to the
>>>>> socket in a hack. But this hack cannot be added to the application
>>>>> process as we don't own it.
>>>>>
>>>>> I've looked at the TCP connection states after killing processes in
>>>>> different ways. The TCP connection ends up in 2 different states with
>>>>> timeouts:
>>>>>
>>>>> (1) Timeout associated with FIN_WAIT_1 state which is set through
>>>>> `tcp_fin_timeout` in procfs (60 seconds by default)
>>>>>
>>>>> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
>>>>> seems like this timeout has come from RFC 1337.
>>>>>
>>>>> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
>>>>> also doesn't seem feasible to change the timeout of TIME_WAIT state as
>>>>> the RFC mentions several hazards. But we are talking about a local TCP
>>>>> connection where maybe those hazards aren't applicable directly? Is it
>>>>> possible to change timeout for TIME_WAIT state for only local
>>>>> connections without any hazards?
>>>>>
>>>>> We have tested a hack where we replace timeout of TIME_WAIT state from a
>>>>> value in procfs for local connections. This solves our problem and
>>>>> application starts to work without any modifications to it.
>>>>>
>>>>> The question is that what can be the best possible solution here? Any
>>>>> thoughts will be very helpful.
>>>>>
>>>>> Regards,
>>>>>
>>>> --
>>>> Muhammad Usama Anjum
>>

