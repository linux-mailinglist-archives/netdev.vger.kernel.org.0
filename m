Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7AD3B4252
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 13:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFYLSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 07:18:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:53788 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhFYLSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 07:18:52 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwjoz-0000r7-8Z; Fri, 25 Jun 2021 13:16:29 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwjoz-0005f1-2J; Fri, 25 Jun 2021 13:16:29 +0200
Subject: Re: [PATCH bpf] net/bpfilter: specify the log level for the kmsg
 message
To:     Dmitrii Banshchikov <me@ubique.spb.ru>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Gary Lin <glin@suse.com>, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Loviska <mloviska@suse.com>
References: <20210623040918.8683-1-glin@suse.com>
 <CAADnVQLpN993VpnPkTUxXpBMZtS6+h4CVruH33zbw-BLWj41-A@mail.gmail.com>
 <20210623065744.igawwy424y2zy26t@amnesia>
 <CAADnVQK2uQ3MvwaRztMtcw8SJz1r213hxA+vM2dCtr6RfpZnSA@mail.gmail.com>
 <20210625073621.zmd2w33wi335lya3@amnesia>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e978b7f1-a9c4-9b60-06cf-318b2144cf77@iogearbox.net>
Date:   Fri, 25 Jun 2021 13:16:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210625073621.zmd2w33wi335lya3@amnesia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26211/Thu Jun 24 13:04:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/21 9:36 AM, Dmitrii Banshchikov wrote:
> On Thu, Jun 24, 2021 at 08:47:06PM -0700, Alexei Starovoitov wrote:
>> On Tue, Jun 22, 2021 at 11:57 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>>> On Tue, Jun 22, 2021 at 09:38:38PM -0700, Alexei Starovoitov wrote:
>>>> On Tue, Jun 22, 2021 at 9:09 PM Gary Lin <glin@suse.com> wrote:
>>>>>
>>>>> Per the kmsg document(*), if we don't specify the log level with a
>>>>> prefix "<N>" in the message string, the default log level will be
>>>>> applied to the message. Since the default level could be warning(4),
>>>>> this would make the log utility such as journalctl treat the message,
>>>>> "Started bpfilter", as a warning. To avoid confusion, this commit adds
>>>>> the prefix "<5>" to make the message always a notice.
>>>>>
>>>>> (*) https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg
>>>>>
>>>>> Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
>>>>> Reported-by: Martin Loviska <mloviska@suse.com>
>>>>> Signed-off-by: Gary Lin <glin@suse.com>
>>>>> ---
>>>>>   net/bpfilter/main.c | 2 +-
>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
>>>>> index 05e1cfc1e5cd..291a92546246 100644
>>>>> --- a/net/bpfilter/main.c
>>>>> +++ b/net/bpfilter/main.c
>>>>> @@ -57,7 +57,7 @@ int main(void)
>>>>>   {
>>>>>          debug_f = fopen("/dev/kmsg", "w");
>>>>>          setvbuf(debug_f, 0, _IOLBF, 0);
>>>>> -       fprintf(debug_f, "Started bpfilter\n");
>>>>> +       fprintf(debug_f, "<5>Started bpfilter\n");
>>>>>          loop();
>>>>>          fclose(debug_f);
>>>>>          return 0;
>>>>
>>>> Adding Dmitrii who is redesigning the whole bpfilter.
>>>
>>> Thanks. The same logic already exists in the bpfilter v1 patchset
>>> - [1].
>>>
>>> 1. https://lore.kernel.org/bpf/c72bac57-84a0-ac4c-8bd8-08758715118e@fb.com/T/#mb36e20c4e5e4a70746bd50a109b1630687990214
>>
>> Dmitrii,
>>
>> what do you prefer we should do with this patch then?
> 
> There was an explicit request to make an event of loading a UMH
> visible - [1]. Given that the default for MaxLevelConsole is info
> and the patch makes the behavior slightly more accurate - ack
> from me.

Ok, sounds good, applied, thanks!
