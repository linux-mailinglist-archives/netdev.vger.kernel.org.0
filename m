Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022F231A039
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBLOCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbhBLOB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:01:57 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C95C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:01:17 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id m17so9353717ioy.4
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hfpu4JNrDZMZnmuhC/B9i4uH563p9QYRFbc8Z09AD8Y=;
        b=GVHI2HxeHVr1cuXtdzYruzbOiB4KETUjoyUjvXcXqgUOA9aFMSI3A365t7/7fGTAtq
         YKJVDBzuKs/D84SZkm9Dw0+S13oOh9H3BG8AFUnVN3h7aCcNBdaHxXxVQeh0JDuYyxfi
         7W9e0uvmlM7ICY+AZfbgjwiABPj+emU5f+acs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hfpu4JNrDZMZnmuhC/B9i4uH563p9QYRFbc8Z09AD8Y=;
        b=hmsz/op35xNHnS2YtlYzL0TARt488Ztqn6SMBivNnYK2wCvXWC5TEaQxBaOcw1QWHG
         KqPhchrDPxkgYhqwM3CwnrKEJAhcfPBlrHEhGZ2YVrmUmxhnx3GQqsrm+dxUxcTIZur5
         7ABk0kaiU2uSXwDweS+Rg8aTXmy4/kkAifWxyGmXFg3H88jBtQ0zfueTreB9Z4XkSOI4
         bEHeuTO2XcOCqKvtiGC/8NUeY3od5Qx0MXvDmRkIBytlU6rrkKEbqIQd7tmdpE822DXh
         yXl104HFwo0FH1AGv5ZVP3BA9EAR6FuqCLi/gWb2oNpm3bZT3P/nJwNdpzaILxL66jZP
         +30Q==
X-Gm-Message-State: AOAM531Wg9anvY2CevfbvVSveBZ4M+aGOFGu3ZvZZG9KBMXJHY90yLLU
        EJk2mxLa8VFAf4NifMO2rVzrcdvARm1C0D6p
X-Google-Smtp-Source: ABdhPJylam6eGTL3mklnT2GyKQxTakQ2Q39BnfQThOB9Nf0FTkzmUCs0MldOziz7vdfNTcrQ8nBpjw==
X-Received: by 2002:a02:30d5:: with SMTP id q204mr2659530jaq.55.1613138476532;
        Fri, 12 Feb 2021 06:01:16 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i20sm4494742ilc.2.2021.02.12.06.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 06:01:15 -0800 (PST)
Subject: Re: [PATCH 2/3] net:ethernet:rmnet:Support for downlink MAPv5 csum
 offload
To:     Jakub Kicinski <kuba@kernel.org>,
        Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
 <1613079324-20166-3-git-send-email-sharathv@codeaurora.org>
 <20210211180459.500654b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <1c4e21bf-5903-bc45-6d6e-64b68e494542@ieee.org>
Date:   Fri, 12 Feb 2021 08:01:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210211180459.500654b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 8:04 PM, Jakub Kicinski wrote:
> On Fri, 12 Feb 2021 03:05:23 +0530 Sharath Chandra Vurukala wrote:
>> +/* MAP CSUM headers */
>> +struct rmnet_map_v5_csum_header {
>> +	u8  next_hdr:1;
>> +	u8  header_type:7;
>> +	u8  hw_reserved:5;
>> +	u8  priority:1;
>> +	u8  hw_reserved_bit:1;
>> +	u8  csum_valid_required:1;
>> +	__be16 reserved;
>> +} __aligned(1);
> 
> Will this work on big endian?

Sort of related to this point...

I'm sure the response to this will be to add two versions
of the definition, surrounded __LITTLE_ENDIAN_BITFIELD
and __BIG_ENDIAN_BITFIELD tests.

I really find this non-intuitive, and every time I
look at it I have to think about it a bit to figure
out where the bits actually lie in the word.

I know this pattern is used elsewhere in the networking
code, but that doesn't make it any easier for me to
understand...

Can we used mask, defined in host byte order, to
specify the positions of these fields?

I proposed a change at one time that did this and
this *_ENDIAN_BITFIELD thing was used instead.

I will gladly implement this change (completely
separate from what's being done here), but thought
it might be best to see what people think about it
before doing that work.

					-Alex
