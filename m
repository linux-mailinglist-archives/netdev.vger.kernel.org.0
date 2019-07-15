Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAEE69A39
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbfGORxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:53:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbfGORxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:53:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CE23960DAB; Mon, 15 Jul 2019 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563213200;
        bh=k3ChXNGFsdifjWHghdc8vll8SaEiy7GjD6ulRqw0jUI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LFxO1yF75FS88d5JZ3LUAa0SmYA2pEpKmFPCJrgCLmworScqTo8JW+wc64doREbdv
         oDWunoFpjRAH6aE+YWyLkT78+6pDlWYrEyP00af0PGtTphGXhNDK6BqoBsW2Gqi5Ub
         P+pvw0N4ztcpUMLCoeTJKhkzLKuuAv9RQ8ffn9Fg=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2DA126021C;
        Mon, 15 Jul 2019 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563213200;
        bh=k3ChXNGFsdifjWHghdc8vll8SaEiy7GjD6ulRqw0jUI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cDwpdQkDT5wTNPfSYWupIoTmE1U4CZ2+pArU4+dPINW+6BDPBL5Jee68BnoWy8OSX
         42eDWNAbZGj/IiKj1aRiHpnRPhyY0kUpT32+DtvMPiRAUpFh8QxlASn1zatL8UiT+N
         VYtXYcLnkllOaLFhNFW+HKo+FojFrVEBfa6FLDCk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2DA126021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] rt2x00usb: fix rx queue hang
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190701105314.9707-1-smoch@web.de>
References: <20190701105314.9707-1-smoch@web.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Soeren Moch <smoch@web.de>, stable@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190715175320.CE23960DAB@smtp.codeaurora.org>
Date:   Mon, 15 Jul 2019 17:53:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> wrote:

> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
>  ->complete() handler") the handler rt2x00usb_interrupt_rxdone() is
> not running with interrupts disabled anymore. So this completion handler
> is not guaranteed to run completely before workqueue processing starts
> for the same queue entry.
> Be sure to set all other flags in the entry correctly before marking
> this entry ready for workqueue processing. This way we cannot miss error
> conditions that need to be signalled from the completion handler to the
> worker thread.
> Note that rt2x00usb_work_rxdone() processes all available entries, not
> only such for which queue_work() was called.
> 
> This patch is similar to what commit df71c9cfceea ("rt2x00: fix order
> of entry flags modification") did for TX processing.
> 
> This fixes a regression on a RT5370 based wifi stick in AP mode, which
> suddenly stopped data transmission after some period of heavy load. Also
> stopping the hanging hostapd resulted in the error message "ieee80211
> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
> Other operation modes are probably affected as well, this just was
> the used testcase.
> 
> Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
> Cc: stable@vger.kernel.org # 4.20+
> Signed-off-by: Soeren Moch <smoch@web.de>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

41a531ffa4c5 rt2x00usb: fix rx queue hang

-- 
https://patchwork.kernel.org/patch/11025561/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

