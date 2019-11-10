Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48721F6BE4
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 00:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfKJXsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 18:48:03 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38435 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfKJXsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 18:48:03 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so9377731pfp.5
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 15:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LKQ36RBhntPidFfbkBZTwB5P/0QcnZiLjWoe3GM1jLU=;
        b=IPonbSsdrwwlQTkRUdLdqRuq6R5pFlj2HocdZSGHPomHC4It1eaGB7QFkd9LekRQB9
         hu6lMPE4zgkXHKBp7wQsT6eaJKb73F25pMkh+jfA8S6e4pZp9Q4m73qAUsCKohdUMnBA
         itR7eZTFVpr87fHu0cGYGMbVPEBDe7QKldnoTHF0tr3wXwmmZPaSyiH3OYGtlhxxYv9N
         SYOupLqZzIJ0f/EzNtECOAJvH6+fwvPCym5Aw85EbMM3CjyYfMZs39YOCkrGiDxd06ZR
         zoEHyZMvzAZKKjHzujaGpo0z7Uy7e1IYQKDqGxVvnvaElSP8roZTiqJ0tr6wu9L/1AoQ
         P6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LKQ36RBhntPidFfbkBZTwB5P/0QcnZiLjWoe3GM1jLU=;
        b=rSzftBH+n9gF35xeQOrmoZIQVgq+y7BcIGePW2KvRt4BjAA4VW/DDRnqKjXOgm3ynU
         WPRkO8zo9d55Wrw377VQ7wl9+NNF7Vae1ULTAE4z3dBaxQdNsEtxdE6zE840rbn+kH0I
         kuhn5I+ZDXuzoRF8d7qtbYFIRuJX4Wa7TeJuMId8BGu/7LV96l4QTYYWso+1VdzsQ3Ky
         UoPv6Xkl1ydrkl45qYrN3OPkNDFRnz/B3O1yThjpQqRBLDab1VDSfrM53gVTRZpThp2B
         VcArAf+2colOAObkVD7sxfKAhtqi/N8Dr98e/zoAAk3ELz85uqnfCpsmhrOtC2pxomw+
         U/MA==
X-Gm-Message-State: APjAAAXl05Jl1VO2JrAkFLJLMf3OLNykuVaEF8UylIfQetU32L7mzvSF
        R4KFxRUBw3HcgsePShoI8K2knuwL
X-Google-Smtp-Source: APXvYqwnXo635WlZL5xYwMKFi0VktCOhdBE81mRrWXfDX7+eXLe8CXZP82YrX3d16awq+w4fwAvtNg==
X-Received: by 2002:a63:1042:: with SMTP id 2mr26356708pgq.59.1573429682300;
        Sun, 10 Nov 2019 15:48:02 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f2sm13144874pfg.48.2019.11.10.15.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2019 15:48:01 -0800 (PST)
Subject: Re: Possible bug in TCP retry logic/Kernel crash
To:     Avinash Patil <avinashapatil@gmail.com>, netdev@vger.kernel.org
References: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com>
Date:   Sun, 10 Nov 2019 15:47:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/19 9:59 PM, Avinash Patil wrote:
> Hi everyone,
> 
> Kernel: Linux 4.19.35 kernel built from linux-stable
> 

This is quite an old version.

Please upgrade to the latest one.

$ git log --oneline v4.19.35..v4.19.82 -- net/ipv4/tcp*c
3fdcf6a88ded2bb5c3c0f0aabaff253dd3564013 tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
67fe3b94a833779caf4504ececa7097fba9b2627 tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
5977bc19ce7f1ed25bf20d09d8e93e56873a9abb tcp: remove empty skb from write queue in error cases
6f3126379879bb2b9148174f0a4b6b65e04dede9 tcp: inherit timestamp on mtu probe
1b200acde418f4d6d87279d3f6f976ebf188f272 tcp: Reset bytes_acked and bytes_received when disconnecting
c60f57dfe995172c2f01e59266e3ffa3419c6cd9 tcp: fix tcp_set_congestion_control() use from bpf hook
6323c238bb4374d1477348cfbd5854f2bebe9a21 tcp: be more careful in tcp_fragment()
dad3a9314ac95dedc007bc7dacacb396ea10e376 tcp: refine memory limit test in tcp_fragment()
59222807fcc99951dc769cd50e132e319d73d699 tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
7f9f8a37e563c67b24ccd57da1d541a95538e8d9 tcp: add tcp_min_snd_mss sysctl
ec83921899a571ad70d582934ee9e3e07f478848 tcp: tcp_fragment() should apply sane memory limits
c09be31461ed140976c60a87364415454a2c3d42 tcp: limit payload size of sacked skbs
6728c6174a47b8a04ceec89aca9e1195dee7ff6b tcp: tcp_grow_window() needs to respect tcp_space()

