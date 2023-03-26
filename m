Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F7D6C94EA
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjCZOCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjCZOCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:02:38 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2125.outbound.protection.outlook.com [40.107.223.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20271B3
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 07:02:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HliV79s0LOlvgtsWVSsgVjiosv393m47s3GYRDkVCcNr+6tQ6ndlkEiDd0XNCmuyZ3FN6EyW4obaZQkbVGRQah+nbDK3zYOkSJnGdv3q1/W5gPIhLIZ1fDhJBuFnuPI9T4ucEVyXdNn5CTfyEVqBBQFdkCt0UYgEFQ+U1/LDJHIYd/Ameh1GpP7bCmAkUQjpJ9pA8K4SLXcEGZQ9XY5hOKsYdG4PG4bgDnVZJRfNUppPKisXy6y41vVqn5wVJd6aDnIzQwtx52qgANNU/1g7XZGy/9fTn58k8g7JQqrY5iQ4WHwsHO1s7OXh6BhsCtef94nwjYdMT3xokWX8jjDjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifK/dtnPz2J8qG+O4sfsRHycP9KLDcCt5udasRN8Q+o=;
 b=bbWcIAiGrNXTt+QOQ2aVY9Vd9BwrtOVZ0onIVG7Yx5JeQ7aGhqFwUprxVgdmEqPJixBprYchJBpOg0/clEpTxNZxROoNaxriF6i2GlM1d79sZjk8o6+g9WQfEF6Hyn9O43T+xSJSUHLKtXNE5JVo0I4l2x33JQbS0B0nWibEGLTe1iY8vnXEDtYhKKsbsfRDhXI9PtmpjOgsZnBd+iFa/FkS9LAT/JnKnN4ug3V/eUF4/RFjkqU9DMHP3i/7xIcFh39Aw8o+EKMpJXVW9MopR6N45VeYlr6JqKmBE8pXLWPVbTj7cpuWQUozFxuH1+xIoh9kHljoywaY+Nzyiw5KiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifK/dtnPz2J8qG+O4sfsRHycP9KLDcCt5udasRN8Q+o=;
 b=u+ntoOpiWxZcGoQ6LFGC6EVfW5cOlQ5wLOEzjYDIbvfIthbsWONbK8TtAyvgIUb++f/KFAevnAikVp2pjryP4ggx7xKPPCn7GyONgUbnD8A8ZhArkmTSLsKA5DrugjkpjhJLvb1jluor9GvmIkX1YJwKo1/gnmx7Xx4P0EY3yE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Sun, 26 Mar
 2023 14:02:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 14:02:33 +0000
Date:   Sun, 26 Mar 2023 16:02:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 3/6] mlxsw: Extend MRSR pack() function to
 support new commands
