Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374BB6BBCC3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjCOSy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjCOSy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:54:57 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2106.outbound.protection.outlook.com [40.107.96.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B04317CE1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:54:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyrE70NDm9D2+YjMmVOzomjfYQu2pfl4kEb4Xn2m/G3WeHmSGuHUgnV2MDrwuiQeV7F0Njf9/Spp7yjbG6hrJTpAgSCcinv7FWStrQntmpSHc4cV/rGXAx/apWBB+KRDlGwstqIknKTnApZNfQJPpfJUXjzAxRLJ9vP/sEeXI4lf/Luun6qrtv1Lj4qRRh7rgDrU4xkcKRzSy8i9jBHJ/F4YOA8ahQz9yWJjzTpV4CeD8dS+oXz5R5ryW3WTOXlN9i9XHTKk5wHQNPjAu5KsWpOem95LLOrFBDL6i9bR2J3FyRXhP0sGNHO7AUSKEHsOxztB9aetuXo9S/xJJ+jhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvd9r+Pdltx/PUOKSi2bYQwrJZhSYMmV5r8iQvOGKbU=;
 b=JH4sDV6q+102dwCIlS7Jk+v5D20FSmkq3lN1yWG9bhiQ668soJTfr0KwkU4GhGuKN5ryGpnebOGk3WsXuEkdLUDbnX2xmBDf0jxP2/EwQu2pLyRYCMCNhzWpDNWAKJkYZCO1AcBIsk4Wqnyxs9+kQJGVSwgihws4eCXQUXtjAbwRrn8n4QREA+Nj8ZegzD0ELlvLSVbtkRRqG2YO0yXv8uMn+VPrHmTbFNRiZnDCAAnfeODl5VzQbkmQnAgAmhoeWkYF1devhcPvHEP9P8Ft0qAC4IlExEylcNnvwLeVAdKYzyFz3+Kizccyqz6xjazNC9mAZjyeeRfpur71ZDk72Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvd9r+Pdltx/PUOKSi2bYQwrJZhSYMmV5r8iQvOGKbU=;
 b=WTGIT8Oq5w/WO3GLftpvzSty+V8CFochY8T+9V9edHdIvYWWFXUIQf8sMXxlrNdt50NTRMFDxzhPL9vU9bx5S779mx4JOWC8q1QwTIYwd6smA4rId+7DH/pqtspR64s8cWi+7VMhy8MZWX/GNTliEneOUah2viGR6KQUZew6T3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5584.namprd13.prod.outlook.com (2603:10b6:303:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:54:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:54:53 +0000
Date:   Wed, 15 Mar 2023 19:54:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 8/8] inet_diag: constify raw_lookup() socket
 argument
Message-ID: <ZBIUeF37sYNV8ne8@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-9-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-9-edumazet@google.com>
X-ClientProxiedBy: AS4P192CA0022.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: aa7d6c7d-ad0a-4a77-b87f-08db2586c345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GnZqUwqMNrx5PBPZ4IEcYWxhfv90P0IBt3QG7mlyoT2HiqBtLaHKX3Q08gUkN6DHIiUwDBKhdH6AjtTtrKpn+O0uYRtcF8IY/EK/VdfIK363TaQaUhZZ2RsGJHp2KeFhocpHCzNSwUDCAYjGbKLNLng5M2frbzq2pMr8WDMeMtRKpjg44/qn05ce9guliE0j4bffdR6v1wUFT0mE1Pgdikk9zMnp/qVMRbpfyztLrY6YKFQOJqWgucvMWHUbyEstrW0/iWxMHWEbjAfZVe0ZDfcQFrcadx3QoIsrZpDxH8wErBu1Hh1FKrIvDOtgPYRcC6S6KyMjGo3MjzsaK1pgFcHzsKMhHq+KliEY/mzsGjKsaKsuVWp3iLt8CEr3ctambK7HzEFd4DL0TamWx5D45P3wKXZf0iGS4A4N7YymxdeM4vJ0bIIQZHVBE51ifHMl8aavUJzedzqP6nRlZc4KK5RrBtjYVLemVTP8uRw9dPWOEfGaFvSKrzh7c6lvA8hRbRp0csIynmK/bCwfE2kr/2H2MA4HkPXCGHSusvmokM8RGj9iCc2H9Fj57UhjzA1OkWi9E4OQC+ldrf1EOTrnhiP5lIi68F61900YB70EKD5I1ZdqcgYn7mMfYo9MCpcd4rRh0xTaMpvPeoC8hkgFKCSLL+1DDEgMvK5Tr4sJyTkROyvK8W9eXp6EArLRvg70
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199018)(36756003)(86362001)(558084003)(38100700002)(41300700001)(8936002)(2906002)(5660300002)(4326008)(2616005)(6512007)(6506007)(186003)(316002)(54906003)(66476007)(8676002)(6486002)(66946007)(6666004)(6916009)(44832011)(478600001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xj3JfgtugCSmv/+cq90DlDbr3NzCY19UZGruzurO6HUmZLaD73aorY6aOs+F?=
 =?us-ascii?Q?WMhuuXUdrCNd7RIeKneXMkWoUBuwjndQxOedbA2E7mn3a0grrQ08oBywOJaB?=
 =?us-ascii?Q?0t7NTxHtp80Tpn8LWIhaJWO6tcECaaieLkSXSNDyfmawPFy0uQp6A0ZC08rH?=
 =?us-ascii?Q?LROWYh4rn2NSXgHmcXzFzIdqIfJP9C0hz+nepe1pt4mKzwNPZtyKGPU1+fKD?=
 =?us-ascii?Q?UgyrdW2AtP7b7cmBuDnFuAhnBSc3nqb5FWuRC/wLzgzJheYVWi044vdM9aky?=
 =?us-ascii?Q?RXuUCGftvaMut8C4HOZxWmMYycPfsANK2Muxdf1YKwgfj0YbL0RsdHfQEB00?=
 =?us-ascii?Q?twY+OQF7cT0PoMI2AfluzJwIT00bX5yItLJRIjvBrdVV5Tbkcgbd3cwBueAT?=
 =?us-ascii?Q?CIab8T6r7zffhE+RJDFnJPf4odJ9BOv5xhJEIr7Vh8YkgsMM6r9yRHrfYKQI?=
 =?us-ascii?Q?s/PNcAyfqcJSYm8WRoOpekUr9VU7qdDvz6wmmc9r2NxxBPTgDDZSzVSXYqve?=
 =?us-ascii?Q?wl8WlY+XcwF9GgJYr3R1IP5Dkk0QedUGfsJnyFKjh2NWuoVNvOIgGu8ZRzEm?=
 =?us-ascii?Q?GYB1fid+6PcxZYr1rTaX3u+cFDjt24RM81f7PqRSx8vqC2t4NQQpdNpCorZt?=
 =?us-ascii?Q?afEK6sml5HJs18BHpzm56GczJLsNRG/o9Vpyk4INaSWKhOrlUBua+KmGaZI7?=
 =?us-ascii?Q?UOk3B8cZaba1PobZ1DmkEcMvBjY3eb7ZEkOOiULNwu0aNRgxgM66pqg8vOGH?=
 =?us-ascii?Q?zuf/KI3xSaRXLDCw9PP0XgCIRgg4XybkzjK+5VcAPWa6OFGumWD+zJWN4c4B?=
 =?us-ascii?Q?vXYT6SC5sxJEHZsdfoT1VtMTAtap4qypRDaiwpxlvtWwvM8iJ1VebzSQPXzK?=
 =?us-ascii?Q?N8lTi5Vy/B3SCsSbOpvC3t8wKvpR9YPlv2cg3II/+i2TYSaAdK1X/aX/8Zcn?=
 =?us-ascii?Q?JSWcGx0cK5uK2tE+MhFEifw09S6mzUR7wQyXyO0EJMMc+vq8KDYrTLIWUjo6?=
 =?us-ascii?Q?2eo11/rrGiZ9cVMCv38exVRzvMT41WzDPYMLCLIgels46LXWd/HEZ4C5zL25?=
 =?us-ascii?Q?EfWHRFSLOGBlZKX7TKQsFqHVGyfN0GXvfrIgVAwYFOwAtTcXNuBETtYogQBz?=
 =?us-ascii?Q?xb1+sr6UJ7Vg9AonGBT4/Bs3pKy23nxGFqJWG2ZjOVo+l3joEzX0YtZYot53?=
 =?us-ascii?Q?JVNqutYHvs9Ee3yJdbF6LuNci/NQgVTPWsMyZfytbHhQh76JO2fQ4Pr8diPv?=
 =?us-ascii?Q?9tZmyZOH2DyavbNgwdGysNxDQtZy4qPOGrPp5PTEzGbkRrJpqheawOei1rQt?=
 =?us-ascii?Q?GApHNymksF/sMVRgUx0q4zSX9rKc+H0k2vrotD/iCAf7r84VXzIRFXiujvp+?=
 =?us-ascii?Q?m7ouXckoQ3+kQc6s8tcqA9idhlamqdW7IpEPh3+EhvNW/PeiSUbZKZZlMRGq?=
 =?us-ascii?Q?agP1AHRp7+p/Kc2OJ7U7QzBEylf6NpF0Xt9r28GIIpH3zhMM3ZdNeGfBRNFp?=
 =?us-ascii?Q?9mMXs31pTGhGEnjMBp9Kz1pg5QOBbjm7q9Q4SlzJjCjzwVBeZabqpn7feU7F?=
 =?us-ascii?Q?vikrS10XrXVb75viF70rE37EZ0jBuoqKXtT9SC5rtRt9eM+GxaCb5Jv8WDsf?=
 =?us-ascii?Q?Jij1vECUTzzmmJQi/+xKBSDQdYkjsm8cf3FkP4aPU5MIoqYnt1cRzAWlVZZx?=
 =?us-ascii?Q?LscPfQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7d6c7d-ad0a-4a77-b87f-08db2586c345
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:54:53.7372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSIcun77lE+3Vz+MFAtrx9vgISFFXqYlPtxylzOPQT572qaB64M1jo/D/Z56QV+fIsu84E/B1cxgTOTqLWGeCKjPaLhSQ0fH7rIs6F0ioOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5584
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:45PM +0000, Eric Dumazet wrote:
> Now both raw_v4_match() and raw_v6_match() accept a const socket,
> raw_lookup() can do the same to clarify its role.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

