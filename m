Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEAFE89E2
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388810AbfJ2Nrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:47:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37597 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388274AbfJ2Nrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572356859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AOZDZYv9EYsWU3DDUZnJ3QM3j0uLD33yFtGOQVV5kdk=;
        b=a34y9R6HXhO/Iw6U5Hb4ng9Bj+ceJQfw6jUbP0CHb0YOQYDVpQKuLxxV7H5VhPSfysVSCm
        guJ9SPtJR4YSd28cQV/ACSVxSpvqtv6jvTJgOo29afNBh/CDaWEanC6moDMXFccrg+ZNWC
        Cp36hKVGem4ZKpAD5t3q0qEZyCPWP+A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-T8pDluwRPCuM6uh_VsJ3hg-1; Tue, 29 Oct 2019 09:47:37 -0400
Received: by mail-wr1-f69.google.com with SMTP id s9so8388205wrw.23
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQTwbHy83mtQr77G3uSvn8MlfrVM//HDdD91jEPvl6g=;
        b=pbCdLYUjhG36NEiHmFGwve+cbKzCIYLZQFY4hBlOjZbekLZ6PINOO9Jj489B/jNzQm
         Dgwpl14yPYrEcNxrH4QDR1qRtZjOcKm098b3wJyQEtTapMl3SCFI5WJHFD5/tPoncs0W
         50i984x1TZhgv77fY9mHAsRwkAXQbOjYGXMLjfzv64BU6W3SkM9juGHNCS6G7FywDG+x
         Oro9ZQfpyJ4t6icjHddUpphsx8V/d4w8BvQGlxTCp/plTw5CUS6MwXBhb60oIP8DvW5D
         KfuWxqiBmIkSfNun4gqcOBL3XWE+8r6cmuXmgpxhwavkTvDQieQa3G6g83NnqleI7HJR
         Rw8w==
X-Gm-Message-State: APjAAAWATwOvgTceDVF6BqO4ARFgoII7HKjFiSHCwjMxPhWk3uUJTjKc
        kwwc9PaMd2ElmAgLkYetb7NfB0pzl+efismlukE8KWls5h4mboixR6Ez2fbVijtyk/bnNXvSBux
        KmCOn/Cike3I6JUs7
X-Received: by 2002:a05:6000:118f:: with SMTP id g15mr5234384wrx.242.1572356854901;
        Tue, 29 Oct 2019 06:47:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzliW861h/AGu6aqVzf4hjYXVlZi0TA4h1trMKB9KcWAVofSDtLty/EGGh6dyERP6OOYq3JRQ==
X-Received: by 2002:a05:6000:118f:: with SMTP id g15mr5234373wrx.242.1572356854705;
        Tue, 29 Oct 2019 06:47:34 -0700 (PDT)
Received: from turbo.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id f204sm2895789wmf.32.2019.10.29.06.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:47:34 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH DRAFT 0/3] mvpp2: page_pool and XDP support
Date:   Tue, 29 Oct 2019 14:47:29 +0100
Message-Id: <20191029134732.67664-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: T8pDluwRPCuM6uh_VsJ3hg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Last patch series for mvpp2. First patch is just a param to disable percpu =
allocation,
second one is the page_pool port, and the last one XDP support.

As usual, reviews are welcome.

TODO: disable XDP when the shared buffers are in use.

Matteo Croce (3):
  mvpp2: module param to force shared buffers
  mvpp2: use page_pool allocator
  mvpp2: add XDP support

 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  11 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 232 ++++++++++++++++--
 3 files changed, 220 insertions(+), 24 deletions(-)

--=20
2.21.0

