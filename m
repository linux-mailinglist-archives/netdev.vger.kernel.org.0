Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91CB67FE37
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjA2Kch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjA2Kcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:32:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F8420D36;
        Sun, 29 Jan 2023 02:32:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ly2Ck5vxDvpkjasHuyKdr6zcgtV5x9wIwif5f2kx3FaheythnyFvAyr0HDLVJaS1OMz5FfHOnQfi6WOmt+oFGr24oMphW7GLySjjPK4+nVc9Jy1CmFluNUcPHS8QptuhaLfO72p6CkL+wGjylmPY4mKfhoKCxj9/nKBBuaS9Ww5/oYLqPzKEueK94GSLo0wq0TMzkbQA2eb4tI63oPymh2OE0t7mzBwU0PBQDYuUBizE1iOIoYjrPz04y0jHBve0jnLSLl9WTl+pg12GmOYvK3Ydla7cZya9edIw40pfrO4decV8sX3To21j3o2LI6/n9n1ikeMzmb42UbnDHyu2fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mac0DdRp0cub4T8y3nadNmV7rfM32iu/O0dUq4Sn1Gg=;
 b=M4LqmhrvEXOa5rvjixqmzJ5t7kejoSZVuy3Fc0tKmcTkDtEQ3KbcQRLA2x85CGL3BTpTZYtriApAqtVuNKKuTgNisCJ0sp5n9xT2fQCit6KfAR/Ye1VJqcUYosjkbyw6bOl+GxiiKN9tVvh3SwOsJ/iWyk3Z/EaUheSB747tpJkF2HvbVMt2H+a8X3LbNI4maghItIoSmWjXu94rDGyBQrO4B91BrDov4r8rGBWaLViFlp0kc1HNt+z7z8kJWwBrg+dlW8NxXd3kmgvoh+wgFZjui2Qoxb9DBBOzuwY0U8SlbLBkaK4gDlVJKBBw7Gk9SoVP+tyFHbqe8wiXWZ4zmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mac0DdRp0cub4T8y3nadNmV7rfM32iu/O0dUq4Sn1Gg=;
 b=sDblZK4OqcKOpVsx7bMAgokYB/ZzS5+a7zQBb3eGZtX2mS2cOsZbWO1k0VcY/mjWLAO2i4gRzTKm9Pab7KK3BECuW/JDAVq27c2WRl0E4+xWyY7Lk3cvT8N7cY0HmfJ13U4PB78qObxmmvJD7GtmjBtdMDWhjRZVOfb/ujEd+Ms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3663.namprd13.prod.outlook.com (2603:10b6:208:1ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 10:32:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 10:32:33 +0000
Date:   Sun, 29 Jan 2023 11:32:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: convert sysfs snprintf and sprintf to
 sysfs_emit
Message-ID: <Y9ZKKlf+V03GnUyg@corigine.com>
References: <20230129091145.2837-1-liubo03@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129091145.2837-1-liubo03@inspur.com>
X-ClientProxiedBy: AM3PR05CA0120.eurprd05.prod.outlook.com
 (2603:10a6:207:2::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3663:EE_
X-MS-Office365-Filtering-Correlation-Id: 60a1d481-5427-4c07-b081-08db01e421a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nkyhy111Xzh3qoMTiOS/N2CcTuCo8n3B1d5G9S9Bx2Y8SVa9AHIgppZTN3AU4TUNBCWnyTfOyUxk5CP5pNUgBID6lz82uLtDHraxmYTP8qs6K2azW5mcvW9p+G0lZ0zI8+xPvE9JDPMHo4j4/bC+VWmuhHjaQaCEtqGkSbpE+Dh7fE7FFUx9oGXnzt0IWrdU+hmhDwJ1foWieGlejjdpwswijhbZjWf/nFt6h7OzHvjQlAQQOQorHW779QNcSX3uFDciF3ED0QWWgwEMmjV51999teb07Qrmy7J9xgRVXG+XcwNsseV3zh642yVKP486FDF5rGo6R0Fqg7vg4Ljpg1BMr8VagvDCDAjgWM5CK+KmeO25SlyWkrVtE2fN31nvXHpGMjIcZSvz3/gm4JGp39vp9xCqC+D+RMxE1LManFN4ybXa3ssGRw8hzqCzhtSQAveGh4oAXFeNzk3OVAv3VJx+3SPBcoO/5CFiBqIM7dBVtm6ot/nMGEpxsmz12Mt6KSPaL9ln7k5yNqZ9KpErSfrZ234qbgJBpKUrx+JFi7uundIg9wCGjFenYn5whjONzvrMeQPV0bBccUTQJ3Sde7CtM8TGe2cL7IEAI5KXsXhZqSnLWUGxRu+EpbHRp6mzNFRyxtgRPBj+AC0fzEppV78wMJL6OGKx3rG+tneQAJ+py+vuBvjl+fBYbhTXcfSc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(136003)(39830400003)(396003)(451199018)(38100700002)(86362001)(36756003)(2906002)(6666004)(478600001)(6486002)(8936002)(5660300002)(44832011)(316002)(66946007)(8676002)(6916009)(66476007)(66556008)(4326008)(4744005)(6512007)(186003)(6506007)(41300700001)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?//CZlluMHixZvY9jerFoqA+oe5qI3ugZe6J/zwE2+4pjGyIC3MR0Uvhi9yQJ?=
 =?us-ascii?Q?zpcxlY1O52ME2XRB+GK1V7iI1pytWlpovHcIjmwLo1DW32C4nN18UEJ531ii?=
 =?us-ascii?Q?aHwoYpB1BuVBz8XBlrIyPka95kgB0Z/KkRiBoOg+8aWR02Z8+vbx+0agH6iv?=
 =?us-ascii?Q?Byj7nOsLA7pAHWsibKBEha3gbgfSKxQAslHpqmr2jKn8qQK/sa67CsPTMaxP?=
 =?us-ascii?Q?SmB/n2KRdUkCSu1lvFLRY0GJDZumwLVltON51EOB4RV4OSqK23H/uZiXobsM?=
 =?us-ascii?Q?kH3FjD4BLas++0geEymYGo4/kRAGATwWkHoeK2e1dAvS5xA31Y1l9SAZDyJU?=
 =?us-ascii?Q?N/jCVmPSo9HAKx4fpgNvWvRvpeffe+dQz3QlrSpbPkeMPnOI3D2QJ9GQ/a0Z?=
 =?us-ascii?Q?PzgIyBZVwSpmYo8LFBjWJAtwn+OCkXCgwQTBdZbEnhyT+zLDc9ztgMEu57JE?=
 =?us-ascii?Q?CUwIQjVZjxwE1ctOkGSmL3U23MIm5xMRh2m/RTBxc/f3Oqkiz/QWoRHjcLOd?=
 =?us-ascii?Q?4OgFjIOSMy3sVDZsc3yA1xhRmU8BwEAOxVR6oZZVwksl0im2duvofAIZAWw4?=
 =?us-ascii?Q?Qz/KT98nIPzKSiy1BvpI54UxLqF50bnlmDktSSoblO8sqcNm5DkE5aRl4ZVG?=
 =?us-ascii?Q?y5I8AQgsPqu1wGa0++WebjMj1h7TQ2H/HI5pZi9zr2kqP6bvP50w8bkPOTta?=
 =?us-ascii?Q?8PsIjYMm+bCCoeRQMEKiJLDrW9y6RWiY0q9gNahNOfiyeNfRFR/TlmkXVl3M?=
 =?us-ascii?Q?IbXgjAVAUjWBgXsmcVMHjxdYuBngkZfMmhWTARh6agoUQ2UBtOrh+xKe8bGA?=
 =?us-ascii?Q?gQBRNGBiNO/LN467fkw5F5AUgkZeQjq0fRHqLZueU7Qse8aHppaevW7CR9NU?=
 =?us-ascii?Q?hBlowLoZYujanQaC3WZGot3fkdKJC1qTnPwdM5ZHYg4F/WdzZgKpCiDZbTzg?=
 =?us-ascii?Q?u94XhmOakAGGMZQNqYf5TGGKPmHZTIOrwkoqtfbT361dAqTQ0X1nXPa80gQQ?=
 =?us-ascii?Q?ddv0CzhpnKITki1ShAGE9J+/qoi2AwLV3+OA7KOs2MLSthntgMOUmf8Q/hLB?=
 =?us-ascii?Q?M4YeS3Us4ltS1QjcAwfWcWNSZYCe86BtnYTiNVbIyhgKzFd2ulhsSX+RVetr?=
 =?us-ascii?Q?0n24MSbqHG8jjuuQK9F0RFZktbtTVItRAbumLQ5V8whhNpeUQjm7KLOTpQei?=
 =?us-ascii?Q?BNtTlGQPxKDOvsYeFtLh8wOjdKD/R3jhPynR6aTiOd+oCTinwcAit2tBqzNM?=
 =?us-ascii?Q?Tr/bWROtXcqHqcMPC4yoW0iwpvWMDFdoNSlUrmdbQJYFBPjWTPzEAPhu6Frx?=
 =?us-ascii?Q?uD/N8jostDxnRwjAVwTK4Wrb5ZiC1R8VeYx4qW2lCBgfYFvVhk357DbMiZrZ?=
 =?us-ascii?Q?45v1kCN3FDLECSufg6wfu7t4KcAiNY17E0sOGCJNP6uTjm3EythIP9SLhaVc?=
 =?us-ascii?Q?lZ2gZ2ynwQ5gI+qK+6+EDKQ7+x6CrY+urQCaoS94ZzEHSn+xqw4Egf0mWVbB?=
 =?us-ascii?Q?ucu+c48UtQFjEi/W+o21OmvBwWbP4AHv+fS+9OMlLYbzNHaE4j/cIioyrXn8?=
 =?us-ascii?Q?0Y1d55+ULQCTxo9t3gXrVega6zHsV7LS3Pk1a5Q0hQr/IHSAIHN8RAVpOWoP?=
 =?us-ascii?Q?qzpp/5f7SbGDIkqsVL4uiYwsLE+yzMTwckQFCUjhEXUmCQUWc6zXZ0a0pxPo?=
 =?us-ascii?Q?VbvUsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a1d481-5427-4c07-b081-08db01e421a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 10:32:33.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TrrFCVoSaGm+sNtrY9BBLssh1K2dMLwGS5jHQIj8epz2QHTX8lVrtOYlK2pQLMTnBRC+VNcz6IH0Sno9R1LivwNBBvmE90iO1bpPVCjeSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3663
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 04:11:45AM -0500, Bo Liu wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst
> and show() should only use sysfs_emit() or sysfs_emit_at()
> when formatting the value to be returned to user space.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>

FWIIW,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

