Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4E8419EFE
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhI0TTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbhI0TTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:19:32 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0B0C061575;
        Mon, 27 Sep 2021 12:17:54 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b15so80777513lfe.7;
        Mon, 27 Sep 2021 12:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wEfxWfUoYccYf25wS9BkLtpKu+l+UR+F26xvznXRDZ4=;
        b=A2IMAi3ek2c6xu1e1l4JxGlNaewQNfxD+chIxMJlaSav9qLQoOe1Yk9uLfMjtv64I6
         lpHwqMZnZfBF5/PkB3i0y7va8EqNPcNnzIoECEPOA4VVDyUtur1fA5SM1TdHUS2VMq0S
         oh2KGus3ew26mlkuXdoE08KTrp8wjEd5usAWjxR9dr1Bwc1ZNVzPCTnVEbVww+yELaNa
         sRJRvn+PLMI4Kq1PC517Im6M0N/n+Pbc+qKUy5ou30v5FKamVvuVt+9hjMDw2AqVUKxe
         NmRpo8iQnf0gWuXcfd5l+S2pNhgQ5Xz72Bfc0t2DEICIQleuxTfs6kEwoJP7QUle14pz
         2i4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wEfxWfUoYccYf25wS9BkLtpKu+l+UR+F26xvznXRDZ4=;
        b=xAR1P4PxKcyXo5G0k4VSqGzX9WyrW4ZBDQuAFU0wuuVLMtDdLq9Yd1XZZ+uqcNiz/W
         IJTZpOLzcWl0GD/F2lJ1hm5FDnCgC+KZTcgEBZiUzMIuJBkVOmWTKUhQUxjOEt9HVNTE
         WeTLt5JE//iaXpBFfidCY73GV5Jx7qEFeOeFc0jWnQxUYghtzmOunfqJ5Rf9mHn6IAOw
         9q75Mf5M/yz+fjXbsof/bsRy2lXqLSvuV8C6gIX3mhZOQRo3m5TQ1UPJ7QNypOXVYclc
         db72deqWfnUR2yJFDQTgIE7dOnCchBPxroiQAtj/lQ6vVyeK4b3iU3aRFXivHpjYwQMx
         65SA==
X-Gm-Message-State: AOAM533Anlo25Rko1GTrQYfbiBKdGkPkcwBGodBOWqA8GwngMWxd9Qo2
        vSikksTZIrQeIcaa6r5s48w=
X-Google-Smtp-Source: ABdhPJycZUWljo2OGk1cPkJhHkiHOQ6wo+6TvbqEIExoUXWt+UkLu5ug96rrfBX5Lx0q1V6vTn5abQ==
X-Received: by 2002:a05:6512:3a96:: with SMTP id q22mr1408300lfu.228.1632770272625;
        Mon, 27 Sep 2021 12:17:52 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id 21sm1686703lfz.128.2021.09.27.12.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 12:17:52 -0700 (PDT)
Message-ID: <68ed78d0-4e72-cbb5-bfa8-d7a92ea7a377@gmail.com>
Date:   Mon, 27 Sep 2021 22:17:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] phy: mdio: fix memory leak
Content-Language: en-US
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
References: <20210927112017.19108-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210927112017.19108-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 14:20, Pavel Skripkin wrote:
> Syzbot reported memory leak in MDIO bus interface, the problem was in
> wrong state logic.
> 
> MDIOBUS_ALLOCATED indicates 2 states:
> 	1. Bus is only allocated
> 	2. Bus allocated and __mdiobus_register() fails, but
> 	   device_register() was called
> 
> In case of device_register() has been called we should call put_device()
> to correctly free the memory allocated for this device, but mdiobus_free()
> was just calling kfree(dev) in case of MDIOBUS_ALLOCATED state
> 
> To avoid this behaviour we can add new intermediate state, which means,
> that we have called device_regiter(), but failed on any of the next steps.
> Clean up process for this state is the same as for MDIOBUS_UNREGISTERED,
> but MDIOBUS_UNREGISTERED name does not fit to the logic described above.
> 
> Fixes: 46abc02175b3 ("phylib: give mdio buses a device tree presence")
> Reported-and-tested-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>


I've just found, that this syzkaller bug has been closed by Yanfei's 
patch [1], but Yanfei's Reported-by: is wrong, IMO.

Yanfei's patch fixed other memory leak and it's not related to bug 
reported by syzkaller. If you take a look at log [2] you won't find 
error message about mii_bus registration failure, i.e the error happened 
a bit latter (more precisely in mdiobus_scan()).

Since, Yanfei's patch is already applied, we cannot remove this tag, so 
I am informing you about this situation to break possible confusions 
about 2 different patches with same Reported-by: tag :)


Thanks


[1] 
https://lore.kernel.org/netdev/20210926045313.2267655-1-yanfei.xu@windriver.com/

[2] https://syzkaller.appspot.com/text?tag=CrashLog&x=131c754b300000


With regards,
Pavel Skripkin
