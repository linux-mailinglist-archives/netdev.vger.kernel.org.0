Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419DD6EC1BF
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjDWTLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWTLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:11:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A67110D8;
        Sun, 23 Apr 2023 12:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cS5LWzoQ8KhhHv4BwyYtE2JlBUeSZkC25LvjQDVAi0gVMrSA//Kq5hpCKiyEkPpcRMSmSfWmsLpfb8UxZVTydlmgsIAOEDkRlgY3pFRkuGciZwwRQ+7CuwsfX9OQaBysI1Gc/jxsRjPehrMmDpOkH9pVkOOOsXjGBDgbN93fHQN3VJ8rgng9XfzTCvuSKXQ348yMPHPyHmzHf+2wQ8Fsja0eFl2CRi2mdTsgThCEgoxo0b2U+FA59by7xqyn/xiop5nfofC1DT5cFakrpaNK7BFhjKPyqFbXPSsDak7JRTQEothkrDeIG21EDA4Y7Xv0I93a3SJ6Z9OQpMsfrI4b3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiAUzErr7+cLykmtSpFEAOicTt3f6ppSgRxTRy9xSSM=;
 b=gN/wpe7wqyzRsZnmspU1rDs6MuDRIIREj3LA8tAAOH1GnjGm1X3l8fFOt5wgeWLEwpVPTKKGn0WXtTGIn5LMFupHz7tMGWBM7zZzCwBK+CNwj98QtLL4RWtMflTLge04pXNmT/cbQiXu5aqvk+iPTtXZhCdNEHGKTas5B7wtOmoXL6zG/9v6zg5enEu95gcH6XWJlo3hHVWzKVUlL7tbIEOEEeCieDoV9rX0yulChHCeCfgvNbSJ4IJPf5KOtsgsnhOkAKJf8U8Y2psOB+BrypQ8pwgEBENj+cf8jPQJnH8AsFKXMSi3/SIRUufb5Kl7DaCLIsNM9inpVZpGTgc8JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiAUzErr7+cLykmtSpFEAOicTt3f6ppSgRxTRy9xSSM=;
 b=MWHQLK32FdxTHl3OBxqubMZQzWefrgQ2ORBvNTRORTI+o+173zkPSGhOAEKKCv9g7uOp+Be4XznhpbLCXh2mtC2TSFQs82ixXAMKt0QLa71p7s1bI+M7L0SEykJWXYzb6Sr8RQN0MLZXO83RIQNXEE8pVM7Xlib9dBy52jVmVUo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6180.namprd13.prod.outlook.com (2603:10b6:806:2e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sun, 23 Apr
 2023 19:11:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 19:11:17 +0000
Date:   Sun, 23 Apr 2023 21:11:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     bhelgaas@google.com, davem@davemloft.net, edumazet@google.com,
        haiyangz@microsoft.com, jakeo@microsoft.com, kuba@kernel.org,
        kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        josete@microsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Message-ID: <ZEWCyaaq+wzyyQp+@corigine.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-7-decui@microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420024037.5921-7-decui@microsoft.com>
X-ClientProxiedBy: AM3PR07CA0075.eurprd07.prod.outlook.com
 (2603:10a6:207:4::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 047d4261-c892-4121-0488-08db442e836e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sA6L8n85bv2IIlK617Ln0LkcST17PiggfC2DnCxq1vgatQEKLLJ4buHDHdqSSdochKeg/s0ebwgVr7+PsIlobR+4jznXcC/tkvm5vDw9xPaCbAbmbFpAMFEGLxDC0XQg+ZJFMPVOVGs2h15RKBj+9cb74cFV7VeYiYZ5NYLLUE6/mRwP/8qCLp4nUAXZV8pjc9ja3UWM2LnyvkYQzBzpi8l60hk+t1d2hEKFAF57uS7DsCVkOoECYVBN4s+LPd2MTkP6RwMgnG+t4cuBWsy8xpa89+76V71qJlyJPni0wNBfgY+lhrzAKcrZBbGk9ZHufZsjeZhHWDPAhDdp2tPDNUi2dq0EbB3oTKdmzGsE6uEz3ympgOEl9P8DkP2DKCWzDgcWHAZlDUOSH0u3u1v75vWRervI82ylBoV4Js0fiYdc9gk7Y76cFIKzrkgmJ8TimZWtH+dh/0m1mHfHCNi3qyuySB2juVkjW1lYxZ4lib9o2+SsKpwGR3WRK8GlWcvb6T+szkKM7xMLP1bNPXfgsHgmY8TYdA+XLCZjmjJ4+Jvf7W4B0jcKNOXKx7pc7px5ls9gtyaVLR/nd0XaZldhM+sCWFMls2yiNSpCtw7dkc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(376002)(396003)(346002)(136003)(451199021)(4326008)(66556008)(66476007)(66946007)(6916009)(316002)(6486002)(6666004)(86362001)(478600001)(5660300002)(36756003)(2616005)(7416002)(8676002)(8936002)(4744005)(44832011)(2906002)(38100700002)(83380400001)(41300700001)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?buavGz16QAHzqfH0d1YhsnRTvpoCmqNHjEQymMvijMpiopjxZpJvcKiEeI5z?=
 =?us-ascii?Q?rITOOEeGF8bUDxoogj9EFWlMTlb5/cIGCSgn/+QS+A+pPcMMGcWu+XoR8tnP?=
 =?us-ascii?Q?GaS/4h9G8jB1ZFhMjZ7UNBHbNpUKUoMrlUY7hGxzq2OlPa4bOepTHLS2v0Y5?=
 =?us-ascii?Q?D/o580ZTUB27Leos2P0FVMiFOfVo/QUba9XbfliaWiOrsBUdplnhh/GxIpc0?=
 =?us-ascii?Q?nboUbYRHKJ22/7VoJq3uECoh7ETBksBhnKqAw4wMWFAI6KwRZ0+3g1Ct0PR3?=
 =?us-ascii?Q?bbHfaflAANqgJLKR97/kkRCre9br/kHh3ejyyRPz3BrTA21ZbPTEA1YWizYQ?=
 =?us-ascii?Q?ZQA3LWX5RGsSWT7+ZimHpJH3/SPa1DzaXjHWyFWbz5kjCARPtMdMX6RHzaUe?=
 =?us-ascii?Q?zvOBT6gGIPw8S207vAh6ydTgy7GlvhWUAx9THtIjsGUF2XKMSj1pMHhW0cPi?=
 =?us-ascii?Q?2/EHsXu0mNc+JTGxJDgI3g8N4ti/CZ9M1YaNgdBHMtHYvOdNKq1eGD3xnLul?=
 =?us-ascii?Q?iVLVCxj5Atukw/26/jrpYbA0kHIYqkm/eTVx26lXyhOre8RHIt5ZhQvrD0Ll?=
 =?us-ascii?Q?wi1QUtbNh1kvosnSsr0R6RgIV1fqNV0a8DbYFsACnepHF93CEKvSwR2CxZQS?=
 =?us-ascii?Q?6EJYEYESgWmcFjkqN6qALfB/lCInbGNQRrnov3Knvj0WJOzE2C3SqskzSUhM?=
 =?us-ascii?Q?fG7jHezG66hw6WI7OqILp0S7A6if9BH8u7U+BFz8yPSOY7EAlg9niUBowHPI?=
 =?us-ascii?Q?HGbPLfUkPH2JmiZWFuuD3Okp9Vy6q7G3nupA8lgwOXj7UwgElQJYC7mGcM71?=
 =?us-ascii?Q?cksSgJJzrHuSsZzi++9d/LfZJFkFbf3RSKS/sV3HFJ5PumsDkh7zf2thmUaV?=
 =?us-ascii?Q?VH+R9WdqTtTz2ycA9pNQiuS6I1zW0s+hqJ4fDVhFRW7VzmsFY9wGg7XeTbRf?=
 =?us-ascii?Q?gfS9sCNITNvUsIWSEbPzzzMJ1Pn1mVttNuZZbNLgJJSOG0wmt7gxb6/kDrkt?=
 =?us-ascii?Q?XsFCS2ZL3yEf/MdBu2YDbPde5Y2F0T5t2trglYCytejl6q5LQhlypwh0SG7U?=
 =?us-ascii?Q?qRNq/KvjiyV+Nm9ZiCLFFxcpgl2HvFvaTp1/lnNU27hw3unMNpLtyjJCBxLc?=
 =?us-ascii?Q?BlvDSe2ymVF9ZS3ti7W5yTHolMeF843UwaxfcQI/vl6ImTIjIdgiib5YeBHW?=
 =?us-ascii?Q?GW4z3CTc7BHAxP04TpDPiB2uCWQutiBTFMbIorzcNycjWEY+XXFM/jCQumDG?=
 =?us-ascii?Q?qUcu8Y4UHBqwEHGONFmoiax212x78xnS31iwDvgbnzcyiqCynXRUh9opglsf?=
 =?us-ascii?Q?cAEFfJMrrVRecTFP5k7VhUnX8/K+tRyiq3lHl1kr4gTXMrfEUmMyuZCR4133?=
 =?us-ascii?Q?/81KkWzUhK3k0iJIPNEGTPFydR5jhH1Rcruw7za4IPGH31YPp6CQ0Cec9gJT?=
 =?us-ascii?Q?f4KGx3A0u7zIYfQTQxZBWMONWSOslf865e9aSVBjwdHMHEHIx9KoNcDf483f?=
 =?us-ascii?Q?vxgWCPSrQv88qewLFqumJJHiBLXXlpndP3Nl3FSKpkT2lvhikacMsnkcIq8b?=
 =?us-ascii?Q?EKKQoD3Lm0218yd3QjsNc2AQr0+BGAVA5EpLk000GwJPY8zwPm9fvNFRafSi?=
 =?us-ascii?Q?tsD9szSROJi+KzHlEVy0w/4Y0f6+Sgcqc3rAEVWM0c4Rxerk2tp+wQgX0W0N?=
 =?us-ascii?Q?8sNFig=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047d4261-c892-4121-0488-08db442e836e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 19:11:17.1735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBFXTLdOJWrAVSVmwSONHPPLmmilPf61sIUt8ttDmCtQZZlcwvM2Y4TQfj/mhhkF1oyYzo4YJNDCaDHviGdeWL8QQTTslD05tKM7ZoPEDR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6180
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 07:40:37PM -0700, Dexuan Cui wrote:
> Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
> turns that grabing the pci_rescan_remove_lock mutex is not enough:

nit: s/grabing/grabbing/g

> refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".

...
