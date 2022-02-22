Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F01B4BFFFE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiBVRSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiBVRSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:47 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD8216C4F2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzKg/To/ZttR7JCMnhic22QDegUAUisT8YdYNiBkrfRqQoGOZCfbiaOs01ImgK/PWgmUOj/Od3raqRxbWRAXwdmPkgcb1QUKb+lbLIl/giebyOg0+8EtuvIZEwyMYxj6iqNl8l/WWwTscvpXQLdU1x1E8zhD9x0l462ObmYOpJekRsUP5LBeABN2VgRFyw+NiA4FPcGSgGyqkfKEoe1ywVC/U8QXCRMSinFRtoPvCa+2RN3A82tSiIam5BijbkMiVT2y5OQqYc9a6+GBsAaNzTXuPKLwLyKPYEAPYnrnetj3ZUyW1ue5zhKDD1AD0DdFnSMCR8GWIHiFkneIugkmEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYuFWvylO0zSMxKVA6/ITCk7aLuET5HdHEi/MphajG0=;
 b=YwDwZSIDaoeRayjCtGWlsMqC12WuldVgtdT+v1AJfPzbsJrh2ABPhk0UVn1ZsTBe32smXT8RNpXL6DaPXqnw3WK296pfnRzgTCU35LCWm7H3h348It9K4lqKUStKvA9aq5qQiN7DnZy+StNBWuuzeKC5WRuxacvk8UF2daSRGoHddWXdvjv+3gatvZCeD3gmfXrak4lCfDlSmO/t+gMyfMJhRbSeZO94SnA/jdS2gM9T0BaJhZ7nkM2ifx5I4b17FjF5OoKD3DceNpQTuE6JY+pnc3wISmmNdOC1RDkgONRSgq2AM90udFnZMaJa8EQvfbWph2WiN5yIB8gJlsIm3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYuFWvylO0zSMxKVA6/ITCk7aLuET5HdHEi/MphajG0=;
 b=lzSGBJye5aBOFu2lKGKnevbHAJ7CTmKZDth1jlSHZUy7Me10OtyI4fwwwTueNTMjp/H53fM4YF+30TBSpUMuqjJ0T64O/asbp24puaRrCuXZGNUvtL+hM69OZYHdUYxEP4SN73YGkqj2302vsG58Uu8SMME/3Mzq5LInNgWkkVXmDZf/wl3r2lgztylxRB/aoVCNA/ymLkd7SM2dT9iGFuzsG8a2Fd2zyuAlosi69Cjk3mhm2mF3raVjLIR6YtCp+URnz4jWTnOo8+M4WOfTykWG1ig0qeiy80OezvTxp4xWAIywr8M4L6vbTofPpmT/Aof49BEagZwYfkFDYBbgJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:18 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/12] mlxsw: reg: Add "mgpir_" prefix to MGPIR fields comments
