Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFCF369336
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbhDWNaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242831AbhDWN3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:29:52 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1507DC061574;
        Fri, 23 Apr 2021 06:29:00 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id n140so49148405oig.9;
        Fri, 23 Apr 2021 06:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y1gBJg1wNiF48iNRaNfe3ZEbPyJ9l2Ym90ig/tAn1p8=;
        b=obP2f3+4lfEBJ3fJPP/4CBQgSlB11ToPMMEldOtp6mhLaGAuiy+R5cs5gtN9sF4FPv
         R5c7lHWO5Qym786/QRzmNke586V39gFPgytIlDneW1XpJLIDc3EKDVsMMuWz3oVb6FD/
         /quJW50IvbTn3bzUg+jCyLMS0BLZHvUAvuYXmA5ySyL0slR+PdpEVitvnD6+0BbauXzK
         tTb23Ur5lBl5ofRmiGOyZ+6gAaDIAL79gs7/LEOBZoKUtYv9UQDp4wveR/VfFbENgnIR
         TEwYKylprWWYYx70LwJtU6Qpo2KEbdaXmKFH04t4uEeA76ZjiE4nkqlFjGnpcFubIEDg
         IPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y1gBJg1wNiF48iNRaNfe3ZEbPyJ9l2Ym90ig/tAn1p8=;
        b=bRbEi/jGvcnvgZAS0SaonvIcEhvV3Qts6AZKDag8dqUN+qDyUKkvwX/22msvYf0mCE
         ZCafnaa7HPeLF+NPiok4cf+gv5wTRlaFozZkdsPe4bFihCaT5pSceq8fbsUgI6Uztbjx
         P4TLiaqD8o0ZSCOtOwZzCMYPk2CpIYaK3blWec2OJZrG+PxZwEBHJJ+BCKIfeMsz6cnv
         pNcJSErFwuLLlrpzbo7nun+4mqeTFj+WlJee+xtIIYYU29njezv0JHn/Uwoaroe0eqq1
         Teyp5mAD2pzhgg3IaKNdVGB9IZdoF3yWgcU6D5XDS6psvvbRw4Ko0g43LvsY9VImo67Q
         rRWw==
X-Gm-Message-State: AOAM533P6s3dnnckPVHpnSvKitTCgjaGA5mKdH8uJKwM+CNHQG/kvbOq
        EpTspHQNOX0CXRGdBf3XhtghXM32uWjRbixXMzZGFMSPg4o=
X-Google-Smtp-Source: ABdhPJx7hVwDesQiu1eC2xkdFULBs7lVcCoOoVg9SWzRt4OkI7MOD3j1rpUpWsE+MZvUCgu6l9WEUer8Z3ysVmvURzM=
X-Received: by 2002:aca:408b:: with SMTP id n133mr4025566oia.13.1619184539540;
 Fri, 23 Apr 2021 06:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210423040214.15438-1-dan@dlrobertson.com> <20210423040214.15438-3-dan@dlrobertson.com>
In-Reply-To: <20210423040214.15438-3-dan@dlrobertson.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Fri, 23 Apr 2021 09:28:48 -0400
Message-ID: <CAB_54W557gEShnirMUfa1Y0MM0ho=At-sbuW10HbY=HEAX91AQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: ieee802154: fix null deref in parse key id
To:     Dan Robertson <dan@dlrobertson.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 23 Apr 2021 at 00:03, Dan Robertson <dan@dlrobertson.com> wrote:
>
> Fix a logic error that could result in a null deref if the user does not
> set the PAN ID but does set the address.

That should already be fixed by commit 6f7f657f2440 ("net: ieee802154:
nl-mac: fix check on panid").

Thanks.

- Alex
