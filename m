Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906222DA18B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503250AbgLNU3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388483AbgLNU32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:29:28 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8D5C0613D6;
        Mon, 14 Dec 2020 12:28:48 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id w5so13998113wrm.11;
        Mon, 14 Dec 2020 12:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYz9C6YD3FEkzjCSdbhYO1FB3acxpS4StIQeo8xxPj8=;
        b=XOk6q5YGwqBboi+LzhjIvj3EY6tdEIyNvP4EF+1pDAflJRa68g9P2J0eb2Hbf43scc
         IBylFOkmthT8tk1BwDpIQVI1CtbF0yHdkYHTco+/TsGTWI0rZjvgnUGBr2j9xRCXO/RL
         fLIEmONy+6tDpT+AI0uHCd0BH8BPvleJFkUKcPa8hevmAUgrD1c700BDxnE17U+LIxb7
         cMSSGaA9TNLT3RyxJ1FZ26JDnPRggV0uEhmzOhhJhzg/uoMeafep31m5AhlbR/jebj5W
         wV3BkgBTCun1nRD+Cfe3GMyp/VP85eLdLRoR3C00XCX5cNqtSjq69pcYQKtq/cAQmwhB
         AqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYz9C6YD3FEkzjCSdbhYO1FB3acxpS4StIQeo8xxPj8=;
        b=KDlF05QT3RLKx6x7upPWR42d5Dgi/xbaLGyHac8YaUdRoZp8FASgT7rNWkRH2NMuTH
         dKXiyXQr9u8x+ucnl8xlgyDELS21CoYUua82/jI6R9nKKZ6+LJEJ95oFBcco7/sqeFkt
         Rli+98ILOLZKFyEKYDl9IXDUZVU2Us+5YwGDT6OzXGO1mEpTc7oLruRW+/FXmHp3HK+s
         bhfiegamhfeJQEg8LwJjrfMI2NqG6Nsy0Quif7LLUWZDhKKFL32jKw/+XIq6U2CGwqmn
         9jYg54e7EeKyAE6ufrOYGa54Cz9PifNdZAHdK1ifwG/JbIKeOdVeAEQPg0rsFQQAtrGX
         pr4w==
X-Gm-Message-State: AOAM532xCxD9hFM5NDXKyL9h+/eIj8TkGLfvEck8VOrCHQOcL63Plvfu
        ezu13XFhuhojanqv2ywrn9g=
X-Google-Smtp-Source: ABdhPJxk6DpbqGHOwmIc9NJHWYITU05nkO1Y2QvjIJHNF7uz3Em4hf/VjhgRPl5sLaLKVCbei4SO+w==
X-Received: by 2002:a05:6000:124e:: with SMTP id j14mr24793761wrx.310.1607977727049;
        Mon, 14 Dec 2020 12:28:47 -0800 (PST)
Received: from localhost.localdomain ([77.137.145.246])
        by smtp.gmail.com with ESMTPSA id r13sm32706175wrs.6.2020.12.14.12.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:28:46 -0800 (PST)
From:   Yonatan Linik <yonatanlinik@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, willemb@google.com,
        john.ogness@linutronix.de, arnd@arndb.de, maowenan@huawei.com,
        colin.king@canonical.com, orcohen@paloaltonetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Yonatan Linik <yonatanlinik@gmail.com>
Subject: [PATCH v2 0/1] net: Fix use of proc_fs
Date:   Mon, 14 Dec 2020 22:25:49 +0200
Message-Id: <20201214202550.3693-1-yonatanlinik@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the failure of af_packet module initialization when
CONFIG_PROC_FS=n.

The commit message itself has a pretty thorough explanation.
I will just add that I made sure this fixes the problem, both by
using socket from userspace and by looking at kernel logs.

This also fixes a similar error in tls_proc.c, found by Jakub Kicinski.

Yonatan Linik (1):
  net: Fix use of proc_fs

 net/packet/af_packet.c | 2 ++
 net/tls/tls_proc.c     | 3 +++
 2 files changed, 5 insertions(+)


base-commit: bbf5c979011a099af5dc76498918ed7df445635b
-- 
2.25.1

