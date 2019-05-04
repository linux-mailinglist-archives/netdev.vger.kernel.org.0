Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3474613C46
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfEDXtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:49:00 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39986 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfEDXtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 19:49:00 -0400
Received: by mail-pf1-f202.google.com with SMTP id k1so3759947pfo.7
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 16:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M+4+6vNMBetWaap8hmdKDBjpM+BMyccB+zu7kZaDQS0=;
        b=bVuNPuw/VBOSWbC3vcobM1KYbI5HSF1lrnaccP7lnDCJwrfCesd41SDp/m0rYaW7PZ
         giYDiALWioPTrVrzuOWqFZ7pvHuYJatZkG1g/lTx7nXZrY1ZrEhv2/IXM8GKPxuWJnf+
         WzkJoiQgh+D6KTfo3NSIhSyd93MSpX5dCrnK7n5Jg3MZy6DR3ZI8+Qucfx2+UuRrhLH6
         C8D4F+t4QGYBq2JF2/25w8D3MprKb574DdbUJHTVgrKnIdMFvatFU82yoV6wZLqqmy1V
         /fs277CPfEE3V5l/HAbGpU4bbrWNWWJ1np7U9Yj6NbDRnS8NWRu5nWAQlpCuViAZzzBj
         Uh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M+4+6vNMBetWaap8hmdKDBjpM+BMyccB+zu7kZaDQS0=;
        b=ETCclzLXk7aDfXi4TTK+fH48cBYRzrRuJZVCDlGS4z3bxvDyAN1cM7vLpvXYAFtNSB
         DyPpc/zTZP/WBCJdCvT4L8qc7qTRkcMGMUTJgiYQvZdODT1PS0/xRqYj1iNlg0HM2Y8y
         RjhFBM7Ofv1/oKQ4ZFyBls4AVmkhbnqNWF2gb4p71lJ3l9IMkvsUOLXog7TnD935efNI
         t48XNQ8iZ5ijbdVfyM/O0qDo8asdnj6oY7OzDWmElsbKyAkEabCRJ+wlyt8FUP3zAMpG
         FWz1WdF9S77v/vvZgVgYszV3KKQwrVzeYpdr9DRD1LdYA4DGlO2ym9yDKVOJ2YLazikH
         4LkQ==
X-Gm-Message-State: APjAAAW+Z/C7G7x1/h9TJwVH0KQGIbOn3v+8q3W1ZF3H3Gp79TufzTGe
        2dR1CmgipMWx99duKLm5av0Vm86cHgYaRg==
X-Google-Smtp-Source: APXvYqwMLwzqWRYkcHkT+2w0qAp7BRqQFGQmT3zoQ2xlWZou8bi2CsgDn3Cu9CiWiYPD1fVMkF0qKKDWXinmpQ==
X-Received: by 2002:a63:ef04:: with SMTP id u4mr14667372pgh.96.1557013739186;
 Sat, 04 May 2019 16:48:59 -0700 (PDT)
Date:   Sat,  4 May 2019 16:48:52 -0700
Message-Id: <20190504234854.57812-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net-next 0/2] net_sched: sch_fq: enable in-kernel pacing for
 QUIC servers
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem added GSO support to UDP stack, greatly improving performance
of QUIC servers.

We also want to enable in-kernel pacing, which is possible thanks to EDT
model, since each sendmsg() can provide a timestamp for the skbs.

We have to change sch_fq to enable feeding packets in arbitrary EDT order,
and make sure that packet classification do not trust unconnected sockets.

Note that this patch series also is a prereq for a future TCP change
enabling per-flow delays/reorders/losses to implement high performance
TCP emulators.

Eric Dumazet (2):
  net_sched: sch_fq: do not assume EDT packets are ordered
  net_sched: sch_fq: handle non connected flows

 net/sched/sch_fq.c | 110 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 96 insertions(+), 14 deletions(-)

-- 
2.21.0.1020.gf2820cf01a-goog

