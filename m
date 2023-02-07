Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3868DD3A
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjBGPmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjBGPmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:42:54 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10E883CC;
        Tue,  7 Feb 2023 07:42:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsWKoyDpVqWA6NxuWRCEXvG22tCgwxjlif4OmcnaNXTmO67XF1u8aE4WSdWyCNmjqoEwj3MZqi99+9KcGWbC0mdnwkArfy/xVbxnNHZfzQQNSrX4X9wGsvui66rumL2VWpapXocBqjJMBPKZaTPCaQ18Ckkfh+oPJP+pypuXWMp/QatG6xVuaaqtSoIeimq3YbPcdTA4ru0kcEw2tiRULofnKAwGgiGMu9ZH+xPKRz2yAUtgzvER3Ghod2lYf6stUifn9/bYEmOJKlh3WkeWAGG0YYeFqReDp67F1OGQkeHRvOyaVSPhDDeFuMRey0ZBf+UpZmklpXymRTlX9EIDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfCPriqx0uoRG5VT1MpPNMl9xkQLzssntex370w/V4U=;
 b=ee1IrSIlN8SsGX5aXD3NqJaXMYzqfOEbkvQW8tk7KQvJFada1yK1S30dOB/TANYmfXhizZkWw7iOFgq6YEOA+KIxUtS1Rhk1zI3r9X4x5WoUj5Glz0AlH5dBMeEjyxIo0/KKQrpqpuzKh2oPGP7hhQjv6bT1VYYPkdFSXG8KDeUdISWPkrH+krBDwa37KecaBtCABOwharhbIDUpviVU9OlTzFfHvk/GwlXrnMcCvs5f/DTAYLqLx0fVt1GOAVUHppP076Z5zvVpCF2dze3AIOdqqGv9VpEpbUgfNNyTEyR1B/gB0WE6GoZq23zNSggES5tzhmEloyp26yOvsVyq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfCPriqx0uoRG5VT1MpPNMl9xkQLzssntex370w/V4U=;
 b=NSg7EjMAl+VE3inHRzviOovRNT2v2r6dvLnrDbJQ//B002TX2sUwTLWmiK32ndcl0QyTyY2TygP9jHFVRTmENC8bFUApJZVHgHIse1G2NKrnFBIS+EhmiAZ+GB5iy7Y8FusoaiRpxRvXdqgjZXDIZ6TnhmM2xqrijkpm/weF/5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5846.namprd13.prod.outlook.com (2603:10b6:a03:434::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 15:42:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 15:42:47 +0000
Date:   Tue, 7 Feb 2023 16:42:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
Subject: Re: [PATCH net-next 4/4] s390/qeth: Convert sprintf/snprintf to
 scnprintf
