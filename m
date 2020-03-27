Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB52F194FE5
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgC0EFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:05:46 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44863 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgC0EFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:05:46 -0400
Received: by mail-qk1-f195.google.com with SMTP id j4so9513299qkc.11;
        Thu, 26 Mar 2020 21:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GByrdXs6lcU5kCSOoxR0ATrYfBsPPkiO/r5cVnhRM/k=;
        b=BrumY6/taf+vJ22SnRyZhu8VL/uvIlkZ5nGyN1Z2tO3Xa5r/K1Pz/+s+hXq+q1ODbl
         y5Qy0GnSv0KSzloJXKu57s38KifyWL4IJ2b9ZGmZrhsMcdeNJq39uRa0OK4FACxyJxgZ
         r1wWvNeri4P++8cT4k2cEMtKv4dJLaTG/nJU5RWtGfUPay//uKzgtLAJSgjj98TXWeyB
         JWwp+aNBpWhHYFe5W2xyPqmHRyhl2RwMJQmWv4061eCHpgsosSYCCqfErLJ+8F/cpMkL
         O6Ym4Wlm9ziVtgZGupnVHF0WjOKMafcxqJvA6njcQldmnlRIG6R44gLNHX08Wtj5iedg
         2f/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GByrdXs6lcU5kCSOoxR0ATrYfBsPPkiO/r5cVnhRM/k=;
        b=mkcEf0SIhyvNY62FeHu0k3XiPjPAYMu3kXBTkUVs3kmkBw9Ar0qZievqYZ35K22Hvv
         gPI7mgze4yZDimlcltSnd8cgs+yBVQvZyIO2xzW6M8TN091R9z2bsnofd4lBQybe6h4t
         dphBs56wmEf6wwGESfEcrtwt6A9vEnu10MoFVy689Y6wjm32AFtKJfgSTSKs3I974X/4
         wQLsjeTQjeMaDlzYG0ZtI4bf5lls6FEnsN3nOabapsbORvKRB3zg3Eg/mKR0gZtiekQM
         jgLLJ7r4JrlEr7byJRHHODMPkfFvhwZJ30CPSbiD3OnPUNNL8IiDeNOJQZZAQ8DNrbPA
         D+MA==
X-Gm-Message-State: ANhLgQ02c1ZBQk/8Xd4Uydhg+B1LKV8W0zD7kxe1Mu/Ty+bm/11+8WN0
        3lfrv7aosM8qRPOWrALYHNU=
X-Google-Smtp-Source: ADFU+vs+S6NHridaaaBDZTO/E9ZsShFQ3xAF7Ae2O/He6Gzy1qKxVW0mnafHU0aATRukIpfMciyoZQ==
X-Received: by 2002:a37:a614:: with SMTP id p20mr12236940qke.114.1585281937701;
        Thu, 26 Mar 2020 21:05:37 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.248])
        by smtp.gmail.com with ESMTPSA id q1sm3250572qtn.69.2020.03.26.21.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 21:05:36 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 24712C5CE4; Fri, 27 Mar 2020 01:05:34 -0300 (-03)
Date:   Fri, 27 Mar 2020 01:05:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com
Subject: Re: [PATCH v6] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200327040534.GK3756@localhost.localdomain>
References: <20200327030751.19404-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327030751.19404-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:07:51AM +0800, Qiujun Huang wrote:
> We should iterate over the datamsgs to move
> all chunks(skbs) to newsk.
> 
> The following case cause the bug:
> for the trouble SKB, it was in outq->transmitted list
> 
> sctp_outq_sack
>         sctp_check_transmitted
>                 SKB was moved to outq->sacked list
>         then throw away the sack queue
>                 SKB was deleted from outq->sacked
> (but it was held by datamsg at sctp_datamsg_to_asoc
> So, sctp_wfree was not called here)
> 
> then migrate happened
> 
>         sctp_for_each_tx_datachunk(
>         sctp_clear_owner_w);
>         sctp_assoc_migrate();
>         sctp_for_each_tx_datachunk(
>         sctp_set_owner_w);
> SKB was not in the outq, and was not changed to newsk
> 
> finally
> 
> __sctp_outq_teardown
>         sctp_chunk_put (for another skb)
>                 sctp_datamsg_put
>                         __kfree_skb(msg->frag_list)
>                                 sctp_wfree (for SKB)
> 	SKB->sk was still oldsk (skb->sk != asoc->base.sk).
> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

Acked-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Thanks Qiujun.
