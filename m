Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF0D90A0C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 23:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfHPVLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 17:11:45 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33835 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbfHPVLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 17:11:44 -0400
Received: by mail-oi1-f193.google.com with SMTP id l12so5813460oil.1;
        Fri, 16 Aug 2019 14:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0gC4sb2j3RWTm9xjuIK9kqivJqH0u782yHSmQQjFy/g=;
        b=ZcN4oCeWfbQ8IuIbiJvX+uHyg1YUAnJlV3kFmXAKGTavk+exyLe7ff2VjFiXkDTygM
         ifb682dWQdfQ1icKhTm6rP2nA8+yruA3hhwkUI1r9EeANqdGB32E8Tl46oSQ+BgdG6lh
         FN0MhfYbVuM/65A+FVlc2KZclUUt9M2r/XsMFGouGqBpyO1m2bstqJsvz5VuWOh9qt+i
         HnhcBiB9nQGEQ8qFWOIoSfFxfsLrMGS2Z4+bjkz3NIFTpjnSzbPM8TVgXs4fYEhcBMrs
         sZKepC884dLnmUSSbvGTLcxU33HfYcbVNJOuvgS5ojY2wJrJqQqaJzJAl/IC8K9kXo+w
         Pd2g==
X-Gm-Message-State: APjAAAV/6MYS2rOa4vYc0l337p3Sha7zEzSK+ZcSoa9mJYbeT2/7XP2X
        5ozNB/uLMnKzxPgDbaYKmA==
X-Google-Smtp-Source: APXvYqxVNGZP55OO2DAvkxQON330c/WkMGGQCA7UZMyjdZKYVNzMAVMjLidQg+yRLMzc0LHLCzRN0Q==
X-Received: by 2002:aca:5106:: with SMTP id f6mr6355037oib.69.1565989903418;
        Fri, 16 Aug 2019 14:11:43 -0700 (PDT)
Received: from localhost (ip-173-126-47-137.ftwttx.spcsdns.net. [173.126.47.137])
        by smtp.gmail.com with ESMTPSA id z26sm1648410oih.16.2019.08.16.14.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 14:11:42 -0700 (PDT)
Date:   Fri, 16 Aug 2019 16:11:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix HOST capability QMI incompatibility
Message-ID: <20190816211141.GA4468@bogus>
References: <20190725063108.15790-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725063108.15790-1-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:31:08PM -0700, Bjorn Andersson wrote:
> The introduction of 768ec4c012ac ("ath10k: update HOST capability QMI
> message") served the purpose of supporting the new and extended HOST
> capability QMI message.
> 
> But while the new message adds a slew of optional members it changes the
> data type of the "daemon_support" member, which means that older
> versions of the firmware will fail to decode the incoming request
> message.
> 
> There is no way to detect this breakage from Linux and there's no way to
> recover from sending the wrong message (i.e. we can't just try one
> format and then fallback to the other), so a quirk is introduced in
> DeviceTree to indicate to the driver that the firmware requires the 8bit
> version of this message.
> 
> Cc: stable@vger.kernel.org
> Fixes: 768ec4c012ac ("ath10k: update HOST capability qmi message")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt     |  6 +++++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/net/wireless/ath/ath10k/qmi.c         | 13 ++++++++---
>  .../net/wireless/ath/ath10k/qmi_wlfw_v01.c    | 22 +++++++++++++++++++
>  .../net/wireless/ath/ath10k/qmi_wlfw_v01.h    |  1 +
>  drivers/net/wireless/ath/ath10k/snoc.c        | 11 ++++++++++
>  drivers/net/wireless/ath/ath10k/snoc.h        |  1 +
>  6 files changed, 51 insertions(+), 3 deletions(-)
