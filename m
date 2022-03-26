Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF184E801C
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 09:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiCZIwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 04:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiCZIwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 04:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EF3167D8;
        Sat, 26 Mar 2022 01:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCB2B800C1;
        Sat, 26 Mar 2022 08:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48932C2BBE4;
        Sat, 26 Mar 2022 08:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648284634;
        bh=s9f5bnhBuCk46wN4ssaRjCDYFb2Vt9/9/gOzq5IqbM4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Wsse77TQPF6Ke+C1gwGny+B0XKyIweV6uyw2XgRapNZle2hcsN2dg8aDx9LXj4dAN
         PBgKW2grATQi5ZyNEWpqzKZ6MPFEaHsQwcezvyaHc8vdwU0sOPnbuZvUhwwC1nxIbo
         u1PPuhVSk/g20nvY8jYE6NBwWxZR4+yvC451ZqDInfSPsb5OR8BqfSUFywTb3lW0R7
         fYgax0D8VE7OqsznQ9DK+wZPW07B2wLBBph9ALnjaHIs3KB6qrrbPAR3/QG8t6+rC/
         fH7TK85liowzjgBSVuBp4MsLChL0z9cOn/59a1QKdbSMjuUrwHbG3VcEnSNrw6TZtT
         79NjatLt1tMfQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Edmond Gagnon <egagnon@squareup.com>,
        Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] wcn36xx: Implement tx_rate reporting
References: <20220323214533.1951791-1-egagnon@squareup.com>
        <20220325224212.159690-1-egagnon@squareup.com>
        <7ae9915d-98fc-efd4-4a1e-872c446aacca@quicinc.com>
Date:   Sat, 26 Mar 2022 10:50:30 +0200
In-Reply-To: <7ae9915d-98fc-efd4-4a1e-872c446aacca@quicinc.com> (Jeff
        Johnson's message of "Fri, 25 Mar 2022 17:09:00 -0700")
Message-ID: <87h77lnlm1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> writes:

> On 3/25/2022 3:42 PM, Edmond Gagnon wrote:
>> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
>> rate:
>>
>> root@linaro-developer:~# iw wlan0 link
>> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>>          SSID: SQ-DEVICETEST
>>          freq: 5200
>>          RX: 4141 bytes (32 packets)
>>          TX: 2082 bytes (15 packets)
>>          signal: -77 dBm
>>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>>          tx bitrate: 6.0 MBit/s
>>
>>          bss flags:      short-slot-time
>>          dtim period:    1
>>          beacon int:     100
>>
>> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
>> firmware message and reports it via ieee80211_ops::sta_statistics.
>>
>> root@linaro-developer:~# iw wlan0 link
>> Connected to 6c:f3:7f:eb:73:b2 (on wlan0)
>>          SSID: SQ-DEVICETEST
>>          freq: 5700
>>          RX: 26788094 bytes (19859 packets)
>>          TX: 1101376 bytes (12119 packets)
>>          signal: -75 dBm
>>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>>          tx bitrate: 108.0 MBit/s VHT-MCS 5 40MHz VHT-NSS 1
>>
>>          bss flags:      short-slot-time
>>          dtim period:    1
>>          beacon int:     100
>>
>> Tested on MSM8939 with WCN3680B running firmware CNSS-PR-2-0-1-2-c1-00083,
>> and verified by sniffing frames over the air with Wireshark to ensure the
>> MCS indices match.
>>
>> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
>> Reviewed-by: Benjamin Li <benl@squareup.com>

[...]

>>   +static void wcn36xx_sta_statistics(struct ieee80211_hw *hw,
>> struct ieee80211_vif *vif,
>> +				   struct ieee80211_sta *sta, struct station_info *sinfo)
>> +{
>> +	struct wcn36xx *wcn;
>> +	u8 sta_index;
>> +	int status = 0;
>
> remove initializer that is always overwritten

I can fix that in the pending branch, no need to resend because of this.

>>   +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32
>> stats_mask,
>> +			  struct station_info *sinfo)
>> +{
>> +	struct wcn36xx_hal_stats_req_msg msg_body;
>> +	struct wcn36xx_hal_stats_rsp_msg *rsp;
>> +	void *rsp_body;
>> +	int ret = 0;
>
> remove initializer that is always overwritten before use

Ditto.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
