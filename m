Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD2858770C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 08:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiHBGSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 02:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbiHBGS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 02:18:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A719F48CA4
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 23:18:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHxI72luL+pk6AgjEFXPgQtyDDD2PjyzRlYfGSoX6ttRIKz+J0YOxVGU8C7vBmMd6H8jzY7oJu2OSQt55pWDVVFIQs1xXuf6FBc9VQhvZy4h6wdnStcbUsN/UKFA86z01CPybdpwx2/oHRHX7ny2QJKReQDayK73KCVKF+86Tu7pchW7WiqT6Sl0PTSNkQ06V9i1NSOJqutxDtqeLa7e3TRsnj4gQu9ojzvVGs/MfccsQsQeKaPqJMTUSn0n8b8L8HnP0gOrn6u4hBAt6V3Y/NC09Im0WFxg59f9kNJGGcOR4CxxdEWycdUaI86FuSU8pfCB2c033vUp8od1JNzGXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHKQOuN9THAEFdOZQNAmNDq6qK5kFKhPdY5TjZav5EY=;
 b=kykbb9VGqQ6OwAVuCQ14UPC6Cg6lzYiI7Gqhzr8nfe3ExyPpnrIGAkWObSk+8XXUo90RgS3JzIN48C3NXMQSs9y0Xj1WLoUDmYxoNpm3Z3AoDB2caTovgJtIBTkcIDsf01SHhINjIV9VcJcQChzlBaHaWONK39NC4Bj0d8xIToAKG1J/zZT+/XcFT6ysFl+3DoHnNhOhQM4d4fDazZM6dZU4LB2koO6o7ZbDFi+d9lNgAHfPohnWgNIhHux0Z1DtkmSbfMdvkkzwrpKzbr/MXpnwYb7tpS0lef+64sXjddU96LL/0wV5NH8EXPorbGpaeK7MCQR6p6Js2YiTUK2KPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=queasysnail.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHKQOuN9THAEFdOZQNAmNDq6qK5kFKhPdY5TjZav5EY=;
 b=PwEgdoHaphVb7avRzDcoqMT+rLB3K/x2uzrG5jF+/tcyJolKBOdhlsPiBUxMwL1kyGpcM61kwsh9aPdzU19eRBNS2hUFp3r2aTGbCSQH2crqDfxTyMwrWB8rjJMAnX8STPtrAOcIpdPDIpGsK98at3scpKMkTqnRK7pnYK3mBW+Vu0E8uCNCR/oq2QsEaGcFG6yOhYprRon91RSUzFa1gWPnGkaMJCd5hqVZcJblWl2sMPoXEPARl7F2C1XBxgVvQ0w1U/yFurWyduc3HDuRGnqccLnHH9Mrs114eXXLHwVrZJDQemmcU7NtqRcE4Q54Pd7rL88vCJxQrVJBNPkv/Q==
