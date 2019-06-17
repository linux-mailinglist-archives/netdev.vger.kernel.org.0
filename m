Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CFB4834D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 14:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfFQM6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 08:58:33 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:48195 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQM6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 08:58:33 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MUGmL-1i2X5B21xb-00RGpA; Mon, 17 Jun 2019 14:57:26 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Matt Mullins <mmullins@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: hide do_bpf_send_signal when unused
Date:   Mon, 17 Jun 2019 14:57:07 +0200
Message-Id: <20190617125724.1616165-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lv1nV0q2KbUMLMJzM+Nv3YOvipTsLH12zv/CeHO3aM7xRWpsk6s
 MbUPGLsitpF3TOjYCzlqF0IIvcsMradip8JB0/CUnr3t/qfkB8u0XIVPwTaqXTUvD7uoH7a
 yj/56+kA2aGM5QMT0yfoToSqTFfsRpsP5JbFYCWHtLMam1v2JccNpZQgvhoRuCWXd+8txJs
 2t1kKKuGSikq+VLG5PDRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:W8pOpR/fJNI=:RukQ8rvFS6v8Sdui3NcM/A
 QXWuaCdtUF0v3yBtEnVuHl3st4RdUWL3hkaZKBc0iPvtUEtN5ddNlWxVsSbdG7oE4yKvcLK15
 caHFgNzGyuVfraobUd4GpLTv5spdqPfybkKuoFYDIUweW/hqR/l73TBT9vglORMtJ5exJuTLX
 JvKMjVpNLI4syHtmARttM/n7uHotzqntj5vmuPhNRDMgCjVsdpaHOx8KuDRJL7hSuHiAYMW6x
 c7UBAA5LlMD0grB62BmTswCBNltaREih1d1rx6REAaUxLZsXSHvu3USMghAVYTSIcgL9g9JJB
 xcJfKVC11w0HtL+tIJy4DeAXwHvue3CY7V3yXq8chijEI8GaMfD99Q4OFY6fGBroMgifs+PwI
 7JZhMzdUcs1M9EYaXit4XdlI6rb0vPrqOfgrm/f6DBghnXhvcP1Mg6bbnwv7pFsN5PX1ghQ3v
 mdx7gjeOq1Nc5kD4sZMBKqh9VPeaBLeAfAL0lHYmakKzY7vNtzeh/1k+Yf1duWs4Ftht/P34J
 9tbD7y69nHGkyJJ0v9Y8Yn7pZdyydhr10byBMUNSbJVb2Cdkb36EEnMBJA6HiEFntAAQVsWuh
 9F4CQoR+XgZHuxdcW54J1xJcf3slxXdjxaCOiFWCLYNWY36CQKkmi2nF5ppQ43GZf31tOfq+N
 kC7jiN730Jebq66xJLS1WcxEom2R4w88bIfZj6T3iejb8A+vJGso2JKPHhaCyoXEornIGc1Y1
 ZkC+rbIHph++fVSRKPwnuMUJcrsjSf/+DcvTtQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_MODULES is disabled, this function is never called:

kernel/trace/bpf_trace.c:581:13: error: 'do_bpf_send_signal' defined but not used [-Werror=unused-function]

Add another #ifdef around it.

Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c102c240bb0b..b1a814e2d451 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -602,6 +602,7 @@ struct send_signal_irq_work {
 
 static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
 
+#ifdef CONFIG_MODULES
 static void do_bpf_send_signal(struct irq_work *entry)
 {
 	struct send_signal_irq_work *work;
@@ -609,6 +610,7 @@ static void do_bpf_send_signal(struct irq_work *entry)
 	work = container_of(entry, struct send_signal_irq_work, irq_work);
 	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, PIDTYPE_TGID);
 }
+#endif
 
 BPF_CALL_1(bpf_send_signal, u32, sig)
 {
-- 
2.20.0

