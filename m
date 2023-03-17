Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1685D6BEF8F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCQRX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCQRXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:23:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE335ECD;
        Fri, 17 Mar 2023 10:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=GRRnMkAwEapUKrcQGfKOaN1vhgF0RjaiDjQd/np8Z70=; b=NT4k2QgkYoe9gkas2LlGyLsF7z
        Gfm6afVmo5Aelt3F7kpsDxrKE5KTFitPTog0/s4nreKqHX/6R46vUxkpR7qf8xzw6bNfgY5P4FKkN
        CoJeE6Q93OsGHYH3RydGFEI0XFJoGQR9ioGFTi2lL3JZVJdA91TwO1Vu+cZbBHz9ySVimB8UAS4QE
        2ToC1anCDIOePk18wQIE06qSEcJASDwZBHyyuUTOxIEpbYIhFK5NgI+jm05zuKo5uezjTDHj5Cd1n
        qhpY13TzvGeFBE59DMYKqdCDdzuCoXqjZvl6NWC8eFe3sPp0mIOdR2uCmQe447rNJMGdbxGaMnv4j
        BmNKKeYg==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pdDnM-0004Lz-M6; Fri, 17 Mar 2023 18:23:12 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pdDnM-000Oha-Bh; Fri, 17 Mar 2023 18:23:12 +0100
Subject: Re: [PATCH bpf-next v7 2/8] net: Update an existing TCP congestion
 control algorithm.
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Kui-Feng Lee <kuifeng@meta.com>, bpf@vger.kernel.org,
        ast@kernel.org, song@kernel.org, kernel-team@meta.com,
        andrii@kernel.org, sdf@google.com
References: <20230316023641.2092778-1-kuifeng@meta.com>
 <20230316023641.2092778-3-kuifeng@meta.com>
 <f72b77c3-15ac-3de3-5bce-c263564c1487@iogearbox.net>
 <ee8cab13-9018-5f62-0415-16409ee1610b@linux.dev>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b8b54ef5-8a24-5886-8f4e-8856dbaa9c34@iogearbox.net>
Date:   Fri, 17 Mar 2023 18:23:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ee8cab13-9018-5f62-0415-16409ee1610b@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26846/Fri Mar 17 08:22:57 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 6:18 PM, Martin KaFai Lau wrote:
> On 3/17/23 8:23 AM, Daniel Borkmann wrote:
>>  From the function itself what is not clear whether
>> callers that replace an existing one should do the synchronize_rcu() themselves or if this should
>> be part of tcp_update_congestion_control?
> 
> bpf_struct_ops_map_free (in patch 1) also does synchronize_rcu() for another reason (bpf_setsockopt), so the caller (bpf_struct_ops) is doing it. From looking at tcp_unregister_congestion_control(), make sense that it is more correct to have another synchronize_rcu() also in tcp_update_congestion_control in case there will be other non bpf_struct_ops caller doing update in the future.

Agree, I was looking at 'bpf: Update the struct_ops of a bpf_link', and essentially as-is
it was implicit via map free. +1, tcp_update_congestion_control() would be more obvious and
better for other/non-BPF users.

Thanks,
Daniel
