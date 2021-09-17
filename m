Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A884540FE1B
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbhIQQp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhIQQpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 12:45:25 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E47AC061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:44:03 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id a66so19325152qkc.1
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p7yZBds9lydxwwoqLr0zoPmawjAek+2Vkh5n3xlOr3o=;
        b=X+yAZLY+uvI5S7F+pdIBcYjNLfOKZ155b4U7wi62kL61ME280kBVXMirGgqK8MrFYu
         GsiqeImuJSevCuhrMjoEOycljj0CEvWUu8YwJ1yMGejJnn4pa4fyQJzEkbFf1p5GEiYc
         DgNY359HMQviIJt80jeAmtptEoy8ezNYJYllRTcWHQvlgckDr2cRBuJmNOn4N2P0KCrB
         2HCab35jq7B3uI2SM+RrFM2qSkvdl7jzp47AvvDvXQBJ3Q6cvPzhQTMF/L6mf8oYMeqa
         mZ6lCYKV675N3jshXtz8Q0J6kekAwswr7Z2IxiOaFZw6zgHesaK2zR6OcXnr4OE1HVgT
         ZyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7yZBds9lydxwwoqLr0zoPmawjAek+2Vkh5n3xlOr3o=;
        b=t1k5YrRPHCQlDNgWB8xWtLsFS6lLeVDaEPDQcpbmMuM5ReO1DsXpIfsH4opO/VgZ+Y
         auB4OnXiFxqdpNhFhGDXQtU4N4YTHW32+v0ox/dXKkzuiTSCbyAM/Bz+sk5EYGntnuxP
         vz8ADbuzfsvpfT5MRBL3nzf/Pm7Tn5KsSb0R7rvjynCCT8kjYIpYQFs2YGxxajKIJyZG
         VNSXUsRnPOGZZUrxmtHombvAqlSuPlvJJSHYVdVzpg333Sszurg2n0V1E/NDPA7Vz19T
         Pzz03RAITi0lGgurZkJqzNWbaz65lvBuBVMw+MaxaAPCLosIFGIpZNVZ7CX+1UZUrTZr
         XJHw==
X-Gm-Message-State: AOAM531ZwH8ANzCuYPXVxMYHTUDjMpTs+HJ2rTaalYgMcD6MRdJ4F0sq
        wrhPo7F3TGcrcVSdZaJE1hzUkvrRj0YSpq7cfLM02g==
X-Google-Smtp-Source: ABdhPJw+qhgRa7iDjf1PHndTiwVx3p4cESeItjgI93bD49ddqAM0XycaWkxQVE6vgh0rBwZLyhcFvW9+8G2GYztI7cU=
X-Received: by 2002:a25:2b07:: with SMTP id r7mr13038210ybr.296.1631897041942;
 Fri, 17 Sep 2021 09:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631888517.git.pabeni@redhat.com> <07fd053d2c2239e70b20b105ff6f33d299dabea7.1631888517.git.pabeni@redhat.com>
In-Reply-To: <07fd053d2c2239e70b20b105ff6f33d299dabea7.1631888517.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Sep 2021 09:43:50 -0700
Message-ID: <CANn89iJOtSJ8JFCThtxjRpZQ9Q44LTs-dDxypEA6Hkho9KdxWQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] tcp: expose the tcp_mark_push() and skb_entail() helpers
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 8:39 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> They will be used by the next patch.
>
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>

OK, but please rename skb_entail() to tcp_skb_entail() :)

Thanks !
