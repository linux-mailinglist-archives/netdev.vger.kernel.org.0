Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D5EF0944
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfKEWYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:24:51 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41976 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfKEWYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:24:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id m9so23702148ljh.8
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uEoXCcW50URE76YSN+2HHLXlNpxyEkZl6KQ83ZpmBAo=;
        b=rtlXhrK5I+KvNrBniPnTlGQiLGb51Z/oF6rvtHzH1g/Ccw6oPcqCZTGDbZSn6bhDuh
         e4pPhUtkOowU5chfv3dc++zv8Ubukw+mm+/3qYVYZpxxKaOgLCWr3hZ/YEvNHKpY+Ndt
         nbK24btLdXQzG7NMXOEQ8miZ8+JGODqUiTuqnAUc3DntzVJ1e4n6CN9VJiP41nmGfMDL
         y0zJezUGE8w4ljj/N9Fn+UUbYiajlhq3D4WJ7k0E85byetRRv3YgqrWr6/uJUZpZRb7s
         RVbVDtbZOtMALIdpRKGdaJBpLZQliVVzxxUpcLrrr5SRYaGZ/Ae9M2w7pSd+zW5UAmud
         QGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uEoXCcW50URE76YSN+2HHLXlNpxyEkZl6KQ83ZpmBAo=;
        b=pL/SRFchwAU27TyFiFVdymKodqns46ARPXvKi/M0Nwmd6J6qPbVD1NUNhx7Qu7mc9S
         zaHQ78VACfQAprpo+kCXSvVKgR55YZGciOhlSClul5Ac8jykhhhQRVcgze1MUxCU6qLT
         JBimA6UHMGGq0zsi9tzyNewp28CPdYpDUEjgdxYsNoY+Ag3zfpXlmhBkcZOq1muzHo3l
         5yjWG7hn+Exc2I8cVXLk7ncsPoTWnWfPNT2t46Aj6fCBxrhbFR0N2yjh8bojSJlm9vr7
         kBD5/VqPfhvCt/i/Lq4TceNp14jnnCsm46v3BLUMLHelPrWigXGteceMB26+g0MOpZlf
         3P3g==
X-Gm-Message-State: APjAAAWl35eDZp6/Jpe7RfynBTFgLckLwJDXaFZupqHQXAsGviub90Et
        PhvlehaFKynEU3QGB5tYpQ9ALg==
X-Google-Smtp-Source: APXvYqzhUx828zEyf5r4JRjmZoxXiSdV5PGx6Tb5wtoj1m7J5IjafH9Bf6nKeJtA9l17OUcVtJg3ZA==
X-Received: by 2002:a2e:b5d0:: with SMTP id g16mr25094261ljn.88.1572992689642;
        Tue, 05 Nov 2019 14:24:49 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s25sm4020139lji.81.2019.11.05.14.24.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:24:48 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/3] net/tls: add a TX lock
Date:   Tue,  5 Nov 2019 14:24:33 -0800
Message-Id: <20191105222436.27359-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Some time ago Pooja and Mallesham started reporting crashes with
an async accelerator. After trying to poke the existing logic into
shape I came to the conclusion that it can't be trusted, and to
preserve our sanity we should just add a lock around the TX side.

First patch removes the sk_write_pending checks from the write
space callbacks. Those don't seem to have a logical justification.

Patch 2 adds the TX lock and patch 3 associated test (which should
hang with current net).

Mallesham reports that even with these fixes applied the async
accelerator workload still occasionally hangs waiting for socket
memory. I suspect that's strictly related to the way async crypto
is integrated in TLS, so I think we should get these into net or
net-next and move from there.

Jakub Kicinski (3):
  net/tls: don't pay attention to sk_write_pending when pushing partial
    records
  net/tls: add a TX lock
  selftests/tls: add test for concurrent recv and send

 include/net/tls.h                 |   5 ++
 net/tls/tls_device.c              |  10 ++-
 net/tls/tls_main.c                |   2 +
 net/tls/tls_sw.c                  |  30 +++------
 tools/testing/selftests/net/tls.c | 108 ++++++++++++++++++++++++++++++
 5 files changed, 134 insertions(+), 21 deletions(-)

-- 
2.23.0

