Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB143AD4C7
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhFRWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:06:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39936 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbhFRWGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 18:06:30 -0400
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <seth.forshee@canonical.com>)
        id 1luMb5-0006CT-5b
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 22:04:19 +0000
Received: by mail-oi1-f197.google.com with SMTP id l136-20020acaed8e0000b02901f3ebfedbf2so5566185oih.11
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 15:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aq0a1ZzhEowcsGM4Ha6B4ggHKmP/83PVuQLh/mwbb0s=;
        b=A6TsFNZz2aGU8rL13rOAj6Epz/5wFrt5Qma6QDKe0V9YWabS/12TbrBXnK5Ohb7UDW
         OsqrXuRZYVaKbipjXZtlrwzzD9lFMAXXpN3FkLLX2iE0hZIYa81cHNLH+hURNjvrMKMi
         o73yLEcNSmphmicDvon6wG8E/x+ikMPKTUPYjk5yP49JwA9ukXGUPtoB02oVkheePG9a
         OPA944oaakILUKa8xmUll5RR/Wi+sxHLcQKpTDEYN+wGBZBN1h8kK7phghQGou/g0fCB
         BU7zEQaF2hkK2J0aXl9sm8EsQHWB7ULhvhxLjMZ2lShcaoa3vmxugjvi0W5S+TQJEB/h
         DWsQ==
X-Gm-Message-State: AOAM530TCWM6y1Gu9xv2raECQyw0Ut/XcaLIxhq5YOSwhtPGvdnmmH8g
        ElbyS6X02MzV2oi3wYEU2sWd41O1Gk6ocokLTxiizkHxe9MJUflDEOSgfhsXEPekV2lpMEsDaHr
        Y57HQYo1QgkecstspeFa9Zkj3XojUgujJhA==
X-Received: by 2002:a05:6830:1bcb:: with SMTP id v11mr11602652ota.251.1624053858035;
        Fri, 18 Jun 2021 15:04:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1bahtyGa53x41WidzwyFgCcVxW+PsY5lEFKzqLLxQJsRyXgTP+B21L5nf31XFlHQryWU42Q==
X-Received: by 2002:a05:6830:1bcb:: with SMTP id v11mr11602630ota.251.1624053857818;
        Fri, 18 Jun 2021 15:04:17 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:44f9:bfd8:94bd:f2e3])
        by smtp.gmail.com with ESMTPSA id y13sm2355582ots.47.2021.06.18.15.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:04:17 -0700 (PDT)
Date:   Fri, 18 Jun 2021 17:04:16 -0500
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: don't change cipher type in bidirectional
 test
Message-ID: <YM0YYNrkihtExlTR@ubuntu-x1>
References: <20210618204532.257773-1-seth.forshee@canonical.com>
 <20210618144149.35192fcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618144149.35192fcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 02:41:49PM -0700, Jakub Kicinski wrote:
> On Fri, 18 Jun 2021 15:45:32 -0500 Seth Forshee wrote:
> > The bidirectional test attempts to change the cipher to
> > TLS_CIPHER_AES_GCM_128. The test fixture setup will have already set
> > the cipher to be tested, and if it was different than the one set by
> > the bidir test setsockopt() will fail on account of having different
> > ciphers for rx and tx, causing the test to fail.
> 
> It's setting it up in the opposite direction, TLS is uni-directional.
> I've posted this earlier:

Ah, so it is, I missed that detail.

> https://patchwork.kernel.org/project/netdevbpf/patch/20210618202504.1435179-2-kuba@kernel.org/
> 
> Sorry for not CCing you.

No worries.

Thanks,
Seth
