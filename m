Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC49215AE0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgGFPjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729254AbgGFPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066FaWXx025630;
        Mon, 6 Jul 2020 08:39:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=DcdPwDvhuPJcsO4BJxkcmalzsqS6wLzExrPO+hfL5R8=;
 b=HF6Gj9HOj8Qak9nrzQrXsr97aNBOP8ifCwnlXycMdUgEG0LPX19yMmM9z47xmDBY8r5s
 4bu2rYsCd0TESZuHJjaFS2a6EdSCgVCaPuDELdgHLdBtoZNtpc1D6696G1u9aZ9KrpFu
 Bt1Ow0FedadxHBpaVPHUaWVAK1gr1Gi/h/6fR7VtGeei1Nav7LCQj1njc0Fk6cZZBhz2
 LfQQ1kAO9T794n7AfCoekyutWDMPxsLzMtBlB6CiSuLGY7tz8dUcxqsQIyUYo4O7Oc1N
 CCI92AkV9YVnhpl3hvLeVx84aorUf0+GXTf8lstg9vw9zRZ7Grey/qinOQhLCdGV7kMp RA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:02 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id A6B933F703F;
        Mon,  6 Jul 2020 08:38:58 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/9] net: qed: correct qed_hw_err_notify() prototype
Date:   Mon, 6 Jul 2020 18:38:15 +0300
Message-ID: <20200706153821.786-4-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the prototype of qed_hw_err_notify() with the following:
* constify "fmt" argument according to printk() declarations;
* anontate it with __cold attribute to move the function out of
  the line;
* annotate it with __printf() attribute;

This eliminates W=1+ warning:

drivers/net/ethernet/qlogic/qed/qed_hw.c: In function
‘qed_hw_err_notify’:
drivers/net/ethernet/qlogic/qed/qed_hw.c:851:3: warning: function
‘qed_hw_err_notify’ might be a candidate for ‘gnu_printf’ format
attribute [-Wsuggest-attribute=format]
 len = vsnprintf(buf, QED_HW_ERR_MAX_STR_SIZE, fmt, vl);
 ^~~

as well as saves some code size:

add/remove: 0/0 grow/shrink: 2/4 up/down: 40/-125 (-85)
Function                                     old     new   delta
qed_dmae_execute_command                    1680    1711     +31
qed_spq_post                                1104    1113      +9
qed_int_sp_dpc                              3554    3545      -9
qed_mcp_cmd_and_union                       1896    1876     -20
qed_hw_err_notify                            395     352     -43
qed_mcp_handle_events                       2630    2577     -53
Total: Before=368645, After=368560, chg -0.02%

__printf() will also be helpful with catching bad format strings
and arguments.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hw.c | 5 ++---
 drivers/net/ethernet/qlogic/qed/qed_hw.h | 7 ++++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index e8c777f30207..554f30b0cfd5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -812,9 +812,8 @@ int qed_dmae_host2host(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
-void qed_hw_err_notify(struct qed_hwfn *p_hwfn,
-		       struct qed_ptt *p_ptt,
-		       enum qed_hw_err_type err_type, char *fmt, ...)
+void qed_hw_err_notify(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+		       enum qed_hw_err_type err_type, const char *fmt, ...)
 {
 	char buf[QED_HW_ERR_MAX_STR_SIZE];
 	va_list vl;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.h b/drivers/net/ethernet/qlogic/qed/qed_hw.h
index 6a61b88b544d..2734f49956f7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.h
@@ -301,7 +301,8 @@ int qed_dmae_sanity(struct qed_hwfn *p_hwfn,
  * @param fmt - debug data buffer to send to the MFW
  * @param ... - buffer format args
  */
-void qed_hw_err_notify(struct qed_hwfn *p_hwfn,
-		       struct qed_ptt *p_ptt,
-		       enum qed_hw_err_type err_type, char *fmt, ...);
+void __printf(4, 5) __cold qed_hw_err_notify(struct qed_hwfn *p_hwfn,
+					     struct qed_ptt *p_ptt,
+					     enum qed_hw_err_type err_type,
+					     const char *fmt, ...);
 #endif
-- 
2.25.1

