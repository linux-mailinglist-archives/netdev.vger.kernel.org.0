Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9EA352F22
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhDBSVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhDBSUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:20:55 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CCAC0613E6;
        Fri,  2 Apr 2021 11:20:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so2726582wmi.3;
        Fri, 02 Apr 2021 11:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IK3P6moRtbr3GXePGjyoKwVTBySnTC80FZZAwgYpc2k=;
        b=OANzGNsAYXnblsIsVSpq9y6XcOiByCDvuKNym1v+nCzx7++T/1z6pzz6DB3PV2Ih6w
         8redi8QHQ85zWSba0oNwsBOPl5EXGTbavpgebV7Ol/cpKh8Ed7yvcZV8mfr6JSXlJGWr
         QyqwNmIbGvTYV50rIWkaHWmShBeJ7poejZlU98UTOeJnh8E0tGbDr+NtzHJ0VL2mKKKk
         j+yfhdeKnDIhdiJ57E+DKGyC8T4jIBTY3no8Lol+2wOPYHaq1xswGqJodZkW4dXUZJyt
         nTmDsxFqiT1eG5fozBiKOsPsQEdnvkauNNIvJvq+MgrrQpV3icylnF+RJ1Q96nXptHJb
         tbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IK3P6moRtbr3GXePGjyoKwVTBySnTC80FZZAwgYpc2k=;
        b=LU3JowwARYVpEOjERI8uVRjlW6I1yxAcw4z0Pi5GAGKYDenXl7UvvFeOScKULdFj4L
         h3hnEDOVBeGJ6lhu9zW0z7sNFxzuNmS6ZgabAz/4W3q4PfotMNx8IBHyFnu1AaZtww0L
         h4sGGXJ4hrYFr7Itv45dB6TqTavaq0ABVS+xKWDZ3aB6PK/Su52m8e2+Z65OdkAk5KvD
         agHGxphj0uf9Vhx3gKlTV7O2P9bnkVMlQXugeYgAq/4xs05IndY8HftbDJT916zJwzWm
         +Kg6KqVmOW/zzQ6YlwfQfOm+v+skDNTJnZp0AGMn4J1lsgVKkI/KIQPyGDWnQ7l5exQW
         61Og==
X-Gm-Message-State: AOAM532fZRTW1l77mqrFYrcXjYwfNa5mTwQ12zR8EfaOL92gZW1Mczv3
        ZYahZk27CgdpLHKwLwstzI0rXlqjOdY=
X-Google-Smtp-Source: ABdhPJx+MVlOXgqJ4rC9OILIDn/RFcxafYMzdF+BB1tlSusn93Ehy5QhEbD0mVfR01OE9vpTomPwig==
X-Received: by 2002:a7b:c357:: with SMTP id l23mr13677428wmj.152.1617387652748;
        Fri, 02 Apr 2021 11:20:52 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.24.151])
        by smtp.gmail.com with ESMTPSA id h10sm15189196wrp.22.2021.04.02.11.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 11:20:52 -0700 (PDT)
Subject: Re: [PATCH net v2] atl1c: move tx cleanup processing out of interrupt
To:     Gatis Peisenieks <gatis@mikrotik.com>, chris.snook@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6ea0a3d1bcf79bb1e319d1e99cfed9b@mikrotik.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <502d7e87-3bd9-29f3-eb18-753331d424e6@gmail.com>
Date:   Fri, 2 Apr 2021 20:20:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c6ea0a3d1bcf79bb1e319d1e99cfed9b@mikrotik.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/21 7:20 PM, Gatis Peisenieks wrote:
> Tx queue cleanup happens in interrupt handler on same core as rx queue processing.
> Both can take considerable amount of processing in high packet-per-second scenarios.
> 

...

> @@ -2504,6 +2537,7 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
>                  NETIF_F_TSO6;
>      netdev->features =    netdev->hw_features    |
>                  NETIF_F_HW_VLAN_CTAG_TX;
> +    netdev->threaded = true;

Shouldn't it use dev_set_threaded() ?

>      return 0;
>  }
> 
> @@ -2588,6 +2622,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>      adapter->mii.phy_id_mask = 0x1f;
>      adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
>      netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
> +    netif_napi_add(netdev, &adapter->tx_napi, atl1c_clean_tx, 64);
>      timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
>      /* setup the private structure */
>      err = atl1c_sw_init(adapter);
