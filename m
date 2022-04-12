Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF004FE741
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358306AbiDLRkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358579AbiDLRjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:39:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73D562C89
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7142161A0C
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 17:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A423AC385A8;
        Tue, 12 Apr 2022 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649785045;
        bh=KoBR7jg4rOAXy43fQYSmsZR2P0XGok1WXDJAEL/jR+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XjImbaiz6vgKAhuqcLrGMcfQIyqjiPbl6BX0qyk82pYsS4IPLpR8bxvPEOkEHIfTn
         ur8EvYP2jvkVLWeu5dB1TxyM3eVDIglg81hr+tsccg1+KOGkDFlibMis0DxkasNpZb
         kpqA0u3GQdTHoukLIb5+Q/d8ZjlLqnxVDxv8Aox2Ik1mYkPDuY3jInstStMm2n1ZGN
         Lg0u3lumhVjFQeCTzcZFcywjnHFaxxDL/xc9hXRCQxO8majk/Ob2qnlPqXOWyVGVSp
         vd4iR7/G0nSVPoyarDmJH5XNESG5359+iSA9nH2Gl3oYVpKAGcOf3spqjB5zV3XUxR
         yLCYVDmUI/aJA==
Date:   Tue, 12 Apr 2022 10:37:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ray Jui <ray.jui@broadcom.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC] Applicability of using 'txq_trans_update' during ring
 recovery
Message-ID: <20220412103724.54924945@kernel.org>
In-Reply-To: <1bdb8417-233d-932b-1dc0-c56042aedabd@broadcom.com>
References: <1bdb8417-233d-932b-1dc0-c56042aedabd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 10:01:02 -0700 Ray Jui wrote:
> Hi David/Jakub,
> 
> I'd like to run through you on the idea of invoking 'txq_trans_update'
> to update the last TX timestamp in the scenario where we temporarily
> stop the TX queue to do some recovery work. Is it considered an
> acceptable approach to prevent false positive triggering of TX timeout
> during the recovery process?
> 
> I know in general people use 'netif_carrier_off' during the process when
> they reset/change the entire TX/RX ring set and/or other resources on
> the Ethernet card. But in our particular case, we have another driver
> running (i.e., RoCE) on top and setting 'netif_carrier_off' will cause a
> significant side effect on the other driver (e.g., all RoCE QPs will be
> terminated). In addition, for this special recovery work on our driver,
> we are doing it on a per NAPI ring set basis while keeping the traffic
> on other queues running. Using 'netif_carrier_off' will prevent traffic
> running from all other queues that are not going through recovery.

Can you use netif_device_detach() to mark the device as not present?
