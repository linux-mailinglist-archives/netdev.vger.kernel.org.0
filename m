Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE9772DF5
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfGXLoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:44:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbfGXLoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:44:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C579D60388; Wed, 24 Jul 2019 11:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968655;
        bh=S6OXrvtDsyi8I8F59uMGPY5IQ3eyM6OF3WhhwoJvzoo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BC57CTXDFCqIg+o+viuTT8ydQbh2/+UtLg4pQNsCd+jyYmVgRwzz32rPtcvN/U1JW
         IGTd0gT6qtZ37NGLczaoIT0xbENopMwtKItNzyqd03HBFrZ8JG4h6mnsRe/f1S5XZS
         4lQWDVqHLwUci2DDDEvj+oY6kg7bwe4/4LSyfkto=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93EBE60FF3;
        Wed, 24 Jul 2019 11:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968651;
        bh=S6OXrvtDsyi8I8F59uMGPY5IQ3eyM6OF3WhhwoJvzoo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TcHlutVETrL2jorSylVgYgvu/0HZrximyJ4Uty+NCQOP5JKjb8tGlmWvfbIpeB7TH
         OMtaI8H1PbL0A9naSaQpbUOb6znBWjc7DOKZHXpHbzZ/b9XAedIR3N+QZYkE0AhyPq
         n5HN/iNwK4Eh9u3Er0pLTxnwc+OTp5VJo5jIadHQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 93EBE60FF3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of
 RTL8723BU
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190704105528.74028-1-chiu@endlessm.com>
References: <20190704105528.74028-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     jes.sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114415.C579D60388@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:44:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> The WiFi tx power of RTL8723BU is extremely low after booting. So
> the WiFi scan gives very limited AP list and it always fails to
> connect to the selected AP. This module only supports 1x1 antenna
> and the antenna is switched to bluetooth due to some incorrect
> register settings.
> 
> Compare with the vendor driver https://github.com/lwfinger/rtl8723bu,
> we realized that the 8723bu's enable_rf() does the same thing as
> rtw_btcoex_HAL_Initialize() in vendor driver. And it by default
> sets the antenna path to BTC_ANT_PATH_BT which we verified it's
> the cause of the wifi weak tx power. The vendor driver will set
> the antenna path to BTC_ANT_PATH_PTA in the consequent btcoexist
> mechanism, by the function halbtc8723b1ant_PsTdma.
> 
> This commit hand over the antenna control to PTA(Packet Traffic
> Arbitration), which compares the weight of bluetooth/wifi traffic
> then determine whether to continue current wifi traffic or not.
> After PTA take control, The wifi signal will be back to normal and
> the bluetooth scan can also work at the same time. However, the
> btcoexist still needs to be handled under different circumstances.
> If there's a BT connection established, the wifi still fails to
> connect until BT disconnected.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

Patch applied to wireless-drivers-next.git, thanks.

18e714687bea rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU

-- 
https://patchwork.kernel.org/patch/11031397/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

