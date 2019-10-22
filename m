Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CFDE030A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbfJVLhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:37:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41653 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730828AbfJVLhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 07:37:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id f5so16812799ljg.8
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 04:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tzLF7earaqQNOqHLaVTcUZJo2JIz/7DoNnPyWsmHOdg=;
        b=K7uRmE1sbYHZkTqVFzhVff1AWMh+oPY1EQ1/nmtDIDv6F+dI3PIpICsZU2GuqOfZMD
         fSTNQJDg65S20ZjYF11kxA5ANQi2kWMpZ4qbNDBDllUodu87WZHUIuS1TmXTmyybuYYw
         smp3wUz0j14Def3asV2uuJ7k7Q/7q3w3MrAQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tzLF7earaqQNOqHLaVTcUZJo2JIz/7DoNnPyWsmHOdg=;
        b=RIqEAgJq76eM/UhmPMWcEJwt7UDj8lnVD4j5LVktLi1MO+FbaUOqnf9OkEqKQwkzrm
         4MC/fpYtUv1hwM1q161Aj+vbLmotElCzI/j8kFuO5YCMXTE2njdYlHnoKSS6hyVxrHV+
         bc5kmCvAbzSokhvKrSmRUE9Hvxqp7CJ5KonqEObzkYlJgLNl6b/Qpedtg0AJNShx24cb
         D/PEiOyio82h8gdEcOTMmhjVJOxYi7O9GVC183JD+uk1NbRYbtOr1+136ztR6JQ6mnpj
         Sw/eq6RYEvkRgQZoNqxLaaYs+80uYw736egrNDcIMjxEFedDq1uNm0rVjJJLD+GbMvdF
         B3lQ==
X-Gm-Message-State: APjAAAVPiU+vsv6f+NC/McYn3u5mAuB1DqnXgmi3K4IfAEuefuuLrSXY
        H90EoDamVIgRngiba47wQcDvLA==
X-Google-Smtp-Source: APXvYqyX+n39EJRCJOhNGsU7OTqlePHMIvmqiGkWKa6xzGybYVHfJDRd68mrlgp/zfl9fcW0Mn5OBQ==
X-Received: by 2002:a2e:9b02:: with SMTP id u2mr18526999lji.18.1571744252288;
        Tue, 22 Oct 2019 04:37:32 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id y3sm7173487lji.53.2019.10.22.04.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 04:37:31 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Date:   Tue, 22 Oct 2019 13:37:25 +0200
Message-Id: <20191022113730.29303-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a follow up on a suggestion from LPC '19 discussions to
make SOCKMAP (or a new map type derived from it) a generic type for storing
established as well as listening sockets.

We found ourselves in need of a map type that keeps references to listening
sockets when working on making the socket lookup programmable, aka BPF
inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found it
problematic to extend due to being tightly coupled with reuseport
logic (see slides [2]). So we've turned our attention to SOCKMAP instead.

As it turns out the changes needed to make SOCKMAP suitable for storing
listening sockets are self-contained and have use outside of programming
the socket lookup. Hence this patch set.

With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
lead to code consolidation between the two map types in the future.

Having said that, the main intention here is to lay groundwork for using
SOCKMAP in the next iteration of programmable socket lookup patches.

I'm looking for feedback if there's anything fundamentally wrong with
extending SOCKMAP map type like this that I might have missed.

Thanks,
Jakub

[1] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[2] https://linuxplumbersconf.org/event/4/contributions/487/attachments/238/417/Programmable_socket_lookup_LPC_19.pdf


Jakub Sitnicki (5):
  bpf, sockmap: Let BPF helpers use lookup operation on SOCKMAP
  bpf, sockmap: Allow inserting listening TCP sockets into SOCKMAP
  bpf, sockmap: Don't let child socket inherit psock or its ops on copy
  bpf: Allow selecting reuseport socket from a SOCKMAP
  selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP

 kernel/bpf/verifier.c                         |   6 +-
 net/core/sock_map.c                           |  11 +-
 net/ipv4/tcp_bpf.c                            |  30 ++++
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/test_select_reuseport.c     | 141 ++++++++++++++----
 .../selftests/bpf/test_select_reuseport.sh    |  14 ++
 6 files changed, 173 insertions(+), 36 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_select_reuseport.sh

-- 
2.20.1

