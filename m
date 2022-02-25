Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7963B4C495E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbiBYPna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242259AbiBYPn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:43:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589421FEDA8;
        Fri, 25 Feb 2022 07:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1132FB8325D;
        Fri, 25 Feb 2022 15:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EE7C340E7;
        Fri, 25 Feb 2022 15:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645803774;
        bh=rG0AcVeKtn6Er71mQXjGdAsXPiigDD36j/6q1LCtrHY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=E5tkRkYLTogDI8uVkWLYEWNS+OizruaLyBLOkuIRXaCAHCejmIyl11vuty3csmPzz
         plLrA4h9wcslVR7++vs7JrFHNcAKId9jVVEjFTxHIPzxj8EXlqA5xp+Y/GhJshZxhR
         +6iQcKus3COda19T6ttXheB2lzkZvpcxgF8wV1unMi9zEaaVz7KfI0jgIL0GydVfSh
         rlDOp64kTRZXN4iX2iEUcd0SuDs60IypWA1J+tmfgsaI8V3qVDHNmOfUIHmpavA8RR
         PQG3cTwFgqOflWXVmYxWdh2USZbKxThH1jtp77S6udiH2LHXHDn9Uiu+CijZEA9lAC
         GbTDCXeFYV6/Q==
Message-ID: <d5be0cf8-0607-5448-e235-183980f8f44a@kernel.org>
Date:   Fri, 25 Feb 2022 08:42:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v2 1/3] net: ip: add skb drop reasons for ip
 egress path
Content-Language: en-US
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220225071739.1956657-1-imagedong@tencent.com>
 <20220225071739.1956657-2-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220225071739.1956657-2-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/22 12:17 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() which is used in the packet egress path of IP layer
> with kfree_skb_reason(). Functions that are involved include:
> 
> __ip_queue_xmit()
> ip_finish_output()
> ip_mc_finish_output()
> ip6_output()
> ip6_finish_output()
> ip6_finish_output2()
> 
> Following new drop reasons are introduced:
> 
> SKB_DROP_REASON_IP_OUTNOROUTES
> SKB_DROP_REASON_BPF_CGROUP_EGRESS
> SKB_DROP_REASON_IPV6DSIABLED

A new version is needed to fix the typo Roman noticed; logic wise:

Reviewed-by: David Ahern <dsahern@kernel.org>

