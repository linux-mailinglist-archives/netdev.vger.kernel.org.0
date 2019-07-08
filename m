Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF9A62914
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391474AbfGHTNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:13:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39573 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfGHTNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:13:41 -0400
Received: by mail-io1-f65.google.com with SMTP id f4so22284286ioh.6;
        Mon, 08 Jul 2019 12:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=KZPOqqmZI4Urxj+xFDSknCAsxm9yYwVbJg1fo8tQnEM=;
        b=gpEd/ECLKtIDjuOOKgTe49o6PRGBnHkrR/pa7pscQePLgv09QnYPAabgILTKst9cay
         1HrZkk72i5J1sg771q43P2wP3nlMAQu8UyQAZSbNpaJDd1abIDwtoSQ79mZsDbv2YkIn
         6NbU+AZFc2iEqsfNodK8biWB5he8RyFBDH4ooJSUQRwnCNziUKB7gI1JCrptkzmVxOl2
         vvaqaYyqqIbH9/8tBWXE8zbHPo6fXMLgzq3chMzBAaX1NMS98tBOxGXEShiDYu/ShBJ3
         eO8TiXCPjHbKFM5QMsCgU0V1hmhs/emtRqupe2dsHmPt5HqY3LCHd+4wtipoXZ0r3c1h
         jE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=KZPOqqmZI4Urxj+xFDSknCAsxm9yYwVbJg1fo8tQnEM=;
        b=C2MO1isftaniCo8vIr6GozZtErw05YBuZykqcl2LMA6clghWzFHf7ZCKkVbrMSZUkd
         Y0ujMWksFNv/PnLcTA1reoMP160BYkITRUWd26sbNBLd+Is3cmPExc9rIK898Y2w8Ci0
         YoUgmEsQTTtF1X04l10b8RR6oWHYMArZtxETnE6G6GMXIiR8IA51Cv2PPFqGIMw10ko6
         5J2gqi7CzOCYjVVmvNrZxhvcDNVRN8b6VSnHAHLoA4BZU1R7OXCpuNK2W9lmf8IHuBg9
         d3ywlRK60O2Csb3bpxbj1DFcs/huAjUexx9Yw8ySgE7qi9xbwfJnQBohVwne/0IwHeYW
         osLw==
X-Gm-Message-State: APjAAAXkR1PSSdEQjGTsDrv+kX54xMn69stTrBmHPJATM+rECh+NHGUG
        eb70/yn6ZK+ccttp7LlItaM=
X-Google-Smtp-Source: APXvYqwDcq/DMb6XARwVeQFywsz18unO+G81xJ5krjgolwu9VNt5DsidjYqpkjq5UwGOPE+hUZcsXQ==
X-Received: by 2002:a6b:1604:: with SMTP id 4mr19904202iow.245.1562613220376;
        Mon, 08 Jul 2019 12:13:40 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q22sm14485951ioj.56.2019.07.08.12.13.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:13:39 -0700 (PDT)
Subject: [bpf PATCH v2 0/6] bpf: sockmap/tls fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:13:29 +0000
Message-ID: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
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

John Fastabend (6):
      tls: remove close callback sock unlock/lock and flush_sync
      bpf: tls fix transition through disconnect with close
      bpf: sockmap, sock_map_delete needs to use xchg
      bpf: sockmap, synchronize_rcu before free'ing map
      bpf: sockmap, only create entry if ulp is not already enabled
      bpf: sockmap/tls, close can race with map free


 include/linux/skmsg.h |    8 +++
 include/net/tcp.h     |    3 +
 include/net/tls.h     |   10 +++-
 net/core/skmsg.c      |    4 +
 net/core/sock_map.c   |   19 +++++--
 net/ipv4/tcp_ulp.c    |   13 +++++
 net/tls/tls_main.c    |  135 ++++++++++++++++++++++++++++++++++++++-----------
 net/tls/tls_sw.c      |   38 +++++++++-----
 8 files changed, 176 insertions(+), 54 deletions(-)

--
Signature
