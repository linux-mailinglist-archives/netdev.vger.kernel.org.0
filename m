Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9628229442C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438593AbgJTVA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:00:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438555AbgJTVA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:00:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KL0P04127503;
        Tue, 20 Oct 2020 21:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=myR4kkwdfHlM3xyjr28GtOPymrWGK3Mb26+e4zzpoXA=;
 b=n8UpiLFB0JrmT/KlMWGEAt4Agqnl8VT3mB4JZm/sW3rWQHrUSbCmD7g3aU/SZIUc/GvV
 PpG2GDfI2BC2XQBbttJ8ky4Zg9SnMo62Zg6s9pffgZxv/ODcTsi1gVzmKm3svodqqjOk
 TutAb+ZL8fFQVTQXR7fYFAitG5Fn94WnYvnF78I3VqXChiuRCum0Io/5EYfkk3M2+Hdh
 ttrOrqZ1nj/KcuRyjedFF49alR77ikgKmIVR233Us8XbWvTfWs2Hzyhf0ZOFrsr3BEY4
 psH3u51UA9MCJNEvFrpc1ejWh66HfApJLEJN0prnvBQpSPfnNGuJndByOUHA5EXuY9PJ mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 347s8mwac6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 21:00:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKu3Q7111426;
        Tue, 20 Oct 2020 20:58:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 348a6nmry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 20:58:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09KKwWIN027374;
        Tue, 20 Oct 2020 20:58:32 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 13:58:31 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 4BAAE6A5D98; Tue, 20 Oct 2020 17:00:08 -0400 (EDT)
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     eric.snowberg@oracle.com, john.haxby@oracle.com,
        todd.vierling@oracle.com
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matthew Garrett <mjg59@google.com>, netdev@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        James Morris <jmorris@namei.org>
Subject: [PATCH RFC UEK5 2/7] bpf: Restrict bpf when kernel lockdown is in confidentiality mode
Date:   Tue, 20 Oct 2020 16:59:59 -0400
Message-Id: <20201020210004.18977-3-konrad.wilk@oracle.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20201020210004.18977-1-konrad.wilk@oracle.com>
References: <20201020210004.18977-1-konrad.wilk@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1011 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_read() and bpf_read_str() could potentially be abused to (eg) allow
private keys in kernel memory to be leaked. Disable them if the kernel
has been locked down in confidentiality mode.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
cc: netdev@vger.kernel.org
cc: Chun-Yi Lee <jlee@suse.com>
cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: James Morris <jmorris@namei.org>

[Backport notes:
 The upstream version is using enums, and all that fancy code.
 We are just retroffiting UEK5 a bit and just checking to
 see if integrity mode has been enabled and if so then
 allow it. If the default lockdown mode (confidentiality) is on
 then we don't allow it.]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 security/lock_down.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/lock_down.c b/security/lock_down.c
index 96ff1badfac0b..1b913f855d48d 100644
--- a/security/lock_down.c
+++ b/security/lock_down.c
@@ -57,9 +57,16 @@ void __init init_lockdown(void)
  */
 bool __kernel_is_locked_down(const char *what, bool first)
 {
-	if (what && first && kernel_locked_down)
+	if (what && first && kernel_locked_down) {
+		/* If we are in integrity mode we allow certain callsites */
+		if (!lockdown_confidentiality) {
+			if ((strcmp(what, "BPF") == 0)) {
+				return 0;
+			}
+		}
 		pr_notice("Lockdown: %s is restricted; see man kernel_lockdown.7\n",
 			  what);
+	}
 	return kernel_locked_down;
 }
 EXPORT_SYMBOL(__kernel_is_locked_down);
-- 
2.13.6

