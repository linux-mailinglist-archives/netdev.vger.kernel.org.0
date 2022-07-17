Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D176577681
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiGQN77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 09:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiGQN76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 09:59:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24BE1400C;
        Sun, 17 Jul 2022 06:59:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id k30so12076063edk.8;
        Sun, 17 Jul 2022 06:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LbXvWfEaQpT3EOvVscba33ymf3op3INZ0urZAjVoQ+c=;
        b=GOZVLSmxUnmmok7nuMBDud3xiCRYe8eu91x9Qvgxc9cJaBQehuLzC3GA6UqGhwru53
         BHuY1Kk/C6M+StYzq7IsGg0gOcozgvgbA5Kj2hht9Nav7qPpTWi2k9XSlljKSO+JpJMX
         Z3Qu9EiRiTn2OIs0tiU7fWX5zVSlzz28tET+tAmXA2y1J7HU7xOF/jJy7ENI8BX6BPXD
         wHbrmfH7vtJeMT1SfokQhDGBil4sC2dPZfNPVTvOAgXco60vf+iR5YJDthf+rgUV/FT6
         A+l7WkBrCBx6yEvA/l3Oyt1Evqp+HUgzgYv4l43DAlW5yzcWWIGsHJlF9WgAt/FyIeff
         8GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LbXvWfEaQpT3EOvVscba33ymf3op3INZ0urZAjVoQ+c=;
        b=7dgKVAqFUJKiyWLWSJtM6VIT+uybUfq1tPKKPjs8JajjMDnOPmmERy9sKNWquiQoWi
         qN5oiMTMUedp5J3zeHDNjWVRX+sHxQl9pvoMcYMqyod5sPL3gzm9m4B+nxv9TFtxirMZ
         o2aLi3b4nsJSnCIK73LYWy6sdPDavuDN/dqURbPA1GU59nmvlp+7NHLgt9AwUDhprJMw
         1pfme4SRLoGeZJFRdRejZtPcphww7RTHEuPetV+EECbOfuJsm/t+Hj+pQTVX7G2Mfwky
         sdvFZ/npThr3UyYJRyXShsPHhOP0witj7H0Vx0PVS4uI3mkWadwwEP6nW4uRdYXKvFW0
         cHnA==
X-Gm-Message-State: AJIora/EZFIN86r3rQ4EmAjnOfS3mhASn8EkmxH6w3kbkcSH/Q/oWTgZ
        F7laHLFBBWsEuHRCiR2MG3E=
X-Google-Smtp-Source: AGRyM1slHNXAJnCxBZ/BWP8T3k0+2yJe1JC18WCLjCcfhqljeNhmrcHHXAAzZTZUlJ/j1k5rsI/uVw==
X-Received: by 2002:aa7:dd16:0:b0:43a:e850:a245 with SMTP id i22-20020aa7dd16000000b0043ae850a245mr30728413edv.127.1658066395289;
        Sun, 17 Jul 2022 06:59:55 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id p4-20020a05640243c400b0043b5fb04e76sm1297707edc.27.2022.07.17.06.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 06:59:54 -0700 (PDT)
Date:   Sun, 17 Jul 2022 16:59:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220717135951.ho4raw3bzwlgixpb@skbuf>
References: <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <20220717125718.mj7b3j3jmltu6gm5@skbuf>
 <a6ec816279b282a4ea72252a7400d5b3@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6ec816279b282a4ea72252a7400d5b3@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 03:09:10PM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-17 14:57, Vladimir Oltean wrote:
> > On Sun, Jul 17, 2022 at 02:21:47PM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-07-13 14:39, Ido Schimmel wrote:
> > > > On Wed, Jul 13, 2022 at 09:09:58AM +0200, netdev@kapio-technology.com
> > > > wrote:
> > > 
> > > >
> > > > What are "Storm Prevention" and "zero-DPV" FDB entries?
> > > 
> > > They are both FDB entries that at the HW level drops all packets
> > > having a
> > > specific SA, thus using minimum resources.
> > > (thus the name "Storm Prevention" aka, protection against DOS
> > > attacks. We
> > > must remember that we operate with CPU based learning.)
> > 
> > DPV means Destination Port Vector, and an ATU entry with a DPV of 0
> > essentially means a FDB entry pointing nowhere, so it will drop the
> > packet. That's a slight problem with Hans' implementation, the bridge
> > thinks that the locked FDB entry belongs to port X, but in reality it
> > matches on all bridged ports (since it matches by FID). FID allocation
> > in mv88e6xxx is slightly strange, all VLAN-unaware bridge ports,
> > belonging to any bridge, share the same FID, so the FDB databases are
> > not exactly isolated from each other.
> 
> But if the locked port is vlan aware and has a pvid, it should not block
> other ports.

I don't understand what you want to say by that. It will block all other
packets with the same MAC SA that are classified to the same FID.
In case of VLAN-aware bridges, the mv88e6xxx driver allocates a new FID
for each VID (see mv88e6xxx_atu_new). In other words, if a locked port
is VLAN-aware and has a pvid, then whatever the PVID may be, all ports
in that same VLAN are still blocked in the same way.

> Besides the fid will be zero with vlan unaware afaik, and all with
> zero fid do not create locked entries.

If by 0 you mean 1 (MV88E6XXX_FID_BRIDGED), then you are correct: ports
with FID 0 (MV88E6XXX_FID_STANDALONE) should not create locked FDB
entries, because they are, well, standalone and not bridged.
Again I don't exactly see the relevance though.
