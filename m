Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784241611D1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBQMPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:15:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53540 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgBQMPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:15:34 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so16930539wmh.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 04:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xqYm6wF8L0TX7f4HXgw6QZrFLaxswQUGOedy6hxkX+o=;
        b=QrsC1KbRJWJlaLS8bMEq9P3Wu988FELiXZs1gwaizwQ5gMmyQrKFHwTpRp0P4IJ8es
         ZqrV+qraYmRnw/vzjLHMZhEPa4UevxAqykK5JIIDYETA+327ZwjegSVboF8dcosuPUwI
         WM12exfktFIVVMOJNWxm5QfbfwD1/G/IiflQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xqYm6wF8L0TX7f4HXgw6QZrFLaxswQUGOedy6hxkX+o=;
        b=ktbaOgcfKpZTohNrB2kiropbH5vLBZu9PwTmyrl9r7GUQgxTa8Jq4eoZCrBNLf3FDR
         onG8P4YitZIdKHQZ2YUZmy00BxYe69DbtiD+Bm1NW1GBompZd70hmhsNNt1rll/azH/o
         ZXN0EBaahnoqARlwD1Xchr1dyrgTMsB/P3eAIwh0+f5WWxmRLWilGbEUGyrM80847Iw+
         lQ/dkvdItS9aSWHYvP9OY0V22iMVyc8k8nRfkGvJok+xcFT6GVRNFGVxnYwlnrqohIcw
         fmdLChOgyF3Ark8C61+zQJ4D/9TEf5ihKKauLbDvhRdwV2e/IkMJdDqKxYWQ1Bo/Df9X
         JE3g==
X-Gm-Message-State: APjAAAUs7x2OPlqe3I9rVzz3tGiUHQYCw0edhXBYwpyJuSlquMQKCIgW
        uOvi1jVBN7xohI3I3GDVg5oX//SPaaetPOH3
X-Google-Smtp-Source: APXvYqwZcyzFMWyS0F42gYwSnohVguLDDxiDtqJbg24IC9TEyGax/PGc90EibEDi8/YIc9XyA50ZwQ==
X-Received: by 2002:a1c:65d6:: with SMTP id z205mr21451025wmb.38.1581941732617;
        Mon, 17 Feb 2020 04:15:32 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id c13sm783356wrn.46.2020.02.17.04.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 04:15:31 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next 0/3] sockmap/ktls: Simplify how we restore sk_prot callbacks
Date:   Mon, 17 Feb 2020 12:15:27 +0000
Message-Id: <20200217121530.754315-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series has been split out from "Extend SOCKMAP to store listening
sockets" [0]. I think it stands on its own, and makes the latter series
smaller, which will make the review easier, hopefully.

The essence is that we don't need to do a complicated dance in
sk_psock_restore_proto, if we agree that the contract with tcp_update_ulp
is to restore callbacks even when the socket doesn't use ULP. This is what
tcp_update_ulp currently does, and we just make use of it.

Series is accompanied by a test for a particularly tricky case of restoring
callbacks when we have both sockmap and tls callbacks configured in
sk->sk_prot.

[0] https://lore.kernel.org/bpf/20200127131057.150941-1-jakub@cloudflare.com/


Jakub Sitnicki (3):
  bpf, sk_msg: Let ULP restore sk_proto and write_space callback
  bpf, sk_msg: Don't clear saved sock proto on restore
  selftests/bpf: Test unhashing kTLS socket after removing from map

 include/linux/skmsg.h                         |  17 +--
 .../selftests/bpf/prog_tests/sockmap_ktls.c   | 123 ++++++++++++++++++
 2 files changed, 124 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c

-- 
2.24.1

