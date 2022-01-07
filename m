Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7741486EA4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343996AbiAGAUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:47984 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343961AbiAGAUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514841; x=1673050841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wc56x3z89MoqMhqYjlsOIeQJY/RWfoCH4DjPm2rYDaM=;
  b=FXPkbkmx2t7rgxuPU6ybV9jO21OPqd3hncD5M9U0XJRpvDt5PPEqRLUI
   SLiULMwVRr3pZwEqyx288YYZxr6Y7GtHpNSWDrnNfbSflmMq+iFZX1cn/
   sfDPC0sd0FVLK2mOY+JD0TFnL+9AO/D4VDy+lgr4OaLo5mbT34MQd4SWO
   vBF1ir2cm1jJ5MFc7kC1DJOt/d8rZWp2rMmrBCctNil26RXNAcuMkO0Vk
   7DNb7L/gGAbK28xsAboA8F3S3/bKBbDMf2IHvRyZgiVHW5E5sD+ufGRw8
   WzsFAjbCPdOUGctazAcH1dq9ZvZvDKjNvSBSC2ElsbA4xjioOKtpwEt3g
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721300"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721300"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508492"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/13] mptcp: keep snd_una updated for fallback socket
Date:   Thu,  6 Jan 2022 16:20:14 -0800
Message-Id: <20220107002026.375427-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After shutdown, for fallback MPTCP sockets, we always have

write_seq == snd_una+1

The above will foul OUTQ ioctl(). Keep snd_una in sync with
write_seq even after shutdown.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index df5a0cf431c1..f6fc0f0f66f0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2666,6 +2666,7 @@ static void __mptcp_check_send_data_fin(struct sock *sk)
 	 * state now
 	 */
 	if (__mptcp_check_fallback(msk)) {
+		WRITE_ONCE(msk->snd_una, msk->write_seq);
 		if ((1 << sk->sk_state) & (TCPF_CLOSING | TCPF_LAST_ACK)) {
 			inet_sk_state_store(sk, TCP_CLOSE);
 			mptcp_close_wake_up(sk);
-- 
2.34.1

