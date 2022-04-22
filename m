Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBF750BC12
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448977AbiDVPvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiDVPvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:51:53 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172F55DA06;
        Fri, 22 Apr 2022 08:49:00 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhvWb-000Dmk-7v; Fri, 22 Apr 2022 17:48:49 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhvWa-000M7G-PL; Fri, 22 Apr 2022 17:48:48 +0200
Subject: Re: [PATCH bpf] lwt_bpf: fix crash when using
 bpf_skb_set_tunnel_key() from bpf_xmit lwt hook
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mkl@pengutronix.de,
        tgraf@suug.ch, shmulik.ladkani@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
References: <20220420165219.1755407-1-eyal.birger@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c053fdf3-84bb-faee-387d-6edb2df9ffee@iogearbox.net>
Date:   Fri, 22 Apr 2022 17:48:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220420165219.1755407-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26520/Fri Apr 22 10:30:17 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 6:52 PM, Eyal Birger wrote:
> xmit_check_hhlen() observes the dst for getting the device hard header
> length to make sure a modified packet can fit. When a helper which changes
> the dst - such as bpf_skb_set_tunnel_key() - is called as part of the xmit
> program the accessed dst is no longer valid.
> 
> This leads to the following splat:
> 
>   BUG: kernel NULL pointer dereference, address: 00000000000000de
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP PTI
>   CPU: 0 PID: 798 Comm: ping Not tainted 5.18.0-rc2+ #103
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>   RIP: 0010:bpf_xmit+0xfb/0x17f
>   Code: c6 c0 4d cd 8e 48 c7 c7 7d 33 f0 8e e8 42 09 fb ff 48 8b 45 58 48 8b 95 c8 00 00 00 48 2b 95 c0 00 00 00 48 83 e0 fe 48 8b 00 <0f> b7 80 de 00 00 00 39 c2 73 22 29 d0 b9 20 0a 00 00 31 d2 48 89
>   RSP: 0018:ffffb148c0bc7b98 EFLAGS: 00010282
>   RAX: 0000000000000000 RBX: 0000000000240008 RCX: 0000000000000000
>   RDX: 0000000000000010 RSI: 00000000ffffffea RDI: 00000000ffffffff
>   RBP: ffff922a828a4e00 R08: ffffffff8f1350e8 R09: 00000000ffffdfff
>   R10: ffffffff8f055100 R11: ffffffff8f105100 R12: 0000000000000000
>   R13: ffff922a828a4e00 R14: 0000000000000040 R15: 0000000000000000
>   FS:  00007f414e8f0080(0000) GS:ffff922afdc00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00000000000000de CR3: 0000000002d80006 CR4: 0000000000370ef0
>   Call Trace:
>    <TASK>
>    lwtunnel_xmit.cold+0x71/0xc8
>    ip_finish_output2+0x279/0x520
>    ? __ip_finish_output.part.0+0x21/0x130
> 
> Fix by fetching the device hard header length before running the bpf code.
> 
> Cc: stable@vger.kernel.org
> Fixes: commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>   net/core/lwt_bpf.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
> index 349480ef68a5..8b6b5e72b217 100644
> --- a/net/core/lwt_bpf.c
> +++ b/net/core/lwt_bpf.c
> @@ -159,10 +159,8 @@ static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>   	return dst->lwtstate->orig_output(net, sk, skb);
>   }
>   
> -static int xmit_check_hhlen(struct sk_buff *skb)
> +static int xmit_check_hhlen(struct sk_buff *skb, int hh_len)
>   {
> -	int hh_len = skb_dst(skb)->dev->hard_header_len;
> -
>   	if (skb_headroom(skb) < hh_len) {
>   		int nhead = HH_DATA_ALIGN(hh_len - skb_headroom(skb));
>   
> @@ -274,6 +272,7 @@ static int bpf_xmit(struct sk_buff *skb)
>   
>   	bpf = bpf_lwt_lwtunnel(dst->lwtstate);
>   	if (bpf->xmit.prog) {
> +		int hh_len = dst->dev->hard_header_len;
>   		__be16 proto = skb->protocol;
>   		int ret;
>   
> @@ -291,7 +290,7 @@ static int bpf_xmit(struct sk_buff *skb)
>   			/* If the header was expanded, headroom might be too
>   			 * small for L2 header to come, expand as needed.
>   			 */
> -			ret = xmit_check_hhlen(skb);
> +			ret = xmit_check_hhlen(skb, hh_len);

Ok, makes sense given for BPF_OK the dst->dev shouldn't change here (e.g. as opposed
to BPF_REDIRECT). Applied, please also follow-up with a BPF selftest for test_progs
so that this won't break in future when it's running as part of BPF CI.

>   			if (unlikely(ret))
>   				return ret;
>   
> 

Thanks,
Daniel
