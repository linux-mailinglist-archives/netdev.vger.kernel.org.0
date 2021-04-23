Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906E3369004
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbhDWKFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbhDWKFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:05:42 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706AFC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:06 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c15so38830710wro.13
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iFvprk5eZdrkDBhOM9vDGXqzXgRtJo1NH3HF5wiCJ8w=;
        b=YzzxEQMRiIeqQutvaaH7MQMjSEZV9WesqCo+090HU0LoJ8dQ0JqFIqgKXeiuYFsEfh
         SLk19tIX/fWagO2H9UVV1KvqnhtHzbMPn4J5ZZ1nQ68Vzjcfou7LnFR0jNEikUSTn3eH
         sEmYkEtbhxulzeAJFx7OxoF6ziJhl9ygsx9gmqGHsiv4/rZ3mEqk3sOdm3lGjuopTH2P
         +BXrO7Y1UObb8W2xFbSqrGHM4lImuj/03vEf1plC4g/C8yWZwwR5CKlpOANIhC5gnUfV
         udK+1fMeY/7oU8ueYzREghu6D8eNltauj0aNI+vjQCWyhFOlH9b9l0uW4d6+UCBFpsbQ
         ytkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFvprk5eZdrkDBhOM9vDGXqzXgRtJo1NH3HF5wiCJ8w=;
        b=TouZEDSiR/QEwqbD6hDjq5hoxr+3LBMVOOhnKcvLBXI9i+o52yKYZeFLuUTCdwQ9pB
         SZS1owZBKDOK849T2THYKaynm5YjNebZMYdb1nnBVaWli5mQtkXgoRa30JMJtG/gmYgP
         j0leqTAnWyLnjssP2hb8k1R3aTlOPorxz7GnDlH5yqlYnhxlGkz91qVq3Ii2uIviUiIL
         eFPWDd9Gr7Py8pHTX/6KZ4e5uLbObdT9a5Ity66UuTICXYexBewvnO4iO0an3MmENK7L
         PTngHmBcLqNvaSla4cUztHaAbMf8D4JF839RlmUs6XnaBzP5IE5ujmXZ2WQzSDaTpWdN
         szPw==
X-Gm-Message-State: AOAM531SDRCBE8Z2aEcy15x7xKmEf3+Sri+U+9C0KS1RZCYp7erQQrFH
        pK2Fm+nKM7weEFV/babt5wg=
X-Google-Smtp-Source: ABdhPJz007+yIfG8kVQNq3vhnps8FNbFbz+ahSJoEBlbfrw6OaUIMmevEzGzQ3ylD4MBd1FHHT6LrA==
X-Received: by 2002:adf:d20b:: with SMTP id j11mr3744318wrh.292.1619172305240;
        Fri, 23 Apr 2021 03:05:05 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id t12sm8599481wrs.42.2021.04.23.03.05.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:05:04 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net 1/5] i40e: add correct exception tracing for XDP
Date:   Fri, 23 Apr 2021 12:04:42 +0200
Message-Id: <20210423100446.15412-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210423100446.15412-1-magnus.karlsson@gmail.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different errors
can occur. The support was only partial. Several errors where not
logged which would confuse the user quite a lot not knowing where and
why the packets disappeared.

Fixes: 74608d17fe29 ("i40e: add support for XDP_TX action")
Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 7 ++++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 06b4271219b1..08fbb2ec7ff8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2317,15 +2317,20 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
+		if (result == I40E_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = I40E_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 12ca84113587..ca7dd1afe37a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -166,15 +166,20 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
+		if (result == I40E_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = I40E_XDP_REDIR;
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

