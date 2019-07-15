Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5F685B9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfGOItA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 04:49:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729245AbfGOIs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 04:48:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B144460F3C; Mon, 15 Jul 2019 08:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563180538;
        bh=d7xrxXALrd9BNvgNlJglyBGbGqVhhDzSP34RGwbKv5A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H3IuQ/2ViEExOHGMu68nOUzqqX1GviZeVC/wOEoSDYxi+QXfGHlQ0QQ4hrpVPN0q+
         S7R6IYCerWTlYTKO3PXg5Wqxcp0bAklITa0dtFFpmFVEAbSBF3erTo/ZTmrgyX6kgK
         biHTogVojFjn23YP6Ar3cRI8HuqvYafvFEuxVjcM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2D70A60DB6;
        Mon, 15 Jul 2019 08:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563180538;
        bh=d7xrxXALrd9BNvgNlJglyBGbGqVhhDzSP34RGwbKv5A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H3IuQ/2ViEExOHGMu68nOUzqqX1GviZeVC/wOEoSDYxi+QXfGHlQ0QQ4hrpVPN0q+
         S7R6IYCerWTlYTKO3PXg5Wqxcp0bAklITa0dtFFpmFVEAbSBF3erTo/ZTmrgyX6kgK
         biHTogVojFjn23YP6Ar3cRI8HuqvYafvFEuxVjcM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2D70A60DB6
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rt2x00usb: fix rx queue hang
References: <20190701105314.9707-1-smoch@web.de>
Date:   Mon, 15 Jul 2019 11:48:52 +0300
In-Reply-To: <20190701105314.9707-1-smoch@web.de> (Soeren Moch's message of
        "Mon, 1 Jul 2019 12:53:13 +0200")
Message-ID: <874l3nadjf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> writes:

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

I'll queue this for v5.3.

-- 
Kalle Valo
