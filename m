Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3231E369006
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbhDWKFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241919AbhDWKFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:05:45 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C0DC06174A
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c15so38830842wro.13
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JdL0Ez3l1Nos4wM54poc3BjM7zKIfXH2UXskbWVhJQ8=;
        b=BPfOgWrCFfFO+GSxopd1iPXmx6Fi/SDqLU5KGt04otBrlAsUPvTFVuFvUCCobsoK9n
         yhN+TF4rSwk/w/WAakBCsfp0l0YiQXpP8EVhKq+aZBOsY7sdPZcdhektO/kRVQ3V5EI7
         oYXnt2yveN9w2Cb/kqJyaz+4tgxtJehRueescJMizeu60ci9RtA1PDVMmdN1lnuKMlVo
         XBwPO1FwNs87YkQ8y7LxL+lV1xBBoKJITUKYv5NrgVmUCudCk45LHubg2RvNLWMNEi4f
         81S75sVpSsX4VHHwLFoupaA0xyWXqN+brasm0R+1OWCoHa23y5KoYZs6/nwhXa1SQaxt
         m32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JdL0Ez3l1Nos4wM54poc3BjM7zKIfXH2UXskbWVhJQ8=;
        b=oeIWxlE+hjcCw0kb6c5u8q9o0NismnJiBHgBJyvX6jgJ0ygCk3MCWVvMjqg7qHbAgm
         GN0dS+emKfobDZB5jithnNKMqClJ8NPRTA4oq9tdIbNAbFHlIdCdnEL5cKgi/S3i46nW
         MZONgz0O6KdRdA1QHoWFasgNiNY3tkMpeXnGMKHnYTcRvuOmDAKQsS/x4NN2lhHAeU+t
         WovZpTpFGQOzA1n4/JuCO8gONoNBprD+n+ZILcP9gVNMnQpCBBxM5gS/UCzOb2D8zTuN
         Y+vvCbpjhm+DAGpP4PLUUtOST9qXoxvVY69zZh5cVQGqbbJYWfunsgq2kubSQihUjmg2
         7MhA==
X-Gm-Message-State: AOAM532Ks3l1ygYdmFp7efoXZKVjCo6cL2y/BrlraMSY+TVReMKEViXF
        GftbFrpcAqll7g3K2Q0MW+M=
X-Google-Smtp-Source: ABdhPJxtd9/pnCXV3cMTAh5A+jskcQD0uwhYXOAEiYFQ3RRaBWlmASMQYIVwv37gq+gFdNSpj0NFqA==
X-Received: by 2002:adf:f5cc:: with SMTP id k12mr3626655wrp.117.1619172307458;
        Fri, 23 Apr 2021 03:05:07 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id t12sm8599481wrs.42.2021.04.23.03.05.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:05:07 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net 3/5] ixgbe: add correct exception tracing for XDP
Date:   Fri, 23 Apr 2021 12:04:44 +0200
Message-Id: <20210423100446.15412-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210423100446.15412-1-magnus.karlsson@gmail.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 ++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 13 ++++++++-----
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cffb95f8f632..c194158a421c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2213,23 +2213,23 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
+		if (unlikely(!xdpf))
+			goto out_failure;
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		if (result == IXGBE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (!err)
-			result = IXGBE_XDP_REDIR;
-		else
-			result = IXGBE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IXGBE_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 3771857cf887..5f01e724037a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -109,20 +109,23 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
+		if (unlikely(!xdpf))
+			goto out_failure;
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		if (result == IXGBE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IXGBE_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.29.0

