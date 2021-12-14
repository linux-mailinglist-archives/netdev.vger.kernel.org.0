Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2D7473CB4
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhLNFqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhLNFqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:46:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3625CC06173F;
        Mon, 13 Dec 2021 21:46:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03D45B817EE;
        Tue, 14 Dec 2021 05:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763A5C34604;
        Tue, 14 Dec 2021 05:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639460807;
        bh=Htj5hV27GPn/DWWnsutC64IYzEAA0cScppOui3dH0sU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=rIQZYp0g/DJXkV+e/qskkf4lsny21T/0vD3DQ55hZsxPlL1VNpj2/OCxyvBvRymW/
         HjOpDGiCPkTwcCUMbl4NN47meFIQ2E7v64x7M1HsswzuL90Do7sCDKwPF9Dkrv4s65
         D0h69am7LD28GCQCFRIt0D/x3/nIWp/Sq3AgogKPU7LCGePVV5EaXGzO7asr3HI5xE
         d8QQ4Sr2DQXE/DIcU8iX2kLhmUV0gPDJUglzyCcXGTQ2z+EjsV6N5eHm0VniHEKCW6
         bHbngAOJA6PqWPx1JRrpOSv1ONUbqyykEt+/WiGBdMNjzkJzNvuh2gh8mSaQjnQgv+
         ySVTJc6WV6ajQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     tony0620emma@gmail.com, pkshih@realtek.com, jian-hong@endlessm.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
References: <20211214053302.242222-1-kai.heng.feng@canonical.com>
Date:   Tue, 14 Dec 2021 07:46:41 +0200
In-Reply-To: <20211214053302.242222-1-kai.heng.feng@canonical.com> (Kai-Heng
        Feng's message of "Tue, 14 Dec 2021 13:33:02 +0800")
Message-ID: <874k7bkabi.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> Many Intel based platforms face system random freeze after commit
> 9e2fd29864c5 ("rtw88: add napi support").
>
> The commit itself shouldn't be the culprit. My guess is that the 8821CE
> only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
> masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
> extremely slow. Eventually the RX ring becomes messed up:
> [ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status
>
> Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
> the driver to resolve the issue.
>
> Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
> BugLink: https://bugs.launchpad.net/bugs/1927808
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

[...]

>  static bool rtw_disable_msi;
>  static bool rtw_pci_disable_aspm;
> +static int rtw_rx_aspm = -1;
>  module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
>  module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
> +module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
>  MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
>  MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
> +MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)")

We already have disable_aspm parameter, why do we need yet another one?
There's a high bar for new module parameters.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
