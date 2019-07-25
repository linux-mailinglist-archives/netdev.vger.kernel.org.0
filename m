Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E063C74F79
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbfGYN3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:29:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52883 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbfGYN3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:29:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so45004245wms.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 06:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tU8YjTmFbALUAn/qrmdPvLulIsSkzB2d5vOtzmfY2Rs=;
        b=QSmEwdLe+YhZkcsz6o4ys0tAUbny3GwZMtN99XRXmdJW1iCZ+Vf5w/In+CBSdd0gHg
         vibClHZKjsQ5r9p6HBHE/H/GgOJk2X6+elUIbON0QW6rgTxwJvqUGQ9yHbtra0efGoNs
         W83ucOFD+C4dzQ7oUHIVDBhfdDQb4we0p+KDsHMlSnYg72/tUWMX3ZZTFsDnQKSagzp3
         /5fqCWCWSPGPtFoHuE2tk0wdqTt2RTmL6SBUIE6hAPQblRStbcdtARk/9JRhp/aOg+/a
         4Mb5/Tq5DHwFlXZrrC18XGiypTMQhfqfVm5Dbu5ShEOWmhs5SWISOep78td+xziV4xUO
         CVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tU8YjTmFbALUAn/qrmdPvLulIsSkzB2d5vOtzmfY2Rs=;
        b=mqbZQd1YwQEh5Zy5dM+CckMz9sjdj/cKOvedX+nuXt0SiQZ4cpUrWw7rYVWob9s6uW
         G6LEUPQS4XmMlhJwcDoNLiltdwLO0B58MJSggaOlnK3MFQwwQsl4U8olRfBqVg5kCUQm
         BZAiHVhhILPX8XcbO9DuF93wZX+ZxHMJk3o5U1OtVy5NkDJMvDtapUfgGZrgQAAX7lpr
         WDovotMBhzki1uz7DSmjG+OtVHVQaf7dW7knb7ro3NnlcPevuvJ2foCYGQpI4h1Wzn6p
         T6wtX10bpHw92Cs5qb1YxFaJkgGTRlmTTSvMEEcMSDsB2EvN3iX6j6F3ai4h/byNMsmF
         ym1A==
X-Gm-Message-State: APjAAAWvD82TywLiJ+rxfwYoazO5P3daqkc76+DWhlG0hwIfjF0YamXy
        8jH6y8S5h00uRBP3AKDB53SAeVGh4g4=
X-Google-Smtp-Source: APXvYqxLCUPCepcCny7CzWoDDk1ywAgVa3CW+UD6K7NsIV9sI+XkHhXJ84YGrnyVi4MvfOP3KuSWxQ==
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr82394008wmm.10.1564061386852;
        Thu, 25 Jul 2019 06:29:46 -0700 (PDT)
Received: from [192.168.112.17] (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id t13sm61665737wrr.0.2019.07.25.06.29.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 06:29:45 -0700 (PDT)
Subject: Re: [PATCH 2/7] can: rcar_canfd: fix possible IRQ storm on high load
To:     Sasha Levin <sashal@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
References: <20190724130322.31702-3-mkl@pengutronix.de>
 <20190724210328.D91DF21873@mail.kernel.org>
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Message-ID: <6b23b091-92d1-b05d-b451-d8c78a990ef3@cogentembedded.com>
Date:   Thu, 25 Jul 2019 16:29:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724210328.D91DF21873@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

I don't know.
Maintainer did not respond, nor to original send nor to resend.
