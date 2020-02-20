Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4686016583F
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgBTHLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:11:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36134 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBTHLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:11:13 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so1467727pgu.3;
        Wed, 19 Feb 2020 23:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O0zFntr1QJNRBWVbfr3Y3ej4pjF2VbnkF0Ahy+Hu/rg=;
        b=bGxTc1NZzIJ9/9ID4iL0F94syynnLjynNX83/axWs+Jhvpt/79GB2+kZq24uiW4KkR
         gu8wfFaKHYZzk8JcIOUk8H/SVXGi/LTnOsk3LEnzz0QKHK9dwBHYYwKqHQ5yJ/IRgvNR
         U/RiHMoiXa9EqlsnXGZwV+g38W89vQV0RXqMTXMxtSPDAEcJYwGclcgIbzawgBKtREl7
         fnkseXtv1pPi7v5cQVa8kaXeHgtLn8ceeXl6Up763AhTuhngW5CSFM6CFTVcyOZL7iJr
         Ehj2rXu3rDY5i9lKpIR+1/1E6DufvqyPaRj+D4bIl5r1GKA7TIgXxKuE1eygdkvnQsX/
         MpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O0zFntr1QJNRBWVbfr3Y3ej4pjF2VbnkF0Ahy+Hu/rg=;
        b=Xde4hUR5Keun6XEbTsptCKeWSPUzu4W2966oI4oXPhV5euIJMNimavf4Qb+eg6f9Ok
         9gIFLPnGFNX19m1wa90GfEEOMzczZeCdx8Te33Kwm8BEtXvCl8SQHrZGQWMVtz/pW82g
         UL6TWi2xbc6yQE8PdItuoiOEbIbAisQTI6TWr6Suws59An/yTpO3EmdtrDo0cZZ0ywzq
         Zzl3//na9TOmFdBOAXbivYaG8QmLesbQqCbhLigvKLRsJlnQvWsRmAVG1apAxYDxRkqF
         lq2iwWM0FguBRLfFeUEBNrPrrc6/LDDXsaVfbZEwQoPz2p/sECJosOqiEMtiZ7CJs5Vw
         IcVA==
X-Gm-Message-State: APjAAAVlriEXPO1q2vroOHC5iJhGZPYrycoLYByevrFNs5o1lQ+lB7EP
        UtXnx/QMEPt/aoxFbNjlrR1KfmnLm00=
X-Google-Smtp-Source: APXvYqx2cBvnnmi8Zw+LlnLnXTNACdkhT6TGG1iapS5aVPoYYKvd0/aHTjT2vCAMO3mVdgWLub6XeA==
X-Received: by 2002:a62:4e42:: with SMTP id c63mr30738042pfb.86.1582182671985;
        Wed, 19 Feb 2020 23:11:11 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id p4sm2148325pgh.14.2020.02.19.23.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 23:11:11 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v3 bpf-next 0/3] bpf: Add get_netns_id helper for sock_ops
Date:   Thu, 20 Feb 2020 07:10:51 +0000
Message-Id: <20200220071054.12499-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
References: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
uniq connection because there may be multi net namespace.
For example, there may be a chance that netns a and netns b all
listen on 127.0.0.1:8080 and the client with same port 40782
connect to them. Without netns number, sock ops program
can't distinguish them.
Using bpf_get_netns_id helpers to get current connection
netns number to distinguish connections.

Changes in v3:
- rename sock_ops_get_netns to get_netns_id

Changes in v2:
- Return u64 instead of u32 for sock_ops_get_netns
- Fix build bug when CONFIG_NET_NS not set
- Add selftest for sock_ops_get_netns

Lingpeng Chen (3):
  bpf: Add get_netns_id helper function for sock_ops
  bpf: Sync uapi bpf.h to tools/
  selftests/bpf: add selftest for get_netns_id helper

 include/uapi/linux/bpf.h                      |  9 +++-
 net/core/filter.c                             | 20 ++++++++
 tools/include/uapi/linux/bpf.h                |  9 +++-
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
 .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
 5 files changed, 92 insertions(+), 3 deletions(-)


base-commit bb6d3fb354c5 ("Linux 5.6-rc1")
-- 
2.20.1

