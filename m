Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED59293FA1
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408807AbgJTPfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:35:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408799AbgJTPfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 11:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603208110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=qpKO9v2R0V+D3M/ed5F9Yt0n+uo8Fwzb8msLXsnjOS4=;
        b=hhAY+ggMxnKQNzZbOdcPeISRBCR9kSwDxNjvmCp0c2G9A/eqM0wU1Uypc5/QxVjJAf5fU8
        i7PlIJ+cjEHMWtFMXixZaHlkOkvjH7K5U3Lb6P5gO1orceQtERyg7+AXjrha6acHeEdpbo
        p+mA/TCL35ufmXtgJd9ywlMfnADH5NI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-RkxKh0BFPBip61LcOjYrpg-1; Tue, 20 Oct 2020 11:34:34 -0400
X-MC-Unique: RkxKh0BFPBip61LcOjYrpg-1
Received: by mail-wr1-f71.google.com with SMTP id m20so956510wrb.21
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 08:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qpKO9v2R0V+D3M/ed5F9Yt0n+uo8Fwzb8msLXsnjOS4=;
        b=JLKQldaVaqRjj4slNEcQE9j5XGhywTnVOBGuvoOCRHQoKGSs8zzcqtzvllRSufVVbd
         HVEk5pT+9wYoKR89b4Is+580zPYyILZblTuBbUNl779EJc5SBdtjGoXNQxKTS2omWXQE
         MQJdYduHrgzoL8bibk8OnVwe/yqY9AZR1hkmLM8j9txBqrFaZBxNqaLQ6+9nO/IkUQxh
         w8d8c6eZm/XxWesFGSr/P+Fz/A4Q9aAs+82ChZQZoLJoriq4GHn5/HryCM1vHDVDhUTu
         jbh/gylJl1A/+/+MeBMee97fVrM3mo1G0QfhyTvkQTBDpka/fvzgCrgloAYnbnIH1M+I
         Y06g==
X-Gm-Message-State: AOAM532hHeB1wrLih+Au/JnU+07SikizW/ZgENsIbYwk+gE0KF4mOWMf
        HXW4eeMTGc+P0NluXgJiYTgWTSz9ZHc4O4A+yFRat2Rk9fShkKZGxagIJtoYg+WNbfF8AxgpmJ8
        9KSwSwBUKO1nYoimU
X-Received: by 2002:a7b:c418:: with SMTP id k24mr3747648wmi.118.1603208073727;
        Tue, 20 Oct 2020 08:34:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1et6v1Tn+9ic85/V1WJ00UqV9xuqk5sJznsvLe2pSZVfjWL0X54EhGyNK30RTluC/ROCpyQ==
X-Received: by 2002:a7b:c418:: with SMTP id k24mr3747634wmi.118.1603208073566;
        Tue, 20 Oct 2020 08:34:33 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id b15sm3584027wrm.65.2020.10.20.08.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 08:34:32 -0700 (PDT)
Date:   Tue, 20 Oct 2020 17:34:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Po Liu <Po.Liu@nxp.com>
Subject: [PATCH net] net/sched: act_gate: Unlock ->tcfa_lock in
 tc_setup_flow_action()
Message-ID: <12f60e385584c52c22863701c0185e40ab08a7a7.1603207948.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to jump to the "err_out_locked" label when
tcf_gate_get_entries() fails. Otherwise, tc_setup_flow_action() exits
with ->tcfa_lock still held.

Fixes: d29bdd69ecdd ("net: schedule: add action gate offloading")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 41a55c6cbeb8..faeabff283a2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3712,7 +3712,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->gate.num_entries = tcf_gate_num_entries(act);
 			err = tcf_gate_get_entries(entry, act);
 			if (err)
-				goto err_out;
+				goto err_out_locked;
 		} else {
 			err = -EOPNOTSUPP;
 			goto err_out_locked;
-- 
2.21.3

