Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1147CB5B
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 03:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhLVC3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 21:29:03 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:50313 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237775AbhLVC3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 21:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1640140142; x=1671676142;
  h=from:to:cc:subject:date:message-id;
  bh=25A2RLRjV+lzLQA+Qzas0p+Abu4pT4L6NwBAMZ18Nyg=;
  b=fuMBqYrAXiC3WnV9D0XZU+cTcFZ2hp7Uv71HX/L93zTWiJy6kYSSd9j5
   lzGNk7AeU1f8OQ+Wqi0eUPfiMPoOqyt9np7eirGy2x54C/ptJq1BTawc8
   BkviFOP9PqJfUwCH2Oa/aOMqCBJgIrgKsu5gagx+2N5lVb7Rm/7vaHpL1
   4=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 21 Dec 2021 18:29:02 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-lv-u18-c.qualcomm.com) ([10.47.234.142])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP; 21 Dec 2021 18:29:01 -0800
Received: by hu-devc-lv-u18-c.qualcomm.com (Postfix, from userid 202676)
        id 650FF500177; Tue, 21 Dec 2021 18:28:01 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kafai@fb.com, maze@google.com, yhs@fb.com,
        Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Date:   Tue, 21 Dec 2021 18:27:37 -0800
Message-Id: <20211222022737.7369-1-quic_twear@quicinc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Need to modify the ds field to support upcoming
Wifi QoS Alliance spec. Instead of adding generic
function for just modifying the ds field, add
skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB. This
allows other fields in the network and transport header
to be modified in the future.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6102f093d59a..0c25aa2212a2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7289,6 +7289,8 @@ static const struct bpf_func_proto *
 cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+	case BPF_FUNC_skb_store_bytes:
+		return &bpf_skb_store_bytes_proto;
 	case BPF_FUNC_get_local_storage:
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_sk_fullsock:
-- 
2.17.1

