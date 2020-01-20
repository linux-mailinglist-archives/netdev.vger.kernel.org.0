Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5714312F
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgATR60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:58:26 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32923 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATR60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:58:26 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so62199pgk.0;
        Mon, 20 Jan 2020 09:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ysjJBMwBw0DEoJwVh/oOrH8bpLVarkoQHD4ZW+ZjLcc=;
        b=gF03ANpUCTOHWnxa81GGHBT7Os+poOUoxf9lJpXAZdFljtqX/E1L86s0lFCGFiLEAf
         63LkHabEs2LiDpT5d+/kN20UhjZ0YTNZjF1URvkycUTxAV6I4QfEJwoAnxdhHQuVw/eK
         lFiUHmUWCFyt+HUPcIgp4d5HOz1TfVFuK4ZFuHRYgvuSbvoKsvEoM7530zd70kzmDGQt
         +R8vA35zdlm7XVHG2Muv20Slp3w6VzmvvOVZZ+93zgnjnRen9RB22YZ2KdeTg7+1LuDs
         p+AslZbe5sxhnTGOBP1p2vj19Ftyjq2vOwh4h2sqD2LDnMFSG+gRw2uSNzGBEf1QvhkI
         MbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ysjJBMwBw0DEoJwVh/oOrH8bpLVarkoQHD4ZW+ZjLcc=;
        b=dpL/RzN/CUwsg0/gaEn8NV0BFQZocmUifi2rmYPBFbX68zN89r/2PNjp35/PMtNlpm
         yg41eMEPM2SZr8lDNyIsIlrQEJCvWvEPpbS0y7jogKyfIutGqgYjGHhzFjJMgjLC3E1T
         Cy0XIqjXJLyD/iMDx9n0zC3GbgnspxgCKYtE7C6SEL75ttvUCNZ5N51/3zXqj8O7BOY/
         VMXDXfb2bospX0SjxU53ktiNj8uP/zxI9Ipgl/0E29lvlFzUn4jeg283IxMep81W6ilP
         +jaR69yU9Mg5/q32sMD9L5ZBJ2iwxA+6LkFuYNpLfAFPxGeGlgR4mfbUsIukn1sv/4L5
         NMjQ==
X-Gm-Message-State: APjAAAVaEUhuR0il/C4KStOfcWUXvVVsBhcXSq2ubNzone005PJol/Zg
        aY1N05zIU0Fv6K3NkGZegTXcFI0o
X-Google-Smtp-Source: APXvYqwzBgH9rYplTvGAFyQMF6dstlqiCjG1FvSkBKHvOYosUMrEnnFXo5Rhym8wqEmHato6nTyaSg==
X-Received: by 2002:a62:7681:: with SMTP id r123mr325130pfc.169.1579543105701;
        Mon, 20 Jan 2020 09:58:25 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b24sm39794104pfo.55.2020.01.20.09.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 09:58:25 -0800 (PST)
Subject: Re: [PATCH] tcp_bbr: improve arithmetic division in bbr_update_bw()
To:     Wen Yang <wenyang@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200120100456.45609-1-wenyang@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <af89b1c6-2182-be2e-6b44-1921483d426b@gmail.com>
Date:   Mon, 20 Jan 2020 09:58:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200120100456.45609-1-wenyang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/20 2:04 AM, Wen Yang wrote:
> do_div() does a 64-by-32 division. Use div64_long() instead of it
> if the divisor is long, to avoid truncation to 32-bit.
> And as a nice side effect also cleans up the function a bit.
> 

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks !
