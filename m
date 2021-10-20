Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0406434719
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhJTImo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:42:44 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35945 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhJTImo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:42:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634719230; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ngiA4F+Xq1nJ5EtozeFV5N0OpfSzo6oaCKX4IXNUDKg=;
 b=wDFFsPa1gBwS8NI9vTHlFhqUMhNaKnHhImHcuxBTMRYy5YTogwvKxjzP+NV97psAQx3Wj+HH
 S4whWuy0qmeDI/7EKir9MuKqSS9YJ6FpQp4LUbNev646OrpKnnsD4Z1BIhvhcobxoI3F7iLR
 PVDJmWqXrVlkmCIl2s+7iolNUqQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 616fd5eb5ca800b6c12cb638 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 08:40:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 68239C43460; Wed, 20 Oct 2021 08:40:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB110C4338F;
        Wed, 20 Oct 2021 08:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org EB110C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] rsi: stop thread firstly in rsi_91x_init() error
 handling
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211015040335.1021546-1-william.xuanziyang@huawei.com>
References: <20211015040335.1021546-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <amitkarwar@gmail.com>, <siva8118@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163471920135.1743.399816436682216881.kvalo@codeaurora.org>
Date:   Wed, 20 Oct 2021 08:40:11 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ziyang Xuan <william.xuanziyang@huawei.com> wrote:

> When fail to init coex module, free 'common' and 'adapter' directly, but
> common->tx_thread which will access 'common' and 'adapter' is running at
> the same time. That will trigger the UAF bug.
> 
> ==================================================================
> BUG: KASAN: use-after-free in rsi_tx_scheduler_thread+0x50f/0x520 [rsi_91x]
> Read of size 8 at addr ffff8880076dc000 by task Tx-Thread/124777
> CPU: 0 PID: 124777 Comm: Tx-Thread Not tainted 5.15.0-rc5+ #19
> Call Trace:
>  dump_stack_lvl+0xe2/0x152
>  print_address_description.constprop.0+0x21/0x140
>  ? rsi_tx_scheduler_thread+0x50f/0x520
>  kasan_report.cold+0x7f/0x11b
>  ? rsi_tx_scheduler_thread+0x50f/0x520
>  rsi_tx_scheduler_thread+0x50f/0x520
> ...
> 
> Freed by task 111873:
>  kasan_save_stack+0x1b/0x40
>  kasan_set_track+0x1c/0x30
>  kasan_set_free_info+0x20/0x30
>  __kasan_slab_free+0x109/0x140
>  kfree+0x117/0x4c0
>  rsi_91x_init+0x741/0x8a0 [rsi_91x]
>  rsi_probe+0x9f/0x1750 [rsi_usb]
> 
> Stop thread before free 'common' and 'adapter' to fix it.
> 
> Fixes: 2108df3c4b18 ("rsi: add coex support")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

515e7184bdf0 rsi: stop thread firstly in rsi_91x_init() error handling

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211015040335.1021546-1-william.xuanziyang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

