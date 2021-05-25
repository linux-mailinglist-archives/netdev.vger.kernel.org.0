Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045173900A9
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhEYMQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbhEYMQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:16:46 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A46C06138B
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:15:13 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id f18so30095661qko.7
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fVT01LrbHVcD8DDdd7kMyccAh0r1MirD1LpVo5M52oI=;
        b=C9i2PmLGtRGAOg4LjvfwfPs7s4DCCYV3otQUteKQplnlucPW4snMGkG4D9xb1Uf5jf
         AubhJpGsgiMxammsEIYUHpniGE1cmZFkumlC/Pci2QFdZn1J/KucHwdYmYdcPlwYT5cZ
         DkoovsuRX3il40jpLvl0HZEB4EuhAnvwKkJfPeMZ/YUFIIMK1ypOh8JHGNPRms1c4v60
         7zGfOVkioTtAu2Kbc/GbO1cYtcusQQsa49VOTy1Qt2PvHuNAj6L6+Cvgq1CqTnBrEHUO
         FDk4kPM/V6uDmA1lzsShHtbzPOKJlmg0HuznCyLhnJmyoPmnUs4rBm6kHVCf3YoAJnRH
         kNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fVT01LrbHVcD8DDdd7kMyccAh0r1MirD1LpVo5M52oI=;
        b=bpPUgwYN+dK1aYQFxc2rsUeSPnfTW5NF0vZoQxouQdxTpObeQESHGt3n0NvxX6SshT
         8bNcjYFy9bU2foCvMLT7u/cZZ4FY+O5OqO/JncwnOlvLPUum00ak23aTJ8m/Do/ElUIY
         J1wIfix+jQeHHlFC65Ect9v0wM2645EuafPxPmntlM55KydXAk+PCf9uFgTPmPo7lx8M
         4ir/wpskV4hBdS2FAzxLBCT/ochKjvxTKT8WnY4Xd3XHSCtD2nC40oMM3WqWWP6qvYSx
         adzE6ujtNCNEVrzwl9AV8PoPzEYXyLpR0Sqsq27UsoiUpeQ9wX7AgWL/lSfRDr93UBXK
         UzmQ==
X-Gm-Message-State: AOAM532vh6qVIxDO/SioNm2BfgCxYCXhIhjwMtoMtcbg8cIOIDNQBw6q
        madUPvegSh0OgNct2O4HqpjThlq7LQqowxQ9MyY=
X-Google-Smtp-Source: ABdhPJxPey8F6hhRqPTvVAVz5nYbU7rRqiMTQW8J+kXXJ1wtaUSWiBhYFGy3jrqyUNYY9OqlgEhHrQ==
X-Received: by 2002:a37:2714:: with SMTP id n20mr33039013qkn.434.1621944912994;
        Tue, 25 May 2021 05:15:12 -0700 (PDT)
Received: from wsfd-netdev-buildsys.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t6sm13271305qkh.117.2021.05.25.05.15.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 May 2021 05:15:12 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/wireguard: make sure rp_filter disabled on vethc
Date:   Tue, 25 May 2021 08:15:07 -0400
Message-Id: <20210525121507.6602-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some distros may enable strict rp_filter by default, which will previent
vethc receive the packets with unrouteable reverse path address.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/wireguard/netns.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 7ed7cd95e58f..37b12f642254 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -363,6 +363,7 @@ ip1 -6 rule add table main suppress_prefixlength 0
 ip1 -4 route add default dev wg0 table 51820
 ip1 -4 rule add not fwmark 51820 table 51820
 ip1 -4 rule add table main suppress_prefixlength 0
+n1 sysctl -w net.ipv4.conf.vethc.rp_filter=0
 # Flood the pings instead of sending just one, to trigger routing table reference counting bugs.
 n1 ping -W 1 -c 100 -f 192.168.99.7
 n1 ping -W 1 -c 100 -f abab::1111
-- 
2.26.3

