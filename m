Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC34F30131A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbhAWEyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbhAWEyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:14 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82284C061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:34 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so4414871plg.13
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=K83YF7GcNY82TVK2vJYspKj0xmLPWlJ36U3nO8TnBUE=;
        b=AEj2GmuSq9bAwmytXSXrvfU1Tvb3GkGgDFWbpAjFqi2td1IS73PkWrfpN/UyL5+CD4
         70kXImoeWMlbmJWuN5/GL0+blgrmnUviMGLcD29o9UOp28bU7Y4jaG10Fu3IKWHWyWBy
         fYluih1Yy9c8An4nEP1/kCQJuTmQWfAeIpwnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=K83YF7GcNY82TVK2vJYspKj0xmLPWlJ36U3nO8TnBUE=;
        b=hU/lUSNPMuFR44W4YIaE77k4NFUMJ38AnKsE3qJ2LPAHDkgCIuxYW7IwkG1cFvV3Ed
         tx1qupfCdZQ7ZsruMOwCETqlV+X3cdM/3WXYZkpZduJaokgmvQC0z8gmgsRda7GtNRys
         X2N1LCx1zKkGOxxr9uf98LQUGohzlphEGWWPxKJioc06OyRp2Ao6bnSrdDojpepQbozy
         5nrNART27wyPwrzC26jEuBJoT5jrzPfdZFpSHQ5A7s0IBgCPgJVdUsVr9DnnpL27W/SO
         QaNLVTXd13UvHpJ7NH/Cdv54HIxLOaoNobcVQBu/yMPB9Au8yv6gaNnsXDEoT+speXbm
         TbKQ==
X-Gm-Message-State: AOAM533CTp1GkC1ggBoAYVO8TjicFzv+HvT2WxwfM+QY2Kf8GPgO4O1U
        jx4QQxRJnfBo2Sx3sktQEydSoXk1K0tcXQb8wzs/y0pgrx9uPlFWK8MIgiTVuAWksIxD6PayLo0
        S/CJnZs+dxFQ6lycbLISH+LJGQ67XC6jlnP+fuyLWEyoA0HFmf9m7y9LUtdtJZxYZghi9OnDd
X-Google-Smtp-Source: ABdhPJxDPNUZI9t3LGRfbfRNqdv9D1LgnQFipdU7hhrCtRRe5CVwmQcG76I8yH1uqw+i1UIiRSvoIA==
X-Received: by 2002:a17:90a:bd8c:: with SMTP id z12mr9270511pjr.204.1611377613505;
        Fri, 22 Jan 2021 20:53:33 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id d2sm10725832pjd.29.2021.01.22.20.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:53:32 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 3/4] rtnetlink: refactor IFLA_VF_INFO stats into rtnl_fill_vfstats()
Date:   Fri, 22 Jan 2021 20:53:20 -0800
Message-Id: <20210123045321.2797360-4-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123045321.2797360-1-edwin.peer@broadcom.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000045dfd505b98a1608"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000045dfd505b98a1608
Content-Transfer-Encoding: 8bit

Moving VF stats into their own function will facilitate separating
them out later.

No functional change.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 net/core/rtnetlink.c | 66 +++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 466f920ac974..95564fd12f24 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1223,6 +1223,42 @@ static noinline_for_stack int rtnl_fill_stats(struct sk_buff *skb,
 	return 0;
 }
 
