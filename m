Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAFD274FAD
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIWD4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIWD4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 23:56:39 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF505C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 20:56:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id u24so2728533pgi.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 20:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xm2ryUznAo1FEst2sYahr9UyaaTq1fNSwYskXlfMwJo=;
        b=fYnr2bO86WnkEJan+Vk/cr6tzKfjY/Q6kEEwixjBCT8WIglryeclanQ5gal8wQcA9L
         Vu2ZeGi4U3nFtRG83NARAb9gyieqX2qWPbOqQzeG3C48PRCLrXXExz8Sm5YFFlBtSP3q
         T9728ABXUFlS3U66EcGvbNHHhHnW+coAKbeL2OWGnkYwPRGcSJOsCedjfoMQptZb1WRl
         3FSrRXom5dA35PcsXSDnZa6CoP4efKmVbyykd+T21Pemf99bjFcYTrN7YD4ohZga8LFk
         DBOnaLknRlcfkE0vc72aCe41isUf5HAVblPldyxzL780ubzMN2bRnPno8DGNdhxe/b1d
         shCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xm2ryUznAo1FEst2sYahr9UyaaTq1fNSwYskXlfMwJo=;
        b=tmi2J0ywuYEkHxk5VTVthKVv0LKFai+ZznOJIg7GfGHCuNixAfes3htwp3b3wgjyNb
         zeCFRE8vqmHZan/aNvRpIUcHorVkQQEhlS6jJh7VDYfoaMGZ+R4XysJxLwxa2NoCPYtf
         Nv0KTi4J0hxA72x70ew8G/uHER/XJUNEusxjQ9FB/HEkiU2cr3BUabfDVghsRAebCXdI
         HFosroxBrJol5n/b4Czd8RS7yQWGCJkK28+JrLz3PGkgdd/46eQf57DZSaeuQ4mESbaZ
         JYJAjLOL9kf95NNksHGSetQreJN2tAGay/npQVDNpprCjMoTORQVB6F1btusN69vlP3x
         VpNA==
X-Gm-Message-State: AOAM532ezkPPV30BKToGXKTah1rq6sAScbib6zYON+vh6Ch60mjHni6/
        ppLqNpfXFTj1NMcPQpHgWLXeg/OdbCBIoQ==
X-Google-Smtp-Source: ABdhPJxin9BE7z/wgRj/soQkYCA7a+FW4E65CZS/ffdyfG1OmKa9CM0YAXuRIySeT9s6M5zlaRbJgQ==
X-Received: by 2002:a65:4984:: with SMTP id r4mr5973876pgs.261.1600833398063;
        Tue, 22 Sep 2020 20:56:38 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id v6sm16729045pfi.38.2020.09.22.20.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 20:56:37 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net 0/2] net_sched: fix a UAF in tcf_action_init()
Date:   Tue, 22 Sep 2020 20:56:22 -0700
Message-Id: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes a use-after-free triggered by syzbot. Please
find more details in each patch description.

---

Cong Wang (2):
  net_sched: defer tcf_idr_insert() in tcf_action_init_1()
  net_sched: commit action insertions together

 include/net/act_api.h      |  2 --
 net/sched/act_api.c        | 52 +++++++++++++++++++++++++-------------
 net/sched/act_bpf.c        |  4 +--
 net/sched/act_connmark.c   |  1 -
 net/sched/act_csum.c       |  3 ---
 net/sched/act_ct.c         |  2 --
 net/sched/act_ctinfo.c     |  3 ---
 net/sched/act_gact.c       |  2 --
 net/sched/act_gate.c       |  3 ---
 net/sched/act_ife.c        |  3 ---
 net/sched/act_ipt.c        |  2 --
 net/sched/act_mirred.c     |  2 --
 net/sched/act_mpls.c       |  2 --
 net/sched/act_nat.c        |  3 ---
 net/sched/act_pedit.c      |  2 --
 net/sched/act_police.c     |  2 --
 net/sched/act_sample.c     |  2 --
 net/sched/act_simple.c     |  2 --
 net/sched/act_skbedit.c    |  2 --
 net/sched/act_skbmod.c     |  2 --
 net/sched/act_tunnel_key.c |  3 ---
 net/sched/act_vlan.c       |  2 --
 22 files changed, 35 insertions(+), 66 deletions(-)

-- 
2.28.0

