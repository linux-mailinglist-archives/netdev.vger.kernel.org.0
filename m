Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0C121F42F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgGNOfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgGNOfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:35:40 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F005BC061755;
        Tue, 14 Jul 2020 07:35:39 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e4so23007801ljn.4;
        Tue, 14 Jul 2020 07:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=0oatnh+z93vVFkayq3AmMhvHt3THUIRsjkAhGL6vXAA=;
        b=lDSNnBMQgcxcalaG4SyIPSAYWE3Bs1Uv0el2KK0R2oPelhy4Sv8aHVzVE8+WzqOJnN
         7gWoILw2/vAP/wIo2EnW9yYDkPxD5x0PWBVvydbeYGU8ogQAqc+UnKwkVqsIaIOqjplg
         ZttLtUzftQIltORW8irzzBrZ3auNP3f8oYi6cGi0PDx3DIpZoohnsQryg8FXTS1VxHVQ
         Es6jlVhHsYEs0nZ9Jmwc8MmXPnsj7xK9a2BLatWkJAyLgabRJ+MEmnXYcM9aZFcoLWB8
         VTN6vpnpBVaOq7iH6f9rupntmWJfFEYUbUdZ677RAAb7VTMqf7/2K2RLn6rNi8oSKwmj
         9yrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=0oatnh+z93vVFkayq3AmMhvHt3THUIRsjkAhGL6vXAA=;
        b=ZcIVEdKudqyHUVAl1nnRJwtPucIIbrhquiSM24iW75/VH4lyA7KMmMGmbey6ofh4o0
         ETeGbQTARWGKRAWJjogS5UfJpPDpQhClgWNl8pOSd62wCJvdFa/iaKcqpfSPOxSrSnXS
         31oJ5bpSENrtet4+8h4xk7URIp6mY1DZYMEx0MRG1lroWCV5V64UK22ZbYIAY36MJtRw
         jt+rPMXSpvQJdL75gOo0oNf+Maay3can83EF6Iuhjiqhw4VBuA84ygMpqYCTsZUtYH4C
         4GtJ1RkSKkXxLWH1p/z9J1KvvdWjeS3IveVq9BBQLO8PJuS0wQdlSauT9X6werV6O4PP
         dO/g==
X-Gm-Message-State: AOAM532rX1DSyiCuOXQ08A/YX9xYvt/q9jXDmksGCXuYh98yPz8JdFMA
        fAOB2kODXwTsBT9dpl0qzdxsvLzt
X-Google-Smtp-Source: ABdhPJxPQzzbdD7fDm8XYM8r+ukMAQEPVidWA4BBaqLCJUYGs8bNSUfrP1QHY36DFFmxD6J2NwQgMQ==
X-Received: by 2002:a2e:8043:: with SMTP id p3mr2599248ljg.469.1594737338288;
        Tue, 14 Jul 2020 07:35:38 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id i2sm4689470lji.59.2020.07.14.07.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 07:35:37 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200711120842.2631-1-sorganov@gmail.com>
        <20200711231937.wu2zrm5spn7a6u2o@skbuf> <87wo387r8n.fsf@osv.gnss.ru>
        <20200712150151.55jttxaf4emgqcpc@skbuf> <87r1tg7ib9.fsf@osv.gnss.ru>
        <20200712193344.bgd5vpftaikwcptq@skbuf> <87365wgyae.fsf@osv.gnss.ru>
        <20200712231546.4k6qyaiq2cgok3ep@skbuf> <878sfmcluf.fsf@osv.gnss.ru>
        <20200714142324.oq7od3ylwd63ohyj@skbuf>
Date:   Tue, 14 Jul 2020 17:35:36 +0300
In-Reply-To: <20200714142324.oq7od3ylwd63ohyj@skbuf> (Vladimir Oltean's
        message of "Tue, 14 Jul 2020 17:23:24 +0300")