+static noinline_for_stack int rtnl_fill_vfstats(struct sk_buff *skb,
+						struct net_device *dev,
+						int vf_num)
+{
+	struct ifla_vf_stats vf_stats;
+	struct nlattr *vfstats;
+
+	memset(&vf_stats, 0, sizeof(vf_stats));
+	if (dev->netdev_ops->ndo_get_vf_stats)
+		dev->netdev_ops->ndo_get_vf_stats(dev, vf_num, &vf_stats);
+	vfstats = nla_nest_start_noflag(skb, IFLA_VF_STATS);
+	if (!vfstats)
+		return -EMSGSIZE;
+	if (nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_PACKETS,
+			      vf_stats.rx_packets, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_PACKETS,
+			      vf_stats.tx_packets, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_BYTES,
+			      vf_stats.rx_bytes, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_BYTES,
+			      vf_stats.tx_bytes, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_BROADCAST,
+			      vf_stats.broadcast, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_MULTICAST,
+			      vf_stats.multicast, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_DROPPED,
+			      vf_stats.rx_dropped, IFLA_VF_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_DROPPED,
+			      vf_stats.tx_dropped, IFLA_VF_STATS_PAD)) {
+		nla_nest_cancel(skb, vfstats);
+		return -EMSGSIZE;
+	}
+	nla_nest_end(skb, vfstats);
+	return 0;
+}
+
 static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 					       struct net_device *dev,
 					       int vfs_num,
@@ -1230,12 +1266,11 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 					       u32 ext_filter_mask)
 {
 	struct ifla_vf_rss_query_en vf_rss_query_en;
-	struct nlattr *vf, *vfstats, *vfvlanlist;
+	struct nlattr *vf, *vfvlanlist;
 	struct ifla_vf_link_state vf_linkstate;
 	struct ifla_vf_vlan_info vf_vlan_info;
 	struct ifla_vf_spoofchk vf_spoofchk;
 	struct ifla_vf_tx_rate vf_tx_rate;
-	struct ifla_vf_stats vf_stats;
 	struct ifla_vf_trust vf_trust;
 	struct ifla_vf_vlan vf_vlan;
 	struct ifla_vf_rate vf_rate;
@@ -1334,33 +1369,8 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	}
 	nla_nest_end(skb, vfvlanlist);
 	if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS) {
-		memset(&vf_stats, 0, sizeof(vf_stats));
-		if (dev->netdev_ops->ndo_get_vf_stats)
-			dev->netdev_ops->ndo_get_vf_stats(dev, vfs_num,
-							  &vf_stats);
-		vfstats = nla_nest_start_noflag(skb, IFLA_VF_STATS);
-		if (!vfstats)
-			goto nla_put_vf_failure;
-		if (nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_PACKETS,
-				      vf_stats.rx_packets, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_PACKETS,
-				      vf_stats.tx_packets, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_BYTES,
-				      vf_stats.rx_bytes, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_BYTES,
-				      vf_stats.tx_bytes, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_BROADCAST,
-				      vf_stats.broadcast, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_MULTICAST,
-				      vf_stats.multicast, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_RX_DROPPED,
-				      vf_stats.rx_dropped, IFLA_VF_STATS_PAD) ||
-		    nla_put_u64_64bit(skb, IFLA_VF_STATS_TX_DROPPED,
-				      vf_stats.tx_dropped, IFLA_VF_STATS_PAD)) {
-			nla_nest_cancel(skb, vfstats);
+		if (rtnl_fill_vfstats(skb, dev, vfs_num))
 			goto nla_put_vf_failure;
-		}
-		nla_nest_end(skb, vfstats);
 	}
 	nla_nest_end(skb, vf);
 	return 0;
-- 
2.30.0


--00000000000045dfd505b98a1608
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg0wfsTCSmUA+DcvpRyZrb
4BcSvkFpQ3r6fni+EAJKVh4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1MzMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIkc5Xn3o5qZvnB4xe+IyqMkiNs4YZflLomnWiRM
SnzYQMqceyacA9X0O0xw3rgo+81i0zq+SPg+w8/0b/zKNTf37h2HAN+AnNKDVIxKf4lTfOwLWLP6
kUZGyI0WZzvuxeFfDcJcvHAPB31+UR2KsDD1FkQwhfESqTvzxlKS2S3afG9qVsvSOfaTU28akGVY
EXRlIqf46BeU7Msf9c83ui7D2unK4hn3tCHcaNgzjDg1KTMu6kFT2AZsbHVI/Yklca9tnJsVlPA/
l39YuRnZrrmthT/rncMpKTQAHPduiHNDUHQckDFVxsKQq/a56oIK21PDBxQstrNqHmGBZWWAX10=
--00000000000045dfd505b98a1608--
