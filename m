Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D479D6C0EB3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCTKZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCTKZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:25:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2121.outbound.protection.outlook.com [40.107.237.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B761BAD3F;
        Mon, 20 Mar 2023 03:25:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3jnjT8fltPi+pLEStBk4seSTlHpTYNwnkeiH3w3AQXx0vb+LB15sm+jBOBJ2YrS00mO8hnMqYgxvw7LPqNl73B3BCZ9+CizR+FTGfdxzJXCzM11O6s9bz6p4QUP4MYqAnJcjYP/mLly5ockzzwX+nCZpu10/giMZbSZV8S/KjTc9WW8PKiCBXZz7CgjSgSSu/yrrg/02UscGuvtgvnINZtTcJsAOF3BAaIiFYSowLF+uxeNjKlV2WGF2nY7w+pgcQZWeLr28ttG26H69Q9Kni18V0tjpkr1puDZcIINA+5HiHUEKAAjf5JxZi4p0oMNl3bnztaUfaWXt2J4VAYPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVD6ZgXSZSbxDUYfZvIK63SvDVkJCsk2rXux0/LI2R0=;
 b=m2wltoc6TQwfV9QKUWOGAFYbOu3hu+v7NotqFJhTQ7ipo0p314mYl9nSYfD3rIBnlrp4dc1AHtZvtmU5WI+6pdgzv087APZ7Uab3olD0/uRjVxBd7NV7zeEaqnzZHbX9Z65QClgj6bz3OUF/KvHZPTGpz7kuL4z5sO/k74y6d4zcUJNjS9+WUhzrZKKP4SEOPFe3CgSZlnErkYnbmfNnGzw47OUwMzY55qzRviC2VJ5lB4aFYSd8489c4eMNNHriYISgXWzM1TszLOYwSUkRZ2/chICjbRHJk15r8sQGPkE+z/omvgvApP5Hox4MIyZf2j/pf9NKM/OpZuU5SqJywA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVD6ZgXSZSbxDUYfZvIK63SvDVkJCsk2rXux0/LI2R0=;
 b=fb7VUaC/XrTq4+6GghX9hvqOi3rYx685oftbUs48vsp90ioZmDGZPhk2O4Opoo//1dIu8YMV4HoZhDCvaCY4+37l2FpuC3YAk5L/hs2PQ4Zu8rrCfM1shObJuZofVVSPFT0D/RiCINrRdWRcNG0Pvj5rsAf83BtWvp25uO89+N4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5096.namprd13.prod.outlook.com (2603:10b6:8:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 10:25:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 10:25:33 +0000
Date:   Mon, 20 Mar 2023 11:25:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] Bluetooth: 6LoWPAN: Add missing check for
 skb_clone
