Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB524EF9F2
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351244AbiDAShe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiDAShd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:37:33 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7841B8FC2;
        Fri,  1 Apr 2022 11:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648838143; x=1680374143;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dE+eYbTlRphRYMzrizvUuQiOeaDFtpljQ+qdtyoyovA=;
  b=Ht9zSv45O6vA+B2AVgriwFwRtGgWB4GDon1mCGFn5irdM/8BLNa+fjqd
   JFnFXW0hRnq/qp5aROsF0jzW0dgFJczdfHVWEIEGWmfHk/l6X1J9diMIY
   EAxGQbIjAVo4XD0JoGE6VXzj7Y51GjleArI+jXZkrQ1U9LAadphCxAM3C
   g=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 01 Apr 2022 11:35:42 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 11:35:30 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 1 Apr 2022 11:35:29 -0700
Received: from [10.110.67.71] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 1 Apr 2022
 11:35:29 -0700
Message-ID: <25b13a66-ab99-8ec8-847a-450827f6163b@quicinc.com>
Date:   Fri, 1 Apr 2022 11:35:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/1] nl80211: Prevent out-of-bounds read when processing
 NL80211_ATTR_REG_ALPHA2
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20220401105046.1952815-1-lee.jones@linaro.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220401105046.1952815-1-lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/2022 3:50 AM, Lee Jones wrote:
> Checks are presently in place in validate_nla() to ensure strings
> greater than 2 are not passed in by the user which could potentially
> cause issues.
> 
> However, there is nothing to prevent userspace from only providing a
> single (1) Byte as the data length parameter via nla_put().  If this
> were to happen, it would cause an OOB read in regulatory_hint_user(),
> since it makes assumptions that alpha2[0] and alpha2[1] will always be
> accessible.
> 
> Add an additional check, to ensure enough data has been allocated to
> hold both Bytes.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   net/wireless/nl80211.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index ee1c2b6b69711..80a516033db36 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -7536,6 +7536,10 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
>   		if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
>   			return -EINVAL;
>   
> +		if (nla_len(info->attrs[NL80211_ATTR_REG_ALPHA2]) !=
> +		    nl80211_policy[NL80211_ATTR_REG_ALPHA2].len)
> +			return -EINVAL;
> +
>   		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
>   		return regulatory_hint_user(data, user_reg_hint_type);
>   	case NL80211_USER_REG_HINT_INDOOR:

LGTM

doesn't nl80211_set_reg() also have this issue?
	alpha2 = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
[...]
	rd->alpha2[0] = alpha2[0];
	rd->alpha2[1] = alpha2[1];
