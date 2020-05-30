Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5571A1E93DB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgE3VJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:09:23 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:41895
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729098AbgE3VJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:09:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFKAMO2r7bzVgIX1CrNGdjcOviHV33llp9iefK+6rhAjC0wcpnGvBAGReBjnPJZmNWo5H4WsuFBLDmd7vf8UdPb7zf+TDCzrUqpNEL0UlH0YjQkEsSR6QXfCMtbnEwuzipk1z7YsYFTGI4hDclTLEx5WMIjU5xQgZv1CL5WQJLTWps+Xwttk8GYWNrpkJnzkRH6h7hg1a4RQ52OxQ1EbCneBaULGuRz6qpirRBPc7pF2ymab9tvWNlwTm6AnmbiqvRo5vITF90rDcXOJka74IdXBtsT0anqXEHL3JoYMR0eb41tuS/ltU042cGSHh8NwcjDi2J8/YQwGQp1Zu1AAHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gvbp74Lrj0pI7o1DRA28wwgPqHFqNmVhGNrngd15oA0=;
 b=kdleIaPqBTw1S1leCtTx6FnqhYNn4JskU8UCS1yu2kD0gSxBDajX5VQ0eTurITY7TRAErJzLTXVU6qGBy6jaK/Ojuuf6nYmUV9A9sOpJIqhF9cTvXmvvveDPsPR6Br2F24kSVkmNBgePZjiZ4IHZF8RyZmUojAFL/ZU7HjDDZozEoO6czqb5duaXsoKl2/QIVQTVLRgFhl0/6g0eQ75Av/Fr7mT17qedEfJSdq1GGwbEXZ1iHhXkJkXzP7ZROjiZ5+Pvsihzry68HDovI2XU2XbaQM54gucoESU0tq4f6/r00ZON6Apv4ui8jlYL0K8b22GK26wrzH+K2CMp9mQDXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gvbp74Lrj0pI7o1DRA28wwgPqHFqNmVhGNrngd15oA0=;
 b=twkta8Ul2elWftP3X47kZwpvuKRQk46uRd7o7YiWsEu7Stpg3j7ikGrDHkvpIaffOj9UWwFYHB7JbIMJXT+1TztadiMcIXgFIxBAIfc/G4lpqKwLYAEVozIbNOvrYUjY7Rc1Vu23sNf14WIinGb3T5qhJ9Ga644E9KCbn7AazQw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:e1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Sat, 30 May
 2020 21:09:16 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 21:09:16 +0000
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v2 net-next  0/3] Extending bpf_setsockopt with SO_BINDTODEVICE sockopt
Date:   Sat, 30 May 2020 23:08:59 +0200
Message-Id: <cover.1590871065.git.fejes@inf.elte.hu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0016.eurprd02.prod.outlook.com
 (2603:10a6:803:14::29) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.133.95.17) by VI1PR0202CA0016.eurprd02.prod.outlook.com (2603:10a6:803:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sat, 30 May 2020 21:09:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [89.133.95.17]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 733b226e-cf4b-4274-c27a-08d804ddb5de
X-MS-TrafficTypeDiagnostic: DB8PR10MB3034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR10MB303474A3FD9856D34400A3BCE18C0@DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivY8dz3o1TTOpKwBqyTYsjk0ka3WciBK5BampuD2FZSvQ8k3rejRbPm4H7w5Jv8Q6L0BtKpy7p+SW9nPfjdT1G7TJ1mfsoq7Vqac8tS7hta+HXGDwxxQxJN4qc5w//pQ42YRmIKkXitevCqX4kc0ZoLW+jxuuZ/AD72dzasBbQIYh51j1MboL83rdfZfDjwCgSNRXYfYXyWGIDTF5dbdf5nhurjQb64vFg4bH7aQw4LGwr3Xrihx3HCa5rwcMR//bPNo0b+OJLy4LIrYpetBimqxTT70nuNtz8gFBOAwBA6jf6cWWo+d47Uv8iQMBcu5zTb0hJ7NKozpH6L2jw/QeucGo30mKRj2ouKpHFiZiElXmwjH7CZRUjXi+uFjrV1w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(396003)(39840400004)(366004)(66556008)(6486002)(69590400007)(66946007)(66476007)(478600001)(83380400001)(107886003)(8936002)(6506007)(8676002)(52116002)(6666004)(4744005)(5660300002)(26005)(2616005)(6916009)(316002)(956004)(786003)(86362001)(4326008)(2906002)(6512007)(16526019)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IA8u97++3TSzJ7Cc7aCJ6KwYXCu8XE43FOn43S4K8U6lHnE0/OiVI+AZGra3MP9RmCRlprQQvOP602TF2EAA6+Q//8kVSDi1FMI70i/adzbA8t1O8GI73dPlLuj5/DxJdIVA+5AVKCmikL1I0xdJx6aLUpTL2oao2wGSb7Nrc62HWtN4bj65atMpWfqWcFYy/odmyuXgkIkpZJriyKHytLkdf9i9t2+0CeOoxbbNfi1I2RKQH6MN7CnJGRgtsjax1nkrgN14gJRs9BKeEotak/fE5yLMRnXKW+tZzLDmLQVzhyEXQk6judBKLfxoBeHgUWsOmy6Eyo9gYEUgGZ/cPGrOzplViosYCLttsu0IbS6+2fY3vRab1CZTLdde/bL+JOuH9URDhpCEvRj0ySjpI+W3ge+MQadaXhTJ47PJ1kUh2sgREx8J5Bkj4m/O1Oo6YDpWbWnla3/8C7z5QmcDcpQxnQwHxcDk0/TCNqlngJc=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 733b226e-cf4b-4274-c27a-08d804ddb5de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 21:09:16.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eF8dUy4IRmr5WWdMXvI6ykLMulnbaRZX+qkJbj0Tue1mYgBlJW/Pm8SSY/M8ZIYwN+ti9f6vbp33mHeTy7EYRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option makes it possible to programatically bind sockets
to netdevices. With the help of this option sockets 
of VRF unaware applications could be distributed between 
multiple VRFs with an eBPF program. This lets the applications
benefit from multiple possible routes.

v2:
- splitting up the patch to three parts
- lock_sk parameter for optional locking in sock_bindtoindex - Stanislav Fomichev
- testing the SO_BINDTODEVICE option - Andrii Nakryiko

Ferenc Fejes (3):
  net: Make locking in sock_bindtoindex optional
  bpf: Allow SO_BINDTODEVICE opt in bpf_setsockopt
  selftests/bpf: Add test for SO_BINDTODEVICE opt of bpf_setsockopt

 include/net/sock.h                            |  2 +-
 net/core/filter.c                             | 27 ++++++++++++++-
 net/core/sock.c                               | 10 +++---
 net/ipv4/udp_tunnel.c                         |  2 +-
 net/ipv6/ip6_udp_tunnel.c                     |  2 +-
 .../selftests/bpf/progs/connect4_prog.c       | 33 +++++++++++++++++++
 6 files changed, 68 insertions(+), 8 deletions(-)

-- 
2.17.1

