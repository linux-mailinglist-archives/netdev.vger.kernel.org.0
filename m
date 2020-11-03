Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30DA2A4E2C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgKCSRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgKCSRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:17:02 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA6EC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 10:17:02 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so23721951ejb.7
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 10:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yM/fnA3BSatr1JIEs8SCgV9+oa5PifIAS9nwhN5Pb0k=;
        b=b/yNiYj56kayma2L+CgTQwulL+nOjQV1sNHlVfvhOysD9Suv6Y3hMG9vmsfr/85+Kv
         hzYVqEjUgKwzA2iphCxPNIQi/tWst7YgXVZ/V4Z/uMv5kEk01hJvf7LQXGJnJf6lVlsr
         OuOYSuD04/D93W2r4pQo55YRcpLGiyJ7ApnO8fm0GsVIIYtIitbe9Pg/4/3YGCnn658r
         3BrHuyLL+Ia0b0JPKnGEYUFsAKjxOjgDfhLczbR3/pUoMVzTsep9VcxYEWtDxS8Fdbt+
         054VhP58jlrxhf3huBIPMW1YVS9HvWre43dfYY4V7cJNAwp72U/HQUDSewejrO8xu2sh
         ACPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yM/fnA3BSatr1JIEs8SCgV9+oa5PifIAS9nwhN5Pb0k=;
        b=SZxvIgZalyqgwVJauSJ8GO6Jg8GY6NtZC/2S6cOV0PeEeHdCxVBLBQOfTn1ILzA5ze
         0aZowAPOoQdfJOKEwzc8nE9o33uFNDQs/sNPAhhbBCUlDzZN/zp2Q3eA0sDJfEdeucs/
         WK3Gbl75M6qvIvUJ7k42YDXLOYdIFtCzWU/rBqYYHMqiF9RHXdiNcSycJND6HKDMWhxS
         ELJchgEv2G/9i1ant3nSCs+BLgp4zersZ2gwL4LiEWyl1ZxuYZBR6Wj7lU39B6vXAZ+P
         uaPKYMY/n4szwGqeN7ZjlKT4/kpH3w/Bk6RavezJwEdgHhFpJwvpZVBC/1SDOC8zd12U
         +SVQ==
X-Gm-Message-State: AOAM530DoaFxypCJ7pLPBwLhsy1Xi17IbUDK1om5qJ7lOtAmxvTkgDpj
        CMzDM3FCY13ZGj4tuuyyQNU=
X-Google-Smtp-Source: ABdhPJwbzDD3pnuRvz8Crlp4VG6r9iEZ4cEjM72VOxzt3Eqb8qO7Po+dvP6wS++yo/6LdR4e2ojWMw==
X-Received: by 2002:a17:906:3689:: with SMTP id a9mr21238269ejc.403.1604427421122;
        Tue, 03 Nov 2020 10:17:01 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f13sm11217424ejf.42.2020.11.03.10.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 10:17:00 -0800 (PST)
Date:   Tue, 3 Nov 2020 20:16:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103181659.qigc7zmx7fiuoyp2@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103173007.23ttgm3rpmbletee@skbuf>
 <AM0PR04MB6754E51184163B357DAACDFB96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103174906.ttncbiqvlvfjibyl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103174906.ttncbiqvlvfjibyl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 07:49:06PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 03, 2020 at 05:41:36PM +0000, Claudiu Manoil wrote:
> > This is the patch:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=d145c9031325fed963a887851d9fa42516efd52b
> > 
> > are you sure you have it applied?
> 
> Actually? No, I didn't have it applied... I had thought that net had
> been already merged into net-next, for some reason :-/
> Let me run the test for a few more tens of minutes with the patch
> applied.

The test has been running for 30 minutes with the cherry-pick from net.
Sorry for the noise.
