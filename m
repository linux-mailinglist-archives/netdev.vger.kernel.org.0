Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F304E6EA672
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbjDUJCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjDUJBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:01:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2123.outbound.protection.outlook.com [40.107.94.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916963C0F;
        Fri, 21 Apr 2023 02:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0bHgd+LZ08dq2HJzUjB3J/M9gt4Yo0rgEJ+/ZLbSDxsdIy6HarPU2cut98jOgBtnUS7lG06gtzhsRcXRd47DXVc7MJGldPYUKcRIPeNBdtED/DxyOiI7fd2gTeaHxqBOvRdiw0NIYhmDLzmu/jLF6y9pKEvS3FhG4Prp24Qk1nO5AEzP/pmrkKTVXijseqmhqvOZ5ehdzsHYvs4NYqZI3rKZ6csxNANO4bXDlsEtJULdeP4LiLIXxEivv5lG4cKygoiimUFc6VzKZXO9dD771vgWpAKhXcXvON8BQgQHNEIBqI79CKGF1ghwad40gCvdRWnPowg+tmvFQjDLLO3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQNXjXUOuOfNQ22c9rAV7qhXRXXarc09AHBsnEhqrSE=;
 b=KoLgOMBWa/CcLF/hrvTNSQfb9ok4rajUFE6XlBrqlJJorPqhOrgQX4oCWdUht91KdUMEa0ZflSkOujfKwCUPwDTbZoMrlm/cKBFZMeMdWXbFbKw5IbqvBtrdP80+nfRt395HppiM/1K8aKMpgGA8dfy2hEpTlU2yq/CKYSIel8QcWAjZLIdWdxRBomwgc6gEThsAtpeZpncPmWyK1bSVRISepnmOGM9sI/2DOon/qd5XeJ83ttVjclSo071aqqiBRgIBQOqGpX7lIP/KKFkZAZnsTP97arc7SS22AwPplNzCbZ67Ux6snjrtwBg2r8UkqI4zN4hJsLQRDZRJaYXMDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQNXjXUOuOfNQ22c9rAV7qhXRXXarc09AHBsnEhqrSE=;
 b=pzfMce0xh3Ycx8CTNNKL14tMCvrxeHcDcGm0JYVXO8l1Gs7boKnWv442P2AIGKfQt0WG9QR9ugFADkkezDioq4tS0ssxPKyzy0uAN9Ftkq/G2sQrnxv4iw9P0idrj+ccEXEAucsJafmLxZtZxKTTLRvIwpPH8R0ciBz33pewEHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5161.namprd13.prod.outlook.com (2603:10b6:208:338::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 09:01:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:01:44 +0000
Date:   Fri, 21 Apr 2023 11:01:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/9] net: enetc: fix MAC Merge layer
 remaining enabled until a link down event
Message-ID: <ZEJQ8JxeiZ1sxTqP@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-2-vladimir.oltean@nxp.com>
 <ZEFKjPR/VL6llxDm@corigine.com>
 <20230420170354.n76b53ws6bitcoj2@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420170354.n76b53ws6bitcoj2@skbuf>
X-ClientProxiedBy: AS4P192CA0019.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5161:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c488a0-c24e-47b6-08cd-08db42470738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0uz61Uq1j3aVekvscYfCqnkvQwriKpgTsLXf0OUKQXwZj3nnZRw5yiMvqRTRBmZhZUc82io0G06SYtN7FE2pnjad1lXJB7EkHr9svX7Kpg/kw8VzrcjU0rotIWf9eBQtwasvWFhAEP+pQoyljGZwQK7g2kywvrt2CNYTqGhVaARzd11DlfwBwufUkgoxlNFBXGJFxyTUqAkaAb6F1+hpQA2JGsP8VnDWcCt65ARcy+98E/PoJPqzUVJmq+NKS+rhGXePmfntlviYZhEIFbENp5R/zXOSyXXbaQ0CJqOla1New298jA8R9+r6BLNgHF5BZklanN0XPQ1fZfwzgJyYT55thiCrXjGtJKQg16wts8Vc2wRW3ABbCyW9Jlsu08B/ylbEvmPpIelpShkxcNpuJ6s3JdlN0mPFRhuK8eJ1QjmbbF2qkV4gNbfIz7LHbJDPNlZ7/53GpD86GdPuLvOJru8vviXoGMrOq28b2o+KYFl1o8/pDfTgta4EENT+r4gsPdRwgN2qgqbS1xtdUUQUguQpTT9tuuWOhK4RDaaNtWmA2t4JOEUNIyAysnQ04tp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(396003)(376002)(136003)(366004)(451199021)(36756003)(54906003)(478600001)(6486002)(6666004)(41300700001)(8936002)(8676002)(38100700002)(66946007)(316002)(4326008)(66476007)(6916009)(2616005)(66556008)(186003)(6512007)(6506007)(86362001)(44832011)(2906002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IoiNWkVsZVORxSIOnFlke8hkRWYC4smmpQf07cVvlvPzh7OrYoopk2r4eB8s?=
 =?us-ascii?Q?4qf41kbmyl6GPbUM4Ray1wkQSBvfn+ubXKBP8hYYuCSDGZok9HwO+HDY+nGP?=
 =?us-ascii?Q?BZjx/G+jKPLSH2NZpkAisNjvuuFt0+UblAo0bhybJss9/pwT0CEi6jEQoczT?=
 =?us-ascii?Q?Og5+SF037R6/PKbKUVNhsr9ropYNfvgOYYLy0nkCkQBNYGOosbXzztyeE9CR?=
 =?us-ascii?Q?3f92Y82snq775fTGf0DQApNAfRYECvSLynpQLzIF5gB4tbhpKgVjzfZPSonO?=
 =?us-ascii?Q?tK7sSkV4TAG2Zjqevl/TMblo5ePkwz0is64OWFnVMd2Gfx99OZT9p9MZqcn2?=
 =?us-ascii?Q?sl+yD2b67k2GQTjxjgmHMxUk7p7g7HVvwlCzuu/1RNCYA0TjG9N4+rZpZfRb?=
 =?us-ascii?Q?k2wIXo1ZqLcVEG1bhtHi79ctKUk0m0s0nhj/9KIUsACGpf53KzTcsvifSc+U?=
 =?us-ascii?Q?MIFc1lbI69MK7KySaX9yekCXSVarhLo8Jok370mtiP42QLqE9W1tsxyzy1gh?=
 =?us-ascii?Q?rmSb8t3/3c1q2q4U25NQJLuiWUBW3m1js6/35FD7iPcStk2/857b4CKo5x66?=
 =?us-ascii?Q?PFpnT6oH2qS3ebOYPamtpOSXWKN8ez71vWOLoMLQuxEPhNXDntEwP5DU0Pn+?=
 =?us-ascii?Q?OzU4f7xzyKDupPbRnRpR2dv57M0MYoJau2T/pPAW+GDG8h6l8LQz7JIuSF1A?=
 =?us-ascii?Q?Jeq4mngEuRifgmPv4e7EvcOMffQHb+YQvuxFe4uejKxXo8l5rnWVa6+jXcZF?=
 =?us-ascii?Q?uTU4BolRegvmgPAhf6lb8ieCIaAv+1PwPulzy9Ddc3eQLWwb+yu4D2cN2/ae?=
 =?us-ascii?Q?ESeHTuxxsUtOjs29VPku/m7RCefPKxxeed6qlyEawYe+56cboQdPBoqk1ZU8?=
 =?us-ascii?Q?kvGXulsqCWarJg/5SgiCZrcFw8j2UQCLW5X2DJWUiqdglJg/AhiNh/AyF1ho?=
 =?us-ascii?Q?xWJ/O8uWD0CcZShuJFu9ecY/Za1RNVsQA+R/2z1D6RU+bSV/HGQEaFJKR3DX?=
 =?us-ascii?Q?HFv5lNWV8wLkqL8DEe90nn4gREeIe2Sshup/22oAZ0iCAt4RnkqCCkFm3pB5?=
 =?us-ascii?Q?toUp8ntEfoO4zfZjha8HcOBDfRdjP3pGFxXZ/vJ+nmGCaFE9KknkEwX3s8Vt?=
 =?us-ascii?Q?uXlu40hhFHS33F1E4/9tV+LXGtxeSZsDNEvGbvP1I7yMYDR3VbWxz3X1z/i+?=
 =?us-ascii?Q?piE/wi+hTeTVr7j9PJb4yX81RXIWCGgnLZlO4JzPq+EnTbxAOO4Q64YF4BI0?=
 =?us-ascii?Q?di31sr0QW9NVChEiYVoXpUg51mIZyZUkJ9BAT7wJJFS3X7j05R7DGWr1Ic+7?=
 =?us-ascii?Q?JcwK9CV/GZR8pXk8enLec6TbmIvlaG/UyKhWgg+s1kP6H0GnPMVFQbevYVB3?=
 =?us-ascii?Q?9eIbDuxpBbpO8M9tDlT3RCRsz3zob6GRQ0HPmbQGEJCQzSLL5yIVs0F51l2p?=
 =?us-ascii?Q?lNDEUgDaTLmNFX3h4EiGQMkkQzEhEgZDQNPbKFvim076FwX0MBy9kkH68R8G?=
 =?us-ascii?Q?sfgjoDlzJm26bztkNy/ozqBYkMojkxemLKcUDGb6UK8LlRw3da3SmWwYtt7F?=
 =?us-ascii?Q?WpjConI3zAlRJNUAhOFbb/aH0taBlerGX9Qn8IguGZkRCt+B7MKEC7Aw2aWz?=
 =?us-ascii?Q?RZyTd3NROv+sDuLzy5IT3W3mDcn5xeioMDOld115KwpOuPrMEi167jryUfZJ?=
 =?us-ascii?Q?ZPEOOA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c488a0-c24e-47b6-08cd-08db42470738
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:01:43.7321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIbqg9N+gdxx/UoRGddSR7vy8avuryFGZShHowo9jx17Z0PCvNRAM6on/esLfQeS+OMhuenMD/ZnLc9oMZ2FyoQNbU4fNTgBUy2HrMpv5A4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5161
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 08:03:54PM +0300, Vladimir Oltean wrote:
> On Thu, Apr 20, 2023 at 04:22:04PM +0200, Simon Horman wrote:
> > > -	/* If link is up, enable MAC Merge right away */
> > > -	if (!!(priv->active_offloads & ENETC_F_QBU) &&
> > > -	    !(val & ENETC_MMCSR_LINK_FAIL))
> > > -		val |= ENETC_MMCSR_ME;
> > > +	/* If link is up, enable/disable MAC Merge right away */
> > > +	if (!(val & ENETC_MMCSR_LINK_FAIL)) {
> > > +		if (!!(priv->active_offloads & ENETC_F_QBU))
> > 
> > nit: The !!() seems unnecessary,
> >      I wonder if it can be written in a simpler way as:
> > 
> > 		if (priv->active_offloads & ENETC_F_QBU)
> 
> I agree. Normally I omit the double negation in simple statements like this.
> Here I didn't, because the expression was split into 2 "if" conditions,
> and I kept the individual terms as-is for some reason.
> 
> Since the generated object code is absolutely the same either way, I would not
> resend just for minor style comments such as this one, if you don't mind.
> However, I do appreciate the review and I'll pay more attention to this
> detail in the future.

Thanks. I agree the result should be same.
No need to resend because of this.
