Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926854FAF7F
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiDJSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiDJSBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 14:01:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F37B13DC6
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 10:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 950BC611A1
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 17:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734B6C385A1;
        Sun, 10 Apr 2022 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649613575;
        bh=ufG6z1OLvX+Z5N/lQE8XEx83DXB/pGBuek9ufG9ZBdU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nhKrsv9V6o8Sg0npM0H7HS/exrF8Km1VQKrLV9U+3R/FvuPgUebheDu0BcoxlfV2u
         Ld9VfB8uJeO4EGMB2HH7lxGK049MjYaHYdJYhnzQzuVr/ylTgmQCQLphirfSN+4Nqz
         MbAjsL1+wP5+50cGqGcHOInFbQS/pbVJ9bfuXkjg0XREEd2z/B8+VvPqikyOr6wLyj
         1Mv6MOb7OaIeQoWKu+FSB8wnzLcGsp0fb2oJQp0CdMHOcBLn/BSpA/RXlBDSbLjqwf
         NWpx44Wh29yuXae+NLEdYCXxMSZH+8DiO7+Yj9nJD0N8HGMTc5Wlo9+qo2jrmijCjS
         /57t5kXdw35fA==
Message-ID: <0b37040f-ba15-7f26-72ad-47e7d6d9b174@kernel.org>
Date:   Sun, 10 Apr 2022 11:59:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/5] ipv4: Use dscp_t in struct
 fib_entry_notifier_info
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
 <f69f4e262e502ff97ace5e13842cf7e53cbd7952.1649445279.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <f69f4e262e502ff97ace5e13842cf7e53cbd7952.1649445279.git.gnault@redhat.com>
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
> Use the new dscp_t type to replace the tos field of struct
> fib_entry_notifier_info. This ensures ECN bits are ignored and makes it
> compatible with the dscp field of struct fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 +++---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c   | 6 +++---
>  drivers/net/netdevsim/fib.c                             | 4 ++--
>  include/net/ip_fib.h                                    | 2 +-
>  net/ipv4/fib_trie.c                                     | 4 ++--
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


