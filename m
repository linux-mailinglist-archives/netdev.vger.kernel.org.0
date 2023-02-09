Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B4B690A4F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjBINeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjBINeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:34:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BF35FB66;
        Thu,  9 Feb 2023 05:34:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4dC38NXpb9pfGDEvOClhZvoyxgpleXeczmmcrMkyPjkoVViOE3gnNpGsE9sEMYi26VXhmtUdBhOocufmD//feQm+YKyRbFB5b33HU1zQ9OcV08f3vkggyuHejh9W+4yE/WqZr8zxXC4r9IqSWDEhHb3MzvhCAXBmW5rGdrmgWQKVyz6j8SU26wTiyucbIJg7JpEsbxkgyGI2Deiv/mE3Mt4cvaZwv7vQmdY/r+iZiZKHkOm54UWcDGtyw6Fjd0XJ8ezYLldTVX2tW/ImTYLVUhtNArdfLHkwY9DCoymTlk707u6Shl8MGILSSnTtkcXT7Q0uJi3kZaHrQcZO3AdnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTyHvrZnQvkO0KN4fkLvTD4klqx4KJsHhsYTrzUGjrU=;
 b=T7VJ1DXXbuF3N+X+0TURTS6ljlwpndQgHS3rwR6PcGHaBkKSUVtyaAHaJZe3nY6WO0xbW+QCwi5IgAYQLlTfA8bdxAwuF1YyVYpmo0FoUbTSJaMdK9Hq6lA7xik9ew75vAWao2QvI9wUQiZykLmOoYkmdYsm8sy4b7UALJ+SNhhBV9vxlOIYdyYej3sddPJySQIptJ1h4DB1FSsyjMg1V8IpqRMV7VHM2wf01lrywqwAHfOGWiLnbiYIcte7mSFMKigT7XBeGWIKy+JeJ/A2x3Updl0BQnyrGZcCRwDSW1zh9zoJWAjjiQnYfWA/h94ufnHdTI/0OVgggiZXJ81IRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTyHvrZnQvkO0KN4fkLvTD4klqx4KJsHhsYTrzUGjrU=;
 b=aynbSrUjkESmOlR/RtA1fvQDpiTy9EJf07hSlihJQse91R0d3vAaM5fvjV0aAVYG6wzQywrgh/cR8IlZht3cP5YZu3tB+CWspAC2ac1DOcutB6BpFORErTaCVQw/QuXM2iECSCM/i+rkEXE+3tIOutMa9MoxenbNaCJS6XnuRLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB6021.namprd13.prod.outlook.com (2603:10b6:806:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 13:32:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 13:32:46 +0000
Date:   Thu, 9 Feb 2023 14:32:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v2 3/4] s390/qeth: Convert sysfs sprintf to
 sysfs_emit
Message-ID: <Y+T1+N87vYBjeaqM@corigine.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
 <20230209110424.1707501-4-wintera@linux.ibm.com>
 <Y+TYo2UXuVQuXGrY@corigine.com>
 <36189f0d-82ec-36f8-c093-1947ebbe3160@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36189f0d-82ec-36f8-c093-1947ebbe3160@linux.ibm.com>
