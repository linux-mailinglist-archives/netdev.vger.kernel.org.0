Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32982A4CC7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgKCRYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgKCRYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:44 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54545C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:44 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so25387153ejm.0
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dyXS/pgIDJBIIkfQq9A66S4gnFLSaXr+vsZuoZ3kDv8=;
        b=fmc/uyqFRb9RB73ZMzagsrY3UN+/vPVhFGN4c5xL5zYocIe+PX3rmOpQV0n1y7P/D9
         ISrDjj0bUAoa3O18IsXq62RzeB2bJK4t5FsPvy3rMQ7CppG3LURcJEKfYeC+womS00Jc
         TZNDI7TWNvID/NFxuz2Gj9MDkW2SdLl3sV4JgypyBi0jOziPESkWzFpF2mjFHnSg0SLE
         uJxCKJ14JlIYMxaLpjvsr8QH2OvIZYZd9g6oU5LSGOcf5hBo1Mdm19zNq3n+kX+z80qP
         A8p+24lsPheZHtBezQYe4w4cRBAFIYUHzSQixSoOZvoCm1seKHh1Dc4TF81qnYj04YLA
         T9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dyXS/pgIDJBIIkfQq9A66S4gnFLSaXr+vsZuoZ3kDv8=;
        b=CCaufqj1vfG0r8mZbkxryTteDKYmD8UOHNTgsFoJySsnVPquwgbp4EwJ+z7rW3o8GA
         qaV+uMhAD7betrer16defXES2Cn2qaJy8/dkSRiTs67M9kSIHvUIkU/mRaB1RE+7qUDu
         aLfchX2SE7YYi9Zsq0aeVGlTZ7yb0tcArSMhj5U31j1peZMxxVL6fN9JCUABpn3E6RbT
         X9XvBcVFC77kB8x+uf/l3bMdtm32pKc7PYkMdEEAXVK0JQJEp1pSzDa9J/opDYAEa7zH
         RtZn2d6RrmZZpyvtqI5x7QTPLpLzr0bEw3bkt8vYvmQ50cOfbZ5Kp369GQxWYUaEnq9Z
         HLdg==
X-Gm-Message-State: AOAM531eXv2pJSDIf+G5lk0ZZt+U7QpqxKnidCuH4+nZq48buCxzJ6q1
        AEe9/6r4vrLAW5h13YMOoYw=
X-Google-Smtp-Source: ABdhPJxEmeWoiZBlko0bG4bbjaq44qAoGCee9J/YkRpwVqZ7/vo84ulrVLTb9dZQyFH48Ntw3EoHgw==
X-Received: by 2002:a17:906:7e43:: with SMTP id z3mr22056877ejr.143.1604424283111;
        Tue, 03 Nov 2020 09:24:43 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k23sm11130927ejo.108.2020.11.03.09.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:42 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:24:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103172441.2xyyr3dkabtgfeao@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
 <AM0PR04MB67540916FABD7D801C9DF82496110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103091226.2d82c90c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103091226.2d82c90c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 09:12:26AM -0800, Jakub Kicinski wrote:
> While it is something to be fixed - is anything other than pktgen
> making use of IFF_TX_SKB_SHARING? Are you running pktgen, Vladimir?

Nope, just iperf3 TCP and PTP. The problem is actually with PTP, I've
been testing gianfar with just TCP for a long while.
