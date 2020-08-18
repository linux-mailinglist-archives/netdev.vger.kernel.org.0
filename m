Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588B72481A0
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgHRJPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRJPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:15:04 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8856EC061389;
        Tue, 18 Aug 2020 02:15:04 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id a65so15695030otc.8;
        Tue, 18 Aug 2020 02:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W2hKsTS1LvaI0SOO9W3/5fRfJY5aEh/BZWVO9XitBWs=;
        b=eGoDITciADrWQe3gs29cyT8xT1NKm5rz9rVcVLDn/bbuYp8fgY1hSDfcgcO2Y8A/FE
         zDJ9bm6G+z2N4IP6u1ELlhwB/iZ+1A+IwLuPDXV50yqTfWBpi2yoklrT0psD6GdMzRGm
         mKZXpjNtcSxOPcLuAlO8t6rlea5KpMBIJZl+zd87Fs8FGCP4YglR+Cy8uqT+GzI0stq3
         viuaxAQxm/6lWfM0J1ue15DTH6MQ6CtMtlUoD1oYGIxuyF9v8tv3Vn0TjcM5dSCK8JbS
         fjcwz39yKbHCwapnbDs3GWnek7Qbumu+oEcYnimX4XO6Q66JRWEkGZLHrLAcc8kim4hs
         +0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W2hKsTS1LvaI0SOO9W3/5fRfJY5aEh/BZWVO9XitBWs=;
        b=Gg+gEN8DUXLNvd3H4jM2RyIIxCbIyZqazH6jdWzal0lIUTvhZ8zjq2ws+ZwsblG3W6
         SV0/LrC8a1jWrvZTG9CFDk9sutJWvHr34r2B3y4IJxgBYWiiIHVEoRZ5oHl9IqIi3hvb
         xlPRm6rnxr2580QuVR9DR0FD2lyJnYs5sccc7wju/2wIrB4Bo2ePAQuZtzOG+zgOpOQ4
         /4mH59nkYKC6lQOFzR12ec8rDUxHGJyTxs12CofLm8HqqKDgAMf4bdrCHEpMaajMBrEc
         SY6ejebc95bw4Y0T6hesUgDpDDuHzYooxTVjRaoX5xQ/0qIeT+sVqGPJo1GLaDVE80HC
         EuVw==
X-Gm-Message-State: AOAM533C+t6/sLu1xMpNWQjk+UxQaSLw48k9x28hav1/9fyNDFL5fNEA
        8iMh0vebwTV7a8tzAOoC8aMuuxe+d7dMosLcwPs=
X-Google-Smtp-Source: ABdhPJzzm5zuxz1BYxytortJNZi40aPY4mo/p0dwJ/cgscBmXy1XrUh5q88EuMzxIjKgJBVv2+jBuBgNQfstKNEw2u4=
X-Received: by 2002:a9d:774d:: with SMTP id t13mr13781704otl.108.1597742104000;
 Tue, 18 Aug 2020 02:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200817082434.21176-1-allen.lkml@gmail.com> <20200817082434.21176-8-allen.lkml@gmail.com>
 <20200817083216.5367f56a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200817083216.5367f56a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Tue, 18 Aug 2020 14:44:52 +0530
Message-ID: <CAOMdWSL0e8iakwc2FUnF8epMme5eofrUMzrG0MjcBvEz4cimKA@mail.gmail.com>
Subject: Re: [PATCH 06/20] ethernet: chelsio: convert tasklets to use new
 tasklet_setup() API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jes@trained-monkey.org, David Miller <davem@davemloft.net>,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com,
        Kees Cook <keescook@chromium.org>, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> You need to adjust kdoc when you change functions:
>
> drivers/net/ethernet/chelsio/cxgb4/sge.c:2664: warning: Function parameter or member 't' not described in 'restart_ctrlq'
> drivers/net/ethernet/chelsio/cxgb4/sge.c:2664: warning: Excess function parameter 'data' description in 'restart_ctrlq'
> drivers/net/ethernet/chelsio/cxgb4/sge.c:2965: warning: Function parameter or member 't' not described in 'restart_ofldq'
> drivers/net/ethernet/chelsio/cxgb4/sge.c:2965: warning: Excess function parameter 'data' description in 'restart_ofldq'


Thanks, will fix it and spin V2.

-- 
       - Allen
