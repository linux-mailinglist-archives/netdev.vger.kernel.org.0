Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7736EDE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfFFIjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:39:06 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:52716 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfFFIjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 04:39:05 -0400
Received: by mail-wm1-f53.google.com with SMTP id s3so1485238wms.2
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 01:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7W4AZwmqFUjZP9AmWoxftQySqTDv4cSCVrTgTUVf7H4=;
        b=cQos73BvgyiB1IQg1OSNrvkqRifL47HYGi5e4Nx6PhXHRgSZwW/eVPfwQyHtd3Dh0L
         KE1tKX8cfKJ/QRgGu3UABnZupi1wAtGK7aPYoTak22AKAOzDaoC5oCxU+HZV3eeZPWUt
         +X8DmH8DRgukz6TnG9GSm4rV6+ZYE2JC2Xml8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7W4AZwmqFUjZP9AmWoxftQySqTDv4cSCVrTgTUVf7H4=;
        b=mR5KYGflcXGtEUbUIfl4t+l5b5PjSPvTD7rials9x5qoh2vCx7C3dZtT25Th/YL3O2
         td9pznGIshZR79kr0I4b5stMy388gMQH50ofGQ0GeYkQI53EKBQ/iklzFb9wR43Leyng
         3FsoHbOrqgOXIjJlAkqDQzZotwGDQ9ilorEqV+rL8PBPgQjuzBeYhqhc/XFaOtwHAhPQ
         SvXQqmY4CrG1hGP/VU5OzFizWjUsNlTytG06ensxRcBZmEJU7qheeq1bPUttS+Lh9yss
         KPmwOr69UptwS5y8uUX+VOi8e+vPnR1/IiqNFOJLkzdp23HzdxDmxTslemmnYoFESCCV
         2UUA==
X-Gm-Message-State: APjAAAU9LyCkG9YgT9om9vCwWVGKbhqpv3t712iGessogT91HE2/g9Uz
        N4WWiqYjwQpdUL/B8B4kmzC66Q==
X-Google-Smtp-Source: APXvYqxI6aQUuskRypHMcd/HfB7YUgAcRnE+c1mMH+wiMTozaFTrPbPqe4oDqYXjqjcaH9UF3hDz8A==
X-Received: by 2002:a1c:3dc1:: with SMTP id k184mr26163386wma.88.1559810343349;
        Thu, 06 Jun 2019 01:39:03 -0700 (PDT)
Received: from andrea (86.100.broadband17.iol.cz. [109.80.100.86])
        by smtp.gmail.com with ESMTPSA id q21sm1076707wmq.13.2019.06.06.01.39.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 01:39:02 -0700 (PDT)
Date:   Thu, 6 Jun 2019 10:38:56 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606083856.GA5337@andrea>
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 10:46:40AM +0800, Herbert Xu wrote:

> The case we were discussing is from net/ipv4/inet_fragment.c from
> the net-next tree:

BTW, thank you for keeping me and other people who intervened in that
discussion in Cc:...

  Andrea


> 
> void fqdir_exit(struct fqdir *fqdir)
> {
> 	...
> 	fqdir->dead = true;
> 
> 	/* call_rcu is supposed to provide memory barrier semantics,
> 	 * separating the setting of fqdir->dead with the destruction
> 	 * work.  This implicit barrier is paired with inet_frag_kill().
> 	 */
> 
> 	INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
> 	queue_rcu_work(system_wq, &fqdir->destroy_rwork);
> }
> 
> and
> 
> void inet_frag_kill(struct inet_frag_queue *fq)
> {
> 		...
> 		rcu_read_lock();
> 		/* The RCU read lock provides a memory barrier
> 		 * guaranteeing that if fqdir->dead is false then
> 		 * the hash table destruction will not start until
> 		 * after we unlock.  Paired with inet_frags_exit_net().
> 		 */
> 		if (!fqdir->dead) {
> 			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
> 					       fqdir->f->rhash_params);
> 			...
> 		}
> 		...
> 		rcu_read_unlock();
> 		...
> }
> 
> I simplified this to
> 
> Initial values:
> 
> a = 0
> b = 0
> 
> CPU1				CPU2
> ----				----
> a = 1				rcu_read_lock
> synchronize_rcu			if (a == 0)
> b = 2					b = 1
> 				rcu_read_unlock
> 
> On exit we want this to be true:
> b == 2
