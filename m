Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A61047DA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 02:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUBFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 20:05:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44892 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfKUBFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 20:05:32 -0500
Received: by mail-pl1-f195.google.com with SMTP id az9so688530plb.11;
        Wed, 20 Nov 2019 17:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+xan1UFVEC5bpc84JCNLbsM7TcNqUcHB/vTfYJqMW5Y=;
        b=CAUd8kFfzFjdlwIAqIpwfueKhe+Ro/GYclcICHkgUpZxyRwF35oQLu832eK4hDNQR/
         QhQMxXBmwliCO+TOhJ9+8Kj5sHrYqKEw50kytv9PxzrSq9Du0jXbhaAmgjzLC665vp6+
         f8LLezB+8AmzONND8zPgBxGQ9Atu8WGE8sv1mhAmdhnPjDDaAZ/Z3fnHic9UxKC4OwKf
         vMgkmpOTUpTDKijoSGuxemJRhJQO++KHE62QJwzt8xGroqoUq9LOcTETxN1QlEAh8EU4
         ZI3yalo6niby9R7U3yqCPLJ1uOCjBJepnJTzgapdH8sgLFDKZSZfua+Q66q62BLq04K1
         qh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+xan1UFVEC5bpc84JCNLbsM7TcNqUcHB/vTfYJqMW5Y=;
        b=Hvc1hNlJEuvbT9aouX7dnLBo3tKCYWZpVVGnD1Va80CNJEHb45WvG/RrjX05fpY3XA
         pi6Sucq8eHWK/VmMhZRzKNUzhvapeMSzGySU1Mq/cXXfIrentF/2noecmg1OpM23tn/9
         LVXzUR80yH6MVErGvlQIxON/grf6ayScjQQC+smTxD9ZuJHGZtx592z9xECt4+7jDhaM
         eMgNlc4EtGnU44qy3HqVFZqXpyP2RoA9M4BFsZfIREDAEJjT5WvBXYer0GsTI8ZbVVHy
         t2zzcYxFuCy1lgzTIGT8gj+n5eRY0UoHt69CNbOAskMpBRs/gQy3BilHeTwKRAzqwBqU
         L/vA==
X-Gm-Message-State: APjAAAUeJH6a36+yGzJgWPCLBOIDwsL89xVxgM2G7yJ1X1PBLcHACx5U
        aq/B+VHnB/pPa8tT66+Gpww=
X-Google-Smtp-Source: APXvYqwIOQvxYDL6qtI/37Fvl6/4sgevqF9opKFXOr+M5OHVMpi1YJPqWJ2EFY+hfzBjN928hEHTDA==
X-Received: by 2002:a17:902:8d81:: with SMTP id v1mr5815296plo.289.1574298331187;
        Wed, 20 Nov 2019 17:05:31 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:250d:e71d:5a0a:9afe])
        by smtp.gmail.com with ESMTPSA id m6sm427110pgl.42.2019.11.20.17.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 17:05:30 -0800 (PST)
Date:   Thu, 21 Nov 2019 10:05:27 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Steven Rostedt <rostedt@goodmis.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20191121010527.GB191121@google.com>
References: <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1573751570.5937.122.camel@lca.pw>
 <20191118152738.az364dczadskgimc@pathway.suse.cz>
 <20191119004119.GC208047@google.com>
 <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
 <20191120013005.GA3191@tigerII.localdomain>
 <20191120161334.p63723g4jyk6k7p3@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120161334.p63723g4jyk6k7p3@pathway.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (19/11/20 17:13), Petr Mladek wrote:
[..]
> It is the first time that I hear about problem caused by the
> irq_work(). But we deal with deadlocks caused by wake_up() for years.
> It would be like replacing a lightly dripping tap with a heavily
> dripping one.
> 
> I see reports with WARN() from scheduler code from time to time.
> I would get reports about silent death instead.

Just curious, how many of those WARN() come under rq lock or pi_lock?
// this is real question

> RT guys are going to make printk() fully lockless. It would be
> really great achievement. irq_work is lockless. While wake_up()
> is not.
>
> There must be a better way how to break the infinite loop caused
> by the irq_work.

A lockless wake_up() would do :)

	-ss
