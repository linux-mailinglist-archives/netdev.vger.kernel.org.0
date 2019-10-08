Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE88D01E8
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 22:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfJHUIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 16:08:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41095 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbfJHUIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 16:08:43 -0400
Received: by mail-qt1-f196.google.com with SMTP id v52so6661qtb.8
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 13:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QkA8x3ljMc7ax0HrFVpN1nehSnwi9fMrWIBTtIlXyqc=;
        b=bh/C4oUgnE5Mb5aHeW4fi1Nhtj5MfsB1sF7myKPU2e8eK/cGuTbbZZFL1Tj22tZSIw
         3r2Secu58XxxheWkW9oK6r+fAwfpLDb1piTp4md4dVt0arThVRfcg1ulh9QfHH6gUsTR
         XLeIcazakvlk7WI0SFGnkir+cwfW/SJ0x3w8m/keJd0LRpwAZiQzOTbW04wmRbmkUEtv
         kemUeUJuYAwsI3IRbf4oh9YI/9QOKYtenQLcHXeBYchgBgYFV1VebtVgEAulloiyQTpC
         2TpHq62rLRY33ko3zG7sUj48Bl9RTtbjFuRS3O7AAUAZ13tOn4U4oU2f0+K5SboJlqZb
         1kuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QkA8x3ljMc7ax0HrFVpN1nehSnwi9fMrWIBTtIlXyqc=;
        b=hqQQ9h9ykEvISVVtKKfRl8/FQDePekRuk0Fbkw51tzQGBdXl8yCuEAfGvEML5u3Asy
         PxBd5R4A7L+vFQ1EvD1QCwrnypEUlpBPGonfBgMHgP8hWtzDUymsA2Lnk4WuSymhUcqH
         Iy/7tOEJa1AYPBsH+uf7prSW5f6wk+CwQsit969jzMup7rfcC2Q3XD553rChktysEc/P
         5yfmiFIwDb/RPEAUKMFVGszWibNHwa1bGN2L0fJjr709XyUQfDFMp/rf6616kxjVxkkZ
         6bmZB8jab2DC6N6ZKPMV0VUhuQYTO7DjwurqE9vTKVB6AIBvapvgn6CpXgT8J4PgPpSN
         pqOA==
X-Gm-Message-State: APjAAAVRfSRo9f+dRvKsXFoijJiOFC3fl+TK0QbiLnzQPfe+9ogbRN33
        qJRbUYdxs0DpwCsojQWuIiJKNQ==
X-Google-Smtp-Source: APXvYqwbyCifHRtHFBE4YZ68dr7CWB4q6ml54jsDZx/mlwIUjc3Ek2yCnWvXKGKIuf9yy7TaZZ6/Eg==
X-Received: by 2002:a0c:fc4f:: with SMTP id w15mr35420590qvp.156.1570565323087;
        Tue, 08 Oct 2019 13:08:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x59sm10876607qte.20.2019.10.08.13.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 13:08:42 -0700 (PDT)
Date:   Tue, 8 Oct 2019 13:08:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] tun: fix memory leak in error path
Message-ID: <20191008130830.718eeee8@cakuba.netronome.com>
In-Reply-To: <CANn89iKvs06pp-WR7KfUVF2mdnAyyXybfxZL5_RBKG25B6rzjw@mail.gmail.com>
References: <20191007192105.147659-1-edumazet@google.com>
        <20191008123137.23c2c954@cakuba.netronome.com>
        <CANn89iKvs06pp-WR7KfUVF2mdnAyyXybfxZL5_RBKG25B6rzjw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 12:47:56 -0700, Eric Dumazet wrote:
> On Tue, Oct 8, 2019 at 12:31 PM Jakub Kicinski wrote:
> > On Mon,  7 Oct 2019 12:21:05 -0700, Eric Dumazet wrote:  
> > > syzbot reported a warning [1] that triggered after recent Jiri patch.
> > >
> > > This exposes a bug that we hit already in the past (see commit
> > > ff244c6b29b1 ("tun: handle register_netdevice() failures properly")
> > > for details)
> > >
> > > tun uses priv->destructor without an ndo_init() method.
> > >
> > > register_netdevice() can return an error, but will
> > > not call priv->destructor() in some cases. Jiri recent
> > > patch added one more.
> > >
> > > A long term fix would be to transfer the initialization
> > > of what we destroy in ->destructor() in the ndo_init()
> > >
> > > This looks a bit risky given the complexity of tun driver.
> > >
> > > A simpler fix is to detect after the failed register_netdevice()
> > > if the tun_free_netdev() function was called already.
> > >
> > > [...]
> > >
> > > Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>
> > > Reported-by: syzbot <syzkaller@googlegroups.com>  
> >
> > Looks good, obviously. Presumably we could remove the workaround added
> > by commit 0ad646c81b21 ("tun: call dev_get_valid_name() before
> > register_netdevice()") at this point? What are your thoughts on that?  
> 
> This is indeed something that could be done now, maybe by an independent revert.

Independent revert seems like the best idea.

Applied this one, thanks!
