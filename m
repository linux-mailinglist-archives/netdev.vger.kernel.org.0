Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0B6C95F0
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 17:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjCZPFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 11:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjCZPFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 11:05:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E6E40D0;
        Sun, 26 Mar 2023 08:05:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kISoKL95AIwwQ/rmudV/kFLnKHhopbiD1pzDFPpQQ8khNdG8dJJ4rc49/qBwT3Jgg0qh7uG0j/Vwq2VoX6sqWAIlepBaRypBai8yOrvlY8oJrn/RK4mRIjRufRdiAtnojWN+vc5r0JrSqNIxYqCIfw1/c5ikwU9MR3uRLdHtPSCJM9YCtRT0X2dACA5w365feS6vIfyJ9HaIfr2TsDuDGaQsaijcuyNhEYT4ZM86ZwFrYy3lIeqSZKB7ZOscLRSr20A2WLD1n/gJCaz3UvAi4rD3okqv/ZOwI44xz6S+fUOSabQ1w2sXqdsAzerLU+Cyv8ey4Yonz10cE31PEoPAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlHIJy8oPqeHHwfRxuhkABQkI7VMDO5Ihw3jyKqxhjw=;
 b=X5pmV4Lcy1Wb24oZu+HWAVVJ6or++S3PDEHNp6kLK0AmEFNyespviVXXpVIcFZEgk+9Mi5ja0YOUH10gYIslG4/yfs/niQaNLb3Ecgstfl4gj1StKZaaMo5fMJUSeBxHQwt9t7hLPIIce5enWXxePybLDrcgOleJzp/UJGVtNgIPcb0t4uGkNpZSd+QLVmcOhr2Q+61VuyKvPS/E2QBD5KJvYSTiVkeqw7RdkfElkDdqn0BVBxbwq+A0aUKzpNZMEhW/bxIT/L8XBOOADhTgNeTHJZFU7//nSK5LmqhNEd6xf1c4MSqtLeAsRjJCIrZW6ZpyU+5V36DehcU13tSdfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlHIJy8oPqeHHwfRxuhkABQkI7VMDO5Ihw3jyKqxhjw=;
 b=UATdwSUu5B0TZk2cgU2Ypn3BDMQKyp0agGszXrtcMOnqx+0Ii12Hmzd//Qn0cpXLnfQzwjfV8uv3RUrjd/ZlqopgYM6e4xtclfDrWhOLvEy0xSUN98IqDKvH+Hzmw8hkc4cEzUHfguv+g4Bw7lKLfRZad8IN4Z0mwoSEzBC2a3I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4934.namprd13.prod.outlook.com (2603:10b6:303:fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 15:05:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 15:05:08 +0000
