Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD64B124F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243992AbiBJQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:06:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbiBJQGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:06:38 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D218C26
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=jkDYoYgDn/3qbwaUuHqdsfbsMKgTOiwZeN1KlBHkJYM=; b=sATJYvRUsk7ranB78wOxUBOC8c
        tpvkcwDoB6qkKGIeILVGaJRZLjXS5i+W+xvQvRQIyPL3f56Fgdtc68H8d9Jc72qbhknXVVBTMrHUe
        +Sk8ND1xT10PqX2Bt/Itwa+Pi91VzxfV7QSuTpVYunJg2uqCsrf8hym838AfSB6luG/g=;
Received: from p200300daa71e0b00d9ae6de683158d49.dip0.t-ipconnect.de ([2003:da:a71e:b00:d9ae:6de6:8315:8d49] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nIBxt-0006hg-N0; Thu, 10 Feb 2022 17:06:37 +0100
Message-ID: <8feee888-491a-9324-6437-07f33d0d5584@nbd.name>
Date:   Thu, 10 Feb 2022 17:06:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
References: <20220210142401.4912-1-nbd@nbd.name>
 <d4f1f9b1-6e8e-d21d-603f-7a0889e33a78@nvidia.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 1/2] net: bridge: add knob for filtering rx/tx BPDU packets
 on a port
In-Reply-To: <d4f1f9b1-6e8e-d21d-603f-7a0889e33a78@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.02.22 15:55, Nikolay Aleksandrov wrote:
> On 10/02/2022 16:24, Felix Fietkau wrote:
>> Some devices (e.g. wireless APs) can't have devices behind them be part of
>> a bridge topology with redundant links, due to address limitations.
>> Additionally, broadcast traffic on these devices is somewhat expensive, due to
>> the low data rate and wakeups of clients in powersave mode.
>> This knob can be used to ensure that BPDU packets are never sent or forwarded
>> to/from these devices
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  include/linux/if_bridge.h    | 1 +
>>  include/uapi/linux/if_link.h | 1 +
>>  net/bridge/br_forward.c      | 5 +++++
>>  net/bridge/br_input.c        | 2 ++
>>  net/bridge/br_netlink.c      | 6 +++++-
>>  net/bridge/br_stp_bpdu.c     | 9 +++++++--
>>  net/core/rtnetlink.c         | 4 +++-
>>  7 files changed, 24 insertions(+), 4 deletions(-)
>> 
> 
> Why can't netfilter or tc be used to filter these frames?
netfilter is slow as hell, and even adding a tc rule that has to look at 
all frames to check for useless BPDU packets costs a lot more CPU cycles 
than simply suppressing them at the source.

- Felix
