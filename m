Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4626AC461
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCFPGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCFPGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:06:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2131.outbound.protection.outlook.com [40.107.244.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F452596D;
        Mon,  6 Mar 2023 07:06:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bp4AyDJfomfbJ0xMKjW2SyS1reRyz1F2YP7FZDqF46emEFflsfSfHs4i40YklHPHj2c1jqczMMs6yHllo0JVamEaXOBzhdKAMoCqmUcaQ2rRT3PMHfyMvgn02AHWUpvjSksa/F8gzOzh6wLpD/42wWJI7xdvUBhunjqDa3gtv8JTTfC2OXf+nQUCKPKNX5cA1fbq03ea1UVdLlSc63O7vDL5RyGBsKxpkOIyT34CjXZxi/Nat9TuF+0quwd7u/V/ZFx6773aNNt8PM22ZK644BXn/TkMuqSdinQcs7ZxD7O9qnTfLNjXBPLGvlxFH7fTFN1qvpXw/V6Qo/2Tawu0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDBq5DQeMmhOGhsIcCAcwPa7lI1TsqWXEQG2LhxILNQ=;
 b=GBCECGotlCk8hHuBigfkeHbARHihWr6lQbdka50u5dR7pXjZReGPXnozb5u520IEZVkdQh5i2M5MocIuBZ4f6br2nXTTk9+GryiaPHo6PxYN0IToQM2O7Y2N0bv9u5DrNM20lR1oUUo8g4qjMri/5TDUTbe8vdx/UBlZiCIaFBPThuNF5KzYjxGmMsIBhRiHPwjSTAQI6FTmcerREvQE/aPLJfUDNiT6Yd33U3zBqkIo5aiP7vCjZN9B05/rm9xTGvEx3zGWg57KKcj4wTesAgY3aGX7UvtSG8uFUMsh6NdfWmWnIPDjPZgt/inXFge40PZ8PqmpaM+L7IGWvrEZKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDBq5DQeMmhOGhsIcCAcwPa7lI1TsqWXEQG2LhxILNQ=;
 b=qh6BoprwszgFzBqnu0ZrlM0N6eZl0GYefgwqyS19zMt8BsjIP021uFMcB4h9qj9V/g4QSWXD0YhSxt+4e5sVEPMjR4wkTLLXZI6UfV5kMwHFblVdq0B3KYH5zt7o5aujBll9rGjUf+0Vdt3brM5y6fqLxOYHi8P13XJjWnWU2NQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 15:06:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 15:06:27 +0000
Date:   Mon, 6 Mar 2023 16:06:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH RESEND net-next v4 4/4] net/mlx5e: TC, Add support for
 VxLAN GBP encap/decap flows offload
