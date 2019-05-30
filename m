Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879A2304DC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfE3Wlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:41:39 -0400
Received: from mail1.ugh.no ([178.79.162.34]:48456 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbfE3Wlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 18:41:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id C373824C799;
        Fri, 31 May 2019 00:41:36 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at catastrophix.ugh.no
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B25G8W0Wd587; Fri, 31 May 2019 00:41:36 +0200 (CEST)
Received: from [10.255.96.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id 424FB24C792;
        Fri, 31 May 2019 00:41:36 +0200 (CEST)
Subject: Re: kTLS broken somewhere between 4.18 and 5.0
To:     John Fastabend <john.fastabend@gmail.com>,
        "Steinar H. Gunderson" <steinar+kernel@gunderson.no>,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
References: <20190413153435.73ecztpnbivrckvj@sesse.net>
 <4cdfca7f-bee0-56f5-e512-8ad2e4e6dfcf@tomt.net>
 <f832cd50-50c5-027c-51db-8a3a3ded4563@gmail.com>
 <a69bb5f9-45d2-354e-0422-e3d37d4e427d@tomt.net>
 <5cd19a06c0ec1_7e362b112aa185b8da@john-XPS-13-9360.notmuch>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <35b274ca-9e15-f1aa-4f40-f4eab592a721@tomt.net>
Date:   Fri, 31 May 2019 00:41:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5cd19a06c0ec1_7e362b112aa185b8da@john-XPS-13-9360.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.05.2019 16:45, John Fastabend wrote:
> Andre Tomt wrote:
>> On 14.04.2019 22:40, John Fastabend wrote:
>>> On 4/13/19 6:56 PM, Andre Tomt wrote:
>>>> On 13.04.2019 17:34, Steinar H. Gunderson wrote:
>>>>> Hi,
>>>>>
>>>>> I've been using kTLS for a while, with my video reflector Cubemap
>>>>> (https://git.sesse.net/?p=cubemap). After I upgraded my server from
>>>>> 4.18.11 to 5.0.6, seemingly I've started seeing corruption. The data sent
>>>>> with send() (HTTP headers, HLS playlists) appears to be fine, but sendfile()
>>>>> (actual video data, from a file on tmpfs) is not; after ~20 kB of data
>>>>> (19626 in one test here), the data appears to be randomly corrupted. Diffing
>>>>> non-TLS (good) and TLS (bad) video data:
> 
> [...]
> 
>> Hi John
>>
>> Have you had any luck tracking this down?
>>
>> Just gave net.git a spin and it is still serving up corrupted data when
>> ktls is active and using sendfile.  FWIW I only tested without ktls
>> offload capable hardware (ie in software mode) and no bpf. Same sendfile
>> usage on a non-ktls socket works fine.
> 
> Hi Andre, I should have a series to address this in the next few days. I
> still need to resolve a couple corner cases. Hopefully, by next week we
> can get bpf tree working for this case.

current linus master, net.git master and bpf.git master are all still 
not working right, so I took a closer look.

It seems to only happen if sendfile writes more than a maximum tls 
record size worth of data. If I clamp the sendfile calls to 16384 bytes 
at a time everything works fine.

Not sure if sendfile triggers record splitting, but could that be what 
is broken? The bisected commit does touch that part quite extensively.

I made a fest input that just repeats 0-9 a-z 10 times for each 
character in a loop and got the following corruption post-decryption:

> 00004f74: 6969 6969 6969 6969 6969  iiiiiiiiii
> 00004f7e: 6a6a 6a6a 6a6a 6a6a 6a6a  jjjjjjjjjj
> 00004f88: 6b6b 6b6b 6b6b 6b6b 6b6b  kkkkkkkkkk
> 00004f92: 6c6c 6c6c 6c6c 6c6c 6c6c  llllllllll
> 00004f9c: 6d6d 6d6d 6d6d 6d6d 6d6d  mmmmmmmmmm
> 00004fa6: 6e6e 6e6e 6e6e 6e6e 6e6e  nnnnnnnnnn
> 00004fb0: 6f6f 6f6f 6f6f 6f6f 6f6f  oooooooooo
> 00004fba: 7070 7070 7070 7070 7070  pppppppppp
> 00004fc4: 7171 7171 7171 7171 7171  qqqqqqqqqq
> 00004fce: 7272 6d6d 6d6d 6d6d 6e6e  rrmmmmmmnn <- uh oh, goes backwards?
> 00004fd8: 6e6e 6e6e 6e6e 6e6e 6f6f  nnnnnnnnoo
> 00004fe2: 6f6f 6f6f 6f6f 6f6f 7070  oooooooopp
> 00004fec: 7070 7070 7070 7070 7171  ppppppppqq
> 00004ff6: 7171 7171 7171 7171 7272  qqqqqqqqrr
> 00005000: 7272 7272 7272 7272 7373  rrrrrrrrss
> 0000500a: 7373 7373 7373 7373 7474  sssssssstt
> 00005014: 7474 7474 7474 7474 7575  ttttttttuu
> 0000501e: 7575 7575 7575 7575 7676  uuuuuuuuvv
> 00005028: 7676 7676 7676 7676 7777  vvvvvvvvww
