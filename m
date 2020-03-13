Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D290E1851B0
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCMWfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:35:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:42446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCMWfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:35:18 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCstf-0002du-7h; Fri, 13 Mar 2020 23:35:15 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCste-000QQu-Vn; Fri, 13 Mar 2020 23:35:15 +0100
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Fix spurious failures in
 accept due to EAGAIN
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
References: <20200313161049.677700-1-jakub@cloudflare.com>
 <CAEf4Bza493cXh+ffS7KHtgGnVDYwyxwDXQ_G6Ps1Bfm4WVRLQA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <22e262a7-d7e7-f020-f98b-55d7512660f5@iogearbox.net>
Date:   Fri, 13 Mar 2020 23:35:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza493cXh+ffS7KHtgGnVDYwyxwDXQ_G6Ps1Bfm4WVRLQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25750/Fri Mar 13 14:03:09 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/20 8:01 PM, Andrii Nakryiko wrote:
> On Fri, Mar 13, 2020 at 9:10 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> Andrii Nakryiko reports that sockmap_listen test suite is frequently
>> failing due to accept() calls erroring out with EAGAIN:
>>
>>    ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
>>    connect_accept_thread:FAIL:733
>>
>> This is because we are using a non-blocking listening TCP socket to
>> accept() connections without polling on the socket.
>>
>> While at first switching to blocking mode seems like the right thing to do,
>> this could lead to test process blocking indefinitely in face of a network
>> issue, like loopback interface being down, as Andrii pointed out.
>>
>> Hence, stick to non-blocking mode for TCP listening sockets but with
>> polling for incoming connection for a limited time before giving up.
>>
>> Apply this approach to all socket I/O calls in the test suite that we
>> expect to block indefinitely, that is accept() for TCP and recv() for UDP.
>>
>> Fixes: 44d28be2b8d4 ("selftests/bpf: Tests for sockmap/sockhash holding listening sockets")
>> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> This looks good. Unfortunately can't repro the issue locally anymore.
> But once this gets into bpf-next and we update libbpf in Github, I'll
> enable sockmap_listen tests again and see if it's still flaky. Thanks
> for following up!

Ok, applied, thanks!
