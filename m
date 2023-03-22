Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854E46C4FF5
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCVQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCVQEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:04:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2109.outbound.protection.outlook.com [40.107.243.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351402CC57
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:04:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzVHoEwHk3uz+iY3AO21wPuTTTaiUcSprPM1udAKVp1WR1uN4AWj8EPj7NtZgEEqJSqu9PW/dtRoNj+BVqHcGIJjUjhRHtqCO0aOkPWPJ4eqYKpEP2hM86Io6bC2O6atR6rQZemytDrCOB65bPpO5fYZtcy13RpiIurTG6pmxnNyqKBCbBxBSclgZD+mdYit+vTIlJr4+f3CNdLfaKqz8LKVOuFZJGpglgI5xRQA+rNVtC7Dcv2Iz7Ez6i3UYqcxBfsVHLwhxhZQOHbSyN+gV09CkIsDuEZcbVCs5atDKEzKuRh0MGQOb29wkBtajHEAs8s3enZXmxTJ4iCUcJEUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYN66BxA7Yg46s1GwlgHcrjKTjwXwrG5074W7j5b4UY=;
 b=f0g4ed/UauP8IrIEdZFVUUtoEeXjvZ5ep+A15thDhZW+W6YKSEBmX//InqeGNfA0ZXUM4C3Pq/h6MNB1Xb3ioT89eYR1lEZsT9fVBHBwBA0h7FM0v+yX/pivV3NoHfvWehwS9H6zUG7HgoiiMNiGbDpI7tIs3OF98aEtTmQwXibuAvVR4nyweT4SdLIdx950RoTSA35I1WsP3BdVa+GDCIqnFym23cdoXyze0WNIp1EFdLDEQpuaJq2C1PRso1wlyc+N5rqRRy1Jh7ZQXJMQZuz5mZB/OgVvo6g9GjDZ0zsJxnCSEUcSvvZiZIqPrA4LE/orwmSHZ2cNR6FpEYWf+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYN66BxA7Yg46s1GwlgHcrjKTjwXwrG5074W7j5b4UY=;
 b=oHxzBxym1oppMgi263saU+i6PGljiIXdWMzwO+goaDCSyjmFf4vY4cZNlrbsy/2242bs1j0v1gX56Ab74exkUXttExJ6lXjklHeMsk82q4pcE7DlMgda1mn+eiRWQ/8VfXO7Slr3O5zkKYTvqveBOViG+7LNqkKevBMtnoZ6WC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4564.namprd13.prod.outlook.com (2603:10b6:208:30f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:04:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:04:03 +0000
Date:   Wed, 22 Mar 2023 17:03:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     joshwash@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net v2] gve: Cache link_speed value from device
Message-ID: <ZBsm7MkHeuZahQJK@corigine.com>
References: <20230321172332.91678-1-joshwash@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321172332.91678-1-joshwash@google.com>
X-ClientProxiedBy: AM8P251CA0015.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4564:EE_
X-MS-Office365-Filtering-Correlation-Id: c907ad58-4464-4f8a-c06d-08db2aef0e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ND5dx41o1OL5WICtRu9LtrSJGdMsqHOfavGrBTAmgOOn/4WJ7Mn48bprTkQwxFsV+UY/+jARtrbSl4bPxwcO/OE/Lo5/Zk01m+ZNms+sdUnPysG5c/2HaTQnrIfi2OENoXZTIo7ZkotOqz3++pWMUYVAcpZAH7P4V1kf/u1tTT0ula2uiOjcXcs7bD9trccdF1jyNzZ35lxEclwzKn5TbOvADtinQ8eyKaUiBlYdfwtREM1i1TB/J+NwKqWIiMNJQnMlVUt3HNxoDpv6NRTMXg2It9+9QmCqwtYnm67JS61plcmukt7VAqebYO37piRwO/dDPbRa1xdNb8rti8+qgMBbvbMNyGn/0t3ybQLasc0Ul7huD1t8WTo3x+uqNQoKJACE/DnHd1wqhaHijIL09hKG0hu3zUmCBjm+IU3LVx5ocLl5GoUgaNGn8fALoZCEjTrdgN7OBoDu0AmH7vQ5GXnPFkBls2UTMsHQCd1Yfqw/1JvpWJTqclOovz3s/agSVInkgdTGW8+dxp6SDEiKHTkx0UDyc+XeczUgRhJlLaDvQURGi0G21HNDn4hToU3JxPuXkdMIFG9aBKOW2W85fBJgpPtkC6AsIP0PHozrtpC3iyECDldrzrDcLSDyBbkSiftjjuTuNN2bG0YCIvdGdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39840400004)(366004)(451199018)(6512007)(83380400001)(2616005)(44832011)(38100700002)(66946007)(66556008)(2906002)(6486002)(86362001)(36756003)(8676002)(5660300002)(41300700001)(66476007)(4326008)(6916009)(8936002)(186003)(4744005)(6506007)(316002)(478600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3n/GHop+k0GyHXFnyhMijgIhCnxy4EoeZLpU3OtgCLzGx8cqko1NV2tXqbce?=
 =?us-ascii?Q?ZGUgnBjP3ufydvjXWtKB3Ijn0QJmLhFKR4NmsivK8uPPVEVVQFYglWmSQfTI?=
 =?us-ascii?Q?MTIcmb2xjHXQGaIigJeEs0Nd2PmxSgMh9sGQG1kf7fOkzk5A9ebJFEhkMWJk?=
 =?us-ascii?Q?a+ZwdMsw1J0K9rgjlREkQdIVKnibcJLVzCH0E58s2NHwymMHXI6o98eF3SS8?=
 =?us-ascii?Q?+Zv7umyhQoqIsM6yU38l/wmjGCMXnvEPIN9NEz+AV0FAVyJH3VsVxHc8N70W?=
 =?us-ascii?Q?JDZ9Fti0kAnR34PQUJsZ6d9p9VGbhKEwNgdtjW/yHtIlwpXq+lr5/kNHlhEc?=
 =?us-ascii?Q?SZ0uUnmlS47nRUUEcaXXOHyr4ENxAFcswWunNv3qtaEu6Yx05IUL7j1SZEr6?=
 =?us-ascii?Q?IOgDEqgufYXuT/lBcvvzeUC68fAGDP/JMBRqpaufCSVLGgbNT6vyBc8VB1os?=
 =?us-ascii?Q?JmHpcTOOkR+RfIjePbvmwgtkQc7oceJjVEAcgjQEARLr2AszH/kvPq3uTk7k?=
 =?us-ascii?Q?Xxlbd9XZ4JHRp0fkQxXoVJBhk/PZs4NvjUbD3u2YqdA9pPSnKsJYW/LeZDGJ?=
 =?us-ascii?Q?9kX3h/WOqt112BuHKYznZfvVICPEMWKSf3ZBrjjHy4eNSBN1giKUohMikbfM?=
 =?us-ascii?Q?92EVlWjwlT02yqo6gNWETbY6szisr5WX8Zp6nuC5HOE569Z2WLcB/MkKA7WN?=
 =?us-ascii?Q?qQusBzf+uwtN1qNqqL1HO5Hgjw+RzKbJ95SZpsPrkVN+CAxLfxQQPRU3i9HS?=
 =?us-ascii?Q?yU1xP/uvjaZLBeM/u4GMw7YtOF3dK0Z03uKuIvuBPkFgh2pSCR9CiLOJi5Wu?=
 =?us-ascii?Q?xNkh7U8BpPflrBnMww7GdUWkRZTR9PrAh7uTMOW5plBslhVpJN79pygaDIGG?=
 =?us-ascii?Q?LAqiVmy/rWjoUIXqAIK+rhuOO3vvOXpsyeCEfNorGFfYIlBbhznTk47Z2S9P?=
 =?us-ascii?Q?I8wJZ/j9mMSPSeKjhDUGfWgSLPr+UrN1Hvwx8QIX56I939Z7WyHbg3vADKWy?=
 =?us-ascii?Q?uEL+syYgTxkAGfqYeH23jG7+P1/CV01/nphguA351207llY+wPBTVh+1Nw/R?=
 =?us-ascii?Q?kxckpmA38LU9b78WaTGFouobNj91rBAVQDhFNRc0aiDUUb91s9m0CKm3Rxqm?=
 =?us-ascii?Q?za1YGmHwzh9gps7jUtm1bv51kZEFFWElf9dm+vVE92B4+fctgVCuSQpGyjKe?=
 =?us-ascii?Q?Ch/HWgwb2K0FKxlQliL+2Ju9XyhIGjmXOEPc0TuPiZn+KMpFT+vuu4vTPyOr?=
 =?us-ascii?Q?O25kcDeikhqhm7g9cWpSZKGy91pzAAQ+hApTRU8IUXcX+rY4M8Ry3y+c2Fmt?=
 =?us-ascii?Q?/Rslf7YBha7jCvZPtrbPh+yKrZnrD7JClVVyKofjmOraZh1INsOs5vs/6z/f?=
 =?us-ascii?Q?anvD3sI2CyGQJBAPSDk6SwM2qGIznHT2Fr8LokGWI6hwy74VScpedltatYC1?=
 =?us-ascii?Q?042qzVA7npns7oNabe8Vy+cjGWAuWBRXCRj7iB/78Lp2+9dlFe3qwRzpRIuR?=
 =?us-ascii?Q?chZeNFStop2cI22+WF/6lwrGz/vhjCR6+s0xJR5/xG0O08ZRs2BoxdGcudJV?=
 =?us-ascii?Q?2D4i3jbiPy/5FBD1ppunxWn2kst1wR5aCzsD3GGjESwCiesFEzw7fA/ySoZQ?=
 =?us-ascii?Q?UmJOWfrhN2l/kp2qLgA/iyfzHglGqGJQOiDSae2HMX8BM4Mk8ah5s8d30bkS?=
 =?us-ascii?Q?8DIVuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c907ad58-4464-4f8a-c06d-08db2aef0e58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:04:03.1192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e22+QH72vef8AFSb1VjQBWyo2K6z7Vr6U1tidsrwkuci+DMO68Z57xr3pYSqDE33U9ETkmiMsuzjjRHvXcjpyC20NWsmqBLqs6GOyKE7HZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4564
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 10:23:32AM -0700, joshwash@google.com wrote:
> From: Joshua Washington <joshwash@google.com>
> 
> The link speed is never changed for the uptime of a VM, and the current
> implementation sends an admin queue command for each call. Admin queue
> command invocations have nontrivial overhead (e.g., VM exits), which can
> be disruptive to users if triggered frequently. Our telemetry data shows
> that there are VMs that make frequent calls to this admin queue command.
> Caching the result of the original admin queue command would eliminate
> the need to send multiple admin queue commands on subsequent calls to
> retrieve link speed.
> 
> Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")
> Signed-off-by: Joshua Washington <joshwash@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

