Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E240F434721
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJTIny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:43:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35945 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhJTInx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:43:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634719299; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XILHEr9PR1G67ML6EPe2JUwoWJ+d+1XbRIu3b8NAunY=;
 b=c8+8pMR2fcTTf27ZKU2N/b4ZQbvzwno+PTVTAtDUV2D0NGM52FyRdx2M9qwEdkIGyCXQMgTz
 4pI/QUTdEYB+mwZ4fLNFRsizq9U+Ycawdz6lgPUCTnkRBNNKrJVJ29J9UwWxybLy8ks/wvi6
 U9g52jdPTnu9LKGYyytb86DhtIM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 616fd643b03398c06cac700a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 08:41:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F2CE6C43617; Wed, 20 Oct 2021 08:41:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9D74C43460;
        Wed, 20 Oct 2021 08:41:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C9D74C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: mwl8k: Fix use-after-free in mwl8k_fw_state_machine()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634356979-6211-1-git-send-email-zheyuma97@gmail.com>
References: <1634356979-6211-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163471929329.1743.12412920889639302188.kvalo@codeaurora.org>
Date:   Wed, 20 Oct 2021 08:41:38 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheyu Ma <zheyuma97@gmail.com> wrote:

> When the driver fails to request the firmware, it calls its error
> handler. In the error handler, the driver detaches device from driver
> first before releasing the firmware, which can cause a use-after-free bug.
> 
> Fix this by releasing firmware first.
> 
> The following log reveals it:
> 
> [    9.007301 ] BUG: KASAN: use-after-free in mwl8k_fw_state_machine+0x320/0xba0
> [    9.010143 ] Workqueue: events request_firmware_work_func
> [    9.010830 ] Call Trace:
> [    9.010830 ]  dump_stack_lvl+0xa8/0xd1
> [    9.010830 ]  print_address_description+0x87/0x3b0
> [    9.010830 ]  kasan_report+0x172/0x1c0
> [    9.010830 ]  ? mutex_unlock+0xd/0x10
> [    9.010830 ]  ? mwl8k_fw_state_machine+0x320/0xba0
> [    9.010830 ]  ? mwl8k_fw_state_machine+0x320/0xba0
> [    9.010830 ]  __asan_report_load8_noabort+0x14/0x20
> [    9.010830 ]  mwl8k_fw_state_machine+0x320/0xba0
> [    9.010830 ]  ? mwl8k_load_firmware+0x5f0/0x5f0
> [    9.010830 ]  request_firmware_work_func+0x172/0x250
> [    9.010830 ]  ? read_lock_is_recursive+0x20/0x20
> [    9.010830 ]  ? process_one_work+0x7a1/0x1100
> [    9.010830 ]  ? request_firmware_nowait+0x460/0x460
> [    9.010830 ]  ? __this_cpu_preempt_check+0x13/0x20
> [    9.010830 ]  process_one_work+0x9bb/0x1100
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

257051a235c1 mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634356979-6211-1-git-send-email-zheyuma97@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

