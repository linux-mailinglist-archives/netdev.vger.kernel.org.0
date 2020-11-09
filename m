Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065DF2AC008
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgKIPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:38:30 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:21166 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKIPia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604936308;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=S6fI1VVgo3BFqkCRhbg9Tu9n35Sv2Rz9Yq/+PsHLB0I=;
        b=NLLux4EFYzcguf8u4HCNV5NB376Fstv1MSblLpW5OTpW39WVnhtVf4S3i0uM2ajdhd
        X3+K1ngiSTBbnKFVp/fRW8sYu1eJaoAu2amApzdU7YUEjCly1N3HCI8p3+Ia0unTsnpL
        Qenh25XXbA59xz5Y5GIxPSg8GPqnPG9C3P/kVD51U3Y0hS3Feegxct96kwqI+sHrJweI
        sS+inuOKYTi8Lk6/HWCdaVQbA4oB3FYq9fCOCUg44KjiwGsk40n2+mleT64ePUW9ib88
        7iBlCQnCspbgCR+VdoBB8FjE+l9gPnTUEm1oDdXDsk/1bTp8yo7zcJSZwVC9LJam44QD
        X2uw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3HMbEWKONeXTNI="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9FcQ864
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 16:38:26 +0100 (CET)
Subject: Re: [PATCH v4 4/7] can: replace can_dlc as variable/element for
 payload length
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
References: <20201109102618.2495-1-socketcan@hartkopp.net>
 <20201109102618.2495-5-socketcan@hartkopp.net>
 <CAMZ6RqJz+G-R6LF=jU22kcYPBwTCOB7XmcY+GTNLmfm+-9rvUw@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <b33f7cc7-6bf3-363b-e328-a405ec4a2575@hartkopp.net>
Date:   Mon, 9 Nov 2020 16:38:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqJz+G-R6LF=jU22kcYPBwTCOB7XmcY+GTNLmfm+-9rvUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On 09.11.20 13:59, Vincent MAILHOL wrote:
> On Mon. 9 Nov 2020 at 19:26, Oliver Hartkopp wrote:
>> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
>> index b2e8df8e4cb0..72671184a7a2 100644
>> --- a/include/linux/can/dev.h
>> +++ b/include/linux/can/dev.h
>> @@ -183,12 +183,12 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
>>          /* override MTU which was set by default in can_setup()? */
>>          if (static_mode & CAN_CTRLMODE_FD)
>>                  dev->mtu = CANFD_MTU;
>>   }
>>
>> -/* get data length from can_dlc with sanitized can_dlc */
>> -u8 can_dlc2len(u8 can_dlc);
>> +/* get data length from raw data length code (DLC) */
> 
> /*
>   * convert a given data length code (dlc) of an FD CAN frame into a
>   * valid data length of max. 64 bytes.
>   */
> 
> I missed this point during my previous review: the can_dlc2len() function
> is only valid for CAN FD frames. Comments should reflect this fact.
> 
>> +u8 can_dlc2len(u8 dlc);
> 
> Concerning the name:
>   * can_get_cc_len() converts a Classical CAN frame DLC into a data
>     length.
>   * can_dlc2len() converts an FD CAN frame DLC into a data length.
> 
> Just realized that both macro/function do similar things so we could
> think of a similar naming as well.
>   * Example 1: can_get_cc_len() and can_get_fd_len()
>   * Example 2: can_cc_dlc2len() and can_fd_dlc2len()

I like!

Patch set v5 is out now.

Thanks,
Oliver

> 
> Or we could simply leave things as they are, this is not a big issue
> as long as the comments clearly state which one is for classical
> frames and which one is for FD frames.
> 
>>
>>   /* map the sanitized data length to an appropriate data length code */
>>   u8 can_len2dlc(u8 len);
> 
> can_len2dlc() might be renamed (e.g. can_get_fd_dlc()) if Example 1
> solution is chosen.
> 
>>   struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
> 
> Yours sincerely,
> Vincent Mailhol
> 
