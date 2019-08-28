Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7301A054E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfH1Os6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:48:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50869 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfH1Os6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 10:48:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so386149wml.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 07:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xo/LHSSw3VnGD1T9j0K8VYk/D9eUwLuivjsbgMSGnJs=;
        b=RyQUFs7EeYzUvS6tv7m7WbMFpk4whB9jTZVW+6PoUzrULEKY2+C3AerAD2iMY973cS
         d0ebRKLiYnvb9zprHAoCAwptbG0Ol3t3AiX8veD0i0AN3vAVjQrBDaJ52ece0MgytNL7
         cUmt+t60Tox13flV24aiuoiwuVtMbrPPhgKyxGYsPBRG3CexeuI2h/27DDlNHIhvp73F
         3z94uPLjZ/LG5ED0IUGCWLS5VU3UfLF6f4QTvC6vUBgvqjapEDUunpvl8XgQDegsY6nC
         0nUJaVndidbuyCZaeM8sE/etrkaP3yIQiQDyceObezJPRk2/sR+8cfx6Z4EYQJDNdYip
         KCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xo/LHSSw3VnGD1T9j0K8VYk/D9eUwLuivjsbgMSGnJs=;
        b=qlMiHSbd2KZ3Q/rOLjmgKR+3EjoLc+Bm0xgh9EwyJ/6gKjqa3TVSL0QfhjwU63Y8UG
         w44L0ojuLYAda9oN0wlX5zdPXoY69tnv+oIXi2xnHuJyJsygDueORgyI4VFpBFvxCGft
         0hTuv8H7N0/PawKUG5AyqaChZ0T5Fmd/CI8ezLmj8mvuhzcbR/fxRu+XxqIlOLhsA0pJ
         +GqyH/hCwZJfZ3hMCNlaiXONmNGe0QlCPULbCGMj8dhkjjQbB7yTenugSDABU1/zJczz
         tFsHOE+3TXmwYxxnHdYIdF5QCGCBRSp74n0GOFEFzfdKmWBa9PBeagRSVCWcbCc+rrfu
         cH0Q==
X-Gm-Message-State: APjAAAWRIStYfS7DX5874tq7XkXXrzj9ePxoy5ovfQLS9t9VqjcMaB+5
        isoQphi+M2txnzrIAWX1CxI=
X-Google-Smtp-Source: APXvYqzNlUlpWqFADzrq0ErfJH6qLuoj+mE2Ko48CRaemlj4Cms8i5tkRy/c6qMF82eTyBnbdiXdmw==
X-Received: by 2002:a7b:c928:: with SMTP id h8mr5526876wml.93.1567003736399;
        Wed, 28 Aug 2019 07:48:56 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id n8sm2973323wro.89.2019.08.28.07.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 07:48:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/3] Fix issues in tc-taprio and tc-cbs
Date:   Wed, 28 Aug 2019 17:48:26 +0300
Message-Id: <20190828144829.32570-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes one panic and one WARN_ON found in the tc-taprio
qdisc, while trying to apply it:

- On an interface which is not multi-queue
- On an interface which has no carrier

The tc-cbs was also visually found to suffer of the same issue as
tc-taprio, and the fix was only compile-tested in that case.

Vladimir Oltean (3):
  taprio: Fix kernel panic in taprio_destroy
  taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte
  net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate

 net/sched/sch_cbs.c    | 19 +++++++++++--------
 net/sched/sch_taprio.c | 32 ++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 20 deletions(-)

-- 
2.17.1

