Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5AD2EC937
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 04:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbhAGDyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 22:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbhAGDyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 22:54:09 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51B2C0612F1
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 19:53:28 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id b10so3477744ilr.4
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 19:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XyHpdjFK5KCcsW0NSpl9XnpAqw+ZRpYJG1t42ebeRWo=;
        b=SPWYmIY9vsS1JyXcShgnrzBhLy8k6kYriNR4QjGS/pWGakxs7YeIfJyaMCQP4BFMma
         fbvFhMdptYQ9X3pFL4r3Z27hWnpqT8AdgDfNuOf7NunJMVRS6YYvu9wvPS6sxQY8xhWA
         euHDsvZTZvmvNR/9RcFNPlf7hMFUFPYCkDwMaE3dGpCJX74lAY/jPjgszF02ZzVQhJE9
         8ySGAgCjtx3cjxRk6hjTcRNeuvcDSfb0YsWQAlyEF79ITC6qejv85ga8ntFAUiCDSPKq
         ZhEJFnWOg1yK9FwiJvaN2L4iyO9GVaHmGBhZPC8xpHqn7caacAiYg6W8NHEP35RGL3Nd
         Dixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XyHpdjFK5KCcsW0NSpl9XnpAqw+ZRpYJG1t42ebeRWo=;
        b=nAQjaLsLnGC7wxvaFkf/gq9wZsCM9yDlBTKLGUE1atj/Ykr7YnivDhUi5iYyfv3Ntt
         7v+BpmItintBhFmA8uw1pQWlsUKOBxw4gFoTdJt3iRoYTKwjwftdmVVtsdYwqcgpdFRy
         hzipUuw2RNOJrK6r19y2/0POtCLxhnX0Oc/LIDLzr2+ZfTPy91o15qWxcmnlYujCBPm8
         Ip1HR05o225sn/o4owE21WA5wWfRCYI1dHQxT2iTTg0TtR6if5TvianScoShuis0se7z
         667GSM4uLWsu/2/8bVRs1mCq++4dihBnTEkhQvLYFiJdB9K70Sso2LyAYHGCg+Wu4vdU
         2BKg==
X-Gm-Message-State: AOAM5317Rkym6/MXR0hdqJsCzhqSbpuF3Pv+Y0CvA55RSlrV7Dnn73ow
        lyH1o6Nupih3Qbz/6FClp/8PXmQRUk8cBKAy/Us=
X-Google-Smtp-Source: ABdhPJyL5H1u173j8+/k5sNclHrMPvc2YioITm+uJGRziIFFldhZjbQuxhgSjT2TeVdtl+MKB876S+yjgqraD/iLJbY=
X-Received: by 2002:a05:6e02:154c:: with SMTP id j12mr7324771ilu.33.1609991606821;
 Wed, 06 Jan 2021 19:53:26 -0800 (PST)
MIME-Version: 1.0
From:   Baptiste Lepers <baptiste.lepers@gmail.com>
Date:   Thu, 7 Jan 2021 14:53:16 +1100
Message-ID: <CABdVr8RVXj3dg-by_W99=fPSjdfB7fYXFRBW9sropQpYKD1xOQ@mail.gmail.com>
Subject: Possible read of uninitialized array values in reuseport_select_sock?
To:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

While reading the code of net/core/sock_reuseport.c, I think I found a
possible race in reuseport_select_sock. The current code has the
following pattern:

   socks = READ_ONCE(reuse->num_socks);
   smp_rmb(); // paired with reuseport_add_sock to make sure
reuse->socks[i < num_socks] are initialized
   while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
        if (i >= reuse->num_socks) // should be "socks" and not
"reuse->num_socks"?

The barrier seems to be here to make sure that all items of
reuse->socks are initialized before being read, but the barrier only
protects indexes < socks, not indexes < reuse->num_socks.

I have a patch ready to fix this issue, but I wanted to confirm that
the current code is indeed incorrect (if the code is correct for a
non-obvious reason, I'd be happy to add some comments to document the
behavior).


Here is the diff of the patch I was planning to submit:

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index bbdd3c7b6cb5..b065f0a103ed 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -293,7 +293,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
             i = j = reciprocal_scale(hash, socks);
             while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
                 i++;
-                if (i >= reuse->num_socks)
+                if (i >= socks)
                     i = 0;
                 if (i == j)
                     goto out;


Thanks,
Baptiste.
