Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A73535083
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 21:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFDT6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 15:58:44 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:35501 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDT6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 15:58:44 -0400
Received: by mail-wm1-f41.google.com with SMTP id c6so13924wml.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=G2f3vMfSNJw3LLdtLwKk1+YL0T97U1YBnbTLXlkw07Q=;
        b=vSo3VP+XkFafF4BhA75r7g8jTag4wXQMdMt0zGnIjy1KyrkNn7ZJsvL1RpqlU+mMnK
         Q0SeGbFq/8M8E1fsijJhTN1LwDMxXPTLfnx68BlXODFHIPXHbZIXGd+slftteC9DORJJ
         dc5xePrwH+SJ+nhf3WcmFo6OeXAmOMN7TCDLzCuGrYLQH3xzoQ8KM6LGJOIMkfsSurOv
         WXiPADGuPFVIf0cg+/i8GcbU+tB+zvrXBo0bZSMCrhQ/1+5PSn6Lv8fRgTjkQwOxcP3m
         46fKY0PlmXfum/n5zT7JSsiFpQqtysDxfse2PKQixej/b2d40nqgU5wWjzDKyctDGUfp
         MJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=G2f3vMfSNJw3LLdtLwKk1+YL0T97U1YBnbTLXlkw07Q=;
        b=Q3s7m4ccV6yUxX1mzjk2EWtyitcjQPAikkz52XBGPYZ0kyrXJ7SoOvWh6c4YngRIsh
         1KrTzvb6r1iBCmSt7ZtN/607HfV5XSDWE2CBMrywMXP0DvEmrbm7r3LEMWDKQ3pMQHNk
         /d4UaAEZG5rSBeG+OG68iFS+koH94fFopCdH+CteJNQLX1+MNDNH5IyS5kT2JkzK+BcB
         ywNwd2RwnEijfVXImoql32f2BQSGsgSv5QOljwHzSpJDpMKRB8CVvYutZ/LJ9AFLZU4T
         RpHi7569sNONz7Y5mKC0NERfR0Cek0UbmHQMXZqa0wlmLT/l2lEFki4QP1kNkfliWfMo
         GsCg==
X-Gm-Message-State: APjAAAXmM332T+H6MWt73xev1mCbx45JvCAesclN9zB94KGgnEMz29bl
        qmnh+y2uWssyweH1mAybYe4=
X-Google-Smtp-Source: APXvYqxtaa7knOQtAW6satP78lJRWxOyOH6Sxf2YmOg3LtpVLbv0wKd4y6tvqvOjNoFevmMMKFKcfw==
X-Received: by 2002:a1c:8017:: with SMTP id b23mr19334851wmd.117.1559678322650;
        Tue, 04 Jun 2019 12:58:42 -0700 (PDT)
Received: from [192.168.1.2] ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id p16sm34211478wrg.49.2019.06.04.12.58.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 12:58:42 -0700 (PDT)
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Subject: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Message-ID: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
Date:   Tue, 4 Jun 2019 22:58:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been wondering what is the correct approach to cut the Ethernet 
link when the user requests it to be administratively down (aka ip link 
set dev eth0 down).
Most of the Ethernet drivers simply call phy_stop or the phylink 
equivalent. This leaves an Ethernet link between the PHY and its link 
partner.
The Freescale gianfar driver (authored by Andy Fleming who also authored 
the phylib) does a phy_disconnect here. It may seem a bit overkill, but 
of the extra things it does, it calls phy_suspend where most PHY drivers 
set the BMCR_PDOWN bit. Only this achieves the intended purpose of also 
cutting the link partner's link on 'ip link set dev eth0 down'.
What is the general consensus here?
I see the ability to be able to put the PHY link administratively down a 
desirable feat. If it's left to negotiate/receive traffic etc while the 
MAC driver isn't completely set up and ready, in theory a lot of 
processing can happen outside of the operating system's control.

Regards,
-Vladimir
