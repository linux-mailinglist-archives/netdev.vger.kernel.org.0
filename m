Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532A13521F1
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhDAWAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbhDAWAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 18:00:14 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7087C0613E6;
        Thu,  1 Apr 2021 15:00:14 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id f5so3288083ilr.9;
        Thu, 01 Apr 2021 15:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=j0WmROs/zEHu4V2L5BiGNsJQHiMqhJUuD7Mh6MSSkfk=;
        b=krh3RhanGIo4tc9Nhuz0Dky+J521AQWwBYVCcDP5PISUUOeM8kyhR5tFIYyh4WQ3+c
         XVeEC3gNhARpn8FeHAS1RCkHfGHiZxpkvdZ5X8NUep2rCNLmTP4YtrEZR7y0RoBJQcz7
         uTNAiTN50XmfYxB5E92nQanHDGAdNS87wFScZVgweKp+kQNAAWeKAMXv+tKDxu09PdkR
         4CJYmJ725hfaXAhq++VSH0OOCmbeU5Xh+QXK4bcntkt1w78xmtlYO+qFbjTZOCpyB/Gr
         cY7MIwMUgN5tMJZkXsK4h2ZHMFwuw41Gw0AxubOpmxYIK5S3SUMjFkTdobM42ROlYdT4
         Psiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=j0WmROs/zEHu4V2L5BiGNsJQHiMqhJUuD7Mh6MSSkfk=;
        b=b87D12z0B/wONqD6gJaJIgCyIHWrrLrmxzQcENq7AP+lWRiKuHL1jAiR9rCDhxwT3S
         InxUewkIW8JLoI5JdJvlfG/FQMd2OJSLoCBeKa3gnvmvblQ6CajWfqBmwmK6BOpGjjx1
         SgoMiK7P93hey4W66FND6dytAEhLyU6EJ+NnQ7/06wLZsQh99DWGHOq9dcrvCcDAeFWe
         5YF/B7sVQbqZp7NSX9cVtGYwn91S4HnaAZwtzgOfO88J2KGEmDQXYAEJGiu0nlDMhH95
         QAzEBxsdfN9XpRsGQ689Ah2g7WTrgJ380fBmM1KaIiS5pFPUS6SGPN2UANMjitJfFHQN
         SKfw==
X-Gm-Message-State: AOAM530adnUfP86mNXf8cXxHFRA1iPIq6fDmv2r+CLHjxm7Nr5f9IGHt
        PaNOU7SW1Nn7Rzzf5Z+nyPk=
X-Google-Smtp-Source: ABdhPJxz7i9cZNrXClR35HpKhxv0SQL3QkIgc6C63v2R3EquL2MLXbUFUpCmqh/HO/7Z0ooZArbAbA==
X-Received: by 2002:a05:6e02:219c:: with SMTP id j28mr8414966ila.229.1617314412958;
        Thu, 01 Apr 2021 15:00:12 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x6sm3271136ioh.19.2021.04.01.15.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 15:00:12 -0700 (PDT)
Subject: [PATCH bpf v2 0/2] bpf, sockmap fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     xiyou.wangcong@gmail.com, andrii.nakryiko@gmail.com,
        daniel@iogearbox.net, ast@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Date:   Thu, 01 Apr 2021 14:59:58 -0700
Message-ID: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses an issue found while reviewing latest round of sock
map patches and an issue reported from CI via Andrii. After this
CI ./test_maps is stable for me.

The CI discovered issue was introduced by over correcting our
previously broken memory accounting. After the fix, "bpf, sockmap:
Avoid returning unneeded EAGAIN when redirecting to self" we fixed
a dropped packet and a missing fwd_alloc calculations, but pushed
it too far back into the packet pipeline creating an issue in the
unlikely case socket tear down happens with an enqueued skb. See
patch for details.

Tested with usual suspects: test_sockmap, test_maps, test_progs
and test_progs-no_alu32.

v2: drop skb_orphan its not necessary and use sk directly instead
    of using psock->sk both suggested by Cong

---

John Fastabend (2):
      bpf, sockmap: fix sk->prot unhash op reset
      bpf, sockmap: fix incorrect fwd_alloc accounting


 net/core/skmsg.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--

