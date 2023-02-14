Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9891C6967F2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjBNPYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBNPYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:24:23 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB91F25941;
        Tue, 14 Feb 2023 07:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=WkmkRKd2p/TpX+NcqEw5lpm/VjJz043nRMugl0QF89s=; b=TsG4P1kkz17T3BGGehFNE4UHdj
        J9wdZPKlbzQZbizC3MbX7loBEFOt9zUZrR5HkRnbg2Hnvo1OnPQvBe7P/f/V38CoFHI2J+5qk5OLj
        oTo/yKdljQ+QTgRvpGrL2ig/p2I6fxsMxkbTplZ7SbRrFIzEvV19KyXgwIjnvhBg3Lrq51+6NIsSL
        yEc1yK4jPTpSqCN8P+HW8xKavKcfvFm88lOf/Z73FljIBACkhCrLE52+1+82HWKir+Vak9PXhdufK
        BaJ+yDy5ZE9P0VImFnerDRbkFvyQRN/3PEvl6djAOCcjC70bv1hkZsE3B57xv9fOHzAwRPQW3zzZf
        f/UAW6Ug==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pRxAB-00008U-9W; Tue, 14 Feb 2023 16:24:11 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pRxAA-000U9p-Sx; Tue, 14 Feb 2023 16:24:10 +0100
Subject: Re: [PATCH v2 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8fffeae7-06a7-158e-e494-c17f4fdc689f@iogearbox.net>
Date:   Tue, 14 Feb 2023 16:24:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26812/Tue Feb 14 09:53:27 2023)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/23 3:27 PM, Alexander Lobakin wrote:
> &xdp_buff and &xdp_frame are bound in a way that
> 
> xdp_buff->data_hard_start == xdp_frame
> 
> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
> this.
> IOW, the following:
> 
> 	for (u32 i = 0; i < 0xdead; i++) {
> 		xdpf = xdp_convert_buff_to_frame(&xdp);
> 		xdp_convert_frame_to_buff(xdpf, &xdp);
> 	}
> 
> shouldn't ever modify @xdpf's contents or the pointer itself.
> However, "live packet" code wrongly treats &xdp_frame as part of its
> context placed *before* the data_hard_start. With such flow,
> data_hard_start is sizeof(*xdpf) off to the right and no longer points
> to the XDP frame.
> 
> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
> places and praying that there are no more miscalcs left somewhere in the
> code, unionize ::frm with ::data in a flex array, so that both starts
> pointing to the actual data_hard_start and the XDP frame actually starts
> being a part of it, i.e. a part of the headroom, not the context.
> A nice side effect is that the maximum frame size for this mode gets
> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
> info.
> 
> Minor: align `&head->data` with how `head->frm` is assigned for
> consistency.
> Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
> clarity.
> 
> (was found while testing XDP traffic generator on ice, which calls
>   xdp_convert_frame_to_buff() for each XDP frame)
> 
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Could you double check BPF CI? Looks like a number of XDP related tests
are failing on your patch which I'm not seeing on other patches where runs
are green, for example test_progs on several archs report the below:

https://github.com/kernel-patches/bpf/actions/runs/4164593416/jobs/7207290499

   [...]
   test_xdp_do_redirect:PASS:prog_run 0 nsec
   test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
   test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
   test_xdp_do_redirect:PASS:pkt_count_tc 0 nsec
   test_max_pkt_size:PASS:prog_run_max_size 0 nsec
   test_max_pkt_size:FAIL:prog_run_too_big unexpected prog_run_too_big: actual -28 != expected -22
   close_netns:PASS:setns 0 nsec
   #275     xdp_do_redirect:FAIL
   Summary: 273/1581 PASSED, 21 SKIPPED, 2 FAILED
