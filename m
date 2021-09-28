Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D841AC2C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240015AbhI1JrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbhI1JrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 05:47:00 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5E8C061575;
        Tue, 28 Sep 2021 02:45:21 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x27so5313129lfa.9;
        Tue, 28 Sep 2021 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5MxU6Fbjn/yvVlEfiCDpyfyuAEPctmlJ+a6oqrIoiwc=;
        b=O18qPKcpfnQwoFTzcvCKjkwP4Wy3wYoSCm1oHlcr7VNklsET3C3dGelF58eOwJE2v4
         h9QouLqcEZ9gGwo9MpjFmRAMFkGhZp4V9nR8Bud2Val3cHhCNXaERT68EMg7PhKU+vo0
         BGjSrp7eXSZlWGj/ahb2QXu+HAeta3RMBYCsXHcFaLz3ZOru/hK4EPAFUAQ+Wp0w9TKu
         J36xOLF7rfOk5w3RwDY1icOgfa4c+M7C1B+z2oUZlxt3WR1CCZIG9HtWheANup0LcdCu
         27iEpgkWWFeTEriaWBnFxBE7wJ6DydqowmaBJ3uQCTGs4DrPX+lfs9bAnOFviW+WwGZp
         WSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5MxU6Fbjn/yvVlEfiCDpyfyuAEPctmlJ+a6oqrIoiwc=;
        b=Vspl3Fl4S2Jb4cLlLUf25ebc3oObHEHQyzJu5u9oKn+X9VDTB9BiMS8bHJRbfUL05U
         7VuUtG+f+hxJOcQdnp7gWqaKToaW164utehoefrxm2Pcz0L576jDDq+tGPmRFKBpDjGY
         YEWx+tN1YbfM6Cx3gIVm5JZ23Kv+jJWgVLl1uzdWJWM4Ur5CUUUA8oqsmtSEyeORFWsf
         DMr4IB2+Ln9quWr9xhaToO8XftPuP0pAKYp3vWNuXJ3gqS+hV3hAx8zcGDXTBDzFkxFZ
         kzUQwXvenTG7Huo798Og79kb/xYYLwY7PATnivmqw76O6Z36jGjg7isCd5DILwzPAXnp
         bmfQ==
X-Gm-Message-State: AOAM531Qyc0/cqNPytImkCUt5iVi2IeZ1d7hvY4kEhZiLwB2il1bxbuU
        MHKfg1SGLMGwqe+tT0t08Tw=
X-Google-Smtp-Source: ABdhPJy6V1iBnwydx/3qvfeqUikzf/XRl+AmQryuN2M8wIsL/QfcC+EkA0mF+zrE5Ov3qQaVcBdZtg==
X-Received: by 2002:a05:6512:2090:: with SMTP id t16mr4815125lfr.119.1632822319787;
        Tue, 28 Sep 2021 02:45:19 -0700 (PDT)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id y9sm2055738lfl.240.2021.09.28.02.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 02:45:19 -0700 (PDT)
Message-ID: <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
Date:   Tue, 28 Sep 2021 12:45:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili> <20210928092657.GI2048@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210928092657.GI2048@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 12:26, Dan Carpenter wrote:
> On Tue, Sep 28, 2021 at 11:55:49AM +0300, Dan Carpenter wrote:
>> I don't have a solution.  I have commented before that I hate kobjects
>> for this reason because they lead to unfixable memory leaks during
>> probe.  But this leak will only happen with fault injection and so it
>> doesn't affect real life.  And even if it did, a leak it preferable to a
>> crash.
> 
> The fix for this should have gone in devm_of_mdiobus_register() but it's
> quite tricky.
> 
> drivers/net/phy/mdio_devres.c
>     106  int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
>     107                               struct device_node *np)
>     108  {
>     109          struct mdiobus_devres *dr;
>     110          int ret;
>     111
>     112          if (WARN_ON(!devres_find(dev, devm_mdiobus_free,
>     113                                   mdiobus_devres_match, mdio)))
>     114                  return -EINVAL;
> 
> This leaks the bus.  Fix this leak by calling mdiobus_release(mdio);
> 
>     115
>     116          dr = devres_alloc(devm_mdiobus_unregister, sizeof(*dr), GFP_KERNEL);
>     117          if (!dr)
>     118                  return -ENOMEM;
> 
> Fix this path by calling mdiobus_release(mdio);
> 
>     119
>     120          ret = of_mdiobus_register(mdio, np);
>     121          if (ret) {
> 
> Ideally here we can could call device_put(mdio), but that won't work for
> the one error path that occurs before device_initialize(). /* Do not
> continue if the node is disabled */.
> 
> Maybe the code could be modified to call device_initialize() on the
> error path?  Sort of ugly but it would work.
> 
>     122                  devres_free(dr);
>     123                  return ret;
>     124          }
>     125
>     126          dr->mii = mdio;
>     127          devres_add(dev, dr);
>     128          return 0;
>     129  }
> 
> Then audit the callers, and there is only one which references the
> mdio_bus after devm_of_mdiobus_register() fails.  It's
> realtek_smi_setup_mdio().  Modify that debug statement.
> 
Thank you, Dan, for analysis, and it sounds reasonable to me.

Back to bug reported by syzbot: error happened in other place:

int __mdiobus_register(struct mii_bus *bus, struct module *owner)
{
....
	phydev = mdiobus_scan(bus, i);		<-- here
	if (IS_ERR(phydev) && (PTR_ERR(phydev) != -ENODEV)) {
		err = PTR_ERR(phydev);
		goto error;
	}
....
}

(You can take a look at the log [1] you won't find error message about 
mii_bus registration failure. I found this place while debugging locally)


So, Yanfei's patch is completely unrelated to bug reported by syzkaller 
and Reported-by tag is also wrong.

Can you, please, take a look at [2]. I think, I found the root case of 
the reported bug. Thank you :)


[1] https://syzkaller.appspot.com/text?tag=CrashLog&x=131c754b300000

[2] 
https://lore.kernel.org/lkml/20210927112017.19108-1-paskripkin@gmail.com/




With regards,
Pavel Skripkin
