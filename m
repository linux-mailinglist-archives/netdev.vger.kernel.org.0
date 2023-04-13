Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7266E0D3C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDMMKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMMKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:10:02 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A672149EA;
        Thu, 13 Apr 2023 05:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=YOBMAKejPX+OUgvMPZLufLnvOCS92uPlIFdCR6OWoLw=; b=T5X6Rx8kaWNvIVsbXet+mazslG
        cUMmKQKwhxpKYmTzVNKZ05lPc6r1bz9rjFGRT4mI5IO4+2Nt8sYcRNrcj5LRTuDqsqm8Q+CqLfJNC
        YAAkgWLyfRWxTtdwYgmJIsep4lObGr/gm5S28YcLNqgVLQUS/4BBDGkhsK/DNQMgOqGADYZN4F/hJ
        gHMJImST2BJPnkTZqc6mOPDKhwBtnIcyMSDqD1qaG90/DSOAK6bhzHgf7oTEOB8+9IcPECOTlgKL0
        FsAmjSyAboq9AthHCt7/yVv/mGA5rsDet7sKip0kYUF0zeVEk6AsAFqchSuAVxHkpSfNjgy+sA94g
        dp1EFu4g==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pmvQN-000Cib-Uw; Thu, 13 Apr 2023 13:47:36 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pmvQN-0003GH-AA; Thu, 13 Apr 2023 13:47:35 +0200
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
To:     Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev,
        toke@redhat.com
References: <20230413025350.79809-1-laoar.shao@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
Date:   Thu, 13 Apr 2023 13:47:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230413025350.79809-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26874/Thu Apr 13 09:30:39 2023)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 4:53 AM, Yafang Shao wrote:
> In our container environment, we are using EDT-bpf to limit the egress
> bandwidth. EDT-bpf can be used to limit egress only, but can't be used
> to limit ingress. Some of our users also want to limit the ingress
> bandwidth. But after applying EDT-bpf, which is based on clsact qdisc,
> it is impossible to limit the ingress bandwidth currently, due to some
> reasons,
> 1). We can't add ingress qdisc
> The ingress qdisc can't coexist with clsact qdisc as clsact has both
> ingress and egress handler. So our traditional method to limit ingress
> bandwidth can't work any more.

I'm not following, the latter is a super set of the former, why do you
need it to co-exist?

> 2). We can't redirect ingress packet to ifb with bpf
> By trying to analyze if it is possible to redirect the ingress packet to
> ifb with a bpf program, we find that the ifb device is not supported by
> bpf redirect yet.

You actually can: Just let BPF program return TC_ACT_UNSPEC for this
case and then add a matchall with higher prio (so it runs after bpf)
that contains an action with mirred egress redirect that pushes to ifb
dev - there is no change needed.

> This patch tries to resolve it by supporting redirecting to ifb with bpf
> program.
> 
> Ingress bandwidth limit is useful in some scenarios, for example, for the
> TCP-based service, there may be lots of clients connecting it, so it is
> not wise to limit the clients' egress. After limiting the server-side's
> ingress, it will lower the send rate of the client by lowering the TCP
> cwnd if the ingress bandwidth limit is reached. If we don't limit it,
> the clients will continue sending requests at a high rate.

Adding artificial queueing for the inbound traffic, aren't you worried
about DoS'ing your node? If you need to tell the sender to slow down,
have you looked at hbm (https://lpc.events/event/4/contributions/486/,
samples/bpf/hbm_out_kern.c) which uses ECN CE marking to tell the TCP
sender to slow down? (Fwiw, for UDP https://github.com/cloudflare/rakelimit
would be an option.)

Thanks,
Daniel
