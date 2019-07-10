Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C6649DC
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfGJPle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:41:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37673 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfGJPld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 11:41:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so2760438wme.2
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 08:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T+2tQIN8GgQEhwrzV9RlnqNsJ9sZaX6RCnruMD/vfzQ=;
        b=OkDzTJehaqhd1eYBmvwR+2ImL/wB1IzbkCso176viuBzHBjxLynt/A2VBv81uYHMjN
         hiL975acFJKDhkYb5xnratCOyG7o3EYPtdZHUOmL/1DAbeF+Do66iBGP1HCvR0jowaPp
         VgZX7JO7Q1nfFqlIibEm1zLRnz2qFgwvSXWglx4cOQZjztu4kHQSChqHXuGFiPyhFVhQ
         8gNWi79wfAf/EGnjLs2Wkg3RD/PH0MztY3ycbQXtcLz5Mwv6L7J6u0r9h/jy8bQdRRYE
         /9Rg0t7Pa+9wLg7ZJx4geJifzy6ET72ZBZ1+y451fjv8JyjUhDYK7FI/ZPzJrzX9Duu5
         NGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T+2tQIN8GgQEhwrzV9RlnqNsJ9sZaX6RCnruMD/vfzQ=;
        b=IyiRxFPLtkzvx8zo2h5EiO2+oAAVkVk7nsOI5LhZoK2McRrfA5xx5/EllpRY3ZPtwZ
         iA2fUKP0KgurV+4O7umRfNivwIRfzFJ/EH8QNYo7j/XlphsL4HIvGoGmimtDzoUUk0sM
         o3l7CPUiOMhRdXI7ha0iHQmWV3Ug/M9JZIb6tTkbfdk+TbLsumLtLCw7qsG9UypVMzQx
         95NiNH0FZzMQFP5EtOiCr7GEGQFtve4+yd7fNEfs+dVMFxzd4up4IpmHLP4W1KIY1I0e
         WYf6NlvsbK8Za4vtoOSDrTAfddOmMmgzMbGHJx8jLOIOO/EmEd5GxSnnTiMZBgGOnyb2
         VkJQ==
X-Gm-Message-State: APjAAAX1fZSzFHQzsmaCzOuOY8Yp5y5FXQxj8RygDO4SJipuCa0JK1/U
        soEHMPTteAW+vOoKGpuNh1QNIjft
X-Google-Smtp-Source: APXvYqy5PGX66VT8a/C+1wLK5c89PUq6sMmKBuKqvvG5gffAaTF5D80kFueRXWIEoYFzO1pKAh4SPQ==
X-Received: by 2002:a1c:f116:: with SMTP id p22mr5882447wmh.70.1562773291658;
        Wed, 10 Jul 2019 08:41:31 -0700 (PDT)
Received: from [192.168.8.147] (31.172.185.81.rev.sfr.net. [81.185.172.31])
        by smtp.gmail.com with ESMTPSA id p4sm2873121wrs.35.2019.07.10.08.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 08:41:30 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     Edward Cree <ecree@solarflare.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
 <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
Date:   Wed, 10 Jul 2019 17:41:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/19 4:52 PM, Edward Cree wrote:

> Hmm, I was caught out by the call to napi_poll() actually being a local
>  function pointer, not the static function of the same name.  How did a
>  shadow like that ever get allowed?
> But in that case I _really_ don't understand napi_busy_loop(); nothing
>  in it seems to ever flush GRO, so it's relying on either
>  (1) stuff getting flushed because the bucket runs out of space, or
>  (2) the next napi poll after busy_poll_stop() doing the flush.
> What am I missing, and where exactly in napi_busy_loop() should the
>  gro_normal_list() call go?

Please look at busy_poll_stop()

