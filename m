Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7404BF0D1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbiBVDTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:19:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240501AbiBVDTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:19:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB8813CF5;
        Mon, 21 Feb 2022 19:19:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 494FD6153A;
        Tue, 22 Feb 2022 03:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E39C340E9;
        Tue, 22 Feb 2022 03:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645499963;
        bh=XdSeylhfMOnuHS3UWpigy3vNcSxueHfx/6cezNReTuc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=koKxbJeGQUeZNd2dhBgGxEQ8ZZWxGB5BmP7fL/QFZxNH7ZmC205cZmobP86c1dahE
         T4Qp9++AGKKqyzwhI0lrASVHN13B7lM087FZ4igAspGeay8LqcpLrmNNjUjbTC5dqB
         2veXEMrSmzToXQiGlJwArWpDHLWq7OGLoENIA35WjFwFjQW7snIEsE88VASXqQn4Sv
         kbPEZuUzbHlUs1qtkKPVazwVjSohmNIsDbDwFCQHhGJmnC5igOFaVuGzBc12JHtNSe
         824fODx2T8GPk1JGruoK1RCqee7jj7IQXDC9avp5cqLUxPfmcMPBYjkMNcOluebElm
         m3a/442n/5TvQ==
Message-ID: <3489899f-3521-133e-5184-1de828eb6309@kernel.org>
Date:   Mon, 21 Feb 2022 20:19:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 3/3] net: neigh: add skb drop reasons to
 arp_error_report()
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-4-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220220155705.194266-4-imagedong@tencent.com>
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

On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> When neighbour become invalid or destroyed, neigh_invalidate() will be
> called. neigh->ops->error_report() will be called if the neighbour's
> state is NUD_FAILED, and seems here is the only use of error_report().
> So we can tell that the reason of skb drops in arp_error_report() is
> SKB_DROP_REASON_NEIGH_FAILED.
> 
> Replace kfree_skb() used in arp_error_report() with kfree_skb_reason().
> 
> Reviewed-by: Mengen Sun <mengensun@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  net/ipv4/arp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: David Ahern <dsahern@kernel.org>
