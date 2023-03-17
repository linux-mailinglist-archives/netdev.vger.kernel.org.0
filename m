Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4276BEF70
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjCQRS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCQRS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:18:27 -0400
Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [IPv6:2001:41d0:203:375::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2163D0A4
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:18:25 -0700 (PDT)
Message-ID: <ee8cab13-9018-5f62-0415-16409ee1610b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679073503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNvWVpgcpdz3Drl42R2YlRRtNcb69Lsle/tO9L8T248=;
        b=FtxyL7hMI4JazSeRpuBj/Aki/3f0EJguOUePTExKp7DBttL0GH08TRQG4pPxh/fEnVGNxK
        PR3EZVaIxiMAmD8Ry4dfKwqaDjgh2KHS8JCOc82LOms4dZMzXVV1A07Spb1MiGg1d4JHCG
        YijB9mBmEwgxuTE5ZD/v9kmr0LRp0nc=
Date:   Fri, 17 Mar 2023 10:18:19 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v7 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kui-Feng Lee <kuifeng@meta.com>, bpf@vger.kernel.org,
        ast@kernel.org, song@kernel.org, kernel-team@meta.com,
        andrii@kernel.org, sdf@google.com
References: <20230316023641.2092778-1-kuifeng@meta.com>
 <20230316023641.2092778-3-kuifeng@meta.com>
 <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 8:23 AM, Daniel Borkmann wrote:
>  From the function itself what is not clear whether
> callers that replace an existing one should do the synchronize_rcu() themselves 
> or if this should
> be part of tcp_update_congestion_control?

bpf_struct_ops_map_free (in patch 1) also does synchronize_rcu() for another 
reason (bpf_setsockopt), so the caller (bpf_struct_ops) is doing it. From 
looking at tcp_unregister_congestion_control(), make sense that it is more 
correct to have another synchronize_rcu() also in tcp_update_congestion_control 
in case there will be other non bpf_struct_ops caller doing update in the future.
