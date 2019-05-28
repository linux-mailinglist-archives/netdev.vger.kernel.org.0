Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB62C692
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfE1MdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:33:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1MdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:33:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6718A606FC; Tue, 28 May 2019 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046793;
        bh=bCv8mmjaGHjRz1CnWoZ7MkvsZKR9B/r/zM9ICGN2FzI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bPR5FFdHt8arbTjleQmE0qcAT4rZbty8w6d9x6eTol6R5pLoiGXxRgCCRHOrTC++X
         hgU6GQuWBo5eUIajk9MPoevVLYleDCaMTXTZjDSNzY4Qbw5RKBB5pn11sCv98+YqHV
         uJamfztJ+a1qJ0/zVgS6LNzy504yPILGrCMNTR/Y=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9710D602FA;
        Tue, 28 May 2019 12:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046792;
        bh=bCv8mmjaGHjRz1CnWoZ7MkvsZKR9B/r/zM9ICGN2FzI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Jg1QSY+ATUDIpm6kBbkH5TMWFsrffh5idO6s9lLv/b5ls6mTh3I6ezyveDLaft+JS
         BLdKrCLxmCEIvyhsaDjjEwYol9wC0UQZpxsOP2+b+/iHLpBmNm3tFsDFSBB+l8ZvFn
         MenAf/9rpCqoNCj9b171qNhpFXsJTUUGCqOWc4dg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9710D602FA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: spi: Fix a memory leaking bug in wl1271_probe()
References: <20190524030117.GA6024@zhanggen-UX430UQ>
        <20190528113922.E2B1060312@smtp.codeaurora.org>
        <20190528121452.GA23464@zhanggen-UX430UQ>
Date:   Tue, 28 May 2019 15:33:09 +0300
In-Reply-To: <20190528121452.GA23464@zhanggen-UX430UQ> (Gen Zhang's message of
        "Tue, 28 May 2019 20:14:52 +0800")
Message-ID: <87tvde4v3u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gen Zhang <blackgod016574@gmail.com> writes:

> On Tue, May 28, 2019 at 11:39:22AM +0000, Kalle Valo wrote:
>> Gen Zhang <blackgod016574@gmail.com> wrote:
>> 
>> > In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
>> > when this allocation fails, ENOMEM is returned. However, 'pdev_data'
>> > and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
>> > platform_device_alloc() returns NULL, we should also free 'pdev_data'
>> > and 'glue' before wl1271_probe() ends to prevent leaking memory.
>> > 
>> > Similarly, we shoulf free 'pdev_data' when 'glue' is NULL. And we should
>> > free 'pdev_data' and 'glue' when 'glue->reg' is error and when 'ret' is
>> > error.
>> > 
>> > Further, we should free 'glue->core', 'pdev_data' and 'glue' when this 
>> > function normally ends to prevent leaking memory.
>> > 
>> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
>> 
>> Same questions as with similar SDIO patch:
>> 
>> https://patchwork.kernel.org/patch/10959049/
>> 
>> Patch set to Changes Requested.
>> 
>> -- 
>> https://patchwork.kernel.org/patch/10959053/
>> 
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>> 
> Thanks for your reply, Kalle. I had debate with Jon about this patch. 
> You could kindly refer to lkml: https://lkml.org/lkml/2019/5/23/1547. 
> And I don't think a practical conclusion is made there.

Yeah, I don't see how that thread proves that these patches are correct.

> Further, I e-mailed Greg K-H about when should we use devm_kmalloc().
>
> On Tue, May 28, 2019 at 08:32:57AM +0800, Gen Zhang wrote:
>> devm_kmalloc() is used to allocate memory for a driver dev. Comments
>> above the definition and doc 
>> (https://www.kernel.org/doc/Documentation/driver-model/devres.txt) all
>> imply that allocated the memory is automatically freed on driver attach,
>> no matter allocation fail or not. However, I examined the code, and
>> there are many sites that devm_kfree() is used to free devm_kmalloc().
>> e.g. hisi_sas_debugfs_init() in drivers/scsi/hisi_sas/hisi_sas_main.c.
>> So I am totally confused about this issue. Can anybody give me some
>> guidance? When should we use devm_kfree()?
> He replied: If you "know" you need to free the memory now, 
> call devm_kfree(). If you want to wait for it to be cleaned up latter, 
> like normal, then do not call it.
>
> So could please look in to this issue?

Sorry, no time to investigate this in detail. If you think the patches
are correct you can resend them and get someone familiar with the driver
to provide Reviewed-by, then I will apply them.

-- 
Kalle Valo
