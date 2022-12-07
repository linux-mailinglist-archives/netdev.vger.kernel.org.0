Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9939A645D1F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiLGPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLGO7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:59:35 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F90961B81
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:58:22 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l11so25267849edb.4
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OdJmiEU6ZfZjJI1LvvQKNe1oMJaPAmyOElFeB7HsN0g=;
        b=HI2y4ytWSbpSUh4cG0gOfqtDHMxHnzEdl35zYALqOnjF6HV/qUnnjE2aZaBPv0OefM
         fF/Dwy3MZRM1Y2ap/nYEtOEzrXnWobYJ+lyr03w0J1X+tUSv99Ndt1KW69IIMzf5emz2
         3RfcY0WiODDsvEuTwjGkd2GuFEgknzHORKip5xg+rU89veS4DEZwxf07oDvaa86T736R
         LQIRQD7re+z7Ncpil7uh6540j+qkn1mNXDLgG6pdI4VoVM7VfHvuTMdVFzCpIIuHf2Bz
         EbzsRDqvzedVK78uKc7taRvZQvSp7jKUnhR4i5m2KC0FBYJ+SGivu3ehnJejO/jd6HvR
         2sXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdJmiEU6ZfZjJI1LvvQKNe1oMJaPAmyOElFeB7HsN0g=;
        b=RZ9ERwZCuR0hxny7tve57nf15snLNQ+HDM3ple8wGijlawZvqit1N4h4NNeM+dRLd+
         dFhbaNE2caFv5yabkMsLruTLA1eBPYNzIaB/aSFbjgJDosDdsg3CCcLSHKYVJZ1I6MYA
         PH8hz2WMetxxyp8MO7EDUEJiizSGaIfRxeU6W5CPRpeUJffiq6xjB0R2cfqkW6hm5xKm
         44jJo7IevAiDCzgBnLG5KG4Gc2vsVI1LA5uG41v1O9mL+84NP+0bg8fv7Wej3M710Er+
         lnmbPQfCDbuoFeHA9kDgHOFc1vKFzywNvW3gmaQt9W29e38cjKoLAmndyfxxhMzLMG2B
         N3YA==
X-Gm-Message-State: ANoB5pl8XpJPyVDoFxvpkWOUrVFIzaI53+l4+KNJnGtmfjJMKqRp34nK
        FBqUl6ouM8a9QTY3kMzBhoF5ZA==
X-Google-Smtp-Source: AA0mqf7m72XGzuy282ccK37/6u4Hfc4eIklv5eM05afWxyQgOmdXf5LMlvb2VHDhMSuL85olK6urQQ==
X-Received: by 2002:aa7:cc93:0:b0:462:6b8e:1ddb with SMTP id p19-20020aa7cc93000000b004626b8e1ddbmr80321772edt.276.1670425100549;
        Wed, 07 Dec 2022 06:58:20 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709063d2900b0079dbf06d558sm8558082ejf.184.2022.12.07.06.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:58:19 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:58:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, davem@davemloft.net
Subject: Re: [PATCH net 2/3] mISDN: hfcpci: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5CqCuW6sHPv+eIg@nanopsycho>
References: <20221207093239.3775457-1-yangyingliang@huawei.com>
 <20221207093239.3775457-3-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207093239.3775457-3-yangyingliang@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 10:32:38AM CET, yangyingliang@huawei.com wrote:
>It is not allowed to call consume_skb() from hardware interrupt context
>or with interrupts being disabled. So replace dev_kfree_skb() with
>dev_consume_skb_irq() under spin_lock_irqsave().
>
>Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
