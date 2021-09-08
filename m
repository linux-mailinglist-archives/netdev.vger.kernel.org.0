Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8643A4040DD
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 00:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbhIHWJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 18:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbhIHWJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 18:09:45 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485DDC061575;
        Wed,  8 Sep 2021 15:08:37 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g8so4945912edt.7;
        Wed, 08 Sep 2021 15:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=VBAGFGwrV6My3M7WCsYfCb12ANprEDTyOrbroDO3Vpw=;
        b=Q2WhAOoiS6fQ0aLjqJdZmEUCEZO4WqWq40c6W+3Rj+kh6WGU2zwGUVSAFIAtfFvQb4
         5JOXK7ABEx5QytUxwABV8GnxVnFfDH4YuWxRjlq7NKhgbQ4QiQE4SnCeu86AdwfyvjQK
         UChp/5qkfB7NPSMdCzguFiljgsJ1htWus48sqq4+Vlm6FcA6BQNBdFKH62JamATMc4R7
         qWJY2Qp8UDMZ0OPlvMQAO9oggAEO99JdKgffR5hyOazKAs6fwYbF92eF73afPzzfCfIM
         Rvl4NGkcMQp5vXNg6mkWxEajmIgqVV9XvYFd8ePjCAMLRLD7PB9KarKaIgg0fsS21Ada
         xBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VBAGFGwrV6My3M7WCsYfCb12ANprEDTyOrbroDO3Vpw=;
        b=DGDN+vIqTGYYXWbA0IfzlrlRNlLiTJPYU6Rv9vYYZ+2431LecpuSh/Yeqcqq8I2T9S
         yG6rMu0oOTHGJq/Jlyu1TXt22Hy0o+UN55f/uU6tWa+DAWmiaUduDRYTjybykHLZhSTg
         YZXiST70pWtnFMwxqHj07ZGeLObh+xnQuueJIiOW+R50fw8f+SlLWb2a+JlK1uuhFlV3
         X8eJ5UDfhKUOk+NdG0r8lK7JZeVPRZBKqap0G8Kx95DP8tdJ6u7ffTFS1sz4RKjJgUtL
         io4FL2VPs496F27EClXJ1tMTKvAebgcpPu/8VIcw6Cx9q6t4nqaeU3x6nvjbLF+CqmCi
         V5Uw==
X-Gm-Message-State: AOAM5331/dKVbUQ3AYziny7uTPTlUX17Vi5axLyAkVlnGFWjtMOMl+Hp
        daHVFdjt5+C9wjvwU42wKYM=
X-Google-Smtp-Source: ABdhPJyAX5iJInw8VBWMJZf55kQdCJRNoTZZ9/va5DV6QpA/lPy2cpEcToZHD/lRvHEHwLzcve2R1g==
X-Received: by 2002:a50:99cc:: with SMTP id n12mr477598edb.53.1631138915862;
        Wed, 08 Sep 2021 15:08:35 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id sb21sm116807ejb.8.2021.09.08.15.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 15:08:35 -0700 (PDT)
Date:   Thu, 9 Sep 2021 01:08:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Circular dependency between DSA switch driver and tagging protocol
 driver
Message-ID: <20210908220834.d7gmtnwrorhharna@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Since commits 566b18c8b752 ("net: dsa: sja1105: implement TX
timestamping for SJA1110") and 994d2cbb08ca ("net: dsa: tag_sja1105: be
dsa_loop-safe"), net/dsa/tag_sja1105.ko has gained a build and insmod
time dependency on drivers/net/dsa/sja1105.ko, due to several symbols
exported by the latter and used by the former.

So first one needs to insmod sja1105.ko, then insmod tag_sja1105.ko.

But dsa_port_parse_cpu returns -EPROBE_DEFER when dsa_tag_protocol_get
returns -ENOPROTOOPT. It means, there is no DSA_TAG_PROTO_SJA1105 in the
list of tagging protocols known by DSA, try again later. There is a
runtime dependency for DSA to have the tagging protocol loaded. Combined
with the symbol dependency, this is a de facto circular dependency.

So when we first insmod sja1105.ko, nothing happens, probing is deferred.

Then when we insmod tag_sja1105.ko, we expect the DSA probing to kick
off where it left from, and probe the switch too.

However this does not happen because the deferred probing list in the
device core is reconsidered for a new attempt only if a driver is bound
to a new device. But DSA tagging protocols are drivers with no struct
device.

One can of course manually kick the driver after the two insmods:

echo spi0.1 > /sys/bus/spi/drivers/sja1105/bind

and this works, but automatic module loading based on modaliases will be
broken if both tag_sja1105.ko and sja1105.ko are modules, and sja1105 is
the last device to get a driver bound to it.

Where is the problem?
