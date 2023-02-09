Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A70169078F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjBILhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjBILhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:37:09 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20707.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::707])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E7E64DAB;
        Thu,  9 Feb 2023 03:26:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxrT4lIN7AIZFW3r5Ju86jXsu1UoibC5geHRBS/FMISzCdUwNHHAFdF/6t0L/TXYN7fq6PzPfmUY9RXTAamJUiwE14mVkvL6jkh44+qG3VJc6byR6rr9SOmErY779YuhQXuOwxh7I/s8AGOpvbI8HUzxbRgRMCKMarx33JKX/JsVeTiKj12wjz4QT6sCntFkr2cyU99714w5WhUuLS5BEMld9DHmkvAYBfoV4g59GvlP1XomQ5T4lVYyUsdGxu8eqTYmxYc+CTYlevApOQxtiur3U9In3iSlABy9MKfu4CMp6b+LlLOVq87o/T4uIOtltOm3ZLvTIzxO+v2o4V2VRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5c3W310Xxobm0mUzOkU9QAVbgfKiYNqusKjwAYJh8ns=;
 b=Rd58O+CIFKmcpigj4szZAzDnXLCMwb27haEW9fZvZ/liFyrRMr6iO57ccNf4yxGFKpUkigLfOvKi3CYGkQxmv6is5CslLsKs8jyoPMjCm6FmSXQ+U7RXeqOWQ+RS7uh6eW5VQyfiyLvYSTE1By5iw6UCViww8KSJLdGNaZktoxoET0vDPjIMi/VrLGNxaOGb+FARCtcNLmm0VxwcAAoMb2Lw1TdYYsk48bml0Ed+TkszyBZHtsgcx2RUCaQb+/re9H6n1lzDTVVrZDVQxruw/8eoMmEPGmH10tZhxsp92DCOqzHevQKDc3zRQUVxGnc8j81HRYjwNnZGR4c0uAt7pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5c3W310Xxobm0mUzOkU9QAVbgfKiYNqusKjwAYJh8ns=;
 b=olNoFVrV4eYrdYmtYzLLxsFFNSi4nAaWAUbRbxICEC+lv9LiVML3E6i3+xHq3FVIVMhO5+fs0SOP0tfTyD7TXITxWctN8SSUBBtkcbG06l/j8UnjECLK9mHerzQ0ACxFwft0pKupTdqHS/5100ZsYZC0Ef0Fc4EiNS7VP7f/QjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.18; Thu, 9 Feb
 2023 11:24:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 11:24:17 +0000
Date:   Thu, 9 Feb 2023 12:24:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: Re: [PATCH net-next v2 2/4] s390/qeth: Use constant for IP address
 buffers
Message-ID: <Y+TX2zhWgzlsnbtn@corigine.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
 <20230209110424.1707501-3-wintera@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209110424.1707501-3-wintera@linux.ibm.com>
