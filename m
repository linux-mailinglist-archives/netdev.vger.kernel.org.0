Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CDB31AEA7
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhBNBUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBNBUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:20:43 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D67C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:20:03 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id l3so4115214oii.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ft+PJva5R3gGcC2+q1YARm/pjjEATrgEHKTg9XqbnL4=;
        b=K7lxzPBXLz8WNgmxb0sJhbbdhXJ9+tmi2S7xgwRA94btTZ0JnrXnMQxd/PxJSxNvrN
         Kmq0JYi9z7d4sduC0UclWWoalLAjhJaW85DEcOuaB4QcnbuGGNXfUUKJq6zSoiFBCZ6S
         PDgKndvuv7Jh0btL5cFar5ywHosgZAuIVCI8/04xCwAj3Cxx8z1Elql7aqLnx3BBwlUv
         Vrlv7T0BEQny85ynih7cJpC4DPTP+3Hsd0Qe10cbeKYqPeVrntc/fHf2AeUuAIn9cZ2C
         x7IyZf4xBCtvU97c+QzvVPQ3hSFm1fxfuQkz+8J+bxC/RcxAOhcg9NXKYUI0XdMzNq/+
         IM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ft+PJva5R3gGcC2+q1YARm/pjjEATrgEHKTg9XqbnL4=;
        b=AxMvdL+TIUTxXNe8CYVSU8uZXr2mjRxXJkVd3/R55rsHeZ/OjkrdUjcm1ybaNU4zjj
         Ka1Qg+9BvMlcCGXTgMidT+jXA200Eu6WTPlZSGVGPHBxCVRV8ddbZZbbPMkLP3K4PxlJ
         KERtVXFmuUhaLW/6klNdlS93AKlaEvI8P5Y+RaNBreVMgTYvRBFfRzrlS/r8vO11ZSHR
         eUAwNnxw7qfkg+hUU2Epo7ilVMwEl5XDv/8RCDSqCA4CuFjbIcTxlKi4PRi6NaJNpqQa
         nyyl//YYuNf0qT1ZZbMbksQbFJkjp/cyVGlOi1sXmXJ1nzJ5mSnQEPSTe0TvUq3fKsRe
         RAFA==
X-Gm-Message-State: AOAM530+lTpGI8zHO1TjZZXOz0UzjwjgY7ryvEGzg9NUqxo4tFn2CCca
        3mOzOyAzRAvmLvN514XuE3U=
X-Google-Smtp-Source: ABdhPJyfRL13uDlsGSduxQtdf/7L61fPwRp3UuWlTxiI1ZvYDbBWTbGZgQvcLEjWwUpM+ydrsJXVtw==
X-Received: by 2002:a05:6808:14d0:: with SMTP id f16mr4272843oiw.56.1613265602539;
        Sat, 13 Feb 2021 17:20:02 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id b17sm2407955ook.21.2021.02.13.17.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:20:02 -0800 (PST)
Subject: Re: [PATCH v2 net-next 02/12] net: mscc: ocelot: only drain
 extraction queue on error
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <00f5e816-49b1-d642-39e4-1e394ae0ce0f@gmail.com>
Date:   Sat, 13 Feb 2021 17:19:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It appears that the intention of this snippet of code is to not exit
> ocelot_xtr_irq_handler() while in the middle of extracting a frame.
> The problem in extracting it word by word is that future extraction
> attempts are really easy to get desynchronized, since the IRQ handler
> assumes that the first 16 bytes are the IFH, which give further
> information about the frame, such as frame length.
> 
> But during normal operation, "err" will not be 0, but 4, set from here:
> 
> 		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
> 			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
> 			if (err != 4)
> 				break;
> 		}
> 
> 		if (err != 4)
> 			break;
> 
> In that case, draining the extraction queue is a no-op. So explicitly
> make this code execute only on negative err.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
