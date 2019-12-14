Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184A211EFF7
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLNCRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:17:03 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39142 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfLNCRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 21:17:03 -0500
Received: by mail-lf1-f68.google.com with SMTP id y1so630373lfb.6
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 18:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YMzVhA4TREW9tiFC6MiVaHtoPClBHm4/K2iOjpWjE2A=;
        b=KTT9QhS8NJAM0lyoaHmTvE5cNXypGuOj9YIlgFqHWDwsuKbPzy0arEYRtrFdZlC47j
         NX66fF7rk7X7RIZZhblN6AHJaFHBZCUV74D3aS5GJOt4xEGo7czcXK5rsBtu6z2hjyWb
         A4Uhhe+J87KuMRjg6jC8RSYoxq+bW2qDjbv+cHBLwSg/esUKnOspki6JRtMjDhpLgkIM
         ZqvjJZ7IZ3fyi2DWG1/0QImOS1TKPOhiw/AhPCdCEW0PvNz1d/2o2uzmtxu/Gz0/onao
         iTuK7Z6VBODYprSenoRPzGHG/KjzE3CGZDfrNyE9S5dhzudBmixCKG1BurBBQ+BZNxzF
         r2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YMzVhA4TREW9tiFC6MiVaHtoPClBHm4/K2iOjpWjE2A=;
        b=OCc7Ux7MH1LNmujQLOGWfM1ea6dlbjHrDxKxhzf3ah4KXfaXbiaiptFvPDWhMaUOIa
         z/mbrW0Y9BQoDcy4u4g5al031hzGPsGGtDNcQ5I28M20Z8o58fUppdGDgv1v/QquiNmy
         TPkuAvcXv2vD6QangdkVbGZZIjIMaW3U7wdavef8MfJhL5x7cIA9rdFP2Hxy/Yw7zBjA
         Wdisl76UpCK6yVu6xncg/Zdto8aSdpi1ZDSn9JOrRJ0DOaVH97Fptq5aJWDqBamHmTap
         fo0e9gTTg6dJeL/TzmxOXu/seLJSs5H/l9+okofHMl0HjokftR8rVVfO7PkRBdXBd0LG
         Xzlw==
X-Gm-Message-State: APjAAAVvYr1PH2vPmwqu4+Zhc1NQwJzKNiKdM+mFIkbeaBleUfwsv/+l
        glqmj+M7C7We80RUjmhrhmOmQA==
X-Google-Smtp-Source: APXvYqzAKMFZH2EOJSKaihLyrb82FMv3qqQBZwlU9OdgfnEgrFd5pZc1cIdqEYaUKIJgFVSimI8iIw==
X-Received: by 2002:ac2:508e:: with SMTP id f14mr9748482lfm.72.1576289820517;
        Fri, 13 Dec 2019 18:17:00 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 2sm5675255ljq.38.2019.12.13.18.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 18:17:00 -0800 (PST)
Date:   Fri, 13 Dec 2019 18:16:54 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Firo Yang <firo.yang@suse.com>
Subject: Re: [PATCH net] tcp/dccp: fix possible race
 __inet_lookup_established()
Message-ID: <20191213181654.33e5999e@cakuba.netronome.com>
In-Reply-To: <457a933e-9168-2ad4-ca3d-4aaf7040a67d@gmail.com>
References: <20191211170943.134769-1-edumazet@google.com>
        <20191212173156.GA21497@unicorn.suse.cz>
        <CANn89i+16zwKepVcHX8a0pz6GrxS+B9y6RiYHL0M-Sn_+Gv1zg@mail.gmail.com>
        <20191212184737.GB21497@unicorn.suse.cz>
        <20191213175219.35353421@cakuba.netronome.com>
        <457a933e-9168-2ad4-ca3d-4aaf7040a67d@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 17:57:23 -0800, Eric Dumazet wrote:
> On 12/13/19 5:52 PM, Jakub Kicinski wrote:
> > I need to remove a whitespace here:
> > 
> > WARNING: Block comments should align the * on each line
> > #98: FILE: include/net/inet_hashtables.h:111:
> > + * reallocated/inserted into established hash table
> > +  */
> > 
> > So last chance to adjust the comment as well - perhaps we can
> > s/into/from/ on the last line? 
> > 
> > Or say "or we might find an established socket that was closed and
> > reallocated/inserted into different hash table" ?
> > 
> > IMHO confusing comment is worse than no comment at all :S
> >   
> 
> Sure, I will send a V2.

Oh even better, thank you!