X-ClientProxiedBy: AM0PR04CA0079.eurprd04.prod.outlook.com
 (2603:10a6:208:be::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4876:EE_
X-MS-Office365-Filtering-Correlation-Id: d79d254f-b8e7-43f5-c98b-08db0a902e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rwps6TfS73clupnq/ChViA6P1N6+boDL/8Vy+An+jt9vdtL1eUg6+rd8j/XuuYwBdw5cGPrYTe3vJJkcSrd3EbzXf3vWwEUlIPtpTibg01hDTCMTFw/AxBDBUOr9xBjmppYWWAZOGjWceTIcmaaGX8bGOYsUKQ1Mfwt7/mojrL5vsk4l53d5YiIl9dOwXlk6+V2NTwwwSQv2l8tJj1RnbUQXQDgauvQfWbp35exXPO3zlNl64MuXaXrqE1Wk4u9mmYJ4HQkJ+rZ7O8xE4KiHgu3/wY2xwfi1bjPMjdDXvTLmv80u7By8sE9RPTM5vMU4uRJb5NSmCOKM+1YjzD4tGNKs6QShO4FDEOI17Hu0Bh6+4NHUk5tLO2nuyIfedJARrkscAo4HuIDFj/hruEdjr2g+xJJpuo+rWpPmqQv1QQHH+qieb4WrKFH3GoS4ZWc1QXj+E5c07/Nv8M6L6DulSJjhQzZfZkMJqEJSHOfC9JhIevuSn4nflx0WN0MGM2q3CV/7zwNQlyP+7fY6dJmyRUYbAW5jk92Aswd/vm/94HZ5g8469DekfmcxgoptsyjlyDX7u4M+MuhkPkF57sHTprKfdwDB0KSslgbmy+3x8Wfu9XhC7BFVDaJHDu77KvL7Of7JMKvH1zJJkBjD3X5aTsu59B0Wyhlx4bO/CSHgoFMrsYnDgngXym3rKpaz5seljOExx7HlmvpNG+cgZCpArNuTJn0Ju/NyNTSVLg0zoMg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(366004)(346002)(376002)(396003)(451199018)(8936002)(41300700001)(2616005)(186003)(6512007)(8676002)(54906003)(2906002)(4326008)(66946007)(6916009)(66476007)(66556008)(44832011)(5660300002)(4744005)(38100700002)(316002)(86362001)(6486002)(478600001)(6666004)(6506007)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NJVkgUKfAi2j7mUMQIXG3RttO/TFG4i0uT7t9gj+VecKszB9/HP1ChmWb8O7?=
 =?us-ascii?Q?IfpLUojL6KmCo/WPzgrSNFH0SpF+6Nr4zSy+f5/uPql9fUwjF8Pd/OSlrgIn?=
 =?us-ascii?Q?u0o4Soz7Ww07/Ordo7gu214Ntc14pgwNgCeQuYkmJedklgrEzu4PY7/UsSgR?=
 =?us-ascii?Q?Wy8NEYWZM18xqqvNQ+lHQrjHBHT83sI7yOs6t+2/TaVqYNUyrHuirB8pdEBY?=
 =?us-ascii?Q?CI4Y8eAbN4XZaPu4PYcineBPDkZjiZTpCV/NehZsIRR0b/E8HjrCeEQasF4K?=
 =?us-ascii?Q?IPtXAOEV8CvT3rX1IEad92P9dUKp/+Y8pu8ljGeBZNsGqLcks6++uImm7oI1?=
 =?us-ascii?Q?W+hkPROC0Pw+kdDilkddM7G4NDqu/UgQt4ot1qexbm3o1VprNEF+36KolXf3?=
 =?us-ascii?Q?EJH5gcwo2ogU5Xl3lv+EDvZieLeGSDgJA8QklwQZupFmJBzIbbZxkglOLJGe?=
 =?us-ascii?Q?Td15k6OscqKmyQfQTR4ksno++xuDLKzEVgWJbKJbVfqwn3wuzQVtXRGHQuZE?=
 =?us-ascii?Q?kluVGxv8GVoK3bM+eOEsROYsDg9J5ndkG0RZb0FJrHXwVQ1Jxm0ORFs+Xsw/?=
 =?us-ascii?Q?nGP1Fs4v48KaPVvhMM1gZGJIPwZ2Z17RiTs/GMx/lNA0/19W19K0Q7sx9g5K?=
 =?us-ascii?Q?mP1stJMB2y24HY/3dXYDvWcwVHdfUP26G+xo8LAVWFsxlPfO6e/i1OK3jF6y?=
 =?us-ascii?Q?GYRBQQnHLcHmJCXn2JH4Dokw84qvMRk4r+nPtfUv7y/i+74XxCPzJ7/WlxW9?=
 =?us-ascii?Q?xvccTVUHt79S8T9Hj7Geaa0CExdf4UobKOqVB7Hp/9/6YedRt68DyJ3glbwm?=
 =?us-ascii?Q?jaEMNlNEcChq6Rpsz+PuLVpJXrEE5OiDWZ/xP13c03FKVhffRIFVjPWqJ0YB?=
 =?us-ascii?Q?3evazZqc8WOWolTJAVYNpi3zAiE+d52lQObzFlLYdsBI3rlfU9WpgnZYLHTe?=
 =?us-ascii?Q?BclLKI1YEz7H9NorFd9gsouJfWkH/M/gkQNuCj0AoJnU9Wd4fH7TIRa4c5GX?=
 =?us-ascii?Q?7ZyTyOKrZSae006r/L3Yfioie9iFbz+LHZAWj1lWGkdIzcnVPq+2p78DpZFX?=
 =?us-ascii?Q?145b/8+j4poImo0/jVdCTT1kT0zgLbICZQ69K1ANLTejkD7zLCnBRvSwbjs6?=
 =?us-ascii?Q?bHQed7eOyWKSWZWyLpBIp4opSCoI5TU6ABX3hFYvti2LxWCJP4a9WRXbtj9X?=
 =?us-ascii?Q?HuFVpJ3+A21NRMe9Z4SsEP6O1XgWuEyPc3m4vAz1IjaYE+AIoHGZUdCKQ5i/?=
 =?us-ascii?Q?rcM+crlDV/MSuClMDqHxYz5N0UCqu1mbTDVQzcrkUAhm8AtGfivXVoa8f37T?=
 =?us-ascii?Q?XUXYzkq5NdkujfsTB7ThDewYZXf36RV47oxyKBaofKhpgysA5G5BbGQTmbNy?=
 =?us-ascii?Q?7eCRYKp8mjlgt5oxFp4yEqpUoK942Y639+Ocd2W6hUHBnvLJ8v1+GNfShIYx?=
 =?us-ascii?Q?Usu9AzHQGvJ0BF3bLxY1jBy4byAKgcmKCAW/XO0HJ+T0aVaJff3TqSn/Jm/B?=
 =?us-ascii?Q?7YbOd4VdqiXICIQlQsNrzTJzI1HFGBs4XisfTfmygPdbvwdAGB+fnptncuDP?=
 =?us-ascii?Q?iML1c1C9wS48w8dzIGCxkNEXDNZxLRs1H4bZURI0FBfKkEiqslJInL5buPXt?=
 =?us-ascii?Q?OnJ2wkMFpdKRbb/i7xRsqG1Ld5yMmyfp1O0zqc8T76scSR/Cl9e7j2XLcdOd?=
 =?us-ascii?Q?xbeHSg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79d254f-b8e7-43f5-c98b-08db0a902e6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 11:24:17.5200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A132WeysLwljVvZyY3JNl+/RAwIICIyLZ9pfXdOyVmUuAKc5LrkXpOzPeUGo3hf5TUob4kLCq9Jja1UHiG3JjIqHEQmX4wKpcI0iuqznBVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 12:04:22PM +0100, Alexandra Winter wrote:
> From: Thorsten Winkler <twinkler@linux.ibm.com>
> 
> Use INET6_ADDRSTRLEN constant with size of 48 which be used for char arrays
> storing ip addresses (for IPv4 and IPv6)
> 
> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

