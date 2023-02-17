Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EC769B3F8
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBQUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBQUco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:32:44 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5953E632;
        Fri, 17 Feb 2023 12:32:42 -0800 (PST)
Message-ID: <cd2fa388-573c-99d7-d199-f588d8d38bd5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676665960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+aseCJdFaeOdUJxOJzEaJC58L3YLEwHfHKCp1+fUKtc=;
        b=tH/YKCIM/Y3cUIiZudHPJNalo/UwfHG2F9S/XTyTXqBhcEVrz5bcgCqbxcv9z/7LBw8a6X
        6ET8EehOqEPYjuhCCytfPSG70EzlveD7gy/tmxbSt9OsuIh935OAwD53Zd4iCIvdA/ygww
        m1hz+5Rbq2GhjADGsS/gwNVF1aDaTxE=
Date:   Fri, 17 Feb 2023 12:32:36 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4] bpf, test_run: fix &xdp_frame misplacement
 for LIVE_FRAMES
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20230215185440.4126672-1-aleksander.lobakin@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230215185440.4126672-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 10:54 AM, Alexander Lobakin wrote:
> +#if BITS_PER_LONG == 64 && PAGE_SIZE == SZ_4K
> +/* tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c:%MAX_PKT_SIZE
> + * must be updated accordingly when any of these changes, otherwise BPF
> + * selftests will fail.
> + */
> +#ifdef __s390x__
> +#define TEST_MAX_PKT_SIZE 3216
> +#else
> +#define TEST_MAX_PKT_SIZE 3408

I have to revert this patch for now. It is not right to assume cache line size:
https://lore.kernel.org/bpf/50c35055-afa9-d01e-9a05-ea5351280e4f@intel.com/

Please resubmit and consider if this static_assert is really needed in the 
kernel test_run.c.

> +#endif
> +static_assert(SKB_WITH_OVERHEAD(TEST_XDP_FRAME_SIZE - XDP_PACKET_HEADROOM) ==
> +	      TEST_MAX_PKT_SIZE);
> +#endif

