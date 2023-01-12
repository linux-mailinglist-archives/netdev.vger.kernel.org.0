Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F229F666B94
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjALH3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjALH3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:29:31 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DDD7679;
        Wed, 11 Jan 2023 23:29:30 -0800 (PST)
Message-ID: <f074b33d-c27a-822d-7bf6-16a5c8d9524d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673508568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FK/1Wr/KKbXq7RtW3FiIu4dIY11MovkHluSBpwZ6VGI=;
        b=rbq0BNNR8lGHzmGsXOJmJA8cPi3Vq8lJxxamt8bbRQyBUGZJdixNRTSeRAVMsGNkQrVfQQ
        RGQbLil9n9lSL5i0Si6xs6LyPCPVaA/CItLT80ampr/AQVlXHEWa+TqrZi4Dbcd5njumAx
        MwOEzY5EnXpOWMBDG+4i4Qv3314A8RE=
Date:   Wed, 11 Jan 2023 23:29:22 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v7 00/17] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, bpf@vger.kernel.org,
        xdp-hints@xdp-project.net, netdev@vger.kernel.org
References: <20230112003230.3779451-1-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230112003230.3779451-1-sdf@google.com>
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

On 1/11/23 4:32 PM, Stanislav Fomichev wrote:
> Please see the first patch in the series for the overall
> design and use-cases.
> 
> See the following email from Toke for the per-packet metadata overhead:
> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
> 
> Recent changes:
> 
> - Bring back parts that were removed during patch reshuffling from "bpf:
>    Introduce device-bound XDP programs" patch (Martin)
> 
> - Remove netdev NULL check from __bpf_prog_dev_bound_init (Martin)
> 
> - Remove netdev NULL check from bpf_dev_bound_resolve_kfunc (Martin)
> 
> - Move target bound device verification from bpf_tracing_prog_attach into
>    bpf_check_attach_target (Martin)
> 
> - Move mlx5e_free_rx_in_progress_descs into txrx.h (Tariq)
> 
> - mlx5e_fill_xdp_buff -> mlx5e_fill_mxbuf (Tariq)

Thanks for the patches. The set lgtm.

The selftest patch 11 and 17 have conflicts with the recent changes in 
selftests/bpf/xsk.{h,c} and selftests/bpf/Makefile. eg. it no longer needs 
XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD, so please respin. From a quick look, it 
should be some minor changes.

Not sure if Tariq has a chance to look at the mlx5 changes shortly. The set is 
getting pretty long and the core part is ready with veth and mlx4 support. I 
think it is better to get the ready parts landed first such that other drivers 
can also start adding support for it. One option is to post the two mlx5 patches 
as another patchset and they can be reviewed separately.

