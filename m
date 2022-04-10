Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF7E4FAF7E
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiDJSA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiDJSA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 14:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220D63C4BE
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 10:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACC3061042
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 17:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7670EC385A1;
        Sun, 10 Apr 2022 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649613525;
        bh=rDFmojbno+uxcj1JiSlGFWy8QvYrmKhjEHKVe2R7R4c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oy5x3gcly/J4bM7xtoJ/iP5LDomvI0lFub0cHgl9zBG63ILZR/Ud9UxN9YpnpbuH4
         Yh8oJnZHJbm6pl54eK5iNiN/Gavk1cyuiNq54KcpIFLkosGVlY8xrfvB70XQTv62GK
         H/BPhURJh1C7dK5n9oQdY086kBHT3ZZ9yY6bk4ZMkKwvMM4mEvLXb58+yUNH2ht8CU
         w2Jbt0LPL5cBgwpQAQVPpPTFm8u30Uq3g1VQ5sTxbwWy52mNl3FKlRB0CiHA2TjNKZ
         x2tdw1mn8auiOJCPcH4L7xgcHkcCv776G/ZtvTsZLeOUun6Xg4cFe6pK7BJUa5m6V8
         it9LEtYsSatsw==
Message-ID: <c4626f31-f986-b4e3-f72d-8faacafe565d@kernel.org>
Date:   Sun, 10 Apr 2022 11:58:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 1/5] ipv4: Use dscp_t in struct fib_rt_info
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1649445279.git.gnault@redhat.com>
 <027027eb31686b0ea43aaf6e533a5912ca400f21.1649445279.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <027027eb31686b0ea43aaf6e533a5912ca400f21.1649445279.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/22 2:08 PM, Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct fib_rt_info.
> This ensures ECN bits are ignored and makes it compatible with the
> fa_dscp field of struct fib_alias.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_router.c | 3 ++-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c   | 7 ++++---
>  drivers/net/netdevsim/fib.c                             | 5 +++--
>  include/net/ip_fib.h                                    | 2 +-
>  net/ipv4/fib_semantics.c                                | 4 ++--
>  net/ipv4/fib_trie.c                                     | 6 +++---
>  net/ipv4/route.c                                        | 4 ++--
>  7 files changed, 17 insertions(+), 14 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


