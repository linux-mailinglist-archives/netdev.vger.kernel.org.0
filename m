Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684CB32E451
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCEJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhCEJGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:06:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65ED764F44;
        Fri,  5 Mar 2021 09:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614935175;
        bh=VTHRslqAi1uoY+aDcHnLLFPLWt88Db72fhwgoQKvPB8=;
        h=Date:From:To:Cc:Subject:From;
        b=mv5mTBaogU+1Y5d/hWqjKltuDVWzhkPr8EELnX5ynakrw6CBagOK3ubYc9txv8mhN
         0UujYgblHcovwk8A6gO/eKrTUWNSdLDJojr20e570f66q8UvsagZwl0sHs5cg0NUIQ
         yaOCj7t/aQKcybKh/OFXczrpT+OMaBgGillXJzglJS741CmCoRF1TOaXHPvBjV13Nr
         Aueb/VsbFBnod+g5ZeuYapUCUy3/NT8llhKE/tdN4Ea8dtw6/dluL5f+ClfHtkkv09
         cHzuGEoX0iOUVh9mOvFMzNdavxc3AFgioOhG5+MPd5WZom9yxZJ0LC7I0k1aFh45dl
         k8zhLz3gnsC0w==
Date:   Fri, 5 Mar 2021 03:06:12 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] rds: Fix fall-through warnings for Clang
Message-ID: <20210305090612.GA139288@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/rds/tcp_connect.c | 1 +
 net/rds/threads.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
index 4e64598176b0..5461d77fff4f 100644
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -78,6 +78,7 @@ void rds_tcp_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 	case TCP_CLOSE:
 		rds_conn_path_drop(cp, false);
+		break;
 	default:
 		break;
 	}
diff --git a/net/rds/threads.c b/net/rds/threads.c
index 32dc50f0a303..1f424cbfcbb4 100644
--- a/net/rds/threads.c
+++ b/net/rds/threads.c
@@ -208,6 +208,7 @@ void rds_send_worker(struct work_struct *work)
 		case -ENOMEM:
 			rds_stats_inc(s_send_delayed_retry);
 			queue_delayed_work(rds_wq, &cp->cp_send_w, 2);
+			break;
 		default:
 			break;
 		}
@@ -232,6 +233,7 @@ void rds_recv_worker(struct work_struct *work)
 		case -ENOMEM:
 			rds_stats_inc(s_recv_delayed_retry);
 			queue_delayed_work(rds_wq, &cp->cp_recv_w, 2);
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

