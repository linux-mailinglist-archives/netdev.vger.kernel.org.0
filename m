Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC22B45D6
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgKPO2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgKPO2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:28:33 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA52FC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 06:28:32 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id u12so11687045wrt.0
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 06:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=singlestore.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JrKflSgSOMe93aJ6VW7ZfmXyv0vu7DMT8yvbPc0RDdc=;
        b=WQhmlf08AdBsMPPsXLBeb7z+Go8g1FnQhZyC6WpJ9GvtDYxj6pNpz+8sZnjNOFPcjC
         svBeMIXJu2PUqSCHpauT0JVXYcdN6AdutzM5rlMs+NqXKwRJwT/jvIc2gAqE4j4T2nWz
         db/WDtZxKHi1uHbuUtl+NyclDgoapLqql0VHdWh44iMzCe+lB+Q6AtVn0Lr6owbuxFVo
         mZpcjJQMWDzyYzgk4uvWBLohlYwYxEbdFnFVfnY5dCG6eUKimjIpmN2YHQv6cu9vaOvI
         IAHHPm7lGzbpSKifagADv3uii6Ipfcfgn/zrf0Tg8mGT+JzrQPodqj0yhnL5IQAviODU
         tABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JrKflSgSOMe93aJ6VW7ZfmXyv0vu7DMT8yvbPc0RDdc=;
        b=YE9mnFQIa6NmbRjirTK4anJOEVP6AcEoVJfsbkaTOfGNp6a3/e+IhyalLtM4eD2TJd
         LudPamsc8muH0mgd8WP/zm3ct2aD/jjxoS3XPenWFj5gVBWCujlh2Q33XzOmwKx9EbXo
         9dZP8GBzKevKzPf07mtcLx7hUr2obWeCJrdHek+sdheKQGZZ9l1jcSM6hj4B7JODU4TT
         LF6dac3u1SIjWAvCpY42+0eqBdmsDcF9kGiux8/iiPCBe4/jmfZYvwGoFooYNWpk2PNH
         vKNHrvO19XRDy7OUO6JJMtI7PJDxqI0sdhFAumsQOR/eknodEokoDJsqYVPrJXRnhvzd
         ubew==
X-Gm-Message-State: AOAM532JwdA3QuVyxwhz1jQ/p3X0QQAQGdAZLG/ZkWftj59bNhBz6Ki9
        flVLf4F/Nk/vV4Mi0xnRWUWeJw==
X-Google-Smtp-Source: ABdhPJynWW8LqCCuROcMY2njI5+Vv3gGgDlkIGQt8yivBkhzu55DbD+0wMXhhpnh7Y4Sai4HP9OgXQ==
X-Received: by 2002:a5d:66d2:: with SMTP id k18mr18829273wrw.327.1605536911509;
        Mon, 16 Nov 2020 06:28:31 -0800 (PST)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id j8sm19294687wrx.11.2020.11.16.06.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 06:28:30 -0800 (PST)
Date:   Mon, 16 Nov 2020 14:28:28 +0000
From:   Ricardo Dias <rdias@singlestore.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] tcp: fix race condition when creating child sockets
 from syncookies
Message-ID: <20201116142828.GA188138@rdias-suse-pc.lan>
References: <20201116120608.GA187477@rdias-suse-pc.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116120608.GA187477@rdias-suse-pc.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please to not consider this version for review. I'll send a new patch
version soon.


