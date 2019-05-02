Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B38D11B0F
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 16:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEBOPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 10:15:23 -0400
Received: from mail1.ugh.no ([178.79.162.34]:36906 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfEBOPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 10:15:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 1114724C2BB;
        Thu,  2 May 2019 16:15:20 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at catastrophix.ugh.no
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Pyo6OS9mcKor; Thu,  2 May 2019 16:15:19 +0200 (CEST)
Received: from [10.255.96.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id 8BC9224C2B9;
        Thu,  2 May 2019 16:15:19 +0200 (CEST)
Subject: Re: kTLS broken somewhere between 4.18 and 5.0
To:     John Fastabend <john.fastabend@gmail.com>,
        "Steinar H. Gunderson" <steinar+kernel@gunderson.no>,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
References: <20190413153435.73ecztpnbivrckvj@sesse.net>
 <4cdfca7f-bee0-56f5-e512-8ad2e4e6dfcf@tomt.net>
 <f832cd50-50c5-027c-51db-8a3a3ded4563@gmail.com>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <a69bb5f9-45d2-354e-0422-e3d37d4e427d@tomt.net>
Date:   Thu, 2 May 2019 16:15:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f832cd50-50c5-027c-51db-8a3a3ded4563@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.04.2019 22:40, John Fastabend wrote:
> On 4/13/19 6:56 PM, Andre Tomt wrote:
>> On 13.04.2019 17:34, Steinar H. Gunderson wrote:
>>> Hi,
>>>
>>> I've been using kTLS for a while, with my video reflector Cubemap
>>> (https://git.sesse.net/?p=cubemap). After I upgraded my server from
>>> 4.18.11 to 5.0.6, seemingly I've started seeing corruption. The data sent
>>> with send() (HTTP headers, HLS playlists) appears to be fine, but sendfile()
>>> (actual video data, from a file on tmpfs) is not; after ~20 kB of data
>>> (19626 in one test here), the data appears to be randomly corrupted. Diffing
>>> non-TLS (good) and TLS (bad) video data:
>>>
>>>     00004c70: fa 70 c5 71 b5 f5 b7 ac 74 b0 ca 80 02 4c 06 3f  .p.q....t....L.?
>>>     00004c80: 5c 5b 0c b3 e0 a0 c3 21 93 d3 6e 65 36 70 0a 27  \[.....!..ne6p.'
>>>     00004c90: 84 67 16 2c 95 c0 55 e1 04 76 52 10 50 5d 00 26  .g.,..U..vR.P].&
>>>
>>>    -00004ca0: 0c b8 84 70 7e ed 12 8f 5e 7e 18 c0 06 20 02 54  ...p~...^~... .T
>>>    +00004ca0: 0c b8 84 70 7e ed 12 8f 5e 7e 0a 60 9f 1f 97 f2  ...p~...^~.`....
>>>
>>>    -00004cb0: 1e 4c c1 71 7d 0b 91 28 23 98 09 ae c4 95 ae 7f  .L.q}..(#.......
>>>    +00004cb0: 6e 17 50 03 67 fa 2f 83 b0 88 eb fc 54 f2 0b 00  n.P.g./.....T...
>>>
>>>    -00004cc0: a2 92 20 b8 f2 b6 72 2a e8 7e d7 27 99 65 56 70  .. ...r*.~.'.eVp
>>>    +00004cc0: 6c 9e a1 02 b4 30 11 25 d7 58 b0 0c c0 6c e1 bd  l....0.%.X...l..
>>>
>>> It never appears to get back into sync after that. Interestingly, it is
>>> _consistently_ wrong; if I download the same fragment multiple times, it
>>> breaks at the same place and gives the same garbage (but different fragments
>>> give different divergence points). Tested with both wget and Chrome.
>>> Does anyone know what could be wrong?
>>>
>>> (It is, unfortunately, not easy for me to reboot this server at will, so a
>>> bisect could be hard.)
>>>
>>> Please Cc me on any replies, I'm not subscribed to netdev.
>>>
>>> /* Steinar */
>>>
>>
>>
>> Reproduced and bisected, the problem showed up in v4.20-rc1. Unfortunately the commit seems to have some significant dependencies so I was unable to verify by reverting it on 4.20.
>>
> 
> 
> Hi thanks I'll take a look this evening or first thing tomorrow. I have
> a couple other fixes queued up for ktls as well so I'll see if we can get
> a fix for this included in that series.
> 
> Thanks!
> John

Hi John

Have you had any luck tracking this down?

Just gave net.git a spin and it is still serving up corrupted data when 
ktls is active and using sendfile.  FWIW I only tested without ktls 
offload capable hardware (ie in software mode) and no bpf. Same sendfile 
usage on a non-ktls socket works fine.
