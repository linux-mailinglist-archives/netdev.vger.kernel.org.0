Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99328522F70
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiEKJcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiEKJcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:32:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6751356A4;
        Wed, 11 May 2022 02:32:49 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id m20so2787950ejj.10;
        Wed, 11 May 2022 02:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2R9/wURm7kp9KYQIXozUkX8wxPrKLslH4VaNDn0oWs0=;
        b=NyCv4qaeunkpTmK532/dsGATD0bujUE4v5Vxrzx1AWaKsSj2yPcr4r8WgGA6StMOTl
         7/wBM5yd9WZzBTmo/Rm9HrzZMbJJ43aLaJg6xrknx7WurkcBnxWjFZ+kNiHzTBv4F4U5
         lz/8EZKUEZgigkbGKe5jvQOPHTiGFRXwCu3PybIEzIkYHeQdeCm3B7K02CxUH8o2AyeV
         3kdVOYAVF230sZOEIIaCbUyj7QqEnvs3yaWaXLxa8oNPgp7mWhZyOOorN+nlvMjYLLeC
         VcWC5hOQQrQNV7mVssCd5Bv1uGBEKpOD1GjyZHV/Ach/Bn52Vc4dW2IFlukxSLSoItf9
         YJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2R9/wURm7kp9KYQIXozUkX8wxPrKLslH4VaNDn0oWs0=;
        b=7baKYhVN8jdhu6KSsr33CAYF+skba7NN00Qu4XW2Go3S3dZZoo47kbcwRd4TUr/yZ5
         j+bDeK/MPjbpuVrsag4j1EmR7/Rzu2JafOGhMd9xPtOn+adbe7q9BfKwDWUE+/JbVZ/8
         afYRo4nacH6+YFQSfm2PQGYcfqpFK6rQJuhDOqtm95EHD5PmJnk4uXYzbu+sLFPGRjAX
         oo4VAVeeWJkX4hMfLqPfYBDUeGYmbm13cXCgogKSOK/LxenzwvtnccScOKORIeDAYOyQ
         pW4iLVXkh6EUbwyFxuRUwwnvaj446GkWwTLA8TtFYd2R2z9E9dr1XGaHPAH5Z26t7FPJ
         VLcw==
X-Gm-Message-State: AOAM530j97Mbvc9yQ5YZj+11qcLkRykf2qmZxHJ30jDy95cabgCVmv9u
        JYHkvV0PLXo/k+HXei3aAGo=
X-Google-Smtp-Source: ABdhPJy72CHL5PbNvu8py5RH4+WygdZt84TQ+hEVKauUfv/IexceOSRwzVyV10jkyrFutSL3AiPtlA==
X-Received: by 2002:a17:907:338b:b0:6f4:6e1:ed66 with SMTP id zj11-20020a170907338b00b006f406e1ed66mr23286843ejb.341.1652261567507;
        Wed, 11 May 2022 02:32:47 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id m12-20020a17090607cc00b006f3ef214df2sm765426ejc.88.2022.05.11.02.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 02:32:46 -0700 (PDT)
Date:   Wed, 11 May 2022 12:32:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <20220511093245.3266lqdze2b4odh5@skbuf>
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
 <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 10:50:17AM +0200, Felix Fietkau wrote:
> Hi Vladimir,
> 
> On 11.05.22 00:21, Vladimir Oltean wrote:
> > It sounds as if this is masking a problem on the receiver end, because
> > not only does my enetc port receive the packet, it also replies to the
> > ARP request.
> > 
> > pc # sudo tcpreplay -i eth1 arp-broken.pcap
> > root@debian:~# ip addr add 192.168.42.1/24 dev eno0
> > root@debian:~# tcpdump -i eno0 -e -n --no-promiscuous-mode arp
> > tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> > listening on eno0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
> > 22:18:58.846753 f4:d4:88:5e:6f:d2 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.42.1 tell 192.168.42.173, length 46
> > 22:18:58.846806 00:04:9f:05:f4:ab > f4:d4:88:5e:6f:d2, ethertype ARP (0x0806), length 42: Reply 192.168.42.1 is-at 00:04:9f:05:f4:ab, length 28
> > ^C
> > 2 packets captured
> > 2 packets received by filter
> > 0 packets dropped by kernel
> > 
> > What MAC/driver has trouble with these packets? Is there anything wrong
> > in ethtool stats? Do they even reach software? You can also use
> > "dropwatch -l kas" for some hints if they do.
> 
> For some reason I can't reproduce the issue of ARPs not getting replies
> anymore.
> The garbage data is still present in the ARP packets without my patch
> though. So regardless of whether ARP packets are processed correctly or if
> they just trip up on some receivers under specific conditions, I believe my
> patch is valid and should be applied.

I don't have a very strong opinion regarding whether to apply the patch or not.
I think we've removed it from bug fix territory now, until proven otherwise.
I do care about the justification (commit message, comments) being
correct though. If you cannot reproduce now, someone one year from now
surely cannot reproduce it either, and won't know why the code is there.
FYI, the reason why you call __skb_put_padto() is not the reason why
others call __skb_put_padto().

> Who knows, maybe the garbage padding even leaks some data from previous
> packets, or some other information from within the switch.

I mean, the padding has to come from somewhere, no? Although I'd
probably imagine non-scrubbed buffer cells rather than data structures...

Let's see what others have to say. I've been wanting to make the policy
of whether to call __skb_put_padto() standardized for all tagging protocol
drivers (similar to what is done in dsa_realloc_skb() and below it).
We pad for tail taggers, maybe we can always pad and this removes a
conditional, and simplifies taggers. Side note, I already dislike that
the comment in tag_brcm.c is out of sync with the code. It says that
padding up to ETH_ZLEN is necessary, but proceeds to pad up until
ETH_ZLEN + tag len, only to add the tag len once more below via skb_push().
It would be nice if we could use the simple eth_skb_pad().

But there will be a small performance degradation for small packets due
to the memset in __skb_pad(), which I'm not sure is worth the change.
