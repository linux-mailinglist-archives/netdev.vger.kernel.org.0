Return-Path: <netdev+bounces-10884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B80C730A01
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E442A1C20DB3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86570134C5;
	Wed, 14 Jun 2023 21:51:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CF92EC0B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:51:30 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ACE268A;
	Wed, 14 Jun 2023 14:51:28 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9828a7a39d1so81469466b.0;
        Wed, 14 Jun 2023 14:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686779487; x=1689371487;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ojH11rOD4V92+B3RoF/GiQHE5eM6XkdZpqEdacgaeIk=;
        b=iprfy/Irh8eDU98dt6Xe6/6txgUtuoDhr/0o0Ydowq+ptVFfNfOwlA1icUJoxQwRnl
         56KEY7QTlfnwMjV5RMX2hi4yS2FfExhdi/Tbdy210JbR1iG1Qg5SxymmezUKtNiC82Cm
         IDnDnyM0FcbPXixXm/T1inH0u+T9B6uX6hMIte1K4X+qXMJfom4kCDHDGJPH7mDpLG1r
         Wmx4foF0jMS2BnKT/1G0ky9JZo78+lqui4Liv6KFonBqYoA7y5zQRSRI9mWrn5ZJfRPs
         UERUHVNEpsdoW7CPONZeYz5rvJodiIX1qpJIaUB4Q7sxfpH1pFmbm71+4feGI92QN4xD
         HSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686779487; x=1689371487;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ojH11rOD4V92+B3RoF/GiQHE5eM6XkdZpqEdacgaeIk=;
        b=awMUZEyt7nnNShbfECzVop4PVtnKJ5ZZ+bMEAcGzk5a3gfZSjv5b14IjFkpH6ET3ea
         QkWxFJUovwNEI4rvGQulMW5/LlxpLTCnByZvxfc1363VAR9Gx2J988chAijIE7VYMw/a
         pYIRaCrhCenDUkyQKM1Lf6reMqt92rsFJxfs7Zvgj5CEIdXFUGZCQKBB5xy5dM9/6+E6
         M23t4F7xoPkI/09CPiSs0t5PqPWakWHJQh3eGw0f79kLxH9jDaKBDq2bk00n0U4+N5Pn
         0eioh9S5qjKKGYaocqG2iK0zZ/N0NykDECvdwB2vyi9jmuO/77W6+KHnVYx1QRu/t9+M
         wycg==
X-Gm-Message-State: AC+VfDyUtl5pKOpY1ovlRmVOIiXbNgPIsavQV5Qqbp2GupWaN4Ye9cJK
	vzi6ZVMxzxGo6st16O9XrdA=
X-Google-Smtp-Source: ACHHUZ6/DkqjfyfP6ofet2xwj/rhOu17T+1aVZtDjeYL7kAWWpa1Q4ys+VB8e7un8gkyU7Xi3VyMVg==
X-Received: by 2002:a17:907:9349:b0:973:e4c2:2bcd with SMTP id bv9-20020a170907934900b00973e4c22bcdmr15216901ejc.18.1686779487092;
        Wed, 14 Jun 2023 14:51:27 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id g18-20020a1709061c9200b00965a4350411sm1178381ejh.9.2023.06.14.14.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 14:51:25 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:51:22 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v4 6/7] net: dsa: introduce
 preferred_default_local_cpu_port and use on MT7530
Message-ID: <20230614215122.rzjv3ovab5nunchs@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-7-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612075945.16330-7-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:59:44AM +0300, arinc9.unal@gmail.com wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> Since the introduction of the OF bindings, DSA has always had a policy that
> in case multiple CPU ports are present in the device tree, the numerically
> smallest one is always chosen.
> 
> The MT7530 switch family, except the switch on the MT7988 SoC, has 2 CPU
> ports, 5 and 6, where port 6 is preferable on the MT7531BE switch because
> it has higher bandwidth.
> 
> The MT7530 driver developers had 3 options:
> - to modify DSA when the MT7531 switch support was introduced, such as to
>   prefer the better port
> - to declare both CPU ports in device trees as CPU ports, and live with the
>   sub-optimal performance resulting from not preferring the better port
> - to declare just port 6 in the device tree as a CPU port
> 
> Of course they chose the path of least resistance (3rd option), kicking the
> can down the road. The hardware description in the device tree is supposed
> to be stable - developers are not supposed to adopt the strategy of
> piecemeal hardware description, where the device tree is updated in
> lockstep with the features that the kernel currently supports.
> 
> Now, as a result of the fact that they did that, any attempts to modify the
> device tree and describe both CPU ports as CPU ports would make DSA change
> its default selection from port 6 to 5, effectively resulting in a
> performance degradation visible to users with the MT7531BE switch as can be
> seen below.
> 
> Without preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
> [  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver
> 
> With preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
> [  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver
> 
> Using one port for WAN and the other ports for LAN is a very popular use
> case which is what this test emulates.
> 
> As such, this change proposes that we retroactively modify stable kernels

I keep mentally objecting to this patch and then I need to remind myself
why this decision was taken. I believe that a key element influencing
that decision is not sufficiently highlighted.

You can add, right here, after "stable kernels":

"(which don't support the modification of the CPU port assignments, so
as to let user space fix the problem and restore the throughput)"

> to keep the mt7530 driver preferring port 6 even with device trees where
> the hardware is more fully described.
> 
> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

