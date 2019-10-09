Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3991DD09A8
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbfJII0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:26:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfJII0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:26:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2A6D961197; Wed,  9 Oct 2019 08:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609581;
        bh=Gy1gqEJtCEvYL82/t6Wu3+FpntDcrfhD3/ePtNqcrpg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SmjR0Yuf1x7q72QwWO9mbyesUNjtks65vlEMJCx5+k653xycK5emN9FD8mg8D8U1p
         9ZjcvS3rpWEEyXD4mh79RAul76vZGzGty+SvocSruMcyS7SlkjMNzYdtEhomvLn9KC
         kKyimG97NyFsvzFtgPKQsV47vw0PTbQY6iRcPle0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2AB96087B;
        Wed,  9 Oct 2019 08:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609580;
        bh=Gy1gqEJtCEvYL82/t6Wu3+FpntDcrfhD3/ePtNqcrpg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jtgMakL1JV63AyL0khRYxBYFm1Kf2GGK4hJDdqL1ultR3CSNyCWymRzxinCPx9l2u
         x4a9Q3xXENzglqzaNM7s8oFlg3jxxs+cJ2N+QpBMrfAM8tsyZ8GAVURPBvxXGIV8+N
         ELfoC0AQ2/WghsmrA55WxNrJPHM2WUbJiogxgfnw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C2AB96087B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] rtl8xxxu: add bluetooth co-existence support for
 single antenna
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191005094826.90814-1-chiu@endlessm.com>
References: <20191005094826.90814-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082621.2A6D961197@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:26:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> The RTL8723BU suffers the wifi disconnection problem while bluetooth
> device connected. While wifi is doing tx/rx, the bluetooth will scan
> without results. This is due to the wifi and bluetooth share the same
> single antenna for RF communication and they need to have a mechanism
> to collaborate.
> 
> BT information is provided via the packet sent from co-processor to
> host (C2H). It contains the status of BT but the rtl8723bu_handle_c2h
> dose not really handle it. And there's no bluetooth coexistence
> mechanism to deal with it.
> 
> This commit adds a workqueue to set the tdma configurations and
> coefficient table per the parsed bluetooth link status and given
> wifi connection state. The tdma/coef table comes from the vendor
> driver code of the RTL8192EU and RTL8723BU. However, this commit is
> only for single antenna scenario which RTL8192EU is default dual
> antenna. The rtl8xxxu_parse_rxdesc24 which invokes the handle_c2h
> is only for 8723b and 8192e so the mechanism is expected to work
> on both chips with single antenna. Note RTL8192EU dual antenna is
> not supported.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

e542e66b7c2e rtl8xxxu: add bluetooth co-existence support for single antenna

-- 
https://patchwork.kernel.org/patch/11175575/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

