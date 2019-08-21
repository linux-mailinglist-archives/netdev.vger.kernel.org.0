Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 028BF97A5D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfHUNIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:08:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:59590 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfHUNIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 09:08:54 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0QM7-0001Gd-DP; Wed, 21 Aug 2019 15:08:51 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0QM7-000FW4-7Z; Wed, 21 Aug 2019 15:08:51 +0200
Subject: Re: [PATCH bpf-next 2/2] tools: bpftool: add "bpftool map freeze"
 subcommand
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190821085219.30387-1-quentin.monnet@netronome.com>
 <20190821085219.30387-3-quentin.monnet@netronome.com>
 <b44cf34c-b6d5-a3f5-f386-e70791e47229@iogearbox.net>
 <2b6d7326-fc74-288b-fa52-b79752222123@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <397a7685-be48-65ab-1120-bfd0f4b08a02@iogearbox.net>
Date:   Wed, 21 Aug 2019 15:08:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2b6d7326-fc74-288b-fa52-b79752222123@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25548/Wed Aug 21 10:27:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/19 2:58 PM, Quentin Monnet wrote:
> 2019-08-21 13:40 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
>> On 8/21/19 10:52 AM, Quentin Monnet wrote:
>>> Add a new subcommand to freeze maps from user space.
>>>
>>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>> ---
>>>    .../bpf/bpftool/Documentation/bpftool-map.rst |  9 +++++
>>>    tools/bpf/bpftool/bash-completion/bpftool     |  4 +--
>>>    tools/bpf/bpftool/map.c                       | 34 ++++++++++++++++++-
>>>    3 files changed, 44 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst
>>> b/tools/bpf/bpftool/Documentation/bpftool-map.rst
>>> index 61d1d270eb5e..1c0f7146aab0 100644
>>> --- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
>>> +++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
>>> @@ -36,6 +36,7 @@ MAP COMMANDS
>>>    |    **bpftool** **map pop**        *MAP*
>>>    |    **bpftool** **map enqueue**    *MAP* **value** *VALUE*
>>>    |    **bpftool** **map dequeue**    *MAP*
>>> +|    **bpftool** **map freeze**     *MAP*
>>>    |    **bpftool** **map help**
>>>    |
>>>    |    *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
>>> @@ -127,6 +128,14 @@ DESCRIPTION
>>>        **bpftool map dequeue**  *MAP*
>>>              Dequeue and print **value** from the queue.
>>>    +    **bpftool map freeze**  *MAP*
>>> +          Freeze the map as read-only from user space. Entries from a
>>> +          frozen map can not longer be updated or deleted with the
>>> +          **bpf\ ()** system call. This operation is not reversible,
>>> +          and the map remains immutable from user space until its
>>> +          destruction. However, read and write permissions for BPF
>>> +          programs to the map remain unchanged.
>>
>> That is not correct, programs that are loaded into the system /after/
>> the map
>> has been frozen cannot modify values either, thus read-only from both
>> sides.
> 
> Are you entirely sure about it? I could not find the relevant
> restriction in the code, the checks seem to be on map flags
> (BPF_F_RDONLY) which do not seem to be modified by the "frozen" status
> in map_freeze()? And tests I ran on my side seem to indicate the map can
> still be updated by new programs. Did I miss something?
> 
> Tested on 5.3.0-rc1:
> 
> 1. Create hash map
> 2. Load BPF program foo, using map
> 3. Test-run program foo - map is updated
> 4. Freeze map - update effectively becomes impossible from user space
> 5. Load BPF program bar, using same map
> 6. Test-run program bar - map is still updated

Looks like I need some more coffee. ;-) Indeed, the program side was via
BPF_F_RDONLY_PROG flag.
