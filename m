Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEB758E6C8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiHJFkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHJFkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6DB6FA16;
        Tue,  9 Aug 2022 22:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33EDF613EA;
        Wed, 10 Aug 2022 05:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0613EC433C1;
        Wed, 10 Aug 2022 05:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660110044;
        bh=2gJbWzpALWoqhREzI/65nFaQ3yxD3pDPr1VTzYjHy+s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fzRn+ofHWrjxCo1fS/haXsAksgnUchkHQXx3AWr9zJzAyBuKjio6BFnQ1Trx67/mW
         6RKlZ1NjDR4rTIa8iZX0m4UTJogmmtyB+noNhIiUYCFS7v0xVI58MzEQumVheyVU+K
         Ldp5On1v8KPvLNFSwEOo+a9EsbUAZFTCM3lUrjfJftRxOnj7r21BXsZ8KVuZEqH+Ry
         8OgZHDYq25/V+skynaRWH7VtfTw5F27il2qeGur4XytxH8fku4sn2/hXRa5W40j1+q
         swthC80o85VMRczLv6ZiqUA+R6kSDxiUBxL+qyG8AOKOjEnCWpO8pms+P5nCBPPv0x
         SXv/k6FdcPnpg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/2] brcmfmac: AP STA concurrency patches from Cypress/Infineon
References: <20220722122956.841786-1-alvin@pqrs.dk>
Date:   Wed, 10 Aug 2022 08:40:36 +0300
In-Reply-To: <20220722122956.841786-1-alvin@pqrs.dk> ("Alvin
 \=\?utf-8\?Q\?\=C5\=A0ipraga\=22's\?\=
        message of "Fri, 22 Jul 2022 14:29:53 +0200")
Message-ID: <87o7wshd0r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin =C5=A0ipraga <alvin@pqrs.dk> writes:

> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> We are using these two patches from Infineon (formerly Cypress) to
> enable AP+STA mode on our CYW89359-based platform. They come from the
> FMAC driver release package distributed by Infineon.
>
> The key thing here is that apsta needs to be set to 1 in order for AP
> mode to work concurrently with STA mode. I cannot speak for other
> chipsets so a review from the Broadcom side would be welcome here.
>
> For the ARP/ND offload being disabled in AP mode, I am of the view that
> this is correct, but while Arend has given his Reviewed-by on it
> previously, it was part of a different series [1], so I am sending
> without in order to jog some memories.
>
> [1] https://lore.kernel.org/linux-wireless/20201020022812.37064-3-wright.=
feng@cypress.com/#t
>
> Soontak Lee (1):
>   brcmfmac: Support multiple AP interfaces and fix STA disconnection
>     issue
>
> Ting-Ying Li (1):
>   brcmfmac: don't allow arp/nd offload to be enabled if ap mode exists

Arend, Franky & Hante: could you please take a look at this patchset?
Also I hope that people from Infineon could comment.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
