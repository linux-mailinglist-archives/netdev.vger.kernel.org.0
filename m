Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995455ED35D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiI1DQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiI1DQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:16:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD503476EC
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C164B81EA2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 03:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD562C433D6;
        Wed, 28 Sep 2022 03:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664334995;
        bh=194Fdn7AS1fxXzhPNR9aQ+FigtjyZMd8xhTg2aaVN+Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VjtuAnoT2nDIGPkwk8X243DZ79CqgcFRuhiKyb2/YcLGm/q115tIWnZ2H1Wo56kE4
         8euoHXo9KfenjvzsddFhBkhsDpDtaZn4+j7uPiqk28eAn9shar6Yr+ccU8X3PgWbxz
         GAq6McLskABQPaQKmIgohb4sWghabboyjUElwrpmW1cUTbtWVIv7hVQCpz8IDRM2G2
         b9V/aifWvt1qMc2ZqS5dD4P2O4NOekrtqoG8EBXZE9ykaOepXXkH831Ld8Qz8qaIHH
         uMKqjYHnh2B23/PDPDlA4JYUpGHqVVvDPN65Ac+Nxuzn2NT4yP6Tbf3ncr2lJfIlgt
         10HD8y+eMULDQ==
Message-ID: <8eb279e1-07e6-4326-7d81-8b7e4edc968a@kernel.org>
Date:   Tue, 27 Sep 2022 21:16:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v3 iproute2-next] ip link: add sub-command to view and
 change DSA conduit interface
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220922220655.2183524-1-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220922220655.2183524-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 3:06 PM, Vladimir Oltean wrote:
> Support the "dsa" kind of rtnl_link_ops exported by the kernel, and
> export reads/writes to IFLA_DSA_MASTER.
> 
> Examples:
> 
> $ ip link set swp0 type dsa conduit eth1
> 
> $ ip -d link show dev swp0
>     (...)
>     dsa conduit eth0
> 
> $ ip -d -j link show swp0
> [
> 	{
> 		"link": "eth1",
> 		"linkinfo": {
> 			"info_kind": "dsa",
> 			"info_data": {
> 				"conduit": "eth1"
> 			}
> 		},
> 	}
> ]
> 
> Note that by construction and as shown in the example, the IFLA_LINK
> reported by a DSA user port is identical to what is reported through
> IFLA_DSA_MASTER. However IFLA_LINK is not writable, and overloading its
> meaning to make it writable would clash with other users of IFLA_LINK
> (vlan etc) for which writing this property does not make sense.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2:
> - update man page
> v2->v3:
> - update main ip-link help text to print the new 'dsa' link type
> - rename the 'master' keyword to 'conduit' and keep 'master' as a
>   fallback
> - to avoid using the 'DSA master' term in the man page, stop explaining
>   which interfaces are eligible for this operation, and just refer to
>   the kernel documentation. Note that since the support was added in
>   net-next, the htmldocs have not been regenerated yet.
> 
>  include/uapi/linux/if_link.h | 10 ++++++

applied to iproute2-next.

always create patches against top of tree. had you done so I would not
have had to strip the uapi piece since it is already there.

