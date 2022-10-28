Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D553C611BFB
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJ1U5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 16:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiJ1U5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 16:57:41 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021020.outbound.protection.outlook.com [52.101.52.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6B6241B02;
        Fri, 28 Oct 2022 13:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaNraUbMwZmYPx6/pcjX4fgzYOvqPGJKIQza9Cv6TT4foCMWpaV8C0Y7JfVZmPM64PHhicDd7Ipx4dFJU0PpBVkaQj2QNdFYrfFwH16xOc6Uv+JvSA2ckg/dW7FsjlBL57o/RrjHxjYTYyBth6Fl3NoKGnMMMymVm4lZbYAUkwEOLiPbauSmU8hJIW76U2O4GMl/lZa+VHxSyxFiMJctE9N6xxBhKsAWZNauRr0vyoYVNG8d/SoegCd4vKbmfnDI66kIOBD1qaSMjPBQtqimgCWK0+0u4pgPybThkFGxp+YdN53aZ52EGUerIV2d19hX3jU7JwzUbtLxmr9g1fuWTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/HcIQanv8L7Cl7QbISriEDg7fjwNLZJqIuQOnDchz8=;
 b=D73ZoUnU2Jr9uxuV4cFH20g/XA2+idumttmwV6LPAlqYIOnjn+RXtGYdJta7+iwB+6LrqgvLaUk4QmjyJ9G8RMgs2EcGMHfKqgS6f64oQxTLBCHL60tkUz4gFhhR2tAhe5xnZKT28eKO6xgH8a6H4qSJn4NFbpaZaP26O8kHM0qWsN0lf8/txUjtaZKhvLjcVgXCpGZ4MzK1Q8/r3KZ5NnFvNWUue4krbax43XKFE02phh0QW/dBGvL0jj6bsxibL+nIvgr0vzPa+TuiX1VSlEzXgY9jK2IIske0j12evy776Q6GRpLILCgS/mgaCsFQpXlZIdUWE3xiWk/t5c13yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/HcIQanv8L7Cl7QbISriEDg7fjwNLZJqIuQOnDchz8=;
 b=i3qL42UfrXylpBkbtkftkdhITvFOSGEFDnQsQ2UwKu1AC14iubtrMb+g+2hPhnXQVhUSTGAY23OVb0+6AcaiQw6zqUaLiebtGliseapOTZFjSIKuTLwpzST8v6RvlzmrBE13ooL3oodpE5rqYLmXczZ+JLl88MvmZt1hxiOaLhc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH0PR21MB1912.namprd21.prod.outlook.com
 (2603:10b6:510:d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9; Fri, 28 Oct
 2022 20:57:24 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f%8]) with mapi id 15.20.5791.010; Fri, 28 Oct 2022
 20:57:24 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 0/2] vsock: remove an unused variable and fix infinite sleep
