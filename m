Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8471955CEF
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZAfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:35:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726223AbfFZAfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:35:09 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q0Yc7P023124
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:35:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=ilCz0r4rFQeiGHJo/tWLnjPRjcP2MfFn/TIBT8YcCPM=;
 b=JH6j+9E54U8HVOwRwhMykC26rwl2YEpW/iLXsgNh3rbsRrdepSQrUHFToHma1yG0pHaB
 XV8E4lo9pHefb5AAHYgEX0ChUlqi+VwkKqo6toklPtG4L9bfh6drO/YTrv0eNxTHQl8U
 o3kPU2o4au4ADXAOBEUgTW5ebQiV3OuH2G4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbs17h94n-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:35:08 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 17:35:05 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 740373702BCE; Tue, 25 Jun 2019 17:35:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <ast@fb.com>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <arnd@arndb.de>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: fix compiler warning with CONFIG_MODULES=n
Date:   Tue, 25 Jun 2019 17:35:03 -0700
Message-ID: <20190626003503.1985698-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_MODULES=3Dn, the following compiler warning occurs:
  /data/users/yhs/work/net-next/kernel/trace/bpf_trace.c:605:13: warning:
      =E2=80=98do_bpf_send_signal=E2=80=99 defined but not used [-Wunused=
-function]
  static void do_bpf_send_signal(struct irq_work *entry)

The __init function send_signal_irq_work_init(), which calls
do_bpf_send_signal(), is defined under CONFIG_MODULES. Hence,
when CONFIG_MODULES=3Dn, nobody calls static function do_bpf_send_signal(=
),
hence the warning.

The init function send_signal_irq_work_init() should work without
CONFIG_MODULES. Moving it out of CONFIG_MODULES
code section fixed the compiler warning, and also make bpf_send_signal()
helper work without CONFIG_MODULES.

Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
Reported-By: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/trace/bpf_trace.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c102c240bb0b..ca1255d14576 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1431,6 +1431,20 @@ int bpf_get_perf_event_info(const struct perf_even=
t *event, u32 *prog_id,
 	return err;
 }
=20
+static int __init send_signal_irq_work_init(void)
+{
+	int cpu;
+	struct send_signal_irq_work *work;
+
+	for_each_possible_cpu(cpu) {
+		work =3D per_cpu_ptr(&send_signal_work, cpu);
+		init_irq_work(&work->irq_work, do_bpf_send_signal);
+	}
+	return 0;
+}
+
+subsys_initcall(send_signal_irq_work_init);
+
 #ifdef CONFIG_MODULES
 static int bpf_event_notify(struct notifier_block *nb, unsigned long op,
 			    void *module)
@@ -1478,18 +1492,5 @@ static int __init bpf_event_init(void)
 	return 0;
 }
=20
-static int __init send_signal_irq_work_init(void)
-{
-	int cpu;
-	struct send_signal_irq_work *work;
-
-	for_each_possible_cpu(cpu) {
-		work =3D per_cpu_ptr(&send_signal_work, cpu);
-		init_irq_work(&work->irq_work, do_bpf_send_signal);
-	}
-	return 0;
-}
-
 fs_initcall(bpf_event_init);
-subsys_initcall(send_signal_irq_work_init);
 #endif /* CONFIG_MODULES */
--=20
2.17.1

