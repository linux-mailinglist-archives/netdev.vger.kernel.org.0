Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F140F2ED431
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbhAGQWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAGQWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:22:48 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B87EC0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:22:08 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id w3so6732203otp.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N1ioO9Gouiqoimyspe6tNzQU1Gnxluk/Jp2jlAbKuNA=;
        b=iRp7koAotsrVVSRa8OFgZxs0rnJV/CEwHPRE8EPwpUM2jwoaeVF6hCkRE8df4Qz7BC
         4QSjYU0thXi807s8N3E9D1SQJdFB/Q+Tfx20PXLqwlIc+A9EN6++WxNrP//PixIh2X7G
         UqIAW2QC1Uf02GUS4kv2DKeStkvUVxwwRKdLbySuVNSWmYLOX3rUR/cDl2V0q1widv77
         dA2Olk+vwC4zhqwodjWudOqCdxuEI+HcIIpSTB9rtcFLlJbiMa5ST8+SYGPemAGIll6O
         ItQOUHmvopvc+t5rt+7I02lelBg1uyeWQDnxzTuzTPcLVzZheV+cFp4x1KVJRDJv1UHE
         0M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N1ioO9Gouiqoimyspe6tNzQU1Gnxluk/Jp2jlAbKuNA=;
        b=hbk3C9DeCws3+0YcEe2IY++gv8rfrgWvZ5MfihX5ET3GBhNHDIAiOrhH3MYSVJaGqS
         cCBs+oQdmPmj0QU9jF3Qk9OBCKPxT9vimTv8ZyiX1dNHwaPgmysSAnuLJlkRaf5HdPKe
         dymom/rW2Ln4e+vhYWhfKnbukxlaCgvkXTVbah0tIHVJo8gvP0fI7OWp1kRdxgjcm0jy
         aZuNKHDnjAP3aB4kS4EX+Pcfh1f4ZRBrs4AoLzgIuMHzmeuDKwKhH+ypL6X9yYMEnULI
         tIR1xUM+p2qz9XXC6nUJ1NDa1u4+XXA1AXp8QHPafzfjwFMV/BCU6XS0AbG45hjpq9cP
         DJhw==
X-Gm-Message-State: AOAM530ezSJk8FHeUkOZBp83mZps2aKoV1uGGwhxOWdv/qJDFzY30KzS
        mnsKoQRzUsOZsEgIPhGRngs=
X-Google-Smtp-Source: ABdhPJzLlPMlnkgE2gpGqxbHkI+Xg1Q6+IldmAaNG0V7iue3ngaXlVIy9m3E+WmJvvgWIs2bcnSDCg==
X-Received: by 2002:a05:6830:1385:: with SMTP id d5mr6985755otq.295.1610036528105;
        Thu, 07 Jan 2021 08:22:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:800d:24b4:c97:e28d])
        by smtp.googlemail.com with ESMTPSA id g200sm1361001oib.19.2021.01.07.08.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 08:22:07 -0800 (PST)
Subject: Re: [PATCH net 1/4] nexthop: Fix off-by-one error in error path
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210107144824.1135691-1-idosch@idosch.org>
 <20210107144824.1135691-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8d31fe13-3574-f7b4-a1de-1c149e44bdf1@gmail.com>
Date:   Thu, 7 Jan 2021 09:22:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107144824.1135691-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 7:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> A reference was not taken for the current nexthop entry, so do not try
> to put it in the error path.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

