Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19C8241D9
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfETUL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:11:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfETUL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 16:11:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7F29B60AA8; Mon, 20 May 2019 20:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558383116;
        bh=apvzPomu1xSc+1mrdcgyoLfkXvPIEgcA1K8kh3yrRGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PcovAR5M2xB/WFhRjvaRGkCCjiRhyzz3kIqItapvtj6xa4zWdhy0GfUhw4szfXu63
         6xNl1nhJeMi4JqtylnC8Md4LZeMq1Gw1a6T+DqfPnWdjyFYGmaJ3pJRKLhMef/4fdi
         VqY6EUJGFispGZCClfubmSdrbqi0qwIvga71KUWM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3DA5F60274;
        Mon, 20 May 2019 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558383115;
        bh=apvzPomu1xSc+1mrdcgyoLfkXvPIEgcA1K8kh3yrRGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aK3eCG3ZTRwKIyMF1zLEDfYHaNUdlEL6R2Jj5MbBoZlpAsxVxYs39InfNOhOrgGSR
         /QEC1YieTnLxZG8eZoLuxGuQVugx98JMstIzBJGFfCIMmr+oSX50g6SjyoHCZlb0qQ
         5Hm+5dyBW6SlsV6BqQJbwGL2y0gQFfHPoJxOVAEs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 May 2019 14:11:55 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Alex Elder <elder@linaro.org>
Cc:     arnd@arndb.de, david.brown@linaro.org, agross@kernel.org,
        davem@davemloft.net, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, evgreen@chromium.org, benchan@google.com,
        ejcaruso@google.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] net: qualcomm: rmnet: fix struct rmnet_map_header
In-Reply-To: <20190520135354.18628-2-elder@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
 <20190520135354.18628-2-elder@linaro.org>
Message-ID: <b0edef36555877350cfbab2248f8baac@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 07:53, Alex Elder wrote:
> The C bit-fields in the first byte of the rmnet_map_header structure
> are defined in the wrong order.  The first byte should be formatted
> this way:
>                  +------- reserved_bit
>                  | +----- cd_bit
>                  | |
>                  v v
>     +-----------+-+-+
>     |  pad_len  |R|C|
>     +-----------+-+-+
>      7 6 5 4 3 2 1 0  <-- bit position
> 
> But the C bit-fields that define the first byte are defined this way:
>     u8 pad_len:6;
>     u8 reserved_bit:1;
>     u8 cd_bit:1;
> 

If the above illustration is supposed to be in network byte order,
then it is wrong. The documentation has the definition for the MAP
packet.

Packet format -

Bit             0             1           2-7      8 - 15           16 - 
31
Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload 
length
Bit            32 - x
Function     Raw  Bytes

The driver was written assuming that the host was running ARM64, so
the structs are little endian. (I should have made it compatible
with big and little endian earlier so that is my fault).

In any case, this patch on its own will break the data operation on
ARM64, so it needs to be folded with other patches.

> And although this isn't portable, I can state that when I build it
> the result puts the bit-fields in the wrong location (e.g., the
> cd_bit is in bit position 7, when it should be position 0).
> 
> Fix this by reordering the definitions of these struct members.
> Upcoming patches will reimplement these definitions portably.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index 884f1f52dcc2..b1ae9499c0b2 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -40,9 +40,9 @@ enum rmnet_map_commands {
>  };
> 
>  struct rmnet_map_header {
> -	u8  pad_len:6;
> -	u8  reserved_bit:1;
>  	u8  cd_bit:1;
> +	u8  reserved_bit:1;
> +	u8  pad_len:6;
>  	u8  mux_id;
>  	__be16 pkt_len;
>  }  __aligned(1);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