Message-ID: <ZAYBbP8HCXf/DHdn@corigine.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <20230306030302.224414-5-gavinl@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306030302.224414-5-gavinl@nvidia.com>
X-ClientProxiedBy: AM9P193CA0028.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: 362e351a-548e-46ea-8436-08db1e545bfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nn+kcP017d59z/Ce+sv9sYm3q38OP8u/P1ywoPUnoUwu8XuR1tGy7t93QHCDXuIdeRJjz2NhaAERPH30hYV3BybSyqzps4iqBigpU4dL5ahgQ4x6QyIwam+mGJGTTwOCyv5vmtC3JUUq8W6HhpFq3/Iu8MUoHSyW9a7hrCb5I6sLmESOAooYkYP5jxLiBK/N30CVuYY2PFD+xSl52FxnduG8lMOOQ5UsF97BkQ/8JMFDI9/8VebEzXErOgKuSGfBA7qUK8ekTe52dmP+JkwCh0N5o5hMyY0I4rfW0ib3UHWz6eq9ykQUQTi9sv7jC+5yAq4EWIGxPLf7CeadDcS0XQZCGhHnQBANvG+vBVG1lpzCJRB87q5t7q9aJJ04yJy3TxezpCOIm20hA1Gga2dFi22z5en+btX+nCRdW0u66exwGG9RC0IkBf3WRmEhxVYIZ+B6z6AcwP7ZSqLPUjiPLKiHBFLLv7CvkeJ7Xy4nxpnMLOgPi9Myy0QMhDtg4pcNFtydrVGWXWH4zGiWmG2PKXujPG8VL/LRFfm+32ggS6KkKrKhzLmu06lFTcpO0r8jZHkmPN0mBX1EZAOMRxCM3/aVKvbFoDCPhaYYoA684frr4nPayK5llCduBv2CcevJQAi7KG27qyPJYJjCk8hu4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(346002)(136003)(39830400003)(451199018)(36756003)(6512007)(6666004)(6506007)(41300700001)(186003)(2616005)(5660300002)(6486002)(8936002)(66946007)(4326008)(2906002)(86362001)(8676002)(66556008)(6916009)(7416002)(44832011)(4744005)(66476007)(316002)(38100700002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iNN8T02gZh+JAxFR0p5WoV2rZzwoALEkDXy3G/aWESMj93ZYmFN5l+oobwhI?=
 =?us-ascii?Q?l6aznqaKfEz0Glj6XIVLRsT4zczFGUbdV2e7GDklORck2ffYG77zEj3IHqPk?=
 =?us-ascii?Q?vGJB4qxwwEhl+pyGQfZ+y+IYP1CEvS8u0Oh/ZDCub3sFGlA1kZTt//eV9Isf?=
 =?us-ascii?Q?mOEMp/Vsik3yCnXep51OMaxmGU2C+9R3C3+WmvQG0Rim8xU7d4tHGB5JmLp7?=
 =?us-ascii?Q?QHTFG/mor2s3xw+uutdWYLTQ4oKJqRzeo9i4DGb8S6tilFKPjqjX2fyRz50E?=
 =?us-ascii?Q?GACM4M7y6pOJ2DhJNgtdwqI04grTjQNe8108fRE0og6EAqf3lrJmlTekuG9Z?=
 =?us-ascii?Q?ifFV/dR+8H8xQCopbgreljbB/f8fjIlvD/R7eeL9LLjX1pojKNyaUgZRvwrd?=
 =?us-ascii?Q?TgErouFcUlVmd6HmjzwC6wWRnYh1hWOefQSdDBDFLDUEQjDMr/R3HbTv1jKE?=
 =?us-ascii?Q?vn3uN7rdw8do4wFRNLKkIDtz23Y+Kmkar+0iY/ECvv8lZ55t0Kh030iveOOf?=
 =?us-ascii?Q?F2SQ+ULdWzgeIAoYaJyevosw1tD2XiUzHrrMpExl3iSFjWGyKAUodJTqZXXq?=
 =?us-ascii?Q?on8Q1d8R7/BRIQQcjjcWRSJ7ie4lm++EiJRsAKYndFxQ8URgE/36iWWQuWnK?=
 =?us-ascii?Q?qhAkbaQcPIM0VCMz7BG3CDJeR+V1ZWQdqoPyauqQUBNkRZvhz6KMxeiBb0iT?=
 =?us-ascii?Q?AV+px2YNtoyqQSCiTXrN93VLk03CC+1DEgvl/zsr0pYfeW47NoA14U1qoLTZ?=
 =?us-ascii?Q?Nv2j1DdXy5kqeMMrR/6l1UJkynAhJGt+xVDs4FwOK4lmlwttCT3ipnrM1jWO?=
 =?us-ascii?Q?fDC4Kc19imI9OP4qJu2IKP8hdfE6QQx4e1YKGu91Q6WnLuwVLBMmDCWj1s8O?=
 =?us-ascii?Q?6+wI0ZUeAkV+7VpszRUqXKwlZW8o8xcT4y8Kb89jWhCpyoq5GFOpjan+HrVh?=
 =?us-ascii?Q?2jtGDDJQm+Q/wIDfbFZy6VkjyDlJsIA7ibS5g9r5p0TlesuXatx5rSjg9x1W?=
 =?us-ascii?Q?sbGWMYXmSQKWqWDxYvBDEo4/aoldiQd3wziD2U5zFAPMYyBK7nKCjlrq5w9D?=
 =?us-ascii?Q?H+QlATMfp0AmvHkdEMCeqpwrdfWJ72w/FjsjCvmrlNTmwlHo0dcdyLqP1tJK?=
 =?us-ascii?Q?wujfCJmJzfexdDNLt33KEHT5Sk8ZFynEUsrTYsA5m7IEASvqQ4J2ig5PxeR7?=
 =?us-ascii?Q?7STBrq1M+51QJ8HEf8OnXHsMfFCpYYgcySMjcMbO15Wmtm/VD/MVCU/NtE1x?=
 =?us-ascii?Q?TZ26Mlu4ry0MxnihdiCGN8nyBXGSkZkQNsaPBCgkjDSqxHIjUuD3e3Dw/RDF?=
 =?us-ascii?Q?j42QsWPGxwmfl8ZFEJVsf8AHrBoDevKi2SlcZ/khXiDRz1jvNxcHwO6+77RR?=
 =?us-ascii?Q?jtaB3lf39HsIFjpvDVTIi21FuZiBeqacmJkoSBXKyNuI9V8xMOUcPBl2CRi2?=
 =?us-ascii?Q?XVG6JakL+yEFviNwNgKsMpU5dD6j65l3zbEMFXfv/N/6eaE8zj2KYcRDoXYn?=
 =?us-ascii?Q?ZEoKLwLrmkdpq6RBdaZPZPLNHgifNHyHw0rfBdoqFwreycfW26GxufnNQR8f?=
 =?us-ascii?Q?gUu7O1Z2tfSsNWh5WnA5rjEFXs79ZCnSw7PzfM6/PHRTKxjadZI0FLOqXZip?=
 =?us-ascii?Q?RTtL8DitdTGKWvZ5OocmOxqkjdiLsHLzmVJHzQWwKb8tkHOOMf0GyYUuLuqj?=
 =?us-ascii?Q?TCnr8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362e351a-548e-46ea-8436-08db1e545bfb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 15:06:27.4384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iK0wO2T3s+dFV55TZDlbXUMYM7KZv8XhS4xTF7BIqaxIzkopR1ty7I/aXyC/xtLbSfGRuh+l5y5D43DoMx6k5cKx0YqjSFxCMPsgA6EkNm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 05:03:02AM +0200, Gavin Li wrote:
> Add HW offloading support for TC flows with VxLAN GBP encap/decap.
> 
> Example of encap rule:
> tc filter add dev eth0 protocol ip ingress flower \
>     action tunnel_key set id 42 vxlan_opts 512 \
>     action mirred egress redirect dev vxlan1
> 
> Example of decap rule:
> tc filter add dev vxlan1 protocol ip ingress flower \
>     enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
>     action tunnel_key unset action mirred egress redirect dev eth0
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

FWIIW, I did provide a Reviewed-by tag for the other patches in this
series, but I don't believe I did for this patch..
