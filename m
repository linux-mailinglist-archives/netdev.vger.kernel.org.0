Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C016AC982
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCFRNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjCFRNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:13:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2126.outbound.protection.outlook.com [40.107.94.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDE49758;
        Mon,  6 Mar 2023 09:13:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxTzOqPpF0CP8Ixm98Mj0O40l+jdlt8iXn/1oRGjVhttY7EsvrhPM66/5wAWIXI8dxhwnTWhbFHnWsrmEdtmoF1ZWp2srwTtlZYtySm50trvdkPtyx2RsuqBss4d9KBPa2CxxZzNaFUzRTwhbJUGcId5cZlSJkTVW5+AqQFjS0YZhQJ7Q0ggcrj6hjVM7I1iTvUjeo+JVNyWI5lLXppfEVdHvvfX171wNREaYeyiHmk50VccTs/AsBnFQAaAtSFgV4C38jbn3VRap+YxuH0yudekIidGYy2/0YdS0Iu0oBtaU7E94fjv9kK1hc4HjlkKEQSWSybWqu5BKPqVCWTOGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/AUsn3s/IENOiIW8+xeqgk74qSj4/Zkr8PiJE6011w=;
 b=geevlblFZSE1GDTW54ZqPtsCoTlOw4v2HIKK1A+hJzteNLr9iqet2fDU+YZellh0UUOCOTRLnGyANk4RH8fq0fLiPM3oCvlXFm5sUDfGG5Fx7H2QJDKUmgOEWy2A/PoqZEL+JmGh4WJFLWW8rUhTHD1gno0Z9AHrZpp30IICb00xEbNQlBqbO1wINbIsLWBgYZIMCQGnu0EoqPaaPCLJsuDvIMCCL50er9ypc2E/m8p/Qap3Ed2F7X18uWzn3DIxDSItN+6wvOvPNmXgHR1rNfaXVD2lRJw1cP7NFJD7YIT0ZJ/XUi+ZNQpVKuBYrmpqTiz+wT4p8zTmOgLf8cVDOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/AUsn3s/IENOiIW8+xeqgk74qSj4/Zkr8PiJE6011w=;
 b=hVIezC/gOS556G/DXebFLheBglCH95aWZjgEhI6vIJyaCbluqZFgVKyecmmLeT90D5ec7/fvubHiLcHN9W5oKNg9w9GT0SOX8/dHPt+bLtfVCODiqAIUd70NGUhUFHy27uV06WkoyTnbtIpmIO9IN3kdbpqU9nfwgh1oRtGaAyQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5635.namprd13.prod.outlook.com (2603:10b6:806:232::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:12:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:12:07 +0000
Date:   Mon, 6 Mar 2023 18:12:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 3/5] mac80211_hwsim: add PMSR request support via
 virtio
Message-ID: <ZAYe4oATHMdqi/H9@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-4-jaewan@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302160310.923349-4-jaewan@google.com>
X-ClientProxiedBy: AM3PR05CA0141.eurprd05.prod.outlook.com
 (2603:10a6:207:3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f5270c4-2e38-487e-f91c-08db1e65ea38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SCXGzWDBFABeXhr4U4ng+dLhmNMYrB0ArKpS65gjKNP3XRcH8nRWYyrZbzndFDDrYWgEEYSb8sL+EBfUPd7ac7LcWT6bRhpKRw5kofqidjcUyrMRlscWGjoYqiS+nMXgdvWt3xzWHYoH8wd6EkaOvz6rOJVVKYElIxWZ0aQDBuk0Y45GKPK9YnHppjo0X+giT6llFLfVnpecnzeiQTyvZWpg31rgwNROERHuM/aC3hN+2R4oHmrjloHINkhHVUqJtuzpH+VVCS6xuTBoL/hnvmN94VS7EZDGmOdZ/kSn1tQi3+ZXkimLlArWRH7h/1JiX10ALvbiNXFCkTx+OyMmwi3AQ5DyUN5GspyqGffAVR+FSnbuQtpZRm8KUqPMVJsCARMPYnmEAEOkWW/KatI+H3knmjo04kVy9s2LLUZfK6w3sB0e3YVc/e63q1rjLqRLAGPJCs0hTnh4ksoQ3aopsuM7d5UyYHYShldKQU9OUNR2B6GbxW/pP2a4v40c9ZCNzUBsMUEjMCsrlaMd4f4OUXp4poIk0o6y+Q0OMz7/c5ea4lWlSQATSBh1jKLy1nAfZsx5L5t6qcVO8gkaTrEqpW8bBabfwPsUFKKZ2qzxWPPiKaBXcjNKYjOYPcwd3/ckxo7aAvK9WXOJaZRohWBddQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(136003)(39840400004)(376002)(451199018)(83380400001)(36756003)(38100700002)(8936002)(478600001)(5660300002)(2906002)(86362001)(186003)(2616005)(6666004)(6486002)(6512007)(6506007)(66476007)(66946007)(44832011)(4326008)(6916009)(66556008)(8676002)(316002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2kZYozq8DqpMcTr2HtkASxyqokegtWT8ezoU3EIsm6HhOF+2H+a11d2HFYXC?=
 =?us-ascii?Q?ftYmWfoFUBvsvoBlMYGBlcHrBmLqZ2W4hgOFcuuCnnvQdHEZBZayXTys1GYJ?=
 =?us-ascii?Q?6e0txmSjfuYocyuCpfqsnSjyB/95SJxkDcR1tKSeb7G2WehPF8Z4f6c/9MG6?=
 =?us-ascii?Q?pMBEmgPhub+K/hVDf1RCdjRa37Eb4s8c98s8sQaWBGy/swQYivKJWS+B319r?=
 =?us-ascii?Q?4iGf93TUdFKumikFk3fRuVKOQjkbOzS7ugLxOdSud2aDPX5VXNYUIJ74GyMs?=
 =?us-ascii?Q?DZg8ZoOIlQ8gUWLCBOvrgt8vEN5RAmtrR3/LpsaZ0TRT1zwyk73DJYsxKqW+?=
 =?us-ascii?Q?iGQqrl7egflWcV66m0iU23SNHok5a1dxObhwgzkDCskXfsY5ObrE/hie9d3M?=
 =?us-ascii?Q?cRrW7z97FdRhakEefkj6R/27spSn/Cgt923bKf+U+YMU81YT9rbGnQ7B5yyW?=
 =?us-ascii?Q?2bdcQbtuPb8877Kx8FVThsP/58wcEPj3JmbZ0aWPb3hm//SeXmXT4EhTxkE1?=
 =?us-ascii?Q?lGYtSMsinwE2yWvNFPzZcHuDS39ZMV9K0/AW6oHS8IDVvttuygT5cykw/F6e?=
 =?us-ascii?Q?gjd39hTSNLHS8aa6PYXNsgCVUMpqr5B2nwgUzvmUVPumo3sessf6ZVN4q2TG?=
 =?us-ascii?Q?0ZUmyKBX+zDlcsg1MZ1cDFEu33tBQN9FvUZXEjoUI3L8JPn/QogUCfVpAvMh?=
 =?us-ascii?Q?8nHWM8OZo7/S4sdQ+UMr2gmYDuQbP5uMf4nLSFnis0iaWBIqkjw+kwZrT7g/?=
 =?us-ascii?Q?xHB3G1JJFSaSCp8Xar/TMruAvGO5kYJTEJGgMbX9G8fTvTrdmz8jKaCUWYxH?=
 =?us-ascii?Q?6cfk4FmrnNrX7oMNNnUvObQEnVjza1ryYDBma8KeSzJzsrTrrKUUGW8cudbQ?=
 =?us-ascii?Q?6uTS5rVI/dWoFPspmiK4dG1lV/EzO1lzW/XEjsM5jCsgIQJ0K74j1aCkXh8+?=
 =?us-ascii?Q?b9tql/xAWYqzftyFyhAPVgqqR66nasxMm9A1FOFp5OBcmNAryPkmEI9SEjN8?=
 =?us-ascii?Q?cyHK5DLtGKz/xRUzWvFJLWQ7cOOF/uMvCMcl4l/Lx2h7iFyGiYLTYDs/T4Qc?=
 =?us-ascii?Q?CiiEc+l26VEHAig9NSYbv2cDC0e7pmNkHHrl7U80ZtkR73hnDF/3pTfd9vWC?=
 =?us-ascii?Q?ICwXqlEhUYeecqaG8bUSrb6YYy49ZebjNz43NfpSxxlLrij7ZrwXYE5YKy2d?=
 =?us-ascii?Q?SjOrD81LqPxVp5y8CYogp3OfweR9YegagCtWAPsSlGsBvhloFvPBbz3BknST?=
 =?us-ascii?Q?ZeQp6XRxETDcbXwOyI0NRyXWTUEm6fTT1Ou0RHbZzFijSI4DJr/B+MjFoaTH?=
 =?us-ascii?Q?saiIu0QuQpIw5pRVLzhxyu6AyjEqIJ5+Upo8J9s5h7i7ztKUxVMHAlNzyf79?=
 =?us-ascii?Q?TrC4hd2f0Nv2MGLaHr/MJQ3Ou8J+YW2zevNRh4DoafLlhaTWS6LGDmH61oEB?=
 =?us-ascii?Q?65mDZNT+QwQ3bvnPFVl3BJRszvJznDfOKJDtr7PJJr5QbS+fyD9abd2ezYUA?=
 =?us-ascii?Q?Fo9jGIX54WZFk2/RUWyuz/pJxqoyx/hOx0hg4fUfMI61LoEP3H9k7Iwk91uu?=
 =?us-ascii?Q?yg29JuHE5Gyh1VNiEzCYyCCSvlcW/32JfJa18Ca4UfnnrqSB2+imTRDt2uIu?=
 =?us-ascii?Q?pQAlL4dWypnUrGL46dF1Y/BIEH0HTTSixsi6dH7NkAabAv17Kyt1Vvo4i6je?=
 =?us-ascii?Q?5VOoDA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5270c4-2e38-487e-f91c-08db1e65ea38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:12:07.6795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhpZneTz6VKHSlINJD+/pGR9O8p5Wp9zG9+ONSVXiDuILE0p9esYsIMmOj88uZK4KsKfBDRiQe5QUq7vRNHPst43au+Guy5qbL0yU9Dw/3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5635
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 04:03:08PM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> time measurement) is the one and only measurement. FTM is measured by
> RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> 
> Add necessary functionalities for mac80211_hwsim to start PMSR request by
> passthrough the request to wmediumd via virtio. mac80211_hwsim can't
> measure RTT for real because mac80211_hwsim the software simulator and
> packets are sent almost immediately for real. This change expect wmediumd
> to have all the location information of devices, so passthrough requests
> to wmediumd.
> 
> In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> mac80211_hwsim receives the PMSR start request via
> ieee80211_ops.start_pmsr, the received cfg80211_pmsr_request is resent to
> the wmediumd with command HWSIM_CMD_START_PMSR and attribute
> HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> nl80211_pmsr_start() expects.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V7->V8: Export nl80211_send_chandef directly and instead of creating
>         wrapper.
> V7: Initial commit (split from previously large patch)
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |   6 +
>  2 files changed, 212 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 79476d55c1ca..691b83140d57 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
>  
>  	/* only used when pmsr capability is supplied */
>  	struct cfg80211_pmsr_capabilities pmsr_capa;
> +	struct cfg80211_pmsr_request *pmsr_request;
> +	struct wireless_dev *pmsr_request_wdev;
>  
>  	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
>  };
> @@ -3139,6 +3141,208 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
>  	return 0;
>  }
>  
> +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
> +						     struct cfg80211_pmsr_ftm_request_peer *request)
> +{
> +	struct nlattr *ftm;
> +
> +	if (!request->requested)
> +		return -EINVAL;
> +
> +	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> +	if (!ftm)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->preamble))

nit: I suspect that you need to invoke nla_nest_cancel() in
     error paths to unwind nla_nest_start() calls.

> +		return -ENOBUFS;
> +

...

> +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> +					    struct cfg80211_pmsr_request *request)
> +{
> +	int err;
> +	struct nlattr *pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
nit: reverse xmas tree - longest line to shortest - for local variable
     declarations.

> +
> +	if (!pmsr)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
> +		return -ENOBUFS;
> +
> +	if (!is_zero_ether_addr(request->mac_addr)) {
> +		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac_addr))
> +			return -ENOBUFS;
> +		if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN, request->mac_addr_mask))
> +			return -ENOBUFS;
> +	}
> +
> +	for (int i = 0; i < request->n_peers; i++) {

nit: the scope of err can be reduced to this block.

> +		err = mac80211_hwsim_send_pmsr_request_peer(msg, &request->peers[i]);
> +		if (err)
> +			return err;
> +	}
> +
> +	nla_nest_end(msg, pmsr);
> +
> +	return 0;
> +}
