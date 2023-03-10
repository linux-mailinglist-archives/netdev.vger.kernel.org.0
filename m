Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016956B420B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjCJN7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCJN7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:59:07 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2090.outbound.protection.outlook.com [40.107.96.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66195BD4CA;
        Fri, 10 Mar 2023 05:59:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBdcQt+NHBUtVqGUsuOcYRi3R4KnFFm4qst5kG995lgKXJ7N0Ojo8s8Q2bg0YoXfBxJikxKhqDOGyHGvyr5ProH3Z3MMckVC80Bgbkex+wkwXUD3wUhKrb1mAhOZWZAnmUJa1f0lVR3cvOnmdC2wxGGei2WOGOsNMzv3V2wZZsZwLauMK7KRLAAHuTQBg4Oog9nLWvWqnMaTcmjTO3Yo/G8zIGGrU9BWrZazvSPkptbWw9d6T1OeKVRT4CxtntChIusgRgyuwxT5fF09OipbKkqeO83ow0XCLJZhVJiS7UMI5xmt6rOg9XdgGo5yN7QjSdu9LCio90I527UC1850ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ET3FXK120a72oxtLcK430eDd0IcVvxkDEy7D60l1JJg=;
 b=QZWxhwAjyn8CC1I8tnbCCr8P3AIm4R8TN7bO5PE4nof6JuYwAVNy1kTigmm2y4ABiy8f6Hi+ku79yovZZKFpSsJmEzt1PJ7qNde6KaPlYgWGabW9NvIg0amzEPz9BlyUejiZyd9HqAnTFcrgkGps2nV+D437rt4hnmXyZHZotspdLCyYdLL7esavuZ7CWx36/+P1cQmlMkS/0r9Pqb36Ucg699WZrlwLJr/GCKyW82eut7uBHdSLhnuhZgYG4UZQvLFshNZG2kurDEzVdVDrsGW4v3X1gfN/F0VGldO60CFRGpzHEF+lCRKzSPvQtKtobkjmXimL1CaV1gilWXCzFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ET3FXK120a72oxtLcK430eDd0IcVvxkDEy7D60l1JJg=;
 b=PRjh+mqY/dTqj0W1wf2FLlCaLxK0UfI7hZnbatkBVcFuO3uHkWth+bAonUFsiziCWWQFYccb/2ZyQApV1zqfYHG+Syf58g2jM4R38gqb/cdqQ4VNYGUBt1kqLiElCWq0Mk7lLGc2T71R6FXaLLTTLY9XyAe8MyoWb1PWWX3X11A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5855.namprd13.prod.outlook.com (2603:10b6:303:1c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 13:58:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 13:58:59 +0000
Date:   Fri, 10 Mar 2023 14:58:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, thomas.lendacky@amd.com,
        wsa+renesas@sang-engineering.com, leon@kernel.org,
        shayagr@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Message-ID: <ZAs3nOoT0GmsLfGN@corigine.com>
References: <20230309165729.164440-1-zyytlz.wz@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309165729.164440-1-zyytlz.wz@163.com>
X-ClientProxiedBy: AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5855:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e90db1-9ed4-461d-ac07-08db216f98af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHmI0b9v4XkU1Z9NLr9PiMHe4TwORkAckgXFq5KxeWDq8VPh1GgdsSW0d0btcx/QAV+9vjRPCduC1w83JTEv7JjjdxVMvJi2YNvPgjdF4yT0ifGYAXeBidDvVIQkjGchQ5YFe/OkTk29JLkXAQxjWmRZotzSt2F7OeHi1vjrggg/YFellGDJrgALfNlLQPzlxMoOia0cKDqDg73V5ylnMjnJhui2BtOAHdLb8AvesFNb5vJo+VPqGjcfzkJYVuokH6ts6dKlKAQ/m+5hKMshlIaapVBiCDF6oh2+84LbMjSBQqmpGGzjrnXvo6Ao0GIwaVaFuYCgxMX1EwB2bQVk8zIWpNl8B6hzHHl1/MqvUZuP4J7el0f+pn7E1yQq1HIkK3B3aS/iqF3fqH7HGG78MgAy1OVl1Njs4rBDU18p2F9LC6CGeJfHMKrQ81HHaATOBZquNQgFcXc/XtoMucl/T2ufzSqjc5h9Ya5fEwl/7K8Kn8ngv+W/IZnXvG4+84eOOx2OmRiQHsad5Gy0mh9fcRXit5Re3laZansQHNrpPOmhkTPDgKH5e40InpLpg0i/I0n8/SNknX5Jx/A1gJE6pzUj9Wa5vBvVkuflBT95j/+k3g5H5+LGBzx/E56U1LdKy3b3Cj4A9i4SWfcBwi2m9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199018)(36756003)(6486002)(186003)(66946007)(2616005)(6666004)(6506007)(83380400001)(41300700001)(8676002)(8936002)(6916009)(2906002)(6512007)(66476007)(4326008)(66556008)(7416002)(5660300002)(44832011)(316002)(38100700002)(86362001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YUqRRU6F8Pd2QiTlF5s9C15emJe0+gwlfW8HprauxyHpl+6YO2zORND1lS0v?=
 =?us-ascii?Q?WKRhdUX4inoTxBo5wCCb4POY7PezzW6La+MavDE7OeZJlcWrpFE73RPINqsD?=
 =?us-ascii?Q?kYcOIy5h7sK0GrFbLSmjkeRwDs6G+5ew/6C8aPSj3d3vA+n2CJJ9YS2MVTpZ?=
 =?us-ascii?Q?NAeeUHhw3Ef9T1+gLhJKgqjx1iA/eAw7NXMQEGz4LYdW6RFWkh5kmX6+Dc1a?=
 =?us-ascii?Q?NCu1jUaPGVk3WEYtUbfGCUo1CmUNKVX0CAVPIkYeTsg3pZiuOLlM1jcxJBpV?=
 =?us-ascii?Q?ET9qcWkBuwPFTuLLwvXnmQYJTI4gDmFPT0o4vX9Cmw/EFxWVg37gNgw1+egw?=
 =?us-ascii?Q?FuK0Rodzd+u2wvFpv6Gs+h25WmAIy+i8yImjCEwV76ocMxUKiARqHj82AZlQ?=
 =?us-ascii?Q?8AzDXiqgreZUzGFfmbj7T1iBY/aziEs+0UezPwAglVECDrQj2k2pPiOpkmrn?=
 =?us-ascii?Q?zIQBojyYF4VKmvjYMKQKkMAqmKc2UAYcoUmKx46j52Elnus2YuLq90kzvxNq?=
 =?us-ascii?Q?Bgu6gMCgX7oXNtNJAMMIj6s1LeMnC6pvEFF1RihyQXFjgED8xNa/FhjF+ZuH?=
 =?us-ascii?Q?oN32kN/e84qZ2ey796/07ILP8hoAC36Vrw8+lerfZTc12TOBuq5Muy81e4Dd?=
 =?us-ascii?Q?r5gQtN4dbgomoR3gDeIZtzXHzMOyDyHryNPT6ZjcJRdXsIWj7VHnIGabSzPn?=
 =?us-ascii?Q?ie6aTMO2NPS8seXvwvWtaBFi6DfQWcqu1O1GEQb0ny9kLtPXcjhdHltyEc/M?=
 =?us-ascii?Q?jm9ml0K9FGrUIEkUHikUDumyNiPgn1fYoDgzMOGSZJYOE3DlvZ03Sc7PPK9h?=
 =?us-ascii?Q?7stsHUatFMQl2ouYb7P1ecnhQt0Buj+vG50t8Li+QQLJeosaClOie40cyRPh?=
 =?us-ascii?Q?Orr9M0Zu48V9I8jBpI4qeBSRbYhwJBsVO+oxjLQ6c9SoCimMqPdeq0UbHhIB?=
 =?us-ascii?Q?QsUZpH7KmIjK+qswyIw/8XmtJzpCr010oAS3398TLh2857yifC2AzrrFI2Kj?=
 =?us-ascii?Q?4Ogh9uQsoRpADBLDRfJTGQT+sRfRz3cEQDWizbnC7JHK+JLVCLgeimV/JYH7?=
 =?us-ascii?Q?EOJT+mctkX25cX/YixOlwt00OAwWihBPsRzW//WvpRbtDk7duNB5ZEZ6xPpG?=
 =?us-ascii?Q?fu0gw/vdsJTbeoDaNpJKSsiTjgEyK6slvgtgp4YdavjZImjchCySgkPzoSBX?=
 =?us-ascii?Q?B/FEeayGdw6Nb318Z/AezsqZ2yjiDg5NW+SnbQ1twmHG977NFrkUd2lncVvj?=
 =?us-ascii?Q?HE4iKerzL1PXdbgyev1JiKxe6BN2QSPkH/N4lNmnZgWvmgBocW2tatP0B4Rg?=
 =?us-ascii?Q?PuBAhivvoToymillMmYyT1fZ6V+QjC1bl4CumQEcJr15rBEUWSVYbkdsVrPa?=
 =?us-ascii?Q?MAYpa5trM+WAs1zqb4dHf9DOqG6kiqcJCT+freBQMU1bNRn1xM+7aX4H0WII?=
 =?us-ascii?Q?pV1RgGYdSm38h64EVcOngIECaVRgD1OS+gOADbKOO2zsZDjkUXgma0rlek/r?=
 =?us-ascii?Q?8JNI5ZL67CKsbSsGTVjR45LJDMp6tFy51cxkraU+l1w8zrCq60X7JB/tKALN?=
 =?us-ascii?Q?cLSa/nUTWxYF92JUfDpmbMDkJJdFFJd9oZ+7cvlr8vEfeNag8WDZv45jLs+O?=
 =?us-ascii?Q?rkApK/eKAB82SyFa2ys4K5T9cVDUuNdtqP4R6o2afluXq4xtTllqXidDIOtM?=
 =?us-ascii?Q?mjtD9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e90db1-9ed4-461d-ac07-08db216f98af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 13:58:59.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rBD0YJ51L7/fYIgoWjIYNqsQMqpWAZSHMHSiregppdk5aKb9VOZaOnWxu+ZeJzFyb8EbfI0MAFOMJq0I266m2ZMioBtE0Rp8FhY8/c7ALQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5855
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:57:29AM +0800, Zheng Wang wrote:
> In xirc2ps_probe, the local->tx_timeout_task was bounded
> with xirc2ps_tx_timeout_task. When timeout occurs,
> it will call xirc_tx_timeout->schedule_work to start the
> work.
> 
> When we call xirc2ps_detach to remove the driver, there
> may be a sequence as follows:
> 
> Fix it by finishing the work before cleanup in xirc2ps_detach
> 
> CPU0                  CPU1
> 
>                     |xirc2ps_tx_timeout_task
> xirc2ps_detach      |
>   free_netdev       |
>     kfree(dev);     |
>                     |
>                     | do_reset
>                     |   //use
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> index 894e92ef415b..ea7b06f75691 100644
> --- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
> +++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> @@ -503,7 +503,10 @@ static void
>  xirc2ps_detach(struct pcmcia_device *link)
>  {
>      struct net_device *dev = link->priv;
> -
> +		struct local_info *local;
> +
> +		local = netdev_priv(dev);
> +		cancel_work_sync(&local->tx_timeout_task)
>      dev_dbg(&link->dev, "detach\n");
>  
>      unregister_netdev(dev);

This doesn't compile.
Also, the indentation is incorrect.

I think what should have been posted is:

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 894e92ef415b..b607fea486ab 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,7 +503,10 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local;
 
+    local = netdev_priv(dev);
+    cancel_work_sync(&local->tx_timeout_task);
     dev_dbg(&link->dev, "detach\n");
 
     unregister_netdev(dev);
