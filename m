Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0C36D9141
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbjDFINS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbjDFINR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:13:17 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0A659E6
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:13:16 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id h198so1570522ybg.12
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680768795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s37AKX46druDkQMukFY2wjOtd4UDmaJrvLEgrvY9bU4=;
        b=nrSafKY0nVFK23NtqSDbq36ZroC2qJOvKZrGvQr2QkYsGlKAjzqDUxSK5MFpX+pIom
         zm1tokTzkYyxjOP1ZxjGw6rzdAIxm5xhWmPy0olG7nzGFJm3f3kw20jT7Ew1Asewhkbx
         TasrqL/9bXj7AGVSol29rvvYUk/37XyVnVWapWliLJJNv6jr5gDjZzwoChW1SAgF9+GC
         4UYPa37LhaCGR87mi5f1yVaQkjpm1l+5LCfn9IJPDPCKt/esnFUTB8gOdOHuVAaQs0S3
         Z+ZTHEWJAERRXGMF2nctXeHg5TQJPs343YSTVvNa07CtvJuIS4MxLK7I5ZCOY07ceeZC
         1Znw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s37AKX46druDkQMukFY2wjOtd4UDmaJrvLEgrvY9bU4=;
        b=zYu1JjjIlsjwJGZ7Xg/xqH8mi7wa0qfsJdZjwBGAs7I0TxGVCDZBVMXEGnvI6kNpFx
         gVr1LOe+yLqfQ5t45iB30GCncDDlhzdX4aEAXzVY7P35v0QKZik3WFcFWedpGP0exhSo
         xASaviRddHC0rhqH1dPN7y7MXKW9qYdDQD54rX8oGbXuZm7PVriWdZ7Yfnx/Vq5GWPPP
         Oftl8d/JMz3WWwdx/lukIDE79zTfayZBZpDPTRemvXghlqiCIyqsuVt4B1EpW8OhCvHk
         ctaybNNw8QwnfsQ4BDUA4FqRtZdZNDrXJASt61kYDLyTZpw1fO0hO0Q5UgoI5bmFxaI4
         DLgg==
X-Gm-Message-State: AAQBX9eNSgBVdVRGcvdDBKX6ABCFnfqStGfRhrBdWM3hm1U7nN3LWZJ+
        EfbNezi3l1NcAQkUyPhkghwv0tPRSiuIx3wzU2ZFxg==
X-Google-Smtp-Source: AKy350Zfk5N0s61DTsl9VnLEj+Ajk4UDuW7STcEJQQgs7kgMhWDYvSKMwIj3WKmJkboudvnSGA7KP7OZSeL2wh7bFyI=
X-Received: by 2002:a25:da46:0:b0:b09:6f3d:ea1f with SMTP id
 n67-20020a25da46000000b00b096f3dea1fmr1566211ybf.4.1680768795347; Thu, 06 Apr
 2023 01:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230406063450.19572-1-yuehaibing@huawei.com>
In-Reply-To: <20230406063450.19572-1-yuehaibing@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Apr 2023 10:13:04 +0200
Message-ID: <CANn89iJTKBVcF4agyJfV-TbtH12Uky=vkDJ9eoxKML9N0K7gAw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: restrict net.ipv4.tcp_app_win
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, kuniyu@amazon.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 8:35=E2=80=AFAM YueHaibing <yuehaibing@huawei.com> w=
rote:
>

>
> 'maxwin' is int, shifting int for 32 or more bits is undefined behaviour.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

SGTM, thanks.
Reviewed-by: Eric Dumazet <edumazet@google.com>
