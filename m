Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA606ACACC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCFRjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCFRj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:39:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20707.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::707])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F683250D;
        Mon,  6 Mar 2023 09:38:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3IJHlvYc5sKxkB3RlMRdQEXdtA5HAHb/YWlTx0oBRbwa4xcxS/0zGRc6bNdTjcuEzbtQDzhtStbcIHCiMtWuKJmXXVguoZO82x1GOhd3Nwx85W8+E7bcnb34Z2etStYLjqHjNKz5bG0lc3rStJEL7N3eA41FCRnEFG90+JPI+eF6z0ApArh/LDbWZYd0AjARnIT/1yDNOrTi6Cso6ZRYOmZvAkzbkSGcHQtKS+d/dVdWo8a95eD2Y2fbQ+n5abs7/mEogZlBlmP0y/EV8F7C0w0sABzHgVdh92770t9AB21ZtVI8CKF7LXH2yAWZbYzK15DpuUOjz7Ype5UmJTztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91MRoPwjf0hD00gJa0vkmTWSlGEh0e9j9DQdscgW6Vc=;
 b=kBJZoyznrFjCV/8uiFPJJLQ8/abebmCL8y1sRXU7VF/LHRHA94OVccMNEOmfa9ME4pTeyftxWdIo5440xgJicXEyMN+MeMnKOyy67dkqTYmh1Yb72btT5IIPqudul45A5OInW0N4+s8S9pP92qor33nYt/hGh2PgGR617C49+2PHpIDS/XeyXehnlTasEVR5PAY1LhziC5QdN3W0PdFU+u/vR/bvnPgbJ1I61JJODyyFd4cIZiM4wa0P3WOCvfxMJLwfWlfNeKFPyfs7i0pmWlF1Bgo1t7qER76Evufu+ZT/bMvYA7nVbt1PizD6bj8jfASd8ARUHdVDQFCVDtkY3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91MRoPwjf0hD00gJa0vkmTWSlGEh0e9j9DQdscgW6Vc=;
 b=EZXFrEFpKKnorD+uHuIlScfLyyt6mw4+SLwQMI0ys8NI3DvDkMYu501GIdLewsNkj2RGP5gIQbgdb1+YbgTfphujTMHYuUF02uKn0dNBJl73qEKmcpRGOcEsnlySKBptvgFrcneS96sM3wdCHd8bwd+SFvJfV1sg+LHxoqmpnCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3699.namprd13.prod.outlook.com (2603:10b6:a03:219::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:37:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:37:20 +0000
Date:   Mon, 6 Mar 2023 18:37:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 4/5] mac80211_hwsim: add PMSR abort support via virtio
Message-ID: <ZAYkypRT+mIdQr/v@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-5-jaewan@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302160310.923349-5-jaewan@google.com>
X-ClientProxiedBy: AM8P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3699:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d3cbf4-2747-48f1-9fc7-08db1e696ff4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QVnrMmB3JgBJKQr3zo8RVbdGHGk3FIQ9FUhBF2+rgVh3sKIWrCjaR2xYmenXq+rH/sUVVQS40XXN0r+DiUyLY5AaHiIClQkikqnwSKYmQS1zmcyU3b6UHYlmJSTKWKGotG6SCtsjxcft4p3tXF+lGiD6yq3d0VJfIHm8ZPy/AKQ68TzRa6QqoNp5TcLu5ZEWg5HXfY5YqzQtVWwX3cPa0kLzw8yv0ETJFa+zaIb6CNBjEA1RR7k19tVsQ4qRzxELQMv8Mqvp4GxsV9JqV0JvmA3ABjlIGNRL3SCV3RHd19XiOVNCNo3xUIaZmk7Vs9gbZa7cl8rAmJUX+fMcTAyWrvl399w+LBJ85BYeGJtCqtPPaGvs9qf8b7T7eqDhGd/KRKDmkqPalv8XpH7hYVeKZ+ki/ixLLPmNsWaOrZg5T5AsL7+GcYk4065aJse3xoKweFBk+4BpTIdks4gpqYI/Lfb5toGY4tfZmZMUjnYzlTps6BuC9+jCw0Y+oScVeClamiLQF9zKKoCl+W5PoPYzFN6YHsPOQSgvt4yFpAXgQWgL1lJoZ85i+bRFjAI3qNZszXgxxbPSjakqZnGRzaaPD4mexgIy2GU2KE5i5PXcvEtRZEeVpXxK4lB0A+tkeg559YOGDOalbLH2wspDaiIJkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(346002)(39830400003)(396003)(451199018)(186003)(38100700002)(8936002)(66556008)(6916009)(66476007)(4326008)(8676002)(41300700001)(66946007)(44832011)(5660300002)(2906002)(478600001)(2616005)(6512007)(6506007)(6666004)(6486002)(316002)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ut48Q/va7swmRzILxiZR/0nAQBRaV5v8llrBmkIZbCQo8nzJa4s0OxH3e8Gb?=
 =?us-ascii?Q?Vv6JfGVPYcibYB/KpnVSktIInqQ7DBGerBGfIYj6CI/SbHYHWqnDsqUQKRSv?=
 =?us-ascii?Q?+J99ZsCu0Y2bUxPrnmzOOtzZgeKGKqUv1xrk6Tota3X4l/IMzETALblPyKFr?=
 =?us-ascii?Q?y3HGRZZqyuMMCHoTwzkH01N4lhtM5rtjJq6zaw+Or8MDW5tq6i8IpsQa5rBN?=
 =?us-ascii?Q?n/+A9maNlOMvMY5wqeJY8sJjMZrJg2koCnoFDWzeP95EYuPczD2X0pOL/XO4?=
 =?us-ascii?Q?JBSpWdpA8aGBGqCDsdGWqCWer8F2fh4Of20JZOaTkVPONsSyPWlpxJRlxu2/?=
 =?us-ascii?Q?n80V9o7biurpkCzogSfE/NYhcxB1u1Ag1jpLyxes3DqCey3NiDKDr5W9MJ5y?=
 =?us-ascii?Q?jLp1T/7YuaWZasao+Mm8vZDIHfdUM6XwRe4a3C00XNgz3d/l7mkhVh0J6Km1?=
 =?us-ascii?Q?uV4ezxQ5YMVtS8IcSRq5ugD4Es4fzm+My6mz5fIYFrMYjRyUN8+BgmRXNg7S?=
 =?us-ascii?Q?1JeZ6vmD6sQdFS659cVr8PhFteTJF86kKWavBcaSLLZUkqs9FF/vAFkEsC17?=
 =?us-ascii?Q?4oOevgLOFUFSkfE+lPJTwZ0q7V667r2mnt0f7UEVV5wzAUIEn6knj7U88iLa?=
 =?us-ascii?Q?5Ob16MdV2S+0Sng0kp0YyUj1U02KqJkL9VMuazI2R0eCoPQffBG88RdzjuBe?=
 =?us-ascii?Q?D0Z7xQLbGRkuBPKcnEQwVhZnurWS/k6V6Wlv1WKnO5TjmSeV6YeO8Gdxawzr?=
 =?us-ascii?Q?VUn8A4H68anhqVs7ENvpyPo9MfsUirzzZii7TFJ5zQc2ogJS2oRTMWfrLC8h?=
 =?us-ascii?Q?Jn/rrNL0f/NOHexUSiCiMiyy2K0KP+80AyY+ZOGNfUjG3DgXq1k8uI9zJfoW?=
 =?us-ascii?Q?cHZUlOZqViuncHL3P8WCY7NXS5cokTfn71pEwIno21FOTzfAnO4qnRj1kqbE?=
 =?us-ascii?Q?8bBb6XQf/BAbvKhYf6NV9cPxnx0C2Lmp/OfIO4CMFnDbDHAILuOmEdTSNv0P?=
 =?us-ascii?Q?3niSggpykvRcAMm7Tv4gyXrmhgY+3FNHu+SlBUZL884SEkVH9//j0NU9G5H8?=
 =?us-ascii?Q?+ZNAlSi9vuLBquMuFS3UkyZaWyBUB8UrA2XtZ7g4MkBKUP7Rm7MY0ziA7t6f?=
 =?us-ascii?Q?Ue5A/wx8EL3Z37h5ZUcsFuQOV2pedyMAFFx2Nr41KPmV63Z9p84soC/Szrs/?=
 =?us-ascii?Q?rEiCzoKUtm4o8i9H2aUZWFO6tivyv6FrDq18WY6S5FyQFVTpDCunjvkZnfof?=
 =?us-ascii?Q?65FTZmkiBhElRJHQ2QWTPvRDvSuMiMKvVjSfuiFERyEN3M8iLgrguJJVxBHt?=
 =?us-ascii?Q?DIw3LRrI7K9gXRX5sAUpcQRgb7XaD63c49sFe4UZGfo4LpPFKkbZT210oxuc?=
 =?us-ascii?Q?vFdOR8PeKqnolps0z7aOV6Bklf2log0f/ndYrxLOvo1YDsvNaiAq5YT2PV1A?=
 =?us-ascii?Q?xRneTZ/IepR7T13tw9Z8grvajxwKW+koLrORsLJd8HXTa4H6kNDNYYEXY+6j?=
 =?us-ascii?Q?5AT5dGiRDKu4bCaY7twU20ok1YvmCSTuvfMHqmp7EUQtNYKD2IAiWqAV+8jk?=
 =?us-ascii?Q?Y2dYJaZzopi1wqMQVk03CKlqQtMh0pIDoOygRfqUHT+G4xk9neuBK9vTLDTJ?=
 =?us-ascii?Q?uitutxJVXcBkYNL4qjOtI9zJGYMy3P26ZfZsEJyBS2sfsaQn4OPB+WP+Jqp6?=
 =?us-ascii?Q?lxLAVQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d3cbf4-2747-48f1-9fc7-08db1e696ff4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:37:20.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbqAVUM6pv4A3GlQlBClZ7GVqBgRZJSZ7lf9tGWUo+j+JHC3a2r9I9xKGQx2osr0zuZQ93u7IRLTIWHokD755PyTnCCO++VllXjWnS7CdFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3699
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 04:03:09PM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> devices with Wi-Fi support. And currently FTM (a.k.a. fine time
> measurement or flight time measurement) is the one and only measurement.
> 
> Add necessary functionalities for mac80211_hwsim to abort previous PMSR
> request. The abortion request is sent to the wmedium where the PMSR request
> is actually handled.
> 
> In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> mac80211_hwsim receives the PMSR abortion request via
> ieee80211_ops.abort_pmsr, the received cfg80211_pmsr_request is resent to
> the wmediumd with command HWSIM_CMD_ABORT_PMSR and attribute
> HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> nl80211_pmsr_start() expects.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V7->V8: Rewrote commit msg
> V7: Initial commit (split from previously large patch)
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 61 +++++++++++++++++++++++++++
>  drivers/net/wireless/mac80211_hwsim.h |  2 +
>  2 files changed, 63 insertions(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 691b83140d57..0d92a7e51057 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3343,6 +3343,66 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
>  	return err;
>  }
>  
> +static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
> +				      struct ieee80211_vif *vif,
> +				      struct cfg80211_pmsr_request *request)
> +{
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	u32 _portid = READ_ONCE(data->wmediumd);
> +	struct sk_buff *skb = NULL;
> +	int err = 0;
> +	void *msg_head;
> +	struct nlattr *pmsr;
> +
> +	if (!_portid && !hwsim_virtio_enabled)
> +		return;
> +
> +	mutex_lock(&data->mutex);
> +
> +	if (data->pmsr_request != request) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	if (err)
> +		return;

How can this occur?
And if it does, isn't the lock leaked?

> +
> +	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!skb)
> +		return;

