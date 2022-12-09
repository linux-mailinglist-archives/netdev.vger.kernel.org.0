Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB56488CB
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLITHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLITHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:07:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437F111A35;
        Fri,  9 Dec 2022 11:07:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0306B82889;
        Fri,  9 Dec 2022 19:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F60DC433D2;
        Fri,  9 Dec 2022 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670612823;
        bh=3epluAPIb6aZNpS676uQqwGWyWaI7SI8Peee6BZlmQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEFCmlrYp/e+1ARRqbtEuml6NCGp+SYbUlahasub8n8B7RvvMOSKrt6aJ9nN8c0zK
         iCThyznPAL4Y/bSNeKEl0LdKIX0qtOpejse0upkYcjyhEmmJN6KsonGDvDhxco9HyY
         WWOYZOEJ37qPy3LDIBLZwTaqJDED+RHPxYhOL/vR8hxYsEGBeBZtVW3bF3s5yjm9+v
         6ZVorqwq7DqwHQ+lcJxouEkrVjN3aIQQ9zOrm05WIe4vKRi63XWcDzQjhY8CuUOuhb
         kxlT2FW11j2MUWMpX5zF/BQMiud/fjfUCn/UzZzU9bpmuORw0/48FZECyognMeNu6q
         oPHmOhio1pDNg==
Date:   Fri, 9 Dec 2022 11:07:02 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: Re: [PATCH net v3 1/1] i40e: Fix the inability to attach XDP program
 on downed interface
Message-ID: <Y5OHVnaGZckyhaSC@x130>
References: <20221209185411.2519898-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221209185411.2519898-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 10:54, Tony Nguyen wrote:
>From: Bartosz Staszewski <bartoszx.staszewski@intel.com>
>
>Whenever trying to load XDP prog on downed interface, function i40e_xdp
>was passing vsi->rx_buf_len field to i40e_xdp_setup() which was equal 0.
>i40e_open() calls i40e_vsi_configure_rx() which configures that field,
>but that only happens when interface is up. When it is down, i40e_open()
>is not being called, thus vsi->rx_buf_len is not set.
>
>Solution for this is calculate buffer length in newly created
>function - i40e_calculate_vsi_rx_buf_len() that return actual buffer
>length. Buffer length is being calculated based on the same rules
>applied previously in i40e_vsi_configure_rx() function.
>
>Fixes: 613142b0bb88 ("i40e: Log error for oversized MTU on device")
>Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
>Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
>Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
>Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
>Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
>v3:
>- Remove unnecessary braces and parentheses
>- Simplify return in i40e_calculate_vsi_rx_buf_len(); return early on
>if conditions and remove elses
>

Reviewed-by: Saeed Mahameed <saeed@kernel.com>

