Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C653C2BFC
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhGJAXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:23:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:60426 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhGJAXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:23:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="270913468"
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="270913468"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="462343533"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.240.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:57 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliangtang@gmail.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/6] mptcp: remove redundant req destruct in subflow_check_req()
Date:   Fri,  9 Jul 2021 17:20:47 -0700
Message-Id: <20210710002051.216010-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
References: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

In subflow_check_req(), if subflow sport is mismatch, will put msk,
destroy token, and destruct req, then return -EPERM, which can be
done by subflow_req_destructor() via:

  tcp_conn_request()
    |--__reqsk_free()
      |--subflow_req_destructor()

So we should remove these redundant code, otherwise will call
tcp_v4_reqsk_destructor() twice, and may double free
inet_rsk(req)->ireq_opt.

Fixes: 5bc56388c74f ("mptcp: add port number check for MP_JOIN")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 66d0b1893d26..b15e2017168d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -214,11 +214,6 @@ static int subflow_check_req(struct request_sock *req,
 				 ntohs(inet_sk(sk_listener)->inet_sport),
 				 ntohs(inet_sk((struct sock *)subflow_req->msk)->inet_sport));
 			if (!mptcp_pm_sport_in_anno_list(subflow_req->msk, sk_listener)) {
-				sock_put((struct sock *)subflow_req->msk);
-				mptcp_token_destroy_request(req);
-				tcp_request_sock_ops.destructor(req);
-				subflow_req->msk = NULL;
-				subflow_req->mp_join = 0;
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MISMATCHPORTSYNRX);
 				return -EPERM;
 			}
-- 
2.32.0