Message-ID: <87k0z6dv0n.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Tue, Jul 14, 2020 at 03:39:04PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > On Mon, Jul 13, 2020 at 01:32:09AM +0300, Sergey Organov wrote:
>> 
>> [...]
>> 
>> >> > From the perspective of the mainline kernel, that can never happen.
>> >>
>> >> Yet in happened to me, and in some way because of the UAPI
>> >> deficiencies
>> >> I've mentioned, as ethtool has entirely separate code path, that
>> >> happens
>> >> to be correct for a long time already.
>> >>
>> >
>> > Yup, you are right:
>> >
>> 
>> [...]
>> 
>> > Very bad design choice indeed...
>> > Given the fact that the PHY timestamping needs massaging from MAC
>> > driver
>> > for plenty of other reasons, now of all things, ethtool just decided
>> > it's not going to consult the MAC driver about the PHC it intends to
>> > expose to user space, and just say "here's the PHY, deal with it". This
>> > is a structural bug, I would say.
>> >
>> >> > From your perspective as a developer, in your private work
>> >> > tree, where
>> >> > _you_ added the necessary wiring for PHY timestamping, I fully
>> >> > understand that this is exactly what happened _to_you_.
>> >> > I am not saying that PHY timestamping doesn't need this issue
>> >> > fixed. It
>> >> > does, and if it weren't for DSA, it would have simply been a "new
>> >> > feature", and it would have been ok to have everything in the same
>> >> > patch.
>> >>
>> >> Except that it's not a "new feature", but a bug-fix of an
>> >> existing one,
>> >> as I see it.
>> >>
>> >
>> > See above. It's clear that the intention of the PHY timestamping
>> > support
>> > is for MAC drivers to opt-in, otherwise some mechanism would have been
>> > devised such that not every single one of them would need to check for
>> > phy_has_hwtstamp() in .ndo_do_ioctl(). That simply doesn't scale. Also,
>> > it seems that automatically calling phy_ts_info from
>> > __ethtool_get_ts_info is not coherent with that intention.
>> >
>> > I need to think more about this. Anyway, if your aim is to "reduce
>> > confusion" for others walking in your foot steps, I think this is much
>> > worthier of your time: avoiding the inconsistent situation where
>> > the MAC
>> > driver is obviously not ready for PHY timestamping, however not all
>> > parts of the kernel are in agreement with that, and tell the user
>> > something else.
>> 
>> You see, I have a problem on kernel 4.9.146. After I apply this patch,
>> the problem goes away, at least for FEC/PHY combo that I care about, and
>> chances are high that for DSA as well, according to your own expertise.
>> Why should I care what is or is not ready for what to get a bug-fix
>> patch into the kernel? Why should I guess some vague "intentions" or
>> spend my time elsewhere?
>> 
>> Also please notice that if, as you suggest, I will propose only half of
>> the patch that will fix DSA only, then I will create confusion for
>> FEC/PHY users that will have no way to figure they need another part of
>> the fix to get their setup to work.
>> 
>> Could we please finally agree that, as what I suggest is indeed a simple
>> bug-fix, we could safely let it into the kernel?
>> 
>> Thanks,
>> -- Sergey
>
> I cannot contradict you, you have all the arguments on your side. The
> person who added support for "ethtool -T" in commit c8f3a8c31069
> ("ethtool: Introduce a method for getting time stamping capabilities.")
> made a fundamental mistake in that they exposed broken functionality to
> the user, in case CONFIG_NETWORK_PHY_TIMESTAMPING is enabled and the MAC
> driver doesn't fulfill the requirements, be they skb_tx_timestamp(),
> phy_has_hwtstamp() and what not. So, therefore, any patch that is adding
> PHY timestamping compatibility in a MAC driver can rightfully claim that
> it is fixing a bug, a sloppy design. Fair enough.

OK, thanks!

>
> The only reason why I mentioned about spending your time on useful
> things is because in your previous series you seemed to be concerned
> about that. In retrospect, I believe you agree with me that your
> confusion would have been significantly lower if the output of "ethtool
> -T" was in harmony with the actual source of hardware timestamps.
> Now that we discussed it through and I did see your point, I just
> suggested what I believe to be the fundamental issue here, don't shoot
> the messenger. Of course you are free to spend your time however you
> want to.

I do care about these things indeed, it's only that right now what I
care most is to get the fixes into the kernel.

Then we can think without hurry about how all this could be improved.

> Acked-by: Vladimir Oltean <olteanv@gmail.com>

Thanks for reviewing, and again for helpful and beneficial discussion!

-- Sergey
