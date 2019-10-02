Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549DCC4667
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 06:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfJBEVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 00:21:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBEVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 00:21:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1E0FD60A4E; Wed,  2 Oct 2019 04:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990092;
        bh=H5ZPrtTIbfEmm+LU0AYaQhfReN0+WJaYDfZWbZE/rOk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MaaB8MkvEqv3F3BpmVkBhKRmwU0lDmb7cjDm7uFzpVetuAfPTsGGa0MVfS1Q3+rup
         CDbMiQ07eZMHHqx4Z4yAVOD5JCo+vrymFyy5RUDVxvyba+AvpL8XO/k2ind5eAaAj5
         OwMlfPG5/wlsvu5SgCJIPIu1WQPDZJsHfQICywSA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB6C1601E7;
        Wed,  2 Oct 2019 04:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990091;
        bh=H5ZPrtTIbfEmm+LU0AYaQhfReN0+WJaYDfZWbZE/rOk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=DDq9+5p2zT2lCaTl3QxYrpLHYOicdnEXN2wJpt0NH6MTtT5u3au+rrz9AjhyAv4hQ
         mIOfUUJ3qSRLjPOGl4pQrg12rpa8Lr5k62jmqyJqNv93mAKSgqdLVkgRn/YJBxM9lF
         XULjkBsJUBs7L4RQs5tIX0FESklyct++u+xASsJ0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CB6C1601E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for
 single antenna
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190911025045.20918-1-chiu@endlessm.com>
References: <20190911025045.20918-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002042132.1E0FD60A4E@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:21:32 +0000 (UTC)
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

As Jes was positive about this in v1 and had only cosmetic comments, I'm
planning to apply this. If there are any changes needed, those can be fixed in
a followup patch.

-- 
https://patchwork.kernel.org/patch/11140223/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

