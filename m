Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4915B1C60E3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgEETOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEETOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:14:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97687C061A0F;
        Tue,  5 May 2020 12:14:09 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h11so1217706plr.11;
        Tue, 05 May 2020 12:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AMQjHklvVQp8kLG2jdJ/FZUlk13ISomLbpvw9v/vCEA=;
        b=LYsM8+Tl4vjqomLGLLzRn3FTLZGWZKGg8tg5+yPy/bp4zdiUIEv6E9aHqiIz0h66DE
         TnAybeL39QPQoU3/WmYUHs0sJl364AaTUz/1ZS7upTH79bdwCKeOXmfyuuM/Hf+M6NRs
         Ti5/hjUoEvAJYzbPGbNKOxHjwbJn6HoSrB8ZXhTyHLEqLdhgxVtF8pUMCrtEp2O4ek/y
         /fX3hk2LU8eMbRYeidHbX7ZnxJPb+JI4Uau6gdZ6JyIL8TNOM9RMOCEYxvuul4ucYaB+
         GR0c1sA+KF7d39Mqt5n36Yja5SeT1T4eJB6oi6XAG+210soAwsm5V0ISXPMvLtq3jKL+
         +GMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AMQjHklvVQp8kLG2jdJ/FZUlk13ISomLbpvw9v/vCEA=;
        b=Tc++xbki0e+xAdQ0582XGUwTGEqrqE0EMziisNm+dZXbyCLhYq8altGhn7K4+HUDE8
         yoh4SM9ZOgjwYUSmWRusJ9xbh85HZUt2dMyi/ZQiAhI/VJaYJWVBBj+As6rwjfiPrAxe
         R58xBowuQe5YWGzFKktdreBnwKOyw8agbfm1QA5oz6QmNsjznOVw+VQWTy0OPktfpKzX
         JfUcOd8xJz0anqbG3UXn1gxoJynXF6anlEGKK6reL9nhkxp9RFMiVTjsNXw/rNtNx0/X
         z6L/rMEF5yxMMQ5+P+87/r+a3NfKHpHs1SiLEjsOLNibMIYk18S7sROym84M0Tj9MLma
         6h1w==
X-Gm-Message-State: AGi0PuadPvFmrT73dX8LgdxPOdmQvDm93R/YxToWqdSCbwrQSRRtG+dv
        WzwVGs+n/ce4HV8Wq/G2Ywo=
X-Google-Smtp-Source: APiQypINnciGRgQTOyBGie2I7fcyZymRaMAr9cKIOnDeCc3yOFSzaJKS2cKSRMI3uRqRjfKD9kn1Mw==
X-Received: by 2002:a17:90a:d985:: with SMTP id d5mr4642222pjv.171.1588706048939;
        Tue, 05 May 2020 12:14:08 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e28e])
        by smtp.gmail.com with ESMTPSA id 131sm2164452pgg.65.2020.05.05.12.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 12:14:08 -0700 (PDT)
Date:   Tue, 5 May 2020 12:14:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200505191405.v3xai47bxeaqsmyg@ast-mbp.dhcp.thefacebook.com>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <89101da0-20e4-a29f-9796-870aa4d328a6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89101da0-20e4-a29f-9796-870aa4d328a6@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Hi,
> 
> I see the objtool warning:
> kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x33: call without frame pointer save/setup
> 
> when using:
> gcc (SUSE Linux) 9.3.1 20200406 [revision 6db837a5288ee3ca5ec504fbd5a765817e556ac2]
> 
> with the attached config file.

Thanks Randy. I reproduced it.
