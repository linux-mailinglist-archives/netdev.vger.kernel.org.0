Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E04B671249
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjARD7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjARD7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:59:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E346222F4;
        Tue, 17 Jan 2023 19:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38EEAB81B05;
        Wed, 18 Jan 2023 03:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50372C433EF;
        Wed, 18 Jan 2023 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674014374;
        bh=Fl8kayFc9jqoIFP9l+2qRSeRmkqifuW10BFKmmYkmig=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IpuE3NTaEXM/SpZnwC07DQpUI/0oy2iSk7uYqBuik0rHeFZj04Zwl18FwleeihYVj
         A2gn/ypuwmyoH531wFVereYiAZfLh+94SWxyjD60x9SLD9uSNXFXrqxRa1USo8sOb6
         Vl4jMEAG11TaC+JIlRpIeRLk2MDpfUV8urH718pdKizzH4Cfe4uDu0f2FpJmUHGKE0
         +nUGhqWfj2i5TxUzh9Af5H64aX6RpDj4EYijwbR5xTi94X45QTzulfxzX+3qHsXVzA
         uekyTkbAJcBap/t6YoMOtwyDjAGa2H3ddySq79DbFl3ER9tIVNgm4/wBcxJPoZi4Zn
         nf/Iy3s8IgZXQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wataru Gohda <wataru.gohda@cypress.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: brcmfmac: Fix allocation size
References: <20230117104508.GB12547@altlinux.org> <87o7qxxvyj.fsf@kernel.org>
        <20230117112141.GB15213@altlinux.org>
Date:   Wed, 18 Jan 2023 05:59:28 +0200
In-Reply-To: <20230117112141.GB15213@altlinux.org> (Alexey V. Vissarionov's
        message of "Tue, 17 Jan 2023 14:21:41 +0300")
Message-ID: <87fsc88pcv.fsf@kernel.org>
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

"Alexey V. Vissarionov" <gremlin@altlinux.org> writes:

> On 2023-01-17 13:05:24 +0200, Kalle Valo wrote:
>
>  >> - buf_size += (max_idx + 1) * sizeof(pkt);
>  >> + buf_size += (max_idx + 1) * sizeof(struct sk_buff);
>  > Wouldn't sizeof(*pkt) be better?
>
> Usually sizeof(type) produces less errors than sizeof(var)...

This matter of taste really but FWIW I prefer sizeof(var) as then the
type can't be different by accident. And the coding style says something
similar, although that's related to memory allocation:

https://www.kernel.org/doc/html/latest/process/coding-style.html#allocating-memory

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
