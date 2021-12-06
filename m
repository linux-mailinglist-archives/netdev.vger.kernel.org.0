Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C87469AB7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347910AbhLFPJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:09:44 -0500
Received: from www62.your-server.de ([213.133.104.62]:59714 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346843AbhLFPHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:07:43 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1muFXJ-000Deo-4Y; Mon, 06 Dec 2021 16:04:13 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1muFXI-000WcB-Tk; Mon, 06 Dec 2021 16:04:12 +0100
Subject: Re: [PATCH v3 net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <cover.1638189075.git.pabeni@redhat.com>
 <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
 <1ac2941f-b751-9cf0-f0e3-ea0f245b7503@iogearbox.net>
 <70c5f1a6ecdc67586d108ab5ebed4be6febf8423.camel@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1685fbab-e4e1-5116-5148-fa7cd8f5879b@iogearbox.net>
Date:   Mon, 6 Dec 2021 16:04:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <70c5f1a6ecdc67586d108ab5ebed4be6febf8423.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26375/Mon Dec  6 10:22:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 11:20 AM, Paolo Abeni wrote:
> On Fri, 2021-12-03 at 23:04 +0100, Daniel Borkmann wrote:
>> Hi Paolo,
>>
>> Changes look good to me as well, we can route the series via bpf-next after tree
>> resync, or alternatively ask David/Jakub to take it directly into net-next with our
>> Ack given in bpf-next there is no drivers/net/ethernet/microsoft/mana/mana_bpf.c yet.
>>
>> On 11/30/21 11:08 AM, Paolo Abeni wrote:
>> [...]> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index 5631acf3f10c..392838fa7652 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -8181,13 +8181,13 @@ static bool xdp_is_valid_access(int off, int size,
>>>    	return __is_valid_xdp_access(off, size);
>>>    }
>>>    
>>> -void bpf_warn_invalid_xdp_action(u32 act)
>>> +void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
>>>    {
>>>    	const u32 act_max = XDP_REDIRECT;
>>>    
>>> -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
>>> +	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
>>>    		     act > act_max ? "Illegal" : "Driver unsupported",
>>> -		     act);
>>> +		     act, prog->aux->name, prog->aux->id, dev ? dev->name : "");
>>
>> One tiny nit, but we could fix it up while applying I'd have is that for !dev case
>> we should probably dump a "<n/a>" or so just to avoid a kernel log message like
>> "dev , expect packet loss".
> 
> Yep, that would probably be better. Pleas let me know it you prefer a
> formal new version for the patch.

Ok, I think no need, we can take care of it when applying.

Thanks,
Daniel