Date:   Sun, 26 Mar 2023 17:05:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jia-Ju Bai <baijiaju@buaa.edu.cn>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mac80211: Add NULL checks for sta->sdata
Message-ID: <ZCBfHlOhU8LjdRg3@corigine.com>
References: <20230321093122.2652111-1-baijiaju@buaa.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321093122.2652111-1-baijiaju@buaa.edu.cn>
X-ClientProxiedBy: AM0PR03CA0070.eurprd03.prod.outlook.com (2603:10a6:208::47)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4934:EE_
X-MS-Office365-Filtering-Correlation-Id: ca3e6c57-e93b-4b03-52f4-08db2e0b7d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyhnVR8PkygelvMPjjMDZoXgMq4OTJDUyuAwsdYcmbXSCmWajuIbmCuN0oszAhQw4z46TaYAZvtyTYsZVa/jZLu/UPD4ymiQb5Jqa+ZJUS7FQtM3S44Sc9gCRA7EfMAW/8f2OijAuqDxvEy9r/M10T6ktoDTSe9nYZAjwCCMgc+G8AyRMCdisXbKSum68kCs3CYeg/BdpyyVsWsjFQb4cCXLS+69s60pE+YXkZmbpfV0mqbD18X/t064iZ2k16dQd61Qq0mWw0oTMGvggwn2HZZ0aCzQxRgaNyZ5CVIsyKH9DQAlDEOgVvtYxZKAx4MplYD/O5DSf1ut6aG6on/g88pgZrH+pNffgMaMbWpUBlkzGsEqNTBAqbEin6y0XWUCvBrCi7avK867r+FxSHaPzqf+iFqaWgy1CC0ytkDI4wZloJ/09I+lRg8dBbdmEnnrY+nYF4Xo28McUebHWiw5KyXURURBRBt9R3KYF1dHoIFIwmjLkPOl1+ijv0B/CjJC7E0bNZm4fqKW6/yflxWECWB0pkRVJv2xn+5N4MbowIBchrvhN/FCRMPIHMvrcYgnzlN25NyeR8HjlopjCOuH82SLus9Rfh8xSF/wXN4CA84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39840400004)(451199021)(2616005)(38100700002)(41300700001)(36756003)(66556008)(66946007)(66476007)(86362001)(4326008)(6916009)(8676002)(478600001)(6486002)(316002)(83380400001)(2906002)(6512007)(44832011)(6506007)(8936002)(5660300002)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3YjvW0NDeUt/Qts1/PuC/ysdOU3/G89mmomncyn0tPhNGjF2JzZEBYYjEwM?=
 =?us-ascii?Q?Bm0ojpqGnB7fIZcahGSpPPXrAc7KVlgJDcTmlJUrFVgJAzJnmjs6AaOJ+Wf6?=
 =?us-ascii?Q?jBdvSMLt1z0gCYIy6kPlbwddv9VepnB85GVvNx4KJpk0heyqNc9AoSoUpCe1?=
 =?us-ascii?Q?H6qRC84zhkO0gR/T12FHob+hVwT/LILDGqdODTkQV1X5t7fVT6rySyX0QKek?=
 =?us-ascii?Q?reA8dPU38W2CGh9sojxDp+wFp3eHY0lN1qzqhIRv5j2DzTlYUKhDQP5UxzK3?=
 =?us-ascii?Q?AR8fF6+n7fF2LYnhUN8G8XyB8sD6VfBooehKoRrEyC+KnEVbmGHbqv+OeCKs?=
 =?us-ascii?Q?8MUtWlEt6rsAq5BWscCVZ3JC33LlolB9SyJPg+hKfKnnIW0JzaPazWZ+dIls?=
 =?us-ascii?Q?rUeKoRM/leBa5e4qg+C3H1JounExZsYhACjEM5Ms0wk+Hpcf+o2FC4L77n0D?=
 =?us-ascii?Q?g9n245jXHUGbYQTca9zs9lAIlq3UcPaHgbZgtIjmPwg6m5h/GJ1X/S4EMAst?=
 =?us-ascii?Q?PsJwmReYzgpshPPxDSbI9vIaAIJQ6n5A7TMosJJiPba9tL02sG7z43ZpQh0H?=
 =?us-ascii?Q?TcZsnDKKTaD1e8DDgRnLIeinWEISGcxHujJ5V2rj8qRbGXM60/Pi2yOhxGIV?=
 =?us-ascii?Q?49FmIUlP7f3s3H0rLmfpAaL/Gwu1nmN4mmO1LX9IwvE2Xv9SFFJIuEeXmxJa?=
 =?us-ascii?Q?UbRk0DMwugiTKmoaq63v8haZUHWfaME6xJX66Hpipf6RW6XZit5PIJgcGtir?=
 =?us-ascii?Q?+x7dhVxnWKpKLK8BDRRYgRhySghDfW4cWfSRhkT8PCtpqow0qvNsiFHsJtdO?=
 =?us-ascii?Q?mhjDLPBLH23m/Hxvkwgo6p+y9qFxENaXznduZygwjCR1kCKDs6KOkVsZty1H?=
 =?us-ascii?Q?1mzBKTTRLGzgvO/LK5fQ6CfbxeONDQz8cIyQRvJchIzA5C31GDWH0Z7vWsKH?=
 =?us-ascii?Q?F8sUmgD7FggYJ95QmRGwG+R6ARLG41H/h5p3mNgih49gJJSzUUzl0+XVvVek?=
 =?us-ascii?Q?A1Mh+CWkLJp19v16xuXSk2mIfPco700plgrOUACm0APDYnm+890HQxTQviLf?=
 =?us-ascii?Q?DJhuttZH5Kpex87UIsvslFgQTiIkMZ5BZP3MuMVNqJbOAJdAbYKwp3BPZeGb?=
 =?us-ascii?Q?5EY6ZVYcInKyfv4BkPtlYR9blB7sZvQ4KUkQAoUS0ssuiiUj9w8fM2lymq0O?=
 =?us-ascii?Q?qPJ4xCqs9XYgxq6sAFh+ErVAUBwd5TRS9QLRECTzO8m1/2d1lMrQNvevrH8a?=
 =?us-ascii?Q?ePoQlWUkNv5Fa9lAWnW7Uzw8mkiKGAZFcQ0Iw8+RQFPzhiTIFD7g9eV7kPuS?=
 =?us-ascii?Q?UwZpxCbM89jsFILe+1yV2csNV75eDx6wMXqop1yM7kd1nnNn0W0Vdhg5VQZH?=
 =?us-ascii?Q?MBmIt5So1F6hetUTbsaKPlyTyIt3dCrMmhp6ZlhJJlswWrluj9ajkuvtn9Mm?=
 =?us-ascii?Q?KGn2YD/leqN+7KScVMeQukcjNdPffYPt9osimZTJ3gO/3k5qG8NTYd3Naqio?=
 =?us-ascii?Q?a2q2ZC8y6l0QZTr9aZnnslsRQ5n4Os1Ldb22pynTZiSyLpbsg9zB7xX+NaEr?=
 =?us-ascii?Q?RFjIY+vx9hRWmZFuQ16hcMmvGV11ghQYWtDQuWevBvxlyM5YXPFxmVln+93u?=
 =?us-ascii?Q?AEQAM3XRVOnXs/Gc5tLK3mH8mv9aM/C8+6e6THo5L9ogJIcCJsNM8UgyxXyF?=
 =?us-ascii?Q?omewcg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3e6c57-e93b-4b03-52f4-08db2e0b7d32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 15:05:08.5415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tRVCPek6oZtCEbrppj9GachStqNITIucMw5YLTT9kRU1PnYVGm4MNzchKgW14J8thjrZZWvaCFEsJnOJrRvjgdI9IxCftOZPxEv1l6LUM5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4934
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 05:31:22PM +0800, Jia-Ju Bai wrote:
> In a previous commit 69403bad97aa ("wifi: mac80211: sdata can be NULL
> during AMPDU start"), sta->sdata can be NULL, and thus it should be 
> checked before being used.
> 
> However, in the same call stack, sta->sdata is also used in the
> following functions:
> 
> ieee80211_ba_session_work()
>   ___ieee80211_stop_rx_ba_session(sta)
>     ht_dbg(sta->sdata, ...); -> No check
>     sdata_info(sta->sdata, ...); -> No check
>     ieee80211_send_delba(sta->sdata, ...) -> No check
>   ___ieee80211_start_rx_ba_session(sta)
>     ht_dbg(sta->sdata, ...); -> No check
>     ht_dbg_ratelimited(sta->sdata, ...); -> No check
>   ieee80211_tx_ba_session_handle_start(sta)
>     sdata = sta->sdata; if (!sdata) -> Add check by previous commit
>   ___ieee80211_stop_tx_ba_session(sdata)
>     ht_dbg(sta->sdata, ...); -> No check
>   ieee80211_start_tx_ba_cb(sdata)
>     sdata = sta->sdata; local = sdata->local -> No check
>   ieee80211_stop_tx_ba_cb(sdata)
>     ht_dbg(sta->sdata, ...); -> No check
> 
> Thus, to avoid possible null-pointer dereferences, the related checks
> should be added.
> 
> These bugs are reported by a static analysis tool implemented by myself, 
> and they are found by extending a known bug fixed in the previous commit. 
> Thus, they could be theoretical bugs.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>
> ---
> v2:
> * Fix an error reported by checkpatch.pl, and make the bug finding
>   process more clear in the description. Thanks for Simon's advice.
> ---
>  net/mac80211/agg-rx.c | 68 ++++++++++++++++++++++++++-----------------
>  net/mac80211/agg-tx.c | 16 ++++++++--
>  2 files changed, 55 insertions(+), 29 deletions(-)
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index c6fa53230450..6616970785a2 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -80,19 +80,21 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
>  	__clear_bit(tid, sta->ampdu_mlme.agg_session_valid);
>  
> -	ht_dbg(sta->sdata,
> -	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n", > -	       sta->sta.addr, tid,
> -	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
> -	       (int)reason);
> +	if (sta->sdata) {
> +		ht_dbg(sta->sdata,
> +		       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
> +		       sta->sta.addr, tid,
> +		       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
> +		       (int)reason);
> +	}

The first line of the body of ___ieee80211_stop_rx_ba_session() is:

	struct ieee80211_local *local = sta->sdata->local;

So a NULL pointer dereference will have occurred before
the checks this change adds to that function.


>  
> -	if (drv_ampdu_action(local, sta->sdata, &params))
> +	if (sta->sdata && drv_ampdu_action(local, sta->sdata, &params))
>  		sdata_info(sta->sdata,
>  			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
>  			   sta->sta.addr, tid);
>  

...

> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index f9514bacbd4a..03b31b6e7ac7 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -368,8 +368,10 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
>  
>  	spin_unlock_bh(&sta->lock);
>  
> -	ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
> -	       sta->sta.addr, tid);
> +	if (sta->sdata) {
> +		ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
> +		       sta->sta.addr, tid);
> +	}

This seems clean :)

>  	del_timer_sync(&tid_tx->addba_resp_timer);
>  	del_timer_sync(&tid_tx->session_timer);
> @@ -776,7 +778,12 @@ void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
>  			      struct tid_ampdu_tx *tid_tx)
>  {
>  	struct ieee80211_sub_if_data *sdata = sta->sdata;
> -	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_local *local;
> +
> +	if (!sdata)
> +		return;

I'm not sure that silently ignoring non-existent sdata is the right approach.
Perhaps a WARN_ON or WARN_ONCE is appropriate?

> +
> +	local = sdata->local;
>  
>  	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
>  		return;
> @@ -902,6 +909,9 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
>  	bool send_delba = false;
>  	bool start_txq = false;
>  
> +	if (!sdata)
> +		return;
> +

Ditto.

>  	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n",
>  	       sta->sta.addr, tid);
>  
