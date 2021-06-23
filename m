Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35BD3B1292
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 06:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWELn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 00:11:43 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:37127 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhFWELn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 00:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1624421365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qwJyHktfbY3YnoEJULnk94mnyKLqcVoumCZF+xCH6SI=;
        b=GvLHrwuujmJKSmFE8eGPvttooYzsqvUJscpbI0hqPFWzuNS8QrUnZikGx5JHizhV0SfgTr
        TIQiY7rtfW1xy/rSycJzEW+K5T+7klZsVoI3icsb6FGZ713wBZu3Z276a1ty7Xr05JILBi
        SNpV/4/CgrS/vSB4pGyJiFgc0Bs0W6M=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2052.outbound.protection.outlook.com [104.47.6.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-2YrovzuGN7mx2lFdlpEapw-1; Wed, 23 Jun 2021 06:09:24 +0200
X-MC-Unique: 2YrovzuGN7mx2lFdlpEapw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQO83YugxKQkXbI0+4zZfppGHCWFRlxS5ZwG1DIs1apnchdsNW0JF6CZl1pl9+Rdvvi9eorJRGxl+M4Jharf/olroT17fGErGfQgV8MHBrOCpi61WEosL2MNkiPxsQ/axyEinvD/vkF17+JQkSzm0/U/SgcQnk35sTqY934SLtQocJejOeExhhOf3dQUmaklQwWvAY/MD8NbxUzUfxL2ITWyCmT6ZUWfM+qHH04nay1wNR/H/QnwuU5iVXcv9bLmTJ5WCDT8QJseqDygC1YoCZIVKJDLbRAQKcX/pitXMRk3kPwWGzjGTihuA1mdRVAGHa8F6cAfT3cwROjzMd3Bdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0pDYN4neyLdyYZHKQ2LUQrRRkAtsaX4DAN5h//lGT4=;
 b=M1zJlFC2lyZZGE1QyBu72r3cCVlTT//QbTG0rd+IW2v5wQLIIxEURxGb6VCBlW6PhWS4mlrBNbLbeVXkvgOwntXTDv+3Ux5jyKIV5C5jXtG3ZWaZ9rLUAFJjRvIkg5sOwl2Zb5PK6f6Y+lWjgNOYrD8afUmlWvP4Lr52xsFWw4iP3Leag3iGUfoSzw9/2ysORl5rc08xR6YlissPR6BzR0b7LbR6u1VedEU5USwNGqGNe9bMyEVCKXuKwNHz8MC+RKVvtLlxABgbPnXZ93CaCNzs4sJ+3fXo0l9pEBPKKXRKHqu5FTYZuoVSFtAzAXSYX4v3oaDOXunVYhzda27yHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM7PR04MB7013.eurprd04.prod.outlook.com (2603:10a6:20b:116::18)
 by AM7PR04MB7062.eurprd04.prod.outlook.com (2603:10a6:20b:122::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 04:09:22 +0000
Received: from AM7PR04MB7013.eurprd04.prod.outlook.com
 ([fe80::d4f6:1298:6c6a:7cb6]) by AM7PR04MB7013.eurprd04.prod.outlook.com
 ([fe80::d4f6:1298:6c6a:7cb6%7]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 04:09:22 +0000
From:   Gary Lin <glin@suse.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin Loviska <mloviska@suse.com>
Subject: [PATCH bpf] net/bpfilter: specify the log level for the kmsg message
Date:   Wed, 23 Jun 2021 12:09:18 +0800
Message-ID: <20210623040918.8683-1-glin@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: PR3P192CA0004.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::9) To AM7PR04MB7013.eurprd04.prod.outlook.com
 (2603:10a6:20b:116::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (60.251.47.115) by PR3P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Wed, 23 Jun 2021 04:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f05adf57-90db-45a0-0420-08d935fcae6d
X-MS-TrafficTypeDiagnostic: AM7PR04MB7062:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB7062D50F3ED39BAB3817AB1DA9089@AM7PR04MB7062.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9b3G42fUQxoDxx38D4P6m9Can6YbNr127jaAYcTTJ2Ul/tsroLeKadP8Z9g2nmLDpsoKzP+tCQHeQSEiD7JXWZVfO55dyLaztAIjPB4+74LnLNfTJTozo4Gk+IJG9aB3XvFZ8wCQCrjceMhsos5RSRL1bvRKo/A9Q0u52sZZU6PoSZqfKusq4borDqnGRvNnKND5htJn3lnk2osERB4qI8OeX2ARm4dNJ7aF0Nt7No5uYcoJK1rMW/69cPWaNW92DySk09j29jZt11VwjdGiMgjwhhZc1RG6DczTxWQc6JdwRw1oAydL0DF5rvhuFr4L3EpXLYZLkKzOdbLYQP416ftzqRV2zYT/8THSqHaf1WIhFVcoLvhm6sdrMk19qK0JzHmEyCj1gOAYnHIlr+Z8vNAiNqwwrznhHAqjJ0iHgVUpBfI+tEQ5pUnoazO8fo/+/+LmEvLMxw9/CdhHi6tNqXD3gZ1s+GH86eaGmMixery5vdVB4T6Fo+iNklzh5ZgWw8olbmLKuVfvu42hF+0Mj+sZqYetC0/B4AOB7nbFMrjwZLuEIn9ElJ9oUo0bzTf1QLEgVsDOxmC+bhiIPw+tlbJ8HeNkIZJogfdBgzk7EQ9279F8eTICjl9aVWCCITbpmmsQ6Ar31pGfZuT1S9sgLA9HkriOfMQH9wGuHplAzqN6UoxGPkUzNdOKTykgh670/KZ16sTg7e+e3RwhY0ESdKtV9PtuL4DummVRrzlguzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7013.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39850400004)(366004)(6486002)(4326008)(38100700002)(478600001)(55236004)(186003)(16526019)(26005)(6666004)(83380400001)(316002)(8676002)(956004)(2906002)(15650500001)(1076003)(6496006)(5660300002)(86362001)(36756003)(966005)(66946007)(107886003)(66556008)(2616005)(110136005)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y/iOhtbpBHfwngUldOSfGbVWuGp0DuMsHxqcqdWVWO/czoJNlDHbrTi6/OJ5?=
 =?us-ascii?Q?m9+BoCdMZ+2hV6MsOW48tztg7p9N2ZxNVzRPMWfZRpfXWKs6nx51Jx/J4Hj/?=
 =?us-ascii?Q?jp9hd7HLsotq17cjtCf9suT/EBZCf2FPH8xiB2KWY3hbG/6xTLPZ5nx/fkgj?=
 =?us-ascii?Q?rhyT1A71I9ekz/1HGXT/JG3kzF/SJKmLFi9OSGVCcm7Z+8GCYb9vE5r6ewjP?=
 =?us-ascii?Q?lFP8TsxBJSASi5S+tRPGTd19E87/8Mpa7LwSzXvPR//dxteuK5c27t1iYFHl?=
 =?us-ascii?Q?p0w6Iv8BuPqronGv+1fjU+06Wf1/qtOvT5XZfG/2WWW8RtJeUUNFcp3B7JKW?=
 =?us-ascii?Q?/G5VtLc16kWFdH/jKgaNTuzbOjSAQi1S1JjAUVJPjvziRnppn/ommxDkZN/s?=
 =?us-ascii?Q?OkRoFgEV5Djun4sU5DLtVHiCkuwhJikjjeercQG5GikvuIyjxFlNPcE7au5d?=
 =?us-ascii?Q?ejJWcEBLYanqaP9f6g/QTjNrKnK1PHexkbM0G/atnv0WcvbCnQlLi8Bsnrby?=
 =?us-ascii?Q?ehrjUOCRQPGUlLxVqME7K7lXfXfDbHia8BAnyUVeQ32KBbZPEw6HReEXhwoC?=
 =?us-ascii?Q?EdHpU4IRhakZIISStUkhZXxKYWlOsujnJcdPFLhe7NJbE28SXAPW3c7bC4W2?=
 =?us-ascii?Q?gC5l0gKhsikBGKhECj0dvlsAKI9th+al97hBQpirm6EMvXCO3Fs1+3GdUFLC?=
 =?us-ascii?Q?BmXLgd+y9xJFCQ7zJLmp7mt7rOLQRNKPI/Uv2o7XWXWsB0STA3XnK8o+gke3?=
 =?us-ascii?Q?l+X+N4gU1RX/hoGxPKkhXFBBzOkop2k1rt3YzNTwHPFM/bb3JKbhbM+d4nig?=
 =?us-ascii?Q?mo8tk5OVOZ2V6+cM83z25aa1fR9tkUFw1Y3kOUBt/SO3azZa3znMA6Vi4wCs?=
 =?us-ascii?Q?IGNaSor0e4W/mGRIMzwteyTyMAofR7GK4hBC/rvsrKEjjxAQUuHCGHSfc1P7?=
 =?us-ascii?Q?1na3XpxBtkDHqFI4Tx56l/xa2C88M263XHuFhX4AfEfqnrsp5UPxp23O5LtT?=
 =?us-ascii?Q?6cWPEzzyVCL7vGPcl35pNHtdRD2VCJa1TCX4LFSHFI2chVYfmNl6mXTemMUd?=
 =?us-ascii?Q?NM7o6LOkBPqWKm34AqZzJWCBWhe/qPfMUdFER7d+yH/26fxHq0h3KrjpiJq/?=
 =?us-ascii?Q?r9JeZEmL8SdTkh3WdXSss4+2NLNnRFoQmIKwQJL7KZ5KgzgBmcfKGGhaBJQH?=
 =?us-ascii?Q?oMyePd8g5SUyZUw7pMpxbnjXWTRYuBy/9/6myR7cM/o7vEhaE+uecLZTXfbO?=
 =?us-ascii?Q?BMisMbuNqamHT2dhvDELeyuE62L9ExPibEjKaEqnAnDY3o/p8QRD/GfyLvJM?=
 =?us-ascii?Q?IwjYR+QOLOdW9Sw4GufzLpAP?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f05adf57-90db-45a0-0420-08d935fcae6d
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7013.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 04:09:22.6167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ng83PpEHbjJlLIWLPux4ME3jlvAKWZlEODRzQppCTdqMtYKYZGCExePydNEnzIE/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per the kmsg document(*), if we don't specify the log level with a
prefix "<N>" in the message string, the default log level will be
applied to the message. Since the default level could be warning(4),
this would make the log utility such as journalctl treat the message,
"Started bpfilter", as a warning. To avoid confusion, this commit adds
the prefix "<5>" to make the message always a notice.

(*) https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg

Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
Reported-by: Martin Loviska <mloviska@suse.com>
Signed-off-by: Gary Lin <glin@suse.com>
---
 net/bpfilter/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 05e1cfc1e5cd..291a92546246 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -57,7 +57,7 @@ int main(void)
 {
 	debug_f =3D fopen("/dev/kmsg", "w");
 	setvbuf(debug_f, 0, _IOLBF, 0);
-	fprintf(debug_f, "Started bpfilter\n");
+	fprintf(debug_f, "<5>Started bpfilter\n");
 	loop();
 	fclose(debug_f);
 	return 0;
--=20
2.31.1

