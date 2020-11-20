Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99D62BB3D5
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbgKTSio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730900AbgKTSim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:42 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C4121D91;
        Fri, 20 Nov 2020 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897522;
        bh=VTHRslqAi1uoY+aDcHnLLFPLWt88Db72fhwgoQKvPB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ILXKx4tvUfne0yLrwW0TBzswhYbTvB4M69NonHE7gnhRnu6jTk2ZaRg1IrB/978Rd
         UPLF8XOHWiVmGhKJvoM7KB45O5d8bamDNSEfly7bCamk81+jIil7rB6PDoCkBl5B6V
         djUyZCiDABEkJwwmyFLcBcY66tOFHKog24H64wiM=
Date:   Fri, 20 Nov 2020 12:38:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 115/141] rds: Fix fall-through warnings for Clang
Message-ID: <7af5923b0293ec5715d17c2290664ca1a6552b1b.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
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

