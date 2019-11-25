Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49425108DA8
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfKYMOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:14:09 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:53010
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbfKYMOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574684048;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=OGZ2n8F7a9gKBAe87Xm3/4zY0uhWgsuXNCXAZXK+jtE=;
        b=Nbubh/YLWhd/bH8vKeZ24qTE+Dk06qTDMPfP9vDAHNDwTXCM90IVv2oer+qx6Ofg
        dPmV37evbR65ltzZMR9YbjF5gnYkuuR/RwpmYQWDDy4PDJjIX1FywXI7H+C9YMI0bMu
        v6W1jnSjFHV1w5Ax6UnY6q8X84zlosb8xiiQ/lZU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574684048;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=OGZ2n8F7a9gKBAe87Xm3/4zY0uhWgsuXNCXAZXK+jtE=;
        b=abeOGg/THu4btBCztsusmbZ5AMFxOdm+25+dAH7rLlb5lHWTpeM94CnH3JOKigx9
        RZ8TThos2bDaoZDmFhD39hsf3c9QrHqU/ZJB1IQcxEh/tGk8HOdWKvw0nITSiIbTPWw
        D/I6wAHH9Oge/wtzNCqTwrtq0qeLNKEXTVHJr+Pc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 147E2C447A0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ath10k: fix RX of frames with broken FCS in
 monitor mode
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191115105612.8531-1-linus.luessing@c0d3.blue>
References: <20191115105612.8531-1-linus.luessing@c0d3.blue>
To:     =?utf-8?q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     ath10k@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Linus_L?==?utf-8?q?=C3=BCssing?= <ll@simonwunderlich.de>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea27bbaac-2f573abe-d791-4ad8-b809-1ce481d4dbb8-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 12:14:08 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Lüssing wrote:

> So far, frames were forwarded regardless of the FCS correctness leading
> to userspace applications listening on the monitor mode interface to
> receive potentially broken frames, even with the "fcsfail" flag unset.
> 
> By default, with the "fcsfail" flag of a monitor mode interface
> unset, frames with FCS errors should be dropped. With this patch, the
> fcsfail flag is taken into account correctly.
> 
> Tested-on: QCA4019 firmware-5-ct-full-community-12.bin-lede.011
> 
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ea0c3e2a4702 ath10k: fix RX of frames with broken FCS in monitor mode

-- 
https://patchwork.kernel.org/patch/11246045/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

