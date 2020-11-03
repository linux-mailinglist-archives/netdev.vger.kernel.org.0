Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62F42A4D7A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgKCRtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgKCRtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:49:10 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF55C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:49:09 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id a10so2045093edt.12
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V42qrGNK8bW6VmirlyLhPtqTBkW10a/gFQKVHJaN6G0=;
        b=UwgfPq5kdLtSIAPmNyPKCIjYlGis4noAqqafR7I9RRFkeIRPksfSLYCWJHRCUKEgku
         zGPRsdImmlyOwCOQLui1g43nl9O6PSdAkGp9ZMSs9qD+m6bK91MnsIVXCaO3Ms4C9rfB
         Lbfm4JYZiFFo9sffQtGeS4oX0w9qUmhe8GOZIt8Sm0IPmRPyYZ4TF3zFgwBTyfieG0xt
         EjPI4LzVySsDnqR/DLC7B85tXO4FnVoz4NkIndMYMyF4+r6RlWibskXQZOVpltOSNQKp
         jXxZo+G7HK9ylSwr4Rl/uGSQw/Hla1Z+V/X3ZKbdRRA7Xuk2sDkcjPLNZDm2LUwKSkns
         nAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V42qrGNK8bW6VmirlyLhPtqTBkW10a/gFQKVHJaN6G0=;
        b=Dx5AwBJKhNqkpQMgZYqczsU4QK30B87JDqkhCt+lFFUz4vfImTo+do6KFIQ9xfb2pR
         d/nhy0Yg5Nospn8bUvf4WjDLraqLd3ktMWV8wkk4HqV1XuEdPViPcVW64T0CilFj3LAa
         tt5CWtOnLcj1yeOdbsZYQTBPU9hzuw2yQx3Ba+HKUZSc16hF3CztK6fs20jJfvHmzuSg
         FunZ+VRIXy/2ZSLs/mZygg877M7+kxDN+/ST11qnFam7gHPROyKjujZrxc0WrLunZCqo
         acZoFVKLuRUMLetf6VNzEhwIe/8Q7uKAdBC4gO8ZhgX7jg1f09Xq2Gl/AA+QDj0B3KDI
         sH3A==
X-Gm-Message-State: AOAM531zkne+bpC0CeB5sq5jIO2du0sBgwPXLi3vzJriyRwV2reJ6zKJ
        RfY1NsySUtsh5QDnbnOBVzk=
X-Google-Smtp-Source: ABdhPJxU8m+0KXIzoelIQhJ7AjaeBccLiwNbL8JsYYDhbqG+FDMqsyixfv5lBiALWjinGwjabnDX2A==
X-Received: by 2002:a05:6402:1750:: with SMTP id v16mr21289827edx.241.1604425748526;
        Tue, 03 Nov 2020 09:49:08 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id i14sm12205852edu.40.2020.11.03.09.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:49:08 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:49:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103174906.ttncbiqvlvfjibyl@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103173007.23ttgm3rpmbletee@skbuf>
 <AM0PR04MB6754E51184163B357DAACDFB96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6754E51184163B357DAACDFB96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 05:41:36PM +0000, Claudiu Manoil wrote:
> This is the patch:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=d145c9031325fed963a887851d9fa42516efd52b
> 
> are you sure you have it applied?

Actually? No, I didn't have it applied... I had thought that net had
been already merged into net-next, for some reason :-/
Let me run the test for a few more tens of minutes with the patch
applied.
