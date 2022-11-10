Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF0623B6F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiKJFns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiKJFnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:43:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD9512AB3;
        Wed,  9 Nov 2022 21:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3E361D85;
        Thu, 10 Nov 2022 05:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5171C433C1;
        Thu, 10 Nov 2022 05:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668059024;
        bh=sH/GcNpwoCJLyv9r25bcOWw2MBvzsgEXqh9lU3pFhgk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=vGqz6Hepe6FbQKoiX03ATJRSxG5Bnq4mbvUayppAFd1b9j+vYHU/IPwU/7B1lRG1G
         AAMEhbRcTAIi4uxkziSye02dzuybla1ERWl7t/XNq4iCKjJOwPtAgjjfP8FPFAOK1J
         NNc0e/zC7T5Nrgk5s4KdLdDvOpm+do3tkYwBWmw99m1Ka5i+qzMYsQ4PA3EXUQ46Q3
         LOe01nBm6bsMoBgXbqZs5ltm4+CCf67ZgKt04tE1B8gCJucYH7lw41OeyESkgYOhO+
         6Eofod2qvdotpLdrdaMJbHbqvQNX2Vw97yuoSaGkUb44nyK/6MIoKn1a24Qr3Q2Tyn
         UIuo3XLPJr2UQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Rasesh Mody <rmody@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 6/7] bna: Avoid clashing function prototypes
References: <cover.1667934775.git.gustavoars@kernel.org>
        <f813f239cd75c341e26909f59f153cb9b72b1267.1667934775.git.gustavoars@kernel.org>
Date:   Thu, 10 Nov 2022 07:43:35 +0200
In-Reply-To: <f813f239cd75c341e26909f59f153cb9b72b1267.1667934775.git.gustavoars@kernel.org>
        (Gustavo A. R. Silva's message of "Tue, 8 Nov 2022 14:31:36 -0600")
Message-ID: <87v8nns6t4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> When built with Control Flow Integrity, function prototypes between
> caller and function declaration must match. These mismatches are visible
> at compile time with the new -Wcast-function-type-strict in Clang[1].
>
> Fix a total of 227 warnings like these:
>
> drivers/net/ethernet/brocade/bna/bna_enet.c:519:3: warning: cast from 'void (*)(struct bna_ethport *, enum bna_ethport_event)' to 'bfa_fsm_t' (aka 'void (*)(void *, int)') converts to incompatible function type [-Wcast-function-type-strict]
>                 bfa_fsm_set_state(ethport, bna_ethport_sm_down);
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> The bna state machine code heavily overloads its state machine functions,
> so these have been separated into their own sets of structs, enums,
> typedefs, and helper functions. There are almost zero binary code changes,
> all seem to be related to header file line numbers changing, or the
> addition of the new stats helper.
>
> Important to mention is that while I was manually implementing this changes
> I was staring at this[2] patch from Kees Cook. Thanks, Kees. :)
>
> [1] https://reviews.llvm.org/D134831
> [2] https://lore.kernel.org/linux-hardening/20220929230334.2109344-1-keescook@chromium.org/
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v3:
>  - Add RB tag from Kees.
>  - Update changelog text.
>
> Changes in v2:
>  - None. This patch is new in the series.
>  - Link: https://lore.kernel.org/linux-hardening/2812afc0de278b97413a142d39d939a08ac74025.1666894751.git.gustavoars@kernel.org/
>
>  drivers/net/ethernet/brocade/bna/bfa_cs.h    | 60 +++++++++++++-------
>  drivers/net/ethernet/brocade/bna/bfa_ioc.c   | 10 ++--
>  drivers/net/ethernet/brocade/bna/bfa_ioc.h   |  8 ++-
>  drivers/net/ethernet/brocade/bna/bfa_msgq.h  |  8 ++-
>  drivers/net/ethernet/brocade/bna/bna_enet.c  |  6 +-
>  drivers/net/ethernet/brocade/bna/bna_tx_rx.c |  6 +-
>  drivers/net/ethernet/brocade/bna/bna_types.h | 27 +++++++--

Mixing wifi and ethernet patches in the same patch is not a good idea,
the network maintainers might miss this patch. I recommend submitting
patch 6 separately.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
