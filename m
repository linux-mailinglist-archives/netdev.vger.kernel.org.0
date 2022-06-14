Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9C54AB6B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353524AbiFNIGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353622AbiFNIG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:06:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7340E38DA7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655193986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGYP/gsEMh//AeAqwdzOtmRdYfkNCUr6/AfFkII/HEA=;
        b=Y6Vc5E/ubhvCY7prig4DKkIYBrN/wnXGszcBmIVc+e7Y/I+9dzF1eZWXrAawNIcca0t2r+
        ZQB2j6yWY+DDlvDGEyoOVEdBsTHBKXk8ChxvxMz7hi1+cu5uAK0KtWXMszdsavcwVOwN5B
        1R5DNEdIVx09GSGGvZf/h143HlVNnwY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-xo5nT0M2NKWIj9od1HqP0g-1; Tue, 14 Jun 2022 04:06:25 -0400
X-MC-Unique: xo5nT0M2NKWIj9od1HqP0g-1
Received: by mail-qv1-f69.google.com with SMTP id x17-20020a0cfe11000000b004645917e45cso5470445qvr.4
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KGYP/gsEMh//AeAqwdzOtmRdYfkNCUr6/AfFkII/HEA=;
        b=xzKcGsTGaQvvwdoXcgF6zsQqzAoKMI+TGd0L/mSZMYT7BxFymOTxxfxask22W5zUpq
         +dzH9seAXB7k8oY5/j8QtZnGVlf97RE3OKCX2C3d1DvLVJwuHA05ecMMFa3a8H6GuXS/
         zn9Jmn52I17JEdW0w7vv9GpyLQWaiiMpUSNuWu1G2QnKk3dULR+PrSkT+Z3kALPtK4L5
         ufHvxzc4gkuS+4c0SEI0gmaT7JOGvk9zHh2GwXZSoTrX2GkuJSXUMB5I9gFNpd/T+ch5
         JKuJJFfc+D2uMHZtCuVqXPIEPPM2AP7dyv5viz82ITEgi8aBanGbR/ylZsLNf1YLtKQ2
         uQNA==
X-Gm-Message-State: AOAM530YVa++I39h6cxIcY27uUWvQ4aLO/STlvAEuboTgw7RODU6lV1e
        gSwxlJwaixMPX5ykeqTLROMEjcnB0ijtHY6jpEIMD72Lj2YN1xN0I//wlr9XraDKW6QMFNCsqN2
        1/9riMk6XsN3kSFFJ
X-Received: by 2002:a05:622a:1906:b0:305:9fd:d39a with SMTP id w6-20020a05622a190600b0030509fdd39amr2975217qtc.25.1655193984978;
        Tue, 14 Jun 2022 01:06:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuCfeLE1J508wXY7hwu7w8PlPhBQNYCDFrlG7u0oQIZ5uVWbwIZyQPijEgSci6cc1tk/iQWA==
X-Received: by 2002:a05:622a:1906:b0:305:9fd:d39a with SMTP id w6-20020a05622a190600b0030509fdd39amr2975201qtc.25.1655193984687;
        Tue, 14 Jun 2022 01:06:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id l188-20020a37bbc5000000b006a6bbc2725esm8265998qkf.118.2022.06.14.01.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:06:24 -0700 (PDT)
Message-ID: <289be1e1392d5a0c9a90486be44ad09d10b70752.camel@redhat.com>
Subject: Re: [PATCH 1/1] l2tp: fix possible use-after-free
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 Jun 2022 10:06:20 +0200
In-Reply-To: <20220610051633.8582-1-xiaohuizhang@ruc.edu.cn>
References: <20220610051633.8582-1-xiaohuizhang@ruc.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-06-10 at 13:16 +0800, Xiaohui Zhang wrote:
> Similar to the handling of l2tp_tunnel_get in commit a622b40035d1
> ("l2ip: fix possible use-after-free"), we thought a patch might
> be needed here as well.
> 
> Before taking a refcount on a rcu protected structure,
> we need to make sure the refcount is not zero.
> 
> Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

I'm sorry for the late, trivial feedback, but we need a Fixes: tag
here. Since you need to repost, please insert the target tree
explicitly into the email subj.

Thanks!

Paolo

