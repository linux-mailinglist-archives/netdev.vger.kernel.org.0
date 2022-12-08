Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26998647502
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiLHRaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLHRaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B2798953
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F09D6200A
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4253CC433D2;
        Thu,  8 Dec 2022 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670520616;
        bh=q6hU/l2N5mL5tgS1R5sVeI+Zd9W++IjrKH8vlB8nQYg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PBOZHfw0FOg+hz0ii9gVOOIJkloFdMIfaZnoRMLLZTpR0LXRVuculIKuJQH/AZ0yK
         n1r3WvK0ZwHfb0g6uGIg26XeAqwi2retFwgTBvimaUTnxqZQGWmN7F8YYDr0MvvwZ3
         3U/0mO34MXXMoDbmC3pWaYGyGcz3Q5ccJqF/uEXqyfbubic062hKPoVwrEx4K3kHTj
         DVXqduetB9gASE0CMaXTtqLIKaPZCiI6lRCFk0D0YlMwhgz1D66l5bO5Xql/xx9lRw
         LqeQ4YJ22zMp5+LaaFJ9X85ZltmqIeMqAIKLQ7KQz5f6e/5d3OPuLO2ZhwEtxcJE7c
         ddIEOyw6ki1Vw==
Message-ID: <c48ca445-88a5-bb00-89a3-f1a0196351ce@kernel.org>
Date:   Thu, 8 Dec 2022 10:30:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH iproute2-next v4 0/2] Add pcp-prio and new apptrust
 subcommand
Content-Language: en-US
To:     Daniel Machon <daniel.machon@microchip.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, petrm@nvidia.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com
References: <20221205222145.753826-1-daniel.machon@microchip.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221205222145.753826-1-daniel.machon@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 3:21 PM, Daniel Machon wrote:
> This patch series makes use of the newly introduced [1] DCB_APP_SEL_PCP
> selector, for PCP/DEI prioritization, and DCB_ATTR_IEEE_APP_TRUST
> attribute for configuring per-selector trust and trust-order.
> 
> ========================================================================
> New parameter "pcp-prio" to existing "app" subcommand:
> ========================================================================
> 
> A new pcp-prio parameter has been added to the app subcommand, which can
> be used to classify traffic based on PCP and DEI from the VLAN header.
> PCP and DEI is specified in a combination of numerical and symbolic
> form, where 'de' (drop-eligible) means DEI=1 and 'nd' (not-drop-eligible)
> means DEI=0.
> 
> Map PCP 1 and DEI 0 to priority 1
> $ dcb app add dev eth0 pcp-prio 1nd:1
> 
> Map PCP 1 and DEI 1 to priority 1
> $ dcb app add dev eth0 pcp-prio 1de:1
> 
> ========================================================================
> New apptrust subcommand for configuring per-selector trust and trust
> order:
> ========================================================================
> 
> This new command currently has a single parameter, which lets you
> specify an ordered list of trusted selectors. The microchip sparx5
> driver is already enabled to offload said list of trusted selectors. The
> new command has been given the name apptrust, to indicate that the trust
> covers APP table selectors only. I found that 'apptrust' was better than
> plain 'trust' as the latter does not indicate the scope of what is to be
> trusted.
> 
> Example:
> 
> Trust selectors dscp and pcp, in that order:
> $ dcb apptrust set dev eth0 order dscp pcp
> 
> Trust selectors ethtype, stream-port and pcp, in that order
> $ dcb apptrust set dev eth0 order ethtype stream-port pcp
> 
> Show the trust order
> $ dcb apptrust show dev eth0 order order: ethtype stream-port pcp
> 
> A concern was raised here [2], that 'apptrust' would not work well with
> matches(), so instead strcmp() has been used to match for the new
> subcommand, as suggested here [3]. Same goes with pcp-prio parameter for
> dcb app.
> 
> The man page for dcb_app has been extended to cover the new pcp-prio
> parameter, and a new man page for dcb_apptrust has been created.
> 
> [1] https://lore.kernel.org/netdev/20221101094834.2726202-1-daniel.machon@microchip.com/
> [2] https://lore.kernel.org/netdev/20220909080631.6941a770@hermes.local/
> [3] https://lore.kernel.org/netdev/Y0fP+9C0tE7P2xyK@shredder/
> 
> ================================================================================
> v3-> v4:
>   - Remove print warning in dcb_app_print_key_pcp()
>   - Add Petr's Reviewed-By tag
> 
> v2 -> v3:
>   - Add macro for maximum pcp/dei value.
> 
> v1 -> v2:
>   - Modified dcb_cmd_apptrust_set() to allow multiple consecutive parameters.
>   - Added dcb_apptrust_print() to print everything in case of no argument.
>   - Renamed pcp keys 0-7 to 0nd-7nd.
>   - Renamed selector names in dcb-apptrust to reflect names used in dcb-app.
>   - Updated dcb-app manpage to reflect new selector names, and removed part
>     about hardware offload.
>   - Updated dcb-apptrust manpage to reflect new selector names, and modified the
>     description of the 'order' parameter.
>   - Replaced uses of parse_one_of() with loops, for new 1nd:1 semantics to be
>     parsed correctly, and not printing an error if selector was not found in
>     list.
> 
> 
> Daniel Machon (2):
>   dcb: add new pcp-prio parameter to dcb app
>   dcb: add new subcommand for apptrust
> 
>  dcb/Makefile            |   3 +-
>  dcb/dcb.c               |   4 +-
>  dcb/dcb.h               |   7 +
>  dcb/dcb_app.c           | 138 +++++++++++++++++-
>  dcb/dcb_apptrust.c      | 307 ++++++++++++++++++++++++++++++++++++++++
>  man/man8/dcb-app.8      |  32 +++++
>  man/man8/dcb-apptrust.8 | 109 ++++++++++++++
>  7 files changed, 592 insertions(+), 8 deletions(-)
>  create mode 100644 dcb/dcb_apptrust.c
>  create mode 100644 man/man8/dcb-apptrust.8
> 
> --
> 2.34.1
> 

applied to iproute2-next
