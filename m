Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE5868CF7C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjBGG2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBGG2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:28:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A261D93F;
        Mon,  6 Feb 2023 22:28:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA3F6106D;
        Tue,  7 Feb 2023 06:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E86C4339B;
        Tue,  7 Feb 2023 06:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675751320;
        bh=hgjCiTgK3tFEZwcSdipz0CMiafS/Ag6o2Dpe7ceprjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDkUJPeeLXHqBULiPzBtMbGFFXsmDfc5HCvW8q6J3lRQuBlGdM49R6n0FCxEE6SJI
         RdZ4cfct3cfJ0X203y+wDBYB9A5iEjcNK+UeTycSnRP2fLPAuBm6tetCnSgvo+XF8g
         ugLZGYfKMQs+pFoPr+y9Pcmx87q+2hL9msB2kiX6xjLnhzTGQA8quMC99MdiFT1+0N
         pVvZAVJzTMZ2jYGW4mQ/tkUAS0+uYJDVKw9EtemFZGVu9AVT0EMOPlDoR49b1+q/x6
         CtNusUURE/LkcQ3sDKrbNXfRnKIyBY+dPqSrAfaiD+ObXYNM1qz+W2UWhoteFRXa6M
         lnHbvwcSg8wLA==
Date:   Mon, 6 Feb 2023 22:28:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: fix mismatched prototype
Message-ID: <20230206222839.0df937c9@kernel.org>
In-Reply-To: <20230203121553.2871598-1-arnd@kernel.org>
References: <20230203121553.2871598-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Feb 2023 13:15:36 +0100 Arnd Bergmann wrote:
> The forward declaration was introduced with a prototype that does
> not match the function definition:
> 
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
>  2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
>   391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks for the fix. What's the compiler / extra flags you're using?
Doesn't pop up on our setups..
