Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1096D7999
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbjDEKUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbjDEKUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:20:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20712.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869A558E
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 03:20:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awQ/CYD7zCcoxfhf6cZbAaA2EzEB6xy2e6yVHkxTAkDFQMGfwub9vrTyBd38ISgqlAT3xc160OMqDSlFaaYrqR+Bm+y4d3n3wyFRNoHQGfJfYf5RNXzY5ShOFrkzoGkBGZpmJf3i5/qv/oHrKKHRTyLKec4z9KC3X6/ZROaQZ+VsgizwtMz6rah6QRQclgMj5wC0Gf8zdGxqJvaeDXBui3Q/qv/t7ioot3JPihfY4RAVvB/xWSpTYcBBtWVKyMvyZRDzdxI9S3MrxZzmgDxE8ZXnBAq+FXR1Bfe6wRMLMgTNDRXqKmlgKkYomqL8j8Sbd2MTfOSEACDobJDmRSw9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gvsi0Bl39a07lWiLNfP/NJXbGxWmOkV6kuDK9yhNOec=;
 b=djFDsNK1RnlG+gNB7sxsEuXlAJm/zx0dkt8+8dGPtgPMviCTQX+xOkG2Aidl3syz5+MIlVM6oJMAhCiLULRoi9XA3KmwR5IMV4xUhICZhFmZiOu7mVRZjbcns0CqE7GM3iKWqArdB8BpLdXYgwvLEw5RXxUCRZTnVUZIopFQTTKHs75+iCfV02gI+VEVUNOmfMjV2F/xP78/BxRlEQv60kWZ4A07cr7qur2BHY64R+DnP+rR+z/CcC5eKwBvIyzKRiospFXaZ7gv+R7mVCgD51P8meUlFVE2YgHhEjsiRL+S/TOd60G/9HSsuolEVR0tYGGpCv0NxM5pMNJy0hiwCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gvsi0Bl39a07lWiLNfP/NJXbGxWmOkV6kuDK9yhNOec=;
 b=pnFjzPNlOt+WkHlJZczjv0006TYjhjCP7IZjHsQ+/i3EELQwQgL6YsqK2Gs01CSXhHiF5tcvA7u9bGji7cHBUDMcVNGtIZTeCTIURcTNW9OdqaMjz29O3dAjV/zhtQJ5uvMzD1M6tV9E0MKvOCljOHA/b1NaEQPr+x/SkRfcGEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5766.namprd13.prod.outlook.com (2603:10b6:303:164::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Wed, 5 Apr
 2023 10:20:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 10:20:23 +0000
Date:   Wed, 5 Apr 2023 12:20:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org
Subject: Re: [PATCH net-next v5] vxlan: try to send a packet normally if
 local bypass fails
Message-ID: <ZC1LYEp8anZWkRFq@corigine.com>
References: <20230323042608.17573-1-vladimir@nikishkin.pw>
 <ZBxycrxU93mhgkAT@corigine.com>
 <87o7o2vrd0.fsf@laptop.lockywolf.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7o2vrd0.fsf@laptop.lockywolf.net>
X-ClientProxiedBy: AM0PR02CA0082.eurprd02.prod.outlook.com
 (2603:10a6:208:154::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5766:EE_
X-MS-Office365-Filtering-Correlation-Id: be3df3e6-f49b-4592-52e0-08db35bf5db4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4n5cDVnZhSnkOet1pIZHB6rLti8YRDKHV+RvZdJFJTVkvVieKeJREnlOrXoMNomAd5hlYvlS1H2b/wUZkY8xtIOYRndw0X3NyaHH603ZkIIYaZ0Fe1Z8MaF5xdbzz2jrW+6rbvtu/c4Q3o8gI7GWMmRCJM3VmVr3Bq4Jb/rK4zDV0ZyGc6nIIbpAvAISZW8KE8J/F8Vlb8eEyzy6kK3GSNzgQtZkBYy+awjUu6o4iqb1/7vMPRnQ/R3A8vwP1T+ieLuncEL0Z89zl7mgjXdzt2A0KZmA1Dyl/mN0PbWkbzidYdYbgodsiGAIw/hLh2Z1hiHKLSYtw5FCXirqdm/2qQgzbUGW2y6P5EZbpGjmV7RIAD9jMSwPESOf6IDBM8AyWQczn06GmeeVfgOarrtfvxV24CldS2GNseVVjqqoEIHC+EyW7ea/jZ8oAyugw1j4gBw7+6ISy6IrbhtqKb54ALm2dGeXjE7qdFuFen/Kc9v1+NQCWDx/m0X4xmCVHCxCD9M5hzyVKl0N6lXr3AUd0v0nxbYb/WFl5aRW8TdX4j+34pfSzMdA5w0iPA4FuvY2LosEF/K8N6WBKs+Su/uyDv3QDa+kz71+V6JR3CnpeX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199021)(66476007)(6916009)(6666004)(66556008)(66946007)(8676002)(4326008)(6486002)(44832011)(36756003)(316002)(2616005)(186003)(38100700002)(6506007)(6512007)(41300700001)(5660300002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OX90vzqhRVNKyefh6ywf0jggULenFBrWZdP86iiKDhjPmgD55+Ps42NyocNp?=
 =?us-ascii?Q?NvjIBdo0v8wD+FoqprS9zTZYx8KhusiVuTdXhhKwehMcpn3dFey7NwK4njm6?=
 =?us-ascii?Q?+wKlnGAK2t62gz6eG9DayBNNVTzoPY9L5yLd/1M/BzjrpMytymJcFGHZW0B5?=
 =?us-ascii?Q?lOHr93BGr/1ljy0XK327vFnvFpdfBF1m+TvZ4L8pb8+qG37bO5DBXD1GfGho?=
 =?us-ascii?Q?YZJonMQ/TB1gvb5Iw93hB4vHdywfCkQzBXDpG9UNTc5Y+kqtJb3Vg3khyhAS?=
 =?us-ascii?Q?aoKLJan7GKflf3rbrS0fHpFAbvSSsxth9bViG0j8ZzHCtLfQPSzA2vYM4TkG?=
 =?us-ascii?Q?6QndUvz5HyNBIjA1iYCJ8tS9BQwqeE23iGbDBtfZGCxTMvS8mKaCez5SqVAI?=
 =?us-ascii?Q?y6jrmFg7qiDH+mSmtlG4PN88kqyJyGVyfHGn0HgHonncdXarDXm3apYvOaUN?=
 =?us-ascii?Q?B+M8i+XQ/pxDdGfsyjbGlXe8/O9MCR0GoWB+YRJTZXTlHR/QdJq3MjkCkoUF?=
 =?us-ascii?Q?ViFnssVlTxEQExoS0/f9JZeNLBNKmNJMHLNUqWMNpz1leUz3sqPwiKj3QplH?=
 =?us-ascii?Q?2HNa1JFF5gvXz8wvBoc28GJHWenxJC8khGHv3+1vxyBVyCBcolZDrp9mMYOW?=
 =?us-ascii?Q?82KJn+/uJi08IQChmn6s4ipOIyNfTBTcbt1qoJsofTBy74zruUKet9QhWqZ/?=
 =?us-ascii?Q?eTR2IycUz34me1YXbvBfGGHmcbojNiZbs5vOJM/GSQsd4mTKFMDkjDP3hHaM?=
 =?us-ascii?Q?csIqnwdDwzOGqNTeiGoDNlWHd8EJVI/XNE/s2mRHtRLw2wxf285FcAPdyDbg?=
 =?us-ascii?Q?ATyVmaORBmJJRaUiTIFU7mJS3WW1z20FMi2gjYURl/7oIs248g944OktB5oz?=
 =?us-ascii?Q?v+JfXZnTJfLS1jD83v/LnMb6S8Pa+dxqLUQFwDk1RIO3fnIIAI8XHMXOo2XK?=
 =?us-ascii?Q?fyFZZ/zClpzZWQgtEJT399Wakp4jt495qpZdyKtsWQKDIuSSrxT97+hUO8yy?=
 =?us-ascii?Q?WEzAN5Wa95rZtp6aQa2jKAhM2wmGWT18iGGW+MGxkJlpDjQb1A8hgO3n1ySN?=
 =?us-ascii?Q?6P6xr/QITFGJGteYxgNbf9K85DJw3KuP+itYoc+Adhx3Lik1VnCDzPOx8yEz?=
 =?us-ascii?Q?b19LnoPFMYREjKOMKkrevflDZs+MT57GTmOho3pXKTBLTedgJzYgj/Snw9b1?=
 =?us-ascii?Q?DeyLUOTZTJ/9uNpvLiWeoPh2vAIoUFq2IoXzWWw1gl2ca8sd5P2z5YZFjtz/?=
 =?us-ascii?Q?/KrVYHspaTh+AvBTTwXZqbyQDpTaY8rwrspHEvcHHsK7/Z+hz6Bz4CUEMFRx?=
 =?us-ascii?Q?mz4flwCa4fcmraPwb+aGYiQDdUP5c9hAj6Q+lhfsDHpru10MpnYGUx77LLfF?=
 =?us-ascii?Q?S4BLxqu5ij8lvvhS2Jv+DursPln+naNDw+FfAP6q1csI5kIzULBr+RFu4ZY0?=
 =?us-ascii?Q?EfXV9XdMWlRlwdZCLzr524OhEQmPsd8ZLUUDK5gzT51SciSgV/CNuDFrhHfB?=
 =?us-ascii?Q?tYM8iZokgFdsaMvsAihz/iLVIs1xENGwJPVSW0tBSUvhfJpYQ0FdVGNe3OSX?=
 =?us-ascii?Q?qLUkiTAx7sZlTfaZmhYvqE3nCAde14mADilzOA8gKiLqGTM2lufVv4elLUp4?=
 =?us-ascii?Q?mXltRzzpg9wRXfG7JII35AOvsw9PB9zeJbKqJnZxYhziBwZbV+XQnIa4pPaG?=
 =?us-ascii?Q?P4Oo+g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3df3e6-f49b-4592-52e0-08db35bf5db4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 10:20:23.1854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZoVZ9WK9AFhKWhnKNY7OVN5odU1qxnHKXyPCYnsbxTDNezRxZLHc8NDnFb4TH3ULIpSFX0A4WCujgm8JS7WbDH4UwhQFrBe9b9v145gG/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5766
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 01:05:02PM +0800, Vladimir Nikishkin wrote:
> 
> Simon Horman <simon.horman@corigine.com> writes:
> 
> > I'm a bit unsure about the logic around dst_release().
> > But assuming it is correct, perhaps this is a slightly
> 
> Let me try to defend this logic.
> 
> In the previous version, if the destination is local (the first "if"),
> then there is no need to keep the address in memory any more, hence the
> address was free()'d at the beginning of the "if" (and was not freed
> after the "if", because the address was still needed at the userspace
> part.)
> 
> With this patch, the "localbypass" creates one more branch inside that
> "if", which is handing over the processing logic to the userspace (which
> has no free()). The older two branches _inside_ the "if" (vxlan
> found/vxlan not found) are still terminating, and therefore have one
> call to free() each.

Hi Vladimir,

thanks for your response.

I do still feel that the code I proposed is slightly nicer
and in keeping with general kernel coding practices.
But I do also concede that is a highly subjective position.

I do agree that your code is correct, within the scope of what the patch
seeks to achieve.  And I do not object to you keeping it as is if that is
your preference.

...
