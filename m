Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750856D0921
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjC3PJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbjC3PJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:09:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2BBCDE9;
        Thu, 30 Mar 2023 08:08:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id le6so18328458plb.12;
        Thu, 30 Mar 2023 08:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z0Z7V7Ss/AtXBRghpZkg8HPKEk/gIK+rbrkFIOnWykw=;
        b=hrKdvXgmz+intqH6k/82qhZO+TXJRFUbWkit5YyihN3zsu13/kSZ0hpW0LVa5b7XVy
         h+KE9JOb8fFAzZYG60AOgY5RNeZjapZ/L4Q/l8g7HQ/PudZPn7BQcfZPJUOnIezdbY4C
         WSW3uXVaJ72O2Q73JC17f1rYt+NLA0tgOfwHgId0U4xbayGoLw4zd3TjSMl1QDWNgoay
         yTwQK2Gz1n74v92l4Hst8OFJ8LVY/EVXYX0JhaQjQyWBDAUqOmPaaYMrR+yRmkM0qv9w
         Gx2josZg2bXesXPWbGOJJSnHTl4S9C2rpx+jZ2yk/jHkgPBwBiMzTH317fUL6yDpgkZ4
         ScyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0Z7V7Ss/AtXBRghpZkg8HPKEk/gIK+rbrkFIOnWykw=;
        b=uZgpifKQADUHARRsbAmYQAtEWMv3BBbV4oq92E+XEE/XRFUXVk3rsgByioUc5P9tGf
         62Qrc0iduTXECZXY53cEfHM3OZCNEdSRQUhH1ytaDJ3b66295cEuKQzooq3BymYG5FtQ
         U8tIR1WDR1jSjOWCZCOFT7TsWddsDrpqSjcpEZ3jzuRB2xSV5SsusiuhuDyCmu9Lowl/
         E57xNE3crvjh3FhCJ4DYpTAA4u99MJxQ7zPpBFH1erEP8fexd3LStXpNIyDLedfDRml/
         oFa4UAzjOdTvVQplWZrmbl+nxWi/kqVfNXwcVJOemInnb5YtxywcV+tTx6pcEDEvqZlv
         92Qg==
X-Gm-Message-State: AO0yUKXN7dNK6rWOhA2+pZ3qW9ELXIQFyE5bFJCX4aCbUgDA5jjhVcXM
        lBLF5ykqAV//SQlHQ7ngd40=
X-Google-Smtp-Source: AK7set+uK7+GwFdenHrawwnv6t1AUOM2gsI7rgDOiMu7/kWlK6xgT1y03qBrqCUPM+I2yWXxPnmQ2w==
X-Received: by 2002:a05:6a20:6ca6:b0:db:cfb5:33aa with SMTP id em38-20020a056a206ca600b000dbcfb533aamr20045536pzb.56.1680188893105;
        Thu, 30 Mar 2023 08:08:13 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w25-20020aa78599000000b00625037cf695sm24868986pfn.86.2023.03.30.08.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:08:12 -0700 (PDT)
Date:   Thu, 30 Mar 2023 18:07:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230330150752.gdquw5kudtrqgzyz@skbuf>
References: <20230327160009.bdswnalizdv2u77z@skbuf>
 <87pm8tooe1.fsf@kapio-technology.com>
 <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
 <20230328114943.4mibmn2icutcio4m@skbuf>
 <87cz4slkx5.fsf@kapio-technology.com>
 <20230330124326.v5mqg7do25tz6izk@skbuf>
 <87wn2yxunb.fsf@kapio-technology.com>
 <20230330130936.hxme34qrqwolvpsh@skbuf>
 <875yaimgro.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yaimgro.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:54:19PM +0200, Hans Schultz wrote:
> I don't know if you have a solution in mind wrt the behaviour of the
> offloaded flag if it is not to do as it does now and let the bridge age
> out dynamic entries. That led me to conclude that this patch-set cannot
> use the offloaded flag, but you seem to suggest otherwise.
> 
> If you have a suggestion, feel free.

Didn't I explain what I would do from the first reply on this thread?
https://patchwork.kernel.org/project/netdevbpf/patch/20230318141010.513424-3-netdev@kapio-technology.com/#25270613

As a bug fix, stop reporting to switchdev those FDB entries with
BR_FDB_ADDED_BY_USER && !BR_FDB_STATIC. Then, after "net" is merged into
"net-next" next Thursday (the ship has sailed for today), add "bool static"
to the switchdev notifier info, and make all switchdev drivers (everywhere
where a SWITCHDEV_FDB_ADD_TO_DEVICE handler appears) ignore the
"added_by_user && !is_static" combination, but by their own choice and
not by switchdev's choice.

Then, make DSA decide whether to handle the "added_by_user && !is_static"
combination or not, based on the presence of the DSA_FDB_FLAG_DYNAMIC
flag, which will be set in ds->supported_fdb_flags only for the mv88e6xxx
driver. When DSA_FDB_FLAG_DYNAMIC is not supported, DSA will not offload
the FDB entry: neither will it call port_fdb_add(), nor will it emit
SWITCHDEV_FDB_OFFLOADED. Ideally, it would also inform user space that
it can't offload this flag by returning an error, but the lack of an
error propagation mechanism from switchdev to the bridge FDB is a known
limitation which is hard to overcome, and is outside the scope of your
patchset I believe. To see whether DSA has acted upon the "master dynamic"
flag or not, it would be good enough for the user to see something
adequate in "bridge fdb show | grep offloaded", I believe.
