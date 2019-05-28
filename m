Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B012C63F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfE1MPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:15:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34952 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE1MPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:15:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so9180339pfd.2;
        Tue, 28 May 2019 05:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+y1LhgybZDo6e2IXKdhcfe/V5jck1KpiR5cRJrvtKo0=;
        b=DtG4PbHGQBnUfiyVAviztUOKIfL3saDBQQh4xyvVOneHT/0sHTcjWx/hEFk4bLHuuK
         +bsflLMhkuKL3slI+lwqPv0YyT3OtPuh2lX55HWFFP+CubEFu0J5NyetX7RVyw7ewdNW
         x+lE8SXILt4aBOxfC7P2BbqcNCh8RSpjNpXjzilESmBTiUXZDg3Q3lqEqF3OYDb9YAqS
         /0G6rkU4PW4v2YLRyjbcyOEl93BIzVuY5W8++vexLQIAP8+r1PxBq4eHMGubYvhI9pdD
         IYbscUr4LZcLue6ltYha9S9TP1uw6F2lgqoPxMtScUpoM/xekz9sxvOaoc2uhAXbe98h
         pEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+y1LhgybZDo6e2IXKdhcfe/V5jck1KpiR5cRJrvtKo0=;
        b=pKLOu0UhBwgsf5oVNundHVq7HrcPld8XARyjRdawhUTkkobVaCYh9ju+rWWqY3aIYt
         dIN5bdTe8z3tDR0G/+04/vh/I9WCAJoKKt13EZGr4BTuAPOPre71q2kdh1tsBxgpQZ0F
         pxs1v34yPlezhGaczcDWc7pN7NYmOuLWWNVX1CbaEwOmvl4c5+CKGIvrd18UWc11ZERi
         wETgbu1F+sUHx2DFQnQ9HWB6RpVUE/dgdEh+xtI5QAi3Lj07SkTU3LUbFFJC9RKZQAcS
         qnAfIFAdlGf6zHBzvSDUNMd09NgMuBBbgr6RbovlmGY4YH4vdeYcdoY4I2J8OVcsnfE/
         V96A==
X-Gm-Message-State: APjAAAUxm55l/WNdkA7+I4khElE3ie0MTF2Coi78I7RkIqAiwViFOPVZ
        sJbuxvpPooJmWmaoEmqqy6o=
X-Google-Smtp-Source: APXvYqzlp65Uhv+naJGFhpgDeNVCpy6jOHSU7kH7ySVU4j/n6EghxRRxGpwpx2qhbUKg7Ps9yasuuQ==
X-Received: by 2002:a62:6507:: with SMTP id z7mr26181575pfb.225.1559045712230;
        Tue, 28 May 2019 05:15:12 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id i16sm13798983pfd.100.2019.05.28.05.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 05:15:10 -0700 (PDT)
Date:   Tue, 28 May 2019 20:14:52 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: spi: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190528121452.GA23464@zhanggen-UX430UQ>
References: <20190524030117.GA6024@zhanggen-UX430UQ>
 <20190528113922.E2B1060312@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528113922.E2B1060312@smtp.codeaurora.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 11:39:22AM +0000, Kalle Valo wrote:
> Gen Zhang <blackgod016574@gmail.com> wrote:
> 
> > In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
> > when this allocation fails, ENOMEM is returned. However, 'pdev_data'
> > and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
> > platform_device_alloc() returns NULL, we should also free 'pdev_data'
> > and 'glue' before wl1271_probe() ends to prevent leaking memory.
> > 
> > Similarly, we shoulf free 'pdev_data' when 'glue' is NULL. And we should
> > free 'pdev_data' and 'glue' when 'glue->reg' is error and when 'ret' is
> > error.
> > 
> > Further, we should free 'glue->core', 'pdev_data' and 'glue' when this 
> > function normally ends to prevent leaking memory.
> > 
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> 
> Same questions as with similar SDIO patch:
> 
> https://patchwork.kernel.org/patch/10959049/
> 
> Patch set to Changes Requested.
> 
> -- 
> https://patchwork.kernel.org/patch/10959053/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
Thanks for your reply, Kalle. I had debate with Jon about this patch. 
You could kindly refer to lkml: https://lkml.org/lkml/2019/5/23/1547. 
And I don't think a practical conclusion is made there.

Further, I e-mailed Greg K-H about when should we use devm_kmalloc().

On Tue, May 28, 2019 at 08:32:57AM +0800, Gen Zhang wrote:
> devm_kmalloc() is used to allocate memory for a driver dev. Comments
> above the definition and doc 
> (https://www.kernel.org/doc/Documentation/driver-model/devres.txt) all
> imply that allocated the memory is automatically freed on driver attach,
> no matter allocation fail or not. However, I examined the code, and
> there are many sites that devm_kfree() is used to free devm_kmalloc().
> e.g. hisi_sas_debugfs_init() in drivers/scsi/hisi_sas/hisi_sas_main.c.
> So I am totally confused about this issue. Can anybody give me some
> guidance? When should we use devm_kfree()?
He replied: If you "know" you need to free the memory now, 
call devm_kfree(). If you want to wait for it to be cleaned up latter, 
like normal, then do not call it.

So could please look in to this issue?

Thanks
Gen
