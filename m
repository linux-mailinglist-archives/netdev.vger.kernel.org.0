Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A2F11907D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLJTTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:19:37 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:48775 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfLJTTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:19:36 -0500
Received: by mail-pl1-f201.google.com with SMTP id q14so337454pls.15
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 11:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eofQlu96w5PdwK6jdsAtv9MrY+azci8yH0951lYXHqk=;
        b=G6zbASc1oLSOyih11B4znRobCS1FvvcrU8nTeE6Ykxazb5bR7CHtYDzc7EJkY0dgIC
         J7DigQ2E5l4P7FCEG7ar5DhUkhFIad+Mhs8aPCWO27gA2pFMQJ8/3yHogOGoGTSkwzeE
         qx1jJlv98tjQTvCbpGDhmfkRye0kK8kW18RCLoBgvmMw0XIsHQ82cn4sSome+RwSOmv6
         01wH6yNYfZMQGeEPk8pXC4Uy95yPUvsuTRVtbZfkzU+W7mNZ3PDeHaNTOO5eEVRYql62
         h6PVw5puqG8BL3TdlePpnMxxZk1IOWbFWEkGEAhsnc8/TDpntnT+CvUiCR8B81xqUjet
         phWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eofQlu96w5PdwK6jdsAtv9MrY+azci8yH0951lYXHqk=;
        b=hdhckZOBB/1vrM+qVwnLvmiNKW0nyWjAZXaoEjyJTb3aEMl70j/1sly4dgEitEL80R
         wmYKTKLGXVXP/zIWxLgGcQyWR4pbpbiPN5fBYrY6p9XgYYbLIGMpACa9iSggsL1eevK+
         VGvcT2+31wOkxF9DAGxiJyOz4C5WM7733VgkSxg1Hm44W/66l2onMVlTIIvLbDUvNmYz
         ZrGl+jpW7gsmRh+CvP4x2EeIolr6RuoHut0OeGZayLGjFNKTKhnxuBOx9g4NCSEyOonv
         fclfnb/2hn6/kt+T4wqy2oAVjPQc01kapsRa0ZLRP1pliiJDdTQSuVgqBw7Ok+VwNJek
         k8kA==
X-Gm-Message-State: APjAAAV2NZuQxHXUvk1+L8vz6xk2xx3OYqrRwCYILsQcuuZUMGeSLRZu
        /yUFXS9BeOXWG9jMiNWoXy+os8lkmZfG1r3/w7jp5sX8NO23R8sK/WpCFoUb9ON8TScpPWcZQtg
        siRhaUeMQiJd7bHCdjxnY5Yb8VjaAqlnhrgL1pVGioQFD7Tqf5oJRiQ==
X-Google-Smtp-Source: APXvYqwv9WGpW3lNnW9weVW4DZ4MLIV+/U3eAXbl5z6CHDB55926Vzzj9cBeSFlo3wm6B/O7vLXaO64=
X-Received: by 2002:a63:130a:: with SMTP id i10mr11067776pgl.199.1576005575815;
 Tue, 10 Dec 2019 11:19:35 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:19:33 -0800
Message-Id: <20191210191933.105321-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH bpf-next] bpf: switch to offsetofend in BPF_PROG_TEST_RUN
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch existing pattern of "offsetof(..., member) + FIELD_SIZEOF(...,
member)' to "offsetofend(..., member)" which does exactly what
we need without all the copy-paste.

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/bpf/test_run.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 915c2d6f7fb9..85c8cbbada92 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -252,22 +252,19 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 
 	/* priority is allowed */
 
-	if (!range_is_zero(__skb, offsetof(struct __sk_buff, priority) +
-			   FIELD_SIZEOF(struct __sk_buff, priority),
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, priority),
 			   offsetof(struct __sk_buff, cb)))
 		return -EINVAL;
 
 	/* cb is allowed */
 
-	if (!range_is_zero(__skb, offsetof(struct __sk_buff, cb) +
-			   FIELD_SIZEOF(struct __sk_buff, cb),
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, cb),
 			   offsetof(struct __sk_buff, tstamp)))
 		return -EINVAL;
 
 	/* tstamp is allowed */
 
-	if (!range_is_zero(__skb, offsetof(struct __sk_buff, tstamp) +
-			   FIELD_SIZEOF(struct __sk_buff, tstamp),
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, tstamp),
 			   sizeof(struct __sk_buff)))
 		return -EINVAL;
 
@@ -437,8 +434,7 @@ static int verify_user_bpf_flow_keys(struct bpf_flow_keys *ctx)
 
 	/* flags is allowed */
 
-	if (!range_is_zero(ctx, offsetof(struct bpf_flow_keys, flags) +
-			   FIELD_SIZEOF(struct bpf_flow_keys, flags),
+	if (!range_is_zero(ctx, offsetofend(struct bpf_flow_keys, flags),
 			   sizeof(struct bpf_flow_keys)))
 		return -EINVAL;
 
-- 
2.24.0.525.g8f36a354ae-goog

