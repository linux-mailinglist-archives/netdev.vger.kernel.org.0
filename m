Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E65261475
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbgIHQXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731754AbgIHQWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:22:12 -0400
X-Greylist: delayed 1958 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Sep 2020 06:33:35 PDT
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B84EC0611E0;
        Tue,  8 Sep 2020 06:33:35 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFdee-00075V-FO; Tue, 08 Sep 2020 15:27:24 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFdee-000498-6K; Tue, 08 Sep 2020 15:27:24 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Arturo Borrero Gonzalez <arturo@debian.org>,
        Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <0b7ca97e-9548-b0a8-cdd1-5200cb3b997d@debian.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9bef756d-d17e-263e-c018-2908f2626bfe@iogearbox.net>
Date:   Tue, 8 Sep 2020 15:27:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0b7ca97e-9548-b0a8-cdd1-5200cb3b997d@debian.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25923/Mon Sep  7 15:37:02 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 1:46 PM, Arturo Borrero Gonzalez wrote:
> On 2020-09-04 23:14, Daniel Borkmann wrote:
>> root@x:~/x# clang -target bpf -Wall -O2 -c foo.c -o foo.o
> 
> In my honest opinion (debian hat), the simplification of the stack is a key
> point for end users/developers. A gain in usability might justify a small
> performance penalty.

Not really, both are independent from each other. Usability is typically achieved
through abstractions, e.g. hiding complexity in libraries (think of raw syscalls
vs libc). Same with the example of bpf or any other kernel subsystem fwiw, users
don't need to be aware of the details as applications abstract this away entirely
but they can benefit from efficiency underneath nevertheless. One example is how
systemd implements cgroup-aware firewalling and accounting for its services via bpf
[0]. Zero knowledge required while it presents meta data in user friendly way via
systemctl status. I'm not trying to convince you of bpf (or systemd), just that
this argument is moot.

> I can think on both sysadmins and network apps developers, or even casual
> advanced users. For many people, dealing with the network stack is already
> challenging enough.

In the age of containers and distributed computing there is no such thing as
sysadmin anymore as we know it from our university days where a bunch of grey
bearded admins maintained a bunch of old sun boxes, printers, etc manually. ;-)
But yes, devops these days is complex, hence abstractions to improve usability
and gain introspection, but kernel is just a tiny fraction in the overall stack.

> Also, ideally, servers would be clean of the GCC or CLANG suites.

Yes agree, one can compile out all other backends (in case of clang at least) that
would generate executable code though.

   [0] http://0pointer.net/blog/ip-accounting-and-access-lists-with-systemd.html
