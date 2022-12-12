Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3568364ABD6
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiLLXy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiLLXyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA57140D3;
        Mon, 12 Dec 2022 15:54:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E018B80B2C;
        Mon, 12 Dec 2022 23:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF96C433D2;
        Mon, 12 Dec 2022 23:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670889292;
        bh=EQI1hoJMPabVIHQBPHFzOMrKRsKT5Z+Qah7oVktxWic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LNb/D1nL9BAgP20Att8CRTX2e5I4va83O94y/5tpTfON6Ebt91I7kKYutQhzN/Rx4
         d6fShKGQG9DjuC8UhtQKtdHer/07fZjF+JQmAv+LZpjltlPBj3waGKDBTmtgI66woP
         bJta9AQx3Q0BE40C7I0bgbPLZlo8dtDNDoPvUb+8hTkDBypx5UruP1PhlLlSEtJLCv
         h0Wgqm/iqwFEGriMmNcMHcWQeuOqHgc1uqokNuXY9ff+cZOLxSA6318kBH2V+vXcDG
         uNNUGWPIYkkb6Ak86aAvJfVFkUyH8ui2t0RZlHCJL3NvjanTCQAzA/wU9K4/RySgEz
         JBGi3/qZla9sg==
Date:   Mon, 12 Dec 2022 15:54:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, andersson@kernel.org,
        agross@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
Subject: Re: [PATCH net-next 2/2] net: ipa: add IPA v4.7 support
Message-ID: <20221212155450.34fdae6b@kernel.org>
In-Reply-To: <48bef9dd-b71c-b6aa-e853-1cf821e88b50@linaro.org>
References: <20221208211529.757669-1-elder@linaro.org>
        <20221208211529.757669-3-elder@linaro.org>
        <47b2fb29-1c2e-db6e-b14f-6dfe90341825@linaro.org>
        <fa6d342e-0cfe-b870-b044-b0af476e3905@linaro.org>
        <48bef9dd-b71c-b6aa-e853-1cf821e88b50@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Dec 2022 10:31:14 +0100 Konrad Dybcio wrote:
> >> which in total gives us 0x146a8000-0x146aafff =20
> >=20
> > Can you tell me where you found this information? =20
> [1], [2]
>=20
> >  =20
> >> That would also mean all of your writes are kind of skewed, unless
> >> you already applied some offsets to them. =20
> >=20
> > This region is used by the modem, but must be set up
> > by the AP.
> >  =20
> >> (IMEM on 6350 starts at 0x14680000 and is 0x2e000 long, as per
> >> the bootloader memory map) =20
> >=20
> > On SM7250 (sorry, I don't know about 7225, or 6350 for that matter),
> > the IMEM starts at 0x14680000 and has length 0x2c000.=C2=A0 However that
> > memory is used by multiple entities.=C2=A0 The portion set aside for IPA
> > starts at 0x146a9000 and has size 0x2000.
> >  =20
> Not sure how 7250 relates to 6350, but I don't think there's much
> overlap..

Dunno if Alex is online, and the patches seem harmless so let me apply
as is so that they make 6.2, and we can follow up with corrections.
