Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46513273317
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgIUTos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbgIUTor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:44:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C2EC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 12:44:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k133so5175346pgc.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 12:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gP9ZcuCLYUcgbONExTMy5A4Uwm+Es82/xxX4OVhRic0=;
        b=uPM1riVYGmpLvEM9Gb+jo69+aFbc8L2tzdu45InFoBYZoyIzBS0nkSZxz5Y5P+es63
         eqWTpbM3TSeir3TTAhDmKJKrDaKlBK4pL6JPqW/YyC2pDeRmzuz6yfzV8XXXkrg9cHnC
         RvWgTNWZ12TCWb0TeMS/GczvUe3dj9YBzyG1w8rfiOkeTxSTt320w5eikV6cRXHEwQ6c
         pgpg5QASK0wqzv/o1omrR588iMOmBPgFBo+fUUE+zgAHU8ith8jI/dRBl2hR6Tob74MY
         DVkxTSup+vk5LylynFEx5+nU5dG1rvHHu9T6a5FzUu07oWrL7sZE0KoYvSBto2BQjHiD
         5zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gP9ZcuCLYUcgbONExTMy5A4Uwm+Es82/xxX4OVhRic0=;
        b=sTFfsHZozSmu74biNlSFoRNEuB+4gIbcYafpJDAANo134FjnIUWAKqWZZSNdI8gY44
         Ha4Uvg1kbr9+6UFtCsZISb+7x2eL0T26pnxJIp91skses2W8C+3uFMHS4un0Q+t2tmEJ
         FXfazhDgqr/32y+tXYxrwturis0RwArygfKuF6dTg1LehlJvR8kWq8t3nppfTC50/Inf
         5ZUk+Qi3vkd4Ab5/sfZ5QphOza1hLWkVtb0/bcYhXbRJ1ezRM4HZXGgCQZiEuEhJ26k6
         nZ395Wuwm3+H1bDsHgQUp0b5MypStROuVUQkgwrMCfZIimNrRLBPtD9XyViiO+op1pQC
         Iq0w==
X-Gm-Message-State: AOAM530BI54Ps/2+TSt2292HdqPUem/hPEEvOlp66TwTg58Pbk9uOduK
        s+aS/eGoFVP+33lEXbKo1AQ=
X-Google-Smtp-Source: ABdhPJy5T0+9F7mzQRmBZo3hCR7J80m3IXfmtWgGkA14QtY4jGL0h3kPrmzHQktZm+5PBmt3CoKrUw==
X-Received: by 2002:a63:547:: with SMTP id 68mr895035pgf.327.1600717487207;
        Mon, 21 Sep 2020 12:44:47 -0700 (PDT)
Received: from [10.67.49.188] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 126sm12997730pfg.192.2020.09.21.12.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 12:44:46 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
 <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
 <315a6f2a1cec945eb35e69c6fdeaf3c2ab3cb25d.camel@nvidia.com>
 <cc20face-ec67-d444-1cf8-f4257dbe1e1c@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <a322976c-6d47-aae8-32eb-3593f8e3cc10@gmail.com>
Date:   Mon, 21 Sep 2020 12:44:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cc20face-ec67-d444-1cf8-f4257dbe1e1c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/20 1:11 PM, Florian Fainelli wrote:
>> Less important, but still:
>>   - it is in the fast path for everyone
>>   - it can already be fixed by a tc action/8021q device
> 
> Sure, but the point is that it should be fixed in a way that is
> transparent to the user, as much as possible.
> 
>>
>> We can go into details but that would be a waste of time, instead I
>> think we
>> should focus on Vladimir's proposed DSA change.
>>
>> Vladimir, I think with the right pvid helper the patch would reduce to
>> dsa_untag_bridge_pvid() on the Rx path only. One thing that I'm
>> curious about
>> is shouldn't dsa_untag_bridge_pvid() check if the bridge pvid is == to
>> the skb
>> tag and the port's pvid?
>> Since we can have the port's pvid different from the bridge's. That's
>> for the
>> case of vlan_filtering=1 and the port having that vlan, but not as pvid.

Vladimir, let me know if you have a patch for DSA and I can give it a
try quickly. Thanks!
-- 
Florian
