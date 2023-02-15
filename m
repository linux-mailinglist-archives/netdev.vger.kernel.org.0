Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8884C6982ED
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBOSFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjBOSFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:05:02 -0500
Received: from out-216.mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A12334F70
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:05:01 -0800 (PST)
Message-ID: <7629c295-fc74-41fe-fd2e-28fe3a6e0846@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676484297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKm9gOUeXhfnihC/vGx+snLWS0EG0ToDKyRoLyPsITI=;
        b=sRSP1l63/qGTmM/Qa0+s6DVn0CrNu29yWMtLz07RdNpmu3zPnzNiOWXFTgfCOAS/Nio5Zv
        1p+T+q5emZwHlzr5SaFnVyG4h92w0tJEr+mFReoj4iCzRrVunL9cT/ATIyaRk5LtL/cr+N
        eDm8O1cOwF5GyIUiD3obSFW5eGEmWR8=
Date:   Wed, 15 Feb 2023 10:04:51 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230215152141.3753548-1-aleksander.lobakin@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230215152141.3753548-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 7:21 AM, Alexander Lobakin wrote:
>   /* The maximum permissible size is: PAGE_SIZE - sizeof(struct xdp_page_head) -
> - * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
> + * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3408 bytes
>    */
> -#define MAX_PKT_SIZE 3368
> +#define MAX_PKT_SIZE 3408

s390 has a different cache line size:

https://lore.kernel.org/all/20230128000650.1516334-11-iii@linux.ibm.com/

The above s390 fix is in bpf-next. It is better to target this patch for 
bpf-next also such that the CI can test it in s390.

