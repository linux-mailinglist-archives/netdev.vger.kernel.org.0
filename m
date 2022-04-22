Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB1050AE5A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 05:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443645AbiDVDLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 23:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347822AbiDVDLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 23:11:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692E139164
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 20:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0B64CE271F
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD58EC385A5;
        Fri, 22 Apr 2022 03:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650596922;
        bh=wvAkZORzSI4ilD7dlYmPYhwHDSM47fMdh4lvSFy+91M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nY9P+aSw9OjKluocuQrrI/cIdfW8Gog21IITeD+PhZwDnqD67awd5u6Scf6h5YkFt
         p+cJutpkXykkx/fYWHcuNtrTW1ZwrcpURvRxgWPlJ4ASZUc9YQuHbahonYdZ4rFfvs
         cJFBnxRzhZlduSA1xk9ZXwwF6KRuN3v22gUhzIOnZOl+GDqpgytxHPxJUojGMmf2lz
         EbcX8hFpWZPI92NetpKjaSTY+rnmZXpz8CfRA3L7iIUmeWton1FGmjVgj4zLbZ1fRO
         V4KnOq+CGJHMID0jiSGqWYsN7hL1Vts59rjwkI/CafOFbtSlT6xExfk/GhiyoUhTB6
         qI/IsSWqRYKKA==
Message-ID: <c1883180-67cd-ebe0-dc3e-49c545bdeb83@kernel.org>
Date:   Thu, 21 Apr 2022 21:08:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 3/3] ipv4: Initialise ->flowi4_scope properly in
 ICMP handlers.
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1650470610.git.gnault@redhat.com>
 <3aabf0b36042c11bc97343f899563cef2b9288e5.1650470610.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <3aabf0b36042c11bc97343f899563cef2b9288e5.1650470610.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 5:21 PM, Guillaume Nault wrote:
> All the *_redirect() and *_update_pmtu() functions initialise their
> struct flowi4 variable with either __build_flow_key() or
> build_sk_flow_key(). When sk is provided, these functions use
> RT_CONN_FLAGS() to set ->flowi4_tos and always use RT_SCOPE_UNIVERSE
> for ->flowi4_scope. Then they rely on ip_rt_fix_tos() to adjust the
> scope based on the RTO_ONLINK bit and to mask the tos with
> IPTOS_RT_MASK.
> 
> This patch modifies __build_flow_key() and build_sk_flow_key() to
> properly initialise ->flowi4_tos and ->flowi4_scope, so that the
> ICMP redirects and PMTU handlers don't need an extra call to
> ip_rt_fix_tos() before doing a fib lookup. That is, we:
> 
>   * Drop RT_CONN_FLAGS(): use ip_sock_rt_tos() and ip_sock_rt_scope()
>     instead, so that we don't have to rely on ip_rt_fix_tos() to adjust
>     the scope anymore.
> 
>   * Apply IPTOS_RT_MASK to the tos, so that we don't need
>     ip_rt_fix_tos() to do it for us.
> 
>   * Drop the ip_rt_fix_tos() calls that now become useless.
> 
> The only remaining ip_rt_fix_tos() caller is ip_route_output_key_hash()
> which needs it as long as external callers still use the RTO_ONLINK
> flag.
> 
> Note:
>   This patch also drops some useless RT_TOS() calls as IPTOS_RT_MASK is
>   a stronger mask.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv4/route.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


