Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9306C8D00
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 10:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjCYJvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 05:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjCYJvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 05:51:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2105.outbound.protection.outlook.com [40.107.243.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BA440CB
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 02:51:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0m9ZEr+klLauJ4K5t5HmeCuHuxhP6qHz9epcslOkV8JToWO2dO+4G+uaMY0o6HZ1OkjpqXOeUqoS7PwjoCjMjPAEBRWsF4frQ3MfwQDFDQpK224WeAoEqpFn6Ex11qqSR7hW1PeqsEvZuwTBNB8wlV8WXZPpRsIMvNXxnDjQJ3pI/0q0Z1uhEbMAwYSFmQhbYDwU8yYOIWVcXjGK/+Rgrxc/thl55y9J5R9wyUcHoipwE6g2/NWCgNLpyLFlEcDaFSgP+4F0LDaY77WBaAb6VZtYQynAGah8Vxo3QPhWFQ8KSfwNrTxpTKw+FjZoJMKdX7+Ni0B02xCXXMj2/wNKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IH0PkVvqGKyWvTnq6sm6njL8GhFT0WYzOXgO8cF9/Yo=;
 b=YdfeewJ2K8WMy4wC3E7XpxqU6qQSjzlWsBqa6//vTFIXO43i+t8uANf7RI6QqMlpEaZc2jmiDpggHKzeuThGJCEsM6Ti9p7W5b3IHkMCuyRYgfn71ZEKFaa5ZcaokA3Xkgdo19SXLC4TNA3ODJ1TXma/+MM5T3kLpICIMhQxBjA3xj8u4GRadoGWG7mq+jCkFeshl0f/gI/OR92vfrTMkevNZ8jf00uClqcffx9JgxtI2G2OoPIVzBkr076A0n6asdYbO9ZvTvtiUeKnMZCokdYuG1dmYWkdWq2jbwE2ysiPsh6acvyzy/QA+BsgE/Ps3mZB1bIk+y5sQ1le9+D4ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IH0PkVvqGKyWvTnq6sm6njL8GhFT0WYzOXgO8cF9/Yo=;
 b=o/v5ASx6fnMBSWmlrfK2yJbnF/mPw21HPHxrEmbKpyPi+DO6fNfXgmE3bhUJCuBVog38/kyQ3tiucAiC3nGSAl80ggH+qanHYh1XdfK3f5rdnoFgxvvPc7a+4eSLz5BtcjRXg3fgtYWywWIaoZ1VFotVbF+ZIKdQ2GNLIiM2Bwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3748.namprd13.prod.outlook.com (2603:10b6:a03:22b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Sat, 25 Mar
 2023 09:51:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 09:51:17 +0000
Date:   Sat, 25 Mar 2023 10:51:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] dev_ioctl: fix a W=1 warning
Message-ID: <ZB7ED+jskOrP4bfS@corigine.com>
References: <d4a549bc-062c-e6cb-fb2f-75f32f8b3964@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4a549bc-062c-e6cb-fb2f-75f32f8b3964@gmail.com>
X-ClientProxiedBy: AM4PR07CA0017.eurprd07.prod.outlook.com
 (2603:10a6:205:1::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3748:EE_
X-MS-Office365-Filtering-Correlation-Id: f1967ff3-0c3e-42bc-d715-08db2d167a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PG+pF/Cd4MnyVZnvMoRnNkOIztmMkop2Onz2XLooZ48kbd7rxqIirpnitGO0DbhOFRomUVLSvBgqLVd5KUIM8O531IFop45g+Fei3zMmsFIcQIplY3WH47UuJyex6ZxUSWjg1fD2b3eRISaij4qXkeb9nftIpSEpUWSPoANxjAfbq8B7/6IcMgD3xN+6/TWbRIGMCVmuoVQKix1nrzWKjWh0BPNljzYbp6ceJNs6rIM5IzTHJto1CdzOMg5Xt1qN4E/faBMhLlL6/k+SQ8+V1cYAIJh56cbb/D5bdJp4X4zXD6jKuzEMXOBeuyXSdWncw3gFtXaZjoj8xxC9gxFDqTPcU1dAe6G3g/PFYGthaZmOe0kX3tfr+HaCtTa5//evcN8a3WVzVzbtLy0D1Y1DOxJpUlPFJvNWe3RnW3qoi+a6GJ608OutBilopcH1sKVDE3vXrWQFLRCha2bLhIyLlVAWLfdkGVT7zWOsoRMR2DWd4KFXaJGxTXhzYAMcPHm/Pop5IiZ5q1toDoMtNuOqGVJn8iUB4upeWlVbbuWDGKUJp3fOabf8tIQPBvosebOAh2/Dh0Yz+XcvV3NImnt5aR2HURrYTQluMyQSuRIMTsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(346002)(136003)(376002)(451199021)(6512007)(6506007)(36756003)(4326008)(5660300002)(478600001)(83380400001)(6666004)(186003)(38100700002)(6486002)(6916009)(66946007)(66556008)(66476007)(86362001)(8676002)(41300700001)(8936002)(44832011)(2906002)(4744005)(2616005)(316002)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g2PhiemKdqPeBzZ8atQOsPYcPAbkG764AphhaHDszGQn4yr3FEqj+aqiZ9eA?=
 =?us-ascii?Q?3r+PeLEXXiFlV7uvDwINcVYRrTOpZvDHKrkVuTzy/56Ncots5kO8MqxFYjdg?=
 =?us-ascii?Q?xXw4jouIO2HSEMj+HCBJ9pZNt5pabmMb0n4doMc37rdqtcF+njqwZvrx2i9O?=
 =?us-ascii?Q?DlYgDrjLKWFfTIP36yGmKAa3I9P/xrVLwKv58qozLwTMIZAKVFOq9FDz1xpL?=
 =?us-ascii?Q?VsXP3ix1RiZbhxUIzceLjwUtkAWPDcuEuvXd3zucWZAtJ6sovXO8JsJbaK5I?=
 =?us-ascii?Q?ALDZuy/PKXpIRF6t9uKxGSzvsj1XKZ1NOVSzpRAw7F+LyhoOhnboDdgi9qGg?=
 =?us-ascii?Q?Jlt6Mcs7QGSaKQJMsM8t7/wXz8DMLQ1DPuzNpA2PKl3UGE5AL3WNrqsc0nZ4?=
 =?us-ascii?Q?6rapUu4TCX8ELkIljLkKkfi/cnonynT39052leG4Ur9mIxXjsd4nrnSHJZ1i?=
 =?us-ascii?Q?1qcNZu8e7nP5iRhMYkVsF8yt9uY3mmIv/5S/G0NPRMEvupaiTwrshEEhgK/k?=
 =?us-ascii?Q?1BjwO05DZ0Zt/jb84aggn6z3H3za/RcMxSOT4VsaGxy+lFtk4HXLkgY4Jmh2?=
 =?us-ascii?Q?7eibixqR7AoRqZfg4b4DvFPZuLYqyuAA3EDDtjg+EUU7asJcMb4VcXEoPWeJ?=
 =?us-ascii?Q?2vcZLo9FOJmPCKExGEVkdLtfPp1OMxVTTSnF1tAMYwqA0sRTR8cHh9roMfH6?=
 =?us-ascii?Q?qYXovjWNgdboBdaIZDCehTV05m+Lx3IVdQqiJEq2FuKWhBoSNqnUZiyUKCte?=
 =?us-ascii?Q?RxvngHPWFpxzR5xxoo0t3IhQOyAvTULRBtaoRWjSBCpoxiL/6cVcaO7TwyHf?=
 =?us-ascii?Q?KGsLqntQYalIycsBmA0nZTYOnkyYHyoM6cXntFEM2zMOq4Ldt+WLYL/ADHMZ?=
 =?us-ascii?Q?KWG2HN2+MPSP2VA05NfNCiJc7JhYMXu+COpo8YHNxwbMeDHMMj+rOpOiG9Gl?=
 =?us-ascii?Q?qfIZe1knq0SQsWwpCBweKmebbZSrZaPPamcFmG2SRx0UloBlJqw6VwOnmRyW?=
 =?us-ascii?Q?RsbQnpPEltqpEcHuGVuEQbIRbLDCEfbeWPhGnQgYNiVAmVkg5OIQtYsWAKDc?=
 =?us-ascii?Q?1ipL4YHfSorFtnATsbqo16WzYWtgfPz6WDPY+OVOPwM3QtbUhByvx3P1y4NZ?=
 =?us-ascii?Q?EyM08TdYTiyXjuYLuBT9/DDhR8YaQHqiolEt99+nUX0pwZ5D5KaP5KzdVMFF?=
 =?us-ascii?Q?IIqf9kliOuiJDC0a7QqJmpCj2bY9iVx0yTX5Ne4bWh2WAuKA2FY8ihBN01ln?=
 =?us-ascii?Q?Ida25+gWgy2iqe1cfRx0XIlZuu3h8jzEJYaqGJV8NKEDrCCKqZ8EUrLqW1fZ?=
 =?us-ascii?Q?ul1lPKfmiKI89JBY09l6x6j+fDGolXWLOIpwEWdTxfNZpBZsiJn0kck8xsoK?=
 =?us-ascii?Q?QR5Ket8gQn20GMHT4V6yrnAhu5Y2w219t6AAxYDUaMEKPJyXJ0IEAeZKrKnT?=
 =?us-ascii?Q?oBvP5/JGc6evCjVIiNqWcKxILW9W/IsQLW9+svZ/vczj2F4fkDHzCOpItRMC?=
 =?us-ascii?Q?X5F+/ZLSYcXbEmqOsEhuEcTYpSfZnOnAv2OWqHVpjm+55Ik3Uv3En8fd+jQ8?=
 =?us-ascii?Q?SE/L58G2J+3d8/Rz3X7vYNgIweTOYXn4+T6SYpwgh/hsaZUXBlFob8MHfjbL?=
 =?us-ascii?Q?p5phtBJJUanDoEQCDwDiN55VK5pdmQx4qeDHYjrdbqEJlGL/Y6lFZQQJuyew?=
 =?us-ascii?Q?L0MAhQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1967ff3-0c3e-42bc-d715-08db2d167a76
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 09:51:17.2070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hw0QWxdUeSwKz6ibmXAf9hdzbHV2pgHFY/ArBNAHcokwtBM5ExKA6Y1y+0K9RAjVeTqS95bNwaAKXiSinYkgGbbQuUxQ7QWYIUE2Bul+8cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3748
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 11:11:49PM +0100, Heiner Kallweit wrote:
> This fixes the following warning when compiled with GCC 12.2.0 and W=1.
> 
> net/core/dev_ioctl.c:475: warning: Function parameter or member 'data'
> not described in 'dev_ioctl'
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