I think the mutex needs to be unlocked here in this error path.

> +
> +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, HWSIM_CMD_ABORT_PMSR);
> +
> +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, data->addresses[1].addr))

In the current scheme, I think err needs to be set here.

> +		goto out_err;
> +
> +	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
> +	if (!pmsr) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	err = mac80211_hwsim_send_pmsr_request(skb, request);
> +	if (err)

I think this error path needs to call nla_nest_cancel().

> +		goto out_err;
> +
> +	err = nla_nest_end(skb, pmsr);
> +	if (err)

I don't think is an error condition.

> +		goto out_err;
> +
> +	genlmsg_end(skb, msg_head);
> +	if (hwsim_virtio_enabled)
> +		hwsim_tx_virtio(data, skb);
> +	else
> +		hwsim_unicast_netgroup(data, skb, _portid);
> +
> +out_err:
> +	if (err && skb)
> +		nlmsg_free(skb);
> +
> +	mutex_unlock(&data->mutex);

I think it might be nicer to arrange this as:

	goto out_unlock;

err_nest_cancel:
	nla_nest_cancel(...);
err_free:
	nlmsg_free(skb);
out_unlock:
	mutex_unlock(&data->mutex);
}

> +}
> +
>  #define HWSIM_COMMON_OPS					\
>  	.tx = mac80211_hwsim_tx,				\
>  	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
> @@ -3367,6 +3427,7 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
>  	.get_et_stats = mac80211_hwsim_get_et_stats,		\
>  	.get_et_strings = mac80211_hwsim_get_et_strings,	\
>  	.start_pmsr = mac80211_hwsim_start_pmsr,		\
> +	.abort_pmsr = mac80211_hwsim_abort_pmsr,
>  
>  #define HWSIM_NON_MLO_OPS					\
>  	.sta_add = mac80211_hwsim_sta_add,			\

...
