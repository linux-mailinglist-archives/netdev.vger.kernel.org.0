Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596CC57F630
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 19:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiGXRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 13:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGXRcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 13:32:23 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D75115B
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 10:32:22 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n133so845572oib.0
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 10:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3yykez3+ZHpegi5wmkaYRUzjh7r9k1PAnPi3dbUmxYM=;
        b=nfuLYb3E3OELR/qNZPFIF3BkYIhtFupjUH4TBaCaYeMJvxne+y4YBZpPd6DtJVqaHN
         Utirk8ZrwqdmhNEfZdoo7rJ9Wmg07Ts6+bZ8TBw++0yOKs81oG7X+saUPvigBan56ryE
         NX4sQ1iYSCBNqsR/d7C+ijufnfir6yW3QtrVdastenFAk3AwtqRvvItzsSCESWtxgpYi
         65G4r3m5a39XHcjZl1yd4kWLjlhTSSMrlt+y4OjDCp7PcS30JyMj4LDJo/aRN0FpO/E0
         A5pMHxw4ho+4LjLV8nfWn6Ni0CeiDaKTz3wLBjWNBM0HCjd2ih2fXIk5EW9b0r3AB0g4
         OItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3yykez3+ZHpegi5wmkaYRUzjh7r9k1PAnPi3dbUmxYM=;
        b=7iBhTZZSMDxKeHJCnr7LQAGI+bJbibd7aEY/hWOnWDFAomjWozqXf6DHNaQfKHcx+c
         4Y5BhmdPuh4+WrpHzjPAcyW68mgXfzhF+MscR9//C2QSDZMzP1Rwyg1o3tG3GI43w4nd
         5ylz2qhrubr1VsNFMrztHhycOa77EJT/y0uHxlMI53FGDM3gXZqAhbWC1gDTStF5yhBq
         bmrb/22ZvQwC5KD2XIHC6/tQHOLc6bhiRDL28S4o2zasDOGMvQEEBfNJJb11MIpmstKT
         NLtH8cr/0B5bTp8myhvv1asuyV9x3Nblw2rrrkge5hfZgm+9zVRsT6RuyAjh642NFvfv
         io9A==
X-Gm-Message-State: AJIora+vf9pa+aYsT9kwBFxWw3CHn1ViG+RURit+6mjOJbfCAV/ZXqMu
        qoUZW2ujkF6wdxYKYkfFOhc=
X-Google-Smtp-Source: AGRyM1tAsn2PDyy/NeNvRssXC4C9Rsps0RWUAwnoXQuT17RaP29ONeu6BdhSznqTeig4ID39qMei/g==
X-Received: by 2002:a05:6808:1508:b0:33a:9da7:ea7a with SMTP id u8-20020a056808150800b0033a9da7ea7amr11659073oiw.72.1658683941660;
        Sun, 24 Jul 2022 10:32:21 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:cc3e:96c:f965:f0dd])
        by smtp.gmail.com with ESMTPSA id h4-20020a9d6f84000000b0061caee21a53sm4239685otq.54.2022.07.24.10.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 10:32:20 -0700 (PDT)
Date:   Sun, 24 Jul 2022 10:32:18 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: act_mirred: avoid printout in the
 traffic path
Message-ID: <Yt2CIl7iCoahCPoU@pop-os.localdomain>
References: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 06:19:22PM +0200, Davide Caratti wrote:
> @@ -251,16 +258,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>  	m_eaction = READ_ONCE(m->tcfm_eaction);
>  	retval = READ_ONCE(m->tcf_action);
>  	dev = rcu_dereference_bh(m->tcfm_dev);
> -	if (unlikely(!dev)) {
> -		pr_notice_once("tc mirred: target device is gone\n");
> +	if (unlikely(!dev || !(dev->flags & IFF_UP)))
>  		goto out;
> -	}
> -
> -	if (unlikely(!(dev->flags & IFF_UP))) {
> -		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
> -				       dev->name);
> -		goto out;
> -	}

I have no objection, just want to point it out users could still figure
out this drop by tracing kfree_skb(). _Maybe_ we could pass a reason to
kfree_skb_reason() too but it is definitely harder.

Thanks!
