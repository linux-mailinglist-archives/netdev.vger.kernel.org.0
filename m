Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9027D670
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgI2TIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:08:23 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40085 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgI2TIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:08:20 -0400
Received: by mail-oi1-f196.google.com with SMTP id t76so6673309oif.7;
        Tue, 29 Sep 2020 12:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7M5WWuCCkp0VZzy+IL0R9xA2aVw6kleFif9899pGFyQ=;
        b=NXnc7HSby/OO/nXaQ1YMZBX5OT6gXDJ7gHaXW8J54vU4YPqwGV8vhFdvjSZR0fQ27F
         SIfh4TzBCId1DRMVmlVKzmqgvjkPNAFUfAXpgT46nVFQcVLnWbKc6dugWfUNYxpq1T+X
         OXf4HLro8REnUAANM357BmdZQ/WDIYdYMIwtD+FCV9tfB8Guf5FUmyTLIYYADABGzfnh
         JiJXFrj3FqWCvFRrFK3zn4QAU+UnmGb+klaaH3JsznN3uJpW7gjVYMiaa9Tl7AKgA+JO
         3FfKESIpcb0iJma/SOEDVfVr2+dtpDfRbq5m9flwiFL19lPDXXQyDHyPYdgq5q1qUIX3
         86IQ==
X-Gm-Message-State: AOAM531mn9nj1RcuJ2UkgnGTlsESMhlG0sNLi6Q58MgnD6t2O4fD565z
        ebMFRHA8dtimwPSgxHu22w==
X-Google-Smtp-Source: ABdhPJy0b+HZcCj2usxdcLROYd54PlCp1iEn8dy5PwPN7+oTFJb3bRAq2L4tLGroeti9O+YaI9yabQ==
X-Received: by 2002:aca:5c43:: with SMTP id q64mr3520166oib.18.1601406498870;
        Tue, 29 Sep 2020 12:08:18 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s13sm1207704otq.5.2020.09.29.12.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 12:08:18 -0700 (PDT)
Received: (nullmailer pid 980133 invoked by uid 1000);
        Tue, 29 Sep 2020 19:08:17 -0000
Date:   Tue, 29 Sep 2020 14:08:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap
 QMI requests
Message-ID: <20200929190817.GA968845@bogus>
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 11:59:41PM +0530, Amit Pundir wrote:
> There are firmware versions which do not support host capability
> QMI request. We suspect either the host cap is not implemented or
> there may be firmware specific issues, but apparently there seem
> to be a generation of firmware that has this particular behavior.
> 
> For example, firmware build on Xiaomi Poco F1 (sdm845) phone:
> "QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1"
> 
> If we do not skip the host cap QMI request on Poco F1, then we
> get a QMI_ERR_MALFORMED_MSG_V01 error message in the
> ath10k_qmi_host_cap_send_sync(). But this error message is not
> fatal to the firmware nor to the ath10k driver and we can still
> bring up the WiFi services successfully if we just ignore it.
> 
> Hence introducing this DeviceTree quirk to skip host capability
> QMI request for the firmware versions which do not support this
> feature.

So if you change the WiFi firmware, you may force a DT change too. Those 
are pretty independent things otherwise.

Why can't you just always ignore this error? If you can't deal with this 
entirely in the driver, then it should be part of the WiFi firmware so 
it's always in sync.

Rob
