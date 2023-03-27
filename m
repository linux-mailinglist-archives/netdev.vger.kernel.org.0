Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654F96CA7AE
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjC0O3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbjC0O3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:29:20 -0400
Received: from outbound.mail.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F8065A5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:28:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrsmF9iwIrHxLjpFZAnFyn6NQC2UWBBKMXSAO+s+KxMAbvi0gW6ibT5IYRbqB6WU1YKg6588rJR1iyNlktOQTlVyRwjlvpEhYrhqScj8WhNIE4rPeZ73vq9c15cdcJBLOIQv0yQvAHbB2YLBBYRYM4Z2XB4B9I27MBwrCjdzbU8DiCO62+9HmfJ8MtcB1DUerBneBw2S8JfQIogT0Xpzy+R1GS4mbaZl6hAbe8RoJJky9RPHOpa3RzBNfnr0f/v+oVjBTtH9khXGv4LkuRuvYPyUuKR+WLoQPoNUpMTtwwdgd1AB/ZBvRpYRK0ibjVrge/A6VKHpcj7jPQPGfdbRMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0HFYYbAX+nK+yL9rmN2x1MyAOulf1PVK77YV02Objw=;
 b=mAHP3fceJXsdP23yG6odXrdwfsBb5a7UzQdFKQYK4HIsR9gcjlLroa4f3FltS1E0Omqd6n8dOOkOqSxFUlm8iUJEQALLBV0w8GJ4H+X2h/GV6CVFLgkmNo9z0gHLlaMJD8quXk0/M2bh5U4CSx0wALCvRmlIQnaTHtqL034ylxd3kwbMKhWlch09N+lvIPUbBD+Oefk54vIQGNHycdRosWUN1ncowGXPnvP9rgGYxBvluxts23gD6280xM4blZ8YmpqgUJaJ5Aj1cs7s0UfniVR6dvOWIqVNC9UqraIhT0FRQi/MoRbeV0+/35sTFht1bt3iPJK8odRw/glV78gFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0HFYYbAX+nK+yL9rmN2x1MyAOulf1PVK77YV02Objw=;
 b=RKRNBmhXKdPybGdp5pU+JT3Ghqp93CUqJ/QUcE2ndpyvJKv5VvEL9ulsmyrDZ/V1x/UUKgNCl/qSK3zm7iXd94qKB81j5hYRyWVPkRJemK8zigWiiYV6Sk2wgr0AEfbHHrWZ0nIeU1Tn/nf7Uzy/u2LRhbPdI8Ho45phwtq/0ik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5545.namprd13.prod.outlook.com (2603:10b6:a03:424::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Mon, 27 Mar
 2023 14:28:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 14:28:33 +0000
Date:   Mon, 27 Mar 2023 16:28:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v3 4/6] sfc: add functions to insert encap
 matches into the MAE
