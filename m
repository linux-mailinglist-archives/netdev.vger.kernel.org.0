Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20A851D127
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389399AbiEFGXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389394AbiEFGXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:23:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC49B5C67A;
        Thu,  5 May 2022 23:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F7261F09;
        Fri,  6 May 2022 06:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8924C385A8;
        Fri,  6 May 2022 06:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651817994;
        bh=V11+LAWJ1d5l67vnmx/JvBJkQlrT/ck1awnxoU+USPo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Td39A2a6SjBgRUPWf5cFiqwthdL+PTezWMG3cVnxsMqzDIghnZwRiSVZCCJluRK7d
         D6qfreohXvGy0Qu2Zq89EgecScEo+tIgygb7sO09B514YTaxy6OCPPUx+hZ8iocr8Y
         0I0ThOa/ryEEViBVJ1sajMCvuuJQycWDdpBmbRIBXRTN7DoEaqX2c7o+LB867yFE0u
         A1GXvIuAv7e+OCwAQRc8+GJ/xuBdYfHzFO0DiKQaeOodZlstflCsAFHlCc58bMOCMX
         9HcKY8taN/K+ygFkfr9NDOsYexRJWSTQHB5j3XY8qVQ0EJ2oeF+oRi4TufXm5zS7R4
         4Hw3vaLXNblqA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211009221711.2315352-1-robimarko@gmail.com>
References: <20211009221711.2315352-1-robimarko@gmail.com>
To:     Robert Marko <robimarko@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165181799100.13324.13296205363993224857.kvalo@kernel.org>
Date:   Fri,  6 May 2022 06:19:52 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robimarko@gmail.com> wrote:

> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
> BDF-s to be extracted from the device storage instead of shipping packaged
> API 2 BDF-s.
> 
> This is required as MikroTik has started shipping boards that require BDF-s
> to be updated, as otherwise their WLAN performance really suffers.
> This is however impossible as the devices that require this are release
> under the same revision and its not possible to differentiate them from
> devices using the older BDF-s.
> 
> In OpenWrt we are extracting the calibration data during runtime and we are
> able to extract the BDF-s in the same manner, however we cannot package the
> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
> the fly.
> This is an issue as the ath10k driver explicitly looks only for the
> board.bin file and not for something like board-bus-device.bin like it does
> for pre-cal data.
> Due to this we have no way of providing correct BDF-s on the fly, so lets
> extend the ath10k driver to first look for BDF-s in the
> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
> If that fails, look for the default board file name as defined previously.
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

f2a7064a78b2 ath10k: support bus and device specific API 1 BDF selection

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211009221711.2315352-1-robimarko@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