Received: from MW4PR04CA0179.namprd04.prod.outlook.com (2603:10b6:303:85::34)
 by BN6PR1201MB2482.namprd12.prod.outlook.com (2603:10b6:404:ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Tue, 2 Aug
 2022 06:18:24 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::d9) by MW4PR04CA0179.outlook.office365.com
 (2603:10b6:303:85::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21 via Frontend
 Transport; Tue, 2 Aug 2022 06:18:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Tue, 2 Aug 2022 06:18:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 2 Aug 2022 06:18:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 1 Aug 2022 23:18:22 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 1 Aug
 2022 23:18:20 -0700
From:   <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <tariqt@nvidia.com>, <sd@queasysnail.net>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH main v2 3/3] macsec: add user manual description for extended packet number feature
Date:   Tue, 2 Aug 2022 09:18:13 +0300
Message-ID: <20220802061813.24082-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220802061813.24082-1-ehakim@nvidia.com>
References: <20220802061813.24082-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a898a4f3-817a-483b-ed7f-08da744ecd84
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2482:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tfKHoRxp+vSxYBngmqxR9PtjOkPm1kDpYGEGarp1PRYvvAmiVhoSioyLseCNdouNIZ2GpMrPsd+SpnjqbxFIEa3nSa5LwkTh383Q9yRjenvYmp3AGgeX7pm2i2Jd3SE6Lgu8UGHUBUMzt8/gflwPhWWCwEXcmYQfIcoU6lGVo317yKcNztoIHuc6kAOU8XObP1IehMDea+AQkjebhqsIOFkb5kyWSugp0zgJujDjgHTZ8OHPdOXABRsFrl0a2skwfMYtIc2SYr6r9e60XeutWlOF8RJ8Q7kogLgfoHpywGvsRCftP0d+HxjXoyFrkZnA4aQouz8sxMbWkV81CId3B3HFK0OsrQ6/VcrYrOlKcOYOgzL4QsitZGYZRBgBhrGGf1hgJrIlrg402CyhDsKzxsA/9B65eaqLgOwW+rRcwgOElxh8E/kc8gAZobysRxwWwo5ECXJq0sKzXw52PgVuAeRUzMWCvTnhfDRHC0EntqrDnDA6LvaiQHuyylQxU5QV780LVvoOkzPdEq9Usm6EMQPYdmcTjbCZrffvNUBPUxcGXNuHF8mVwgqMrgJiwqH32c1lnhkcO1dQA01dzDud1gNyZGwXe7QcdS1f4JQwXXHsjLCxQG93Qivx0NvUh5m9mzEcSHoA+yjkBYqfO1VFs9L1opQGQ75T7Rq6OXpmbFO5fmzkWKNra9cdFZz7DVd92DWl9OIidCVZ+zE702Q9F16ipwSi+8cDOB0b7yIRprRJgpe3Jlm2JjIytPUbcIWFZl81MOza/0ClDrGXtkO3rI/1Gl36qiKJ/1Iymtpen9DNXEYtvFl4n9OLMgwg7m01gbjaPAIUyfPiS57px/uwTw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(36840700001)(40470700004)(46966006)(82310400005)(26005)(86362001)(6666004)(41300700001)(7696005)(40480700001)(110136005)(54906003)(316002)(478600001)(336012)(40460700003)(82740400003)(356005)(81166007)(47076005)(426003)(2616005)(107886003)(186003)(1076003)(36860700001)(83380400001)(2876002)(5660300002)(4326008)(8676002)(36756003)(70586007)(70206006)(8936002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 06:18:22.9564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a898a4f3-817a-483b-ed7f-08da744ecd84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2482
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Update the user manual describing how to use extended packet number (XPN)
feature for macsec. As part of configuring XPN, providing ssci and salt is
required hence update user manual on  how to provide the above as part of
the ip macsec command.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 man/man8/ip-macsec.8 | 52 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index bb816157..67bb2c23 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -24,6 +24,8 @@ ip-macsec \- MACsec device configuration
 .BR validate " { " strict " | " check " | " disabled " } ] ["
 .BI encodingsa " SA"
 ] [
+.BI flag " FLAG"
+] [
 .BR offload " { " off " | " phy " | " mac " }"
 ]
 
@@ -64,8 +66,17 @@ ip-macsec \- MACsec device configuration
 .IR OPTS " := [ "
 .BR pn " { "
 .IR 1..2^32-1 " } ] ["
+.BR xpn " { "
+.IR 1..2^64-1 " } ] ["
+.B salt
+.IR <u94> " ] ["
+.B ssci
+.IR <u32> " ] ["
 .BR on " | " off " ]"
 .br
+.IR FLAG " := "
+.BR xpn "
+.br
 .IR SCI " := { "
 .B sci
 .IR <u64> " | "
@@ -116,6 +127,29 @@ type.
 .nf
 # ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac
 
+.SH EXTENDED PACKET NUMBER EXAMPLES
+.PP
+.SS Create a MACsec device on link eth0 with enabled extended packet number (offload is disabled by default)
+.nf
+# ip link add link eth0 macsec0 type macsec port 11 encrypt on flag xpn
+.PP
+.SS Configure a secure association on that device
+.nf
+# ip macsec add macsec0 tx sa 0 xpn 1024 salt 838383838383838383838383 on key 01 81818181818181818181818181818181
+.PP
+.SS Configure a receive channel
+.nf
+# ip macsec add macsec0 rx port 1234 address c6:19:52:8f:e6:a0
+.PP
+.SS Configure a receive association
+.nf
+# ip macsec add macsec0 rx port 1234 address c6:19:52:8f:e6:a0 sa 0 xpn 1 salt 838383838383838383838383 on key 00 82828282828282828282828282828282
+.PP
+.SS Display MACsec configuration
+.nf
+# ip macsec show
+.PP
+
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
 with a initialization vector (IV) derived from the packet number. The same key must not be used
@@ -125,6 +159,24 @@ that reconfigures the keys. It is wrong to just configure the keys statically an
 indefinitely. The suggested and standardized way for key management is 802.1X-2010, which is implemented
 by wpa_supplicant.
 
+.SH EXTENDED PACKET NUMBER NOTES
+Passing flag
+.B xpn
+to
+.B ip link add
+command using the
+.I macsec
+type requires using the keyword
+.B 'xpn'
+instead of
+.B 'pn'
+in addition to providing a salt using the
+.B 'salt'
+keyword when using the
+.B ip macsec
+command.
+
+
 .SH SEE ALSO
 .br
 .BR ip-link (8)
-- 
2.21.3