Message-ID: <ZCGoCl77wA26ebA3@corigine.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
 <88f67546ea63c9695e7c228d06d0f129dd383530.1679912088.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88f67546ea63c9695e7c228d06d0f129dd383530.1679912088.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5545:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0fb0ad-3001-44f7-7c24-08db2ecf8b0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pk2a4JyjdcQDvIsywgGth02XAVLN+48IY0iViVTXPNU9Y9bvMZSXODJMO/ZWEd17bqKU0/E7tD7vHrFDcddqfDxm19U4qBECbx0W88W4NEilDGp+RIvRzU1/HNEhPuxEk+0z//QcdfE/4Kh1/WDUYJ2H8wEvTSyvwJIeuNIAr1RNVGTQf8vDYQLsBbC1EqJhFiy8+a0nwBH+nBTtk4mOKcCQoHbLUDPFnCvLmYvm5WLgRYTfFwoAqHwgwy9VOkD+z5u0WO+4ZWbuTSSrHd3gp2aXOBIpRhUI3dEuMBCDivRJMd7liFgR4o3lri8Inl/sqj3BHn3WoYb66bR28O4abmGfdP3vgt6TTQs6MMifENfoSH8Wgwq2g/DJlv3sBu+I85ymaehziBeTEg/XcmaIVwl07deyQeHtrXKqZOMJjIqgUN2PrkykFIPun9BnO8wZEcr7uaXsxovyF4mynEfYCuvZNc4TxNXP/Uste+bkvKt6AKjX/GV9gHLai0ilYxJItTf4RAmjjP0J6dxYXhq9dABgBHZ7nijsquZYDO9weSSs2w4gsjyuuOyywnz4/E7wJzcAqc5HuwUlzLXztcE82ZVbe4ZaZwIEKUV/02jmpfk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(376002)(136003)(366004)(451199021)(2616005)(41300700001)(44832011)(86362001)(36756003)(5660300002)(38100700002)(8936002)(6486002)(478600001)(8676002)(66946007)(66556008)(4326008)(6916009)(2906002)(66476007)(4744005)(7416002)(6666004)(6506007)(186003)(6512007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZKMWc29qB0uX0X8LoufEPloqDAncAiUey7gBR61BMBO/xjiItBM8iiQH8C2I?=
 =?us-ascii?Q?HQYtTNaH8e0CbQX65wpl46dkRkdD5TTXQyXU3mAWKv8T1a9cEViDmUDLLDfu?=
 =?us-ascii?Q?Bd8UR9nWillY3Wl00mZUFM7Sa2PoQGLsiBI7FXPHEXkr+BLUb8xR4p649Q16?=
 =?us-ascii?Q?eG4iwfOBXDPB6k26JBIc+czuRAvNoyMrEzk4cZFOfqiagH8o64qdmdcEPyKg?=
 =?us-ascii?Q?AHLpu5FXMaIUG0V+NxJn6WMp8i9UWHnDDxYEToQ4pwKcyGOdML3+J9/4RZwh?=
 =?us-ascii?Q?vKAkI1LcWKa7EGwLzs61MuKUY8DvFQCFfc/CyDrkcZ+nmF9ZzFfICH9YYMP2?=
 =?us-ascii?Q?N0qGLkEbHoT4R6Ygjzu9Vxop7FqZRAFfa73b2WaAFt6gPOUmPMKoChMuaOcl?=
 =?us-ascii?Q?a+rI+6x/uViehvqI7xd8xWC/JYCKA73Dke4toun8Vvrlv71A/u2l5PpF4+5b?=
 =?us-ascii?Q?99UjrUXMD2CLTo93Y6VvHAiIVuccjNidAUa/bn6rY8dMTMUlt84vlhU9eCjV?=
 =?us-ascii?Q?YUrNHFoI9KRXo+PNvsGzcOn+PB6LQnYsClxap8dkTvRrAVyjW4ES/2gaYcOF?=
 =?us-ascii?Q?oHDWJXvGEsBfn2cHFBfWV94+he/FmNlg3hERP/eSQgkHP42aENeGn/49GtpD?=
 =?us-ascii?Q?aJoMypJcKABSKoVmO8Qny25QCldq3VrQFohubW7EtPuLRj7UC5YAixBSAceP?=
 =?us-ascii?Q?HjTMcvroC784QPi2PJOxxeUgYpFUNQuqe5QLxCgF+dAa1W/40TQiMj6X4oNY?=
 =?us-ascii?Q?Xau9UddGnxwhaq/ldFH+twXmIpYmQBRIhrknWoHIydS/wUABpS33Kw4eCAA0?=
 =?us-ascii?Q?Vv+KyGZQ8NVzYtyYDbzCqygdcLOmBhePZblqUKGzk3kRsXuDxUIEjiNLZyna?=
 =?us-ascii?Q?h4eJV2ui6DmbFekAu679+tLojBnbHJ+u7Z28vuAsdylykjpbNoobxTweKdzr?=
 =?us-ascii?Q?ZczVsgJt5zrtewvT3s9TToROmBj11ZAhY90CectyDsC1aagza/iDDuxTGITf?=
 =?us-ascii?Q?LpopDrsn2xkkiH4JmPxxPTZsmtsebU+7TyJDdn4kafqkoGVmkg4ARSngYtni?=
 =?us-ascii?Q?F5EBOziH/6u0ApEJkFT6PVCcNdiKBuASTPkXf8CuH9qFNh+MBayhFRN9AIoh?=
 =?us-ascii?Q?2iTfJRK5iCy4voep8xb8xjr893xBcqU04cIhb5WGaDxfDhjOJm1JYuqu2kp0?=
 =?us-ascii?Q?enJ6EOXCo9MEmYHYLJhPETBwClZUyZbw5BDQac8yMgoM1K9MmaxLxWC1cGp8?=
 =?us-ascii?Q?nZVSUOyKyKU95CGMpP+NTi/co0PhhpBq9+XvLpkkRneniktm3TFKWiX6aexA?=
 =?us-ascii?Q?kH+MPlRGWrVhlwsrceKKaS+YkD86PRblp2WVZLAPLoMup5WCf5xM4cTEYJoe?=
 =?us-ascii?Q?ayxw1CY+t5FAw1m3nTF+EvSIgJvtvm2H89gRYd/7gqQ2TIwV82upRXMfgxA7?=
 =?us-ascii?Q?1qpmeCmeUWZo9xNdiQLk03EZvhyNv4q9MzS07gHIqcb7JEEUAPkFZmlc35tw?=
 =?us-ascii?Q?fwUwjXY1jpGewo0GoUewTgi+GR6hb55lXQaB0d67NXN1IZ/8ZMd9Ock/I2ZD?=
 =?us-ascii?Q?sPKhZUZXIiqRC3Jf3ypsHSsziPmv2TxiSTo04A7TUqX2NLfHSIxfMXko7Jb0?=
 =?us-ascii?Q?s2887Q7y2TYVt+fE6Fx2gk0iYbc61dMn29LkGyOdVTcLH5aHRR6cjtmIQoAd?=
 =?us-ascii?Q?i90c5w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0fb0ad-3001-44f7-7c24-08db2ecf8b0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 14:28:33.0134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+fkZGm9MW23Ycpacjvt2YIBWi+hq8yN6wGNnDuCmz0qg1fTLx8ngnK+iPvVKdsFazrces1oAh4VQJkQQYxxK8MC9ZGAtJKiv6jul7lgWnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5545
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 11:36:06AM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> An encap match corresponds to an entry in the exact-match Outer Rule
>  table; the lookup response includes the encap type (protocol) allowing
>  the hardware to continue parsing into the inner headers.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v3: use enum for tun_type field (Simon)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