Message-ID: <ZBg0ljeZVSpyf6E9@corigine.com>
References: <20230320030846.18481-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320030846.18481-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: AM0PR02CA0079.eurprd02.prod.outlook.com
 (2603:10a6:208:154::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5096:EE_
X-MS-Office365-Filtering-Correlation-Id: 5afdc1f8-613c-473d-466e-08db292d6fcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNgdi+AAeLHJ/D2jEjCiktLwqAvlGrLxlozGem4ZheWEAyQ7zFEe+5oXPkGHn4QvoA1OWchk6yah36GvZga7+pk5fHRs0fPqWUo3Rwv15OsERfs+1Wgnab+Wa2FAUSfOXzzzUrj+kLQoMg60XAIqYjHmZOgnBMlEyTS71CpGzV+xHo+IhtbQZOJ5cqB5MqN9nB4ABUV28r+MBewpFzPlpQ5EeNdlvqgbxID0Os5G0fmnuNT5vHZ70I4IV92nrjY+1qanA0tNjExl4EOOU2giDCjG9M2RfSl+gQYDDIqzpEtfuWaYeJGLWeh/NDjVbdSY+Q5rolCBK8OlyjDzUtWtDO38JdH7OjzArcFV/FeGsoKbMBaGsiLxVrp9Ta0YC3GhvvSudzN8SU0BO0EJjioQDiqBbe4cmDdfLaM5YAc45pJLvirVqOhcBJ1qb6Mj3819JLt0yYCAvhNicEdeCWrMJaEfFjwEcp+RIMgGapa1p1V698Pc9/cfg1FSsqlC4elsfbPsep91WyL9xusH9nadoIYe7ehEDSnQcASsFkYLCOO5JgE9G5FDv0xbsGbrI0rCJeFmeHWy+odtBB7cQKu/Ack7uAukcajGlbAeKHyStmw5VgOW0AaApdG7R5KN/bvIkGtuKRQv6y7fj3peK6yyovM4puwNZpIJJljWn6Nn0ifSriH/2710tOkBBwPpxreA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(366004)(39830400003)(396003)(451199018)(2616005)(6666004)(6506007)(6512007)(186003)(6486002)(4326008)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(478600001)(7416002)(44832011)(41300700001)(8936002)(2906002)(5660300002)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dkFWlKLZcwuDrUeXU0/HY/C++UaL1TONnqnhkT+2wVqs1VOSm9GEBTTi2eM0?=
 =?us-ascii?Q?YxDuaX+75BRFO3lOQ8ocilxtSuBe9znb9h+KFaQZgITbqw992bgFTN+aUZXU?=
 =?us-ascii?Q?8J6XqqBUue3qmQNTBnxEghcWoOC/SJ1VuiyUP47s95VlkbXrVHmNLj0icXgb?=
 =?us-ascii?Q?qI1v1AlfQZsjMAeyx3dQyZvphSXMXfvH7wrxyMmHT9o2zPESEE+YOREmJZkN?=
 =?us-ascii?Q?etzFuUKk7iDnDbJZDp2mGG1grkvldnswJsRalyWHBB0M8xh/Ko2PmJ3FNmro?=
 =?us-ascii?Q?O99+bO0SNlRCD9ZyLSZQyUMyuf+6onkpbm2+R9RJPIM/mxebi7SOYHVi4ju9?=
 =?us-ascii?Q?ZYlGqKuG4ThLQZ/mk/5nLZYUtSh60mZ30QbcFJADwMjOYj5302qO/A94I9Rr?=
 =?us-ascii?Q?9hz8/ox9Bf2pWjKHBKwxgcP29v0MeFt8aO/iF/5NfQMroezc4eIzgs5vaR4T?=
 =?us-ascii?Q?gqa/6SITR2jzoRzr+tBQXYLkEzjpNYyLn7hSWvoCj/0NuqiiyG2LIdZ2jF6X?=
 =?us-ascii?Q?TH8CIYkXheWigHiTs6UWCKAp7HEqkJ3XRCDKf/zBn7mcbWGTjSbAqJ2uHe/z?=
 =?us-ascii?Q?zrdufCS+zLRa3jqnyR2RKdvJzc3o88rLLplfStxbgW3jtdg6Yy/3AludlMU3?=
 =?us-ascii?Q?804vS1xzOce1BZZICiiQkj8mZIdUBg0DtH8G4++uwT0f3Xs6Unl1dnr6MJAZ?=
 =?us-ascii?Q?x4aJvV4imQrAQSeLTg6dMolC0dcmKm5td7OaIYp8OEz4/vBnkPoXWm9amPkK?=
 =?us-ascii?Q?o7Jy+HtycHW6XM/UX/8FT9KHqOI2H6LKCZDeSxNKASRT+n5Zw0Fs/uF2gw+S?=
 =?us-ascii?Q?WgUKf8jF7h12Tr1qiAjOiF84jDe6mviGt3p1cbGSOAlWU5B4yi3qeQqdsFNl?=
 =?us-ascii?Q?nc6VnuW43eWL1lLAwpfiDEDxV/dMw5mC/Va34txTn0gaHD5lOSI8ctP6eXOV?=
 =?us-ascii?Q?FME8xgSdY52qog2aT1vVWxqnMabRGOBZhUUqaLkAKqltn8/EHaa2ap0FFsab?=
 =?us-ascii?Q?GpFhIpZY8WcPJ/YdEvTSweTOPDkecSzcjfRPtvaNJ+NAsPYfHOGF4hZ+ktDg?=
 =?us-ascii?Q?yKZvTR4hCEH7mU/PENIWMXib6sAW9B0D04P5PUgUup/4muTA8lsbIvOhPxGp?=
 =?us-ascii?Q?Vqxbrp0OzD6uxVpgst0KIEtzRYEjtCARM8KxkZK0/DoBs2Irk5NRSJMdn1dq?=
 =?us-ascii?Q?YMkArJKFDJQy4OGIPfDdQQG7gt69gYYh1iMk2tSyRrAIm6GOy3Bd5+30rJEm?=
 =?us-ascii?Q?ij+myDOUvl9wor952nZxqNbw9WHqAl8HxPnXIe8AduQu3Nzsc1zrSGuT13CK?=
 =?us-ascii?Q?qQL03bv0EtFujSVKTeyCWIuX/vVV337mCysOeA+2Ws49qwtXBKmoCnVv7EDN?=
 =?us-ascii?Q?+/5xEgYtE0M/H1ySO90xjkz4v1AnvjjhPDoxV/7cECZZOQlsCBB/xvpIRZgA?=
 =?us-ascii?Q?qZfot7j4fxYX98/OJ/yIWn8QEkyEb5dFgU0qgNmKwRiQmKIkfxTqoi2hnLQk?=
 =?us-ascii?Q?24ZyE6InDkfqwrQ6frJnoBJjwJhFijwVPvK4hQ9OXGwoGiq/ie3zLEDvSFlR?=
 =?us-ascii?Q?QOiyrnRccp48D6NhaN3kwqz/MWVXgZSV/ZsU/RLhtvu/EB+G96KMBeFaoMBC?=
 =?us-ascii?Q?wpAoq4FSjTf59HvWytVLXvXz4mikarOt+1hZg0pmJaX9QCxGVy8HA07fQyyW?=
 =?us-ascii?Q?s1NPbg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afdc1f8-613c-473d-466e-08db292d6fcb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 10:25:33.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQ/ex1bqxsQUCxWtlqY69ZcnPgchjLrN0Z4zHjlT9m4erjC+xYmQ6xW11W0d45Iu0zTE8Q+cqliklSjCcMKFv3aLiKUhMXR8doYmQOO8QX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5096
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 11:08:46AM +0800, Jiasheng Jiang wrote:
> On Mon, Mar 20, 2023 at 10:54:40AM +0800, Jiasheng Jiang wrote:
> > On Sat, Mar 18, 2023 at 05:03:21AM +0800, Simon Horman wrote:
> >> On Wed, Mar 15, 2023 at 03:06:21PM +0800, Jiasheng Jiang wrote:
> >>> Add the check for the return value of skb_clone since it may return NULL
> >>> pointer and cause NULL pointer dereference in send_pkt.
> >>> 
> >>> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
> >>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> >>> ---
> >>> Changelog:
> >>> 
> >>> v1 -> v2:
> >>> 
> >>> 1. Modify the error handling in the loop.
> >> 
> >> I think that at a minimum this needs to be included in the patch description.
> >> Or better, in it's own patch with it's own fixes tag.
> >> It seems like a fundamental change to the error handling to me.
> > 
> > I will submit a separate patch to modify the error handling in the loop.
> > You can directly review the v1.
> > Link:https://lore.kernel.org/all/20230313090346.48778-1-jiasheng@iscas.ac.cn/
> 
> I think it would be better to send a patch series.

Yes, agreed.
