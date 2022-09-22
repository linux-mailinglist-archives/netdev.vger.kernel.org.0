Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A263A5E5A21
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiIVEXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIVEXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFA6ADCE9;
        Wed, 21 Sep 2022 21:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D450633B2;
        Thu, 22 Sep 2022 04:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B840CC433C1;
        Thu, 22 Sep 2022 04:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663820588;
        bh=Zu49OmzNGTlyM3kN/XVnev/23u/OswdAXVOA4hTUCm0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TiyJW0ElUtMQ9OBf+XxHk/3od8zmIrLezqDbWrZiZoPaqcBzwwoMYJYCCpB2OwToq
         bsSyUBOaqcDCFYWIhiDDYRenvwj9rpdisnwEi1U7UZsaQPsxOrViyLlKD1xvX9DbYP
         JcZlDas9rael2YP3Wsx4Fq/LU3nQwn1/IkIFP/3pLSLFO9qmWxigeizm99z5kYneGU
         HfoumbgxM3vPrrgw8wV2BXsyN88eP5iCNPX0jGsqhHI/sBL47BkBc1hOQGcfbT83o7
         yFtGqcl2lEytlWD1NkqHdepGczfO1TjfTFD91UaKYI6dtBkKiDevhQ4ctt5Ve8gOGS
         r8XlKhivAYSNw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Syed Rafiuddeen <syed.rafiuddeen@cypress.com>,
        Syed Rafiuddeen <syed.rafiuddeen@infineon.com>,
        Chung-Hsien Hsu <chung-hsien.hsu@infineon.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] brcmfmac: Update SSID of hidden AP while informing its bss to cfg80211 layer
References: <20220722115632.620681-1-alvin@pqrs.dk>
        <20220722115632.620681-7-alvin@pqrs.dk>
Date:   Thu, 22 Sep 2022 07:23:01 +0300
In-Reply-To: <20220722115632.620681-7-alvin@pqrs.dk> ("Alvin
 \=\?utf-8\?Q\?\=C5\=A0ipraga\=22's\?\=
        message of "Fri, 22 Jul 2022 13:56:31 +0200")
Message-ID: <878rmc6nru.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin =C5=A0ipraga <alvin@pqrs.dk> writes:

> From: Syed Rafiuddeen <syed.rafiuddeen@cypress.com>
>
> cfg80211 layer on DUT STA is disconnecting ongoing connection attempt aft=
er
> receiving association response, because cfg80211 layer does not have valid
> AP bss information. On association response event, brcmfmac communicates
> the AP bss information to cfg80211 layer, but SSID seem to be empty in AP
> bss information, and cfg80211 layer prints kernel warning and then
> disconnects the ongoing connection attempt.
>
> SSID is empty in SSID IE, but 'bi->SSID' contains a valid SSID, so
> updating the SSID for hidden AP while informing its bss information
> to cfg80211 layer.
>
> Signed-off-by: Syed Rafiuddeen <syed.rafiuddeen@infineon.com>
> Signed-off-by: Chung-Hsien Hsu <chung-hsien.hsu@infineon.com>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@infineon.com>
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>

Infineon now submitted the same patch, I'll continue the review there:

https://patchwork.kernel.org/project/linux-wireless/patch/20220914033620.12=
742-5-ian.lin@infineon.com/

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
