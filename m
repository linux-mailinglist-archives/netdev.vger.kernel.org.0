Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926B2F4C15
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbhAMNN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbhAMNN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:13:26 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C23C061575;
        Wed, 13 Jan 2021 05:12:46 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 18so2122996ybx.2;
        Wed, 13 Jan 2021 05:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ZM1NJioel4M66Wv6WkWIoMAY0vNPXOkS6Y95M9Fqtp4=;
        b=II//dHYhJKfqntuOSd+wyYjZTAXDxFu7wseVJTatnSM7lwANbcz1y1slNkdACJQ4QO
         V+KQqck59jvRwPofOEc7qnGK+APb3eluwhYyiXg0CWSsLpWdu8U+3zMuBwaXRWa6hPGV
         x1PWUkU/GoMsRuJ4I9J3jT5RgQnaN97/Mr3hSGRY4dEEo2GDwqT6xF4EQFybjLs6WLDc
         JwdhEME6a8jMvmMAJdt+yOpb1rH3m+aXOn9pWn7LY8uwTi5iHwZony2oDhDfKAcns3o+
         suhzOc5SRJMf5SNqUcIbxjy0MFjRwyuo+9TzO2iLf0BfofQmXVrBd0cOloXj3tAW5Jfq
         GL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ZM1NJioel4M66Wv6WkWIoMAY0vNPXOkS6Y95M9Fqtp4=;
        b=OtiqewB22y8u1Vh9vvf7n7lgcHGI0jcfsL9yPRRxuU6d6epJsSdr7t17G5uN/U3JSU
         +DiosYu4SBdzyWIOFUBsQg3N6LJVLSAxL/TofAeaPBibVIWfJc7HCsykm0YsWm4BTMLf
         1zKWLy/9C0BhNL4p0APYsyLX+WSqYTW4pBBuJ+SIv0wB1IzuUfzN4P3HfAdsYvQEMvsx
         jU4HX75i53OfHgbLIleHNjpv8d7Cftukr4ORjXXbVAKxDuhbIORH4EomJrBcnYvbKVrE
         7tFLrbO4hPJ+ybiyxllk5983i+ETE088+QviiOt9rIK/bmbhDIK7Sd/3agkDtpx2bWxL
         Zwvw==
X-Gm-Message-State: AOAM5330rq7C1dRIY2/D5f/yIYQaVOkOmByj3mD5502GGpxFrULmDHU1
        k4F9tnA2U7fZxrEI+E4plzY/O7S02Ds/BMBbPd0SueDONJoDhSl1
X-Google-Smtp-Source: ABdhPJz9qP4YyI8w0g+/ScsAbWhgMM8gPmAmAoUVtFKNOjw3zB/1pK5MUeUalJ4oIYx/krzqLuwXWXYh5b/Pd/r3S6Y=
X-Received: by 2002:a25:3457:: with SMTP id b84mr3006251yba.167.1610543565396;
 Wed, 13 Jan 2021 05:12:45 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Wed, 13 Jan 2021 21:12:19 +0800
Message-ID: <CAD-N9QWYDUHhG1vRMOCRniHW3vk6VDLmiJmKWC+h_H_23RvEFA@mail.gmail.com>
Subject: "WARNING: locking bug in do_ipv6_setsockopt" should share the same
 root cause with "WARNING: locking bug in do_ipv6_getsockopt"
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found that on the syzbot dashboard, =E2=80=9CWARNING: locking bug in
do_ipv6_setsockopt=E2=80=9D(https://syzkaller.appspot.com/bug?id=3D6a970baf=
20aa5a64455be86fb920f468def703c6)
and
"WARNING: locking bug in do_ipv6_getsockopt"
(https://syzkaller.appspot.com/bug?id=3De97be0bf4d30813e951bcc6249e72c592a7=
90164)
should share the same root cause.

The reason for my above statement is that their PoCs have a high
similarity except for the last syscall - "setsockopt vs getsockopt".
In the last syscall, when it invokes lock_sock(sk) and accesses
sk->sk_lock.slock, the WARNING happens.

If you can have any issues with this statement or our information is
useful to you, please let us know. Thanks very much.

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
