Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C3167F994
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjA1Q3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbjA1Q3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:29:42 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2104.outbound.protection.outlook.com [40.107.92.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9A53401A;
        Sat, 28 Jan 2023 08:29:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsDuTKknJGgUjHgFx5OjGyTdy4I5ggBBIKkSbu1SFJjM9jfmppZinZFH9d+m913C+wADhQWqP+Qwu/5fvW5RbTLqtymld99G8Z25/+eFyLJ14d4LZCaxGW2uTXhGLLbPVKV3f5S3WYvdXlGB/EBOt3MMFFeJioPvAuOYIR5pp07Al/aTvkpGkvkudgtXAmS3pJCRTBmbQrl1lMvjiakHreXfBzDvcwlsJTt4FUYsy9iEeTj4mx929BycRxOaA22TsHYp4SJhwDxYsRiyxmOqip+9V1uPXPJSl8NWqTUG5CTggcbgdT8olEgxo9f9iRhGD5LFlo61Q8ltqh1NUFyrCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZ2vw8jzF7QmTezPtk6dWYZ3lZb4uTtayvArffZhgc8=;
 b=PEOBMQe6Sr7oDQ5/ottPcqY4GIRWFCf155Djec1FjlVo5QQWjabXWdeYH8bdXzpt+ohn6mL3JElTLWDt0rjEr+vA3e5LDVFpVhQLQ+7R8zR1ZThXpUs1piL7yzuKbYcC2dMSa03svrQdvirYPjU2yjRGp+zMShRj/cfNXad035CFXrIfz2frMAnCWKSEYCOsEE+dRZsxfU1wAY3XIkKzKalGHIsyU+O1SZSpgrDerFfrdeDq3n8xY7jEvWluVxrM7prj6WBl7coMilbj/4UhFAV3EDQNZilYLlKFpv7hl0CwweIdfajbe+HYpI0ZzrK3jgamUd/ilCJ13LufRNW2Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ2vw8jzF7QmTezPtk6dWYZ3lZb4uTtayvArffZhgc8=;
 b=W6DHJ8UR4pzPpcfaYKe2JCjrNJbA66YfHdGIQBjQok9qL91j4bBh0R9s+gzkZnD0smvHLjfMIRK7jggsr3FPcyX5ot+DPMYneFz9DdDqbfDWgb5rnNPIZ1alXnfQp/5HrwnaYDaO9mnoNTLEiM1zi5mb/I4t1B0fm253LoS0hEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3882.namprd13.prod.outlook.com (2603:10b6:5:22a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sat, 28 Jan
 2023 16:29:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:29:37 +0000
Date:   Sat, 28 Jan 2023 17:29:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ysato@users.sourceforge.jp, dalias@libc.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH net-next] sh: checksum: add missing linux/uaccess.h
 include
Message-ID: <Y9VNY2C1CuHHo6WY@corigine.com>
References: <20230128073108.1603095-1-kuba@kernel.org>
 <Y9VKZhCOdM4L28UA@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9VKZhCOdM4L28UA@corigine.com>
X-ClientProxiedBy: AM0PR04CA0131.eurprd04.prod.outlook.com
 (2603:10a6:208:55::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3882:EE_
X-MS-Office365-Filtering-Correlation-Id: 23cf1f8d-6688-4112-0aa1-08db014cd91c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +oyqRyyJbBGEPRaNfsCAc+Kl8aexHoR3BO8yHJcDji7bHbmL1wsX27+QJfg2YhyrCpEz+iUEKqQRvedr5tKRV+5Q4JWcK8GEWUyVFsBPS0b1+5z6rqW6AGPnTlMS4i96xhuipL9VD4Gq6TOjmV6r7nv5m+WEN8QVpziHLNRCA4PxEGe28cOuyiaeGXGvjgj9iqh9fAG69ny8InbZMn5t+TT8XuiSRiVKBEW+xQFenOhVN3l7gTLFhRmZjNha7HcaopIb9doDyb6b2tWB1ltq7+0Atj11+s8LzXMVI7dsT2lAO6oSpc4paVqerReY1IEbOEPYlgjGBYck2mO/HY4ODMwzgg8hQEvYNv29aw5YvFfojxp/hfKixi9MCUlrcveMMKqup/DZrDIm5qdp+f2COEjdjgaHpIrEFMlQ46gCRfJiqdoIUju0MBDV/N4EMeExUfRLFLkeTyYoHKLOzlMtNkPDKNKeJQ0HE7gO+49kjR+OsU95XQI1qxN2R2kLmPDYeRhgDaKkOFsbfulqkcNShYuOqpQPfxHAlnijx6thmlunyGBLgqHfZlLj2rC60QZsJzWGfGsN/7NuL/SmX+yGLVY5v0Qh+dc+TvvoZ6R82iOAaEfZXV4BbYpenml1pJGRtgRx2eX9H1hkUjKr5Z97EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39830400003)(136003)(396003)(346002)(451199018)(2616005)(36756003)(6506007)(4744005)(186003)(6512007)(6486002)(44832011)(6666004)(478600001)(86362001)(2906002)(38100700002)(316002)(5660300002)(66946007)(66556008)(66476007)(6916009)(41300700001)(4326008)(83380400001)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8uKF9rGOlUaVIRQGxTLHpGYUOn+YhBiVku3MlpKBFBQCTqy9h7hZR8HfTL/A?=
 =?us-ascii?Q?9nVFzz1tC6jRAov1HDH53vmxHjQjRViBGWbBZF8I6RxEnOQFzW8OwZyVSFLC?=
 =?us-ascii?Q?fBOL+79G7HMnmzBFhqmZiqSUdnnx6MZ3nTj2yOzuYWN22xbx1ZHQmrK8DdbT?=
 =?us-ascii?Q?84Bd++lqPxKyOK7Gy6vcQPNRVfD9XkSLCy5DWnWthPLdr8aaM8gxkD4SHEyB?=
 =?us-ascii?Q?oQvKB34HFt9O6wStIEog1GDWNtc9bCs+HVkN1ZeXph4NoOUY1lHtdDJiZfSY?=
 =?us-ascii?Q?SKBEwI8F68QeU+DPOxbZzRLRUul655jQ6iht3yQ26VThS5GdLEGpyAMfpUH4?=
 =?us-ascii?Q?4+IuQAQ1qR/w0XggJA05h3Ec3x6nkZ/IOXIWcunwA+kAwlzRuEkbgV2DckXr?=
 =?us-ascii?Q?BxCfbk+Vdyqu2yNYaitHlQESsZqJAB5R1uli2Xz8nQhsI14z25YKxC3yiZgV?=
 =?us-ascii?Q?1wjW+U1Fwi8qOpC1R2PdC2/5ig1a/PputGaQfRysUidUf+G9ojEaYASgRUDX?=
 =?us-ascii?Q?nUzypkg01NfqdGx1un/kjnJ1cuFmQPH4lyMKp1lFlWEUJ8BJXKmza+eDzthI?=
 =?us-ascii?Q?7nADrMu6EQbqLLMrJuPWDagbKXMeZ8TwpmA+luAbPY9N4WJk4TU6uXYbZ6M9?=
 =?us-ascii?Q?JpE9dGoJEb2Xp8vE02KJS+VYtbCibFYQn04xPjY3OsCEkW5kqZXUQ7Ctp5DT?=
 =?us-ascii?Q?cht2jpFJJ/JNNV4IIEdBlEuOo4i4TvZg0krL7FTgLa2cWS5haLTAjoOfeQFV?=
 =?us-ascii?Q?ZBfc6OexNM0YtrnVn4TGqmVg7+9auwox2Icir8Hz9tiDH7fZuKraR13WZtLw?=
 =?us-ascii?Q?UwyVA27PWWa/mHUp1grWJs06s5rRmiytHdnd/2lVUjkZlj9hhAsraVsPqlKE?=
 =?us-ascii?Q?lPcbLg5QxlyOpxjseCIVL8NT330QUiGLZATKnNblHpvhnqshlCB1U63cSemP?=
 =?us-ascii?Q?jc9/XMXbwUfdKOHkOZBN2dxI9hhKZDbwnv5fRb5ENbuV4pTNud0c12PJo/ka?=
 =?us-ascii?Q?E9zvZYEEKxFTBNghPCiv6CE/MNfuyO6ZZv+QaPEns0nilnBVfIzQ6BtpBOYV?=
 =?us-ascii?Q?3IeigzfCSK8m7rpX8iXj1b2g2TdbtX7mmmsWiOIdIS40/aWC7yom3HsQr9T/?=
 =?us-ascii?Q?5rTGEFq87pfBtOEbXK8ZYag0O/vlFphaww1aMJdIqjR2J3n6YIQgEs5JwgEF?=
 =?us-ascii?Q?0dFqsOPmqPtEW6/0zQlx1gjY7SXW/simn9xXvwmX34/76aWCZCBSN1iqeEZd?=
 =?us-ascii?Q?A4Ahw6jpsDGX4bsCPVrUtxoxvoQusXWQaoVr4YQbdVBqFHvdZzsSlOqKwiLR?=
 =?us-ascii?Q?W7/fvi1yrFzNOTyIarBMKvRVEu9cYQIc77u5pna/Vf8tLvX2gT6RUtuZX/oW?=
 =?us-ascii?Q?iJQVMJ1nfTnaBhDOBYTfXIv+cW5u0oVl868QVT53pykAN0MdRIBnGBnKAU2r?=
 =?us-ascii?Q?4Lou1Unr5yU4H9vE5ffDv2D2s53CBi9+1ryv3Ab5v4dFi4AbbtgQB93VxtjO?=
 =?us-ascii?Q?n+ZUBajkE9ZfrpPHnlu9vsI3PdMexrAa50wCa5cxG1yk16jkIHq47NQJOzzC?=
 =?us-ascii?Q?ax46qMojHTGOL0D7iJg+6mxRRtLHbWngLT2HVpoRFRIY7rh8o9B5bWf+CpB6?=
 =?us-ascii?Q?1gd3tJd5B76W8khfAPlNLQEvUGjYr9wcBhFurG5VZae7zasm4BRpZg+weyjJ?=
 =?us-ascii?Q?mMOndA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cf1f8d-6688-4112-0aa1-08db014cd91c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:29:37.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RverWDd0nrbfnn8RCf4Of1/t3LAg9wqzI64c4r0m4dA0MBxYBVhJ+cdX1DO8ru8wjthV6HHCwwT9DwqHp2scLI8+yTXTuH0KlDpxeK3CQLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3882
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 05:16:48PM +0100, Simon Horman wrote:
> On Fri, Jan 27, 2023 at 11:31:08PM -0800, Jakub Kicinski wrote:
> > SuperH does not include uaccess.h, even tho it calls access_ok().
> 
> I see that is true.
> But it's less clear to me why that is a problem.

Ok, now I see the kernel test robot splat.
Let me try and reproduce it for my own edification.
