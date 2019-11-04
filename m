Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88091EDB7C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 10:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfKDJSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 04:18:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58446 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfKDJSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 04:18:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA49EJDS119332;
        Mon, 4 Nov 2019 09:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=VpF3n2MgAvnlY9fnK2p5DZXyfZYTZBZEOdxJexzBBgY=;
 b=WHXxkPBg/zyHB8fTDOt7V7tqEVbSzSVFdziz7+YrmuapIUqNxXN01fkxYeuErCCpArBU
 h8ypWDbDEBxRUYyKQbNYgx1FGAhckqzJ+mOyE2v3sNbTZQYwP/TMu2dmwol0RXLkrNBZ
 h8iQEqGZ00g6R+Lprzn/X0HoIA1tyEp59O9Iu+c4IIwThYBsBzyybGyC+dB8x3vvYn5z
 NhUXtuyAHI8uYCEp9kPhULUbZtRHyp3/4myG10HrErIbnEu9KPQAL3iHgtV7CFSG8ZAy
 bJd+AQXem25yywirWdT50lkXVQxa1hME/ZmHxICnHMtnXWMDDsA2ACWalR1sNEEmJ/kX Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rpnw46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 09:17:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA49ELXk104410;
        Mon, 4 Nov 2019 09:15:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w1kxcvv1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 09:15:50 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA49Fln4011621;
        Mon, 4 Nov 2019 09:15:47 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 01:15:46 -0800
Date:   Mon, 4 Nov 2019 12:15:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH bpf] bpf: offload: unlock on error in bpf_offload_dev_create()
Message-ID: <20191104091536.GB31509@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040092
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to drop the bpf_devs_lock on error before returning.

Fixes: 9fd7c5559165 ("bpf: offload: aggregate offloads per-device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis.  Not tested.

 kernel/bpf/offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index ba635209ae9a..5b9da0954a27 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -678,8 +678,10 @@ bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
 	down_write(&bpf_devs_lock);
 	if (!offdevs_inited) {
 		err = rhashtable_init(&offdevs, &offdevs_params);
-		if (err)
+		if (err) {
+			up_write(&bpf_devs_lock);
 			return ERR_PTR(err);
+		}
 		offdevs_inited = true;
 	}
 	up_write(&bpf_devs_lock);
-- 
2.20.1

