Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8FF7D1F1
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 01:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfGaXc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 19:32:57 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44018 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaXc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 19:32:57 -0400
Received: by mail-lj1-f195.google.com with SMTP id y17so42834858ljk.10
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 16:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CX+W2vODD3zGUj/joWK7YfYg9vtMH4AGLIbP0a3owOM=;
        b=NmKGubUQ61jLeyg5LFUsUxAHzdospAsPZVPSOgfWpOB6Lh8DQv0SyO+dAa4fBn1cxe
         WC97uvjLQUT3tX2qHRzDbAJBnhjdaodWudOAQwGgy29wXvsqmE76NpYns42K4EXnvDvk
         E28nfl6itmpuKBWeM9hKMakSqkjmbHAwaiTKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CX+W2vODD3zGUj/joWK7YfYg9vtMH4AGLIbP0a3owOM=;
        b=qUbvEHX1tdTeIdcOJiQHKs2moKoT1PmJe3StI402wcN8A/DIjD4zszfYMt+xC2hsx+
         j5gbdpPMKax7H1bDe/yPrZLSlpBrsLD6+fr8G8RiuJaxKafi/bnJeQ0ILRUSBKFbk7Hi
         ZgGD8C+H2QpQpaB7ae62H2YGmhqeR/xfhk7T+vm4wMPqLfnCNyKLtuKS0HlkRPpswFhJ
         2mXu3I7NLUml6CsYKF/Hb0Vblr1Lv0sTNneYhiwINlGjN9oorBhAlvlm9aM1A2YxWeTY
         5xOrt9vbvZpLYDyvZHXAqqbxbNbzrfT73v96hNBJgXoq5aYeTbVEU41hUP4qQ2t9nesh
         XuGg==
X-Gm-Message-State: APjAAAVDwfbbURodf9ie3Dy8rknsjxOwN7FQHDSQKAUfP09SG9bTcGl/
        lHdRFTgqH+NvqEPu/N18oE/4Kw==
X-Google-Smtp-Source: APXvYqyKZvZlTIuro1i68XRxTVikQLptULFWQ0xk+x2CLH6K/OpdUcY5d1jPiQvlVq9WF9o4oXouew==
X-Received: by 2002:a2e:9ac4:: with SMTP id p4mr25556932ljj.185.1564615975037;
        Wed, 31 Jul 2019 16:32:55 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id e62sm14273888ljf.82.2019.07.31.16.32.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 16:32:53 -0700 (PDT)
Subject: Re: [PATCH net v3] net: bridge: move vlan init/deinit to
 NETDEV_REGISTER/UNREGISTER
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
References: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
 <20190731224955.10908-1-nikolay@cumulusnetworks.com>
 <20190731155338.15ff34cb@hermes.lan>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <c9a68f85-49f6-6d02-e130-a03d540aa0a7@cumulusnetworks.com>
Date:   Thu, 1 Aug 2019 02:32:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190731155338.15ff34cb@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 1:53 AM, Stephen Hemminger wrote:
>   
>> -int br_vlan_init(struct net_bridge *br)
>> +static int br_vlan_init(struct net_bridge *br)
>>  {
>>  	struct net_bridge_vlan_group *vg;
>>  	int ret = -ENOMEM;
>> @@ -1083,6 +1085,8 @@ int br_vlan_init(struct net_bridge *br)
>>  	return ret;
>>  
>>  err_vlan_add:
>> +	RCU_INIT_POINTER(br->vlgrp, NULL);
>> +	synchronize_rcu();
> 
> Calling sychronize_rcu is expensive. And the callback for
> notifier is always called with rtnl_head. 
> 
> Why not just keep the pointer initialization back in the
> code where bridge is created, it was safe there.
> 

Because now the device registered and we've published the group, right now
it is not an issue but if we expose an rcu helper we'll have to fix this
because it'd become a bug.
I'd prefer to have the error path correct and future-proof it, since it's
an error path we're not concerned with speed, but rather correctness. Also
these are rarely exercised so the bug might remain for a very long time.


