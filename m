Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9576C5127
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCVQsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCVQsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:48:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2095.outbound.protection.outlook.com [40.107.243.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BFD24BE4;
        Wed, 22 Mar 2023 09:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2856J7yQSmI5LnK0bzg+3RJ1AFtv+2mcug11Wws6fQD2+54+KV64T/C+onbaOQSk2D0NH0oJ67MDaP1ufzAB/lpSbqVSoQdm3uL/tPJjecMqfriaT0lPNE+FPya1vSHA6myWda7THJWsDH57Zxz8lQY5CVsJ+I7K0PIhpSwIiWF7JlU0to4i79ku9+QGXO5HTjooDWxjVrmy6ctUwRmnLuEBPDBmCa+dNQh6xClP5DV5/sFxlODQkVve3pvZdmH22AI0GL8rBPI2fwfHeSgU3avFtjOwSArIYgIUbVPggxDRfkw58rkpwweYudreCKsiKXOwSkjVRCOaX9g+lIDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9M/kQDHPYkkY2bShdlGfEi0owLQef8OkYn5LpF9pOQ4=;
 b=cAGW4D/rudvg/6ETQdc022Yj0bnhxpiEn1+Ps4mGpEV3KNr5fK8bfISB6vphqboKrgufve0lBlhQ12BC8namKBytGGCHhCzrx4W/+tNv6NKh7HUkpT26w3BwEZTBSi2ysJKNifjhyOm3sWwmxwuaxEi430wqVue8VT343bzCpKlW2/MEb87pLWBWQYTaH603XrKGURQ1GesoeAsEub9ehxwvzKDHWCI57IXbCAp5JN8yQYe/HJkKcsF6KbDtBcWLp+gNACEv3dg9JthY0voUmYN7Br2kFxX+3C33PtPHEap1/6KO1iNIpRZ8PoRdTOo4qIz9coL5iGz3lw2HvQJeBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9M/kQDHPYkkY2bShdlGfEi0owLQef8OkYn5LpF9pOQ4=;
 b=tv21imxKf5JO0Qa0x0VO/EdvIzuYbw0nXiCCrRtyaI8YMstngYNSa7YgQKfRXncM0wg5H/U2W2WZpHkS8vnr30tmAmYLQ2/dqWA9K2ZBKyCOuZ25oc8NPs40ueFevZXAm+Y0ryfCcwvDxZ3rDwPpz6gBE67rjF9Sw7de0HDHGBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5406.namprd13.prod.outlook.com (2603:10b6:510:126::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:48:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:48:30 +0000
Date:   Wed, 22 Mar 2023 17:48:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] liquidio: remove unused IQ_INSTR_MODE_64B function
Message-ID: <ZBsxV0pHfG3Xh5qh@corigine.com>
References: <20230321184811.1827306-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321184811.1827306-1-trix@redhat.com>
X-ClientProxiedBy: AS4P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5406:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1699c3-50b8-454c-cc15-08db2af543ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3GvqTUlkDYWj0yjRiH7xs5YCBRWDi0elIjzqSKYLW/ZRTef77LrIJIWYuCZRE4ymvGTwdzDyRgQULRhJG0V12Ztdhg0KeFtZoG4iZd7s/9b2HZawo8lY8/u2FXDu4W298cbjXjHka7Uoaw9+m51febSXyLSc68/uPwUFd6XOHbguEdOSKAMhnb7g/Hny0LcjiMSSclpQEilv4WA53/wogGWzvQptJXtCtjhXgec1LkJp15GWWl232kD+7RgV0orJPHdd/H7WlP4qsK5lCFL+dY9e3ymsUCk7i3ZfagvSnma1LtI5gkG6KFAzeo6TfrOY9v0W0pxjB40Hyj5JlbCl48uGe+Wd4dIWC4MrCvUVI+FMkWZnUzpKjruju/j2QtlyrymeVGoTWSkpayODZmo70OYBUSst1jCK4nTxSCHAX0XlIbDJNqOtVYRZqty0+2u5lVH0nzjPAWNnuM6k72nO050rkoPPrF5hpotH2hJLoMzMaYOeuVGoSCVeNe6UhopKJzOr9QoS4rEaTPHQlf/554npX/ppsnQEtrqxWFomLdTyiQZ7owOUQfQ6rxDXFY+24kAV9T3GTgukaxl47Q0kik0RgbON7ryKCnya7LM7K7ats5LRKNNjo/n5L0pDlO7oj8hgztp8PCcjtIZY5Tl8tn2QMZxHoWZHOWiNOLFXBRnY+lhTwomCvGBLCUJjx7rV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(396003)(376002)(366004)(346002)(451199018)(83380400001)(2616005)(316002)(6506007)(6512007)(6486002)(7416002)(5660300002)(6916009)(6666004)(478600001)(186003)(44832011)(38100700002)(4326008)(86362001)(66556008)(2906002)(8676002)(66946007)(66476007)(36756003)(4744005)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NkOGVCbinRpwWgN2U5BKTUvsArW4yxSGwWo6yQShjSRaA6HmJpgFoti15OaZ?=
 =?us-ascii?Q?68vuksfHmHgyIbRdtUkNCF0sdyt7WWBsxKOulhx/8iNNPBdxgQpmkWY5lUBs?=
 =?us-ascii?Q?n6KfP7fDCvYQNeyskwblLdFWkjOx2K5h+rYBMO+xLdJfBv+ouIjfmv7ca3XU?=
 =?us-ascii?Q?n8S1GIqaLbdX3gNmnf/jxfNMxwKBVczz6LmmYeXXIVoubiVrQqCtyNFsLLPU?=
 =?us-ascii?Q?gmgG9ryykpbRKKmt7rQiBh0Dxy99qohTvkAM2x8219pUoamQN8Cwpx35VWr1?=
 =?us-ascii?Q?BkjL4D84LGV/7PFJfCzSJtioMKMaqM654crvj1r3YURPt38f31hhAZe1bazO?=
 =?us-ascii?Q?71MAipc48m0h1Ycsx+Q1S8VIy/rhzcPQ0dBF4mAav9iAQtuzUrzoMV+zd/ew?=
 =?us-ascii?Q?yViK70YRKhpBeZhC8KC1z0RUwmCIux5ObVKgVbdey82JHZb142WGi8rbaeTT?=
 =?us-ascii?Q?Ibz1GXWa/MHzfoRZ4l9vTbXb8tHdyW4ndj8V4M+8pOmNltoGk2nSAc/GuHf+?=
 =?us-ascii?Q?XYikOBZMJARxdDxP0g+1ZO6Jb4K/015cEs8z3f9sNzXF4EVsup/Ct5Rwk/8u?=
 =?us-ascii?Q?AS43GdT/ZCKujg+j//LLYm2yQ0j3bvCoGQVsF/GIp/4wTNSdlgRr8w/yHOj7?=
 =?us-ascii?Q?x0WBFjepOedMJleu11EnT594U+GLi649+HVOf3CVIzBGQ22fqiFGFbtAOjEF?=
 =?us-ascii?Q?zH/rZIvh3h7IgwVeYRn4Qvqc5ds2FU/xuKRL2e2WL53hvwiL3TyQvWk6Zbcp?=
 =?us-ascii?Q?zMwZF2juPwCQLuwbKtwXJVi0vhzqBqNiMozv2WqIxWnPPZ++GG7FgkLH6CeZ?=
 =?us-ascii?Q?cg9oR3AtiU9NCn9yQLMJ/IXY4hgdYbci0DzKMB1wodDADDzLopNThE7yOi/k?=
 =?us-ascii?Q?IUeIFMb4anVmqeKDCfI3jbzE7W8GIvZdHf54XcA8U+uz8PjDFTKtrCJe1ObR?=
 =?us-ascii?Q?UlDtXTMoMobUCPxskCC4g/FOsXfJ8mLzqfE4TGCeu2jVALGkK2ux4ACgUIzj?=
 =?us-ascii?Q?Gf2okQwPDioQgvruWU4CC/D7mOPIMG9GMbJrPMncX1DChemD1l4+QBPYvIIE?=
 =?us-ascii?Q?aYlV9uVfmesCtD9m9pp7vbug9vLxweHhsCE5QZpulfAYneHxCQiI6jNLXe1J?=
 =?us-ascii?Q?VWt2+q2saR97l3pxn9CQ4gJ9Eu0xHEws8DRTT1VNCiHSyt2aiZm0aRJMxAXh?=
 =?us-ascii?Q?YgpFXBC8UVKwt6iZ4GtN9X3D6gxhf7tVX7aLUWS9JlUZIOLy/hX3On/OcpIp?=
 =?us-ascii?Q?tXd7DjX9ccXRFxpe+4S5CwsG3ZGY9axyZoQ+vjnRJLGzFXBFLyb8KxOz2sFh?=
 =?us-ascii?Q?pOL48y9uNJsIkvyZx+lZRZiIut+wOn1wdlnoN8Mm+LDgzIdpQYAPRZMlUhHL?=
 =?us-ascii?Q?nEF8PlaOumKMSzkpCMdeSra12ZcMB5phxVWFgNbj1K8mofTYoAAGqyECYWOf?=
 =?us-ascii?Q?MfGANMEvM5/EfVAgMn4sbxBj5GjXsvbereOhnr9KB8SgMnhwHzYq4xGeADg8?=
 =?us-ascii?Q?LDc0Jr42GTkUzoDgKJCfOQfRP0CBxZTXi64ZzLO/deYSBlXywytoPes0yz9D?=
 =?us-ascii?Q?4H61K6UZwIoVw57ywz5WaNGi3nvREtfC2lkMBZopasggiihWJkuq5AIPfLfW?=
 =?us-ascii?Q?uEYRJra+KR1CSnRH7Dojw/iG1EsTXe+xssX8rKy31wGyTZEeU8CqH42M6pkM?=
 =?us-ascii?Q?y5e6TQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1699c3-50b8-454c-cc15-08db2af543ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:48:29.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhbXDmwWmE118m0Mk47wOTQ4OpHdLPnbSoNJXx2VyTjWNzolNJFPIy1sJ660yrQ53iJ+9Vek/ybN/1xEz8YRcXRm4CgAkXXqMlBS6VVboKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5406
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:48:11PM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/ethernet/cavium/liquidio/request_manager.c:43:19: error:
>   unused function 'IQ_INSTR_MODE_64B' [-Werror,-Wunused-function]
> static inline int IQ_INSTR_MODE_64B(struct octeon_device *oct, int iq_no)
>                   ^
> This function and its macro wrapper are not used, so remove them.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

