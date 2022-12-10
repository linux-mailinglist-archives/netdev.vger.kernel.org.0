Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DAA648BD4
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLJAma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJAm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:42:29 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D383F97645;
        Fri,  9 Dec 2022 16:42:27 -0800 (PST)
Message-ID: <8fdc5438-9ca1-6c12-9909-c6f472c22f19@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670632946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4j7zCs4ite6CneM2hN33AekYFseDp5FZuluTmgM6C8=;
        b=UQy+2H0bR4kY8GcTkMgDNeSmN6X9KwMzIfrBHnEbVb5W8eGty6p/MAzk5RWXpbkp1mPSPe
        0R+uVG5iSnFGk00sGDOOhNJjrHY1hKBZ1nPkzE3OMY9z1uPpO74fkY6gIJWLXXp6YVD8Uc
        cs49hY/iSGqCA87YpcG15Hp/zkUeaQM=
Date:   Fri, 9 Dec 2022 16:42:19 -0800
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX
 kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-4-sdf@google.com> <878rjhldv0.fsf@toke.dk>
 <CAKH8qBvgkTXFEhd9hOa+SFtqKAXuD=WM_h1TZYdQA0d70_drEA@mail.gmail.com>
 <87zgbxjv7a.fsf@toke.dk>
 <CAKH8qBsK1J5HeSgPN_sYzQRY2jZOO=-E+zyKsn4xJ22zv5HRFg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBsK1J5HeSgPN_sYzQRY2jZOO=-E+zyKsn4xJ22zv5HRFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 6:57 PM, Stanislav Fomichev wrote:
> On Thu, Dec 8, 2022 at 4:07 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>>>> Another UX thing I ran into is that libbpf will bail out if it can't
>>>> find the kfunc in the kernel vmlinux, even if the code calling the
>>>> function is behind an always-false if statement (which would be
>>>> eliminated as dead code from the verifier). This makes it a bit hard to
>>>> conditionally use them. Should libbpf just allow the load without
>>>> performing the relocation (and let the verifier worry about it), or
>>>> should we have a bpf_core_kfunc_exists() macro to use for checking?
>>>> Maybe both?
>>>
>>> I'm not sure how libbpf can allow the load without performing the
>>> relocation; maybe I'm missing something.
>>> IIUC, libbpf uses the kfunc name (from the relocation?) and replaces
>>> it with the kfunc id, right?
>>
>> Yeah, so if it can't find the kfunc in vmlinux, just write an id of 0.
>> This will trip the check at the top of fixup_kfunc_call() in the
>> verifier, but if the code is hidden behind an always-false branch (an
>> rodata variable set to zero, say) the instructions should get eliminated
>> before they reach that point. That way you can at least turn it off at
>> runtime (after having done some kind of feature detection) without
>> having to compile it out of your program entirely.
>>
>>> Having bpf_core_kfunc_exists would help, but this probably needs
>>> compiler work first to preserve some of the kfunc traces in vmlinux.h?

hmm.... if I follow correctly, it wants the libbpf to accept a bpf prog using a 
kfunc that does not exist in the running kernel?

Have you tried "__weak":

extern void dummy_kfunc(void) __ksym __weak;

SEC("tc")
int load(struct __sk_buff *skb)
{
	if (dummy_kfunc) {
		dummy_kfunc();
		return TC_ACT_SHOT;
	}
	return TC_ACT_UNSPEC;
}

