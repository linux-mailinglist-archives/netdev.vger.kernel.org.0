Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB31EC750
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfKARMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:12:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46713 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfKARMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:12:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id u22so13735311qtq.13;
        Fri, 01 Nov 2019 10:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qBMruKDrI3Y48/s7yeyyJd+W3JxGzLZElVujOhMNo6A=;
        b=buxhYq1vZ0N+QH31OeIiVHzsQreNFrkDUAPUKeSLEcMP9R5h/LvZ1GURfJMH6xcb6Z
         V5dGQaCQILTWG6m52g+zvaEydQ2z0/OK0hdjk0KBPGP0c67PH+VKIGPmX3fL/+MtWb0v
         lahLDwyXElV9I+fckICB1sfR8tGhxiqfPRuz91j1pjQkiWmMfR9Ez30H+C38wajeAYo9
         D9BLnuH/AGvfpzKkvvxs/jTUlQCkawfQuCciXnX3esNMzwPZw3e4ge6xsD1SKR41h8Fl
         KI9Xng7klJdU8WLnbmfY3Ra8exeWOMjLW3ZlMymad0COZ7Prkmre6Zcrj7xZtmQPaCyv
         RgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qBMruKDrI3Y48/s7yeyyJd+W3JxGzLZElVujOhMNo6A=;
        b=HpyJ6muEP2grZLMfShhsXpIfvEcW0i9JMm7V18oIThhSRgDmcWPMJ/xHEiqf5g7anl
         +13eSzGNkDVnr2JVwGhhEvRqETLLxNUfdireyxTU67PWcTHXocyat4HAXnrNia6bYwMX
         3n1voJXECn7RgcNgXN+SN8yNdX6dBXDYcz8yk4GnjZKzGRPSAysjFDb68YrTN4kygT08
         eCpebAM7gw0PPxqwNeNAJu2+rqF8zILco/HCYkcYGkixQtNZkEbSNz42CJ38UHZbEPdw
         8OlKgSEe4PlvCqaPMnHg47/cHoRx5uBjTTEbV2a1YM4GsTKX9V24lw6TBNFbsLG/EOxj
         vpdQ==
X-Gm-Message-State: APjAAAUfUgjCV2BhMnsKMS/owrC0hio5ZE350q+P2O9MPnpvVF4KLyct
        cy10azkqrVd9ZMwTAdMNsPE=
X-Google-Smtp-Source: APXvYqyS8BC/NScTWDb66O2vz8siZmUL33ffFo8nCRgGbLvydjciCv+urAANR6Qa803PY7ZD0TFJ/g==
X-Received: by 2002:ac8:51d4:: with SMTP id d20mr334345qtn.239.1572628327191;
        Fri, 01 Nov 2019 10:12:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::ad6a])
        by smtp.gmail.com with ESMTPSA id o201sm3585630qka.17.2019.11.01.10.12.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 10:12:06 -0700 (PDT)
Date:   Fri, 1 Nov 2019 10:12:02 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] net: fix sk_page_frag() recursion from memory reclaim
Message-ID: <20191101171202.GP3622521@devbig004.ftw2.facebook.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
 <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
 <20191031162049.27e54d9412214aea79acd2ea@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031162049.27e54d9412214aea79acd2ea@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Oct 31, 2019 at 04:20:49PM -0700, Andrew Morton wrote:
> > > In [0], tcp_send_msg_locked() was using current->page_frag when it
> 
> "tcp_sendmsg_locked" and "current->task_frag".  Stuff like this makes
> review harder :(

lol, sorry about that.

> > > Fix it by adding gfpflags_normal_context() which tests sleepable &&
> > > !reclaim and use it to determine whether to use current->task_frag.
> > >
> 
> Dumb-but-obvious question.  Rather than putzing with allocation modes,
> is it not feasible to change the net layer to copy the current value of
> current->task_frag into a local then restore its value when it has
> finished being used?

It's being used as an allocation cache, so doing so would lead to the
same area getting allocated for two packets at the same time instead
overrunning the end of the cache.

Thanks.

-- 
tejun
