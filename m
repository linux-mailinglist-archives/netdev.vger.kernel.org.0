Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B031769D05
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbfGOUtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:05 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40886 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:04 -0400
Received: by mail-ot1-f66.google.com with SMTP id y20so2594229otk.7;
        Mon, 15 Jul 2019 13:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=AjNrvGga0Rwkqc34Ofr3xEEo19X2YqWl7UCGJgM7/20=;
        b=DupnNoh/L4HEHop3whDuE26LI93giUvtVz9tnrL2gw3FyMkvvk+dGFgDs78TgJtjOB
         FJ+dx7IjZ0VyEzRXkBhRT8KASfdENwlPCUuYrQD3OhLF7mwtidKoZqXdmwcGGm47MTja
         FJ4R5lT5xEIhCGXjCHmj5ccwuefhPz6N57ef4QX0zEglh1PTcLEmNBhNeVwWjRgYFVMO
         74DPTpwCZDZbIdpcApHJ5zvTgo1Z1n9exV6SX6YY84FMoou4tyq8Y36Nx57a7MmEHyB7
         Fcm6+lSngfV+3ZFx610a6zHeM6RhAOyjWG9R/UXWFc4zFYNRoml5GastQ4qN5tkrA1Ls
         t3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=AjNrvGga0Rwkqc34Ofr3xEEo19X2YqWl7UCGJgM7/20=;
        b=mu8GEENjEX2hsgNyZU1IsyhJSz3Pkzq8P0/AZYNqJhKP8oWtSVsAx2JPaekDaU61xG
         cA5ZviXIJk77wuYJu6DAKIUNTQtwQmySoaaiIJPUwveMAu8dcJR4TbcpoMUKc4anjW83
         jBMx/KYI5C958GKG+YbV+5YczCngU8xpOcHc2bAFAuj8FQo5glOMi/aaZIcdPLwodufJ
         1LCkoOJoAUidKXXDRTkEzNifoELMV/YfhSfKIKg1fwxwx99nB2V/1Tmu5JaWXnGfjCqs
         h4l/wCC0xv1c49+icHrJHqeWY9W95EsSYp/BXgKuduUWEtEX41LAloGsJuSXq6JE3eyC
         Ispg==
X-Gm-Message-State: APjAAAURxKhJydXgMGKoC/TURTX7JR27lg1mbDGisV49zzcWmrGRcZ6n
        IODUO7J43uTJFBsZieyStDM=
X-Google-Smtp-Source: APXvYqzVsshJDbM8V1RaJLnuDTkTKstSYfT3QGlORYEGSL2UOyh4w9Alckf83zuuvAYae0vmfUudPA==
X-Received: by 2002:a9d:5ed:: with SMTP id 100mr22370025otd.105.1563223743725;
        Mon, 15 Jul 2019 13:49:03 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id 132sm6414590oid.47.2019.07.15.13.49.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:03 -0700 (PDT)
Subject: [bpf PATCH v3 0/8] sockmap/tls fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:01 -0700
Message-ID: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resolve a series of splats discovered by syzbot and an unhash
TLS issue noted by Eric Dumazet.

The main issues revolved around interaction between TLS and
sockmap tear down. TLS and sockmap could both reset sk->prot
ops creating a condition where a close or unhash op could be
called forever. A rare race condition resulting from a missing
rcu sync operation was causing a use after free. Then on the
TLS side dropping the sock lock and re-acquiring it during the
close op could hang. Finally, sockmap must be deployed before
tls for current stack assumptions to be met. This is enforced
now. A feature series can enable it.

To fix this first refactor TLS code so the lock is held for the
entire teardown operation. Then add an unhash callback to ensure
TLS can not transition from ESTABLISHED to LISTEN state. This
transition is a similar bug to the one found and fixed previously
in sockmap. Then apply three fixes to sockmap to fix up races
on tear down around map free and close. Finally, if sockmap
is destroyed before TLS we add a new ULP op update to inform
the TLS stack it should not call sockmap ops. This last one
appears to be the most commonly found issue from syzbot.

---

Jakub Kicinski (1):
      net/tls: don't arm strparser immediately in tls_set_sw_offload()

John Fastabend (7):
      tls: remove close callback sock unlock/lock around TX work flush
      tls: remove sock unlock/lock around strp_done()
      bpf: tls fix transition through disconnect with close
      bpf: sockmap, sock_map_delete needs to use xchg
      bpf: sockmap, synchronize_rcu before free'ing map
      bpf: sockmap, only create entry if ulp is not already enabled
      bpf: sockmap/tls, close can race with map free


 include/linux/skmsg.h |    8 ++-
 include/net/tcp.h     |    3 +
 include/net/tls.h     |   12 +++-
 net/core/skmsg.c      |    4 +
 net/core/sock_map.c   |   19 ++++--
 net/ipv4/tcp_ulp.c    |   13 ++++
 net/tls/tls_main.c    |  155 ++++++++++++++++++++++++++++++++++++++-----------
 net/tls/tls_sw.c      |   76 +++++++++++++++++-------
 8 files changed, 221 insertions(+), 69 deletions(-)

--
Signature
