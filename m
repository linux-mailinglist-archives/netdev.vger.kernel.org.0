Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454FF437C07
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhJVRjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhJVRjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:39:31 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E66BC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:37:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ls18so3451781pjb.3
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JGILPW70EhKHaH6mS2SKi/elH8Ua3oaJ/gGf+ornOUE=;
        b=ec+M4FOOOSoyV11rLq2a4MSk68Mr3QI90pgrK3bc7X+j4FDhJMKMU0ZvlgxheUj1nz
         W8AzFYn2eMudly8JExOH2ZC6RkphVWBGZbNK54MkTY0kLL0EAeg0iR3JpGc1bsCzzGWu
         RiOmXEYeN6NP4O4PwzmRjwJPCTicuxmM3KZ25nHCb3TqQl1q9rm2AALIzKZuuH2g44IU
         cvyozeNquwVOl95YP2unUA/J6jKWtWsULwzMnqH81qfmR8TsAOuhZiH52cUwGn4EQrEA
         gV+GsACtmhQi5llR44vVlQMsqW+cyQQVKbYUmt5QGPUc9Hxfv4rkGLt354eagpKh/h3O
         viMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JGILPW70EhKHaH6mS2SKi/elH8Ua3oaJ/gGf+ornOUE=;
        b=TrgJMbzIYvqymWr5GNjsCyp3Yc0iWG6ZKW4IUvS7wFMdygq/CcNLQNidhK336XFMzF
         b3ujfSX1uxypl9HjRt923UlKcrb+8sSCxDhgZkAs0MtMxuZ9fdNO4115HPXBYc1q6QFo
         W5ths396yxvsVzQMC6pwZv0zfAyDzBvtyibQVNhp2CmPpmEFouJPx7vFSlFKTgS47/Yu
         d40567xc9gFDsGH1B3tfxRx5HDsNposhIX7nSUuSGErVE7NzEB2Yz+e859r0FYPIb+C9
         Iz4fUxomCVv1JFu7CcIrEr5LGuyUjW1JgPwYF8GIQ0L1jVeYch/yfG+Fo0NlPaHBN1BU
         lc4w==
X-Gm-Message-State: AOAM531Gd+n+9xFiYRdXNigZX2gUb9FLWh5VDo809cTDvbnLgxdoPBwR
        VQ6ydV/VGPrWjExGthn9Wpo=
X-Google-Smtp-Source: ABdhPJyXw4DoFgePWRHOA+lt+imHxulcXoarDR6gcJRx1fQxxQ2wnZpu8mt+QVnIAft/HXgMKdY5Qw==
X-Received: by 2002:a17:90b:3b44:: with SMTP id ot4mr1474104pjb.114.1634924233605;
        Fri, 22 Oct 2021 10:37:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n18sm10030988pfu.214.2021.10.22.10.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:37:12 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 6/9] net: dsa: introduce locking for the
 address lists on CPU and DSA ports
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d953d624-a2ba-0052-34cc-c1f9ec8730c2@gmail.com>
Date:   Fri, 22 Oct 2021 10:37:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> Now that the rtnl_mutex is going away for dsa_port_{host_,}fdb_{add,del},
> no one is serializing access to the address lists that DSA keeps for the
> purpose of reference counting on shared ports (CPU and cascade ports).
> 
> It can happen for one dsa_switch_do_fdb_del to do list_del on a dp->fdbs
> element while another dsa_switch_do_fdb_{add,del} is traversing dp->fdbs.
> We need to avoid that.
> 
> Currently dp->mdbs is not at risk, because dsa_switch_do_mdb_{add,del}
> still runs under the rtnl_mutex. But it would be nice if it would not
> depend on that being the case. So let's introduce a mutex per port (the
> address lists are per port too) and share it between dp->mdbs and
> dp->fdbs.
> 
> The place where we put the locking is interesting. It could be tempting
> to put a DSA-level lock which still serializes calls to
> .port_fdb_{add,del}, but it would still not avoid concurrency with other
> driver code paths that are currently under rtnl_mutex (.port_fdb_dump,
> .port_fast_age). So it would add a very false sense of security (and
> adding a global switch-wide lock in DSA to resynchronize with the
> rtnl_lock is also counterproductive and hard).
> 
> So the locking is intentionally done only where the dp->fdbs and dp->mdbs
> lists are traversed. That means, from a driver perspective, that
> .port_fdb_add will be called with the dp->addr_lists_lock mutex held on
> the CPU port, but not held on user ports. This is done so that driver
> writers are not encouraged to rely on any guarantee offered by
> dp->addr_lists_lock.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
