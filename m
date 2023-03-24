Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C0A6C8026
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjCXOoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjCXOn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:43:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D195D12051;
        Fri, 24 Mar 2023 07:43:56 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x3so8722950edb.10;
        Fri, 24 Mar 2023 07:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679669035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C21jvyZVXMZAcNncraIer8AUyEAdXPxhhiclNufk6dM=;
        b=OI/NV6HZnkGU+Z1W7MqzD4PVmaiqNR43yWSKyXm5HcHjljLi09QfGuChCC4Cop3Mq6
         cgALULB7vvDenLhbzYcUEL23+pKpStq5Yd0VbuQqa9Zvv/WBI9GxVOmr1vSxq94eLf71
         I2kmdjaufmyHf8aA9L0U6XZaZlP3xIikWgZ68jo1KRz2jMuvUdlTnIqWBWoXYV+clbBW
         fJ2sY/TLR0IurmpL2YUnxMyuNnlIJrqqvQaNifHbf886QZiS8UzSEX68nZvyzrNit25n
         VZfucIry1S4PXUeYglFZaWuLbSiv0ne4JMzzdiOU/I2ziWBbBAc1lkR/U1RtqCLh9mHT
         +Nqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679669035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C21jvyZVXMZAcNncraIer8AUyEAdXPxhhiclNufk6dM=;
        b=N51bpIu7Mk/PAUu5nMtUShUY7lMe3D+R7Lkx9ybs/G9+8p78jx9a68kyYbFVYvb8Yu
         wk+Xz7yTTTZQsGnJTIeUjus6PNUpbpVGItSnSTuiIk+Y6dfgVcV/qL+Ydn7dNQ8HO6SP
         +4WLzb0D2YU3QCnBPFKKUM/8+3LB/PZk+zcP2FEoQKjBxJCj0cuDJwktPFf8BLFtXQ9q
         4J6s4l9RVoUFJxFOBhvUXesO2jfpz+f/2M/rBxFcSSN/KK/aS0mQZXgVpWSgSZZkzydD
         of6179rvaCC5XQnpGMArMn9hddT/fRuoo9TEPgg3QaL/21dTJz5vmphtyR1julVzhmy4
         JvDQ==
X-Gm-Message-State: AAQBX9dnuQBdkK5xWfAsnFhZLqS9ifqI5VJ2XygswpbvF533vFGz0tsM
        NN3ezSEGRsruVBm6qpuw/RV+7EzWUW89yQ==
X-Google-Smtp-Source: AKy350b1GPFgS+RKuJjs0iGqrLrD974ShBQf060WLsGpWMVUNlyChRn1VtNaPk1K85VinJZt1i33Cw==
X-Received: by 2002:a17:906:329b:b0:8e3:74ad:94ce with SMTP id 27-20020a170906329b00b008e374ad94cemr2746328ejw.8.1679669034424;
        Fri, 24 Mar 2023 07:43:54 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id lj24-20020a170906f9d800b00932ba722482sm9534542ejb.149.2023.03.24.07.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:43:54 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:43:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: What is the best way to provide FDB related metrics to user
 space?
Message-ID: <20230324144351.54kyejvgqvkozuvp@skbuf>
References: <20230324140622.GB28424@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324140622.GB28424@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Fri, Mar 24, 2023 at 03:06:22PM +0100, Oleksij Rempel wrote:
> Hello all,
> 
> I am currently working on implementing an interface to provide
> FDB-related metrics to user space, such as the size of the FDB, the
> count of objects, and so on. The IEEE 802.1Q-2018 standard offers some
> guidance on this topic. For instance, section "17.2.4 Structure of the
> IEEE8021-Q-BRIDGE-MIB" defines the ieee8021QBridgeFdbDynamicCount
> object, and section "12.7.1.1.3 Outputs" provides additional outputs
> that can be utilized for proper bridge management.
> 
> I've noticed that some DSA drivers implement devlink raw access to the
> FDB. I am wondering if it would be acceptable to provide a generic
> interface for all DSA switches for these kinds of metrics. What would be
> the best interface to use for this purpose - devlink, sysfs, or
> something else?

It's not an easy question. It probably depends on what exactly you need
it for.

At a first glance, I'd say that the bridge's netlink interface should
probably report these, based on information collected and aggregated
from its bridge ports. But it becomes quite complicated to aggregate
info from switchdev and non-switchdev (Wi-Fi, plain Ethernet) ports into
a single meaningful number. Also, the software bridge does not have a
hard limit per se when it comes to the number of FDB entries (although
maybe it wouldn't be such a bad idea).

ieee8021QBridgeFdbDynamicCount seems defined as "The current number of
dynamic entries in this Filtering Database." So we're already outside
the territory of statically defined "maximums" and we're now talking
about the degree of occupancy of certain tables. That will be a lot
harder for the software bridge to aggregate coherently, and it can't
just count its own dynamic FDB entries. Things like dynamic address
learning of FDB entries learned on foreign interfaces would make that
utilization figure quite imprecise. Also, some DSA switches have a
VLAN-unaware FDB, and if the bridge is VLAN-aware, it will have one FDB
entry per each VLAN, whereas the hardware table will have a single FDB
entry. Also, DSA in general does not attempt to sync the software FDB
with the hardware FDB.

So, while we could in theory make the bridge forward this information
from drivers to user space in a unified form, it seems that the device
specific information is hard to convert in a lossless form to generic
information.

Which is exactly the reason why we have what we have now, I guess.

What do you mean by "devlink raw access"? In Documentation/networking/dsa/dsa.rst
we say:

| - Resources: a monitoring feature which enables users to see the degree of
|   utilization of certain hardware tables in the device, such as FDB, VLAN, etc.

If you search for dsa_devlink_resource_register(), you'll see the
current state of things. What is reported there as device-specific
resources seems to be the kind of thing you would be interested in.
