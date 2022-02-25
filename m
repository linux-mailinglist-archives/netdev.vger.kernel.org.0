Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E834C4904
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiBYPdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236052AbiBYPdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:33:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A4132967;
        Fri, 25 Feb 2022 07:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B76F61844;
        Fri, 25 Feb 2022 15:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2DBC340E7;
        Fri, 25 Feb 2022 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645803157;
        bh=re4LD9i2Uj90dRANt0iYKXhrrOvJlN1j1FZasGnyiig=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=F1tGVoHU9ft3AJ+FdeAO59avOt3QxhvLzRVgJxVOTUyM/l1NsqIkhu55dRD4ZNdt2
         d9stGn0B4d2XqJf3Ur8ta0doAE3REzxrPBRNDoGd5pKTXJMcUY1owi1u41zSn3poD4
         HEl5AoxnmCOxFpq1wP/jH2N8qxKyX5GvfhKl0GAzlb/qK5NNasac8yy6s/+GLskSBk
         kvNkqeXi8X9K37K1FJwRHCeuJk6pF805y9R9/lxaqFpj05K2BoYyUq/yQ99jDCDiyQ
         CzEWwInpVRNufbQWjO6XqVPDbSPZ11OeGuirK4Aw0EZM6Ym5DHkaYpmeGcbAXz30Yl
         ng24jir7s8h7Q==
Message-ID: <d0c27a7a-1ea9-6083-7d57-e9a23949c52f@kernel.org>
Date:   Fri, 25 Feb 2022 08:32:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v2] net/ip6mr: Fix build with
 !CONFIG_IPV6_PIMSM_V2
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Mobashshera Rasool <mobash.rasool.linux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20220225145206.561409-1-dima@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220225145206.561409-1-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/22 7:52 AM, Dmitry Safonov wrote:
> The following build-error on my config:
> net/ipv6/ip6mr.c: In function ‘ip6_mroute_setsockopt’:
> net/ipv6/ip6mr.c:1656:14: error: unused variable ‘do_wrmifwhole’ [-Werror=unused-variable]
>  1656 |         bool do_wrmifwhole;
>       |              ^
> 
> Cc: Mobashshera Rasool <mobash.rasool.linux@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Fixes: 4b340a5a726d
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
> v2: move the (v == MRT6MSG_WRMIFWHOLE) check under if (v != mrt->mroute_do_pim)
> 
>  net/ipv6/ip6mr.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

