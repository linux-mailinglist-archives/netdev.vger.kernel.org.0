Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911263017F9
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 20:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbhAWTPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 14:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAWTPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 14:15:01 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24C1C06174A
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:14:20 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n42so8640620ota.12
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eNoGfh1nyASZPYDQ0izXBOQQmTtFNiSKqMkftnByvd0=;
        b=viO+vJuqD9i69fGYrQLp7YqoxzJYFpiK7gvbz73jqzYPD4t/BmAzorrz073XLC6r9/
         3K6C55zL7m8rimmNTFDos8/Mww6SC1CJ22qGv5IJHpmkTgs1LFcq9c0EcgHhMRV36hnP
         LEnjAA7WOqZlZB76LtA8r1x/2eT27Icd4pfZNcnQFX+r2L6VgtBlUM4PvIRQ1nCAxiwj
         5hpgjGQgngHRQDOeY1n6WN3++NKOwg9MgANVmY6XJotqtAAqbUORhiXHbfZeUa7zph5n
         LijkVgB4iV5dxsg9ID64aChWIBdFZTqoE1gG1qNoa9k2XWy2Lk2ttLTSgosUoV+yXP/7
         ZmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNoGfh1nyASZPYDQ0izXBOQQmTtFNiSKqMkftnByvd0=;
        b=TelSBfPPUnBkc2eq1kIX8j48qzAkr9FOuLtUNxxAB7mcQfBzUmd7gKX7F4HI8zKzv8
         5CscrATFg4+k+RMBjehgAZcKw+TYJ4iApwEgMfn3ji3y3QDBokT26yHJnjYm0tEX44pe
         EQDQLeUXvtc8kycgSO9nl7iqkXIOhHu9IMwOUFy+YGQuR3dxc0lsjBUVWfNJYnRIReKu
         dDsbFHa3ymGJ/RZSFuI71P0VLMcTicFErrFDWUZXU/TMUmXI5CkKtCKUkMEAkba01EQi
         lIg0GxiOASj0uTS8dc0+BuVhX4IGj+4D+hXLvny5lVNXPrA2/wFg0K3CPtXInrSq+imi
         2a7w==
X-Gm-Message-State: AOAM53123qup+zkKQb0lCbVEogDzPmbx5PrSnFVHPXVXPHm+Vz1C8zhB
        zMVxldITF33BKMRXdrTDLpM=
X-Google-Smtp-Source: ABdhPJxRLsqoy2KZfTzO6pk1RR26XAPSpDYlGYJB+2UA6hYrG9Wf+AqzH9KhVrx6k5nc5wQD4xTnYA==
X-Received: by 2002:a05:6830:13c2:: with SMTP id e2mr7476030otq.264.1611429260114;
        Sat, 23 Jan 2021 11:14:20 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id h30sm2293337ooi.12.2021.01.23.11.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 11:14:19 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
To:     Edwin Peer <edwin.peer@broadcom.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
Date:   Sat, 23 Jan 2021 12:14:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210123045321.2797360-2-edwin.peer@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 9:53 PM, Edwin Peer wrote:
> If a nested list of attributes is too long, then the length will
> exceed the 16-bit nla_len of the parent nlattr. In such cases,
> determine how many whole attributes can fit and truncate the
> message to this length. This properly maintains the nesting
> hierarchy, keeping the entire message valid, while fitting more
> subelements inside the nest range than may result if the length
> is wrapped modulo 64KB.
> 
> Marking truncated attributes, such that user space can determine
> the precise attribute truncated, by means of an additional bit in
> the nla_type was considered and rejected. The NLA_F_NESTED and
> NLA_F_NET_BYTEORDER flags are supposed to be mutually exclusive.
> So, in theory, the latter bit could have been redefined for nested
> attributes in order to indicate truncation, but user space tools
> (most notably iproute2) cannot be relied on to honor NLA_TYPE_MASK,
> resulting in alteration of the perceived nla_type and subsequent
> catastrophic failure.
> 

Did you look at using NETLINK_CB / netlink_skb_parms to keep a running
length of nested attributes to avoid the need to trim?

