Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85F131896F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhBKL2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhBKL0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:26:17 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17469C0613D6
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 03:25:35 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id f6so5273136ioz.5
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 03:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RNCbwWGJpmc+SYAl0oGAkOn8c+Uetv6pQ0SAtn/I0ts=;
        b=EfkcZAfIM4OEUp7no+mO5klbesiyD66uhZ4a6kqrXSsrqHxWaooE7YbbGPdAotQT7o
         Ye0UOPKcIdisKnbKPIQbOF3bJX3gPm4W6UaEK0/JciFK+KVteL5WZPMyIlrxuyUXKe6T
         /tRs2FwyzQtW3dh5QHCqYxww3A692iMogQvyvF7sN8SYgn2wzQbZ7oggt2+7+tdQ3Gtp
         cAeXaST1Fna24kCpJDflWfjYKQ0avOdBHp79hi4+5RTSNY/ZZSoha81GrmTBn8vkNwlz
         aLyp5C3Vf+oSOfC3VR8jFGnMTktpIfW7z0nbkkCItw/NvvXwVijqxsqjb53yHoRSVrQR
         IlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RNCbwWGJpmc+SYAl0oGAkOn8c+Uetv6pQ0SAtn/I0ts=;
        b=gjApj9XcDHrrMVvXi7zwf4dllITUuTyZy5yy7Fhi3a2zb9l0cdfremTRtcJveE15ZR
         TZBBNKvJfqsyo657eNzdEXx5Z4DTqKODi6fm3dLmKUeKkdS6sC176rG/4fb4+PCI4Ddy
         +TaCnZ9rcT0js6eN2MMXs7JDH/lT3D8U8OX9tgcxTCMrFLZ3KIUI11ZV8K7hjP+KC7St
         RmB6ZwNweb3yGDE8Z+1oQCbywdVpxrrKP8apHr37b+Nl58by1hG+UhktdO0kKzjoLyq7
         +myzF4Kisr0iMr0gHfRVw4I33RSngmW3XcQxXdCupX7WxbVR49NCvLPV3lQS1RJ/qOye
         +kiA==
X-Gm-Message-State: AOAM533+GBeub1dCc93SJ4YOk0HUn3gQmi8Xiz5Wbc7eLQvWnw4QQZQY
        wn5SZ3DPVLFobXnAStW1iE1siw==
X-Google-Smtp-Source: ABdhPJwkf4DVaG85M5Q5H+KZXQweo64TrVUTcyu7/QCvwi7ewUpJ6P1iW2r1c5ZVZKsP//uwz0zPUw==
X-Received: by 2002:a6b:6016:: with SMTP id r22mr4953860iog.93.1613042734450;
        Thu, 11 Feb 2021 03:25:34 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v1sm2465066ilm.35.2021.02.11.03.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 03:25:33 -0800 (PST)
Subject: Re: [PATCH net-next] net: ipa: pass checksum trailer with received
 packets
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210210211349.13158-1-elder@linaro.org>
Message-ID: <3f3a5630-f4af-1dec-be9f-2b3868ad60bf@linaro.org>
Date:   Thu, 11 Feb 2021 05:25:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210210211349.13158-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/21 3:13 PM, Alex Elder wrote:
> For a QMAP RX endpoint, received packets will be passed to the RMNet
> driver.  If RX checksum offload is enabled, the RMNet driver expects
> to find a trailer following each packet that contains computed
> checksum information.  Currently the IPA driver is passing the
> packet without the trailer.
> 
> Fix this bug.
> 
> Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
> Signed-off-by: Alex Elder <elder@linaro.org>

I want to give this patch a little more thought.

In the end it's not that critical (this is not
in the normal RX completion data path), and
the way things are currently configured we
won't have checksum offload enabled for the
receiving endpoint anyway.

     --> So I WITHDRAW this patch. <--

I don't think the patch is wrong, but I'm going
to avoid the backport hassle, and wait to address
the issue until it really matters.

Thanks.

					-Alex

> ---
> 
> David/Jakub,
> I would like to have this back-ported as bug fix.  At its core, the
> fix is simple, but even if it were reduced to a one-line change, the
> result won't cleanly apply to both net/master and net-next/master.
> How should this be handled?  What can I do to make it easier?
> 
> Thanks.
> 
> 					-Alex
> 
>   drivers/net/ipa/ipa_endpoint.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 7209ee3c31244..5e3c2b3f38a95 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -1232,6 +1232,11 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
>   	void *data = page_address(page) + NET_SKB_PAD;
>   	u32 unused = IPA_RX_BUFFER_SIZE - total_len;
>   	u32 resid = total_len;
> +	u32 trailer_len = 0;
> +
> +	/* If checksum offload is enabled, each packet includes a trailer */
> +	if (endpoint->data->checksum)
> +		trailer_len = sizeof(struct rmnet_map_dl_csum_trailer);
>   
>   	while (resid) {
>   		const struct ipa_status *status = data;
> @@ -1260,18 +1265,18 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
>   		 */
>   		align = endpoint->data->rx.pad_align ? : 1;
>   		len = le16_to_cpu(status->pkt_len);
> -		len = sizeof(*status) + ALIGN(len, align);
> -		if (endpoint->data->checksum)
> -			len += sizeof(struct rmnet_map_dl_csum_trailer);
> +		len = sizeof(*status) + ALIGN(len, align) + trailer_len;
>   
>   		if (!ipa_endpoint_status_drop(endpoint, status)) {
>   			void *data2;
>   			u32 extra;
>   			u32 len2;
>   
> -			/* Client receives only packet data (no status) */
> +			/* Strip off the status element and pass only the
> +			 * packet data (plus checksum trailer if enabled).
> +			 */
>   			data2 = data + sizeof(*status);
> -			len2 = le16_to_cpu(status->pkt_len);
> +			len2 = le16_to_cpu(status->pkt_len) + trailer_len;
>   
>   			/* Have the true size reflect the extra unused space in
>   			 * the original receive buffer.  Distribute the "cost"
> 

