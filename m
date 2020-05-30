Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10ACA1E93DD
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgE3VJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:09:58 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:2551
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729098AbgE3VJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:09:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIZpRcJXSj0YDpQNXK0eaLAVvgknDegtmf4Cg0wBO8ImIKFo68sbhfg9cn0UbRN6xpfJAKPL3QCLo8KGY9Nwc+OY0xvkg4ldj0GPtNuCgR8MvJhwmFFTEY5ckT/gwJKHX0ipW58liwu9FhYEvzZ18EnK2LcAdKT9OVu0wTaM/pHWWj8hNv0wMfuOSfHkFGq1+OvdEvBONAMGcS/as//QslQfrsuQIEOUgU3QJXuHl1zY0IhQvZrGRnI8vWdcw7rgKFRw2iRE2cDox9OaGpDmvZHMD9vt49BR2w2bCFIDk+IdshWzFzPxJkbPIgAzXf7SsJlLb5PMgeIR0u88IgFRQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI1K48FdjscSVBk8PZUJ20aalFwmOv7Pe3ZnJA4sbN8=;
 b=M9y7GKmdL0pcrnP7cKLl/9Ljl+MFf2vDcmqmABVczbHhCQySNWS+bHp4GS8dRDKBUqjgrDMB6TptfNLadl/nkis4WKFd7re1UI1yAct5GKJKgST2BlXFXU38PFAuWaQCid+OwvNdtnlgXkhQPkTCjt89kWjWQaA0ndM3Ik+RqkAtp6dmcK84FfWhpAYxoKLmGK5Tarwq1ea5BZo/Z/w0T48cPD3SKCsv8KrjfvbJ8d00clXGG2sH0VuCnuTsE05TkaMCKGVq4I1RpO0pjBgyjDwEvbCfG048Ho5cUVZlbNby2duCfcwAYLh0aC+9TXYMhMOSLcWCOitrqRHxRuRZuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI1K48FdjscSVBk8PZUJ20aalFwmOv7Pe3ZnJA4sbN8=;
 b=ItNxO3jPqyD0mLTU+kZDOC/6D9wLGDllaD/CW5QA4fPw/eRNjQR5F0JmOfXsoJy2Pwlgb9ANNVc/ekRfF6RTT1zFgdTPv7Z+ksPCRiFXGIE67/MugiAbtxePmpRvE8i1qv2I6fTPk8TLUmtGqNEPSiTFC9Vc3K1Wtkzb0B77un8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:e1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Sat, 30 May
 2020 21:09:19 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 21:09:19 +0000
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v2 net-next  2/3] bpf: Allow SO_BINDTODEVICE opt in bpf_setsockopt
Date:   Sat, 30 May 2020 23:09:01 +0200
Message-Id: <4149e304867b8d5a606a305bc59e29b063e51f49.1590871065.git.fejes@inf.elte.hu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1590871065.git.fejes@inf.elte.hu>
References: <cover.1590871065.git.fejes@inf.elte.hu>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0016.eurprd02.prod.outlook.com
 (2603:10a6:803:14::29) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.133.95.17) by VI1PR0202CA0016.eurprd02.prod.outlook.com (2603:10a6:803:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sat, 30 May 2020 21:09:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [89.133.95.17]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 463c9d86-ad73-4a42-c1e4-08d804ddb6a7
X-MS-TrafficTypeDiagnostic: DB8PR10MB3034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR10MB3034562D562197E1A7FBC284E18C0@DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KDVqftCLwissOmNRjJtkxy1a8XNJv+vNVUoC4rTegqGIqJRefKOUF7Fay4l/hTD7aBKtypzZsh9oKW0+DbF2ViwoKc5CqXlG+7WdHRnrBhPJDLsc+8DJo6/JTPvKjj6EQpAkpKP2EbT+cmhGjDyGYwcILnH1UdPisTv1j+NcHF8+BPUSh72fMUoi/YWbXzmyvJ6diAbzCLlhOY0iDtDH/cS9mYPazI6vr+EMlHs2gfu1I01z3iSR4OfpM5dJdgLWW9O3ZWJ5joz7km2HfjWunfmLyFQfyGoOAN9KCggEb9jnqqTR/6GwytDXuwKbGUtTwQWWOcDXzxnR6yloA5AYs6yijqZAS5OSp4zNMk0pCNRq+YyIBxmhu54NJOSizn7W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(396003)(39840400004)(366004)(66556008)(6486002)(69590400007)(66946007)(66476007)(478600001)(83380400001)(107886003)(8936002)(6506007)(8676002)(52116002)(6666004)(5660300002)(26005)(2616005)(6916009)(316002)(956004)(786003)(86362001)(4326008)(2906002)(6512007)(16526019)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PwjkVAtTbUKp7lbTdgKiSwU9jmCFCpq9A93qcS5JiOior1zUvg5lVD4k9f2k0qDvOw4OqtPBfpUGcPIpVXPQCy+5dRxAp1sSMOIMO2FFfNct3FYDF2MWaC9et2TZNPwctlbrneJ9eagdvEgtIW9MF4C6MPre7biJjKvBLebtK6MxCcf3maJCvbbCCJ/OXbdjZORK/9WyQaIH0h9b79ETIU6tpNvd81tA9E0UPzmWIYR1bmm0it+TA+3cjsNytWhLHgay2DII8N5iVScHuGQQT2PGCeivM9l5LNNZ0n3prRlBwSpO7gEUyhn4jsax9BF7m3Fr8qfxuyFyY6hSk1bhI9qSQBclMNobVBYuxhrc+izDVUK5b5VK2Rprc51IrViKhag+uUSXd5x4l+lJvK4EHFFjjPPlrlHLZooQ3ALAcUh8ZicEKzPNzGzKqPsQnU5mO8XrFPYwNB+7GmiYZNS5lrx/tePfK600y/X2bXT27FA=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 463c9d86-ad73-4a42-c1e4-08d804ddb6a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 21:09:17.2795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PV4wbXzjBHlYLqbSFGZwMsYjQh1piAYdAlg0J0pRxg0J5/985HNaAsoDdPRPhp7oyEuyuYclCYd/sbRVrNVMzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extending the supported sockopts in bpf_setsockopt with
SO_BINDTODEVICE. We call sock_bindtoindex with parameter
lock_sk = false in this context because we already owning
the socket.

Signed-off-by: Ferenc Fejes <fejes@inf.elte.hu>
---
 net/core/filter.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index bd2853d23b50..a0958c5ef127 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4248,6 +4248,9 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen, u32 flags)
 {
+	char devname[IFNAMSIZ];
+	struct net *net;
+	int ifindex;
 	int ret = 0;
 	int val;
 
@@ -4257,7 +4260,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 	sock_owned_by_me(sk);
 
 	if (level == SOL_SOCKET) {
-		if (optlen != sizeof(int))
+		if (optlen != sizeof(int) && optname != SO_BINDTODEVICE)
 			return -EINVAL;
 		val = *((int *)optval);
 
@@ -4298,6 +4301,29 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				sk_dst_reset(sk);
 			}
 			break;
+		case SO_BINDTODEVICE:
+			ret = -ENOPROTOOPT;
+#ifdef CONFIG_NETDEVICES
+			optlen = min_t(long, optlen, IFNAMSIZ - 1);
+			strncpy(devname, optval, optlen);
+			devname[optlen] = 0;
+
+			ifindex = 0;
+			if (devname[0] != '\0') {
+				struct net_device *dev;
+
+				ret = -ENODEV;
+
+				net = sock_net(sk);
+				dev = dev_get_by_name(net, devname);
+				if (!dev)
+					break;
+				ifindex = dev->ifindex;
+				dev_put(dev);
+			}
+			ret = sock_bindtoindex(sk, ifindex, false);
+#endif
+			break;
 		default:
 			ret = -EINVAL;
 		}
-- 
2.17.1

