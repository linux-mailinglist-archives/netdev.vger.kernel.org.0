Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF9011EFCB
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfLNBw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:52:29 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34136 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfLNBw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:52:28 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so724877ljc.1
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QeM0cNANAVuFWpkkoxfUTePp88POyD3MqjOAJJEq/Fw=;
        b=K9rP3ajbsamDXjhogIXs8pQL3ntj+pkJ6Pwst0qUT/nTQa0JHhqBd8UqnDPGGa6WTs
         TwVIzGdIy0S9t+Qibbggu8OxE6wEwkNGJnrttT6cnyiYqfLnPFJzdQDul8uDYV1dnAxx
         8S9M9woamrzZ8rGxWS4rgDB6fFAot0sVLfKFv8sutmSvsB9FjNPXEzlDhANV+Q42cSsp
         M0ONlwZpLb8JPDhuH9dWjm3KFp9LneJ5SGM/qoUXxV6nyvH6vKAZXX/Kzg/Yt3aMTMbg
         5Vs3xniLWVmtcKx82xgaWXuq7JBfcbqYMoBCPbeWI7/Pk3h/FaTLHqebSLp/HVLgjoS/
         PLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QeM0cNANAVuFWpkkoxfUTePp88POyD3MqjOAJJEq/Fw=;
        b=k5AA+gD7v95Jk2A2CSZsIJd4kP0u5lq7ZFLceRAbicaEus1cnnkHgTpmj7IW8KLm3J
         PaNCG08f4RD4Rv3pY9qYJ5vlL44LvQ6vhoVq1vSz3htKYFSTcO2kpNih7DlwBK3qlldV
         NnuS221yloNQb/nu452kMgFhFuX9xL/wkEjJ5Lyev1ghEG3lTFC0SMSBB+xAnrLi6FKZ
         lZp3RfKgAbJjR+Tjs8J0sHtQXmp/rPjzJeZywheDfmrdSYOcXAt+5groqbr+ZllbJPIJ
         cMKwF9P/x/VyogtSP74yOODxh/DSXpSdVcAOTB/X4T5jvdTwi5LdNROCg+sSlbXRGJmb
         8ZCw==
X-Gm-Message-State: APjAAAXGuecs0EffpDpHXiQTG/sZHdlkBWDWoj4RMctKteX2XlMgo9s1
        gzd6y0pvHqMVcGAbu4kggE8Tcw==
X-Google-Smtp-Source: APXvYqwjVl3sVy8xvYm1hq6Rhy/ACipa4ImXZ79sDsWujwfeJdp4YhJIbheZFHn7ulXRXZWQ9EUuZA==
X-Received: by 2002:a2e:b0c4:: with SMTP id g4mr11440393ljl.83.1576288346484;
        Fri, 13 Dec 2019 17:52:26 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n3sm5222284lfk.61.2019.12.13.17.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 17:52:26 -0800 (PST)
Date:   Fri, 13 Dec 2019 17:52:19 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Firo Yang <firo.yang@suse.com>
Subject: Re: [PATCH net] tcp/dccp: fix possible race
 __inet_lookup_established()
Message-ID: <20191213175219.35353421@cakuba.netronome.com>
In-Reply-To: <20191212184737.GB21497@unicorn.suse.cz>
References: <20191211170943.134769-1-edumazet@google.com>
        <20191212173156.GA21497@unicorn.suse.cz>
        <CANn89i+16zwKepVcHX8a0pz6GrxS+B9y6RiYHL0M-Sn_+Gv1zg@mail.gmail.com>
        <20191212184737.GB21497@unicorn.suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 19:47:37 +0100, Michal Kubecek wrote:
> > > >  /*
> > > >   * Sockets can be hashed in established or listening table
> > > > - */
> > > > + * We must use different 'nulls' end-of-chain value for listening
> > > > + * hash table, or we might find a socket that was closed and
> > > > + * reallocated/inserted into established hash table
> > > > +  */  
> > >
> > > Just a nitpick: I don't think this comment is still valid because
> > > listening sockets now have RCU protection so that listening socket
> > > cannot be freed and reallocated without RCU grace period. (But we still
> > > need disjoint ranges to handle the reallocation in the opposite
> > > direction.)  
> > 
> > Hi Michal
> > 
> > I am not a native English speaker, but I was trying to say :
> > 
> > A lookup in established sockets might go through a socket that
> > was in this bucket but has been closed, reallocated and became a listener.  
> 
> I'm not a native speaker either. What I wanted to point out was that the
> comment rather seems to talk about the other direction, i.e. looking up
> in listener hashtable and ending up in established due to reallocation.
> That was an issue back when the offset was introduced (and when there
> was a check of end marker value in __inet_lookup_listener()) but it
> cannot happen any more.
> 
> > Maybe the comment needs to be refined, but I am not sure how, considering
> > that most people reading it will not understand it anyway, given the
> > complexity of the nulls stuff.  
> 
> I guess it can stay as it is. After all, one needs to see the lookup
> code to understand the purpose of the offset and then it's easier to see
> in the code what is it for.

I need to remove a whitespace here:

WARNING: Block comments should align the * on each line
#98: FILE: include/net/inet_hashtables.h:111:
+ * reallocated/inserted into established hash table
+  */

So last chance to adjust the comment as well - perhaps we can
s/into/from/ on the last line? 

Or say "or we might find an established socket that was closed and
reallocated/inserted into different hash table" ?

IMHO confusing comment is worse than no comment at all :S
