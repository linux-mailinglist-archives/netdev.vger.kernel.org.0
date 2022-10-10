Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B09A5FA350
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 20:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJJSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 14:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJJSWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 14:22:23 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258151DA63
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 11:22:23 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id b5so10898575pgb.6
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bSxSJqNb+sqoNTXSt8Ye05VUAgMzhi/zgUSPCGgMEc=;
        b=n/8VHYiA7PJrbHwJIQGtT8aJdABS3/DM5tlhlN+UkXerEmjBV7g962mdOrOsnsFT0Z
         oKIpOF3iS/VaLfq79VOaHWcjnEGmtPNYaUtINafZ8N+Asxq+MC3qgBTt2Sh6iTREKXQQ
         0N5G//kY1te3/PKLi1pL5hwN5Ju4eFQlJ88RA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+bSxSJqNb+sqoNTXSt8Ye05VUAgMzhi/zgUSPCGgMEc=;
        b=wjKYbTVyVFtvdlw1Nu8duTinyxuyNT9nTnMRhy56BjBVaEmAAVuYAfnbd8T/vcMSEF
         wQ1OHcinKVSXn7Mwnk66z42CalOlvMyRUCEO+tpQYv8sQPQh7oOi9JfLdZccHXJKpHg1
         9Ms+hdnqr6rqVRtbWyuzdvS0k8w6I1bHiloO0PIfiUF61mR8cuIy+v0OoFfYPySB28dm
         2VN772WHtEscZd3/Kp9vwxvWcx2odEnESKJzhP2BbiMXn7wrxH1nqmUn6EGuUYaakRFM
         eDvcl3dukJXXPYj26dT5kuwOqXvTD229xlbKHMoshvHQz2Kyd3NnK2Sk5hk27YlmRWsU
         L27Q==
X-Gm-Message-State: ACrzQf272Y+VlI5RV7NN78a1H0Hmuh9a8JfzJTS0DKaJbw5yZW+eQxnf
        IZ+mXfdkKV6gYkxrUPBuFhOAxiQY5uSbyXCct/r4+BF20PyEtundM8uzcTRxvPZAJp64fUZM5Wj
        iPrU5TLS7YrUpNOZ/MATL+VhyZ773+u2//IWOSrlwtJhdiLbgW42NtSo/7W0QE365x9Dx
X-Google-Smtp-Source: AMsMyM4mprkW/0gEZ0uddLZDAnuC3PC2QmjdN6vWo+03MtObwNsStMpdQpOumTxOgNHkjhMX5aI4Mw==
X-Received: by 2002:a63:186:0:b0:442:ee11:48a5 with SMTP id 128-20020a630186000000b00442ee1148a5mr17565584pgb.284.1665426142330;
        Mon, 10 Oct 2022 11:22:22 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79e52000000b005632d3b5c9csm3460195pfq.211.2022.10.10.11.22.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Oct 2022 11:22:22 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [net-next PATCH] net: core: Add napi_complete_done tracepoint
Date:   Mon, 10 Oct 2022 11:21:34 -0700
Message-Id: <1665426094-88160-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint to help debug napi_complete_done. Users who set
defer_hard_irqs and the GRO timer can use this tracepoint to better
understand what impact these options have when their NIC driver calls
napi_complete_done.

perf trace can be used to enable the tracepoint and the output can be
examined to determine which settings should be adjusted.

$ sudo perf trace -e napi:napi_complete_done -a --call-graph=fp --libtraceevent_print

356.774 :0/0 napi:napi_complete_done(napi_complete_done on napi struct 0xffff88e052f02010 dev vlan100 irq_defers_remaining 2 timeout 20000 work_done 0 ret 0)
	napi_complete_done ([kernel.kallsyms])
	napi_complete_done ([kernel.kallsyms])
	i40e_napi_poll ([i40e])
	__napi_poll ([kernel.kallsyms])
	net_rx_action ([kernel.kallsyms])
	__do_softirq ([kernel.kallsyms])
	sysvec_apic_timer_interrupt ([kernel.kallsyms])
	asm_sysvec_apic_timer_interrupt ([kernel.kallsyms])
	intel_idle_irq ([kernel.kallsyms])
	cpuidle_enter_state ([kernel.kallsyms])
	cpuidle_enter ([kernel.kallsyms])
	do_idle ([kernel.kallsyms])
	cpu_startup_entry ([kernel.kallsyms])
	[0x243d98] ([kernel.kallsyms])
	secondary_startup_64_no_verify ([kernel.kallsyms])

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/trace/events/napi.h | 29 +++++++++++++++++++++++++++++
 net/core/dev.c              |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index 6678cf8..e8473d3 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -11,6 +11,35 @@
 
 #define NO_DEV "(no_device)"
 
+TRACE_EVENT(napi_complete_done,
+	TP_PROTO(struct napi_struct *napi, int hard_irq_defer, unsigned long timeout,
+		int work_done, bool ret),
+
+	TP_ARGS(napi, hard_irq_defer, timeout, work_done, ret),
+
+	TP_STRUCT__entry(
+		__field(	struct napi_struct *,	napi)
+		__string(	dev_name,  napi->dev ? napi->dev->name : NO_DEV)
+		__field(	int,			hard_irq_defer)
+		__field(	unsigned long,		timeout)
+		__field(	int,			work_done)
+		__field(	int,			ret)
+	),
+
+	TP_fast_assign(
+		__entry->napi = napi;
+		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
+		__entry->hard_irq_defer = hard_irq_defer;
+		__entry->timeout = timeout;
+		__entry->work_done = work_done;
+		__entry->ret = ret;
+	),
+
+	TP_printk("napi_complete_done on napi struct %p dev %s irq_defers_remaining %d timeout %lu work_done %d ret %d",
+		__entry->napi, __get_str(dev_name), __entry->hard_irq_defer,
+		__entry->timeout, __entry->work_done, __entry->ret)
+);
+
 TRACE_EVENT(napi_poll,
 
 	TP_PROTO(struct napi_struct *napi, int work, int budget),
diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830..e601f97 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6091,6 +6091,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 	if (timeout)
 		hrtimer_start(&n->timer, ns_to_ktime(timeout),
 			      HRTIMER_MODE_REL_PINNED);
+
+	trace_napi_complete_done(n, n->defer_hard_irqs_count, timeout, work_done, ret);
 	return ret;
 }
 EXPORT_SYMBOL(napi_complete_done);
-- 
2.7.4

