Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C950A52037D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiEIR0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbiEIR0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:26:46 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7260C2655E9;
        Mon,  9 May 2022 10:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1652116970; x=1683652970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xeiVbBjGZzQmi5hxe8ODrmB4OItgCwayOzZqZR/3bMs=;
  b=mMPrOVq3Vj478HYgQ8ADOgCxlSSenvHRtG/jyPx/pjH0SHJJNX+vxlvY
   rUL8FRbk7xTDcoflVez/W8orkRpBXAVly3cyqomKXCtUWf4PQzuT89Fx6
   H3uuu6vI3Tx4Ze9nuC9ZwXrujS4emzSVe0zmZ2zoX9zCCk1ZA9MLCkDkp
   I=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 09 May 2022 10:22:50 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 10:22:51 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 9 May 2022 10:22:49 -0700
Received: from [10.110.84.131] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 10:22:48 -0700
Message-ID: <e824a9d7-7d30-c9e6-fc27-65af0dcd958b@quicinc.com>
Date:   Mon, 9 May 2022 10:22:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3] ath10k: improve BDF search fallback strategy
Content-Language: en-US
To:     Abhishek Kumar <kuabhs@chromium.org>, <kvalo@kernel.org>
CC:     <netdev@vger.kernel.org>, <dianders@chromium.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/2022 7:26 PM, Abhishek Kumar wrote:
> Board data files wrapped inside board-2.bin files are
> identified based on a combination of bus architecture,
> chip-id, board-id or variants. Here is one such example
> of a BDF entry in board-2.bin file:
> bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> It is possible for few platforms none of the combinations
> of bus,qmi-board,chip-id or variants match, e.g. if
> board-id is not programmed and thus reads board-id=0xff,
> there won't be any matching BDF to be found. In such
> situations, the wlan will fail to enumerate.
> 
> Currently, to search for BDF, there are two fallback
> boardnames creates to search for BDFs in case the full BDF
> is not found. It is still possible that even the fallback
> boardnames do not match.
> 
> As an improvement, search for BDF with full BDF combination
> and perform the fallback searches by stripping down the last
> elements until a BDF entry is found or none is found for all
> possible BDF combinations.e.g.
> Search for initial BDF first then followed by reduced BDF
> names as follows:
> bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
> bus=snoc,qmi-board-id=67,qmi-chip-id=320
> bus=snoc,qmi-board-id=67
> bus=snoc
> <No BDF found>
> 
> Tested-on: WCN3990/hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
> 
> Changes in v3:
> - As discussed, instead of adding support for default BDF in DT, added
> a method to drop the last elements from full BDF until a BDF is found.
> - Previous patch was "ath10k: search for default BDF name provided in DT"
> 
>   drivers/net/wireless/ath/ath10k/core.c | 65 +++++++++++++-------------
>   1 file changed, 32 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 688177453b07..ebb0d2a02c28 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1426,15 +1426,31 @@ static int ath10k_core_search_bd(struct ath10k *ar,
>   	return ret;
>   }
>   
> +static bool ath10k_create_reduced_boardname(struct ath10k *ar, char *boardname)
> +{
> +	/* Find last BDF element */
> +	char *last_field = strrchr(boardname, ',');
> +
> +	if (last_field) {
> +		/* Drop the last BDF element */
> +		last_field[0] = '\0';
> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +			   "boardname =%s\n", boardname);

nit: strange spacing in the message. i'd expect consistent spacing on 
both side of "=", either one space on both sides or no space on both 
sides.  also the use of "=" here is inconsistent with the use of ":" in 
a log later below

> +		return 0;
> +	}
> +	return -ENODATA;
> +}
> +
>   static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>   					      const char *boardname,
> -					      const char *fallback_boardname1,
> -					      const char *fallback_boardname2,
>   					      const char *filename)
>   {
> -	size_t len, magic_len;
> +	size_t len, magic_len, board_len;
>   	const u8 *data;
>   	int ret;
> +	char temp_boardname[100];
> +
> +	board_len = 100 * sizeof(temp_boardname[0]);
>   
>   	/* Skip if already fetched during board data download */
>   	if (!ar->normal_mode_fw.board)
> @@ -1474,20 +1490,24 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>   	data += magic_len;
>   	len -= magic_len;
>   
> -	/* attempt to find boardname in the IE list */
> -	ret = ath10k_core_search_bd(ar, boardname, data, len);
> +	memcpy(temp_boardname, boardname, board_len);
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boardname :%s\n", boardname);

nit: use of ":" inconsistent with use of "=" noted above.
also expect space after ":, not before: "boardname: %s\n"


>   
> -	/* if we didn't find it and have a fallback name, try that */
> -	if (ret == -ENOENT && fallback_boardname1)
> -		ret = ath10k_core_search_bd(ar, fallback_boardname1, data, len);
> +retry_search:
> +	/* attempt to find boardname in the IE list */
> +	ret = ath10k_core_search_bd(ar, temp_boardname, data, len);
>   
> -	if (ret == -ENOENT && fallback_boardname2)
> -		ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
> +	/* If the full BDF entry was not found then drop the last element and
> +	 * recheck until a BDF is found or until all options are exhausted.
> +	 */
> +	if (ret == -ENOENT)
> +		if (!ath10k_create_reduced_boardname(ar, temp_boardname))
> +			goto retry_search;
>   
>   	if (ret == -ENOENT) {

note that ath10k_create_reduced_boardname() returns -ENODATA when 
truncation fails and hence you won't log this error when that occurs

>   		ath10k_err(ar,
>   			   "failed to fetch board data for %s from %s/%s\n",
> -			   boardname, ar->hw_params.fw.dir, filename);
> +			   temp_boardname, ar->hw_params.fw.dir, filename);

does it really make sense to log the last name tried, temp_boardname? or 
does it make more sense to still log the original name, boardname?

maybe log each failure in the loop, before calling 
ath10k_create_reduced_boardname()?

>   		ret = -ENODATA;
>   	}
>   
> @@ -1566,7 +1586,7 @@ static int ath10k_core_create_eboard_name(struct ath10k *ar, char *name,
>   
>   int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>   {
> -	char boardname[100], fallback_boardname1[100], fallback_boardname2[100];
> +	char boardname[100];
>   	int ret;
>   
>   	if (bd_ie_type == ATH10K_BD_IE_BOARD) {
> @@ -1579,25 +1599,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>   			return ret;
>   		}
>   
> -		/* Without variant and only chip-id */
> -		ret = ath10k_core_create_board_name(ar, fallback_boardname1,
> -						    sizeof(boardname), false,
> -						    true);
> -		if (ret) {
> -			ath10k_err(ar, "failed to create 1st fallback board name: %d",
> -				   ret);
> -			return ret;
> -		}
> -
> -		/* Without variant and without chip-id */
> -		ret = ath10k_core_create_board_name(ar, fallback_boardname2,
> -						    sizeof(boardname), false,
> -						    false);
> -		if (ret) {
> -			ath10k_err(ar, "failed to create 2nd fallback board name: %d",
> -				   ret);
> -			return ret;
> -		}
>   	} else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
>   		ret = ath10k_core_create_eboard_name(ar, boardname,
>   						     sizeof(boardname));
> @@ -1609,8 +1610,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
>   
>   	ar->bd_api = 2;
>   	ret = ath10k_core_fetch_board_data_api_n(ar, boardname,
> -						 fallback_boardname1,
> -						 fallback_boardname2,
>   						 ATH10K_BOARD_API2_FILE);
>   	if (!ret)
>   		goto success;

