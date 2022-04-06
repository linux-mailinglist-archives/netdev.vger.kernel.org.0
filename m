Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8124F6BFA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiDFVBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiDFVBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:01:24 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D950CDB2DF;
        Wed,  6 Apr 2022 12:30:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cloSnyiUiDUNovm8xi07SAUvjSG+0Oh/lGma5oBe2tEpXk58VxfalVid8mUyJhHsvIpvo+hWnlxj4NixqN7BWypWeMUP1X9QYhJBszHtgFeznVqkNv0yBrMq380qtYEiAsoCpzubK1+EJCWQ8pHduanxjcdS+nQVlPO49DIM+gxwtnHfJraBYeSj1lGGMNAYsX6y5RYkPFP0EfqnSHrSmabPI/SuWMBFEwmq7fP88BrrshTCYMajCN6gFsdt2eeKxMv5DffWPREg9SZpctVVK/FYv5tkGfQoZ/Kyg3n6ihTErSx2RVUpTraK80kwVBPx7pzh5LS19PIeNGTmR5gIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogzSFe/w3J/0n9EdaCkjAkQN1rKVUfLbd4tamgSDBCA=;
 b=FiZIgz7p/w3V7WCZAqizi6FgpeM/sN2hhSYTXT+FRU+0PviffGFOfT1DNUJoQ3mBmh1EMp7X0iJQQzaX5V4a3tzFbAPASPpLH/nMEnSaWpvRimKYcBdW5nm5eAGODXnnMqMaVf+/IrJzr+vnL/CQPpvy3bkZbNLIudQty5Zn6LYA6cAWPSIddi6ClQRj+l1Oji8as8uI69Tx5YGjRKbc5A577rGOqry44TNgMB9JCsMvjOOuDj2L/LfwNlIExXaoHP3gj8afRGG9wQN7NcM1e2nlTP42j+/3mfziS/N/Xkz7roYXXSLChzjjJdV+6bpKi3v5m+atA5+CCqYZ1UEd5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogzSFe/w3J/0n9EdaCkjAkQN1rKVUfLbd4tamgSDBCA=;
 b=aaLp960uJy7hZDi0DOBVYHVsd/uD0kSq/DpNw1H82XLomlTlQy8/8F6ld1juDCW0M8RNWuKDlgzm7Tfm7A9qowMoDtcLiF0YEI0zenCXWJq4EG+PSHS+rX0b29RB/hUow0aFaDndoApwgoPNwBCXpaZUGRzj6eC+Rz6uNxE8Q8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5487.eurprd04.prod.outlook.com (2603:10a6:803:d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 19:30:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 19:30:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and 4.19
Date:   Wed,  6 Apr 2022 22:29:53 +0300
Message-Id: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0069.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54f111f5-da8f-476e-6617-08da1803e1f6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5487:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5487FC2073A0779AEA8794E5E0E79@VI1PR04MB5487.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qGlKfkefqDwqVUi59LDkbZkdE6UEyDFpk8s/J5ObWlCrNRWthvzALXMXK+nFtixy38PLo0jsLFVdnCzKfegOREgtR+oCR1kb8LV1UUJDnJvLf3bRkj7jkjqZnYbYU/wqQSqgLGXpnsDWvj+AVfovD6skVwkcaTGBUdzLhsHIIaqTwo/BVZMyjWFtXfrDKgUq1Eij0vh9AAjpw8j73Oo1P3XuNGG7Rk7mF1lc3W9RLc1fXCE0d7Ug9ST6KTQ7KMEFj9cAFXCR/yIuK2u+u52z5VqG6el3bx/9f8/E9AspbE1+XQiT8EQZ12GV+/9yMBg0wY+GCW9qzW6bsdHpL+Ie++gYZoiktIFrmMXybcN19YHd6UYGFfOxhTQ94iNM0g7jW+5PbTp/5i3m/+2yy6HtMJrWvIL1g5o9MvaoiYw6o+Xa0JCDallmV89DJb9+j+oallxgRYo9yXE9MLyUsuJ21byALVZpc5iERUBtDdpX4cBrAvm/6i2j/YwGXWrHVHkWdvZDNvZ6CgMhzFhjoHHzbf+NM5WmaTf03iLFw6Z4cjUxuT+L+XJDeHtbQcGtqed0Dl73AI0LN+clabov9xssw/S54KOSQbEjNM+61Xk7VC3Jy838oAI4fm8HBtxRXQybRAHYuNTfQNc2N32QN1CXO2Y9E6fu62LZF7wahHX/MDHkz6eqyJ2GFCL0SLNcXdzs+cyYjthVJw9s2H0ZZVi7ZPW8TgvEflL69MxW309AjwcibkpVPgJ1+2+SZR3742GrB5UZMAbb13rPpDhs6IvAM/yKN8febxtR0thVSCe7upM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(86362001)(2616005)(316002)(8676002)(66556008)(66476007)(38350700002)(1076003)(6506007)(38100700002)(66946007)(4326008)(6666004)(186003)(110136005)(54906003)(2906002)(508600001)(26005)(6486002)(8936002)(52116002)(83380400001)(966005)(36756003)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvYUMuxpyDjeP5E6WKiZyVD3op388PxvMfxLYpJM8lpCiPTRIkAwil4Px4Nm?=
 =?us-ascii?Q?5caO01QEPaRDJhrECPNj/AR25S8W0w9GXZIPIQzmxfajEAdh6KvtXmxOYl/F?=
 =?us-ascii?Q?8g65k4FV0pUhvEU2+sA/pfG5w/S1ZOYRa5EWGsdGMhjlKjm0SPLH+Y4aSJ8s?=
 =?us-ascii?Q?MhtaRzKRgJ4TfYGvqipSVwAhhLZBFvWSOZBY30wiwfSGMJ/+8h8rrW8NKCJk?=
 =?us-ascii?Q?xwGj5VD3ImHl01S7ubi+J5jxjYaZIFDBbW29IiJ5kxXsp1KcKAOteZ2Ch2Qt?=
 =?us-ascii?Q?Akhpqi+4uKM+bwQs3LKM+8sbfaxOS64K+5Na9D7wrapMGozhDyusEwxsElxT?=
 =?us-ascii?Q?JhD7MpanfRpPV544s5lMe4bgtkhjBGEXd8f1FJtEWU6szuZK4vXFS4BeXrZ0?=
 =?us-ascii?Q?dKySz3nZT9k9p6K5uXdOE/9NzA68gNo2hf/2Qti+r/rSev76YQxS0/pgERRU?=
 =?us-ascii?Q?me/FLd7+PmeXN++1YrsRZsjCTQB9cb1ZqTR6dbaHOqjEqaJSuQ/9pa/inOnI?=
 =?us-ascii?Q?ravTXbQfOCx1ybKKUTMxU//146JLan57c7EUqIxVFY8SMjrOQRT9JWRZZFjW?=
 =?us-ascii?Q?X9gxtwcqZTLqdSr463tkE95OzZQdGS+X9FB6XcyDicmYeOn8V3jP+6ZxnAuT?=
 =?us-ascii?Q?7LCGd8KURnKiiwJdSV1aiSVf4K+Sho+0CIo+WSykXzaamTOylIKwnBATcF0x?=
 =?us-ascii?Q?1LxFf/u5QLTExFeFwc8dejvcoGe+crd8nkudsmTHb/KBCuGrZ/J69sZ/cWeh?=
 =?us-ascii?Q?ucyB4BkVWzvf2b6Mj4Ly71deS6tk3U86CQYSZ+c9O/9gVYD70EZfoJU4vCEd?=
 =?us-ascii?Q?74a+mF9q418M/LSnJ1JXif8Z964dqiso0KyzZ24uJQBEnkW8h5ze7FRBdu4Z?=
 =?us-ascii?Q?KZTwpezQZm0a8Y5WtvBO5xCqyLUtWGZ+CXZ83+n4Q8tletqnTWW5RFbp44k3?=
 =?us-ascii?Q?4tOfF/fNhmCr3bvwogEbbVYbUJ6wsW8qChww8IYE3BVwWnUVaRKDeT7Lv8Pu?=
 =?us-ascii?Q?2bRIagRLiHnUpv1WKemNhKbIT01vT557mgRcrptxJHuYpeqsWWABFAmL0qbk?=
 =?us-ascii?Q?fL44IhwQZE39Pkd4v/y+YHUSRIcZjKQd/9BUu/KoH60Gcusd3af5Lr7dv4mF?=
 =?us-ascii?Q?6mE8dfMzdRpGHsHcVyBug3DtfVUX/4JubbyTQvFLwlVGb/fW9IflGUckC4R/?=
 =?us-ascii?Q?c3Vd7UuAJbYV5wxd0AFOfwO5ns3VIusAvXoRAz106P/6yKpp6MwhbDVne87f?=
 =?us-ascii?Q?3oZ/8v4QQuxDgUASC6xE+e5naZT4NMsCrF+LKd9ab/1vY0RQcAmEA0xyaYNE?=
 =?us-ascii?Q?MX7lf4S77PwUDWXLgF8lKhtRM2xdtx4pZBeCsLfAbeat6045G22SuTOwdgWC?=
 =?us-ascii?Q?c+iZ7g80zgrqI1Nf5rvizJXyMTaIaAMdrZuJFqYCC+JubdqVHJ0BLaB2qUqo?=
 =?us-ascii?Q?5qndewn4eTQxt+la9PsCYitU2XC0GTFDm+iTuvQWj5edpAJtXDLtBpdmyil8?=
 =?us-ascii?Q?SR49QS0WMju6orh06zJHXe/xZTyOZ/+E0wKAoZIRQ+jYUG7Eo21VERpGaBAp?=
 =?us-ascii?Q?2hxSIkhvVUPEi8XH+0OSJNWUa5y92ApEsGU+2LbiGPuLXzw8r50moJqsb2Jd?=
 =?us-ascii?Q?hzQ2cP7wdwJhUzNokEHE0AzS5jAjaKbL82TYRQvdsFHoMm3wusZruYHd18gx?=
 =?us-ascii?Q?Ot74SfymL66Sqq1oeltq0Z0/n2LZcG/7h/yqOvIySyuKAFemf06TBnCzI11f?=
 =?us-ascii?Q?M0IDjIb3uhNmevNL7Bphu/AWQO2rgFk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f111f5-da8f-476e-6617-08da1803e1f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:30:18.3367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCimYClIqbnKIgrLhEnyr5L0Xesnt3aOtvQBLKgQ1/DeKJp7FkxqiUUCK44CnqLQ4yGQC4ZaI8v+084iytZhLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5487
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed with Willem here:
https://lore.kernel.org/netdev/CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0C3rKMzGgcPc6A@mail.gmail.com/T/

the kernel silently doesn't act upon the SOF_TIMESTAMPING_OPT_ID socket
option in several cases on older kernels, yet user space has no way to
find out about this, practically resulting in broken functionality.

This patch set backports the support towards linux-4.14.y and linux-4.19.y,
which fixes the issue described above by simply making the kernel act
upon SOF_TIMESTAMPING_OPT_ID as expected.

Testing was done with the most recent (not the vintage-correct one)
kselftest script at:
tools/testing/selftests/networking/timestamping/txtimestamp.sh
with the message "OK. All tests passed".

I tried to backport the changes to linux-4.9.y as well, but something
apparently unrelated is broken there, and I didn't investigate further
so I'm not targeting that stable branch:

./txtimestamp.sh
protocol:     TCP
payload:      10
server port:  9000

family:       INET
test SND
    USR: 1581090724 s 856088 us (seq=0, len=0)
./txtimestamp: poll

Willem de Bruijn (2):
  ipv6: add missing tx timestamping on IPPROTO_RAW
  net: add missing SOF_TIMESTAMPING_OPT_ID support

 include/net/sock.h     | 25 +++++++++++++++++++++----
 net/can/raw.c          |  2 +-
 net/ipv4/raw.c         |  2 +-
 net/ipv6/raw.c         |  7 +++++--
 net/packet/af_packet.c |  6 +++---
 5 files changed, 31 insertions(+), 11 deletions(-)

-- 
2.25.1

