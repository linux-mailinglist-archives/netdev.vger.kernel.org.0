Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD39E15FAD6
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgBNXl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:41:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726861AbgBNXl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:41:57 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ENYc5S021549
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 15:41:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=s5AINjqbi4/0oeVLttio2uLVEGZPsLRmz6siQCTuMVM=;
 b=JqaETfaj5Wx/w5LIRtwG2/Os7HChJsAa1IO6j82hc1MvdkD7l//46b1LSo5RdkJm/215
 oW0hTCi+KebW+g4nIry3b1FrRMQChJ2dsikUYjOQSeksnudCL20X4V+FfUfBiLc14dwm
 1kPMwijPakKlwHd1DKME9mnKIzpTQwG2/i8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y5yud1ngs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 15:41:56 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 14 Feb 2020 15:41:54 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 6ABCD62E356D; Fri, 14 Feb 2020 15:41:48 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: allow bpf_perf_event_read_value in all BPF programs
Date:   Fri, 14 Feb 2020 15:41:46 -0800
Message-ID: <20200214234146.2910011-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_09:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=956
 clxscore=1015 adultscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_perf_event_read_value() is NMI safe. Enable it for all BPF programs.
This can be used in fentry/fexit to profile BPF program and individual
kernel function with hardware counters.

Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/trace/bpf_trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 19e793aa441a..4ddd5ac46094 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -843,6 +843,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_send_signal_proto;
 	case BPF_FUNC_send_signal_thread:
 		return &bpf_send_signal_thread_proto;
+	case BPF_FUNC_perf_event_read_value:
+		return &bpf_perf_event_read_value_proto;
 	default:
 		return NULL;
 	}
@@ -858,8 +860,6 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_stackid_proto;
 	case BPF_FUNC_get_stack:
 		return &bpf_get_stack_proto;
-	case BPF_FUNC_perf_event_read_value:
-		return &bpf_perf_event_read_value_proto;
 #ifdef CONFIG_BPF_KPROBE_OVERRIDE
 	case BPF_FUNC_override_return:
 		return &bpf_override_return_proto;
-- 
2.17.1

