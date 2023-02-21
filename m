Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B1B69E65B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbjBURxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjBURxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:53:02 -0500
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315A72195A
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:53:01 -0800 (PST)
Message-ID: <d6388f1d-13d3-d844-eca2-a4874e5c70cb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677001979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4IpaySF9btFuOu7iV7zMDJ1p1BXvgvQZ9/y209N9C0=;
        b=XxwE2tUtRadHJwiW8hA67MXHh9/YL9UIORTVQNb7CwuftV6QIdrv0yKhBlrLRoUcaEYQke
        J+tUHlbZ4Wkj4MDADti/xttWsNV/lwbdzclZOYnrgiAw6yVNLv5SZoxuTRG0srsHgcN9lz
        XOgfdmltzZcFV4dqRfSzrZrKzH/QwvA=
Date:   Tue, 21 Feb 2023 09:52:52 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5] bpf, test_run: fix &xdp_frame misplacement
 for LIVE_FRAMES
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230220154627.72267-1-aleksander.lobakin@intel.com>
 <36538615-7768-bdea-7829-6349729ab7cc@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <36538615-7768-bdea-7829-6349729ab7cc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 4:35 AM, Alexander Lobakin wrote:
> From: Alexander Lobakin <aleksander.lobakin@intel.com>
> Date: Mon, 20 Feb 2023 16:46:27 +0100
> 
>> &xdp_buff and &xdp_frame are bound in a way that
>>
>> xdp_buff->data_hard_start == xdp_frame
>>
>> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
>> this.
>> IOW, the following:
>>
>> 	for (u32 i = 0; i < 0xdead; i++) {
>> 		xdpf = xdp_convert_buff_to_frame(&xdp);
>> 		xdp_convert_frame_to_buff(xdpf, &xdp);
>> 	}
>>
>> shouldn't ever modify @xdpf's contents or the pointer itself.
>> However, "live packet" code wrongly treats &xdp_frame as part of its
>> context placed *before* the data_hard_start. With such flow,
>> data_hard_start is sizeof(*xdpf) off to the right and no longer points
>> to the XDP frame.
>>
>> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
>> places and praying that there are no more miscalcs left somewhere in the
>> code, unionize ::frm with ::data in a flex array, so that both starts
>> pointing to the actual data_hard_start and the XDP frame actually starts
>> being a part of it, i.e. a part of the headroom, not the context.
>> A nice side effect is that the maximum frame size for this mode gets
>> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
>> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
>> info.
>> Also update %MAX_PKT_SIZE accordingly in the selftests code. Leave it
>> hardcoded for 64 bit && 4k pages, it can be made more flexible later on.
>>
>> Minor: align `&head->data` with how `head->frm` is assigned for
>> consistency.
>> Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
>> clarity.
>>
>> (was found while testing XDP traffic generator on ice, which calls
>>   xdp_convert_frame_to_buff() for each XDP frame)
> 
> Sorry, maybe this could be taken directly to net-next while it's still
> open? It was tested and then reverted from bpf-next only due to not 100%
> compile-time assertion, which I removed in this version. No more
> changes. I doubt there'll be a second PR from bpf and would like this to
> hit mainline before RC1 :s

I think this could go to bpf soon instead of bpf-next. The change is specific to 
the bpf selftest. It is better to go through bpf to get bpf CI coverage.

> 
>>
>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
>> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>> Link: https://lore.kernel.org/r/20230215185440.4126672-1-aleksander.lobakin@intel.com
>> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> (>_< those two last tags are incorrect, lemme know if I should resubmit
>   it without them or you could do it if ok with taking it now)

Please respin when it can be landed to the bpf tree on top of the s390 changes.
