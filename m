Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F74028429C
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgJEWj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:39:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:39058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgJEWj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 18:39:59 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kPZ9A-00045G-TJ; Tue, 06 Oct 2020 00:39:56 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kPZ9A-000CCM-Lj; Tue, 06 Oct 2020 00:39:56 +0200
Subject: Re: [PATCH v2 bpf-next] bpf: use raw_spin_trylock() for
 pcpu_freelist_push/pop in NMI
To:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, john.fastabend@gmail.com, kpsingh@chromium.org
References: <20201005165838.3735218-1-songliubraving@fb.com>
 <20201005180346.gs2iznki5jnslqqp@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f4101546-210e-c63c-2190-73ba9bae19a4@iogearbox.net>
Date:   Tue, 6 Oct 2020 00:39:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201005180346.gs2iznki5jnslqqp@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25948/Mon Oct  5 16:02:22 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/20 8:03 PM, Martin KaFai Lau wrote:
> On Mon, Oct 05, 2020 at 09:58:38AM -0700, Song Liu wrote:
[...]
>> non-NMI pop(): 	use _lock(); check per cpu lists first;
>>                  if all per cpu lists are empty, check extralist;
>>                  if extralist is empty, return NULL.
>>
>> non-NMI push(): use _lock(); only push to per cpu lists.
>>
>> NMI pop():    use _trylock(); check per cpu lists first;
>>                if all per cpu lists are locked or empty, check extralist;
>>                if extralist is locked or empty, return NULL.
>>
>> NMI push():   use _trylock(); check per cpu lists first;
>>                if all per cpu lists are locked; try push to extralist;
>>                if extralist is also locked, keep trying on per cpu lists.
>>
>> Reported-by: Alexei Starovoitov <ast@kernel.org>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>
>> ---
>> Changes v1 => v2:
>> 1. Update commit log. (Daniel)
> Acked-by: Martin KaFai Lau <kafai@fb.com>

LGTM, applied, thanks!
