Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60C635ACEB
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 13:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhDJLW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 07:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbhDJLW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 07:22:26 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3703EC061762
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 04:22:12 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l4so12543198ejc.10
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 04:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=h97NT6e0USV1yMZ1LGATTQ30XfWagRjEerkhzUe+N5w=;
        b=WsG8HapFTd/361MhHAUkCYQdaJoCo3QE+SSREInHOK9aqYmowpL05YY2l32PmDigW1
         UozVyfsak5UwNOeSanZAM4Ki1Mo4BeAhZbfa4r1q2FTlhoYs0QtNUsx3DiuvTQV2fGgA
         F6l+6+56nB7aJpqpkaltYGgD+vmFLvmf/lCirRRyndmhhblwVDv4RMY02vV8ibGuSDci
         DG+fkNiPWs4K1fbkpi/rWD0XMP2v6li/QkhP4vIZziueetGMsp6XrjNG16u6DHq2HBW8
         InxYIv+ymb1TYrCeXfstyecuYVnhbR9gxugSJf3CXlS7E9Uq1EVjSXqEauxZoU/EUyTi
         gAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=h97NT6e0USV1yMZ1LGATTQ30XfWagRjEerkhzUe+N5w=;
        b=hA9iHkqd5YnujgeQRqU4oF3PmEYKp24BgcHWyrAakb346xPr6PIW8Yb/mNKW1WGtMn
         Scr/Pg+Ywp9As9lEekgiG7nYjFT1IAM92Qa7YpSSsTwteoLRrW0JZHwz734AqlY7L9E+
         xBK1HlrRKA4DVkk+j99/dqf5zMs/XhBp+wNzwikOb7imJ5+oUEqzhBqCJRmO/uFG2rvH
         6KU79iZEX4PK6cKbMN2vNn0q+OacqDsqmin14nPh4ed7jH9ZuQ0c/ElIKl9i+Gwe6TGO
         OZCsyztXX+CUla+9mwsmlYTJad3cV008K0GQDGAPh3mKiL0DxQgclo5EzrzIcRTQXM8/
         Gtvg==
X-Gm-Message-State: AOAM533M9PlFsRy2BtnUtLWi/ErOqntkmErWV61LIKbi9g2k1Ot799/M
        RewWSbkTLRC6nPQ4zqkNcUl1w0pVVUPMsA==
X-Google-Smtp-Source: ABdhPJy1kfzum9zpuqGFONuNcG9i64Mu/TCojT6RqCdIK52i0E1c1w1Q7ebcM6PWH+OdfnN+hagiJQ==
X-Received: by 2002:a17:906:c290:: with SMTP id r16mr822103ejz.241.1618053730735;
        Sat, 10 Apr 2021 04:22:10 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id x1sm2531202eji.8.2021.04.10.04.22.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Apr 2021 04:22:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Bug Report Napi GRO ixgbe
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
Date:   Sat, 10 Apr 2021 14:22:08 +0300
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F81F217-6E5C-49EB-95A7-CCB1D3C3ED4F@gmail.com>
References: <20210316223647.4080796-1-weiwan@google.com>
 <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
 <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com>
 <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com>
 <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
To:     netdev <netdev@vger.kernel.org>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi  Team

One report latest kernel 5.11.12=20

Please check and help to find and fix

Apr 10 12:46:25  [214315.519319][ T3345] R13: ffff8cf193ddf700 R14: =
ffff8cf238ab3500 R15: ffff91ab82133d88
Apr 10 12:46:26  [214315.570814][ T3345] FS:  0000000000000000(0000) =
GS:ffff8cf3efb00000(0000) knlGS:0000000000000000
Apr 10 12:46:26  [214315.622416][ T3345] CS:  0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
Apr 10 12:46:26  [214315.648390][ T3345] CR2: 00007f7211406000 CR3: =
00000001a924a004 CR4: 00000000001706e0
Apr 10 12:46:26  [214315.698998][ T3345] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
Apr 10 12:46:26  [214315.749508][ T3345] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
Apr 10 12:46:26  [214315.799749][ T3345] Call Trace:
Apr 10 12:46:26  [214315.824268][ T3345]  =
netif_receive_skb_list_internal+0x5e/0x2c0
Apr 10 12:46:26  [214315.848996][ T3345]  napi_gro_flush+0x11b/0x260
Apr 10 12:46:26  [214315.873320][ T3345]  napi_complete_done+0x107/0x180
Apr 10 12:46:26  [214315.897160][ T3345]  ixgbe_poll+0x10e/0x2a0 [ixgbe]
Apr 10 12:46:26  [214315.920564][ T3345]  __napi_poll+0x1f/0x130
Apr 10 12:46:26  [214315.943475][ T3345]  napi_threaded_poll+0x110/0x160
Apr 10 12:46:26  [214315.966252][ T3345]  ? __napi_poll+0x130/0x130
Apr 10 12:46:26  [214315.988424][ T3345]  kthread+0xea/0x120
Apr 10 12:46:26  [214316.010247][ T3345]  ? kthread_park+0x80/0x80
Apr 10 12:46:26  [214316.031729][ T3345]  ret_from_fork+0x1f/0x30
Apr 10 12:46:26  [214316.052904][ T3345] ---[ end trace c7726a0541128b42 =
]=E2=80=94

Martin

