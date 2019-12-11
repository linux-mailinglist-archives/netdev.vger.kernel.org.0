Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44FA811BAB0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfLKRxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:53:52 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:47210 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730390AbfLKRxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:53:52 -0500
Received: by mail-pf1-f202.google.com with SMTP id e62so2536334pfh.14
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZJ1oDyTzeXeW7N9+MWcw6Erx6CiN4LkWGkKMDboif64=;
        b=UEJDUel8+0mbaKzZkv5PN5vaSzLDpVZyCmC9O4Kr9JA44Q1Vf0cVw1Ksa/qoerfutZ
         oYFMs1CY+K8GlNR8+MaQJ6ew63QpIr61vK3GPfZEZHpwevAyDBb2URMbL4Z51Znd5NQu
         XC9DgrsZlmqYfLbt6ceiMjj0iolNVbAp2/0WW8ml38ehYA/0K9zQK2ikqxTvwAYGLD4A
         V2G1Ek1GxZPJOA3ZN1ZtBdyUw2FRV0qPeSI6qjmx/gYuLRGcag/AdEvM/w7kI4SdBh+Z
         5/Srm1oGpjXhKnjcQzYpk/Ze1rs2zDhOv+/tbRMRF4OLMDXtZOHvXYgNCZpQ6bmii0AN
         jCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZJ1oDyTzeXeW7N9+MWcw6Erx6CiN4LkWGkKMDboif64=;
        b=OUlTeq0enrRUv38+35XDXxOSZFSyH31VfvblIkNb3NpfOxj8O1W5VYCVUrlyf9WT4C
         JN9JDUz3MyNwYDZMZnWN4N0jvDCNFsFBfJhr/Yx5nIOGSVxgWON8GKtV+g6j6+iIeQde
         uTRvOYjPdV7QnMz0DPmXXu2ErdMabBK0vilhESSU4GSFq9TUgFb/+TbakG7PgC6C0MuA
         hwpmQek61+t0mJ/ve1+FD7Atr90ZpKJX6W+Gt5AnK0/pAMi0J83JaGeDy+8g6QrOIzR2
         SY6WcM3lO9sdbZT5+rzuZDW8ja0/KQj07QV2CO9B4ZZlSGP+ZwCbTUkpq8bDAPi0KhxY
         BcyA==
X-Gm-Message-State: APjAAAXF6J161ZNlwH3LxbUEkP4ZOFNcRVZTGEG1YUe7DmUnqwt4Iwbf
        1InLI5a7pH12ChKAnlFMmXteXEVFRAHDiQtJLZbh/H8A5OeL4DQ1E1sJiOieYIuFD7QYfkQCMd2
        XdizhsWU3UqBuOQRpwBgJ8tr7CvUGLHe2Zvc0NWhLSiG/HAXzvwiD3A==
X-Google-Smtp-Source: APXvYqyK6BjDE2BnAYzWgZj9ST91PypaNH+s76eIB4XplW47dYQSCT8BstG2UT0rErnRTFHE4rShTZc=
X-Received: by 2002:a63:d543:: with SMTP id v3mr5389333pgi.285.1576086831333;
 Wed, 11 Dec 2019 09:53:51 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:53:48 -0800
Message-Id: <20191211175349.245622-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH bpf-next 1/2] bpf: expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_RUN
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wire_len should not be less than real len and is capped by GSO_MAX_SIZE.
gso_segs is capped by GSO_MAX_SEGS.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/bpf/test_run.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 85c8cbbada92..06cadba2e3b9 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -263,8 +263,10 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 		return -EINVAL;
 
 	/* tstamp is allowed */
+	/* wire_len is allowed */
+	/* gso_segs is allowed */
 
-	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, tstamp),
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, gso_segs),
 			   sizeof(struct __sk_buff)))
 		return -EINVAL;
 
@@ -272,6 +274,14 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	skb->tstamp = __skb->tstamp;
 	memcpy(&cb->data, __skb->cb, QDISC_CB_PRIV_LEN);
 
+	if (__skb->wire_len < skb->len || __skb->wire_len > GSO_MAX_SIZE)
+		return -EINVAL;
+	cb->pkt_len = __skb->wire_len;
+
+	if (__skb->gso_segs > GSO_MAX_SEGS)
+		return -EINVAL;
+	skb_shinfo(skb)->gso_segs = __skb->gso_segs;
+
 	return 0;
 }
 
@@ -285,6 +295,8 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	__skb->priority = skb->priority;
 	__skb->tstamp = skb->tstamp;
 	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
+	__skb->wire_len = cb->pkt_len;
+	__skb->gso_segs = skb_shinfo(skb)->gso_segs;
 }
 
 int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
-- 
2.24.0.525.g8f36a354ae-goog

