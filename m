Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF032B6978
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKQQKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKQQKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 11:10:03 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97F7A2463D;
        Tue, 17 Nov 2020 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605629401;
        bh=8XfGb6kRV71gq8MgGR6Lzjg87391NOSJbLR+3IFAdF8=;
        h=Date:From:To:Cc:Subject:From;
        b=pJGR+0lFEfWLYhgiiVD0W6QgMjylRhNdE2GFxxnGP1OjTUMnxhPTEUDFrvtE271Gt
         qAZCm14hc/bHQWNEIo7uHq25toqWIq6wPMiPA/EDJGegcJ8uAuPkof8iGxQWFEyVG9
         YVv/wU62F+99XD25gNDH0lcoVUXj3uLPDeqw++Yw=
Date:   Tue, 17 Nov 2020 10:09:58 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] mwifiex: Fix fall-through warnings for Clang
Message-ID: <20201117160958.GA18807@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 2 ++
 drivers/net/wireless/marvell/mwifiex/sta_event.c   | 1 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     | 1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c         | 1 +
 4 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 119ccacd1fcc..6b5d35d9e69f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -201,6 +201,7 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 			mwifiex_dbg(priv->adapter, INFO,
 				    "info: SNMP_RESP: DTIM period=%u\n",
 				    ul_temp);
+			break;
 		default:
 			break;
 		}
@@ -1393,6 +1394,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_TDLS_OPER:
 		ret = mwifiex_ret_tdls_oper(priv, resp);
+		break;
 	case HostCmd_CMD_MC_POLICY:
 		break;
 	case HostCmd_CMD_CHAN_REPORT_REQUEST:
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index bc79ca4cb803..68c63268e2e6 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -99,6 +99,7 @@ static int mwifiex_check_ibss_peer_capabilities(struct mwifiex_private *priv,
 			case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
 				sta_ptr->max_amsdu =
 					MWIFIEX_TX_DATA_BUF_SIZE_4K;
+				break;
 			default:
 				break;
 			}
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index b48a85d791f6..18e89777b784 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -108,6 +108,7 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			if (params->crypto.wpa_versions & NL80211_WPA_VERSION_2)
 				bss_config->wpa_cfg.pairwise_cipher_wpa2 |=
 								CIPHER_AES_CCMP;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index b8f19ca73414..0b375608df7d 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -1396,6 +1396,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