Message-ID: <Y+JxcPOJiRl0qMo1@corigine.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-5-wintera@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172754.980062-5-wintera@linux.ibm.com>
X-ClientProxiedBy: AM0PR03CA0023.eurprd03.prod.outlook.com
 (2603:10a6:208:14::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 16b5fb33-65ba-4dcd-80d4-08db0921f60d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hASJFujXuu6qo10eDXXgULoZiJHSmESOypbGnuVt3k2uOJZkWoL52XyjUpJake3pT39WSTUWnHreIP0i+LScwzetRjD84mIJxMAVyd328sZCHl6l68PVkxJi+QAoU+9N7Rkz1U34Nh51OrDamMNISdHPQFWmotOy7YKzl5rltn3CneyvknCBM1cCIWn6PApheZeISTUgWiQ2edI9GTcaYigh1G7+MIxJ27S7sXcDDPQrW/3kGEwnFvJjx/AS3vQpUWw4nQK5tcz1FbZxVFzOv6BFfHZYmqhPOFJ5NqXQ+t5UrLdWfrYeoyuxud2wJjq2Ku+u5qK1T/AzG/PgN26ZQWHRuz4oaM+at4b/dhIgoKUimRjT3gpFx8ENi6Dn4RLbUIYishVwef76e0+BtGpY75bVuwC2eQuZniiabdaShbHNoYkB+3LD5Vw+ORCqF4dZK8TWvk45F976pk23EElMnGXrpi5k1IK/rN2pSHNPLqWzIPSVRk4IQ4gE1yRtB0BvUFpXy/wfQwf7Q5wa8SP16jqeAMfzjf4h92JZLVSjSwQd8xrYvziZmPq0rBiDYFhysya3e97s5PusaUS5EMvt3UJtgn3eruavnqU5PRMVLxf/YchA3CVLGJuE+7OAInlALU8DV0h81NeZ2kUZiYzq2hxAwoJNZMZMOMSUVTdJwpf3b5+ceeeQ3dbw8k0QNVYW7IaYKCoPSmFMW0kP4Tk+ZZHy6zlCe/9wS2UrY83QJa4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(366004)(136003)(376002)(346002)(451199018)(6486002)(478600001)(966005)(186003)(38100700002)(8936002)(6506007)(36756003)(6512007)(41300700001)(54906003)(66556008)(4326008)(66946007)(316002)(6916009)(8676002)(2616005)(66476007)(86362001)(44832011)(2906002)(6666004)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F4ec0BDNpVafmTXdKfPqow1Onodc0ePDn+nhxIu7SqjpaPnop2SUrlJHwBjU?=
 =?us-ascii?Q?UsKpEqJfSMxzvcmBL9Wn0YMLmlWefJraWnYiZWjHGdBmP3w0oZ5jvpMfVa/f?=
 =?us-ascii?Q?QbuigXOFTvlqeiWTwfm2dyu2BIGIbUxs6+OM8cqCL86MjovYrrA3lsyoFACY?=
 =?us-ascii?Q?rJw6AKmu5FIrgI/osk8DzgXY6NtCZk0lSOUcggXQy2/gSp/XvHeo5fi85GO2?=
 =?us-ascii?Q?YKeSFVHQQaNjatYp5rCVjCE3cXQY0mqFEFt3LfMz0jRrLivsRUEhwl0e8LV6?=
 =?us-ascii?Q?9/QYQWIl8bOvK+xahtqFYdPvoEgDTkv5lr9SduMV5LXjDkh2lfBX8IUaSiqs?=
 =?us-ascii?Q?GIJDehcQVTHNGDZce2RKcqjVAXx+e9Hz2oCcvZ5PUG4XHUJOxc+BD5FYp4U+?=
 =?us-ascii?Q?fC1xKimc1dvkPrmwiXFCXNljdLSME03J+YmNVBik5KWBbCeMBopM2+nXfhKe?=
 =?us-ascii?Q?+LQ+pZuC5H+ijW8h6c+JeAt1ZLAi4zGX56K6RbBDvfULNPU+XyLGoumH1ogN?=
 =?us-ascii?Q?Iq6DjwI2eWydEWE+Go2G5X9ZDIwwOmYfyAW9/ZyPF1WMynKVfIc1QXmua18f?=
 =?us-ascii?Q?8P6Z7HO4S//MpAJ2WBdwByoF5K1fpsP9U3wjNYHbATfSoXVSu4j95E7De/A/?=
 =?us-ascii?Q?IYkp7JY4yRQ+tltegDHk5QPwlMQIrhoJlaAX7GYJWteFplATSihcGF7ALnYF?=
 =?us-ascii?Q?XgOjdQE90LMLpqEEA45D9M9BxJYJRCTTISJA4GxBDUlmZZ6pwIMCMAlct4ZC?=
 =?us-ascii?Q?5n3EbL4ePOvT0gykdXXkQLZ3vXX/taNBbY2ad89Ld/sEZfMgV2XubcZZjyGw?=
 =?us-ascii?Q?jkETOXv2Z3mNbWIQqsiSoL+xb8FleohSc2aTBxgDK31YctoMuY31YUp4meZI?=
 =?us-ascii?Q?ig7AVFh4H3XEybUWeIUfBjQypdxg9mPRgHn8+54rL9aU4fQc9YcdM7/hX2Ik?=
 =?us-ascii?Q?TTBEQluQuc2B605Ljfe/aLOiwPhu2UmZ/B+xmqgJB9XXzIVCRfM9ncg916/Z?=
 =?us-ascii?Q?d0zqDZgcdQlNUfDJ4t9DuC8QGiCoAbqquE5FP8wUcDO8u11Vv0xDRVF5tXj2?=
 =?us-ascii?Q?AYOiV3zBWDPkv3jgMvwLWSo4y3nApthwE4SLgLRC7UDFd1lJVhFszWApUSzu?=
 =?us-ascii?Q?FN4ORBnhinPP+jpmBmow2o78yg9GokT6qb8AHXYtV6+TzTPL7i9R7iZsTjT7?=
 =?us-ascii?Q?WcZVW0GjF9f9lGRcbB5EEQNIIg1szpgvYfKrE3ptxOqFXG4THEKOh6haIh3v?=
 =?us-ascii?Q?FD0ma9owCftkpmlMs8fkEJmCd6gqKeyBrNW1iUAN5P9l4wxLeXmivG5mMa0j?=
 =?us-ascii?Q?9hZlIRx4q2L4anhOeRtghgJHr65zkMaf40vT5byiz7STR6BfDzMRHTbBqgzZ?=
 =?us-ascii?Q?faoDR0HoR0v4AtyisR9+bh+FLY04HimlyZJRQpP6xYhM97KCIErEh4faDj69?=
 =?us-ascii?Q?8zmqf+L97jC9bUzhQpi2Yb0QVjHcJXWKjWMIF+SWjdBsrQ3imVCUL9+DcvEE?=
 =?us-ascii?Q?WF/w1XVWOYzD7kO53iLUUm8y1sqMJ2rOQNQPQYjSiBTCZD4MXdsDhJFZ54UV?=
 =?us-ascii?Q?lXbQxnKqWWbrCexY4pla2iq7CwQu2yHswGTqWu21FBGo2sbZfylbCNnSTR5i?=
 =?us-ascii?Q?fnZLtaJNYSGFYqegQOVH6cC4yDdYjU2IkMab91c3J6FLLFJvYJmTj3oN0KCD?=
 =?us-ascii?Q?LvadiA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b5fb33-65ba-4dcd-80d4-08db0921f60d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 15:42:47.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0VB8Kud1y79HtmM5ridP7CZ9Utgyvf0phe04xne7/7J7Xp0FXv8dSD9XC/Yh4po+1++Zncg4JF7/6cxfO9qwmV17bOmiGs+nrrUp2rs+yA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5846
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:27:54PM +0100, Alexandra Winter wrote:
> From: Thorsten Winkler <twinkler@linux.ibm.com>
> 
> This LWN article explains the rationale for this change
> https: //lwn.net/Articles/69419/

https://lwn.net/Articles/69419/

> Ie. snprintf() returns what *would* be the resulting length,
> while scnprintf() returns the actual length.

Ok, but in most cases in this patch the return value is not checked.
Is there any value in this change in those cases?

> Reported-by: Jules Irenge <jbi.octave@gmail.com>
> Reviewed-by: Alexandra Winkler <wintera@linux.ibm.com>

s/Winkler/Winter/ ?

> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>

...

> diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
> index 1cf4e354693f..af4e60d2917e 100644
> --- a/drivers/s390/net/qeth_l3_main.c
> +++ b/drivers/s390/net/qeth_l3_main.c
> @@ -47,9 +47,9 @@ int qeth_l3_ipaddr_to_string(enum qeth_prot_versions proto, const u8 *addr,
>  			     char *buf)
>  {
>  	if (proto == QETH_PROT_IPV4)
> -		return sprintf(buf, "%pI4", addr);
> +		return scnprintf(buf, INET_ADDRSTRLEN, "%pI4", addr);
>  	else
> -		return sprintf(buf, "%pI6", addr);
> +		return scnprintf(buf, INET6_ADDRSTRLEN, "%pI6", addr);
>  }


This seems to be the once case where the return value is not ignored.

Of the 4 callers of qeth_l3_ipaddr_to_string, two don't ignore the return
value. And I agree in those cases this change seems correct.

However, amongst other usages of the return value,
those callers also check for a return < 0 from this function.
Can that occur, in the sprintf or scnprintf case?
