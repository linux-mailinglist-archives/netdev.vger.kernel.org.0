Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386FA6E4A89
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjDQOBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjDQOBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:01:21 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128B3976D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:49 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v3so807685wml.0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681740047; x=1684332047;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lwYZr0tdmSWA2lS4jSh8G0uHrl4ssZt285ILCs+hSX0=;
        b=MOoHIpZOiD5XrGBLi+alDgsoj4qZK4BazoRK5tcbh1e3yizm/aY40p+Dwxa97Ch1mb
         odtqFczGCXEBV65kL46gMTBWjEth9fsT7GPvuLPHx6+eM4ASdzgY7g9b3re0cHfeB7Fc
         6l/EwJSK52F4/zhh5QnAAzdVCTUQDE8ur6LMFM8KRG0LCIoquphE+bpY+TJr09Gi+/r2
         Y+YvnM7DoCMtUnYqRZ2YqKKZ3zPdo4m1WIHh/lN0FPiRoWKHNa/eTxUXnoX/vpfI8UQv
         HBfdYPKq0s7rz49af4Z6UiVa9YDKnCrCufB7a/o6GfftgNDz9hL3gTC4Wif2CGq1axur
         yhGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681740047; x=1684332047;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwYZr0tdmSWA2lS4jSh8G0uHrl4ssZt285ILCs+hSX0=;
        b=j1GheDMj0aiduVPAneYpN6o2JrX+I0Z72ORp1hQQkfxXmHX7/jrLvsgV+ba3oNGiOa
         i86Npxs01uHvNL4eXW1yr14H0Nl7IjtQ3P6QVPyNLr+OzHNPOiE+E1UuERJUfznrM8Ug
         66UqisJfzNZSyHjAksucrZG9VVMPZEgFtbO4A1eYsP3univwwdGhXMgnrxLfotbdSgtQ
         TSnSNvDQuOUY+3/kepcNlQ6aodO+KSfULh1bwqxcnJtI+CMx6ZFMfrqAnlFIAfq5/A1i
         ymjPBVGQnOPWrinjVmiV2FWfgxlWK/m58q93jjm8fgLzw8H1gom21hwpxSi1KnhcCbri
         OS8Q==
X-Gm-Message-State: AAQBX9eZmgdsyVuCivwJtC7mr0HNAnJ9F/UBd5LkW09xX1VC0KNsMKK8
        1c5nUlgaesL5lhFoIAtM8XoO1g==
X-Google-Smtp-Source: AKy350YWApKGUen0p3cpHF0CL1GxnS4R+9/uyq7VhhxQhCy77ndfYxW/ZayZEq1eubZ/9S/A7gr5pw==
X-Received: by 2002:a7b:cb06:0:b0:3ef:f26b:a187 with SMTP id u6-20020a7bcb06000000b003eff26ba187mr9822770wmj.0.1681740046780;
        Mon, 17 Apr 2023 07:00:46 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id x12-20020adff0cc000000b002d64fcb362dsm10580652wro.111.2023.04.17.07.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:00:46 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 0/2] mptcp: fixes around listening sockets and the
 MPTCP worker
Date:   Mon, 17 Apr 2023 16:00:39 +0200
Message-Id: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-0-1d2ecf6d1ae4@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAdRPWQC/z3OwQqDMBAE0F+RPXepMS3S/krxsK5rDcUYNmkVx
 H83FtrjzMBjVoiiTiLcixVUPi66yedgTgXwQP4p6LqcoSorW15Mje8QkwqN6CXhvx1D4oDzpC9
 RJGYJaUZrenvtarZyI8hgS1GwVfI8HGQ6/6xjDCq9W75PHpBtaLZtBwd70WqeAAAA
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1777;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=sE3/rnP5lAEFTV7sAWWzUeeAVYS7OAXmYmfeSexbhZ4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkPVENs23FmmZFYmqwW+NbjgJm5qm1Ri21lKPlc
 /QvqpmSzZyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZD1RDQAKCRD2t4JPQmmg
 c574EACF4M/8vhN6Xxj2AN1dcf/5sFKLreu6hGictpgTQCg3XWa71jJTaBoWiX3D1/4ZIw6uwhd
 q0b2gCP/l6lWW1IoKYp4euGGwEgPwhRuOKgMVKqrsrLv9ifzLlFhPbsAlN+cbrYs0tZgLyoJTWM
 nGjq4GFENyrMWujwG5e/z7almhDcWEu7RLDzX2vkvxCVlr2Gnd/ByLAP51Epmmo36APeS+/PoR4
 DOcpmeWaPQfvObUQJS9cyN+UB1zTwcnzQ7YYwUFER4Q5qp3ge/SwgAXYWsSJZGk55skv5ZJTpT7
 zmsW9XTNn7B0tiilaNKHOQYeEDnCap/VhjHVQw9zphsN4ely2EvJL9mDVXmQyScQ01tR2fq5Ku9
 r5sBW8ZtDWZW4HYhJvMQGSeY4XrTrWUe4BfBioPqtOBjhGTw7tavb9juHiWk2syfw+PFDtZE2TZ
 08iqKTwEzZcxpPiJNS5FtIr9MxvjFDv5cqGCt3Frp3dbkfWCgHeY+LOA7RL7wu1vynZ/qACC2AK
 mGUlY4A0lueCGIxLJB+iELvzTwd0Zg8lfvE6VAklgSlZFefj5b070hTtZFLjm8l2yj2k8AfJwre
 4nExvTx50gk9W6nHa7JMbV9wypeBdDXUZCihffd9wagdFaD+M+GbiFGLajShYNyweG1ydGU6Fvr
 YsOUUM4Le0+JD1w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Paasch reported a couple of issues found by syzkaller and
linked to operations done by the MPTCP worker on (un)accepted sockets.

Fixing these issues was not obvious and rather complex but Paolo Abeni
nicely managed to propose these excellent patches that seem to satisfy
syzkaller.

Patch 1 partially reverts a recent fix but while still providing a
solution for the previous issue, it also prevents the MPTCP worker from
running concurrently with inet_csk_listen_stop(). A warning is then
avoided. The partially reverted patch has been introduced in v6.3-rc3,
backported up to v6.1 and fixing an issue visible from v5.18.

Patch 2 prevents the MPTCP worker to race with mptcp_accept() causing a
UaF when a fallback to TCP is done while in parallel, the socket is
being accepted by the userspace. This is also a fix of a previous fix
introduced in v6.3-rc3, backported up to v6.1 but here fixing an issue
that is in theory there from v5.7. There is no need to backport it up
to here as it looks like it is only visible later, around v5.18, see the
previous cover-letter linked to this original fix.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Paolo Abeni (2):
      mptcp: stops worker on unaccepted sockets at listener close
      mptcp: fix accept vs worker race

 net/mptcp/protocol.c | 74 ++++++++++++++++++++++++++++++++----------------
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 129 insertions(+), 27 deletions(-)
---
base-commit: 338469d677e5d426f5ada88761f16f6d2c7c1981
change-id: 20230417-upstream-net-20230417-mptcp-worker-acceptw-31f35d7c3e9a

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

