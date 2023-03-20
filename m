Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16F26C2078
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCTSyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCTSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:54:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136F81EBC5;
        Mon, 20 Mar 2023 11:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97CA8CE12F4;
        Mon, 20 Mar 2023 18:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2485CC433EF;
        Mon, 20 Mar 2023 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679338009;
        bh=g6BlJgmijhqCNlalItaw2/djnjag2HIYjh4tOLp9usQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TARLu0zesRuKbjKpYtNSvP2VsNkuSjTgtXZgtX/jdRJUKbA2uduKXf2TaJXxkPJMJ
         tWBHfkAXToM5YjdpqJLU3UJXtz3kfnMs/9gbc9WEfMnpNGZF1rdHisKk1JirMkOc+/
         a5JKnZzQS22GVLYbIwum1wat7lo7UJKLtXIDec8sUZlgGwPd8Hy6zjT4kgGj0mgorw
         HK+excSPt18rfDx7VqIgPSb2oRt7sKQdUuDqJFYffrIJVeMh4aKX1qwxTYSjL2CV7/
         jtR3RVWDXI7V8TBP7c6QkDEh0jJqTOPx99NvOSYIpx9Z4HjUmj0Gf9g2qht753cV1R
         Ywq6jr1zPgaTQ==
Date:   Mon, 20 Mar 2023 11:46:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jason Xing <kerneljasonxing@gmail.com>, brouer@redhat.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, stephen@networkplumber.org,
        simon.horman@corigine.com, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230320114648.29a04add@kernel.org>
In-Reply-To: <870ba7b7-c38b-f4af-2087-688e9ae5a15d@redhat.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-3-kerneljasonxing@gmail.com>
        <20230316172020.5af40fe8@kernel.org>
        <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
        <20230316202648.1f8c2f80@kernel.org>
        <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
        <870ba7b7-c38b-f4af-2087-688e9ae5a15d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 14:30:27 +0100 Jesper Dangaard Brouer wrote:
> >> So if you want to monitor a meaningful event in your fleet, I think
> >> a better event to monitor is the number of times ksoftirqd was woken
> >> up and latency of it getting onto the CPU.  
> > 
> > It's a good point. Thanks for your advice.  
> 
> I'm willing to help you out writing a BPF-based tool that can help you
> identify the issue Jakub describe above. Of high latency from when
> softIRQ is raised until softIRQ processing runs on the CPU.
> 
> I have this bpftrace script[1] available that does just that:
> 
>   [1] 
> https://github.com/xdp-project/xdp-project/blob/master/areas/latency/softirq_net_latency.bt
> 
> Perhaps you can take the latency historgrams and then plot a heatmap[2]
> in your monitoring platform.
> 
>   [2] https://www.brendangregg.com/heatmaps.html

FWIW we have this little kludge of code in prod kernels:

https://github.com/kuba-moo/linux/commit/e09006bc08847a218276486817a84e38e82841a6

it tries to measure the latency from xmit to napi reaping completions.
So it covers both NICs IRQs being busted and the noise introduced by 
the scheduler. Not great, those should really be separate.
