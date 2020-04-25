Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CAF1B82B7
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDYAZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDYAZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:25:51 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85106C09B049;
        Fri, 24 Apr 2020 17:25:51 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b2so11771901ljp.4;
        Fri, 24 Apr 2020 17:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jV8boHgUOS/pdyj9br5NN2uDVZis4I9hgoWkuGr8doE=;
        b=nyZ1Pz7tsmG0T/0T9uv9RSTUVYU5BNAkqG/l34W0MtyeFppfvvz74NpfUaxA+mcw0B
         fNGqfNZfVX3W27zljNqFcd8TGrkE/rTXGfobI3y5tfKBMxNLFK/NwK1jIV4D1jtnRlCU
         CN/2pCSonrYU69vx7MYnVT277zHQGoDDEZUT2jy3rH+h44dzf6kWiZ4ynTTiWMCIf98j
         EDjqESdCbGd2Ysz//gHKzQnCl3smuxf8hZ00qFDHQRNMndZr/lmxjN243qBYnzraKc6W
         eAwT3Ahq/yhBTw5ZQilie6EDOZzgEYCTS6NRlQdu6GvmOtFZg+VqYd2b3OGMP0DXwUSJ
         YsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jV8boHgUOS/pdyj9br5NN2uDVZis4I9hgoWkuGr8doE=;
        b=qhr5ZCFgeymlVlo6Hy/5gD7U2zhPBKl1pr7HDhBtz9tzo5rEIDPdirJgw8DMcFnEKy
         Wq2Re7xGRYS75mPfxWS0HyUU037cZ9B9n+dWsk1EAkMRXdYeYOy7v6xm9vaZXarMOUFZ
         npe7I8xrlANnRVZJ0kqCXalsIGbVZu49/rPFYyVk45or7+pspT2wuyNQ/v2iWxT8krX0
         pxi5oAOTY69huHr6THueVMxpKI/4ZCApV3Vf2hnLbjYo+9G5p0XGVDPd4+2TKfWXlrhC
         VXdamvIvKRgLqJhVwcF5nZyT3/5OaGT5wasXknjoTULvvhwg+m6dULxBkN8TPoCX+Bgi
         9D+A==
X-Gm-Message-State: AGi0PuY2teD/Z4J5Pn9o8tPMOcZCADN2+tAlG3T8oRtAyq7VM/9fXH0V
        8IqYZC8W+4zZy6cHWS2JCb/RF6ScfdgI6McrgHI=
X-Google-Smtp-Source: APiQypIbhn2hm1fX0cDvwytvFW2Y2WKiZbLh4hJXcbbkvHgVH04GNxZGgTRuK0R7uvxKLf6IJqd6HFcrr4IIUhNxEH0=
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr7044039ljm.215.1587774349870;
 Fri, 24 Apr 2020 17:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200423050637.GA4029@udknight>
In-Reply-To: <20200423050637.GA4029@udknight>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Apr 2020 17:25:38 -0700
Message-ID: <CAADnVQKdZtzzJ=BD8Get-+kFefDeYrqSiqUVGFe9p++hifwTXA@mail.gmail.com>
Subject: Re: [PATCH] bpf, x86_32: Fix logic error in BPF_LDX zero-extension
To:     Wang YanQing <udknight@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiong Wang <jiong.wang@netronome.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:18 PM Wang YanQing <udknight@gmail.com> wrote:
>
> When verifier_zext is true, we don't need to emit code
> for zero-extension.
>
> Fixes: 836256bf ("x32: bpf: eliminate zero extension code-gen")
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Applied.
Please make sure fixes tag looks like this:
Fixes: 836256bf5f37 ("x32: bpf: eliminate zero extension code-gen")

all 12 digits.
