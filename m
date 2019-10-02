Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1150DC4698
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 06:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfJBE3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 00:29:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBE3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 00:29:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6FB52611C5; Wed,  2 Oct 2019 04:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990551;
        bh=ShTKPTs4KOdaImLZFk6yFEClFsbgGy3rpclnBAkALO8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PxDtrRd9iWyLeIoep1axeT0pDjKslnlcU+I/ZXdIDIxVMndxHLaCoRbFvVt7kndyW
         e2+0Ly1gSg5QMiPwaBeldBCuPLu10+8n6VglQ6ak2HMUusUf6zTHkGx6n2OsFJzquH
         3ZdFoXVdq730zyYABSwkbcG7QbXjBgm+U6kCSbFA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40191608CC;
        Wed,  2 Oct 2019 04:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990550;
        bh=ShTKPTs4KOdaImLZFk6yFEClFsbgGy3rpclnBAkALO8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aXi7aoGaHtbaezobUtr1BxMha4SVYgsM6XrSqSQbQGANpWRQY+o0xO9ItfoR2ub0Q
         qu5ghSISXEMjdxZErz587OGh14tOTMqDZ0uAfUN5gGC1lPLc2GJtlxgCbeAx7uVOwa
         tCWOmxyzD4GaXOAWfrPpZpir4vYhuRnwYc0m8HG4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40191608CC
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
Message-Id: <20191002042911.6FB52611C5@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:29:11 +0000 (UTC)
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

Failed to apply, please rebase on top of wireless-drivers-next.

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h).
error: could not build fake ancestor
Applying: rtl8xxxu: add bluetooth co-existence support for single antenna
Patch failed at 0001 rtl8xxxu: add bluetooth co-existence support for single antenna
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11140223/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

