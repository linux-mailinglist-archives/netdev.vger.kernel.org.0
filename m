Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A15669313A
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBKNXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 08:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKNXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 08:23:42 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2114.outbound.protection.outlook.com [40.107.220.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F8022A07
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 05:23:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLYvqD/lg4Rs6nfGgaLePiqEYYELbaEQrscV+GWyphS3MV7v/gpiR4KWJ2DsPbBB+UKtEUysRvjC4T2sNiRWMeQif8HeC/xayqAvn6MfeZxUO9wIeR9E2KCpAoJxudElzF2XNM91ArvPJ73zIxF1tbamBgjTOtQsS073I7VuWBOD0c24y5uCUvZ/LuPBQ+SFhDE1+iuYON+rYCJv5DU5R2qWc/57v28ocO7ihe60glveN7nDJfAgL+SkrZBqT0Ayj5zzG5oU1C66cO3CmCXEi63WiP36EsNYoUwr3lByRqMIvAOO2P9o6XbmLga+6QsJTkUt+y9if/wwHvrWilmeEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EW4GPrrMX0TH2vkp6bWU+Yq+fgzDHnG73XizI1Ag/xg=;
 b=RtWBqbdCHriAF0ydTaJLEfUY+1r1TpzUtuC40ZuQN2T8fbR/O+2rXVwSeF9mZXsvC1e01hGnWgPEF29EIDFfv7cV9YyzEQ2QgzVk+lznoI04QSE7EXoAvNZQRt66UZpxz1OvjnBuXADzrloW4lM+Pwp8x7BCAT58lhUTBYNKZzXCv8KkEOB4JZ+XGuwaSKq582xjm2Qu8qGeqEbD+IuVBBT7ad3lReZ0RsrCslL7y9WFCHzCdt+J5lRiiwgEHPlxtjzV7yCNCfBFPVJpVjm37sCfUbfJn9O7/JoC+clUY5MRvGwhBtgyXypdSGj0gI4RHplv4dbKBOv2XTm8obC4vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW4GPrrMX0TH2vkp6bWU+Yq+fgzDHnG73XizI1Ag/xg=;
 b=qGhzYJlC1rBkp/8KEl9BTqlLjUvvizywtYpHOzS+l1dP0IH4lS2w9ejQGEHx1VopkHZVw6OikzdI3MLG8280G8/VeGtkUy71gelRiD045RnxZrd9QydX29Z8sE8nHt+sGTkbIeFK5DDhhMCWBSyW/LzYVIAa1AoOUzPoPUp+QR0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5321.namprd13.prod.outlook.com (2603:10b6:303:148::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 13:23:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 13:23:37 +0000
Date:   Sat, 11 Feb 2023 14:23:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, moshe@nvidia.com
Subject: Re: [patch net-next] devlink: don't allow to change net namespace
 for FW_ACTIVATE reload action
Message-ID: <Y+eW0E9HMPxndN2p@corigine.com>
References: <20230210115827.3099567-1-jiri@resnulli.us>
 <Y+ZDdAv/YXddqoTp@corigine.com>
 <ce11f400-5016-3564-0d31-99805b762769@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce11f400-5016-3564-0d31-99805b762769@intel.com>
X-ClientProxiedBy: AM4PR0302CA0008.eurprd03.prod.outlook.com
 (2603:10a6:205:2::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5321:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8013fa-feee-4932-16a3-08db0c332e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NM4iGS62vGt0WZGxG5HxmxGCKU4suQ7aOecTbf2Do11mQIjYSQWKt992RRzsPrMqG/wY1TzxkoMEP54dysZlPahNn9KpekiztFNyENymrIzV6NxKXRgyKDBQXVJ/ZvnM9FDAGtywrGXQYazslBaBUDKREgkqu376UKbzEoCUkXMGhbZTGSJMItzg4vlBvW7y7WFp3VUevDnOIV4RQXE/tyU5awg6TpJiTbIskNQmxv3w0YRt7422ktboGoDSl/nuJ86w8kMplmhttk/DgnxhkfzacMMGcXwhE3rp8VkyTOj6/r8o9CLmJykKxsn/U440WEhWfV7nzOb8YWhCZ9f14cotOlempqncdS5DR601z71WwbUzOQnBhp6uesdS6rQSSrMB8nzIIelYak1nTQNMfLmIowrgC95eAb2RDWdKzjCxQYJkU+rlEiTLi0kwlxsjtWEwDI7u521tGvQjQp4LDVZcHA/QHmL89hdnfsoEEeC6Wpu4RDawx/GNmyMOAQaOTyNmx1p52Nth5TWic6yLpcV/qNpo7bDQZ+tTNP7OydzoSqjznSt8338/ahbqka0SdaRRby1n1iiasaWMdYv6aztXSkFGratTUsZWfLpVQ0Ugfv1LfLWBe3ryIKHBlmLCn12Sa7oR9XZmxh8czBK5UuaCwqqKak8pWK9krOYUhtMiupKDB7sjp8hR0cQrY2bW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(346002)(39830400003)(396003)(451199018)(6916009)(8676002)(4326008)(41300700001)(8936002)(86362001)(44832011)(2616005)(186003)(66946007)(66476007)(66556008)(2906002)(6666004)(6512007)(6506007)(53546011)(5660300002)(36756003)(83380400001)(38100700002)(478600001)(316002)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8IhD3+i/bLKFAs6W+QJlLIlb16/IsXbo9RwnDMN7Fn09S6KSIydeNgXVg04H?=
 =?us-ascii?Q?W51LFscJvAkTRqbxkkxINkjmkvlicAr1bry+NU4eXkErU3JqtaBNysBI1xtK?=
 =?us-ascii?Q?t2jXg2uRrqsNDjhmSjD/P95hLm13nnRsh5EYfRfT3lss9of6OspUfq4VRcWB?=
 =?us-ascii?Q?wE9+wjurM1PJy1fQbLFLh9pky/GPQMICiuOzM8w53l4OThV/NaGvTfUXd0an?=
 =?us-ascii?Q?bo7hBKWpvOWOvRuEhR242PYQRPchZg4e56T+B7YE6ArtFBt5qepuT/5LOD/Y?=
 =?us-ascii?Q?3cDiIH+wKPLKfNHzu2KtOwgGGpvttHutQA7U2qIqyHJBToVRYL2gtxdnpTUy?=
 =?us-ascii?Q?hgllJOzcGD3sOKJpfFTwUoT11OOhA/7/EblvlRY+Buk5ZjjQQ+tyyCNVPlon?=
 =?us-ascii?Q?TMX05r8PStisjdLFL/fu/WM1xRmj9ACSBPlF95vy0v+NDkkB5yXLXPa+fU4m?=
 =?us-ascii?Q?aRtnjXjeiYiFc942T1FCrUjttQohrXXMJCzADqVxFyqbVWPGqDEjxvO0vMYo?=
 =?us-ascii?Q?R9gD+lJ2z5oOoAq3d16BWgpBO431nAhjyqYiTcBRSecd5d7OkbezuX2ysCH2?=
 =?us-ascii?Q?rmfMc+Iw408O+1/NkvKP359x0CHpHUUr9i+FJ95DLxwPAKSFk0SeGcU2ncmG?=
 =?us-ascii?Q?L1TSWDDBF+aRAtkzVdXj2cI5iMHEpoFrveMCVDKidm+cj5LS6BVUKRtYT7Cg?=
 =?us-ascii?Q?WxG5AbSGCVN/g/AOJGUlYy3S6CfQF5Y8jB1TAqIzoOcEMWl4mlQPNsBYq4jK?=
 =?us-ascii?Q?nJgDIF0TxAvtPDRRERX6eD0TJ1njGInEGuUU7wbSqCDuF97hu6f6qqVdc17Z?=
 =?us-ascii?Q?ZuNc5amNfkMcPvfGh4B0JTosmf+FL3obbHzCrqM8FsHe3dkmxktqqWoQKqQL?=
 =?us-ascii?Q?iSliRs/Nhb6NNz+e+a9f/jGdabL/o7Y0vWwn6GBiRSdJhu0tcd5snu/KDOp5?=
 =?us-ascii?Q?lC2MWkMJyKYq3BIsZJQTIxqZ/uPmllMlFMidpZgwkwj/Ip0i2lbgezpRSKUf?=
 =?us-ascii?Q?pnbWR7RO1NEXkerjJi41hS12nOOg10DgzWzCbC7ersCVOuegqYEQaQCebRyu?=
 =?us-ascii?Q?z19TZvDTJLsFdlePSa/qYeV+Fjn0HJRcWeyEXZ7S7x44KRtOu9XNPjpyxsGs?=
 =?us-ascii?Q?cb6SkPyq9dSC+MBEyxvkLprzGA9GE5HSrEjqYzVWeUk/GpJNT6HTpWY+2ifq?=
 =?us-ascii?Q?fcCUim3TjY7OOz6RklveCXMz5NPScwVbB+YaZYGoSX18QCJ3AvVWZXWry7Gx?=
 =?us-ascii?Q?/Rnf2TpT/AeCeSbkueprLwXPq1vrJ41m0wjKuuCLc5fJL72e3rHj9KKx5JZo?=
 =?us-ascii?Q?IbcN/HngyaPfTXeci5OoTSEpmi6QyGtIzaQq/iQANxjkWnU+ZcuUam2uJB/5?=
 =?us-ascii?Q?IACoEVELAWUKaxtZDcKhfg2PnWZ069Ut7AyIOLasgXrre/nVesD6lETqBrgy?=
 =?us-ascii?Q?UPZcwsrytLcBToe1w6WcPMfvhJNJ65JV30VHCfNjLooLZn6Q751O0+h7fE6b?=
 =?us-ascii?Q?H0FK0MSPIAWbjWOSHNSL/P/XJKzjXii07sJUnt/VUK/IGaJPBnrW91Uv6AMV?=
 =?us-ascii?Q?9RjFpXYv3PvyB6ea8eKAaKLA9SCe1aOojSyBYr7b5CA1TdY/Le9gTtmKScjX?=
 =?us-ascii?Q?q+q677R7FOyLbLUTMExB37BcP61OGzSnjsKWtPtR3ddB9AbNoKkaOIx+92HA?=
 =?us-ascii?Q?jO+fDg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8013fa-feee-4932-16a3-08db0c332e93
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 13:23:37.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nt+6kTqwGfsGr/S1HadMaM20oztITHq84E5Rw2bsBslNGVfxpCQd3pb5xWoPIisOauw3xlLUVBX4SY+lbr2kdPgLW32qMVJ6oe/wApkS60w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5321
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 11:43:04AM -0800, Jacob Keller wrote:
> 
> 
> On 2/10/2023 5:15 AM, Simon Horman wrote:
> > On Fri, Feb 10, 2023 at 12:58:27PM +0100, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >>
> >> The change on network namespace only makes sense during re-init reload
> >> action. For FW activation it is not applicable. So check if user passed
> >> an ATTR indicating network namespace change request and forbid it.
> >>
> >> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> ---
> >> Sending to net-next as this is not actually fixing any real bug,
> >> it just adds a forgotten check.
> >> ---
> >>  net/devlink/dev.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/net/devlink/dev.c b/net/devlink/dev.c
> >> index 78d824eda5ec..a6a2bcded723 100644
> >> --- a/net/devlink/dev.c
> >> +++ b/net/devlink/dev.c
> >> @@ -474,6 +474,11 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
> >>  	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
> >>  	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
> >>  	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
> >> +		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
> >> +			NL_SET_ERR_MSG_MOD(info->extack,
> >> +					   "Changing namespace is only supported for reinit action");
> >> +			return -EOPNOTSUPP;
> >> +		}
> > 
> > Is this also applicable in the case where the requested ns (dest_net)
> > is the same as the current ns, which I think means that the ns
> > is not changed?
> > 
> 
> In that case wouldn't userspace simply not add the attribute though?

Yes, that may be the case.
But my question is about the correct behaviour if user space doesn't do that.