Date:   Fri, 28 Oct 2022 13:56:44 -0700
Message-Id: <20221028205646.28084-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH0PR21MB1912:EE_
X-MS-Office365-Filtering-Correlation-Id: b87d799c-be3b-44ca-5a3d-08dab927032a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ll6WwaKuHXfu22pvpGpflGE7p4Tu5N2C5BmSX4qOgLzBbzlcvLgUaKroqy7TmkBoQj4OvvK915l/1jKa3l17ZhHs8x4E2kSZ1iXYViCVuc3M9jS3YFqvESnMFjWD29R7YAVORRgDbNQHAfLnM4afPAShlk3/i6I1Bh2jMy8wnX9Zn80KYTtNCNIkM0TClbtUyXsVwOKfRf3IMtNwq+m2kEKwgNHFcvjapvndchzEI+8KL6zg3F+fn8sBTwNQMzijlozFSVTp8wrICMk97OCV1MC+muRfcqDVuhoNO1rlMlo3iRflFpDriloDs6uQ7ZJnCGDshd34l2WjrCntoEEQvbsNj+U1dz/Z7ue4tTBjITBFlmLu5yaEYzpeBgvqLoCduPDd72QxgEzoj2fgFGHQznKk2lp/CJQtWBpmij5FzR5RCj2ACRv5M6BOgeJrxADXpuDvjUOHKxR7DGlKdgjH741NTfk/e2knVhRmlTPMrn7Riysyk3sJ+qCOvbMAhLGqS/73klPijv9f73x2o0uymiE4COYJzkBVPvJbxj3tDTLFrHWVIZAqS+kotenWpMt+qC36jkdU3wK7dJT9fMMNyFAJhp1Aij3I2XHhUqR6jqpvjnamRX4ElVQl0IrXnq+MStz6e47V0K+OJ38fYT4i8AQoca6tTdDzDI15L0zk8ZLQ5MbYmvEtHaL7yvHMS9fyswVkUJ7kVxUPSfHVt589YDdDjGFj/hHEepq3rQjVT5AkgAwPGckPDbnHOQLsBT03
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(6666004)(107886003)(52116002)(6506007)(82950400001)(8676002)(4326008)(7416002)(2906002)(3450700001)(66556008)(5660300002)(82960400001)(38100700002)(1076003)(41300700001)(86362001)(6512007)(66476007)(66946007)(316002)(36756003)(2616005)(186003)(83380400001)(6486002)(10290500003)(4744005)(478600001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTq2IjoTVgLL2Kns96PQQYBq/TtqCL5FSVbtnubFwci49DzrCJr82e2tGV2s?=
 =?us-ascii?Q?CQxuHZCOzhCb50YdNiuVfugO+V8VCchWzq6dFOY4T14rFWPBkgZkZKg4vMqu?=
 =?us-ascii?Q?XkDkScHpnspsSI1t2WSDBwx9hCoVFQxxYECbORT6jOCTpXU8tCDm28GvIeEa?=
 =?us-ascii?Q?tJOQjpuHMLbePQCWyX1YX32sXswgnsHIYFHKDiCkwcWPH4cUni5KqaC+WM3m?=
 =?us-ascii?Q?uWL/faw7XC+3V7oc61abwrGDLvvxG5CyQo7SW7xxkDlaeLsAfb0pqF7hdZW9?=
 =?us-ascii?Q?VUel/KCsm32dW1YWt0x5VRoaV3MCk4cixnzXjcB90MWJmmzrHCyWtE5a18Z1?=
 =?us-ascii?Q?2AUR8eslx+PWClD6zqiG5nMfgj9/kIjDlFWqK33nfK4D19VamgDSLTUKtCoE?=
 =?us-ascii?Q?9t/Azg/j0bBK0Yt6sClz2AWJNPJSLxhLmqPiUjhj41ZUo2M9z25891bBV4TK?=
 =?us-ascii?Q?dkjeS/oHyDdSHjXHfAHmyHLolwhAGaZyVOYb/KRB230/IdsRRQUGdcaIVjwo?=
 =?us-ascii?Q?yWsJcDEyIW2sWuySqX/j0HBf8AL33HwvPE/lgVuLE3zZ/D/UEamRkmdJ5AcO?=
 =?us-ascii?Q?3JSMwvQQLLA+I3pigiQ8ECO/yoms8qjkTxk8McJ+6uQjvQNCecJCsc59ovM0?=
 =?us-ascii?Q?5rdRmCdeZOaNa0Ohd92I5gCtl/EtrmDPEg/zSa68o6SQNZcdThdQD02WrQgQ?=
 =?us-ascii?Q?y7qsNbs5xhWQaYo8TVVaDxUE9IPSAEk7SqMSjilu9Otz3TIXeKbiJdoYnBT1?=
 =?us-ascii?Q?Cwi5td4OcC56a0BPI9YGqSdDyMnpSG4WJglwEd52g4q6vf0E9bQRsE9CM5gT?=
 =?us-ascii?Q?vtK19SFdRyN1WgwsgOlOVVrdVNGJIaSjVbU+0m98BCidTsQ4rWIuqSRhQ0oI?=
 =?us-ascii?Q?mbNPbUm8B6ZV+GAZlmTveo2hNGxcXWjQWt9aWdmy/mp30oOMmywU3rYL/7lL?=
 =?us-ascii?Q?AiKHXit1rqmOgtnUjyQEt+8f1iCMxWtQ3LjCTqrwnAoyHojkC9xqm8bQHrsv?=
 =?us-ascii?Q?m2lHLDTDvI3IZgjAnUUVdWkDWkavmpvX1o1wkNkU4+7XerXWiqJ86Qa4utXA?=
 =?us-ascii?Q?6zsNuOQtOkEFR7J3efecqkE1WPFKtxoQJTFETkxAXoBe584KW8lTy0/gZoEZ?=
 =?us-ascii?Q?l4N/IyVB58b2LnemFsnP9dDgNhd06GfxuZ4BpnOAJbv3AakNEWHj6/YaQQdc?=
 =?us-ascii?Q?DIynO9rC+qP9Y6I0oxDMTS3gFVMSUhm2dn5qVHgnvfSZ6iQV+Fwal4WVJD10?=
 =?us-ascii?Q?vEgdH+1lMuMBjmoHxYOg5KWsfCrX5r9qcuHMtDHjE5KR3aiIpGhTIdBkmBDG?=
 =?us-ascii?Q?3sq50a8LUoAss76zv314R6qhscWlCv9KbcUg3jrXILWY4qD11kZ/UpNiXSk5?=
 =?us-ascii?Q?AS/xCREmR3ikzng0+KL23R2LtmJNLGG1ADOMSTQ8uvYtjX2Vz0fWySP84evh?=
 =?us-ascii?Q?tRg7AsKJg+pY7t8XBqgP0QkvVQ1MHG3xnFBe+0boJSipz+UVK9cgx7REKGiy?=
 =?us-ascii?Q?la2XFPT9RFDdvAF3vvz6w/EEm0HXNOKdnVWxreYg9JNn7e9WEpz5fdjWr15f?=
 =?us-ascii?Q?X7DJiOcLx/or3fJ4+6xFRwJ7NFjdBEgLGHclfMjpUt6W1kwiavjSM7zhUWjG?=
 =?us-ascii?Q?Qu1rctGOBhDojnPO8wQMZXOjC6xs+CtF2cu42r44Qdl9?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87d799c-be3b-44ca-5a3d-08dab927032a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 20:57:23.8548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFpojuZLdVKtmMuyFQbet+EX5sYgfyARxlh3o75RMom97QGiPicxnzljZ4+VjvCMwZXpzExW6W7/ucQkR1o+7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1912
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 removes the unused 'wait' variable.
Patch 2 fixes an infinite sleep issue reported by a hv_sock user.

Dexuan Cui (2):
  vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
  vsock: fix possible infinite sleep in vsock_connectible_wait_data()

 net/vmw_vsock/af_vsock.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.25.1

