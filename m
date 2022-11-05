Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE361DBF0
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 17:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKEQQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 12:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKEQQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 12:16:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA713D4E;
        Sat,  5 Nov 2022 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=hMlRvmOztseL8Ey9AQ1Tl95aMzXuJGidMzIyJVt4wQA=; b=kS9KqMtlGyn4E07pJekbylaDY7
        IZSzpqI+ZtrvOtf46C0bfg/SW1A0KK2W7OhydzSADx5uwxf99rd+Yk+Md06SWn4aDil1o8tS1W/4x
        2A5PHBczERCRSSYLt2e091A26eF5TJQ0oNLyUHVLOHX+xZBa1u24uH1KhfVMJiL0Jx2KOtfRpuJYk
        Yvr++K+vjv5ep4XwSDDI5Ddk41Oy/s8mJ6avT89luwNwG/+Q6YM/Mt5rXlZnj5kHza8n3VcMb//5v
        4/upmGhgfhaZvZokjY5olgoUQdTqK9Us5JbL8XlYFjqQtqFhG84gs80DCuu43HWJ95WUOPZGPTWYZ
        Ya/dCSpg==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1orLqS-006set-5F; Sat, 05 Nov 2022 16:16:32 +0000
Message-ID: <e03209cb-00c7-e282-c2a6-9a2bab0b147f@infradead.org>
Date:   Sat, 5 Nov 2022 09:16:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] selftests/bpf: Fix unsigned expression compared with
 zero
Content-Language: en-US
To:     Kang Minchul <tegongkang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221105102552.80052-1-tegongkang@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221105102552.80052-1-tegongkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 11/5/22 03:25, Kang Minchul wrote:
> Variable ret is compared with zero even though it was set as u32.

It's OK to compare a u32 == to zero, but 'ret' is compared to < 0,
which it cannot be. Better explanation here would be good.
Thanks.

> So u32 to int conversion is needed.
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 681a5db80dae..162d3a516f2c 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1006,7 +1006,8 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
>  {
>  	struct xsk_socket_info *xsk = ifobject->xsk;
>  	bool use_poll = ifobject->use_poll;
> -	u32 i, idx = 0, ret, valid_pkts = 0;
> +	u32 i, idx = 0, valid_pkts = 0;
> +	int ret;
>  
>  	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
>  		if (use_poll) {

-- 
~Randy