Message-ID: <ZCBQc3UQ92cr+ZOd@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <57356b6bcd2e32661ad7e2bb5b57ce3adf2315eb.1679502371.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57356b6bcd2e32661ad7e2bb5b57ce3adf2315eb.1679502371.git.petrm@nvidia.com>
X-ClientProxiedBy: AS4P190CA0061.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b3e973-432b-46f4-f1ff-08db2e02bf46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QC8qwNPCJW/eNv/5M5dbp5Wjj7RqIiERhck8MgPdVthPDE+FlK9CZhl9qPpjVchXLswlitJvWlbWJYcocpu5CwBT8zqy5fLwonhEPzTJmL/RlYVlzBj4JEglau5zgMYboFD/sF99yKv4RZA0HzQJocShEzTk3lw+XB2G2KknY3DZvh+E4l2VWqJdcEONIl7yqKR2UeEj+K4r1SlCT8P/+kzzJESLYXLb1CKw4hv6CGPNBAmmrtOz3jHo5D5ES8NUPs24UZLA5EzFdbRirr/FZQ+CyvVG8UXXXJTQA0oawogRUHKNmf4DeUVApBNwo4dfB2DPG0/DkOhqez1fi51sr8K/iErKgYwiiOmAzuPRa8oiKXOuPyUCT4aCjX0p+0hfoivsP2WGvWrd2tcQ198RY1rhVWrZpDwr56+/3+mejG9OBEGh86SKsA1OstUJmpPneHEUiu26HIYcZMeSVRMMln2xKXSRhteKgEWqDEYgUllprEn9ISfGODxEQD3v49ADYn/lJMt8nqSREcmAW/C3ML5gZ48Rk72eh5EbWcst8NPz1Fi4a3YpvKLjJzTdjRGWL91xwrg9+NHbjR663sFFJGeV50f7P3hCMyWU8MzeiDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(346002)(366004)(396003)(451199021)(2616005)(4326008)(66476007)(66946007)(66556008)(6916009)(8676002)(6486002)(54906003)(478600001)(6512007)(6506007)(186003)(316002)(6666004)(2906002)(4744005)(44832011)(36756003)(86362001)(41300700001)(38100700002)(5660300002)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7xBnVv7mSODmVPpnGrLrQZfkVOUhwAQQbPp3cGVjn9zN6FlXJJUCNYyNh0Fy?=
 =?us-ascii?Q?mLQ+yrlkhMjqkI8I682Z07LLY5GkVbvi1WK5hTwvye/Ccbau8ogloOxVKLJe?=
 =?us-ascii?Q?lKjTtoLJ9w2EwHVxtyBi8bJnggm7T/JNIWQhwxdMcGHjWBELOUcJu7t0mzm4?=
 =?us-ascii?Q?EAvGfedZ61Ez9FY7EmZ0daR6Qfpl9JnHOLBRPeZyq4sN6wDsfLC8sZLVi/p6?=
 =?us-ascii?Q?5pARnEekzWEjYV7mw7wS/fWLe9GgTMxuPvMUjKvyG44Q8ZzGuPYwkA5Ao688?=
 =?us-ascii?Q?wAFPZ70HHeq1Gy4pwe1j3KE04oGrDe+GbiMLTAot2C5TOAaJrbAw4YW2fPPE?=
 =?us-ascii?Q?ogNxECy8aA5HFl1+De+dNsBH6F6RPULN89e/C+R+m9BXyKYMFclRPZ6Yqj1s?=
 =?us-ascii?Q?r5E/rycprnqjYJGOEsaMOeEkqZgwXUaUzbA7g+LbyvqYja97O29WkH/hxcJA?=
 =?us-ascii?Q?a1vnPFpcVTeoXZtJsO2U2VT31KkByAMIkLKA9/ZXkZzbW15hJZdy9oq9Daca?=
 =?us-ascii?Q?66IEP/chCYYkaAu4kMs4yHUdpiuaHinz3pr+vl4lfiUqckEf91pdkiqfPi1I?=
 =?us-ascii?Q?eR0z38APWOettxuQ+dqO8VfS4/KqqpNH+mIHyJj1qseyMJyEzoKP92Fl83uK?=
 =?us-ascii?Q?87sAFTWJac8/vSuV7PUTtQANvhvwR1UaziGIsP1EvnR+dKf2Jdg/lKCJgXB3?=
 =?us-ascii?Q?VBj1j6+Mho4JLsRE6HNwUukLrjWXUgKvVPCEF2XwhDRFVKGZLLjOVSHZ9NCw?=
 =?us-ascii?Q?cRB4QeeJ3CUM6cxRc6V8z1o9/BwYOkrvNm5DsR1j2+WdsNtrwUf5nleFkNOo?=
 =?us-ascii?Q?vPkogL3db4PCGyePnQmUToISuMnsanENtwNbySiZD/qrIkswtLYDMt6BlR1a?=
 =?us-ascii?Q?W2jooleZXU1lBD1+4jvuUqMr/k2H00nu9pvASMQxh28h9p1HyU7/CEpN6Iza?=
 =?us-ascii?Q?YCojO9fATSQSWAo4R5Hgxzsk+gIq8L8fvxdSZQI+jIJ4Uhx+HYKPb7moeosg?=
 =?us-ascii?Q?OQDlSfpB0K09Oo0mJNUwnQQfUiGpMCrSZ+Fjral392RySiIgIipB58dHIbqW?=
 =?us-ascii?Q?dU8EgwKwiALn8RUS343qhfxdiRE+srps592ZSryhJzeXYJClCqtx2SwuGDbH?=
 =?us-ascii?Q?AVNrOTw6QMcdU6DLEoHsHGMAIEGs1Obv+D7fcJkv8iNkjLTyV6NEVPnY/GGV?=
 =?us-ascii?Q?EWi8irp7PvLi4Gl4Bot7nlHQKGYLGs11K6fc/e4Y+OgDwJu8SB8SCEQBq1rU?=
 =?us-ascii?Q?t+Z3oBDUbhUebASei8NOcbaxZsmAOrcwNhaPwrh6NjcooQ8dK3aOJ2aorOBi?=
 =?us-ascii?Q?DUSty+VRoUOLX0XDBH/+f3SUsnBqGKrTuaxLQPhKrn/LeoRRSHZ8CP2dOvdJ?=
 =?us-ascii?Q?7mKhkqqpb1yF+44ehT9ZZPodQGXOeZpCV6Wths2IZiSxmtzOvJiCzFHdC54I?=
 =?us-ascii?Q?E9YO5QcKyO5fupWa597eDQDwX8oiIpGziHgDSJ5zxcerHNQG+fHcRcNub2Cr?=
 =?us-ascii?Q?iLmqBAjJEqT/1VkmEWLP4mtmkwMzzjxhMLc8Ry5QsLXRVuPUb7E+UzyT5yV6?=
 =?us-ascii?Q?ZqhJWZDy1qJXo29Zy3H5tRb+7B2FMwRZ3MKlUgdrmQguzhVfIZCqdFTYSvyh?=
 =?us-ascii?Q?0Oer6MxbmKTa1aVlTFOHxZRp133WWB09nFksiQr7/Ak6lHCuAhbej/+yxBxH?=
 =?us-ascii?Q?asltlw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b3e973-432b-46f4-f1ff-08db2e02bf46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 14:02:33.8687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rxfwk1kPWRM/iObKa8o9lAJJZ/hXLNkXEHFVAVodQx+wDSq6LbdHekjnDO+gkQxjeC1XAju6tEocIQ12GZs7QDf8UL91VjwkmWaBJFPlbcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:49:32PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> Currently mlxsw_reg_mrsr_pack() always sets 'command=1'. As preparation for
> support of new reset flow, pass the command as an argument to the
> function and add an enum for this field.
> 
> For now, always pass 'command=1' to the pack() function.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

