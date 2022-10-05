Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931295F54BC
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJEMr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiJEMr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:47:56 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F18C61D59;
        Wed,  5 Oct 2022 05:47:55 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1og3oX-00031K-Ua; Wed, 05 Oct 2022 14:47:53 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1og3oX-000MZ8-Jj; Wed, 05 Oct 2022 14:47:53 +0200
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, joe@cilium.io,
        netdev@vger.kernel.org
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net> <87bkqqimpy.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3cc8a0c3-7767-12cf-f753-82e2df8ef293@iogearbox.net>
Date:   Wed, 5 Oct 2022 14:47:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87bkqqimpy.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26680/Wed Oct  5 09:55:19 2022)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/22 12:33 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> As part of the feedback from LPC, there was a suggestion to provide a
>> name for this infrastructure to more easily differ between the classic
>> cls_bpf attachment and the fd-based API. As for most, the XDP vs tc
>> layer is already the default mental model for the pkt processing
>> pipeline. We refactored this with an xtc internal prefix aka 'express
>> traffic control' in order to avoid to deviate too far (and 'express'
>> given its more lightweight/faster entry point).
> 
> Woohoo, bikeshed time! :)
> 
> I am OK with having a separate name for this, but can we please pick one
> that doesn't sound like 'XDP' when you say it out loud? You really don't
> have to mumble much for 'XDP' and 'XTC' to sound exactly alike; this is
> bound to lead to confusion!
> 
> Alternatives, in the same vein:
> - ltc (lightweight)
> - etc (extended/express/ebpf/et cetera ;))
> - tcx (keep the cool X, but put it at the end)

Hehe, yeah agree, I don't have a strong opinion, but tcx (or just sticking
with tc) is fully okay to me.

> [...]
> 
>> +/* (Simplified) user return codes for tc prog type.
>> + * A valid tc program must return one of these defined values. All other
>> + * return codes are reserved for future use. Must remain compatible with
>> + * their TC_ACT_* counter-parts. For compatibility in behavior, unknown
>> + * return codes are mapped to TC_NEXT.
>> + */
>> +enum tc_action_base {
>> +	TC_NEXT		= -1,
>> +	TC_PASS		= 0,
>> +	TC_DROP		= 2,
>> +	TC_REDIRECT	= 7,
>> +};
> 
> Looking at things like this, though, I wonder if having a separate name
> (at least if it's too prominent) is not just going to be more confusing
> than not? I.e., we go out of our way to make it compatible with existing
> TC-BPF programs (which is a good thing!), so do we really need a
> separate name? Couldn't it just be an implementation detail that "it's
> faster now"?

Yep, faster is an implementation detail; and developers can stick to existing
opcodes. I added this here given Andrii suggested to add the action codes as
enum so they land in vmlinux BTF. My thinking was that if we go this route,
we could also make them more user friendly. This part is 100% optional,
but for new developers it might lower the barrier a bit I was hoping given
it makes it clear which subset of actions BPF supports explicitly and with
less cryptic name.

> Oh, and speaking of compatibility should 'tc' (the iproute2 binary) be
> taught how to display these new bpf_link attachments so that users can
> see that they're there?

Sounds reasonable, I can follow-up with the iproute2 support as well.

Thanks,
Daniel