X-ClientProxiedBy: AM0PR01CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: da11cfa0-55e3-41d7-a40f-08db0aa22156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knTv/Fuz8aYKi5AhLEVUZwy/PMaprnvqntCLrBuvLUM8VVYSy2HdnHKY1vrNuC2fMX+2iMS+VOTelZfoD6dJTQCLi0l9hpfYNg696pY8+FenGutR6z030ZZUYngLAlgxBlWctgk29910Uxag2E9SuDu2cKnv05YvQxJCCMSEP4WYj8evbKY9YS1uLz+uiq8X4a+OIyL4lpa5eUb4lvJOEm6gUYCnyAU0JsshM77mwzPCb9Exd7ZmZV3NRfgV7oT4HCzgWFLArEcW6aISfO16gkCevj5ugf1htLamgacgTzBvOdBe1ZYVuC7IhjdhNDmt1eRl+bHXjc9qyt1TFxnlyIqxiVh0Pd9yA/RVFSYBYpZnHm6jHZmwVa5tfD3NvSavQYL/mDRXkQu8TNHe0b218vTjb1tIFwwhM4kIOt4AdSjejNoeuyFRSJXIMPRROpFMNdNHvozXHDehpFTW/dKXLIUVUc1dbyBLAO4BIvwv29gEVn1pF4hLLLTBaIKy6YQhOkCE9LGIXH7ygWRczYzXUh6exC9xeYwpif0Nz2V4Fam3/fSPXghUndzhLJ6fWw0/RnWUTKortkRBK9SoL9VZlgt4UYStAVI/3Wy8FwyiWxhXdYjItgswWmLxOpHsnWRUFpBLPD0K6j7fLsmNZL1KKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(366004)(39840400004)(376002)(451199018)(5660300002)(38100700002)(186003)(8936002)(53546011)(6506007)(44832011)(2906002)(6512007)(41300700001)(6666004)(6916009)(4326008)(8676002)(66476007)(66946007)(2616005)(66556008)(316002)(86362001)(54906003)(478600001)(6486002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3UXcTNzbhPHbVsZkdcrMaLdZxGWBa7fo8CSkBjpThxSghVmlb8FWbiQhq8S?=
 =?us-ascii?Q?fQxlPZdr9vTyq6JzxPJiBCTw/RCisyJ9oxSYvtqiWGlzQlwJUOzSx4sgnuRN?=
 =?us-ascii?Q?AxbVGfwWSa5yqyNBbCun1B2cUuz9r5Fk53m0kBKxgF9ezGC61b9lXe+phK/l?=
 =?us-ascii?Q?H0LcBcwNM4IOk1URrgLsgrW4zNXlpDnbjRn77PDAjSPvSax3zH3FQL9fjIx4?=
 =?us-ascii?Q?u1Piof/SmuY5L/KuBHS6dVSr4Kocin8TT1sQ77UEzeGzE1thd0Wn+SIXEtW+?=
 =?us-ascii?Q?mNOFWY+M5C8H+/sXSd8KiQdy+C3WQFHfqbPnULCB/X2tiGBf4wAUzjDAKdVF?=
 =?us-ascii?Q?JNrTyhHRvwTJCqsPQ9yuB+uIXiuItajZqlRX3RfxqSsf1jiPrbMAmX6b7/FH?=
 =?us-ascii?Q?8txWhffzAsPqCCNuw6LrxYpQx/OoIS5/d6bSRzjCKFWD/R4jnGYf298w/GVx?=
 =?us-ascii?Q?Abi8myUftrIYd87iqhQaknBbaEb+WHEjP2DktvbRWDLSMF322ME0+9fAM9Fi?=
 =?us-ascii?Q?IU5m2MCM8P+jtbt+TVNfbPe8rJUasybEBaajJtKMv2W6IJbW9cbM9Uyjexjp?=
 =?us-ascii?Q?xgTpwU4XI68TFSXnc2WxLKCejopD8iHtNBJjclR6Hp349iBi03sVBfUc78WC?=
 =?us-ascii?Q?4TStmSXRjMqk6mwwenp0iUcZi/UgDDTAsX590UcqaYG0Fgdcne1tg8LRZlBP?=
 =?us-ascii?Q?gNNftZ0yJB/CPMF9e/2C9cs6/puIaJQvsorSVGXqV6p61B+MScw2ZW1yqe5L?=
 =?us-ascii?Q?7pTFsjNyC5s3xX3Z8h2PBlwOd1xq6+0YFyTSlmsq3fcst+cgdLOMufSOw2mE?=
 =?us-ascii?Q?Fgsn4cw5mzlumCIpyRvl+B1ZKMVGfuqwoPXDrWIbmwdCLrkH04Gt1r4FMnHO?=
 =?us-ascii?Q?L/IikV0CBa6W8G8kxK1HiFfwRXGUUpFXAysPZ7PLte53lpy8g/9JNvRZlWg2?=
 =?us-ascii?Q?93isREIsVXNU/LsuVbBG1cCiMOVykrmR65QBZhxRd8o2FDRXJx59AeqX/HOq?=
 =?us-ascii?Q?GCYrs99xkAD4eg2ZUc5wMnxjAa57dTWoy2yklHxdAUEP5CWhzmmWqGvqt+lA?=
 =?us-ascii?Q?xxZJ+yzNfee4/YAj5xTzuUwHc5miLxrgJYSOZZRhvD8NgRhshY9jYMzYg/wC?=
 =?us-ascii?Q?H+Jpc8hbFyCLSHkqDfNezCGH3LWOhzCR/k4+wIJSbvgCRv6Gc9Uq+9K8W0wL?=
 =?us-ascii?Q?cRto8M/7K4SIBoGrsUaQW2/DnbtScbh3/C1y9DxbX6q2pW9D3RbpZFs4Pvo/?=
 =?us-ascii?Q?UWdqpTy84BEtPKjeTDzHqYIo8yDrlZtb8pyI5iTYt0J6ZnVYVWWA1Kcu12Fx?=
 =?us-ascii?Q?mQDLav/Lk4uPOdhRJvMiK6gxP6AxLFtIWolPoLCfuk07dzVzEP+bPiIjV0pm?=
 =?us-ascii?Q?Tkwu8nEknImZ6TvrFxEplAWTPlInY1yjmEBypvWessBdWRamWFMM9RhYrFdm?=
 =?us-ascii?Q?oXA4E6ryxz+IIkaNFVsxvCqMJY/o2n2NNSu4V1N832Sltq/lRUUnGkq3LKCQ?=
 =?us-ascii?Q?BZtBMKjI8ZRubdhJR+upf5a2s58c1VSCietn3zSd6R4Y+JLHoD+xZPVAOlTX?=
 =?us-ascii?Q?fudU0pisLWW8j31/4IfZNJaQ5cEI8OZlUsBUITzX9NygJuZXO8hWNAKNjscc?=
 =?us-ascii?Q?44Vvw14jAP7FGoS4Q9W3sZiQgwq6OxArOdXoG/kQHRmLHAbjCcliN5j/PYBE?=
 =?us-ascii?Q?jvdk9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da11cfa0-55e3-41d7-a40f-08db0aa22156
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 13:32:46.5060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySGLjmVDthrJVRXFWFvcZ9K5w58osXJn/+Pp6Jqn72NN2BZ3mam5MqP9CD2DHl+9Vhf01BJwlV5EX1X/d94qz8o2H+quvlEgQzLD8DLCyN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB6021
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 01:57:04PM +0100, Alexandra Winter wrote:
> 
> 
> On 09.02.23 12:27, Simon Horman wrote:
> > On Thu, Feb 09, 2023 at 12:04:23PM +0100, Alexandra Winter wrote:
> >> From: Thorsten Winkler <twinkler@linux.ibm.com>
> ...
> >>  
> >> -		entry_len = qeth_l3_ipaddr_to_string(proto, ipatoe->addr,
> >> -						     addr_str);
> >> -		if (entry_len < 0)
> >> -			continue;
> > 
> > Here the return code of qeth_l3_ipaddr_to_string() is checked for an error.
> > 
> >> -
> >> -		/* Append /%mask to the entry: */
> >> -		entry_len += 1 + ((proto == QETH_PROT_IPV4) ? 2 : 3);
> >> -		/* Enough room to format %entry\n into null terminated page? */
> >> -		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
> >> -			break;
> >> -
> >> -		entry_len = scnprintf(buf, PAGE_SIZE - str_len,
> >> -				      "%s/%i\n", addr_str, ipatoe->mask_bits);
> >> -		str_len += entry_len;
> >> -		buf += entry_len;
> >> +		qeth_l3_ipaddr_to_string(proto, ipatoe->addr, addr_str);
> > 
> > But here it is not. Is that ok?
> > 
> > Likewise in qeth_l3_dev_ip_add_show().
> 
> As you pointed out in your comments to patch 4/4 v1,
> qeth_l3_ipaddr_to_string() will never return a negative value, as it only
> returns the result of s*printf() which at least in this usecase here will
> never return < 0.

Indeed I did. I just wanted to be sure this was intentional.
As it is, I am happy.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

