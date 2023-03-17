Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3076BEF0F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCQRDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCQRDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:03:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6E22A9B3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:03:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi/ODCh8ai9BiGXElwqcCxxz7nSpnoeFp9++/OD5egGDOBSEL+G3UPhoAA4f6wiLmb2dSmWGFlY/gSNpKxBqYWpPwWtivUcLpKmkeFB4ZQIquUvyy4NgbjKmGQTiB/Mghh/kScEGqD2n8spF8dV+Na3+lBD5ZZalJ79fqrV6LdEvQvHvLx0gq3NZmtTMBpMvv8IEaBCAMPtqMuLJOpQNm6ERmkGGveDx/Wc1m01zvDfLRCyJEnEZvm/MxxtIhh9C1Fm4jYb6ArjQHTfzlSvuT3yjMMkh9t4Z1Ogs+kYgZSfhnsL9jgbPLJLz1v9lAeg82KivIoAKHtu8A36DEs8LsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdNljN0aTpCV9pBbOMwHn6scp1Si5R/MvzVcYtZU1m8=;
 b=n0X6IGHSaySaAD5Uf1WnrrBcYGTe25b587sneYAt2jtKSPIadTsJmkAesbbYmj0regJ93uYRM1CUDMjbd0byfiVuihzOuCxjEBO17ijOC2srZjvtaF18uNCtCTzP8HaatdbjErn2A0Jy7YWtcKUMGUaeQZCTIhUnsz6dvJNJAkIqH8JMXepE5t7FrUjq2bJD1pwerUt5n6MbYKOj9ke5isszOMEa6pECQF6UvTqGyZZeAr/MpBBqm0osZgnxq0jMG/IYmc7F84ivkCRBp4r4r3ONFwBSrEi7Lt/I3tWEvJTQjYW9s/xRJiX3iAEIS6+lIAqENfIiQTMeZThXZ2DlkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdNljN0aTpCV9pBbOMwHn6scp1Si5R/MvzVcYtZU1m8=;
 b=GygBNf+WGv4BaIuwo8/ZT7ReoCsPdNJ7JLibRi//r2amIasnaMv5txlweSA+8fsPecxvHsAVIKFlY159gesjiPF/X30sTyRj0xL85Aroh1tGCfJ1aAn9DexVw8+IVaMHdqebt2AaLWvGRBjVR9qbhiwSp1KSbrl2WPbMaNZY/Ro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3879.namprd13.prod.outlook.com (2603:10b6:610:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 17:03:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 17:03:26 +0000
Date:   Fri, 17 Mar 2023 18:03:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 08/10] x25: preserve const qualifier in
 [a]x25_sk()
