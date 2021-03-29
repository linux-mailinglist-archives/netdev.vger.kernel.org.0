Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302D634DC26
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhC2WzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhC2WzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 18:55:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29204C061762;
        Mon, 29 Mar 2021 15:55:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id ay2so5141165plb.3;
        Mon, 29 Mar 2021 15:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=riwS4fKZmYi1s9ahYLZfXUq5/tOglH8JPYYvD9weK5o=;
        b=OR9oTxQta8eqpIy/h4iAVKRA/cVaqmQaiJDc21WMR4gHeGr9Mc2M6/9p98XGJYkB/3
         b5WNjXs4c01ti+8V6SVhMejHhS8j5F4cfCZobtQBYQZco1yE2SdLNjCgAThspSE62QRc
         H+60liBKhyNiiFQZfuuOUeHsDikU+jcBcvTBd9XbMfdPhiASC+oQyB60To+r4aTk9vWl
         eKpeYpCEft1tZsDfdam5e5P4hVDma7MXKAY3Hp4RwqgPbQylCLtF84qhhd+RDiRJSYY8
         lQxrZJfn6XDqR9z4fIS8BOjkT5r6L0MY3HdND4ihvr6LokMbOMRcu0BTDS0FZ5EcZyUy
         H1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=riwS4fKZmYi1s9ahYLZfXUq5/tOglH8JPYYvD9weK5o=;
        b=HONxG0gnRa9QF3+iSvwMDheIJfK2+odv8lAfFdpRgvZRAMfqOtFJG3KMfJZAMD381b
         wxwvs3yVwpJEqqcJI0i2WKNvDaNK/uTvxcSufJbfXP4UKEZYed5Awv+saaXwMF4eUHGh
         XBhG0+qVShF4NHtL5OhnHvzb6uK3Mj8VXG7kkbbqEHhXpuZYFvpNvBoEEJTo/s+kSwJu
         AAcPpEfPMBtNaufdA2cKFikbixo6yec4yt1OIv0lKgngNgP5+ceMgBi9omLRDEpkpB5O
         X/Yksl5a2DHTnpIMIVS02Xu+Pq/Fk3WhJ05hPkkRzwSKbjO0V3mmCW6HgKZ17ctz88sl
         OvMw==
X-Gm-Message-State: AOAM532N9HE9bE8r3BWtiA8zpQ+rqNkz4O8gnxWlaj4XUyeJJJ6cneql
        vk6x5NgO+DawJj62KpR/gQ8=
X-Google-Smtp-Source: ABdhPJxuSKooLGKpUklp1sIyirkbLOMBRu9lhF2SAChgjYIOZX5GnDGW8b/pTWhxxzEC2eVO364Dlg==
X-Received: by 2002:a17:90a:a4cb:: with SMTP id l11mr1298790pjw.144.1617058506536;
        Mon, 29 Mar 2021 15:55:06 -0700 (PDT)
Received: from localhost ([112.79.230.77])
        by smtp.gmail.com with ESMTPSA id q1sm9169695pgf.20.2021.03.29.15.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 15:55:06 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     vladbu@nvidia.com
Cc:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org, memxor@gmail.com,
        netdev@vger.kernel.org, toke@redhat.com, xiyou.wangcong@gmail.com
Subject: [PATCH v2 1/1] net: sched: bump refcount for new action in ACT replace mode
Date:   Tue, 30 Mar 2021 04:23:23 +0530
Message-Id: <20210329225322.143135-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, action creation using ACT API in replace mode is buggy.
When invoking for non-existent action index 42,

	tc action replace action bpf obj foo.o sec <xyz> index 42

kernel creates the action, fills up the netlink response, and then just
deletes the action after notifying userspace.

	tc action show action bpf

doesn't list the action.

This happens due to the following sequence when ovr = 1 (replace mode)
is enabled:

tcf_idr_check_alloc is used to atomically check and either obtain
reference for existing action at index, or reserve the index slot using
a dummy entry (ERR_PTR(-EBUSY)).

This is necessary as pointers to these actions will be held after
dropping the idrinfo lock, so bumping the reference count is necessary
as we need to insert the actions, and notify userspace by dumping their
attributes. Finally, we drop the reference we took using the
tcf_action_put_many call in tcf_action_add. However, for the case where
a new action is created due to free index, its refcount remains one.
This when paired with the put_many call leads to the kernel setting up
the action, notifying userspace of its creation, and then tearing it
down. For existing actions, the refcount is still held so they remain
unaffected.

Fortunately due to rtnl_lock serialization requirement, such an action
with refcount == 1 will not be concurrently deleted by anything else, at
best CLS API can move its refcount up and down by binding to it after it
has been published from tcf_idr_insert_many. Since refcount is atleast
one until put_many call, CLS API cannot delete it. Also __tcf_action_put
release path already ensures deterministic outcome (either new action
will be created or existing action will be reused in case CLS API tries
to bind to action concurrently) due to idr lock serialization.

We fix this by making refcount of newly created actions as 2 in ACT API
replace mode. A relaxed store will suffice as visibility is ensured only
after the tcf_idr_insert_many call.

Note that in case of creation or overwriting using CLS API only (i.e.
bind = 1), overwriting existing action object is not allowed, and any
such request is silently ignored (without error).

The refcount bump that occurs in tcf_idr_check_alloc call there for
existing action will pair with tcf_exts_destroy call made from the
owner module for the same action. In case of action creation, there
is no existing action, so no tcf_exts_destroy callback happens.

This means no code changes for CLS API.

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
Changelog:

v1 -> v2
Remove erroneous tcf_action_put_many call in tcf_exts_validate (Vlad)
Isolate refcount bump to ACT API in replace mode
---
 net/sched/act_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b919826939e0..43cceb924976 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err != ACT_P_CREATED)
 		module_put(a_o->owner);

+	if (!bind && ovr && err == ACT_P_CREATED)
+		refcount_set(&a->tcfa_refcnt, 2);
+
 	return a;

 err_out:
--
2.30.2

