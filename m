Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E758E6CC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiHJFsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHJFsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:48:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738226050C;
        Tue,  9 Aug 2022 22:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AC5EB81AAE;
        Wed, 10 Aug 2022 05:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48300C433D6;
        Wed, 10 Aug 2022 05:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660110484;
        bh=Uy/xg+Q+v6debLuTK6XZQeKR8bU1zlFobRALW89Y8dQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WjfuVuR9cXDq2tMSzKzbCgihGo4seMRSQI5QvsYU5sdNUL31TLqvsClfEix9aae5j
         xxvF1vbPxNfp+5CahJrrHAIGSBWE8CMWGvY9YaYLvKUAAlmh3QUrhBeOELSkTK4pN0
         brj7glAP8Ggq2siaW55EoFLESUcioJM7G1tT6g9OtQS4a1JXDWn0LSLoITOHVIczFy
         I9pv3InxeexzLCIiJ14/pEmVm8Jbc00Bo1yok0wT+faIWeKY8KLOrFzuw21VZZuNIv
         gFH+elIIsEycfM6wUFgyzz0SdxU0+I1Ao0f4ugN6X8rPE4MYe8xAr47+GOjahAkGMr
         eBg3TzHlBtlKw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [1/6] wifi: brcmfmac: fix continuous 802.1x tx pending timeout
 error
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722115632.620681-2-alvin@pqrs.dk>
References: <20220722115632.620681-2-alvin@pqrs.dk>
To:     =?utf-8?q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166011047689.24475.5790257380580454361.kvalo@kernel.org>
Date:   Wed, 10 Aug 2022 05:48:01 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin Šipraga <alvin@pqrs.dk> wrote:

> From: Wright Feng <wright.feng@cypress.com>
> 
> The race condition in brcmf_msgbuf_txflow and brcmf_msgbuf_delete_flowring
> makes tx_msghdr writing after brcmf_msgbuf_remove_flowring. Host
> driver should delete flowring after txflow complete and all txstatus back,
> or pend_8021x_cnt will never be zero and cause every connection 950
> milliseconds(MAX_WAIT_FOR_8021X_TX) delay.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

5 patches applied to wireless-next.git, thanks.

0fa24196e425 wifi: brcmfmac: fix continuous 802.1x tx pending timeout error
09be7546a602 wifi: brcmfmac: fix scheduling while atomic issue when deleting flowring
aa666b68e73f wifi: brcmfmac: fix invalid address access when enabling SCAN log level
5606aeaad01e wifi: brcmfmac: Fix to add brcmf_clear_assoc_ies when rmmod
2eee3db784a0 wifi: brcmfmac: Fix to add skb free for TIM update info when tx is completed

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722115632.620681-2-alvin@pqrs.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

