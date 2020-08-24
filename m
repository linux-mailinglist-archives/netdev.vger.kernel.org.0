Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCE025097E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHXTjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHXTi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 15:38:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8E9C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 12:38:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y9so11786601ybp.8
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 12:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=g4pL4sVyrmOHm7d8P2FtckN7sUsE1ULTw8xRTNRh+SI=;
        b=CoV/L53mwlQU4CmFv+qyfNTZJqXqwvTa0hKuq5T9gfLT05XMqzwM+AiGNQ2LPdOOSL
         djCoEUi6/nIJ0xI0ldNXvhw+jSelLMQA/N+/QLUdCIQ/mBxOdJMO0OEaFHoV9JNOfvJ8
         zOVbX7q4qMmz9OdrnQRYYpapzeAuvgHYeRNvbT0hi4hpqV6k86Yw8EeAqDsKEy8cDOIz
         p86j1+a8DcwbanlYBPSIKF+JcVwH4PJGPLhCef6gKKTawRbAq8YsOWovfsUD2apLiVly
         wxVsvt3Fn9tOgClVYY+Iet4yYT5mCmB2KtcU9xd0PliAWN0Ji5wZRmuVIhF1c0MBAtC4
         +k8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g4pL4sVyrmOHm7d8P2FtckN7sUsE1ULTw8xRTNRh+SI=;
        b=VUv/dB60UeCS2LnF9HuZEciz0yT2cs/SqXksoXdvd4T4rH/76gpDRfQzNCp9mBu+Fy
         PBlxUVjrBPZPmFdViCjmYzLjKtZzIVYB2kmzOdyb2PI9NK54ULLkyp0zEE/wsjL/+rgD
         YQRP7N2wgNvbP7wJpLANiygbwkdX/JF2I0QgOmYEYYZGJal0HH9Ri7tzSx9UlRO16ITs
         NSU4D1SdNOpPz8KqeAnU9wRwWAOLtoEwdOFfV5IFZj9CEBGfyIibDzq03tm3MLAX195i
         ZHU6CkHUpTlwqEzH6Crf//QU0EYXs2IQOlBiWWgPRB11R4kxHcE3+PPljlzHwNf1FcrF
         L+cg==
X-Gm-Message-State: AOAM533UYTZxGLJwlkCYnJ8k4lf094+noLUm4UGcGY+BKIf5jGG1adua
        8U7W9DpRnv0J5zSkkOTAoJi+JV6s7N6rqYvjCJw=
X-Google-Smtp-Source: ABdhPJz54Qy8rUAZu+NRaiGqe2/DL4+O296F7M9YhQOXOdT7uRz6rqiIoIKEPsVPlHFnFppwvghUIOpqviAIabHIkcA=
X-Received: from willmcvicker.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:2dd0])
 (user=willmcvicker job=sendgmr) by 2002:a25:37ca:: with SMTP id
 e193mr10506255yba.387.1598297937465; Mon, 24 Aug 2020 12:38:57 -0700 (PDT)
Date:   Mon, 24 Aug 2020 19:38:32 +0000
In-Reply-To: <20200824193832.853621-1-willmcvicker@google.com>
Message-Id: <20200824193832.853621-2-willmcvicker@google.com>
Mime-Version: 1.0
References: <20200804113711.GA20988@salvia> <20200824193832.853621-1-willmcvicker@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v3 1/1] netfilter: nat: add a range check for l3/l4 protonum
From:   Will McVicker <willmcvicker@google.com>
To:     stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Will McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The indexes to the nf_nat_l[34]protos arrays come from userspace. So
check the tuple's family, e.g. l3num, when creating the conntrack in
order to prevent an OOB memory access during setup.  Here is an example
kernel panic on 4.14.180 when userspace passes in an index greater than
NFPROTO_NUMPROTO.

Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:...
Process poc (pid: 5614, stack limit = 0x00000000a3933121)
CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
task: 000000002a3dfffe task.stack: 00000000a3933121
pc : __cfi_check_fail+0x1c/0x24
lr : __cfi_check_fail+0x1c/0x24
...
Call trace:
__cfi_check_fail+0x1c/0x24
name_to_dev_t+0x0/0x468
nfnetlink_parse_nat_setup+0x234/0x258
ctnetlink_parse_nat_setup+0x4c/0x228
ctnetlink_new_conntrack+0x590/0xc40
nfnetlink_rcv_msg+0x31c/0x4d4
netlink_rcv_skb+0x100/0x184
nfnetlink_rcv+0xf4/0x180
netlink_unicast+0x360/0x770
netlink_sendmsg+0x5a0/0x6a4
___sys_sendmsg+0x314/0x46c
SyS_sendmsg+0xb4/0x108
el0_svc_naked+0x34/0x38

Fixes: c1d10adb4a521 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Will McVicker <willmcvicker@google.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 31fa94064a62..0b89609a6e9d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	if (!tb[CTA_TUPLE_IP])
 		return -EINVAL;
 
+	if (l3num != NFPROTO_IPV4 && l3num != NFPROTO_IPV6)
+		return -EOPNOTSUPP;
 	tuple->src.l3num = l3num;
 
 	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
-- 
2.28.0.297.g1956fa8f8d-goog

