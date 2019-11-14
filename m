Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12809FC0F4
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 08:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfKNHnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 02:43:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfKNHnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 02:43:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 91D0860DAB; Thu, 14 Nov 2019 07:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573717380;
        bh=dZvmqQ58GRtsL8g5e4gnM7IbfR3M6/bfC460IXbV33s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oTPq9uMlVAOEP/8x0SynOQFI46f9Me6X2Y6HXonDXs5ua7dIU3goJx2KZB3dEbOZF
         2HzLxUQsqFsGIMltEAfCAhaeE1CyNTwvHbKwkDWQO/D1JNWjiqKL3/s/inQ45Tl/no
         2jSbIhiB0Le5GuLecUd/Q10jJKPbHJyuFa/kSKhY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EE56260CA5;
        Thu, 14 Nov 2019 07:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573717378;
        bh=dZvmqQ58GRtsL8g5e4gnM7IbfR3M6/bfC460IXbV33s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oL4QulW1wnrKdj2s3Mo7QbKJq4Z5Mw7tqigcO4UYBwQ5wOPcRHKqesyLgmvhJ7acG
         OH9aLYnCZ19B5kmJlt3VE5D8EX+dypApdfmZ2w+fisaaaTQX8JfNoYSb+r5ono2abD
         yNFSdwNfSeRqiwWm0DoQ/25oFQDSwV8wZyMMhEdE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EE56260CA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        "open list\:QUALCOMM ATHEROS ATH10K WIRELESS DRIVER" 
        <ath10k@lists.infradead.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        jeffrey.l.hugo@gmail.com, govinds@codeaurora.org
Subject: Re: [PATCH] ath10k: add cleanup in ath10k_sta_state()
References: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu>
        <20191113192821.GA3441686@builder>
Date:   Thu, 14 Nov 2019 09:42:52 +0200
In-Reply-To: <20191113192821.GA3441686@builder> (Bjorn Andersson's message of
        "Wed, 13 Nov 2019 11:28:21 -0800")
Message-ID: <87eeyax5s3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Thu 15 Aug 14:04 PDT 2019, Wenwen Wang wrote:
>
>> If 'sta->tdls' is false, no cleanup is executed, leading to memory/resource
>> leaks, e.g., 'arsta->tx_stats'. To fix this issue, perform cleanup before
>> go to the 'exit' label.
>> 
>
> Unfortunately this patch consistently crashes all my msm8998, sdm845 and
> qcs404 devices (running ath10k_snoc).  Upon trying to join a network the
> WiFi firmware crashes with the following:
>
> [  124.315286] wlan0: authenticate with 70:3a:cb:4d:34:f3
> [  124.334051] wlan0: send auth to 70:3a:cb:4d:34:f3 (try 1/3)
> [  124.338828] wlan0: authenticated
> [  124.342470] wlan0: associate with 70:3a:cb:4d:34:f3 (try 1/3)
> [  124.347223] wlan0: RX AssocResp from 70:3a:cb:4d:34:f3 (capab=0x1011 status=0 aid=2)
> [ 124.402535] qcom-q6v5-mss 4080000.remoteproc: fatal error received:
> err_qdi.c:456:EF:wlan_process:1:cmnos_thread.c:3900:Asserted in
> wlan_vdev.c:_wlan_vdev_up:3219
>
> Can we please revert it for v5.5?

Yes, let's revert it. And thanks for sending the patch to do that:

https://patchwork.kernel.org/patch/11242743/

-- 
Kalle Valo
