Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A563B188B88
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCQREp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:04:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34013 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgCQREp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:04:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id z15so26655300wrl.1
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 10:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cyH4ajC0akIqyAx+ph/Apx1aDBXqX//MLpu6/L9jiK4=;
        b=vaJRmXNaqklnjWYRCeodm6/k5DkKqanHZPFOXDQzlddYti0kIODHBguuIMieOnNlRZ
         Ecwos9nnmXJMgYTMZ9SGSi6jhfOHrg3EozBDdPLKsb/U16/jhIYzywShDGdKD4D94AyQ
         JUs7x0mRGxDsPbOCIlg/7sV6GPpXsrb/NUldw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cyH4ajC0akIqyAx+ph/Apx1aDBXqX//MLpu6/L9jiK4=;
        b=t7PY93l7pPb4VxBdZ4Um3ldlF5UAhjBqWpFK80k2462uBBfGUwNLvy8n4SvEaafM/n
         n6nboHdxedfbmirnuqCv5MbqKNNRs/bWRCOV1OajHLdI/O/RcNXi/F7upkeqkuatMXI5
         83WTCaCfc4bEinpCsUUtRrpQsVO2xknQZCRWNUnVCvNX8++9enKNQiZrBDVYGFjUCgY1
         /ypC7g7g+FhgTEwFOggO7ijY6m5BIFYpUbZ3YdS1aClRzybGl78nQesqPkGAlr3yQ8FV
         7PDNvurN7PsFgPskKmL09MHQLsHzZaKaXTMtrVtIDcymZWaI4yxKRFo81UPdKqYTBuU6
         55MA==
X-Gm-Message-State: ANhLgQ3CMzw2g659I/UThDhEHudMCCq4oJ8HSvxctB82JkcUuIPRJrh3
        50Ui7DgBEfbRm/UC1nueliyiUFQu43tYQA==
X-Google-Smtp-Source: ADFU+vtURmRdSv3GHu+us1zBIMa9dsCiYpOad6MTYXAf3YsrcqYR8XjmQTayBCMiUuf//OBGrnc7IQ==
X-Received: by 2002:adf:f081:: with SMTP id n1mr6951586wro.161.1584464683491;
        Tue, 17 Mar 2020 10:04:43 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s1sm5248205wrp.41.2020.03.17.10.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 10:04:40 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next 0/3] net/tls: Annotate lockless access to sk_prot
Date:   Tue, 17 Mar 2020 18:04:36 +0100
Message-Id: <20200317170439.873532-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have recently noticed that there is a case of lockless read/write to
sk->sk_prot [0]. sockmap code on psock tear-down writes to sk->sk_prot,
while holding sk_callback_lock. Concurrently, tcp can access it. Usually to
read out the sk_prot pointer and invoke one of the ops,
sk->sk_prot->handler().

The lockless write (lockless in regard to concurrent reads) happens on the
following paths:

tcp_bpf_{recvmsg|sendmsg} / sock_map_unref
  sk_psock_put
    sk_psock_drop
      sk_psock_restore_proto
        WRITE_ONCE(sk->sk_prot, proto)

To prevent load/store tearing [1], and to make tooling aware of intentional
shared access [2], we need to annotate sites that access sk_prot with
READ_ONCE/WRITE_ONCE.

This series kicks off the effort to do it. Starting with net/tls.

[0] https://lore.kernel.org/bpf/a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com/
[1] https://lwn.net/Articles/793253/
[2] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE


Jakub Sitnicki (3):
  net/tls: Constify base proto ops used for building tls proto
  net/tls: Read sk_prot once when building tls proto ops
  net/tls: Annotate access to sk_prot with READ_ONCE/WRITE_ONCE

 net/tls/tls_device.c |  2 +-
 net/tls/tls_main.c   | 28 +++++++++++++++-------------
 2 files changed, 16 insertions(+), 14 deletions(-)

-- 
2.24.1

