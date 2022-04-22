Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FC350ADD1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 04:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443396AbiDVCfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 22:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443391AbiDVCfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 22:35:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1164B438;
        Thu, 21 Apr 2022 19:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3E8C61462;
        Fri, 22 Apr 2022 02:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16D0C385A7;
        Fri, 22 Apr 2022 02:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650594757;
        bh=G/mklGa7Ma5bIBJ3geQ4nFYfuf9rVkRuLCnnbAj4e7I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=u+BbJmRVZznfrSLYJPPTDZWybNZ0pTElG2KGfsLnaBEGo+OPUAnuP+hfDIWkGt5en
         v6+Hnf4d4AnS8VIhbXtSInLS8DSUSyRLa25LmzibGMXkCWrU9gDO1StDq8LKCmmZHK
         VdzOaAiBi2Tmnuhyn0e29JRNNcitjIu4l2nJ8nosf0/N1ILTNg/DXcw1Xd8IpS3mX8
         rH0USz3WEbdJeSjeKh32WdKfrXlhoIhoTYpc6gISWktcdJrpRe+BnbSspEWMW53YGY
         9M2sP0wxyx1A1PBL+xliKgO5fYgb5sZC2QV7yE2gyM0WoL8gEuxwB2fxRFZzkpY21Y
         zVv/N/vdRnKmw==
Message-ID: <5f09f4d0-71d0-f122-d83e-6071fc2945b2@kernel.org>
Date:   Thu, 21 Apr 2022 20:32:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 2/3] ipv4: Avoid using RTO_ONLINK with
 ip_route_connect().
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
References: <cover.1650470610.git.gnault@redhat.com>
 <492f91626cab774d7dda27147629c3d56537f847.1650470610.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <492f91626cab774d7dda27147629c3d56537f847.1650470610.git.gnault@redhat.com>
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
> Now that ip_rt_fix_tos() doesn't reset ->flowi4_scope unconditionally,
> we don't have to rely on the RTO_ONLINK bit to properly set the scope
> of a flowi4 structure. We can just set ->flowi4_scope explicitly and
> avoid using RTO_ONLINK in ->flowi4_tos.
> 
> This patch converts callers of ip_route_connect(). Instead of setting
> the tos parameter with RT_CONN_FLAGS(sk), as all callers do, we can:
> 
>   1- Drop the tos parameter from ip_route_connect(): its value was
>      entirely based on sk, which is also passed as parameter.
> 
>   2- Set ->flowi4_scope depending on the SOCK_LOCALROUTE socket option
>      instead of always initialising it with RT_SCOPE_UNIVERSE (let's
>      define ip_sock_rt_scope() for this purpose).
> 
>   3- Avoid overloading ->flowi4_tos with RTO_ONLINK: since the scope is
>      now properly initialised, we don't need to tell ip_rt_fix_tos() to
>      adjust ->flowi4_scope for us. So let's define ip_sock_rt_tos(),
>      which is the same as RT_CONN_FLAGS() but without the RTO_ONLINK
>      bit overload.
> 
> Note:
>   In the original ip_route_connect() code, __ip_route_output_key()
>   might clear the RTO_ONLINK bit of fl4->flowi4_tos (because of
>   ip_rt_fix_tos()). Therefore flowi4_update_output() had to reuse the
>   original tos variable. Now that we don't set RTO_ONLINK any more,
>   this is not a problem and we can use fl4->flowi4_tos in
>   flowi4_update_output().
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/route.h | 36 ++++++++++++++++++++++++------------
>  net/dccp/ipv4.c     |  5 ++---
>  net/ipv4/af_inet.c  |  6 +++---
>  net/ipv4/datagram.c |  7 +++----
>  net/ipv4/tcp_ipv4.c |  5 ++---
>  5 files changed, 34 insertions(+), 25 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


