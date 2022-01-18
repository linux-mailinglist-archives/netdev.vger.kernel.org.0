Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADEC491FA5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbiARHBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:01:09 -0500
Received: from mail-bn8nam12on2107.outbound.protection.outlook.com ([40.107.237.107]:16063
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230196AbiARHBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 02:01:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UC5YuoWqYNdfmY8ainW3UxHLHgMEhsw+q46KvcEsL7YyjTrZGfd669H0LigytAa/W37hllmLmqb4vqbmfRU8NiAO6YgCSloNsxMimzpd9Jk4rrKpYVEEC6fZoVeuwX2b2KZkwcDUqATB+zWo0EqjUfVLMjPD7JPw99WXBuvXG4OvxSVxn9FuCFQN+Zb+ncQuVmXv1jS1lV1sFUL2r9B8Qipy33i4YqH8e+rbAjDuaOPMsV5r6KY0hosM5fzcCLYTz4jsYDdiLtRSr5prQkxfgz/2x9QJHAtvyWl5VU8WlNqPqJiExWl8Me5/lrnsrB20YB6KusijAl9iYHKv0cpNWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzgS0CmpQjeXv55isOtyOT8Q7uMxAv+CT34olQNmcRQ=;
 b=WguDjHKRXAwOywYjVxB+4Yjx8DOpGd7Pa2hgFRCrUbEb5cP8x9hXnILPFmVF0Kjono3c9Z3AmTdbi4QewTURS5K3LsN1WJOjoSv4QFneznZyvz6dGGi1YC/f0AkhiT3SzG/u3L2G1NrDMYKju1kZBrVZdBLbh//8AH4FezW0qn+afd/P+tzURPembB+cI0eNhKOXI81xIL81FmjlJhMQXtuaJHgNSzf60fYSftyKWWBPlSqswapEY7syy0A7lNAsuyPk6LxgFDgDKDEuiKQzjWCFJlwTZYDzuPPPQw+YOsGKci7KYpz/P2s9EhYrHwWurIQP5dPp9lxV104RwhXQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzgS0CmpQjeXv55isOtyOT8Q7uMxAv+CT34olQNmcRQ=;
 b=kWi1GV4RfJrmTMpZnCuDbDhwefDjJBsvpukuAHm5/vCkGuEMh5LqWNSXcti3m8ztRPalmUiULaCqBp8Q434Jr80/5cAnW9xRr5Pc3IGk9ceA/aUo4MaYqVHVaabgiqu5hMef/Quc2Sead0zeka1bGOjYFfT7KROx++1SrH4hLAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by CY4PR22MB0088.namprd22.prod.outlook.com
 (2603:10b6:903:15::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 07:01:06 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e%7]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 07:01:06 +0000
From:   Congyu Liu <liu3101@purdue.edu>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     yajun.deng@linux.dev, edumazet@google.com, willemb@google.com,
        mkl@pengutronix.de, rsanger@wand.net.nz, wanghai38@huawei.com,
        pablo@netfilter.org, jiapeng.chong@linux.alibaba.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Congyu Liu <liu3101@purdue.edu>
Subject: [PATCH net] net: fix information leakage in /proc/net/ptype
Date:   Tue, 18 Jan 2022 02:00:29 -0500
Message-Id: <20220118070029.1157324-1-liu3101@purdue.edu>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0020.namprd19.prod.outlook.com
 (2603:10b6:610:4d::30) To MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaca8077-ad2b-411d-3b8e-08d9da504c33
X-MS-TrafficTypeDiagnostic: CY4PR22MB0088:EE_
X-Microsoft-Antispam-PRVS: <CY4PR22MB008877729822BBB92D0A57B1D0589@CY4PR22MB0088.namprd22.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: phe/5D3Bgse+m6zkIz6ECouenSVmaRidDUlyzbd34v2BoC0eRPrE9eZpubfUAgALyUr27OaOZ+3z4p2lKTUdZ22wt9kPtACskRFYDVZjm1wTWlDcgMZtsjIhrcrDGrd85af4Y/03rvot27xG6Js3Rm/Xv52J0Rchplat1YGlTfiZrVqAOnADm874Eugr+yRIgqO3v9pKtkBCdspxkO4f5gl3xm8JIo9cn7oAoYY2iDgm5PerIp7P/M2Ahv3/Q5QDnvfULeQsjGI34djd/dcW9q8MpBhwkYDWQbmwfsXKFC2FkQ+0AekKw2wGnOQSUOCHz5doxtAhUxyKea4vuKIcvXot+n9cfTqzA211T/J4wBISNBGYX/IpRZaSxvYceN8AM9HZk43etSBj05RBaV9ULTolPCBO3SLqXW9+AKN3jskWZZE4aV/pB4wSAMiteDxZSMKgsUd31P6SVysa20TUnq18ij9BCVe0tEDx+75XuFfe9buvqX3YcEL5duiLrN9V1vKlixOXHIAUoNUGmHtO26xVyotdtElGBCO4Dx9GJkCP4lUyb7IbM89taAYFBkgu25ZYwFmB2kYP5hLWp+ErsaQrPWg7VO7W78+ADQec89jtEA0Kj8mCoTzRp5VZ+dcwlCRR+HJNWHGU+whD/pe7W1+lJ/3A13B3zUcaJVLQb3fhrwIkVWRYOdz9zc8s9+nSAMRr8H0bDD0tqe+u9fG4+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(6486002)(66556008)(508600001)(316002)(4326008)(2906002)(38100700002)(7416002)(52116002)(8676002)(786003)(36756003)(66476007)(6506007)(5660300002)(83380400001)(6512007)(6666004)(75432002)(2616005)(66946007)(107886003)(26005)(86362001)(186003)(8936002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4jpVVI5RyhIOLPhhB8p4/bwiphuhhQm5xRvECjuDmKVxi3T35jmlhk3WytN0?=
 =?us-ascii?Q?3ngubRkNbjOI4i9yvnNKRf4ei0q/8epCJuxg/SBPab9PxgK/I0juwKSjrRsG?=
 =?us-ascii?Q?jRjarUch7yem2ipbxCxuZrtIDsaFGXU4rnK/v9KriP9jyz8MWTb+NmpHaPbp?=
 =?us-ascii?Q?Fgd8Zc3MmzNjMvdJ4EBLfuDOlWDXuEQwlUNvkhi2MiFyeNYT+iATDEz/9sR9?=
 =?us-ascii?Q?DACiYFEzpumqtYAuyaAPN9RGYCiwwmdSRDh3qQaGOXzsg259rd+iuL9KLJ13?=
 =?us-ascii?Q?Ncpzi3kwzi3N6mmavPcpWUEOgyRGQ9Yxw8+A7ioHDtRhKOAhs9XLKNQ3d0EL?=
 =?us-ascii?Q?g1hEqoYjDQVPBsADp4Tehg2D7Waw/GaILMafRtqdqsLNkYRm5cwJvfBTRDVe?=
 =?us-ascii?Q?meeICCzl9uQux75TCcu7OkSEvRgrYcCjdNo3+F2xqh+vAiKss34575FbO84/?=
 =?us-ascii?Q?WMCSJztLK6sC5JI9okpvrDB02knuWIXulwZxG7nBJdn6Lnq4u/gD+RJ04wZ4?=
 =?us-ascii?Q?QzI0R8iX89xFp9V3q4nFnsx/cqSuPsxTO9flCetXvqxGa4NXKV9DInXNipRh?=
 =?us-ascii?Q?CgVpgEdMrZKMknVF7vPC1dHoUkJvJod5EL43fA8prbZUiugAhcoXnMALPQ2+?=
 =?us-ascii?Q?EfYBlZgevawxRkhf/C7Cbq9Ua8t7jxbqdqv/r2MswZ1/aWKikUFBOhKBiM7m?=
 =?us-ascii?Q?4sdjiRCEyFVNiHI+iabLDGxKZHC4+qFE7kmjygdHtNKojFz9sMhei5TXr7GP?=
 =?us-ascii?Q?N9hbmAhdKWajJ11pJ5e3yS+I9D8DEk9Xaf51qgkQqjxisgSJOu+Y+N+LItio?=
 =?us-ascii?Q?9nMq66oHh5SHyfUEtbAvBBC0yjJNs3GmqBHbftnPWl95TDSJX/gpj/JbLtqf?=
 =?us-ascii?Q?aVMM7Q9TKHj9AMs7E6jhdpzvUjZAhh0T/BHRSbibtckCBDGwxxGkKrBGf7tb?=
 =?us-ascii?Q?ZJ7GKaM1l5z9uxp+11S/ATtIN8+NCoGaHQWJ8q6sSu9yhjpVEJdAm8kMxRHV?=
 =?us-ascii?Q?wpbl55SirYDf3c/2RlhGpjUUPuNPrXf9Jf5HEocL8zCukUPNbLtkgYRpyf4R?=
 =?us-ascii?Q?EPmOCHSsQ3AEiUqwnaVRMhffFxpLYcxj1WE5ajDoJnlSMzuyQ5b6QvAWCvcJ?=
 =?us-ascii?Q?Bo8qrm6B3DA18bS3vNqn19ABJBkNkXCofT+z6xK+0qFEsUXfoxhvMOq7LLz7?=
 =?us-ascii?Q?nvMADLuG8sfN6uUBp8w956584/Pox9XL6CazscJdMvFxMlPXUKidRvrlMI8L?=
 =?us-ascii?Q?1H2hwtR0eu2wkT9JHxyBAGYK9EUBQWCOj82LIZpXgRBwgjUEtg9i9wuv7NoO?=
 =?us-ascii?Q?szsrk9UmbCyOYjaK7J9QLUEpq1NK07ZQHMtEz0VeF+H9/MiS5lXejOlx36GH?=
 =?us-ascii?Q?I4zSFLn0zq7GLIc4c/7an6zDM8IVzFMSjKMxZv6iYLotTuZv8vjOSjDkJ29G?=
 =?us-ascii?Q?QebM4fdbaL3I7PMayZoNckgl0v+4dzG825jFNb7I9nBC6p1UvzSng92NQEjO?=
 =?us-ascii?Q?xschLyys/mUHdI8nhUwtYmDZnQUxYa5Zt7yGVN9L7I2Eka3cR46DtomwPt4+?=
 =?us-ascii?Q?9jA3uug/N+qMZWoS0zXei+Uis7tpy3QUB0se2xLWszdLwBHd5F+t7/AnzSJs?=
 =?us-ascii?Q?/PNnFMuO6/pvrXYJBMPHYP0=3D?=
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: aaca8077-ad2b-411d-3b8e-08d9da504c33
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 07:01:06.1081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQb2tyTLaZlniV/4OaoOd+Z0qdMOEYljKCidbspBdK9R2anYXVUnaNMxgivEoa1IterQxkcUrZzlHFGvrrINJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR22MB0088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one net namespace, after creating a packet socket without binding
it to a device, users in other net namespaces can observe the new
`packet_type` added by this packet socket by reading `/proc/net/ptype`
file. I believe this is minor information leakage as packet socket is
namespace aware.

Add a function pointer in `packet_type` to retrieve the net namespace
of corresponding packet socket. In `ptype_seq_show`, if this
function pointer is not NULL, use it to determine if certain ptype
should be shown.

Signed-off-by: Congyu Liu <liu3101@purdue.edu>
---
 include/linux/netdevice.h |  1 +
 net/core/net-procfs.c     |  3 ++-
 net/packet/af_packet.c    | 18 ++++++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3213c7227b59..72d3601850c5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2548,6 +2548,7 @@ struct packet_type {
 					      struct net_device *);
 	bool			(*id_match)(struct packet_type *ptype,
 					    struct sock *sk);
+	struct net		*(*get_net) (struct packet_type *ptype);
 	void			*af_packet_priv;
 	struct list_head	list;
 };
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index d8b9dbabd4a4..fd5e8682058c 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -260,7 +260,8 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Type Device      Function\n");
-	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
+	else if ((pt->get_net && net_eq(pt->get_net(pt), seq_file_net(seq))) ||
+		 (!pt->get_net && (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)))) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5bd409ab4cc2..7997b9db8280 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1678,6 +1678,14 @@ static bool fanout_find_new_id(struct sock *sk, u16 *new_id)
 	return false;
 }
 
+static struct net *fanout_ptype_get_net(struct packet_type *pt)
+{
+	struct packet_fanout *f;
+
+	f = pt->af_packet_priv;
+	return read_pnet(&f->net);
+}
+
 static int fanout_add(struct sock *sk, struct fanout_args *args)
 {
 	struct packet_rollover *rollover = NULL;
@@ -1774,6 +1782,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.get_net = fanout_ptype_get_net;
 		match->prot_hook.id_match = match_fanout_group;
 		match->max_num_members = args->max_num_members;
 		list_add(&match->list, &fanout_list);
@@ -3294,6 +3303,14 @@ static struct proto packet_proto = {
 	.obj_size = sizeof(struct packet_sock),
 };
 
+static struct net *packet_ptype_get_net(struct packet_type *pt)
+{
+	struct sock *sk;
+
+	sk = pt->af_packet_priv;
+	return sock_net(sk);
+}
+
 /*
  *	Create a packet of type SOCK_PACKET.
  */
@@ -3353,6 +3370,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+	po->prot_hook.get_net = packet_ptype_get_net;
 
 	if (proto) {
 		po->prot_hook.type = proto;
-- 
2.25.1

