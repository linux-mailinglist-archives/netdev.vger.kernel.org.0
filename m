Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D453A2CB28F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgLBB6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgLBB6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:58:13 -0500
Date:   Tue, 1 Dec 2020 17:57:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606874252;
        bh=/B7Qy3AqRfswOpnyESo40g80ZWacBqUtUbUSF2XInLo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=gR/AbShkyrgnXe6AMxwN39wg23VDYXhUa9eLS8zipcGmarTdWj05WppsS7FPE/u7m
         1v7AVuMTy4Ufq6x7/fQ7bryVX6n7byEU/lXxhkbhpmQwBWKFMtSCLmGPRwdVMLAboc
         NbjNsRvrBzdS444xsQiLKOWU5Hg+OIad/kV+27OY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v7 00/14] net/smc: Add support for generic
 netlink API
Message-ID: <20201201175730.0aa647a6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 20:20:35 +0100 Karsten Graul wrote:
> Please apply the following patch series for smc to netdev's net-next tree.
> 
> Up to version 4 this patch series was using the sock_diag netlink
> infrastructure. This version is using the generic netlink API. Generic
> netlink API offers a better type safety between kernel and userspace
> communication.
> Using the generic netlink API the smc module can now provide information
> about SMC linkgroups, links and devices (both for SMC-R and SMC-D).
> 
> v2: Add missing include to uapi header smc_diag.h.
> 
> v3: Apply code style recommendations from review comments.
>     Instead of using EXPORTs to allow the smc_diag module to access
>     data of the smc module, introduce struct smc_diag_ops and let
>     smc_diag access the required data using function pointers.
> 
> v4: Address checkpatch.pl warnings. Do not use static inline for
>     functions.
> 
> v5: Use generic netlink API instead of the sock_diag netlink
>     infrastructure.
> 
> v6: Integrate more review comments from Jakub.
> 
> v7: Use nla_nest_start() with the new family. Use .maxattr=1 in the
>     genl family and define one entry for attribute 1 in the policy to
>     reject this attritbute for all commands. All other possible attributes
>     are rejected because NL_VALIDATE_STRICT is set for the policy
>     implicitely, which includes NL_VALIDATE_MAXTYPE.
>     Setting policy[0].strict_start_type=1 does not work here because there
>     is no valid attribute defined for this family, only plain commands. For
>     any type > maxtype (which is .maxattr) validate_nla() would return 0 to
>     userspace instead of -EINVAL. What helps here is __nla_validate_parse()
>     which checks for type > maxtype and returns -EINVAL when NL_VALIDATE_MAXTYPE
>     is set. This requires the one entry for type == .maxattr with
>     .type = NLA_REJECT in the nla_policy.
>     When a future command wants to allow attributes then it can easily specify a
>     dedicated .policy for this new command in the genl_ops array. This dedicated
>     policy overlays the global policy specified in the genl_family structure.

Applied, thank you!
