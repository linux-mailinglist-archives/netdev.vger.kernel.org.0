Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3BBD78F9
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbfJOOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:45:19 -0400
Received: from mail-vk1-f181.google.com ([209.85.221.181]:36310 "EHLO
        mail-vk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732595AbfJOOpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 10:45:19 -0400
Received: by mail-vk1-f181.google.com with SMTP id w3so4402523vkm.3
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 07:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XROkh959F7qjDHVVNXpDtZJp9FNzqPbbesUV83OOxa4=;
        b=O1+hokyY3gkds21yf00JwltfESWOHg1hpiqGOLSWHG5168wCiehqZz5qdPAUHzjtJp
         S7bhiy7sMLAwVf/lWNs916L/ZEnzuXgBROhFG563THi3LYGi42m2TDVAhLJDweA7GOJe
         PTSj9AYl9N39vBZkifMCSjexn0NfMeWOu1x7rJa4vzN4uzmLMjG7iwe7IY/Abj7DroAV
         lFftuNQtfer78qyjMJT572ARxAovwue0asW8G/4Vz13VAfm73eTSojE/7NAfIB5ujMSM
         d91I+p85Gxx1WDyNfOwNuZgsvefS14HWtlpVhBBkZLr3OmatqAEUdQRbMVa9ogT7dIxa
         jqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XROkh959F7qjDHVVNXpDtZJp9FNzqPbbesUV83OOxa4=;
        b=U1+g0+pY/wVUryKMGrb4AmUzxu8tdvGgr47xocy0brQE5FEENfGODmlPTFy6t/nEia
         lG+pjn55cqkX+yY5uAyLFMI0RYr3FBBT1oUiC8O24O0pgaWutGLn3TTud3vcD/C964nm
         NvLWzE3E8oiF2Bw8/crwDHu7CWXCl9f591STW67wDGm3dTzX2fWGjXnxRnmmk+tapil7
         vaVZep4iZkqK2mAMJaOitj2YCIarkLSBF6xYb1+zDhLIoQPqxWpWUxJ858un8cxsn8gU
         fo2CMroVr5vAdMuV55WXPWZps23rOFGpK7S5Hm+8QmJsNbRQlQAJkFursgPtQho7NkVh
         y96Q==
X-Gm-Message-State: APjAAAXxaQAXEN/WyKuvCJSjgrZH7vQKbVt7cRoJSFej2mtoRFfWHLfJ
        GHBQpE2mH+IMxrr6IzH2COaP1QcY
X-Google-Smtp-Source: APXvYqwxNzPI9+69WXuTEbY6LI/SRGP/UDZE+4vt5l/WobVk4cLmOScuoDXjFuJQ51LJDHI0TZjFJg==
X-Received: by 2002:ac5:ccc2:: with SMTP id j2mr19038412vkn.44.1571150717506;
        Tue, 15 Oct 2019 07:45:17 -0700 (PDT)
Received: from dahern-DO-MB.local (207.190.24.244.psav-cs.smartcity.net. [207.190.24.244])
        by smtp.googlemail.com with ESMTPSA id d28sm9833740vsl.5.2019.10.15.07.45.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 07:45:15 -0700 (PDT)
Subject: Re: Race condition in route lookup
To:     Martin Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
 <CAEA6p_A_kNA8kVLmVn0e=fp=vx3xpHTTaVrx62NVCDLowVxaog@mail.gmail.com>
 <20191014172640.hezqrjpu43oggqjt@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9d4dd279-b20a-e333-2dd6-fe2901e67bce@gmail.com>
Date:   Tue, 15 Oct 2019 10:45:14 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014172640.hezqrjpu43oggqjt@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/19 1:26 PM, Martin Lau wrote:
> 
> AFAICT, even for the route that are affected by fib6_update_sernum_upto_root(),
> I don't see the RTF_PCPU route is re-created.  v6 sk does
> dst_check() => re-lookup the fib6 =>
> found the same RTF_PCPU (but does not re-create it) =>
> update the sk with new cookie in ip6_dst_store()
> 

That's fine. The pcpu cache is per nexthop (fib6_nh) for a specific
gateway/device.

The invalidate forces another lookup for the intended destination after
the change to the fib. If the lookup resolves to the same fib entry and
nexthop, then re-using the same cached dst/rt6_info is ok.
