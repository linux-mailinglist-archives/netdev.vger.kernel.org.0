Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E15594AA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfF1HRD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 03:17:03 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43431 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfF1HRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:17:03 -0400
Received: by mail-ed1-f65.google.com with SMTP id e3so9634551edr.10
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 00:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ZCRbHOCPztH6pUkKjSDbIVRfDzIBNE+tA9OeAyX61+Q=;
        b=AIMGD8dxahd0jnTYfWNL5ER4OtJp9liyWtFLqpaOSDT7+VCtD7T+spP2p23LTzpMb0
         oxpqT6X449cL2U778y/xBZNrdeQ7aaP3pFzayIcFE10KSdIILJEVuTtdFKCLHBiXWHmq
         3AThBHOyI2Xy9InmHT73Ze2qSpmhcpWmrnUcxhLlzVDH/4tIMi8EO4/ENZjYxMPAYGTH
         ZOqNBz5IsY3UC8IrdTnVfzuoOVhl80MnQmRh6ouHNYsXJwXbw5cgY194Onm2Jc+dPknc
         HXCRzxQ+e89t9v6Wsh6esjOj2boa7lxeYeFfyEQRMCJEQ3DbRmY2XJmS9oXCF100WCih
         pQFg==
X-Gm-Message-State: APjAAAWHuX4yZfpGQKMpAvrpkCWqurvBWghdmJNM+ga/a6BN+xvZ82Ge
        yfSRGPD6RHrjevCNtf/Qkf61eA==
X-Google-Smtp-Source: APXvYqyCDqZ6S8Wv06rSONdXxLlFyIEj8zENHbgH0JY+0CVWAXeklN8Z13ArRCvSzfxzEUJU04B7SQ==
X-Received: by 2002:a17:906:154d:: with SMTP id c13mr7270301ejd.208.1561706221894;
        Fri, 28 Jun 2019 00:17:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w35sm433984edd.32.2019.06.28.00.17.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:17:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1DD7181CA7; Fri, 28 Jun 2019 09:17:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <04a5da1d-6d0e-5963-4622-20cb54285926@iogearbox.net>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1> <156125626136.5209.14349225282974871197.stgit@alrua-x1> <04a5da1d-6d0e-5963-4622-20cb54285926@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Jun 2019 09:17:00 +0200
Message-ID: <874l4a9o2b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>> indication of whether it can successfully redirect to the map index it was
>> given. Instead, BPF programs have to track this themselves, leading to
>> programs using duplicate maps to track which entries are populated in the
>> devmap.
>> 
>> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>> helper, which makes it possible to return failure to the eBPF program. The
>> lower bits of the flags argument is used as the return code, which means
>> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>> 
>> With this, a BPF program can check the return code from the helper call and
>> react by, for instance, substituting a different redirect. This works for
>> any type of map used for redirect.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>
> Overall series looks good to me. Just very small things inline here & in the
> other two patches:
>
> [...]
>> @@ -3750,9 +3742,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>  {
>>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>  
>> -	if (unlikely(flags))
>> +	/* Lower bits of the flags are used as return code on lookup failure */
>> +	if (unlikely(flags > XDP_TX))
>>  		return XDP_ABORTED;
>>  
>> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
>> +	if (unlikely(!ri->item)) {
>> +		WRITE_ONCE(ri->map, NULL);
>
> This WRITE_ONCE() is not needed. We never set it before at this point.

You mean the WRITE_ONCE() wrapper is not needed, or the set-to-NULL is
not needed? The reason I added it is in case an eBPF program calls the
helper twice before returning, where the first lookup succeeds but the
second fails; in that case we want to clear the ->map pointer, no?

-Toke