Date:   Tue, 22 Feb 2022 19:16:58 +0200
Message-Id: <20220222171703.499645-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0074.eurprd02.prod.outlook.com
 (2603:10a6:802:14::45) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a905b50f-4bb6-435e-79c8-08d9f62751d0
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4262F43BBC952FC015B28381B23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0KmhzdPRaRWeKcBOWfM1F1ZwBdU8cwzUSPCdbMtFdqVr9Wka/kKza16xhvWieFajbrfy1Bxv41LAaVsxOONvrOhzTlcq5WVYvYmSdKx5LWzwVgLekZURrQCrBRm90pdUjfC7NobznGM79oG7UjtWcioJoa3g1MNhEYeCb37nP+6MMzNSzjWNZZ6XlCfjgRmNycvQZSR350DFA+uiZ4WVOxqsFPh5eyS0eAidaaKbT+zqrxJPtx8ge/ZFDPbcdaLBammKQIjHa+UwvLc1lH2e9Yw7jRljD88BlFXM9Y5p+hWXPyQsnb3wD5dNZJZdGqAYcOwjJ0TqCcgJAUWQ/FCa5EwGUXGSf2A7f1bEwhFuMp+72ov6SRVScwicRa1nCD8NDNSsAVX2SNj3gGeTZy3LtjKFQHHh7t3/0DqR5As1c35GUB3Op2LEgY45yOpe/JFc7VwpZJvHT/rpl5dMrEvdkvUawiZX0hdVKZWknGObKZywHA6jnq4oMF1ZAB1VYGugYH3QCvwDmjr6NnpvnPv1WJdVXe1szuKvDSRMP2UcnF9q6xD5gqAOAhGtWBdEwfapWnQFlC19bCOFYgWnOGsxdLsSnBQ3Yr/Gedl0bFJsPTo6s+4FyzgZZ4qcGFS6kjrzg3E7iPkYLGI5O/RHU3GOQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X8lUxUhE3xfCfRzxyw9vw5mGwEnAMVXPGUhFQpTBDS7rGEdqxMboo770Eaf9?=
 =?us-ascii?Q?GuQiTtzVTlZzxycg4yThRECWND0TchlK3oJIp7MnGj6a3GSDCt0ToSAM711w?=
 =?us-ascii?Q?AjL3v12mkhHgbdz5WRTdk+7goqysIWvpWPETqPjySJdJrP7sBbhXpUZeVyVw?=
 =?us-ascii?Q?rKE7x8n9rDnLqMC+Ex0g7MjJOe3hpYWGhiw2xlyOhNHUZkEj5t+T/Nlv4gNd?=
 =?us-ascii?Q?xR1h4bnifLwi6R/yysEvrAOzTGW4J8mviF8RWcDsQGVHh+J91YEzm+0nFq0x?=
 =?us-ascii?Q?cAgCKHyUxUu26BiYO2t7DYYTlMPwpP+kvCIUPodujFhX95B3xmbu6drazECS?=
 =?us-ascii?Q?BQnjgrQwk4V5APGhRfz34hQGx7naFBbf+U+J2A27i848GdRSZ5iApaHXzsjn?=
 =?us-ascii?Q?r2fW/Ksguz5K8F9NmL7F3Tos23HabWAyMnskelXCS4w6p/wp0A35oRenRGjj?=
 =?us-ascii?Q?l4SOD1UAWnm1Vrkg0Whl3KvMPxJTT7K9rCOF/ov4uex5jZv4ej3hz6Aj0vJ9?=
 =?us-ascii?Q?+ANAaWvzpBiqy6fs5KPVfwRLlIgWVR+Hwg6s97NpGkBiALcaPMWJ7N+9X1Nj?=
 =?us-ascii?Q?t1qXTZW66bTINa2uQ0s+P0jfNbnkCVBwB2jzLGzcmWXu7QbHN5FVggmFF+bc?=
 =?us-ascii?Q?DvVW0YJhIK/CX5oE7De3Mh4N5QN8fOExkPJV8HEV4EwLaY9H2EZv82ofTtBO?=
 =?us-ascii?Q?zJZEW4g7z9Undy9wPsbykelAFYsm/APJe7zGlE7i3PT2Aish34lIn0EU2Y4M?=
 =?us-ascii?Q?OWLJoSFA4tD7d5sMNV+8ksPFjQzlTdQ+cgQrbBiC7wP4v3NovBiRNHxhKZi7?=
 =?us-ascii?Q?WhMZ5LeqNwhjYxrkM8FVetBOcZg6h6FoVLYIxRXElaCKouHdBpLC5GIsVwEn?=
 =?us-ascii?Q?7Rs4+WNbmvysLFzKC3+WEXAoxFdG/QipzXMuCiruEC0rwC+qvdh3iPrvtFUT?=
 =?us-ascii?Q?YGwAyyfhM8x5CG3so9yc8ewYGh6TE9e2kwjax+PQcsY8QodoFqSmZWRsvDBX?=
 =?us-ascii?Q?Cm9rYUlkLI4XiE/XRGAcyXx6Sz347dk6yAkaptdMjgtSBwkMIox7duSxwPqz?=
 =?us-ascii?Q?BYLRL4PnclApumR6jkjw/wB7ChRQTGmIbUqOTv3iDv4llOqfBoqeYFDVBYGw?=
 =?us-ascii?Q?P42WH4GRlGKeG4oYBy8t202oJ+EtZ2DqwYKVCWyXDhmk8oy2b0XDph43gIaC?=
 =?us-ascii?Q?uwQij23GuoaBhP2nI0tlE41CbOT+qPc2kh7mRy0ZtSUkN/ZPskdBwP+1Lj1V?=
 =?us-ascii?Q?nObyc8MlTB3qPjS7BpB7kNN3f2Wv28xdw9NgvQ0GQ5yPGRm5eQ5SXCqqT08E?=
 =?us-ascii?Q?d4//+XByVxwml84H0EMvJrA0EMJ6oEPfYCLQM4U6e2+Xe4DZkU+WwXx/sj8N?=
 =?us-ascii?Q?OcGRG4DUCJuwcoRBht/MFY6c7K6n/0olSiG1aoAbm6nAYrO7q/qNYAWRr7i8?=
 =?us-ascii?Q?3pQYhQuE0ZCbA+Al/SUKtUjA2rLmD5ALBhDLu3EYrjzoLEHsiBoMMov8vMBR?=
 =?us-ascii?Q?rHWVV9DnwLRfkzdJoUlMyLgL2Fq+TyXuXmXDVDWNtXyVFFNkDwLr9hIfFob5?=
 =?us-ascii?Q?Ikuou4zRDIiQUniCg7s8TYhC6frH2NJjXGANEsfEofMdBRm1Oe3j+BAGUQD1?=
 =?us-ascii?Q?l2Ft9fVZq7EAdvjTsAb15S8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a905b50f-4bb6-435e-79c8-08d9f62751d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:18.7660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf8v2cdDy7eynWTLePDb1X0LzrUAmEXhuVgW5dTqSqrz/yyZ4J+yzfqb5beTI1PJ9hzI/iIkCk2mqtzBH05mZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Do the same as for other registers and have "mgpir_" prefix for the
MGPIR fields.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index eebd0479b2bc..1f0ddb8458a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11323,24 +11323,24 @@ enum mlxsw_reg_mgpir_device_type {
 	MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE,
 };
 
-/* device_type
+/* mgpir_device_type
  * Access: RO
  */
 MLXSW_ITEM32(reg, mgpir, device_type, 0x00, 24, 4);
 
-/* devices_per_flash
+/* mgpir_devices_per_flash
  * Number of devices of device_type per flash (can be shared by few devices).
  * Access: RO
  */
 MLXSW_ITEM32(reg, mgpir, devices_per_flash, 0x00, 16, 8);
 
-/* num_of_devices
+/* mgpir_num_of_devices
  * Number of devices of device_type.
  * Access: RO
  */
 MLXSW_ITEM32(reg, mgpir, num_of_devices, 0x00, 0, 8);
 
-/* num_of_modules
+/* mgpir_num_of_modules
  * Number of modules.
  * Access: RO
  */
-- 
2.33.1

