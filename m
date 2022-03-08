Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E234D1170
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344730AbiCHICe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344722AbiCHICd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:02:33 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7563E5E3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 00:01:37 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id u10so25455481wra.9
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 00:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IucybA/BbH72cgwgMkENy2nc0cw2uppzQpsI3A+UQng=;
        b=n2kvax4T596zRbJNHl3pnQBK56Kh3dAHGIATboCR3y4jygN1ehcf5ApBgDCV5Vb3y2
         SLWndLQ0RqQWcpJbKcyPuO4ztnaTn3WfZR+tAtBuAeiJ0Y4BNeMp+yu7V3xAAAEvQsfw
         vGDZbgQA8EuIXMQU+qtoE3wx/BO1VbroSviRdyIUievVZU8k63A/eymNH8QYO7RND78l
         0P+hi35rqJI6VNdQR07pPSUOTsEeJ7ZspVOX8afsoJi3MTripFjC89dnGdmYHSVLZ1dl
         3WbZw96mkjwI/2AQL/umBpbHA+/2eq+3Ehftz+AHUwt9F0eWyqjKCErDO6inxcJrERVt
         OwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IucybA/BbH72cgwgMkENy2nc0cw2uppzQpsI3A+UQng=;
        b=NqBU/sRHr/lSu21c/1XCoFxAtCsmEBJTFnG9XFCclo3lPUz1rWPDe4kRefiunGVgcz
         EQfPfKdlFRKYOTa3w0KQEpVEEnEtP7FuN/0gmZqa4XclR7geJkakcr1k13I6lm2cwV2I
         ijdrUIyEPyAAHKHTCuKM1WjDiulTH7+uxnffhqxF80QfLYBgvVXSEg5n2vzelyGvLBDr
         No1gLxtSdHatu91DJf7W5NtmMrpRTPIUttzm25LJmgjSy5Pj7J5uXVT3pWWaAqxVzhTT
         10/EkZzhE+rKVn7OExwniTmTgPTOe4PQeM9cPEm3FlcPEwe6hepcACX3dPpb/+aluPgw
         2eYQ==
X-Gm-Message-State: AOAM531rm62cvvRL9ZLX7YG+wLPKCUeAIovxd3O3f2359PNvodPED51g
        8oGusZ+dRFfdIsIyU6X3W93ySA==
X-Google-Smtp-Source: ABdhPJz+6S70Pvi8hGyqht0OJu08Ak+kz7cIlHduA+N2p+09HFTvirJzU5DqlyxwJQXndXnzxWy20w==
X-Received: by 2002:adf:e7c5:0:b0:1f2:1a3:f1a0 with SMTP id e5-20020adfe7c5000000b001f201a3f1a0mr5098043wrn.21.1646726495571;
        Tue, 08 Mar 2022 00:01:35 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05600c3caa00b00380deeaae72sm1978124wmb.1.2022.03.08.00.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 00:01:35 -0800 (PST)
Date:   Tue, 8 Mar 2022 08:01:32 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YicNXOlH8al/Rlk3@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <20220307173439-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220307173439-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Mar 2022, Michael S. Tsirkin wrote:

> On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> 
> Pls just basically copy the code comment here. this is just confuses.
> 
> > Also WARN() as a precautionary measure.  The purpose of this is to
> > capture possible future race conditions which may pop up over time.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> 
> And this is a bug we already fixed, right?

Well, this was the bug I set out to fix.

I didn't know your patch was in flight at the time.

> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> 
> not really applicable anymore ...

I can remove these if it helps.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
