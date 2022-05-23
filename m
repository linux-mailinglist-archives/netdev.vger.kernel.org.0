Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6045317F5
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiEWT1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiEWT05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1E839176;
        Mon, 23 May 2022 12:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F23F612AC;
        Mon, 23 May 2022 19:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5411C385A9;
        Mon, 23 May 2022 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653332803;
        bh=AumV0nZ46LzfW6RXeTCbFojukMPLFQlCkqhJHUS2YwU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GLJxwzi9LxJhx45hJBXTRHgfOZVf/HA3FeAK4t+rf+pSo58j1gvuNgjCX/pxLTJ1q
         LOT/S28vgbFIiXPvpWfc0rTLET+gNuvk6iC/mOFLCtqCbvNIu1ZSO3FryOLeu/lvYr
         46vEtDK9eOULBQdJjJrp2yk4rFhfF8eSNRWsLF22orHlVqZAP/58dLEw9XMW1kQOhE
         o6/CFcQp+BOyn6oQnCg/lahg60zUi1ioc6vYhn6DRNCYVCH6Ft4UKoKHKB46jdNTL5
         2TM+q9C4IGBtBHx66hfo2u2KwMYOU2GTKY+FiMwQKJYaOUvGNLijdQ/00e0BSTZPI3
         miC8EwPOquALA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ath11k: fix netdev open race
References: <20220517103436.15867-1-johan+linaro@kernel.org>
        <YouezMIwm3PYxOKY@hovoldconsulting.com>
Date:   Mon, 23 May 2022 22:06:37 +0300
In-Reply-To: <YouezMIwm3PYxOKY@hovoldconsulting.com> (Johan Hovold's message
        of "Mon, 23 May 2022 16:48:44 +0200")
Message-ID: <875ylwysoy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Tue, May 17, 2022 at 12:34:36PM +0200, Johan Hovold wrote:
>> Make sure to allocate resources needed before registering the device.
>> 
>> This specifically avoids having a racing open() trigger a BUG_ON() in
>> mod_timer() when ath11k_mac_op_start() is called before the
>> mon_reap_timer as been set up.
>> 
>> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
>> Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> ---
>
> For completeness:
>
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Thanks, added in the pending branch.

You submitted this as RFC but do you mind if I apply this anyway? The
patch looks good and passes my tests. But I do wonder why I haven't seen
the crash...

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