Message-ID: <ZBSdWGDgLbFBLg5Y@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-9-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-9-edumazet@google.com>
X-ClientProxiedBy: AM0PR01CA0162.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3879:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b5b127-c2fb-4e02-996c-08db27098658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LeUSe83F3zs/WbFxyYLE2iVAD2SAcRTn9iYajQuKeO5MvkW76J1+OfYTQKDxNgwTZvKQe7JFj0TzjxvXgcG7rB9V781dhluSJXcO9pDVya0zCagnYKW8JcdurRaOyIOoRKcO+wwDLyZkrwTBi/QOBwx43vpXbu1pe+u5RcigZesx/kDDcXaoYLd3NfGPr7gWqQsbI3p+5aJKQStz0PF5swq6Pnj3rS15sq/ngMB+gIAZYOaum6Ty6PMXdgcMMiMGHhSVDBAHfECKa8oqC07wdIQjR/HxlGH8CKenAeYz0m+fgM/TzEZrFHlw3TNJLsfIZpvAiIUx7jC2Z8Ya7uZ5NvbRCKP3oXe8h9aEM5ZpPvBHptKdpS/zoa4AQa4cVcXPJRUDsoieUjI6ewvuGeyWv9otBa15qcD06YyenZFBOgGDYEToRFLu46GskKSTtoO312yjoGLqVaFZAK8unkMETCLaxKcDUnSwpukJuMnFCcb7h7OgYWHiosAdV1effhW3C45ey9+CkSdUkKiZXmkV8IS2aFu6Trj9gGWJNdQa69GXUv0fa7gtJ/qPuyFkze1TO//6G9GAVadXy7wQ3uoOAOkAJTUioL+1WQrNF8sAzk8oXNtB5IB/zTgLvLL4L+ZZGVobs0dYESY0NzD6Dm4z0zV5j8RBTcb//+UThF7AHD6bl6BigrIl1LI3i0giluH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39840400004)(136003)(376002)(366004)(451199018)(4326008)(6486002)(478600001)(6506007)(6512007)(54906003)(66946007)(186003)(316002)(2616005)(6666004)(66476007)(6916009)(66556008)(8676002)(5660300002)(8936002)(44832011)(41300700001)(38100700002)(2906002)(86362001)(36756003)(558084003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4nJtmoChXsT+7hnWGRn2+N7Sd2Xepv+MysLMcgrPNb2GI+XvbJ60yofTUjE?=
 =?us-ascii?Q?+w39NqN4Udojngq6xAOEyMAtdstg/q6uLvDE5hQqak4c8cFj9fwILpr1ZQY4?=
 =?us-ascii?Q?D4hFxxpPCgEH1nAhe8PmeuKBkyBlX3ekWgV9VG3vr98UlwBJg1G++rVlyg9f?=
 =?us-ascii?Q?xQI4nDQTcK2Ij4CPCYanNPDWw9DR+MXlneQ3gsc4xiQ4PF9MKO7INmGJ/B8L?=
 =?us-ascii?Q?g2UbH1i1aa1p39VwBDAtOGmL7N6BQGtlu8WFYar58qXHQJmr/tqRw8LJV3t8?=
 =?us-ascii?Q?bw3SN6To07uNpXDVHH+vFC8XNA1SC/Px9P2GA9Xmd7HAcBRHclLNxIF/Ngy6?=
 =?us-ascii?Q?22DOsfx7xWQfTClroB8KF0NiIQ8XkZpsxP7DxMJRL90UDY2ulS3GGhodvZJW?=
 =?us-ascii?Q?iJmTWlSt8HQS365UpdmgneZlP3caNXtS2EmwkElBFVe5GXd+lKml8/vZcOVa?=
 =?us-ascii?Q?CMIh7zXQ+eTec6gzyswwl/ZfWvXGstKhRDa4yOkC+a3DGmkoH+0Yb+tEt3Ha?=
 =?us-ascii?Q?UOeJ84200OBoBjCGNE66gQEhvCX7g8yBQzizXYAKsA1+q8dHKgHXwSD5lQFG?=
 =?us-ascii?Q?Ndx1yB44bmSwFoMJ0LnR15GBnj6SDTl2OkZfYe4LW/tpHnWHK5IM7lcTVr+V?=
 =?us-ascii?Q?kCh1JDYsWYqxUvOu5lWgejgZDBLk9Hr0WKAAslQFpobUHHOUMR0rcDGW/3Os?=
 =?us-ascii?Q?3zn+UchOBXG9fdFE6rp8mZMdQRcE76PMTg3b9bYc8xYimc2wu/G1w8gcgpU6?=
 =?us-ascii?Q?kqfRHxN6NIIv+9zbe1XmbE5HnOvA8NojexkiYa7xcgyu9ji+7h4Bx8Tvi3Md?=
 =?us-ascii?Q?L6jArDWvQM06qPbVwuHR/cHw6HB6jMvCroStWg1jlqxtHDd0uR46e1UAMCS4?=
 =?us-ascii?Q?V9gA7vR8TPG4Y5qJjPTBRoe7iO0RuiWUia88tRO/PQPQQTTjcwB7lV8ZqtKi?=
 =?us-ascii?Q?XYBesdGXQQ+UYL7Y9d1pCzI0VTmeAi7XyrQVtJ5Qmaq7GSleYMyCfod/5ran?=
 =?us-ascii?Q?8ZCfE8QzG8M7ji/s1okFlUDmXZT+gUkVhKWfAVOBIHXL7yd2y3LVuOC23jIv?=
 =?us-ascii?Q?VQFQSeU6Cspv/OSsFZ7i0fEsh/mI0/eE4nNdeQq4R3T7inWXeTT/EglLNWT4?=
 =?us-ascii?Q?Ne/dg2td8TYiHLG5PoWQx7/RxHwxFa34TkZW0fmY91xxvs8gFUbWhrPv2sgd?=
 =?us-ascii?Q?rINzp1urTS8eYuB5Rk0hnD0ErGdQgy3YMhMH5MLyZr7wDTu+aLIL4b3ICpPP?=
 =?us-ascii?Q?CPFWp5GaV/iSNOJ8VAh1BpLC2UVlxDlctACcj1PNNjOus5qE/QZtSHLpIEhk?=
 =?us-ascii?Q?lf4iu2y4FCByWky4tnJicG2uXfKXneBi2P9g3pShL8647aEQCotfWe6A+67T?=
 =?us-ascii?Q?g8zlpY140ojcJcJybowE0rFSO5FsFe8e9qwZO8qclPrvBEVFcW1PZ0OZgYh7?=
 =?us-ascii?Q?sg7rCUoa3MJMMnXlHC59vyf31Gd1GYlmLrqQ24RfQ6bEfGQr6WTns6/pZ0W5?=
 =?us-ascii?Q?elibb6LMXYs9T9vZ+mN6wQSo7FgvnOHxPvRWuGOVbDYXExnEyFvVbAubjsZ+?=
 =?us-ascii?Q?BdBH/5Fz7eNHeUZSoQKpcDGMtn8o6xOx8HLTum/LubZmjlekXEwCBvLx8Kr6?=
 =?us-ascii?Q?U1kggS9KJOSIha2dcUzXj9Ya41vd9ualOJOgw6pCh2VjETykHq0yFxXj77XH?=
 =?us-ascii?Q?5cdUYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b5b127-c2fb-4e02-996c-08db27098658
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 17:03:26.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sXeRxrWg+7+4pQeGuC/WBWMNqjofipeSL6i5MxYZCSTE6kaT052h4pnZjTGUd4sd5ykKGYGKyaNgKfn5RQFlAJt6mF/Iq9omgTaiAoBUv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3879
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:37PM +0000, Eric Dumazet wrote:
> We can change [a]x25_sk() to propagate their argument const qualifier,
> thanks to container_of_const().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

